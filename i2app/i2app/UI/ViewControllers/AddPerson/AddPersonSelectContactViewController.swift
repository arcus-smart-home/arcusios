//
//  AddPersonSelectContactViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/26/16.
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

class AddPersonSelectContactViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate, UITextFieldDelegate {
  @IBOutlet var closeButton: ArcusButton!
  @IBOutlet var headerLabel: ArcusLabel!
  @IBOutlet var searchTextField: ArcusFloatingLabelTextField!
  @IBOutlet var searchClearButton: ArcusButton!
  @IBOutlet var contactsTableView: UITableView!

  let sections = ["A", "B", "C", "D", "E",
                  "F", "G", "H", "I", "J",
                  "K", "L", "M", "N", "O",
                  "P", "Q", "R", "S", "T",
                  "U", "V", "W", "X", "Y",
                  "Z", "#"]
  var contactsArray: [ContactModel]?
  var sortContacts: [[String : [ContactModel]?]]? = []
  var completionHandler: ((_ selectedContact: ContactModel) -> Void)?

  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    self.configureSearchUI()
    self.contactsTableView.register(UINib(nibName: "ArcusTwoLabelTableViewSectionHeader",
                                          bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: "sectionHeader")
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: UI Configuration
  func configureSearchUI() {
    let textColor: UIColor = self.searchTextField.textColor!.withAlphaComponent(0.2)

    self.searchTextField.floatingLabelTextColor = textColor
    self.searchTextField.floatingLabelActiveTextColor = textColor
    self.searchTextField.separatorColor = textColor
    self.searchTextField.activeSeparatorColor = textColor
    self.searchTextField.tintColor = textColor
  }

  func configureTextFieldKerning(_ textField: UITextField) {
    let text: String = textField.text!
    let attributedString: NSMutableAttributedString =
      NSMutableAttributedString.init(string: text)

    let range: NSRange = NSRange(location: 0, length: text.characters.count)

    attributedString.addAttribute(NSKernAttributeName, value: 2.0, range: range)
    textField.attributedText = attributedString
  }

  // MARK: Data Configuration
  internal func configureWithContacts(_ contacts: [ContactModel]?,
                                      completionHandler: ((_ selectedContact: ContactModel) -> Void)?) {
    self.contactsArray = contacts
    self.completionHandler = completionHandler

    sortContacts(self.contactsArray!)
  }

  func sortContacts(_ contacts: [ContactModel]) {
    self.sortContacts = []
    for section in sections {
      let sortPredicate = NSPredicate(format: "filterName beginswith[c] %@", section)

      let sectionArray = contacts.filter {
        sortPredicate.evaluate(with: $0)
      }

      if sectionArray.count > 0 {
        let sectionDictionary: [String: [ContactModel]?] =
          [section: sectionArray]
        self.sortContacts!.append(sectionDictionary)
      }
    }
  }

  func filterContactsWithSearch(_ searchString: String, contacts: [ContactModel]) {
    let filterPredicate =
      NSPredicate(format: "lastName CONTAINS[c] %@ OR firstName CONTAINS[c] %@",
                  searchString,
                  searchString)

    let searchArray = contacts.filter {
      filterPredicate.evaluate(with: $0)
    }

    if searchArray.count >= 0 {
      self.sortContacts(searchArray)
    }
  }

  func clearSearchFilter() {
    self.searchTextField.text = nil
    self.searchTextField.resignFirstResponder()

    self.searchClearButton.isHidden = true

    self.sortContacts(self.contactsArray!)
    self.contactsTableView.reloadData()
  }

  // MARK: IBActions
  @IBAction func clearSearchButtonPressed(_ sender: UIButton) {
    self.clearSearchFilter()
  }

  @IBAction func closeButtonPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: {})
  }

  // MARK: UITableViewDataSourcste
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.sortContacts!.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionDictionary: [String: [ContactModel]?] =
      self.sortContacts![section]

    return Array(sectionDictionary.values)[0]!.count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    var header: ArcusTwoLabelTableViewSectionHeader? =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        as? ArcusTwoLabelTableViewSectionHeader
    if header == nil {
      header = ArcusTwoLabelTableViewSectionHeader(reuseIdentifier: "sectionHeader")
    }

    header?.hasBlurEffect = true
    header?.backingView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)

    let sectionDictionary: [String: [ContactModel]?] =
      self.sortContacts![section]
    if sectionDictionary.keys.count > 0 {
      header?.mainTextLabel.text = Array(sectionDictionary.keys)[0]
      header?.mainTextLabel.textColor = UIColor.black

      header?.accessoryTextLabel.text = ""
    }

    return header
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "ArcusSelectionCell"

    let cell: ArcusSelectOptionTableViewCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? ArcusSelectOptionTableViewCell

    let sectionDictionary: [String: [ContactModel]?] =
      self.sortContacts![indexPath.section]
    let currentContact: ContactModel = Array(sectionDictionary.values)[0]![indexPath.row]

    cell?.titleLabel.text = currentContact.firstName
    cell?.descriptionLabel.text = currentContact.lastName

    if currentContact.image != nil {
      cell?.detailImage.image = currentContact.image
      cell?.detailImage.layer.cornerRadius = cell!.detailImage.frame.size.height / 2
    } else {
      cell?.detailImage.image = UIImage(named: "account_user")
      cell?.detailImage.layer.cornerRadius = 0
    }

    return cell!
  }

  // MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sectionDictionary: [String: [ContactModel]?] =
      self.sortContacts![indexPath.section]
    let currentContact: ContactModel = Array(sectionDictionary.values)[0]![indexPath.row]

    self.completionHandler!(currentContact)
    tableView.deselectRow(at: indexPath, animated: false)
  }

  // MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.resignFirstResponder()
    return true
  }

  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    var searchString: String = ""

    // Deletion Case
    if string == "" {
      searchString =
        (textField.text! as NSString).replacingCharacters(in: range,
                                                          with: string)
    } else {
      searchString = textField.text! + string
    }

    if searchString != "" {
      self.searchClearButton.isHidden = false
      self.filterContactsWithSearch(searchString, contacts: self.contactsArray!)
      self.contactsTableView.reloadData()
    } else {
      self.clearSearchFilter()
    }
    self.configureTextFieldKerning(textField)

    return true
  }
}
