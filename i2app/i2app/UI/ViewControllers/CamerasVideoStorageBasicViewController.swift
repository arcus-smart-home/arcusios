//
//  CamerasVideoStorageBasicViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/4/18.
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

class CamerasVideoStorageBasicViewController: UIViewController {
  var presenter: CameraVideoStoragePresenter?
  var popupWindow: PopupSelectionWindow?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter = CameraStoragePresenter(delegate: self)
    configureUI()
  }
  
  func configureUI() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    setBackgroundColorToLastNavigateColor()
    addDarkOverlay(BackgroupOverlayLightLevel)
  }
  
  // MARK: Popup Handling
  
  func deleteAllConfirmPopup() {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }
    
    let popupStyle = PopupWindowStyleCautionWindow
    
    let yesButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("Yes, Delete All Clips", comment: ""),
                                       event: #selector(performDelete(_:)))
    let noButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("Cancel", comment: ""),
                                       event: #selector(closePopup(_:)))
    
    let buttonView: PopupSelectionButtonsView =
      PopupSelectionButtonsView.create(withTitle: "Are You Sure",
                                       subtitle: "Delete All will delete all clips",
                                       buttons: [yesButton, noButton])
    buttonView.owner = self
    
    popupWindow = PopupSelectionWindow.popup(view,
                                             subview: buttonView,
                                             owner: self,
                                             displyCloseButton: false,
                                             close: #selector(closePopup(_:)),
                                             style: popupStyle)
    
  }
  
  
  func performDelete(_ sender: AnyObject) {
    presenter?.deleteAll()
  }
  
  func closePopup(_ sender: AnyObject!) {}
  
  @IBAction func performDeleteTapped() {
    presenter?.confirmDelete()
  }
}

extension CamerasVideoStorageBasicViewController: CameraVideoStoragePresenterDelegate {
  func showConfirmCleanPopup() {
    // N/A
  }
  
  func showConfirmDeletePopup() {
    self.deleteAllConfirmPopup()
  }}
