//
//  ModalAlertViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/16/16.
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

import UIKit
import Cornea

class ModalAlertViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  ModalAlertDelegate,
DeviceImageLoader {
  @IBOutlet weak var placeIcon: UIImageView!
  @IBOutlet weak var placeTitleLabel: ArcusLabel!
  @IBOutlet weak var placeAddressLabel: ArcusLabel!
  @IBOutlet weak var alertIconColorRing: ColorRingView!
  @IBOutlet weak var alertIcon: UIImageView!
  @IBOutlet weak var alertTable: UITableView!
  @IBOutlet weak var alertTableHeader: UIView!
  @IBOutlet weak var alertTableFooter: UIView!
  @IBOutlet weak var alertDescriptionLabel: ArcusLabel!
  @IBOutlet weak var primaryActionButton: ArcusButton!
  @IBOutlet weak var secondaryActionButton: ArcusButton!
  @IBOutlet weak var buttonContainerHeightConstraint: NSLayoutConstraint!

  var modalAlertPresenter: ModalAlertPresenter!

  fileprivate var appAlertStyle: UIBarStyle?
  fileprivate var appNavigationTintColor: UIColor?

  // MARK: View LifeCycle
  class func create(_ modalAlertPresenter: ModalAlertPresenter) -> ModalAlertViewController? {
    var modalAlertViewController: ModalAlertViewController?

    let storyboard: UIStoryboard = UIStoryboard(name: modalAlertPresenter.storyboardName(),
                                                bundle: nil)
    if let viewController = storyboard
      .instantiateViewController(withIdentifier: modalAlertPresenter
        .viewControllerIndentifier()) as? ModalAlertViewController {
      viewController.modalAlertPresenter = modalAlertPresenter
      viewController.modalAlertPresenter.delegate = viewController
      modalAlertViewController = viewController
    }
    return modalAlertViewController
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    configureLayout(modalAlertPresenter)
  }

  override func viewWillDisappear(_ animated: Bool) {

    UINavigationBar.appearance().barTintColor
      = NavigationBarAppearanceManager.sharedInstance.barTintColor

    super.viewWillDisappear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    updateHeaderLayout()
    updateFooterLayout()
  }

  // MARK: UI Configuration

  func configureLayout(_ modalAlertPresenter: ModalAlertPresenter) {
    configureNavigationBar(modalAlertPresenter)
    configurePlaceDetails(modalAlertPresenter)
    configureAlertIcon(modalAlertPresenter)
    configureAlertLabels(modalAlertPresenter)
    configureButtonLabels(modalAlertPresenter)
  }

  func configureNavigationBar(_ modalAlertPresenter: ModalAlertPresenter) {
    navBar(withTitle: modalAlertPresenter.navigationTitle(),
                    textColor: modalAlertPresenter.navigationTextColor())

    if let doneButtonTitle = modalAlertPresenter.doneButtonTitle() {
      navBar(withTitle: modalAlertPresenter.navigationTitle(),
                      andRightButtonText: doneButtonTitle,
                      textColor: modalAlertPresenter.navigationTextColor(),
                      with: #selector(doneButtonPressed(_:)),
                      selectorTarget: self)
    }

    appAlertStyle = navigationController?.navigationBar.barStyle
    appNavigationTintColor = navigationController?.navigationBar.barTintColor

    UINavigationBar.appearance().barStyle = .default
    UINavigationBar.appearance().barTintColor = modalAlertPresenter.navigationBarColor()

    setNeedsStatusBarAppearanceUpdate()
  }

  func configurePlaceDetails(_ modalAlertPresenter: ModalAlertPresenter) {
    let place: PlaceModel = modalAlertPresenter.place()
    if let name: String = PlaceCapability.getNameFrom(place) {
      placeTitleLabel.text = name
    }

    if let streetAddress: String = PlaceCapability.getStreetAddress1(from: place) {
      placeAddressLabel.text = streetAddress
    }
  }

  func configureAlertIcon(_ modalAlertPresenter: ModalAlertPresenter) {
    alertIcon.image = UIImage(named: modalAlertPresenter.iconName())
    alertIconColorRing.borderColor = modalAlertPresenter.navigationBarColor()
  }

  func configureAlertLabels(_ modalAlertPresenter: ModalAlertPresenter) {
    alertDescriptionLabel.text = modalAlertPresenter.description()
  }

  func configureButtonLabels(_ modalAlertPresenter: ModalAlertPresenter) {
    configurePrimaryButtonLabel(modalAlertPresenter)
    configureSecondaryButtonLabel(modalAlertPresenter)

    if primaryActionButton.isHidden == true || secondaryActionButton.isHidden == true {
      buttonContainerHeightConstraint.constant = 0
    } else {
      buttonContainerHeightConstraint.constant = 136
    }
  }

  func configurePrimaryButtonLabel(_ modalAlertPresenter: ModalAlertPresenter) {
    if let primaryActionTitle = modalAlertPresenter.primaryActionTitle() {
      primaryActionButton.setTitle(primaryActionTitle, for: UIControlState())
    } else {
      primaryActionButton.isHidden = true
    }
  }

  func configureSecondaryButtonLabel(_ modalAlertPresenter: ModalAlertPresenter) {
    if let secondaryActionTitle = modalAlertPresenter.secondaryActionTitle() {
      secondaryActionButton.setTitle(secondaryActionTitle, for: UIControlState())
    } else {
      secondaryActionButton.isHidden = true
    }
  }

  func updateHeaderLayout() {
    if let tableHeaderView = alertTable.tableHeaderView,
      alertTableHeader.frame.height != tableHeaderView.frame.height {

      var headerViewFrame = tableHeaderView.frame
      headerViewFrame.size.height = alertTableHeader.frame.size.height
      tableHeaderView.frame = headerViewFrame

      DispatchQueue.main.async {
        UIView.beginAnimations("tableHeaderView", context: nil)
        self.alertTable.tableHeaderView = self.alertTable.tableHeaderView
        UIView.commitAnimations()
      }
    }
  }

  func updateFooterLayout() {
    if let tableFooterView = alertTable.tableFooterView,
      alertTableFooter.frame.height != tableFooterView.frame.height {

      var footerViewFrame = tableFooterView.frame
      footerViewFrame.size.height = self.alertTableFooter.frame.size.height
      tableFooterView.frame = footerViewFrame

      DispatchQueue.main.async {
        UIView.beginAnimations("tableFooterView", context: nil)
        self.alertTable.tableFooterView = self.alertTable.tableFooterView
        UIView.commitAnimations()
      }
    }
  }

  // MARK: IBActions

  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    NotificationCenter.default
      .post(name: Notification.Name.dismissModalAlert, object: nil)
  }

  @IBAction func primaryActionPressed(_ sender: ArcusButton) {
    primaryAction(modalAlertPresenter)
  }

  @IBAction func secondaryActionPressed(_ sender: ArcusButton) {
    secondaryAction(modalAlertPresenter)
  }

  // MARK: Actions

  func primaryAction(_ modalAlertPresenter: ModalAlertPresenter) {
    modalAlertPresenter.primaryAction()
  }

  func secondaryAction(_ modalAlertPresenter: ModalAlertPresenter) {
    modalAlertPresenter.secondaryAction()
  }

  // MARK: UITableViewDataSource

  func numberOfSections(in tableView: UITableView) -> Int {
    return modalAlertPresenter.alertedDeviceInfo.count
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    var rows = 0
    if let devices = modalAlertPresenter.alertedDeviceInfo[section]["devices"] as? [DeviceModel] {
      rows = devices.count
    }
    return rows
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView,
                 estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 180
  }

  func tableView(_ tableView: UITableView,
                 heightForHeaderInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(_ tableView: UITableView,
                 estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 75
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: modalAlertPresenter.cellIdentifier())
      as? ArcusTitleDetailTableViewCell {
      if let devices = modalAlertPresenter
        .alertedDeviceInfo[indexPath.section]["devices"] as? [DeviceModel] {
        let device: DeviceModel = devices[indexPath.row]

        cell.titleLabel.text = device.name
        if cell.descriptionLabel != nil {
          let description: String? = modalAlertPresenter.descriptionTextForDevice(device)
          if description != nil {
            cell.descriptionLabel.text = description
          }
        }

        imageForDeviceModel(device, completionHandler: {
          (image: UIImage?, fromCache: Bool) in
          cell.accessoryImage.image = image
          if fromCache == true {
            cell.accessoryImage.clipsToBounds = true
            cell.accessoryImage.layer
              .cornerRadius = (cell.accessoryImage.bounds.size.width) / 2
          } else {
            cell.accessoryImage.layer.cornerRadius = 0
          }
        })
      }
      return cell
    }
    return UITableViewCell()
  }

  // MARK: UITableViewDelegate

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
      as? ArcusTitleDetailTableViewCell {
      if let alertTitle = modalAlertPresenter
        .alertedDeviceInfo[section]["alertTitle"] as? String {
        cell.titleLabel.text = alertTitle
      }
      return cell
    }
    return nil
  }

  // MARK: ModalAlertDelegate

  func updateLayout() {
    DispatchQueue.main.async(execute: {
      if self.isViewLoaded == true {
        self.configureLayout(self.modalAlertPresenter)
        if self.alertTable != nil {
          self.alertTable.reloadData()
        }
      }
    })
  }

  func executeSegue(_ identifier: String) {
    DispatchQueue.main.async(execute: {
      self.performSegue(withIdentifier: identifier, sender: self)
    })
  }

  // MARK: PrepareForSegue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if let alertInfoViewController = segue.destination as? ModalAlertInfoViewController {
      if let infoPresenter = modalAlertPresenter.modalAlertInfoPresenter() {
        alertInfoViewController.modalAlertInfoPresenter = infoPresenter
      }
    }
  }
}
