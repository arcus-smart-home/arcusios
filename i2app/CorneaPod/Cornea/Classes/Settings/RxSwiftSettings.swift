//
//  RxSwiftSettings.swift
//  i2app
//
//  Created by Arcus Team on 10/31/17.
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
import CocoaLumberjack

extension Constants {
  public static let kPlaceChangedNotification: String = "PlaceChangedNotification"
}

extension Notification.Name {
  public static let placeChanged = Notification.Name(Constants.kPlaceChangedNotification)
}

public protocol ArcusSettingsEvent: ArcusEvent {}

public struct CurrentAccountChangeEvent: ArcusSettingsEvent {
  public var currentAccount: ArcusModel?

  public init(currentAccount: ArcusModel?) {
    self.currentAccount = currentAccount
  }
}

public struct CurrentHubChangeEvent: ArcusSettingsEvent {
  public var currentHub: ArcusModel?

  public init(currentHub: ArcusModel?) {
    self.currentHub = currentHub
  }
}

public struct CurrentPersonChangeEvent: ArcusSettingsEvent {
  public var currentPerson: ArcusModel?

  public init(currentPerson: ArcusModel?) {
    self.currentPerson = currentPerson
  }
}

public struct CurrentPlaceChangeEvent: ArcusSettingsEvent, ArcusNotifiableEvent {
  public var currentPlace: ArcusModel?

  // MARK: `ArcusNotifiableEvent`

  public var notificationName: Notification.Name {
    return Notification.Name.placeChanged
  }

  public var notificationObject: Any? {
    return currentPlace?.modelId
  }

  public init(currentPlace: ArcusModel?) {
    self.currentPlace = currentPlace
  }
}

public struct CurrentSettingsClearedEvent: ArcusSettingsEvent {}

public protocol RxSwiftSettings {
  var eventObservable: PublishSubject<ArcusSettingsEvent> { get }

  func getEvents() -> Observable<ArcusSettingsEvent>
}

extension RxSwiftSettings {
  public func getEvents() -> Observable<ArcusSettingsEvent> {
    return eventObservable.asObservable()
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
  }
}
