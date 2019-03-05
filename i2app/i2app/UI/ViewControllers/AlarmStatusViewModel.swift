//
//  AlarmStatusViewModel.swift
//  i2app
//
//  Created by Arcus Team on 2/16/17.
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

import Cornea

class AlarmStatusViewModel {
  var alarmType: AlarmType
  var status: String
  var isEmpty = false
  var isAlarming = false
  var isPromonitored = false
  var securityState: AlarmSecurityStatusState?
  var triggeredDevices = [DeviceModel]()
  var ringViewModel: AlarmStatusRingViewModel?
  var iconName: String {
    switch alarmType {
    case AlarmType.CO:
      return "co_icon_white"
    case AlarmType.Security:
      return "sec_icon_white"
    case AlarmType.Panic:
      return "sec_icon_white"
    case AlarmType.Smoke:
      return "smoke_icon_white"
    case AlarmType.Water:
      return "leak_icon_white"
    }
  }

  required init(alarmType: AlarmType,
                status: String,
                isEmpty: Bool,
                isAlarming: Bool,
                securityState: AlarmSecurityStatusState?,
                ringViewModel: AlarmStatusRingViewModel?) {
    self.alarmType = alarmType
    self.status = status
    self.isEmpty = isEmpty
    self.isAlarming = isAlarming
    self.securityState = securityState
    self.ringViewModel = ringViewModel
  }

  convenience init(alarmType: AlarmType,
                   status: String,
                   isEmpty: Bool,
                   isAlarming: Bool,
                   ringViewModel: AlarmStatusRingViewModel?) {
    self.init(alarmType: alarmType,
              status: status,
              isEmpty: isEmpty,
              isAlarming: isAlarming,
              securityState: nil,
              ringViewModel: ringViewModel)
  }

  convenience init (alarmType: AlarmType, status: String) {
    self.init(alarmType: alarmType,
              status: status,
              isEmpty: true,
              isAlarming: false,
              ringViewModel: nil)
  }
}
