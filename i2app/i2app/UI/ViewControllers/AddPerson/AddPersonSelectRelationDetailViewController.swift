//
//  AddPersonSelectRelationDetailViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/29/16.
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

class AddPersonSelectRelationDetailViewController: AddPersonSelectRelationViewController {
  var completionHandler: ((_ selectedRelation: NSDictionary) -> Void)?
  
  // MARK: View LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: UI Configuration
  override func configureUI() {
    self.relationTableView.estimatedRowHeight = 70
    self.relationTableView.rowHeight = UITableViewAutomaticDimension
  }
  
  func configureRelationDetails(_ detailsArray: NSArray?,
                                completionHandler: ((_ selectedRelation: NSDictionary) -> Void)?) {
    if detailsArray != nil {
      self.relationshipArray = detailsArray
    }
    
    self.completionHandler = completionHandler
  }
  
  // MARK: IBActions
  @IBAction func closeButtonPressed(_ sender: UIButton) {
    if self.otherTextField?.isFirstResponder == true {
      self.otherTextField?.resignFirstResponder()
    }
    
    if self.selectedIndex >= 0 {
      let relationDictionary: NSDictionary? = self.relationshipArray?[self.selectedIndex]
        as? NSDictionary
      
      var selectedRelation: NSDictionary? = nil
      if relationDictionary?.allKeys[0] as? String == "people_service_other" {
        var otherString: String = "other"
        if let text = self.otherTextField?.text, text != "Please Describe" {
          otherString = text
        }
        selectedRelation = ["people_service_other": otherString]
      } else {
        selectedRelation = relationDictionary
      }
      self.completionHandler!(selectedRelation!)
    }
    
    self.dismiss(animated: true, completion: {})
  }
  
  // MARK: UITableViewDelegate
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    super.tableView(tableView, didSelectRowAt: indexPath)
  }
}
