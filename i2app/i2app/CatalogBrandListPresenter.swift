//
//  CatalogBrandListPresenter.swift
//  i2app
//
//  Created by Arcus Team on 1/29/18.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

import Foundation
import Cornea
import RxSwift

/**
 Interface for an object that has a cache of available Brands and Products
 */
protocol CatalogDeviceListCache: class {
  /**
   Object representing the data needed by the view controller.
   */
  var viewModel: BrandSectionViewModel { get }
}


/**
 Interface needed for presenters to be used in the Catalog Brand List.
 */
protocol CatalogBrandListPresenterProtocol: CatalogDeviceListCache {

  /**
   Checks if the view should present the device pairing warning.
   */
  func checkPairingWarning()
  
}

/**
 Delegate used to receive update callbacks from a Catalog Brand List Presenter.
 */
protocol CatalogBrandListPresenterDelegate: class {
  
  /**
   Called when the pairing warning screen should be presented.
   */
  func shouldPresentPairingWarning()

  /**
   Method called when there is new brand data available.
   */
  func availableBrandsDidUpdate()

}

/**
 Presenter used to provide the brand data available from the product catalog.
 */
class CatalogBrandListPresenter: ArcusProductCatalogService, ArcusPairingSubsystemCapability,
ArcusPairingDeviceCapability, StaticResourceImageURLHelper, KitSetupHelper {
  
  /**
   Required by ArcusProductCatalogService
   */
  let disposeBag = DisposeBag()
  
  /**
   Required by CatalogBrandListPresenterProtocol
   */
  weak private(set) var delegate: CatalogBrandListPresenterDelegate?

  /**
   A provider to get the current Pairing Subsystem, which changes do to App lifecycle changes
   */
  var pairingSubsystemProvider: PairingSubsystemModelProvider<SubsystemModel>

  /// Current place used by request to the platform
  var currentPlace: String

  /// required object
  var modelCache: (ArcusModelCache & RxSwiftModelCache)

  /// ordered list of products calculated once requested
  var viewModel: BrandSectionViewModel {
    didSet {
      DispatchQueue.main.async { [unowned self] _ in
        self.delegate?.availableBrandsDidUpdate()
      }
    }
  }

  required init(pairingSubsystemModelProvider: PairingSubsystemModelProvider<SubsystemModel>,
                 modelCache: (ArcusModelCache & RxSwiftModelCache),
                 currentPlace: String) {

    self.modelCache = modelCache
    pairingSubsystemProvider = pairingSubsystemModelProvider
    self.currentPlace = currentPlace
    self.viewModel = BrandSectionViewModel(allBrands: [],
                                           hubRequiredBrands: [],
                                           noHubRequiredBrands: [])
  }

  /// Optional initalizer, fails with nil if prerequisites are not prepared
  convenience init?(delegate: CatalogBrandListPresenterDelegate,
                    pairingSubsystemModelProvider: PairingSubsystemModelProvider<SubsystemModel>,
                    modelCache: (ArcusModelCache & RxSwiftModelCache),
                    currentPlace: String) {

    self.init(pairingSubsystemModelProvider: pairingSubsystemModelProvider,
              modelCache: modelCache,
              currentPlace: currentPlace)

    pairingSubsystemModelProvider.cacheLoadedObservable
      .asObserver()
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .subscribe(onNext: { [unowned self, unowned modelCache] _ in
        self.viewModel = self.createGroupedProducts(modelCache)
      })
      .disposed(by: disposeBag)
    self.delegate = delegate
  }

  /// Function private to the initalizer that handles the creation of the view model
  private func createGroupedProducts(_ modelCache: (ArcusModelCache & RxSwiftModelCache)) -> BrandSectionViewModel {

    guard let ms = modelCache.fetchModels(Constants.productNamespace) as? [ProductModel] else {
      DDLogError("Application has entered device pairing in an illegal state")
      return BrandSectionViewModel(allBrands: [],
                                   hubRequiredBrands: [],
                                   noHubRequiredBrands: [])
    }

    let allBrands: [CatalogBrandViewModel] = ms
      .filter{ return $0.canBrowse() }
      .reduce(into: [String: CatalogBrandViewModel]()){ (all, product) in
        guard let vendorName = product.vendorName() else { return }
        let productVM = CatalogDeviceViewModel(product: product)
        var brand: CatalogBrandViewModel = all[vendorName] ?? CatalogBrandViewModel()
        if brand.name != vendorName { // is a new VM
          brand.name = vendorName
        }
        brand.productList.append(productVM)
        all[vendorName] = brand
      }
      .map { return $0.value }

    let hubRequiredBrands: [CatalogBrandViewModel] = allBrands.map { brand -> CatalogBrandViewModel in
      let hubRequiredProducts = brand.productList.filter({return $0.hubRequired})
      var newBrand = brand
      newBrand.productList = hubRequiredProducts
      return newBrand
    }

    let noHubRequiredBrands: [CatalogBrandViewModel] = allBrands.map { brand -> CatalogBrandViewModel in
      let noHubRequiredProducts = brand.productList.filter({return !$0.hubRequired})
      var newBrand = brand
      newBrand.productList = noHubRequiredProducts
      return newBrand
    }

    return BrandSectionViewModel(allBrands: allBrands,
                                 hubRequiredBrands: hubRequiredBrands,
                                 noHubRequiredBrands: noHubRequiredBrands)
  }
}

// MARK: CatalogBrandListPresenterProtocol

extension CatalogBrandListPresenter: CatalogBrandListPresenterProtocol {

  func checkPairingWarning() {
    checkForPairDevices()
  }
  
  private func checkForPairDevices() {
    guard let ps = try? pairingSubsystemProvider.modelObservable.value(),
      let pairingSubsystem = ps else {
      return
    }
    
    try! requestPairingSubsystemListPairingDevices(pairingSubsystem)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] response in
        if let response = response as? PairingSubsystemListPairingDevicesResponse {
          self?.process(listPairingResponse: response)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func process(listPairingResponse response:PairingSubsystemListPairingDevicesResponse) {
    guard let devices = response.getDevices() as? [[String: AnyObject]] else {
      return
    }
    
    let pairingDevices = devices.map { (device) -> PairingDeviceModel in
      PairingDeviceModel(attributes: device)
    }
    
    for pairingDevice in pairingDevices {
      if let state = getPairingDevicePairingState(pairingDevice) {
        if state == .misconfigured || state == .mispaired {
          delegate?.shouldPresentPairingWarning()
          return
        }
      }
    }
    
    checkForKitDevices(pairingDevices: pairingDevices)
  }
  
  private func checkForKitDevices(pairingDevices: [PairingDeviceModel]) {
    guard let ps = try? pairingSubsystemProvider.modelObservable.value(),
      let pairingSubsystem = ps else {
        return
    }
    
    try! requestPairingSubsystemGetKitInformation(pairingSubsystem)
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] response in
        if let response = response as? PairingSubsystemGetKitInformationResponse {
          self?.process(kitInformation: response, pairingDevices: pairingDevices)
        }
      })
      .disposed(by: disposeBag)

  }
  
  private func process(kitInformation response: PairingSubsystemGetKitInformationResponse,
                       pairingDevices: [PairingDeviceModel]) {
    guard let kitInformation = response.getKitInfo() as? [[String: AnyObject]] else {
      return
    }
    
    for kitInfoData in kitInformation {
      let protocolAddress = kitInfoData["protocolAddress"] as? String ?? ""
      let kitDeviceState = deviceState(pairingDevices: pairingDevices, protocolAddress: protocolAddress)
      
      if kitDeviceState == .inactive {
        delegate?.shouldPresentPairingWarning()
        return
      }
    }
  }
  
}
