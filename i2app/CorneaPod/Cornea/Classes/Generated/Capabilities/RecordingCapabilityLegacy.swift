
//
// RecordingCapabilityLegacy.swift
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

public class RecordingCapabilityLegacy: NSObject, ArcusRecordingCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: RecordingCapabilityLegacy  = RecordingCapabilityLegacy()
  
  static let RecordingTypeSTREAM: String = RecordingType.stream.rawValue
  static let RecordingTypeRECORDING: String = RecordingType.recording.rawValue
  

  
  public static func getName(_ model: RecordingModel) -> String? {
    return capability.getRecordingName(model)
  }
  
  public static func setName(_ name: String, model: RecordingModel) {
    
    
    capability.setRecordingName(name, model: model)
  }
  
  public static func getAccountid(_ model: RecordingModel) -> String? {
    return capability.getRecordingAccountid(model)
  }
  
  public static func getPlaceid(_ model: RecordingModel) -> String? {
    return capability.getRecordingPlaceid(model)
  }
  
  public static func getCameraid(_ model: RecordingModel) -> String? {
    return capability.getRecordingCameraid(model)
  }
  
  public static func getPersonid(_ model: RecordingModel) -> String? {
    return capability.getRecordingPersonid(model)
  }
  
  public static func getTimestamp(_ model: RecordingModel) -> Date? {
    guard let timestamp: Date = capability.getRecordingTimestamp(model) else {
      return nil
    }
    return timestamp
  }
  
  public static func getWidth(_ model: RecordingModel) -> NSNumber? {
    guard let width: Int = capability.getRecordingWidth(model) else {
      return nil
    }
    return NSNumber(value: width)
  }
  
  public static func getHeight(_ model: RecordingModel) -> NSNumber? {
    guard let height: Int = capability.getRecordingHeight(model) else {
      return nil
    }
    return NSNumber(value: height)
  }
  
  public static func getBandwidth(_ model: RecordingModel) -> NSNumber? {
    guard let bandwidth: Int = capability.getRecordingBandwidth(model) else {
      return nil
    }
    return NSNumber(value: bandwidth)
  }
  
  public static func getFramerate(_ model: RecordingModel) -> NSNumber? {
    guard let framerate: Double = capability.getRecordingFramerate(model) else {
      return nil
    }
    return NSNumber(value: framerate)
  }
  
  public static func getPrecapture(_ model: RecordingModel) -> NSNumber? {
    guard let precapture: Double = capability.getRecordingPrecapture(model) else {
      return nil
    }
    return NSNumber(value: precapture)
  }
  
  public static func getType(_ model: RecordingModel) -> String? {
    return capability.getRecordingType(model)?.rawValue
  }
  
  public static func getDuration(_ model: RecordingModel) -> NSNumber? {
    guard let duration: Double = capability.getRecordingDuration(model) else {
      return nil
    }
    return NSNumber(value: duration)
  }
  
  public static func getSize(_ model: RecordingModel) -> NSNumber? {
    guard let size: Int = capability.getRecordingSize(model) else {
      return nil
    }
    return NSNumber(value: size)
  }
  
  public static func getDeleted(_ model: RecordingModel) -> NSNumber? {
    guard let deleted: Bool = capability.getRecordingDeleted(model) else {
      return nil
    }
    return NSNumber(value: deleted)
  }
  
  public static func getDeleteTime(_ model: RecordingModel) -> Date? {
    guard let deleteTime: Date = capability.getRecordingDeleteTime(model) else {
      return nil
    }
    return deleteTime
  }
  
  public static func getCompleted(_ model: RecordingModel) -> NSNumber? {
    guard let completed: Bool = capability.getRecordingCompleted(model) else {
      return nil
    }
    return NSNumber(value: completed)
  }
  
  public static func getVideoCodec(_ model: RecordingModel) -> String? {
    return capability.getRecordingVideoCodec(model)
  }
  
  public static func getAudioCodec(_ model: RecordingModel) -> String? {
    return capability.getRecordingAudioCodec(model)
  }
  
  public static func view(_ model: RecordingModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRecordingView(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func download(_ model: RecordingModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRecordingDownload(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: RecordingModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRecordingDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func resurrect(_ model: RecordingModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestRecordingResurrect(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
