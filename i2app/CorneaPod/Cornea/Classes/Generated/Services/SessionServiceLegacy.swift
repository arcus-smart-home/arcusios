
//
// SessionServiceLegacy.swift
//
// Generated on 20/09/18
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

import Foundation
import PromiseKit
import RxSwift

// MARK: Legacy Support

public class SessionServiceLegacy: NSObject, ArcusSessionService, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let service: SessionServiceLegacy = SessionServiceLegacy()
  
  
  public static func setActivePlace(_ placeId: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceSetActivePlace(placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func log(_ category: String, code: String, message: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceLog(category, code: code, message: message))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func tag(_ name: String, context: [String: String]) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceTag(name, context: context))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listAvailablePlaces()  -> PMKPromise { 
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceListAvailablePlaces())
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getPreferences()  -> PMKPromise { 
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceGetPreferences())
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func setPreferences(_ prefs: Any) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceSetPreferences(prefs))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resetPreference(_ prefKey: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceResetPreference(prefKey))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func lockDevice(_ deviceIdentifier: String, reason: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestSessionServiceLockDevice(deviceIdentifier, reason: reason))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
