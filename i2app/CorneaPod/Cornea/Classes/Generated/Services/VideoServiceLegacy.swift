
//
// VideoServiceLegacy.swift
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

public class VideoServiceLegacy: NSObject, ArcusVideoService, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let service: VideoServiceLegacy = VideoServiceLegacy()
  
  
  public static func listRecordings(_ placeId: String, all: Bool, type: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceListRecordings(placeId, all: all, type: type))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pageRecordings(_ placeId: String, limit: Int, token: String, all: Bool, inprogress: Bool, type: String, latest: Double, earliest: Double, cameras: [String], tags: [String]) -> PMKPromise {
  
    
    
    
    
    
    
    let latest: Date = Date(milliseconds: latest)
    let earliest: Date = Date(milliseconds: earliest)
    
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServicePageRecordings(placeId, limit: limit, token: token, all: all, inprogress: inprogress, type: type, latest: latest, earliest: earliest, cameras: cameras, tags: tags))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func startRecording(_ placeId: String, accountId: String, cameraAddress: String, stream: Bool, duration: Int) -> PMKPromise {
  
    
    
    
    
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceStartRecording(placeId, accountId: accountId, cameraAddress: cameraAddress, stream: stream, duration: duration))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func stopRecording(_ placeId: String, recordingId: String) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceStopRecording(placeId, recordingId: recordingId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getQuota(_ placeId: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceGetQuota(placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getFavoriteQuota(_ placeId: String) -> PMKPromise {
  
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceGetFavoriteQuota(placeId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteAll(_ placeId: String, includeFavorites: Bool) -> PMKPromise {
  
    
    
    
    do {
      return try service.promiseForObservable(service.requestVideoServiceDeleteAll(placeId, includeFavorites: includeFavorites))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
