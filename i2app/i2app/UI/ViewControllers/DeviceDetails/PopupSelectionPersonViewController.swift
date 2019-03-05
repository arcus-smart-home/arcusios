//
//  PopupSelectionPersonViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/12/17.
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
import CocoaLumberjack

@objc protocol PopupSelectionPersonViewControllerDelegate: class {
  func unassigned()
  func completeSelection(_ value: PersonModel)
}

class PopupSelectionPersonViewController: UIViewController, SelectionPersonPresenterDelegate {

  weak var delegate: PopupSelectionPersonViewControllerDelegate!
  var presenter: SelectionPersonPresenterProtocol!
  weak var deviceModel: DeviceModel!
  fileprivate var selectedPersonID: String?

  @IBOutlet weak var tableView: UITableView!

  /// Required Factory for creation and initialization of PopupSelectionPersonViewController
  /// will correctly set the explictly unwrapped delegate parameter
  static func create(withDelegate: PopupSelectionPersonViewControllerDelegate,
                     deviceModel: DeviceModel,
                     selectedPersonModel: PersonModel?) -> UINavigationController {
    guard let nav = UIStoryboard(name: String(describing: self), bundle: nil)
      .instantiateInitialViewController() as? UINavigationController,
      let vc = nav.viewControllers.first as? PopupSelectionPersonViewController,
      let currentPlace = RxCornea.shared.settings?.currentPlace else {
        DDLogWarn("Fatal Error loading PopupSelectionPersonViewController, app will crash")
        return UINavigationController()
    }
    vc.delegate = withDelegate
    vc.deviceModel = deviceModel
    vc.presenter = SelectionPersonPresenter(delegate: vc, place: currentPlace)
    if let modelID = selectedPersonModel?.modelId as String? {
      vc.selectedPersonID = modelID
    }
    return nav
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavBarTitle(NSLocalizedString("ASSIGN TO", comment: ""))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter.fetchPersons()
  }

  func updateLayout() {
    tableView.reloadData()
  }

  @IBAction func donePressed() {
    if let selectedPersonID = selectedPersonID,
      let selectedPerson = presenter.persons?.filter({ person -> Bool in
        return person.modelId.isEqual(selectedPersonID)
      }).first {
      delegate.completeSelection(selectedPerson)
    } else {
      delegate.unassigned()
    }
  }
}

extension PopupSelectionPersonViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      selectedPersonID = nil
    } else if let persons = presenter.persons,
      indexPath.row <= persons.count,
      let person = persons[safe: indexPath.row - 1] {
      selectedPersonID = person.modelId as String
    }
    tableView.reloadData()
  }
}

extension PopupSelectionPersonViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SelectionPersonViewCell
    guard let persons = presenter.persons else {
      DDLogWarn("Fatal Error in SelectionPersonPresenter")
      return cell
    }
    if indexPath.row == 0 {
      let isChecked = selectedPersonID == nil
      bind(cell: cell, toDevice: deviceModel, checked: isChecked)
    } else if let person = persons[safe: indexPath.row - 1] {
      let modelId = person.modelId
      let isChecked = ((selectedPersonID != nil) && modelId as String == selectedPersonID!)
      bind(cell: cell, toPerson: person, checked: isChecked)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let persons = presenter.persons else {
      return 0
    }
    return persons.count + 1
  }

  func bind(cell: SelectionPersonViewCell, toPerson: PersonModel, checked: Bool) {
    cell.personNameLabel.text = toPerson.fullName
    if let cellImage = toPerson.image {
      cell.deviceImage.image = cellImage
        .exactZoomScaleAndCutSize(inCenter: CGSize(width: 45, height: 45))
        .roundCornerImageWithsize(CGSize(width: 45, height: 45))
    } else {
      let userDefaultImage = UIImage(named: "userIcon")?.invertColor()
      cell.deviceImage.image = userDefaultImage
    }

    if checked {
      cell.checkIcon.image = UIImage(named: "CheckMark")
    } else {
      cell.checkIcon.image = UIImage(named: "CheckmarkEmptyIcon")
    }
  }

  func bind(cell: SelectionPersonViewCell, toDevice: DeviceModel, checked: Bool) {
    cell.personNameLabel.text = toDevice.name
    let productId = DeviceCapability.getProductId(from: toDevice)
    let hint = toDevice.devTypeHintToImageName()
    _ = ImageDownloader.downloadDeviceImage(productId,
                                            withDevTypeId: hint,
                                            withPlaceHolder: nil,
                                            isLarge: false,
                                            isBlackStyle: false)
      .swiftThen { res in
        guard let img = res as? UIImage else {
          return nil
        }
        cell.deviceImage.image = img.invertColor()
        return nil
    }

    if checked {
      cell.checkIcon.image = UIImage(named: "CheckMark")
    } else {
      cell.checkIcon.image = UIImage(named: "CheckmarkEmptyIcon")
    }
  }
}
