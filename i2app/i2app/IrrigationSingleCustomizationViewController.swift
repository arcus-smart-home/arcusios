//
//  IrrigationSingleCustomizationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/19/18.
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
import RxSwift

class IrrigationSingleCustomizationViewController: UIViewController {
  
  /**
   Required by ScrollViewKeyboardAnimatable
   */
  var keyboardAnimatableShowObserver: Any?
  
  /**
   Required by ScrollViewKeyboardAnimatable
   */
  @IBOutlet weak var keyboardAnimationView: UIScrollView!
  
  /**
   Required by ScrollViewKeyboardAnimatable
   */
  var keyboardAnimatableHideObserver: Any?
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var deviceAddress = ""
  
  /**
   Required by IrrigationCustomizePresenter
   */
  var deviceImage: UIImage?
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var actionButton: UIButton!
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  /**
   Required by IrrigationCustomizePresenter
   */
  var irrigationData = IrrigationSingleCustomizationViewModel()

  /**
   Required by IrrigationCustomizePresenter
   */
  var zoneContext: Int?
  
  @IBOutlet weak var deviceImageView: UIImageView!
  
  @IBOutlet weak var zoneNameField: ScleraTextField!
  
  @IBOutlet weak var wateringTimeView: UIView!
  
  @IBOutlet weak var wateringTimeLabel: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var multiIrrigationButtonContainer: UIView!
  
  static func create() -> IrrigationSingleCustomizationViewController? {
    let storyboard = UIStoryboard(name: "IrrigationCustomization", bundle: nil)
    let id = "IrrigationSingleCustomizationViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? IrrigationSingleCustomizationViewController else {
        return nil
    }
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    irrigationCustomizeFetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    addKeyboardScrolling()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    cleanUpKeyboardScrollingObservers()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let destination = segue.destination as? IrrigationSinglePopupViewController {
      destination.popupDelegate = self
      destination.titleText = "Duration"
      destination.options = irrigationCustomizeWateringTimesText()
      destination.selectedOptionIndex = irrigationData.selectedWateringTimeIndex
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    if zoneNameField.isEditing {
      zoneNameField.resignFirstResponder()
    }
    
    irrigationCustomizeSaveData()
    
    addCustomization(PairingCustomizationStepType.irrigationZone.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeIrrigationZone)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
    if zoneNameField.isEditing {
      zoneNameField.resignFirstResponder()
    }
    
    irrigationCustomizeSaveData()
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func wateringTimeSelected() {
    if zoneNameField.isEditing {
      zoneNameField.resignFirstResponder()
    }
    
    performSegue(withIdentifier: "WateringTimePopupSegue", sender: self)
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    let zonePlaceholder = "Zone \(zoneContext ?? 1) Name"
    zoneNameField.title = zonePlaceholder
    zoneNameField.placeholder = zonePlaceholder
    
    let gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(wateringTimeSelected))
    wateringTimeView.addGestureRecognizer(gesture)
    
    // When there is a zone context this view is part of the multi zone flow, and the platform data
    // for the customization step is not available.
    if zoneContext == nil {
      addScleraBackButton()
      multiIrrigationButtonContainer.isHidden = true
      updateActionButtonText()
      
      // Set platform fields if avaiable
      if let header = currentStepViewModel()?.header {
        navigationItem.title = header
      }
      if let title = currentStepViewModel()?.title {
        titleLabel.text = title
      }
    } else {
      actionButton.isHidden = true
      multiIrrigationButtonContainer.isHidden = false
    }
  }
  
  fileprivate func updateViews() {
    let timesText = irrigationCustomizeWateringTimesText()
    let selectedIndex = irrigationData.selectedWateringTimeIndex
    
    if timesText.count > selectedIndex {
      wateringTimeLabel.text = shortenTimeText(timesText[selectedIndex])
    }
    
    if let image = deviceImage {
      deviceImageView.image = image
    }
    
    zoneNameField.text = irrigationData.zoneName
  }
  
  private func irrigationCustomizeWateringTimesText() -> [String] {
    var wateringTimesText = [String]()
    
    for time in irrigationData.wateringTimes where time > 0 {
      if time < 60 {
        let text = time == 1 ? "1 minute" : "\(time) minutes"
        wateringTimesText.append(text)
      } else {
        let hours = time / 60
        let text = hours == 1 ? "1 hour" : "\(hours) hours"
        wateringTimesText.append(text)
      }
    }
    
    return wateringTimesText
  }
  
  private func shortenTimeText(_ text: String) -> String {
    let minute = "minute"
    let hour = "hour"
    
    var shortenText = text.replacingOccurrences(of: minute, with: "min")
    shortenText = shortenText.replacingOccurrences(of: hour, with: "hr")
    
    return shortenText
  }
  
  private func applyDefaultNameIfNeeded() {
    if zoneNameField.text == "" {
      zoneNameField.text = "Zone \(zoneContext ?? 1)"
    }
  }
  
}

extension IrrigationSingleCustomizationViewController: IrrigationSinglePopupDelegate {
  func irrigationSinglePopupSelectedOptionIndex(_ index: Int) {
    irrigationData.selectedWateringTimeIndex = index
    updateViews()
  }
}

extension IrrigationSingleCustomizationViewController: PairingCustomizationStepPresenter {
  
}

extension IrrigationSingleCustomizationViewController: IrrigationCustomizePresenter {
  func irrigationCustomizeDataUpdated() {
    updateViews()
  }
}

extension IrrigationSingleCustomizationViewController: ScrollViewKeyboardAnimatable {
  
}

extension IrrigationSingleCustomizationViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == zoneNameField {
      if let zoneName = zoneNameField.text {
        irrigationData.zoneName = zoneName
      }
    }
  }
  
}
