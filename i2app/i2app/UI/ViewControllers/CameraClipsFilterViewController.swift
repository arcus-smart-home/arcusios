//
//  CameraClipsFilterViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/18/17.
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
import RxSwift

protocol CameraClipsFilterViewControllerDelegate: class {
  func didApplyFilters(withViewController: CameraClipsFilterViewController)
  func didCancelFilters(withViewController: CameraClipsFilterViewController)
}

class CameraClipsFilterViewController: UIViewController {
  
  /// delegate
  /// set the delgate before viewDidLoad
  weak var delegate: CameraClipsFilterViewControllerDelegate!

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var cameraFilterLabel: UILabel!
  @IBOutlet weak var timeFilterDescriptionLabel: UILabel!
  @IBOutlet weak var timeChevronImage: UIImageView!
  @IBOutlet weak var timeFilterImage: UIImageView!
  @IBOutlet weak var timeFilterLabel: UILabel!
  var popupWindow: PopupSelectionWindow!
  var premiumStatusBool: Bool = true
  var selectedCameraFilter: ClipCameraFilter!
  var selectedTimeFilter: ClipTimeFilter!
  var disposeBag: DisposeBag = DisposeBag()
  
  static func create() -> CameraClipsFilterViewController {
    let sb: UIStoryboard = UIStoryboard(name: "CameraCard", bundle:nil)
    let vc = sb.instantiateViewController(withIdentifier: "CameraClipsFilterViewController")
      as? CameraClipsFilterViewController
    return vc!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTitle()
    updateLayout()
    
    checkPremiumStatus()
  }
  
  private func checkPremiumStatus() {
    if premiumStatusBool {
        self.timeFilterImage.alpha = 0.3
        self.timeChevronImage.alpha = 0.3
        self.timeChevronImage.isUserInteractionEnabled = false

      }
      self.timeFilterLabel.isEnabled = premiumStatusBool
      self.timeFilterLabel.isUserInteractionEnabled = premiumStatusBool
      self.timeFilterDescriptionLabel.isEnabled = premiumStatusBool
  }
  
  func configureTitle() {
    titleLabel.attributedText =
      FontData.createFontData(FontTypeDemiBold,
                              size: 12,
                              blackColor: true,
                              space: true)
        .getFontAttributed("Filter".uppercased())
    titleLabel.sizeToFit()
  }

  @IBAction fileprivate func closeButtonPressed() {
    delegate.didCancelFilters(withViewController: self)
  }

  @IBAction fileprivate func cameraFilterButtonPressed() {
    guard let cameras = CameraClipsFilterPresenter.getCamerasToDisplay else {
      DDLogError("fatal error in the modal cache")
      return
    }
    let popupSelection = PopupSelectionTextPickerView
      .create(NSLocalizedString("CHOOSE A CAMERA", comment: ""),
              list: cameras)
    self.popupWindow =
      PopupSelectionWindow.popup(self.view,
                                 subview: popupSelection,
                                 owner: self,
                                 close: #selector(CameraClipsFilterViewController.closeCameraFilter(_:)))
  }

  func closeCameraFilter(_ sender: Any) {
    guard let camerasFilters = CameraClipsFilterPresenter.camerasFilters,
      let selectedString = sender as? String,
      let selectedFilter = camerasFilters.filter({$0.address == selectedString}).first
      else {
      return
    }
    selectedCameraFilter = selectedFilter
    updateLayout()
  }

  @IBAction func timeFilterButtonPressed() {
    if !premiumStatusBool {
      return
    }
    guard let timeFilters = CameraClipsFilterPresenter.timeFilterDisplay else {
      DDLogError("fatal error in the modal cache")
      return
    }
    let popupSelection = PopupSelectionTextPickerView
      .create(NSLocalizedString("SHOW CLIPS FROM", comment: ""),
              list: timeFilters)
    self.popupWindow =
      PopupSelectionWindow.popup(self.view,
                                 subview: popupSelection,
                                 owner: self,
                                 close: #selector(CameraClipsFilterViewController.closeTimeFilter(_:)))

  }

  func closeTimeFilter(_ sender: Any) {
    let camerasFilters = ClipTimeFilter.allClipTimeFilters
    guard let selectedString = sender as? String,
      let selectedFilter = camerasFilters
        .filter({$0.filterName == selectedString}).first else {
          DDLogError("fatal error no selected filter")
          return
    }
    selectedTimeFilter = selectedFilter
    updateLayout()
  }

  @IBAction func clearAllButtonPressed() {
    selectedTimeFilter = ClipTimeFilter.defaultFilter
    selectedCameraFilter = ClipCameraFilter.defaultFilter
    updateLayout()
  }

  @IBAction func applyFilterButtonPressed() {
    delegate.didApplyFilters(withViewController: self)
  }
  
  func updateLayout() {
    timeFilterLabel.text = selectedTimeFilter.filterName
    cameraFilterLabel.text = selectedCameraFilter.name
  }

}
