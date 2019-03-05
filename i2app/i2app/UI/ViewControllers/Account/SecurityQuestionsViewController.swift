//
//  SecurityQuestionsViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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

class SecurityQuestionsViewController: BaseTextViewController,
  UITableViewDelegate,
  UITableViewDataSource,
  RegistrationConfigHolder {

  fileprivate let answerPlaceholder: String = "************"

  @IBOutlet internal var answerTextField: AccountTextField!
  @IBOutlet internal var answer2TextField: AccountTextField!
  @IBOutlet internal var answer3TextField: AccountTextField!

  @IBOutlet internal var securityQuestion1Button: UIButton!
  @IBOutlet internal var securityQuestion2Button: UIButton!
  @IBOutlet internal var securityQuestion3Button: UIButton!

  internal var securityQTableView: UITableView!

  @IBOutlet internal var mainText: UILabel!
  @IBOutlet internal var nextButton: UIButton!

  fileprivate var tableData: [String]?
  fileprivate var securityQuestions: [String: String]? = [:]
  fileprivate var securityQuestionAnswerDictionary: [String: String]?

  @IBOutlet internal var bottomTextConstraint: NSLayoutConstraint!

  internal var config: RegistrationConfig?

  fileprivate var _viewMode: SecurityQuestionsViewMode?
  var viewMode: SecurityQuestionsViewMode {
    get {
      if _viewMode == nil {
        _viewMode = SecurityQuestionsViewMode.ViewModeAccountCreation
      }

      return _viewMode!
    }
    set(value) {
      _viewMode = value
    }
  }

  class func create() -> SecurityQuestionsViewController {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: SecurityQuestionsViewController? = storyboard
      .instantiateViewController(withIdentifier: "SecurityQuestionsViewController")
      as? SecurityQuestionsViewController

    vc?.config = AccountRegistrationConfig()

    return vc!
  }

  class func create(_ config: RegistrationConfig) -> SecurityQuestionsViewController? {
    let storyboard: UIStoryboard = UIStoryboard.init(name: "CreateAccount", bundle: nil)
    let vc: SecurityQuestionsViewController? = storyboard
      .instantiateViewController(withIdentifier: "SecurityQuestionsViewController")
      as? SecurityQuestionsViewController

    vc?.config = config
    return vc
  }

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navBar(withBackButtonAndTitle: NSLocalizedString("Security", comment: ""))

    loadData()
    setupView()
    setupTableView()
  }

  // MARK: View Setup
  fileprivate func loadData() {
    DispatchQueue.global(qos: .background).async {
      _ = LocalizedStringsController.getSecurityQuestions()
        .swiftThen { dict in
          if let questions: [String: String] = dict as? [String: String] {
            self.securityQuestions = questions

            let fontType: FontDataType = self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
              ? FontDataTypeSettingsSubTextTranslucent
              : FontDataTypeAccountSubText

            var values = [String](questions.values)
            var fontData = FontData.getString(values[0], withFont: fontType)
            self.securityQuestion1Button.setAttributedTitle(fontData, for: UIControlState())
            self.securityQuestion1Button.titleLabel?.numberOfLines = 0
            self.securityQuestion1Button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

            fontData = FontData.getString(values[1], withFont: fontType)
            self.securityQuestion2Button.setAttributedTitle(fontData, for: UIControlState())
            self.securityQuestion2Button.titleLabel?.numberOfLines = 0
            self.securityQuestion2Button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

            fontData = FontData.getString(values[2], withFont: fontType)
            self.securityQuestion3Button.setAttributedTitle(fontData, for: UIControlState())
            self.securityQuestion3Button.titleLabel?.numberOfLines = 0
            self.securityQuestion3Button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

            if self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange {
              self.setExistingQuestions()
            }
          }
          return nil
        }
        .swiftCatch { error in
          guard let error = error as? NSError else { return nil }
          self.displayErrorMessage(error.localizedDescription, withTitle: "Create Account Error")

          return nil
      }
    }
  }

  fileprivate func setupView() {
    if self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange {
      self.setBackgroundColorToLastNavigateColor()
      self.addDarkOverlay(BackgroupOverlayLightLevel)
    }

    self.answerTextField.placeholder = NSLocalizedString("Answer", comment: "")
    self.answerTextField.autocapitalizationType = UITextAutocapitalizationType.sentences
    self.setTypeAndFontForTextField(self.answerTextField)

    self.answer2TextField.placeholder = NSLocalizedString("Answer", comment: "")
    self.answer2TextField.autocapitalizationType = UITextAutocapitalizationType.sentences
    self.setTypeAndFontForTextField(self.answer2TextField)

    self.answer3TextField.placeholder = NSLocalizedString("Answer", comment: "")
    self.answer3TextField.autocapitalizationType = UITextAutocapitalizationType.sentences
    self.setTypeAndFontForTextField(self.answer3TextField)

    if self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange {
      self.nextButton.styleSet(NSLocalizedString("save", comment: ""),
                               andButtonType:FontDataTypeButtonLight,
                               upperCase:true)

      self.setTextFieldColorsForSettingsChange(self.answerTextField)
      self.setTextFieldColorsForSettingsChange(self.answer2TextField)
      self.setTextFieldColorsForSettingsChange(self.answer3TextField)
    } else {
      self.mainText.attributedText = FontData.getString(NSLocalizedString("Need to call support for help?"
        + "\nThis will confirm your identity.\n(Also helps with forgotten passwords)", comment: ""),
                                                        withFont:FontDataTypeAccountMainText)

      self.nextButton.styleSet(NSLocalizedString("next", comment: ""),
                               andButtonType:FontDataTypeButtonDark,
                               upperCase:true)
      if UIDevice.isIPhone5() {
        bottomTextConstraint.constant = 2
      } else {
        bottomTextConstraint.constant = 58
      }
    }
  }

  fileprivate func setTypeAndFontForTextField(_ textField: AccountTextField) {
    let fontType: FontDataType = self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
      ? FontDataTypeSettingsSubText
      : FontDataTypeAccountSubText

    let placeholderType: FontDataType = self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
      ? FontDataTypeSettingsSubText
      : FontDataTypeAccountSubText

    textField.setupType(AccountTextFieldTypeGeneral, fontType: fontType, placeholderFontType: placeholderType)
  }

  fileprivate func setTextFieldColorsForSettingsChange(_ textField: AccountTextField) {
    let textColor = UIColor.white
    let separatorColor = UIColor.white.withAlphaComponent(0.4)
    let activeTextColor = UIColor.white.withAlphaComponent(0.6)

    textField.textColor = textColor
    textField.activeSeparatorColor = separatorColor
    textField.separatorColor = separatorColor
    textField.floatingLabelTextColor = activeTextColor
    textField.floatingLabelActiveTextColor = activeTextColor
  }

  fileprivate func setExistingQuestions() {
    DispatchQueue.global(qos: .background).async {
      _ = PersonCapability.getSecurityAnswers(on: RxCornea.shared.settings?.currentPerson)
        .swiftThen { response in
          if let answersResponse = response as? PersonGetSecurityAnswersResponse {
            self.securityQuestionAnswerDictionary = answersResponse.getSecurityAnswers() as? [String: String]

            let fontType: FontDataType = self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
              ? FontDataTypeSettingsSubText
              : FontDataTypeAccountSubText

            let translucentType: FontDataType =
              self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
                ? FontDataTypeSettingsSubTextTranslucent
                : FontDataTypeAccountSubText // Currently only used in settings

            var i: Int = 0

            for (key, _) in self.securityQuestionAnswerDictionary! {
              if let _: String = self.securityQuestions?[key] {
                var questionButton: UIButton?
                var answerField: AccountTextField?

                switch i {
                case 0:
                  questionButton = self.securityQuestion1Button
                  answerField = self.answerTextField
                case 1:
                  questionButton = self.securityQuestion2Button
                  answerField = self.answer2TextField
                case 2:
                  questionButton = self.securityQuestion3Button
                  answerField = self.answer3TextField
                default: break
                }

                if questionButton != nil {
                  let fontData =
                    FontData.getString(self.securityQuestions?[key] ?? "", withFont: translucentType)
                  questionButton?.setAttributedTitle(fontData, for: UIControlState())
                }

                if answerField != nil {
                  let fontData = FontData.getString(self.answerPlaceholder, withFont: fontType)
                  answerField?.attributedText = fontData
                  self.setTypeAndFontForTextField(answerField!)
                }
              }
              i += 1
            }
          }

          return nil
      }
    }
  }

  fileprivate func setupTableView() {
    self.tableData = ["First car?", "First pet?", "Oldest paternal aunt's maiden name?"]

    self.securityQTableView = UITableView(frame: CGRect(x: 32, y: 211, width: 313, height: 214))
    self.securityQTableView.dataSource = self
    self.securityQTableView.delegate = self
    self.view.addSubview(self.securityQTableView)
    self.securityQTableView.isHidden = true

    let maskPath: UIBezierPath =
      UIBezierPath(roundedRect: self.securityQTableView.bounds,
                   byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight],
                   cornerRadii: CGSize(width: 10.0, height: 10.0))

    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.securityQTableView.bounds
    maskLayer.path = maskPath.cgPath
    maskLayer.lineWidth = 1.0
    maskLayer.strokeColor = UIColor.black.cgColor

    self.securityQTableView.layer.borderWidth = 0.5
    self.securityQTableView.layer.borderColor = UIColor.black.cgColor
  }

  // MARK: TableViewDataSource

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")

    if cell == nil {
      cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
    }

    cell?.backgroundColor = UIColor.clear

    let cellFontDataType = self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange
      ? FontDataTypeSettingsSubText
      : FontDataTypeAccountSubText

    cell!.textLabel?.attributedText = FontData.getString(self.tableData?[indexPath.row],
                                                         withFont: cellFontDataType)

    return cell!
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func displaySecurityTableViewController(_ button: UIButton) {
    let securityTableViewController: SecurityTableViewController = SecurityTableViewController.create()

    securityTableViewController.viewMode = self.viewMode
    securityTableViewController.dataSource = Array(self.securityQuestions!.values)
    securityTableViewController.selectedButton = button
    if self.securityQuestion1Button != nil
      && self.securityQuestion2Button != nil
      && self.securityQuestion3Button != nil {
      if self.securityQuestion1Button.titleLabel?.text != nil
        && self.securityQuestion2Button.titleLabel?.text != nil
        && self.securityQuestion3Button.titleLabel?.text != nil {
        securityTableViewController.currentSelections = [self.securityQuestion1Button.titleLabel!.text!,
                                                         self.securityQuestion2Button.titleLabel!.text!,
                                                         self.securityQuestion3Button.titleLabel!.text!]
      } else {
        securityTableViewController.currentSelections = ["Unknown 1", "Unknown 2", "Unknown 3"]
      }
    } else {
      securityTableViewController.currentSelections = ["Default 1", "Default 2", "Default 3"]
    }
    self.navigationController?.pushViewController(securityTableViewController, animated: true)
  }

  // MARK: Actions

  @IBAction func securityQuestion1Pressed(_ sender: AnyObject) {
    self.displaySecurityTableViewController(self.securityQuestion1Button)
    self.answerTextField.text = ""
  }

  @IBAction func securityQuestion2Pressed(_ sender: AnyObject) {
    self.displaySecurityTableViewController(self.securityQuestion2Button)
    self.answer2TextField.text = ""
  }

  @IBAction func securityQuestion3Pressed(_ sender: AnyObject) {
    self.displaySecurityTableViewController(self.securityQuestion3Button)
    self.answer3TextField.text = ""
  }

  @IBAction func nextButtonPressed(_ sender: AnyObject) {
    super.validateTextFields()
  }

  @IBAction func saveButtonPressed(_ sender: AnyObject) {
    if self.viewMode == SecurityQuestionsViewMode.ViewModeAccountCreation {
      super.validateTextFields()
    } else {
      self.updateSecurityQuestionsViaSettings()
    }
  }

  // MARK: UITextFieldDelegate

  override func textFieldDidBeginEditing(_ textField: UITextField) {
    super.textFieldDidBeginEditing(textField)

    if textField.isSecureTextEntry {
      textField.isSecureTextEntry = false

      let fontType: FontDataType = (self.viewMode == SecurityQuestionsViewMode.ViewModeSettingsChange)
        ? FontDataTypeSettingsSubText
        : FontDataTypeAccountSubText

      textField.attributedText = FontData.getString("temp", withFont: fontType)
      // @"temp"string is a workaround for setting font properly.  Should never be visible.

      textField.text = nil
    }

    if let accountTextField = textField as? AccountTextField {
      self.setTypeAndFontForTextField(accountTextField)
    }
  }

  // MARK: Save from Settings

  func updateSecurityQuestionsViaSettings() {
    var errorMessage: NSString? = "Error"

    if self.isDataValid(&errorMessage) {
      let question1: String? = self.securityQuestions?
        .firstKeyForValue(self.securityQuestion1Button.titleLabel?.text ?? "")
      let question2: String? = self.securityQuestions?
        .firstKeyForValue(self.securityQuestion2Button.titleLabel?.text ?? "")
      let question3: String? = self.securityQuestions?
        .firstKeyForValue(self.securityQuestion3Button.titleLabel?.text ?? "")

      let answer1: String? = self.answerTextField.text! == answerPlaceholder
        ? self.securityQuestionAnswerDictionary?[question1!]
        : self.answerTextField.text

      let answer2: String? = self.answer2TextField.text == answerPlaceholder
        ? self.securityQuestionAnswerDictionary?[question2!]
        : self.answer2TextField.text

      let answer3: String? = self.answer3TextField.text == answerPlaceholder
        ? self.securityQuestionAnswerDictionary?[question3!]
        : self.answer3TextField.text

      DispatchQueue.global(qos: .background).async {
        _ = PersonCapability.setSecurityAnswersWithSecurityQuestion1(
          question1, withSecurityAnswer1: answer1,
          withSecurityQuestion2: question2, withSecurityAnswer2: answer2,
          withSecurityQuestion3: question3, withSecurityAnswer3: answer3,
          on: RxCornea.shared.settings?.currentPerson)
          .swiftThen { _ in
            self.navigationController?.popViewController(animated: true)
            return nil
          }
          .swiftCatch { error in
            guard let error = error as? NSError else { return nil }
            self.displayErrorMessage(error.localizedDescription)
            return nil
        }

      }
    } else {
      DispatchQueue.main.async {
        if let errorString = errorMessage as String? {
          self.displayErrorMessage(errorString)
        }
      }
    }
  }

  // MARK: Save Registration Context

  override func saveRegistrationContext() {
    let question1: String? = self.securityQuestions?
      .firstKeyForValue(self.securityQuestion1Button.titleLabel?.text ?? "")
    let question2: String? = self.securityQuestions?
      .firstKeyForValue(self.securityQuestion2Button.titleLabel?.text ?? "")
    let question3: String? = self.securityQuestions?
      .firstKeyForValue(self.securityQuestion3Button.titleLabel?.text ?? "")

    self.createGif()

    DispatchQueue.global(qos: .background).async {

      if self.config is AccountRegistrationConfig {
        self.setSecurityForAccountRegistration(question1!, question2: question2!, question3: question3!)
      } else if self.config is InvitationRegistrationConfig {
        self.setSecurityForInviteRegistration(question1!, question2: question2!, question3: question3!)
      }
    }
  }

  // TODO: Clean this up!
  fileprivate func setSecurityForAccountRegistration(_ question1: String,
                                                     question2: String,
                                                     question3: String) {
    guard let person = RxCornea.shared.settings?.currentPerson,
      let account = RxCornea.shared.settings?.currentAccount,
      let answer1 = self.answerTextField.text,
      let answer2 = self.answer2TextField.text,
      let answer3 = self.answer3TextField.text else { return }

    _ = AccountController
      .setSecurityAnswersWithSecurityQuestionsAndCompleteStep(question1,
                                                              securityAnswer1: answer1,
                                                              securityQuestion2: question2,
                                                              securityAnswer2: answer2,
                                                              securityQuestion3: question3,
                                                              securityAnswer3: answer3,
                                                              personModel: person,
                                                              accountModel: account)
      .swiftThen { _ in
        self.hideGif()

        let registered: Bool = UIApplication.shared.isRegisteredForRemoteNotifications
        let notification: Bool = (UserDefaults.standard.object(forKey: "notificationAnswer") as AnyObject)
          .isEqual(true)

        if !registered && !notification {
          self.navigationController?.pushViewController(SuccessAccountViewController.create(), animated: true)
        } else {
          self.navigationController?.pushViewController(NotificationViewController.create(), animated: true)
        }

        return nil
      }
      .swiftCatch { error in
        guard let error = error as? NSError else { return nil }
        self.hideGif()
        self.displayErrorMessage(error.localizedDescription, withTitle: "Security Questions Error")
        return nil
    }
  }

  fileprivate func setSecurityForInviteRegistration(_ question1: String,
                                                    question2: String,
                                                    question3: String) {
    guard let person = RxCornea.shared.settings?.currentPerson,
      let account = RxCornea.shared.settings?.currentAccount,
      let answer1 = self.answerTextField.text,
      let answer2 = self.answer2TextField.text,
      let answer3 = self.answer3TextField.text else { return }

    _ = AccountController.setSecurityAnswersWithSecurityQuestions(question1,
                                                                  securityAnswer1: answer1,
                                                                  securityQuestion2: question2,
                                                                  securityAnswer2: answer2,
                                                                  securityQuestion3: question3,
                                                                  securityAnswer3: answer3,
                                                                  personModel: person,
                                                                  accountModel: account)
      .swiftThen { _ in
        self.hideGif()

        if let vc = AccountInvitationPinCodeEntryViewController.create(self.config!) {
          vc.personModel = RxCornea.shared.settings?.currentPerson
          self.navigationController?.pushViewController(vc, animated: true)
        }
        return nil
      }
      .swiftCatch { error in
        guard let error = error as? NSError else { return nil }
        self.hideGif()
        self.displayErrorMessage(error.localizedDescription, withTitle: "Security Questions Error")
        return nil
    }
  }
}
