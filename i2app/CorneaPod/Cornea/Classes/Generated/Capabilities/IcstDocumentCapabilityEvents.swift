
//
// IcstDocumentCapEvents.swift
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

// MARK: Commands
fileprivate struct Commands {
  /** Add a document to the support_document_versions table with approved set to false. The &#x27;modifiedBy&#x27; and &#x27;version&#x27; attributes are autoset. */
  static let icstDocumentCreateDocument: String = "icstdoc:CreateDocument"
  /** Promote a document to the support_documents table. The document will also still be in the support_document_versions table. &#x27;approved&#x27; is autoset, &#x27;approvedBy&#x27; is already set. */
  static let icstDocumentApproveDocument: String = "icstdoc:ApproveDocument"
  /** Reject an unapproved document by setting &#x27;approvedBy&#x27; to null. The &#x27;modifiedBy&#x27; field will not be changed (otherwise this would just be a SetAttributes call). */
  static let icstDocumentRejectDocument: String = "icstdoc:RejectDocument"
  /** Retrieves a list of document info without the documents themselves. */
  static let icstDocumentListDocumentMetadata: String = "icstdoc:ListDocumentMetadata"
  /** Removes a document. Only allowed if the document has not been approved. */
  static let icstDocumentDeleteDocument: String = "icstdoc:DeleteDocument"
  
}

// MARK: Enumerations

/** The type of document */
public enum IcstDocumentDocType: String {
  case endsession = "ENDSESSION"
  case smartplug = "SMARTPLUG"
  case firmware = "FIRMWARE"
}

// MARK: Requests

/** Add a document to the support_document_versions table with approved set to false. The &#x27;modifiedBy&#x27; and &#x27;version&#x27; attributes are autoset. */
public class IcstDocumentCreateDocumentRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IcstDocumentCreateDocumentRequest Enumerations
  /** the type of the document */
  public enum IcstDocumentDocType: String {
   case endsession = "ENDSESSION"
   case smartplug = "SMARTPLUG"
   case firmware = "FIRMWARE"
   
  }
  override init() {
    super.init()
    self.command = Commands.icstDocumentCreateDocument
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IcstDocumentCreateDocumentResponse(message)
  }

  // MARK: CreateDocumentRequest Attributes
  struct Attributes {
    /** unique id */
    static let id: String = "id"
/** the type of the document */
    static let docType: String = "docType"
/** The gzipped, B64 version of the text document */
    static let document: String = "document"
 }
  
  /** unique id */
  public func setId(_ id: String) {
    attributes[Attributes.id] = id as AnyObject
  }

  
  /** the type of the document */
  public func setDocType(_ docType: String) {
    if let value: IcstDocumentDocType = IcstDocumentDocType(rawValue: docType) {
      attributes[Attributes.docType] = value.rawValue as AnyObject
    }
  }
  
  /** The gzipped, B64 version of the text document */
  public func setDocument(_ document: String) {
    attributes[Attributes.document] = document as AnyObject
  }

  
}

public class IcstDocumentCreateDocumentResponse: SessionEvent {
  
}

/** Promote a document to the support_documents table. The document will also still be in the support_document_versions table. &#x27;approved&#x27; is autoset, &#x27;approvedBy&#x27; is already set. */
public class IcstDocumentApproveDocumentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.icstDocumentApproveDocument
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IcstDocumentApproveDocumentResponse(message)
  }

  
}

public class IcstDocumentApproveDocumentResponse: SessionEvent {
  
}

/** Reject an unapproved document by setting &#x27;approvedBy&#x27; to null. The &#x27;modifiedBy&#x27; field will not be changed (otherwise this would just be a SetAttributes call). */
public class IcstDocumentRejectDocumentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.icstDocumentRejectDocument
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IcstDocumentRejectDocumentResponse(message)
  }

  
}

public class IcstDocumentRejectDocumentResponse: SessionEvent {
  
}

/** Retrieves a list of document info without the documents themselves. */
public class IcstDocumentListDocumentMetadataRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: IcstDocumentListDocumentMetadataRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.icstDocumentListDocumentMetadata
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IcstDocumentListDocumentMetadataResponse(message)
  }

  // MARK: ListDocumentMetadataRequest Attributes
  struct Attributes {
    /** only retrieve documents of one type */
    static let docType: String = "docType"
 }
  
  /** only retrieve documents of one type */
  public func setDocType(_ docType: String) {
    attributes[Attributes.docType] = docType as AnyObject
  }

  
}

public class IcstDocumentListDocumentMetadataResponse: SessionEvent {
  
  
  /** The list of document metadatas */
  public func getDocuments() -> [Any]? {
    return self.attributes["documents"] as? [Any]
  }
}

/** Removes a document. Only allowed if the document has not been approved. */
public class IcstDocumentDeleteDocumentRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.icstDocumentDeleteDocument
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return IcstDocumentDeleteDocumentResponse(message)
  }

  
}

public class IcstDocumentDeleteDocumentResponse: SessionEvent {
  
}

