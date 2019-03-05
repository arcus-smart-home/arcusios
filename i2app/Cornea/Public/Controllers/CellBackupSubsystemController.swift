//
//  CellBackupSubsystemController.swift
//  i2app
//
//  Created by Arcus Team on 7/19/16.
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
import Cornea

enum CellBackupState {
    case cellular       // Hub on Cellular
    case broadband      // Hub on Broadband
    case suspended      // Sim Suspended: Need to Call
    case notReady       // Not Ready: Update Plan
    case configuration  // Needs Configuration
}

class CellBackupSubsystemController: NSObject, SubsystemProtocol {

    var subsystemModel: SubsystemModel
    var numberOfDevices: Int32 = 0
    unowned(unsafe) var allDeviceIds: NSArray = NSArray()

    init(attributes: [String: AnyObject]) {
        self.subsystemModel = SubsystemModel(attributes: attributes)
    }

    func state() -> CellBackupState {
        var state: CellBackupState = CellBackupState.broadband

        if let status = CellBackupSubsystemCapability.getStatusFrom(self.subsystemModel) {

            switch status {
            case kEnumCellBackupSubsystemStatusACTIVE:
                state = CellBackupState.cellular
                break
            case kEnumCellBackupSubsystemStatusERRORED:
                if let errorState = CellBackupSubsystemCapability.getErrorState(from: self.subsystemModel) {
                    switch errorState {
                    case kEnumCellBackupSubsystemErrorStateBANNED:
                        state = CellBackupState.suspended
                        break
                    case kEnumCellBackupSubsystemErrorStateNOSIM:
                        state = CellBackupState.configuration
                        break
                    case kEnumCellBackupSubsystemErrorStateNOTPROVISIONED:
                        state = CellBackupState.configuration
                        break
                    default:
                        break
                    }
                }
                break
            case kEnumCellBackupSubsystemStatusNOTREADY:
                if CellBackupSubsystemCapability.getNotReadyState(from: self.subsystemModel)
                    == kEnumCellBackupSubsystemNotReadyStateNEEDSSUB {
                    state = CellBackupState.notReady
                }
                break
            default:
                break
            }

        }

        return state
    }

}
