
//
// IcstDocumentCapabilityLegacy.swift
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

public class IcstDocumentCapabilityLegacy: NSObject, ArcusIcstDocumentCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: IcstDocumentCapabilityLegacy  = IcstDocumentCapabilityLegacy()
  
  static let IcstDocumentDocTypeENDSESSION: String = IcstDocumentDocType.endsession.rawValue
  static let IcstDocumentDocTypeSMARTPLUG: String = IcstDocumentDocType.smartplug.rawValue
  static let IcstDocumentDocTypeFIRMWARE: String = IcstDocumentDocType.firmware.rawValue
  

  
  public static func getCreated(_ model: IcstDocumentModel) -> Date? {
    guard let created: Date = capability.getIcstDocumentCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getId(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentId(model)
  }
  
  public static func getDocType(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentDocType(model)?.rawValue
  }
  
  public static func setDocType(_ docType: String, model: IcstDocumentModel) {
    guard let docType: IcstDocumentDocType = IcstDocumentDocType(rawValue: docType) else { return }
    
    capability.setIcstDocumentDocType(docType, model: model)
  }
  
  public static func getDocument(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentDocument(model)
  }
  
  public static func setDocument(_ document: String, model: IcstDocumentModel) {
    
    
    capability.setIcstDocumentDocument(document, model: model)
  }
  
  public static func getModified(_ model: IcstDocumentModel) -> Date? {
    guard let modified: Date = capability.getIcstDocumentModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func getModifiedBy(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentModifiedBy(model)
  }
  
  public static func getVersion(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentVersion(model)
  }
  
  public static func getApproved(_ model: IcstDocumentModel) -> NSNumber? {
    guard let approved: Bool = capability.getIcstDocumentApproved(model) else {
      return nil
    }
    return NSNumber(value: approved)
  }
  
  public static func getApprovedBy(_ model: IcstDocumentModel) -> String? {
    return capability.getIcstDocumentApprovedBy(model)
  }
  
  public static func setApprovedBy(_ approvedBy: String, model: IcstDocumentModel) {
    
    
    capability.setIcstDocumentApprovedBy(approvedBy, model: model)
  }
  
  public static func createDocument(_  model: IcstDocumentModel, id: String, docType: String, document: String) -> PMKPromise {
  
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIcstDocumentCreateDocument(model, id: id, docType: docType, document: document))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func approveDocument(_ model: IcstDocumentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestIcstDocumentApproveDocument(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func rejectDocument(_ model: IcstDocumentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestIcstDocumentRejectDocument(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listDocumentMetadata(_  model: IcstDocumentModel, docType: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestIcstDocumentListDocumentMetadata(model, docType: docType))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func deleteDocument(_ model: IcstDocumentModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestIcstDocumentDeleteDocument(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
