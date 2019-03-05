//
//  i2AppServiceEventPublisher.swift
//  i2app
//
//  Created by Arcus Team on 3/20/18.
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

/// An Internal Class that hold the memory of our Services and creates them on startup with the
/// AppDelegate's help
internal class ApplicationServiceEventPublisher: ArcusApplicationServiceFactory,
ArcusApplicationServiceEventPublisher {

  /// i2App classes should use this shared instance
  static let shared: ApplicationServiceEventPublisher = ApplicationServiceEventPublisher()

  /// To conform to ArcusApplicationServiceEventPublisher
  /// _Our services listen to this observable_
  var eventObservable = PublishSubject<ArcusApplicationServiceEvent>()

  /// Holds the memeory of all the services in the application, keep it secret keep it safe
  private var applicationServices: [ArcusApplicationServiceProtocol]?

  init() {
    applicationServices = buildApplicationServices(eventPublisher: self)
  }

  /// We are going to kick and scream to our logs if we ever get deinitalized
  deinit {
    DDLogWarn("MAJOR ISSUE IN ApplicationServiceEventPublisher: This class should never be deallocated")
  }
}
