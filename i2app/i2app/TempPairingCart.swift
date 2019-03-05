//
//  TempPairingCart.swift
//  i2app
//
//  Created by Arcus Team on 2/15/18.
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

// TODO: Remove this file when the pairing view has been implemented.

class TempPairingCartViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var presenter: TempPairingCartPresenterProtocol?
  
  var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.tableFooterView = UIView()
    
    presenter = TempPairingCartPresenter(delegate: self)
    presenter?.fetchPairingCartItems()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
      self.presenter?.fetchPairingCartItems()
    })
  }
  
  @IBAction func closeButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension TempPairingCartViewController: TempPairingCartPresenterDelegate {
  
  func pairingCartItemsDidChange() {
    tableView.reloadData()
  }
  
}

extension TempPairingCartViewController: PairingCustomizationPresenter {

}

extension TempPairingCartViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presenter = presenter,
      indexPath.row < presenter.cartDevices.count else {
      return
    }
    
    let selectedViewModel = presenter.cartDevices[indexPath.row]
    
    // Retrieve the customization steps given the device address of the selected entry
    pairingCustomizationPresenterFetchSteps(deviceAddress: selectedViewModel.deviceAddress) { (viewModel) in
      // Ensure that all the data needed to present the steps is present
      guard let viewModel = viewModel,
      let firstStep = viewModel.steps.first,
      let stepType = firstStep.stepType,
      let viewController =
        PairingCustomizationViewControllerFactory.viewController(forStepType: stepType) else {
        return
      }
      
      // Configure the data for the first step
      viewController.deviceAddress = selectedViewModel.deviceAddress
      viewController.stepIndex = 0
      viewController.pairingCustomizationViewModel = viewModel
      
      // Create a navigation controller for the customization workflow and present it modally
      let navigation = UINavigationController(rootViewController: viewController)
      self.present(navigation, animated: true, completion: nil)
    }
  }
  
}

extension TempPairingCartViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.cartDevices.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let presenter = presenter,
      presenter.cartDevices.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "PairingCartItemCell")
        as? PairingCartItemCell else {
          
          return UITableViewCell()
    }
    
    let viewModel = presenter.cartDevices[indexPath.row]
    cell.title.text = viewModel.name
    cell.title.textColor = viewModel.isCustomized ? ScleraColor.success : UIColor.black
    cell.state.text = viewModel.state
    cell.state.textColor = viewModel.isCustomized ? ScleraColor.success : UIColor.black
    
    return cell
  }
  
}

struct PairingCartDeviceViewModel {
  var name = ""
  var productAddress = ""
  var deviceAddress = ""
  var state = ""
  var isCustomized = false
}

class PairingCartItemCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  
  @IBOutlet weak var state: UILabel!
  
}

protocol TempPairingCartPresenterProtocol {
  
  var cartDevices: [PairingCartDeviceViewModel] { get }
  
  var delegate: TempPairingCartPresenterDelegate? { get }
  
  func fetchPairingCartItems()
  
}

protocol TempPairingCartPresenterDelegate: class {
  
  func pairingCartItemsDidChange()
  
}

class TempPairingCartPresenter {
  
  var disposeBag = DisposeBag()
  
  fileprivate(set) var cartDevices = [PairingCartDeviceViewModel]()
  
  weak private(set) var delegate: TempPairingCartPresenterDelegate?
  fileprivate var products = [ProductModel]()
  
  init(delegate: TempPairingCartPresenterDelegate) {
    self.delegate = delegate
  }
  
  fileprivate func getDeviceName(forDeviceAddress address: String) -> String {
    for product in products where product.address == address {
      return product.productName() ?? ""
    }
    
    return ""
  }
  
}

extension TempPairingCartPresenter: TempPairingCartPresenterProtocol {
  
  func fetchPairingCartItems() {
    guard let cache = RxCornea.shared.modelCache,
    let products = cache.fetchModels(Constants.productNamespace) as? [ProductModel],
    let pairingDevices = cache.fetchModels(Constants.pairingDeviceNamespace) as? [PairingDeviceModel]else {
      return
    }
    
    self.products = products
    
    cartDevices = pairingDevices.map {
      let model = $0
      let state = self.getPairingDevicePairingState(model) ?? PairingDevicePairingState.pairing
      var device = PairingCartDeviceViewModel()
  
      device.productAddress = self.getPairingDeviceProductAddress(model) ?? ""
      device.deviceAddress = self.getPairingDeviceDeviceAddress(model) ?? ""
      device.state = state.rawValue
      device.name = self.getDeviceName(forDeviceAddress: device.productAddress)
      
      if let customizations = self.getPairingDeviceCustomizations(model) {
        let complete = PairingCustomizationStepType.complete.rawValue
        for customization in customizations where customization == complete {
          device.isCustomized = true
        }
      }
      
      return device
    }
    
    self.delegate?.pairingCartItemsDidChange()
  }
  
}

extension TempPairingCartPresenter: ArcusProductCatalogService {
  
}

extension TempPairingCartPresenter: ArcusPairingDeviceCapability {
  
}

extension TempPairingCartPresenter: ArcusPairingSubsystemCapability {

}
