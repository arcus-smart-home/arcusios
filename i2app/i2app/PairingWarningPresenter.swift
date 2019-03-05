//
//  PairingWarningPresenter.swift
//  i2app
//
//  Created by Arcus Team on 7/23/18.
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

enum PairingWarningSectionType {
  case activation
  case improperlyPaired
}

struct PairingWarningSectionViewModel {
  var sectionType = PairingWarningSectionType.activation
  var sectionTitle = ""
  var sectionDescription = ""
  var buttonTitle = ""
}

struct PairingWarningViewModel {
  var sections: Variable<[PairingWarningSectionViewModel]> = Variable([])
}

protocol PairingWarningPresenter: KitSetupHelper, ArcusPairingSubsystemCapability {
  
  var pairingWarningViewModel: PairingWarningViewModel { get set }
  
  // MARK: Extended
  
  func fetchPairingWarningSectionData()
 
  func isHubOnline() -> Bool
}

extension PairingWarningPresenter {
  
  func fetchPairingWarningSectionData() {
    observeEvents()
    fetchSections()
  }
  
  func isHubOnline() -> Bool {
    guard let hub = hubModel(), !hub.isDown else {
      return false
    }
    
    return true
  }
  
  private func observeEvents() {
    guard let pairingSubsystem = pairingSubsystemModel(),
      let cache = RxCornea.shared.modelCache as? RxArcusModelCache else {
        return
    }
    
    pairingSubsystem.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchSections()
      })
      .disposed(by: disposeBag)
    
    cache.getEvents()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe( { [weak self] _ in
        self?.fetchSections()
      })
      .disposed(by: disposeBag)
  }
  
  private func fetchSections() {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
    
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
      DDLogError("Error - PairingWarningPresenter error loading kit devices.")
    }
  }
  
  private func process(kitInformationResponse response: PairingSubsystemGetKitInformationResponse) {
    guard let kitInfo = response.getKitInfo() as? [[String: AnyObject]] else {
      return
    }
    
    fetchPairingDevices(forKitInfo: kitInfo)
  }
  
  private func fetchPairingDevices(forKitInfo kitInfo: [[String: AnyObject]]) {
    guard let pairingSubsystem = pairingSubsystemModel() else {
      return
    }
    
    do {
      try requestPairingSubsystemListPairingDevices(pairingSubsystem)
        .observeOn(MainScheduler.asyncInstance)
        .subscribe( onNext: { [weak self] response in
          if let response = response as? PairingSubsystemListPairingDevicesResponse {
            self?.process(listPairingResponse: response, kitInfo: kitInfo)
          }
        })
        .disposed(by: disposeBag)
    } catch {
      DDLogError("Error - PairingWarningPresenter error loading pairing devices.")
    }
  }
  
  private func process(listPairingResponse response:PairingSubsystemListPairingDevicesResponse,
                       kitInfo: [[String: AnyObject]]) {

    guard let devices = response.getDevices() as? [[String: AnyObject]] else {
      return
    }
    
    let pairingDevices = devices.map { (device) -> PairingDeviceModel in
      PairingDeviceModel(attributes: device)
    }
    
    var sections = [PairingWarningSectionViewModel]()
    let activateCount = finishActivationCount(kitInfo: kitInfo, pairDeviceModels: pairingDevices)
    let improperlyPairedCount = improperlyPairedDeviceCount(pairDeviceModels: pairingDevices)
    
    if activateCount > 0 {
      sections.append(activationSection())
    }
    if improperlyPairedCount > 0 {
      sections.append(improperlyPairedSection())
    }
    
    pairingWarningViewModel.sections.value = sections
  }
  
  private func finishActivationCount(kitInfo: [[String: AnyObject]],
                                     pairDeviceModels: [PairingDeviceModel]) -> Int {
    var count = 0
    
    for kitInfoData in kitInfo {
      let protocolAddress = kitInfoData["protocolAddress"] as? String ?? ""
      
      if let pairDevice = pairDevice(fromPairDevices: pairDeviceModels, protocolAddress: protocolAddress),
        isPairedDeviceKit(pairedDevice: pairDevice) {
        let state = deviceState(pairingDevices: pairDeviceModels, protocolAddress: protocolAddress)
        if state == .inactive {
          count += 1
        }
      }
    }
    
    return count
  }
  
  private func improperlyPairedDeviceCount(pairDeviceModels: [PairingDeviceModel]) -> Int {
    var count = 0
    
    for pairedDevice in pairDeviceModels {
      if let state = getPairingDevicePairingState(pairedDevice),
        state == .misconfigured || state == .mispaired {
        count += 1
      }
    }
    
    return count
  }
  
  private func isPairedDeviceKit(pairedDevice: PairingDeviceModel) -> Bool {
    // If the pair device contains the "KIT" tag, then it can be filtered out of this count.
    if let tags = pairedDevice.getTags() as? [String] {
      for tag in tags where tag.uppercased() == "KIT" {
        return true
      }
    }
    
    return false
  }
  
  private func activationSection() -> PairingWarningSectionViewModel {
    var section = PairingWarningSectionViewModel()
    
    section.sectionType = .activation
    section.sectionTitle = "1 or more kit devices have not been activated."
    section.sectionDescription = "It’s best to activate all devices in your kit."
    section.buttonTitle = "FINISH ACTIVATION"
    
    return section
  }
  
  private func improperlyPairedSection() -> PairingWarningSectionViewModel {
    var section = PairingWarningSectionViewModel()
    section.sectionType = .improperlyPaired
    section.sectionTitle = "1 or more devices are improperly paired."
    section.sectionDescription = "Follow the steps to reset and reconfigure your improperly paired devices."
    section.buttonTitle = "RESOLVE"
    
    return section
  }
  
  
  private func pairingSubsystemModel() -> SubsystemModel? {
    let namespace = Constants.pairingSubsystemNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [SubsystemModel] else {
      return nil
    }
    
    return models.first
  }
  
  private func hubModel() -> HubModel? {
    let namespace = Constants.hubNamespace
    
    guard let models = RxCornea.shared.modelCache?.fetchModels(namespace) as? [HubModel] else {
        return nil
    }
    
    return models.first
  }
  
}
