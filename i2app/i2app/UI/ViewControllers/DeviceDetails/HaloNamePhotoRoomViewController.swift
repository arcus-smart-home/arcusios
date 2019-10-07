//
//  HaloNamePhotoRoomViewController.swift
//  i2app
//
//  Created by Arcus Team on 10/27/16.
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

extension Notification.Name {
  static let deviceBackupUpdate = Notification.Name("DeviceBackgroupUpdate")
}

class HaloNamePhotoRoomViewController: UIViewController {

  @IBOutlet weak var logoButton: UIButton!
  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var cleanNameButton: UIButton!
  @IBOutlet weak var editNameField: AccountTextField!
  @IBOutlet weak var roomNameLabel: ArcusLabel!
  @IBOutlet weak var saveButton: ArcusButton!

  var selectedImage: UIImage!
  var popupWindow: PopupSelectionWindow!
  var deviceModel: DeviceModel!
  var roomsDictionary: OrderedDictionary = [:]

  @objc class func createWithDeviceModel(_ device: DeviceModel) -> HaloNamePhotoRoomViewController {
    let vc: HaloNamePhotoRoomViewController = (UIStoryboard(name: "DeviceDetailSettingHalo", bundle: nil)
      .instantiateViewController(withIdentifier: "HaloNamePhotoRoomViewController")
      as? HaloNamePhotoRoomViewController)!

    vc.deviceModel = device

    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToLastNavigateColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)

    if self.deviceModel != nil {
      self.navBar(withBackButtonAndTitle: self.deviceModel.name)
      self.editNameField.text = self.deviceModel.name

      let image: UIImage? =
        (AKFileManager.default() as AnyObject)
          .cachedImage(forHash: self.deviceModel.modelId as String!,
                       at: UIScreen.main.bounds.size,
                       withScale: UIScreen.main.scale)
      if image != nil {
        if self.view.renderLogoAndBackground(with: image,
                                             forLogoControl: self.logoButton) == false {
          self.selectedImage = nil
        } else {
          self.selectedImage = image
        }
      } else {
        if let productId = DeviceCapability.getProductId(from: self.deviceModel) {
          let urlString: String = ImagePaths.getLargeProductImage(fromProductId: productId)
          if urlString.count > 0 {
            _ = ImageDownloader.downloadDeviceImage(urlString,
                                                    withDevTypeId:self.deviceModel.devTypeHintToImageName(),
                                                    withPlaceHolder:nil, isLarge:
              true, isBlackStyle:false)
              .swiftThen({ image in
                self.selectedImage = image as? UIImage

                self.logoButton.setImage(self.selectedImage, for: UIControlState())
                return nil
              })
          }
        }
      }

      self.initializeRooms()
    }
    self.editNameField.textColor = UIColor.white
    self.editNameField.floatingLabelTextColor = UIColor.white.withAlphaComponent(0.6)
    self.editNameField.floatingLabelActiveTextColor = UIColor.white
    self.editNameField.activeSeparatorColor = UIColor.white.withAlphaComponent(0.0)
    self.editNameField.separatorColor = UIColor.white.withAlphaComponent(0.0)
    self.editNameField.delegate = self
    self.editNameField.inputAccessoryView = self.keyboardToolbar(#selector(keyboardDoneTapped))
    self.editNameField.keyboardAppearance = .dark
    self.editNameField.autocorrectionType = .no
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector:#selector(keyboardFrameWillChange),
                                           name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                           object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self,
                                              name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                              object: nil)
  }

  fileprivate func initializeRooms() {
    // Get all the rooms
    let rooms: Dictionary = HaloCapability.getRoomNames(from: self.deviceModel)
    let mutableDict: NSMutableDictionary = NSMutableDictionary()
    for roomKey in rooms.keys {
      mutableDict.setValue((roomKey as? String)!,
                           forKey: (rooms[roomKey] as? String)!.uppercased())
    }
    roomsDictionary = OrderedDictionary(dictionary: mutableDict)
    roomsDictionary.sortArray()

    self.roomNameLabel.text = HaloCapability.getRoomFrom(self.deviceModel)
    if let index = roomsDictionary.allValues.index(where: {$0 as? String == self.roomNameLabel.text}) {
      self.roomNameLabel.text = self.roomsDictionary.allKeys[index] as? String
    }
  }

  @IBAction func onClickImageButton(_ sender: AnyObject) {
    ImagePicker.sharedInstance()
      .present(self,
               withImageId: "ID",
               withCompletionBlock: { (image: UIImage?) -> Void in
                self.selectedImage = image
                self.selectedImage = image
                if self.selectedImage != nil {
                  (AKFileManager.default()!)
                    .cacheImage(self.selectedImage,
                                forHash: self.deviceModel.modelId as String!)
                  let name = Notification.Name.deviceBackupUpdate
                  NotificationCenter.default
                    .post(name: name,
                          object: self.deviceModel)

                  self.view.renderLogoAndBackground(with: self.selectedImage,
                                                    forLogoControl: self.logoButton)
                }
      })
  }

  @IBAction func clickCleanButton(_ sender: AnyObject) {
    editNameField.text = ""
  }
  @IBAction func onClickBackground(_ sender: AnyObject) {
    self.editNameField.resignFirstResponder()
  }

  @IBAction func roomButtonPressed(_ sender: AnyObject) {
    self.editNameField.resignFirstResponder()

    let popupSelection =
      PopupSelectionTextPickerView.create(NSLocalizedString("ROOMS", comment: ""),
                                          list: roomsDictionary)
    popupSelection?.setCurrentKey(self.roomNameLabel.text)
    self.popupWindow =
      PopupSelectionWindow.popup(self.view,
                                 subview: popupSelection,
                                 owner: self,
                                 close: #selector(doCloseRoomPicker(_:)))
  }
  func doCloseRoomPicker(_ state: String) {
    if let index = roomsDictionary.allValues.index(where: {$0 as? String == state}) {
      self.roomNameLabel.text = self.roomsDictionary.allKeys[index] as? String
    }
  }

  @IBAction func saveButtonPressed(_ sender: AnyObject) {
    self.createGif()
    DispatchQueue.global(qos: .background).async {
      if self.roomsDictionary[self.roomNameLabel.text!] as? String !=
        HaloCapability.getRoomFrom(self.deviceModel) {
        if let index = self.roomsDictionary.allKeys
          .index(where: {$0 as? String == self.roomNameLabel.text}) {
          HaloCapability.setRoom(self.roomsDictionary.allValues[index] as? String,
                                 on: self.deviceModel)
          _ = self.deviceModel.commit().swiftThen { _ in
            if self.editNameField.text != self.deviceModel.name {
              DevicePairingManager.sharedInstance()
                .renameDevice(self.editNameField.text,
                              for: self.deviceModel,
                              complete: {
                                self.hideGif()
                                self.navigationController?.popViewController(animated: true)
                })
            } else {
              self.hideGif()
              self.navigationController?.popViewController(animated: true)
            }
            return nil
          }
        }
      } else if self.editNameField.text != self.deviceModel.name {
        DevicePairingManager.sharedInstance()
          .renameDevice(self.editNameField.text,
                        for: self.deviceModel, complete: {
                          self.hideGif()
                          self.navigationController?.popViewController(animated: true)
          })
      } else {
        DispatchQueue.main.async {
          self.hideGif()
        }
      }

    }
  }

  @objc func keyboardFrameWillChange(_ note: Notification) {
    //this animation will move the entire view up by the height of the keyboard
    guard let info = note.userInfo,
      let keyboardEndFrame = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let keyboardBeginFrame = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
      let animationCurveValue = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
      let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
        return
    }
    let animationCurve = UIViewAnimationCurve(rawValue: animationCurveValue)!
    var newFrame = self.view.frame
    let keyboardFrameEnd = self.view.convert(keyboardEndFrame, to: nil)
    let keyboardFrameBegin = self.view.convert(keyboardBeginFrame, to: nil)
    newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y)

    UIView.beginAnimations(nil, context: nil)
    UIView.setAnimationDuration(animationDuration)
    UIView.setAnimationCurve(animationCurve)
    self.view.frame = newFrame
    UIView.commitAnimations()
  }

  // MARK: Keyboard Toolbar Selectors
  func keyboardDoneTapped() {
    view.endEditing(true)
  }

  @IBAction func didEndEditing(_ sender: AnyObject) {
    view.endEditing(true)
  }
}

extension HaloNamePhotoRoomViewController: UITextFieldDelegate {

  func textFieldDidBeginEditing(_ textField: UITextField) {
    saveButton.isEnabled = false
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    saveButton.isEnabled = true
  }
}
