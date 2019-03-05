//
//  PairingInstructionViewController.swift
//  i2app
//
//  Arcus Team on 2/21/18.
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

/// Renders a pairing instruction "page" typically as part of a sequence of steps embedded
/// in the PairingStepsParentViewController's view pager.
///
/// -seealso PairingStepsParentViewController
class PairingInstructionViewController: UIViewController {

  // MARK - OffsetScrollViewKeyboardAnimatable
  @IBOutlet var keyboardAnimationView: UIScrollView!
  var keyboardAnimatableShowObserver: Any?
  var keyboardAnimatableHideObserver: Any?

  @IBOutlet weak var illustration: UIImageView!
  @IBOutlet weak var instruction: UILabel!
  @IBOutlet weak var instructionLink: UIButton!
  @IBOutlet weak var inputContainer: UIView!
  @IBOutlet weak var linkContainer: UIView!
  @IBOutlet weak var stackView: UIStackView!

  var step: ArcusPairingStepViewModel?
  
  fileprivate var presenter: PairingStepsPresenter?
  fileprivate var linkUrl: URL?
  fileprivate var externalAppUrl: URL?
  fileprivate var formViews: [String:UIView] = [:]

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: PairingStepsPresenter) -> PairingInstructionViewController? {
    let storyboard = UIStoryboard(name: "PairingInstructionSteps", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "PairingInstructionViewController")
                  as? PairingInstructionViewController {
      vc.step = step
      vc.presenter = presenter
      return vc
    }
    
    return nil    
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let step = step as? PairingStepsStepViewModel else {
      return
    }

    // Populate step illustration
    let productAddress = step.productAddress
    if let stepNumber = step.order,
      stepNumber == 2,
      presenter?.viewModel?.isVoiceAssistant ?? false {
      illustration.image = UIImage(named: "download_image_large_circle")
    } else if let stepNumber = step.order,
      let location = ImagePaths.getPairingImage(ProductModel.modelIdForAddress(productAddress),
                                                forStep: Int32(stepNumber)) {
      illustration.sd_setImage(with: URL(string: location))
    }

    // Populate one or more lines of instructional text
    if let instructionTexts = step.instructions {
      instruction.text = instructionTexts.joined(separator: "\n")
    }
    
    self.linkContainer.isHidden = true
    
    // Populate manufacturer instruction link (when available)
    if let linkUrlLocation = step.linkUrl {
      self.linkUrl = URL(string: linkUrlLocation)
      
      if let linkText = step.linkText {
        self.instructionLink.setTitle(linkText, for: .normal)
        
        self.linkContainer.isHidden = false
      }
    } else {
      // Reuse the link URL to launch external apps when needed
      if let appURL = step.externalAppUrl {
        self.externalAppUrl = URL(string: appURL)
        
        if let linkText = step.linkText {
          self.instructionLink.setTitle(linkText, for: .normal)
          
          self.linkContainer.isHidden = false
        }
      }
    }

    // Populate user input form (when available)
    if hasForm() {
      self.presenter?.formDelegate = self
      inputContainer.removeFromSuperview()
      
      formViews = buildFormViews()
      for (_, fieldView) in formViews {
        stackView.addArrangedSubview(fieldView)
      }
    
    } else {
      inputContainer.isHidden = true
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addKeyboardScrolling()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    cleanUpKeyboardScrollingObservers()
  }
  
  override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let step = step as? PairingStepsStepViewModel else {
      return
    }

    if let mfgrInstruction = segue.destination as? MfgrInstructionsViewController,
       let instructionsUrl = step.linkUrl {

      mfgrInstruction.instructionsUrl = URL(string: instructionsUrl)
    }
  }
  
  @IBAction func linkUrlButtonTapped(_ sender: Any) {
    if linkUrl != nil {
      performSegue(withIdentifier: "linkUrlInstructionsSegue", sender: self)
    } else if let appUrl = externalAppUrl {
      UIApplication.shared.openURL(appUrl)
    }
  }

  private func buildFormViews() -> [String: UIView] {
    guard let step = step as? PairingStepsStepViewModel else {
      return [:]
    }

    var views: [String: UIView] = [:]
    
    if let fields = step.form {
      for field in fields {
        if !field.isHidden() {
        
          if let containerCopy = entryContainerCopy(),
             let textField = findChildView(ScleraTextField.self, inParent: containerCopy),
             let fieldName = field.name {
            
            textField.selectedTitle = field.label
            textField.placeholder = field.label
            textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
            textField.addTarget(self, action: #selector(textFieldDidEnd(textField:)), for: .editingDidEnd)
            textField.addTarget(self, action: #selector(textFieldDidBegin(textField:)), for: .editingDidBegin)

            views[fieldName] = containerCopy
          }
        }
      }
    }
    
    return views
  }

  private func entryContainerCopy() -> UIView? {
    return NSKeyedUnarchiver.unarchiveObject(with:
      NSKeyedArchiver.archivedData(withRootObject: self.inputContainer)) as? UIView
  }
  
  @objc func textFieldDidChange(textField: UITextField) {
    updateInputCharacterCounts()
    presenter?.formWasUpdated()
  }
  
  @objc func textFieldDidEnd(textField: UITextField) {
    updateInputCharacterCounts()
    _ = validateForm(showErrors: true)
    presenter?.formWasUpdated()
  }

  @objc func textFieldDidBegin(textField: UITextField) {
    clearErrorFromField(textField)
  }

  private func updateInputCharacterCounts() {
    guard let step = step as? PairingStepsStepViewModel else {
      return
    }
    if let fields = step.form {
      for field in fields {
        if let fieldName = field.name,
           let inputContainer = formViews[fieldName],
           let maxCount = field.maxlen,
           let inputField = findChildView(ScleraTextField.self, inParent: inputContainer),
           let charCount = inputField.text?.count,
           let charCountLabel = findChildView(UILabel.self, inParent: inputContainer) {

          if charCount > maxCount, let substring = inputField.text?.prefix(maxCount) {
            inputField.text = String(substring)
          }
          
          charCountLabel.text = "\(inputField.text?.count ?? 0)/\(maxCount)"
        }
      }
      
    }
  }

  fileprivate func findChildView<T>(_ type: T.Type, inParent: UIView) -> T? {
    for subview in inParent.subviews {
      if let found = subview as? T {
        return found
      }
    }
    return nil
  }

}

extension PairingInstructionViewController: InputFormDelegate {

  func hasCompletedForm() -> Bool {
    return hasForm() && validateForm(showErrors: false)
  }

  func hasForm() -> Bool {
    guard let step = step as? PairingStepsStepViewModel else {
      return false
    }
    return (step.form?.count ?? 0) > 0
  }

  func getCompletedForm() -> [String:String] {
    var completedForm: [String:String] = [:]

    guard let step = step as? PairingStepsStepViewModel else {
      return completedForm
    }

    if hasForm() {
      
      if let fields = step.form {
        for field in fields {

          // Hidden field populated with data from platform
          if field.isHidden() {
            if let fieldName = field.name, let fieldValue = field.value {
              completedForm[fieldName] = fieldValue
            }
          }
          
          // Visible field populated with user-entered data
          else {
            if let fieldName = field.name,
               let viewContainer = formViews[fieldName],
               let textField = findChildView(ScleraTextField.self, inParent: viewContainer),
               let fieldValue = textField.text {
              
              completedForm[fieldName] = fieldValue
            }
          }
        }
      }
    }
    
    return completedForm
  }

  fileprivate func clearErrorFromField(_ textField: UITextField) {
    for (_, thisFormView) in formViews {
      if let thisField = findChildView(ScleraTextField.self, inParent: thisFormView),
         thisField == textField {
        
        thisField.removeError()
      }
    }
  }

  fileprivate func validateForm(showErrors: Bool) -> Bool {
    guard let stepModel = step as? PairingStepsStepViewModel else {
      return false
    }

    let completedForm = getCompletedForm()

    if let formModel = stepModel.form {

      for thisEntry in formModel {
        if let entryName = thisEntry.name,
           let viewContainer = formViews[entryName],
           let textField = findChildView(ScleraTextField.self, inParent: viewContainer),
           let required = thisEntry.required,
           let minlen = thisEntry.minlen,
           let maxlen = thisEntry.maxlen {
          
          if required && completedForm[entryName] == nil      ||
              (completedForm[entryName]?.count ?? 0) < minlen ||
              (completedForm[entryName]?.count ?? 0) > maxlen {
            
            if showErrors {
              textField.showError(errorText: "Invalid input")
            }
            return false            
          } else {
            textField.removeError()
          }
        }
      }
    }
    
    return true
  }
  
}

extension PairingInstructionViewController: OffsetScrollViewKeyboardAnimatable {
  func activeViewForKeyboardScroll() -> UIView? {
    if let current = UIResponder.current as? UIView {
      return current
    }
    return nil
  }
}
