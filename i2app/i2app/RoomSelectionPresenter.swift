//
//  RoomSelectionPresenter.swift
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
import Cornea

struct CustomizationRoomViewModel {
  var identifier = ""
  var name = ""
}

struct CustomizationRoomSelectionViewModel {
  var selectedRoomIdentifier = ""
  var rooms = [CustomizationRoomViewModel]()
}

protocol RoomSelectionPresenter: ArcusHaloCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get set }
  
  /**
   Required by RxSwift to track observables.
   */
  var disposeBag: DisposeBag { get }
  
  /**
   View model containing the data needed for the room selection view.
   */
  var roomSelectionData: CustomizationRoomSelectionViewModel { get set }
  
  /**
   Called whenever there is a chage in the choices available.
   */
  func roomSelectionUpdated()
  
  // MARK: Extended
  
  /**
   Saves the selected room.
   */
  func roomSelectionSaveSelectedRoom()
  /**
   Retrieves the data to be used by the view. Calls roomSelectionUpdated() once the data has been
   retrieved.
   */
  func roomSelectionFetchData()
  
}

extension RoomSelectionPresenter {
  
  func roomSelectionSaveSelectedRoom() {
    guard let device = deviceModel() else {
      return
    }
    
    if let haloType = HaloRoom(rawValue: roomSelectionData.selectedRoomIdentifier) {
      setHaloRoom(haloType, model: device)
      _ = device.commit()
    }
  }
  
  func roomSelectionFetchData() {
    guard let device = deviceModel() else {
      return
    }
    
    var viewModels = [CustomizationRoomViewModel]()
    
    if let selectedRoom = getHaloRoom(device) {
      roomSelectionData.selectedRoomIdentifier = selectedRoom.rawValue
    } else {
      roomSelectionData.selectedRoomIdentifier = HaloRoom.none.rawValue
    }
    
    if let rooms = getHaloRoomNames(device) {
      for room in rooms {
        var roomViewModel = CustomizationRoomViewModel()
        roomViewModel.identifier = room.key
        roomViewModel.name = room.value
        viewModels.append(roomViewModel)
      }
    }

    roomSelectionData.rooms = viewModels.sorted { $0.name < $1.name }
    roomSelectionUpdated()
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
