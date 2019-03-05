//
//  FactoryResetViewController.swift
//  i2app
//
//  Arcus Team on 4/19/18.
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

public class FactoryResetViewController: FactoryResetBaseViewController {

  let presenter = FactoryResetPresenter()
  var steps: [FactoryResetStepModel] = []
  public var disposeBag = DisposeBag()

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var stepsTable: UITableView!
  @IBOutlet weak var tableHeight: NSLayoutConstraint!
  let tableViewContentSizeKey = "contentSize"
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    self.stepsTable.dataSource = self
    self.titleLabel.text = "To reset \(getProductDisplayName()), follow the steps below:"
    
    self.presenter.delegate = self
    self.presenter.factoryReset()
    
    stepsTable.addObserver(self,
                           forKeyPath: tableViewContentSizeKey,
                           options: .new,
                           context: nil)
  }
  
  deinit {
    stepsTable.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      tableHeight.constant = stepsTable.contentSize.height
    }
  }
}

extension FactoryResetViewController: ArcusProductCapability {

  func getProductDisplayName() -> String {
    if let productAddress = FactoryResetBaseViewController.productAddress,
       let productModel = RxCornea.shared.modelCache?.fetchModel(productAddress) as? ProductModel,
       let vendorName = getProductVendor(productModel),
       let productName = getProductName(productModel) {
      
      return "the \(vendorName) \(productName)"
    } else {
      return "the device"
    }
  }
}

extension FactoryResetViewController: UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return steps.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FactoryResetStepCell")
      as? FactoryResetStepCell {
      cell.stepNumber.image = steps[indexPath.row].numberImage()
      cell.stepText.text = steps[indexPath.row].stepText
      
      return cell
    }
    
    return UITableViewCell()
  }
  
}

extension FactoryResetViewController: FactoryResetDelegate {

  func onDisplayResetSteps(_ steps: [FactoryResetStepModel]) {
    self.steps = steps
    self.stepsTable.reloadData()
  }
  
  func onFactoryResetError(_ reason: String) {
    DDLogError(reason)
    self.displayGenericErrorMessage()
  }
}
