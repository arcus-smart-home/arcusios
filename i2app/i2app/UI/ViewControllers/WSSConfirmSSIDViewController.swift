//
//  WSSConfirmSSIDViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/14/16.
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

class WSSConfirmSSIDViewController: UIViewController,
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate {
    @IBOutlet var tableView: UITableView!

    internal var SSID: String = ""
    var confirmSSID: String = ""

    var ssidTextField: ArcusFloatingLabelTextField?
    var confirmSSSIDTextField: ArcusFloatingLabelTextField?
    var ssidClearButton: UIButton? {
        didSet {
            self.ssidClearButton?.addTarget(self,
                                            action: #selector(clearButtonPressed(_:)),
                                            for: .touchUpInside)
        }
    }
    var confirmSSIDClearButton: UIButton? {
        didSet {
            self.confirmSSIDClearButton?.addTarget(self,
                                            action: #selector(clearButtonPressed(_:)),
                                            for: .touchUpInside)
        }
    }

    internal var completion: ((_ SSID: String, _ confrimSSID: String) -> Void)!

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavBar()
        self.configureBackground()
        self.configureTableView()
    }

    // MARK: UI Configuration
    func configureNavBar() {
        self.navBar(withTitle: self.navigationItem.title,
                             andRightButtonText: "DONE",
                             with: #selector(doneButtonPressed(_:)))
    }

    func configureBackground() {
        self.setBackgroundColorToDashboardColor()
        self.addWhiteOverlay(BackgroupOverlayMiddleLevel)
    }

    func configureTableView() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = nil
    }

    // MARK: IBActions
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        if sender == self.ssidClearButton {
            self.ssidTextField?.text = ""
            self.SSID = ""
        } else if sender == self.confirmSSIDClearButton {
            self.confirmSSSIDTextField?.text = ""
            self.confirmSSID = ""
        }
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        if self.SSID.count > 0 &&
            self.confirmSSID.count > 0 &&
            self.SSID == self.confirmSSID {

            self.completion(self.SSID, self.confirmSSID)
            self.dismiss(animated: true, completion: nil)
        } else {
            // SHOW ERROR
        }
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsTextFieldTableViewCell? = tableView
            .dequeueReusableCell(withIdentifier: "NetworkTextFieldCell") as? SettingsTextFieldTableViewCell
        cell?.selectionStyle = .none

        cell?.textField.textColor = UIColor.black
        cell?.textField.floatingLabelTextColor = UIColor.black.withAlphaComponent(0.4)
        cell?.textField.floatingLabelActiveTextColor = UIColor.black
        cell?.textField.activeSeparatorColor = UIColor.black.withAlphaComponent(0.4)
        cell?.textField.separatorColor = UIColor.black.withAlphaComponent(0.4)
      if indexPath.row == 0 {
        cell?.textField.text = self.SSID
        cell?.textField.placeholder = "SSID"
      } else {
        cell?.textField.text = self.confirmSSID
        cell?.textField.placeholder = "Confirm SSID"
      }

        cell?.textField.setupType(AccountTextFieldTypeGeneral,
                                  fontType: FontDataType_Medium_18_Black_NoSpace,
                                  placeholderFontType: FontDataTypeAccountTextFieldPlaceholder)

        cell?.clearButton.isHidden = (cell!.textField.text?.count == 0)

        if indexPath.row == 0 {
            self.ssidTextField = cell?.textField
            self.ssidClearButton = cell?.clearButton!
        } else {
            self.confirmSSSIDTextField = cell?.textField
            self.confirmSSIDClearButton = cell?.clearButton!
        }

        return cell!
    }

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.ssidTextField?.becomeFirstResponder()
        } else {
            self.confirmSSSIDTextField?.becomeFirstResponder()
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.ssidTextField {
            self.SSID = textField.text!
        } else if textField == self.confirmSSSIDTextField {
            self.confirmSSID = textField.text!
        }
    }
}
