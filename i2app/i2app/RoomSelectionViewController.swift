//
//  RoomSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/17/18.
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

class RoomSelectionViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var deviceAddress = ""
  
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
   Required by RoomSelectionPresenter
   */
  var roomSelectionData = CustomizationRoomSelectionViewModel()
  
  let tableViewContentSizeKey = "contentSize"
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  static func create() -> RoomSelectionViewController? {
    let storyboard = UIStoryboard(name: "RoomSelection", bundle: nil)
    let id = "RoomSelectionViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? RoomSelectionViewController else {
        return nil
    }
    
    return viewController
  }
  
  deinit {
    tableView.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure Views
    configureViews()
    
    roomSelectionFetchData()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      updateTableViewHeight()
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    roomSelectionSaveSelectedRoom()
    addCustomization(PairingCustomizationStepType.room.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeRoom)
    
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    
    actionButton.isEnabled = roomSelectionData.selectedRoomIdentifier != ""
    
    tableView.tableFooterView = UIView()
    tableView.addObserver(self,
                          forKeyPath: tableViewContentSizeKey,
                          options: .new,
                          context: nil)
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
    if let descriptionParagraphs = currentStepViewModel()?.description, descriptionParagraphs.count > 0 {
      descriptionLabel.text = descriptionParagraphs.joined(separator: "\n\n")
    }
  }
  
  fileprivate func updateViews() {
    actionButton.isEnabled = roomSelectionData.selectedRoomIdentifier != ""
    tableView.reloadData()
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
}

extension RoomSelectionViewController: PairingCustomizationStepPresenter {
  
}

extension RoomSelectionViewController: RoomSelectionPresenter {
  
  func roomSelectionUpdated() {
    updateViews()
  }
  
}

extension RoomSelectionViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return roomSelectionData.rooms.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard roomSelectionData.rooms.count > indexPath.row,
      let cell = tableView.dequeueReusableCell(withIdentifier: "RoomSelectionCell")
        as? RoomSelectionCell else {
          return UITableViewCell()
    }
    
    let room = roomSelectionData.rooms[indexPath.row]
    let selected = roomSelectionData.selectedRoomIdentifier
    let check = room.identifier == selected ? "check_teal_30x30" : "uncheck_30x30"
    cell.roomLabel.text = room.name
    cell.checkmarkImageView.image = UIImage(named: check)
    
    return cell
  }
  
}

extension RoomSelectionViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard roomSelectionData.rooms.count > indexPath.row else {
      return
    }
    
    roomSelectionData.selectedRoomIdentifier = roomSelectionData.rooms[indexPath.row].identifier
    updateViews()
  }
  
}
