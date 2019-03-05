//
//  MultiButtonEditViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/26/18.
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

class MultiButtonEditViewController: UIViewController {
  
  var deviceAddress = ""
  
  var buttonType = ""
  
  var buttonName = ""
  
  var disposeBag = DisposeBag()
  
  var multiButtonEditData = MultiButtonEditViewModel()
  
  var templateIds = [String]()
  
  var templateNames = [String]()
  
  var currentTemplateId = ""
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  let tableViewContentSizeKey = "contentSize"
  
  deinit {
    tableView.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    multiButtonEditFetchData()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      updateTableViewHeight()
    }
  }
  
  @IBAction func saveButtonPressed(_ sender: Any) {
    multiButtonEditSaveSelection()
  }
  
  @IBAction func cancelButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  private func configureViews() {
    addScleraStyleToNavigationTitle()
    
    tableView.tableFooterView = UIView()
    tableView.addObserver(self,
                          forKeyPath: tableViewContentSizeKey,
                          options: .new,
                          context: nil)
  }
  
  fileprivate func updateViews() {
    titleLabel.text = "What do you want \(buttonName) to do?"
    navigationItem.title = buttonName
    
    tableView.reloadData()
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
  fileprivate func selectActionAtIndex(_ selectedIndex: Int) {
    for (index, action) in multiButtonEditData.actions.enumerated() {
      if index == selectedIndex {
        currentTemplateId = action.templateId
        multiButtonEditData.actions[index].isSelected = true
      } else {
        multiButtonEditData.actions[index].isSelected = false
      }
    }
    
    updateViews()
  }
  
}

extension MultiButtonEditViewController: MultiButtonEditPresenter {
  
  func multiButtonEditUpdated() {
    updateViews()
  }
  
  func multiButtonEditSaveCompleted() {
    dismiss(animated: true, completion: nil)
  }
  
}

extension MultiButtonEditViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return multiButtonEditData.actions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard multiButtonEditData.actions.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "MultiButtonEditCell") as?
      MultiButtonEditCell else {
        return UITableViewCell()
    }
    
    let viewModel = multiButtonEditData.actions[indexPath.row]
    let check = viewModel.isSelected ? "check_teal_30x30" : "uncheck_30x30"
    cell.checkImage.image = UIImage(named: check)
    cell.actionLabel.text = viewModel.name
    
    return cell
  }
  
}

extension MultiButtonEditViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectActionAtIndex(indexPath.row)
  }
  
}
