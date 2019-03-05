//
//  AddPersonSelectRelationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/28/16.
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

class AddPersonSelectRelationViewController: UIViewController,
  UITableViewDataSource,
  UITableViewDelegate,
  UITextFieldDelegate,
ArcusInputAccessoryProtocol {
  @IBOutlet var headerMainLabel: ArcusLabel!
  @IBOutlet var relationTableView: UITableView!
  @IBOutlet var relationTableBottomSpacingConstraint: NSLayoutConstraint! {
    didSet {
      self.defaultTrailingSpace = self.relationTableBottomSpacingConstraint.constant
    }
  }
  @IBOutlet var nextButton: ArcusButton!
  @IBOutlet var otherTextFieldInputAccessoryView: ArcusInputAccessoryView! {
    didSet {
      self.otherTextFieldInputAccessoryView.inputDelegate = self
      self.otherTextFieldInputAccessoryView.doneButton
        .setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white],
                                for: UIControlState())
    }
  }

  weak var otherTextField: ArcusFloatingLabelTextField? {
    didSet {
      self.otherTextField?.inputAccessoryView = self.otherTextFieldInputAccessoryView
    }
  }

  internal var addPersonModel: AddPersonModel?

  var relationshipArray: NSArray? = PersonModel.personRelationArray() as NSArray?
  var selectedIndex: Int = 0
  var selectedDetailsArray: NSArray? = []

  var defaultTrailingSpace: CGFloat = 0
  fileprivate var selectedSubRelationship: NSDictionary?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardWillShow(_:)),
                                           name: Notification.Name.UIKeyboardWillShow,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.keyboardWillHide(_:)),
                                           name: Notification.Name.UIKeyboardWillHide,
                                           object: nil)

    self.configureUI()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: UI Configuration
  func configureUI() {
    self.nextButton.isEnabled = true

    self.setBackgroundColorToDashboardColor()
    self.addWhiteOverlay(BackgroupOverlayMiddleLevel)

    self.navBar(withBackButtonAndTitle: self.navigationItem.title)

    self.relationTableView.backgroundColor = UIColor.clear
    self.relationTableView.backgroundView = nil
    self.relationTableView.estimatedRowHeight = 70
    self.relationTableView.rowHeight = UITableViewAutomaticDimension

    self.selectedIndex = 0
    self.relationTableView.selectRow(at: IndexPath(row: 0, section:0),
                                     animated: false,
                                     scrollPosition: UITableViewScrollPosition.top)
  }

  // MARK: IBActions
  @IBAction func nextButtonPressed(_ sender: UIButton) {
    if self.selectedIndex != -1 {
      if let relationDictionary: NSDictionary =
        self.relationshipArray![self.selectedIndex] as? NSDictionary {
        var selectedRelation: NSDictionary? = nil

        if relationDictionary.allKeys[0] as? String == "people_other" {
          let otherString: String =
            (self.otherTextField!.text != "Please Describe") ?
              (self.otherTextField?.text)! : "other"
          let key: String? = relationDictionary.allKeys[0] as? String
          selectedRelation = [key!: otherString]
        } else if self.selectedSubRelationship != nil {
          selectedRelation = self.selectedSubRelationship
        } else {
          selectedRelation = relationDictionary
        }

        self.addPersonModel!.relation = selectedRelation!.allKeys[0] as? String
        if self.addPersonModel?.relation == "people_other" ||
          self.addPersonModel?.relation == "people_service_other" {
          let otherValue: String? = selectedRelation!.allValues[0] as? String
          self.addPersonModel!.relation = self.addPersonModel!.relation! +
            " " + otherValue!
        }
      }

      if self.addPersonModel!.accessType == PersonAccessType.fullAccess {
        // Show Full Access Reminder View
        self.performSegue(withIdentifier: "AddPersonFullAccessReminderSegue", sender: self)
      } else if self.addPersonModel!.accessType == PersonAccessType.locksAlarmNotifications {
        // Show Pin Code View
        self.performSegue(withIdentifier: "AddPersonPinCodeEntrySegue", sender: self)
      } else {
        // Show Phone Number View
        self.performSegue(withIdentifier: "AddPersonRelationToPhoneEntrySegue", sender: self)
      }
    }
  }

  // MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return self.relationshipArray!.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let key = (self.relationshipArray![indexPath.row] as AnyObject).allKeys[0] as? String else {
      return UITableViewCell()
    }

    let titleString = (self.relationshipArray![indexPath.row] as AnyObject).allValues[0] as? String
    var detailString: String? = nil

    let detailsArray: NSArray? = PersonModel.subrelationArrayForRelationKey(key) as NSArray?
    if detailsArray != nil {
      if self.selectedSubRelationship != nil {
        for details in detailsArray! {
          let detailKey: String? = (details as AnyObject).allKeys[0] as? String
          let subKey: String? = self.selectedSubRelationship!.allKeys[0] as? String

          if detailKey == subKey {
            detailString = self.selectedSubRelationship?.allValues[0] as? String
            break
          }
        }
      } else {
        detailString =  (detailsArray![0] as AnyObject).allValues[0] as? String
      }
    }

    if titleString == "Other" {
      return self.selectOtherCell(tableView,
                                  indexPath: indexPath,
                                  titleString: titleString!,
                                  detailString: detailString)
    } else {
      return self.selectOptionCell(tableView,
                                   indexPath: indexPath,
                                   titleString: titleString!,
                                   detailString: detailString)
    }
  }

  func selectOptionCell(_ tableView: UITableView,
                        indexPath: IndexPath,
                        titleString: String,
                        detailString: String?) -> UITableViewCell {
    let cellIdentifier: String = "RelationOptionCell"

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    cell?.backgroundColor = UIColor.clear
    cell?.managesSelectionState = true
    cell?.selectionStyle = UITableViewCellSelectionStyle.none

    cell?.titleLabel.text = titleString

    if cell?.descriptionLabel != nil {
      if detailString != nil {
        cell?.descriptionLabel.text = detailString
      } else {
        cell?.descriptionLabel.text = ""
      }
      
      if cell?.descriptionLabel.text == "" {
        cell?.descriptionLabel.isHidden = true
        cell?.accessoryImage.isHidden = true
      } else {
        cell?.descriptionLabel.isHidden = false
        cell?.accessoryImage.isHidden = false
      }

      let accessoryImageTapRecognizer: UITapGestureRecognizer =
        UITapGestureRecognizer.init(target: cell,
                                    action:#selector(cell?.accessoryImageTapped))
      cell?.descriptionLabel.addGestureRecognizer(accessoryImageTapRecognizer)
      cell?.descriptionLabel.isUserInteractionEnabled = true
      cell?.accessoryImageTappedCompletion = {
        Void in
        if let key = (self.relationshipArray![indexPath.row] as AnyObject).allKeys[0] as? String,
          let detailsArray = PersonModel.subrelationArrayForRelationKey(key) as NSArray? {
          self.selectedIndex = indexPath.row

          if self.nextButton != nil {
            self.nextButton.isEnabled = true
          }

          tableView.selectRow(at: indexPath,
                              animated: false,
                              scrollPosition: .none)

          self.selectedDetailsArray = detailsArray
          self.performSegue(withIdentifier: "AddPersonSelectRelationDetailSegue", sender: self)
        }
      }
    }

    return cell!
  }

  func selectOtherCell(_ tableView: UITableView,
                       indexPath: IndexPath,
                       titleString: String,
                       detailString: String?) -> UITableViewCell {
    let cellIdentifier: String = "RelationOtherCell"

    let cell: AddPersonOtherRelationTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? AddPersonOtherRelationTableViewCell

    cell?.backgroundColor = UIColor.clear
    cell?.managesSelectionState = true
    cell?.selectionStyle = UITableViewCellSelectionStyle.none

    cell?.otherTextField.isUserInteractionEnabled = false
    cell?.otherTextField.tintColor = UIColor.black.withAlphaComponent(0.2)

    if cell?.otherTextField.text == "" {
      cell?.otherTextField.text = NSLocalizedString("Please Describe", comment: "")
    }

    self.otherTextField = cell?.otherTextField

    return cell!
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let relationDictionary: NSDictionary? =
      self.relationshipArray![indexPath.row] as? NSDictionary

    self.selectedIndex = indexPath.row

    if relationDictionary?.allKeys[0] as? String == "people_other" ||
      relationDictionary?.allKeys[0] as? String == "people_service_other" {
      self.otherTextField?.isUserInteractionEnabled = true
      self.otherTextField?.becomeFirstResponder()

      tableView.scrollToNearestSelectedRow(at: UITableViewScrollPosition.top,
                                           animated: true)
    }

    if self.nextButton != nil {
      self.nextButton.isEnabled = true
    }
  }

  // MARK: UITextFieldDelegate
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {

    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.otherTextField = textField as? ArcusFloatingLabelTextField

    if textField.text == "Please Describe" {
      textField.text = ""
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text == "" {
      textField.text = "Please Describe"
    }
  }

  // MARK: Keyboard Handling
  func keyboardWillShow(_ notification: Notification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue? =
      userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue
    let keyboardRectangle = keyboardFrame?.cgRectValue
    let keyboardHeight = keyboardRectangle?.height

    self.relationTableBottomSpacingConstraint.constant = keyboardHeight!
    self.relationTableView.layoutIfNeeded()
  }

  func keyboardWillHide(_ notification: Notification) {
    self.relationTableBottomSpacingConstraint.constant = self.defaultTrailingSpace
    self.relationTableView.layoutIfNeeded()
  }

  // MARK: ArcusInputAccessoryProtocol
  func doneToolBarButtonPressed(_ accessoryView: ArcusInputAccessoryView) {
    self.otherTextField?.resignFirstResponder()
  }

  // MARK: PrepareForSegue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddPersonPinCodeEntrySegue" {
      let pinCodeViewController: AddPersonPinCodeEntryViewController? =
        segue.destination
          as? AddPersonPinCodeEntryViewController
      pinCodeViewController?.addPersonModel = self.addPersonModel
    } else if segue.identifier == "AddPersonRelationToPhoneEntrySegue" {
      let phoneNumberEntryViewController: AddPersonPhoneNumberViewController? =
        segue.destination
          as? AddPersonPhoneNumberViewController
      phoneNumberEntryViewController?.addPersonModel = self.addPersonModel
    } else if segue.identifier == "AddPersonFullAccessReminderSegue" {
      let fullAccessReminderViewController: AddPersonFullAccessReminderViewController? =
        segue.destination
          as? AddPersonFullAccessReminderViewController
      fullAccessReminderViewController?.addPersonModel = self.addPersonModel
    } else if segue.identifier == "AddPersonSelectRelationDetailSegue" {
      let selectRelationDetailViewController: AddPersonSelectRelationDetailViewController? =
        segue.destination
          as? AddPersonSelectRelationDetailViewController
      selectRelationDetailViewController?
        .configureRelationDetails(self.selectedDetailsArray,
                                  completionHandler: {
                                    (selectedRelation: NSDictionary) -> Void in

                                    self.selectedSubRelationship = selectedRelation
                                    self.relationTableView.reloadData()
                                    let indexPath: IndexPath =
                                      IndexPath(row: self.selectedIndex,
                                                section: 0)
                                    self.relationTableView.selectRow(at: indexPath,
                                                                     animated: false,
                                                                     scrollPosition: .none)
        })
    }
  }
}
