//
//  HubPairingNamingPresenter.swift
//  i2app
//
//  Created by Arcus Team on 4/13/18.
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
import RxSwiftExt
import SDWebImage

struct NameHubViewModel {

  //Default Name
  private static var defaultHubName = Constants.hubDeviceName

  var deviceName: String = NameHubViewModel.defaultHubName
  var deviceImage: UIImage?
  var deviceImagePlaceholder: UIImage?
}

protocol HubPairingNamingPresenter: ArcusHubCapability, ArcusPlaceCapability, ArcusPairingSubsystemCapability {

  /**
   The hub model the View, great injection point to stub out HubModelLogic,

   extended to be set as Cornea's currentHub
   */
  var hubModel: HubModel? { get }

  /**
   The size of the image to be used for the device
   */
  var deviceImageSize: CGSize { get }

  /**
   The scale of the image to be used for the device
   */
  var deviceImageScale: CGFloat { get }

  /**
   The data used to populate the views
   */
  var nameHubViewModel: NameHubViewModel { get set }

  /**
   Called when a change happens to the Device Model of the given address.
   */
  func nameHubDataUpdated()

  /**
   Delegate Callback type function, the saving functionality has completed and the user may continue
   when this is called
   */
  func shouldPresentNext()
  
  /**
   Delegate callback indicating that the user should transition to the success kit screen.
   */
  func shouldPresentSuccessKit()

  // MARK: Extended

  /**
   Fetches the data for the view
   */
  func nameHubPresenterFetchData()

  /**
   Saves the data from the view model
   */
  func nameHubPresenterSaveData()
}

extension HubPairingNamingPresenter {

  func nameHubPresenterFetchData() {
    guard let device = hubModel else {
      return
    }

    if let image = AKFileManager.default().cachedImage(forHash: device.modelId,
                                                       at: deviceImageSize,
                                                       withScale: deviceImageScale) {
      nameHubViewModel.deviceImage = image
      nameHubDataUpdated()
    }

    fetchDeviceProductImage { [weak self] (image) in
      if let image = image {
        self?.nameHubViewModel.deviceImagePlaceholder = image
        self?.nameHubDataUpdated()
      }
    }

    if let name = getHubName(device) {
      nameHubViewModel.deviceName = name
    }

    nameHubDataUpdated()
  }

  func nameHubPresenterSaveData() {
    nameHubPresenterSaveDeviceName()
    nameHubPresenterSaveImage()
  }

  private func fetchDeviceProductImage(completion: @escaping (UIImage?) -> Void) {

    let productV2Id = "dee000"
    let productV3Id = "dee001"
    var productId = productV2Id

    /// Check for V3 Hub
    if let hubModel = self.hubModel,
      let model = self.getHubModel(hubModel),
      model == "IH300" {
      productId = productV3Id
    }

    guard let urlString = ImagePaths.getProductImage(fromProductId: productId,
                                                     isLarge: true),
      let imageManager = SDWebImageManager.shared() else {
        completion(nil)
        return
    }

    let url = URL(string: urlString)

    if imageManager.cachedImageExists(for: url) {
      let key = imageManager.cacheKey(for: url)

      if let image = SDImageCache.shared().imageFromDiskCache(forKey: key).invertColor() {
        completion(image)
      } else {
        completion(nil)
      }
    } else {
      imageManager.downloadImage(with: url,
                                 options: .retryFailed,
                                 progress: { (_, _) in },
                                 completed: { (image, _, _, _, _) in
                                  if let image = image?.invertColor() {
                                    completion(image)
                                  } else {
                                    completion(nil)
                                  }

      })
    }
  }

    private func nameHubPresenterSaveDeviceName() {
        guard let hubModel = self.hubModel else { return }
        setHubName(nameHubViewModel.deviceName, model: hubModel)
        hubModel.commitChanges()
            .observeOn(MainScheduler.asyncInstance)
            .timeout(30.0, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] _ in
                self?.fetchKitDevices()
                }, onError: { [weak self] _ in
                    self?.fetchKitDevices()
            })
            .disposed(by: disposeBag)
    }
    


  private func nameHubPresenterSaveImage() {
    guard let model = hubModel,
      let image = nameHubViewModel.deviceImage else {
        return
    }

    AKFileManager.default().cacheImage(image, forHash: model.modelId)
  }
  
  private func fetchKitDevices() {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      shouldPresentNext()
      return
    }
    
    do {
      try requestPairingSubsystemGetKitInformation(pairingSubsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? PairingSubsystemGetKitInformationResponse,
            let kitInfo = response.getKitInfo() as? [[String: AnyObject]],
            kitInfo.count > 0 {
            self?.shouldPresentSuccessKit()
          } else {
            self?.shouldPresentNext()
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - error loading kit devices.")
      shouldPresentNext()
    }
  }

  private func fetchHubImage(completion: @escaping (UIImage?) -> Void) {
    guard let hubModel = hubModel else {
      return
    }
    if let image = AKFileManager.default().cachedImage(forHash: hubModel.modelId,
                                                       at: deviceImageSize,
                                                       withScale: deviceImageScale) {
      completion(image)
    } else {
      fetchDeviceProductImage(completion: completion)
    }
  }

  var hubModel: HubModel? {
    if let settings = RxCornea.shared.settings,
      let model = settings.currentHub {
      return model
    }
    return nil
  }
  
  private func pairingSubsystemModel() -> SubsystemModel? {
    let namespace = Constants.pairingSubsystemNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [SubsystemModel] else {
      return nil
    }
    
    return models.first
  }
}
