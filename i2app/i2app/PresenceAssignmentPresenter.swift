//
//  PresenceAssignmentPresenter.swift
//  i2app
//
//  Created by Arcus Team on 3/22/18.
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
import Cornea

protocol PresenceAssignmentPresenter: class {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   Disposable object to stop observations on the device model.
   */
  var deviceModelDisposable: Disposable? { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   List of view models containing the current choices. A choice can either be a person or an unassigned
   option.
   */
  var presenceAssignmentChoices: [PresenceAssignmentChoiceViewModel] { get set }
  
  /**
   Called whenever there is a chage in the choices available.
   */
  func presenceAssignmentChoicesUpdated()
  
  // MARK: Extended
  
  /**
   Takes an assignment choice and uses it to assign it to the device model of the device being customized.
   - parameter choice: The view model for the choice to be selected.
   */
  func presenceAssignmentSelect(choice: PresenceAssignmentChoiceViewModel)
  
  /**
   Retrieves the available choices for presence assignment.
   */
  func presenceAssignmentFetchChoices()
  
  /**
   Starts observing changes on the device model for the current address. When a change occurs, the choices
   for the device will be re-fetched and the view should eventually update.
   */
  func presenceAssignmentObserveChanges()
}

extension PresenceAssignmentPresenter {
  
  func presenceAssignmentObserveChanges() {
    guard let model = deviceModel() else {
      return
    }
    
    let observer = model.getEvents()
    deviceModelDisposable = observer
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( onNext: { [weak self] _ in
        self?.presenceAssignmentFetchChoices()
      })
    
    deviceModelDisposable?.addDisposableTo(disposeBag)
  }
  
  func presenceAssignmentSelect(choice: PresenceAssignmentChoiceViewModel) {
    guard let cache = RxCornea.shared.modelCache,
      let personModels = cache.fetchModels(Constants.personNamespace) as? [PersonModel],
      let device = deviceModel() else {
        return
    }
    
    // Unassign if no person is selected
    if choice.identifier == "" {
      device.unassignPerson({}, failedBlock: {})
    } else {
      for person in personModels where person.modelId == choice.identifier {
        device.assignPerson(person, completeBlock: {}, failedBlock: {})
      }
    }
  }
  
  func presenceAssignmentFetchChoices() {
    guard let cache = RxCornea.shared.modelCache,
    let personModels = cache.fetchModels(Constants.personNamespace) as? [PersonModel],
    let device = deviceModel() else {
      return
    }
    
    let assignedPerson = device.getAssignedPerson()

    // First Choice
    var unassigned = PresenceAssignmentChoiceViewModel()
    unassigned.choiceText = "Unassigned"
    if let image = UIImage(named: "person_unassigned_45x45") {
      unassigned.choiceImage = image
    }
    if assignedPerson == nil {
      unassigned.isSelected = true
    }

    var choices = [PresenceAssignmentChoiceViewModel]()
    
    for personModel in personModels {
      var choice = PresenceAssignmentChoiceViewModel()
      choice.choiceText = personModel.fullName
      choice.identifier = personModel.modelId
      if assignedPerson == personModel {
        choice.isSelected = true
      }
      if let image = personModel.image {
        choice.choiceImage = image
      } else if let image = UIImage(named: "person_45x45") {
        choice.choiceImage = image
      }
      choices.append(choice)
    }
    
    choices = choices.sorted { $0.choiceText.lowercased() < $1.choiceText.lowercased() }
    choices.insert(unassigned, at: 0)
    
    presenceAssignmentChoices = choices
    presenceAssignmentChoicesUpdated()
  }
  
  private func selectChoice(withIdentifier identifier: String) {
    for (index, choice) in presenceAssignmentChoices.enumerated() where choice.identifier == identifier {
      presenceAssignmentChoices[index].isSelected = true
    }
  }
  
  private func deselectChoice() {
    for (index) in presenceAssignmentChoices.indices {
      presenceAssignmentChoices[index].isSelected = false
    }
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
