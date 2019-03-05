
//
// IcstDocumentCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var icstDocumentNamespace: String = "icstdoc"
  public static var icstDocumentName: String = "IcstDocument"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let icstDocumentCreated: String = "icstdoc:created"
  static let icstDocumentId: String = "icstdoc:id"
  static let icstDocumentDocType: String = "icstdoc:docType"
  static let icstDocumentDocument: String = "icstdoc:document"
  static let icstDocumentModified: String = "icstdoc:modified"
  static let icstDocumentModifiedBy: String = "icstdoc:modifiedBy"
  static let icstDocumentVersion: String = "icstdoc:version"
  static let icstDocumentApproved: String = "icstdoc:approved"
  static let icstDocumentApprovedBy: String = "icstdoc:approvedBy"
  
}

public protocol ArcusIcstDocumentCapability: class, RxArcusService {
  /** The date the document was created */
  func getIcstDocumentCreated(_ model: IcstDocumentModel) -> Date?
  /** unique id */
  func getIcstDocumentId(_ model: IcstDocumentModel) -> String?
  /** The type of document */
  func getIcstDocumentDocType(_ model: IcstDocumentModel) -> IcstDocumentDocType?
  /** The type of document */
  func setIcstDocumentDocType(_ docType: IcstDocumentDocType, model: IcstDocumentModel)
/** The gzipped, B64 version of the text document */
  func getIcstDocumentDocument(_ model: IcstDocumentModel) -> String?
  /** The gzipped, B64 version of the text document */
  func setIcstDocumentDocument(_ document: String, model: IcstDocumentModel)
/** The last date the document was modified */
  func getIcstDocumentModified(_ model: IcstDocumentModel) -> Date?
  /** agent id that last modified the document */
  func getIcstDocumentModifiedBy(_ model: IcstDocumentModel) -> String?
  /** version of the document */
  func getIcstDocumentVersion(_ model: IcstDocumentModel) -> String?
  /** true if the document has been approved, set to false when created */
  func getIcstDocumentApproved(_ model: IcstDocumentModel) -> Bool?
  /** agent id that should approve the document (if approved is false) or did approve the document (if approved is true). The agent making the changes sets this field to indicate the document is ready for review. */
  func getIcstDocumentApprovedBy(_ model: IcstDocumentModel) -> String?
  /** agent id that should approve the document (if approved is false) or did approve the document (if approved is true). The agent making the changes sets this field to indicate the document is ready for review. */
  func setIcstDocumentApprovedBy(_ approvedBy: String, model: IcstDocumentModel)

  /** Add a document to the support_document_versions table with approved set to false. The &#x27;modifiedBy&#x27; and &#x27;version&#x27; attributes are autoset. */
  func requestIcstDocumentCreateDocument(_  model: IcstDocumentModel, id: String, docType: String, document: String)
   throws -> Observable<ArcusSessionEvent>/** Promote a document to the support_documents table. The document will also still be in the support_document_versions table. &#x27;approved&#x27; is autoset, &#x27;approvedBy&#x27; is already set. */
  func requestIcstDocumentApproveDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent>/** Reject an unapproved document by setting &#x27;approvedBy&#x27; to null. The &#x27;modifiedBy&#x27; field will not be changed (otherwise this would just be a SetAttributes call). */
  func requestIcstDocumentRejectDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent>/** Retrieves a list of document info without the documents themselves. */
  func requestIcstDocumentListDocumentMetadata(_  model: IcstDocumentModel, docType: String)
   throws -> Observable<ArcusSessionEvent>/** Removes a document. Only allowed if the document has not been approved. */
  func requestIcstDocumentDeleteDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusIcstDocumentCapability {
  public func getIcstDocumentCreated(_ model: IcstDocumentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.icstDocumentCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getIcstDocumentId(_ model: IcstDocumentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentId] as? String
  }
  
  public func getIcstDocumentDocType(_ model: IcstDocumentModel) -> IcstDocumentDocType? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.icstDocumentDocType] as? String,
      let enumAttr: IcstDocumentDocType = IcstDocumentDocType(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func setIcstDocumentDocType(_ docType: IcstDocumentDocType, model: IcstDocumentModel) {
    model.set([Attributes.icstDocumentDocType: docType.rawValue as AnyObject])
  }
  public func getIcstDocumentDocument(_ model: IcstDocumentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentDocument] as? String
  }
  
  public func setIcstDocumentDocument(_ document: String, model: IcstDocumentModel) {
    model.set([Attributes.icstDocumentDocument: document as AnyObject])
  }
  public func getIcstDocumentModified(_ model: IcstDocumentModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.icstDocumentModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getIcstDocumentModifiedBy(_ model: IcstDocumentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentModifiedBy] as? String
  }
  
  public func getIcstDocumentVersion(_ model: IcstDocumentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentVersion] as? String
  }
  
  public func getIcstDocumentApproved(_ model: IcstDocumentModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentApproved] as? Bool
  }
  
  public func getIcstDocumentApprovedBy(_ model: IcstDocumentModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.icstDocumentApprovedBy] as? String
  }
  
  public func setIcstDocumentApprovedBy(_ approvedBy: String, model: IcstDocumentModel) {
    model.set([Attributes.icstDocumentApprovedBy: approvedBy as AnyObject])
  }
  
  public func requestIcstDocumentCreateDocument(_  model: IcstDocumentModel, id: String, docType: String, document: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IcstDocumentCreateDocumentRequest = IcstDocumentCreateDocumentRequest()
    request.source = model.address
    
    
    
    request.setId(id)
    
    request.setDocType(docType)
    
    request.setDocument(document)
    
    return try sendRequest(request)
  }
  
  public func requestIcstDocumentApproveDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent> {
    let request: IcstDocumentApproveDocumentRequest = IcstDocumentApproveDocumentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestIcstDocumentRejectDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent> {
    let request: IcstDocumentRejectDocumentRequest = IcstDocumentRejectDocumentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestIcstDocumentListDocumentMetadata(_  model: IcstDocumentModel, docType: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: IcstDocumentListDocumentMetadataRequest = IcstDocumentListDocumentMetadataRequest()
    request.source = model.address
    
    
    
    request.setDocType(docType)
    
    return try sendRequest(request)
  }
  
  public func requestIcstDocumentDeleteDocument(_ model: IcstDocumentModel) throws -> Observable<ArcusSessionEvent> {
    let request: IcstDocumentDeleteDocumentRequest = IcstDocumentDeleteDocumentRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
