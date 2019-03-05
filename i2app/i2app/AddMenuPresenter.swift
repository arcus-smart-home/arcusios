//
//  AddMenuPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/6/18.
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

import RxSwift
import Cornea

struct AddMenuViewModel {
  var rows: Variable<[AddMenuRowViewModel]> = Variable([])
  var hubDisposition = AddMenuHubDisposition.unknown
  var isAccountPremium = false
  var isUserAccountOwner = false
  var isUserPlaceOwner = false
  var needsRulesTutorial = false
  var needsScenesTutorial = false
}

enum AddMenuHubDisposition {
  case notPaired
  case allPaired
  case kitIncomplete
  case offline
  case unknown
}

enum AddMenuRowType {
  case hub
  case device
  case rule
  case scene
  case place
  case person
  case care
  case addArcus
  case section
}

struct AddMenuRowViewModel {
  var imageName = ""
  var title = ""
  var subtitle = ""
  var type = AddMenuRowType.section
}

protocol AddMenuPresenter: KitSetupHelper, ArcusPairingSubsystemCapability, ArcusPersonCapability {
  
  var addMenuViewModel: AddMenuViewModel { get set }
  
  // Extended
  
  func addMenuFetchOptions()
  
}

extension AddMenuPresenter {
  
  func addMenuFetchOptions() {
    observeEvents()
    fetchData()
  }
  
  private func observeEvents() {
    guard let hub = RxCornea.shared.settings?.currentHub,
    let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
 
    pairingSubsystem.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchData()
      })
      .disposed(by: disposeBag)
    
    hub.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchData()
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchData() {
    fetchAccountSetting()
    fetchOptions()
    fetchHubDisposition()
    fetchTutorialStates()
  }
  
  private func fetchAccountSetting() {
    addMenuViewModel.isAccountPremium = RxCornea.shared.settings?.isPremiumAccount() ?? false
    
    guard let settings = RxCornea.shared.settings,
      let currentPlace = settings.currentPlace,
      let currentAccount = settings.currentAccount,
      let currentPerson = settings.currentPerson,
      let personCurrPlaceString = getPersonCurrPlace(currentPerson) else {
        addMenuViewModel.isUserAccountOwner = false
        addMenuViewModel.isUserPlaceOwner = false
        return
    }
    
    let personOwnsAccount = currentPerson.ownsAccount(currentAccount)
    let accountOwnsPlace = currentAccount.ownsPlace(currentPlace)
    addMenuViewModel.isUserPlaceOwner = personOwnsAccount && accountOwnsPlace
    addMenuViewModel.isUserAccountOwner = !personCurrPlaceString.isEmpty
  }
  
  private func fetchTutorialStates() {
    addMenuViewModel.needsRulesTutorial = RxCornea.shared.settings?.displayRulesTutorial() ?? true
    addMenuViewModel.needsScenesTutorial = RxCornea.shared.settings?.displayScenesTutorial() ?? true
  }
  
  private func fetchOptions() {
    let shouldDisplayHubPlace = addMenuViewModel.isUserPlaceOwner && addMenuViewModel.isUserPlaceOwner
    var rows = [AddMenuRowViewModel]()
    
    let devicesSection = AddMenuRowViewModel(imageName: "device_header_313x132",
                                   title: "Devices",
                                   subtitle: "",
                                   type: .section)
    rows.append(devicesSection)
    
    let hub = AddMenuRowViewModel(imageName: "hub_purple_45x45",
                                   title: "Add a Smart Hub or Kit",
                                   subtitle: "The Heart of the System",
                                   type: .hub)
    if shouldDisplayHubPlace { rows.append(hub) }
    
    let addArcus = AddMenuRowViewModel(imageName: "hub_purple_45x45",
                                  title: "Add Arcus to Your Home",
                                  subtitle: "Turn your home into a smart home.",
                                  type: .addArcus)
    if !shouldDisplayHubPlace { rows.append(addArcus) }
    
    let device = AddMenuRowViewModel(imageName: "device_purple_45x45",
                                   title: "Add a Device",
                                   subtitle: "Pair a Device to Arcus",
                                   type: .device)
    rows.append(device)
    
    let rulesScenesSection = AddMenuRowViewModel(imageName: "rules_scenes_header_318x132",
                                   title: "Rules and Scenes",
                                   subtitle: "",
                                   type: .section)
    rows.append(rulesScenesSection)
    
    let rule = AddMenuRowViewModel(imageName: "rule_purple_45x45",
                                   title: "Add a Rule",
                                   subtitle: "Connect & Automate Devices",
                                   type: .rule)
    rows.append(rule)
    
    let scene = AddMenuRowViewModel(imageName: "scene_purple_45x45",
                                   title: "Add a Scene",
                                   subtitle: "Control Several Devices at Once",
                                   type: .scene)
    rows.append(scene)
    
    let placePersonSection = AddMenuRowViewModel(imageName: "place_person_header_313x132",
                                   title: "Place or Person",
                                   subtitle: "",
                                   type: .section)
    rows.append(placePersonSection)
    
    let place = AddMenuRowViewModel(imageName: "home_purple_45x45",
                                   title: "Add a Place",
                                   subtitle: "Add Additional Places\n(e.g. Vacation Home)",
                                   type: .place)
    if shouldDisplayHubPlace { rows.append(place) }
    
    let person = AddMenuRowViewModel(imageName: "person_purple_45x45",
                                   title: "Add a Person",
                                   subtitle: "Invite Someone",
                                   type: .person)
    rows.append(person)
    
    let careSection = AddMenuRowViewModel(imageName: "caregiving_person_header_313x132",
                                   title: "Caregiving",
                                   subtitle: "",
                                   type: .section)
    rows.append(careSection)
    
    let care = AddMenuRowViewModel(imageName: "care_purple_45x45",
                                   title: "Add a Care Behavior",
                                   subtitle: "Trigger a Care Alarm when a loved one's routine is out of the ordinary.",
                                   type: .care)
    rows.append(care)
    
    addMenuViewModel.rows.value = rows
  }
  
  private func fetchHubDisposition() {
    if RxCornea.shared.settings?.currentHub == nil {
      addMenuViewModel.hubDisposition = .notPaired
      return
    }
    
    if let pairingSubsystem = pairingSubsystemModel() {
      do {
        try requestPairingSubsystemGetKitInformation(pairingSubsystem)
          .observeOn(MainScheduler.asyncInstance)
          .subscribe( onNext: { [weak self] response in
            if let response = response as? PairingSubsystemGetKitInformationResponse {
              self?.process(kitInformationResponse: response)
            }
          })
          .disposed(by: disposeBag)
      } catch {
        DDLogError("Error - AddMenuPresenter error loading kit devices.")
      }
    }
  }
  
  private func process(kitInformationResponse response: PairingSubsystemGetKitInformationResponse) {
    guard let kitInfo = response.getKitInfo() as? [[String: AnyObject]],
    let pairingDevices = pairingDeviceModels(),
      kitInfo.count > 0 else {
      // If there are no kitted or pairing devices then all kitted devices have been paired.
      addMenuViewModel.hubDisposition = .allPaired
      return
    }
    
    // Hub Model has been removed
    guard let currentHub = RxCornea.shared.settings?.currentHub else {
      addMenuViewModel.hubDisposition = .notPaired
      return
    }
    
    for kitInfoData in kitInfo {
      let protocolAddress = kitInfoData["protocolAddress"] as? String ?? ""
      let state = deviceState(pairingDevices: pairingDevices, protocolAddress: protocolAddress)
      
      if state == .inactive {
        addMenuViewModel.hubDisposition = currentHub.isDown ? .offline : .kitIncomplete
        return
      }
    }
    
    // If there are kitted devices but none of them is inactive then the Kit Setup is not needed.
    addMenuViewModel.hubDisposition = .allPaired
  }
  
  private func pairingDeviceModels() -> [PairingDeviceModel]? {
    let namespace = Constants.pairingDeviceNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [PairingDeviceModel] else {
      return nil
    }
    
    return models
  }
  
  private func pairingSubsystemModel() -> SubsystemModel? {
    let namespace = Constants.pairingSubsystemNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [SubsystemModel] else {
      return nil
    }
    
    return models.first
  }
  
}

