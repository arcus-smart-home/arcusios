
//
// PlaceCapEvents.swift
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
  /** Lists all devices associated with this place */
  static let placeListDevices: String = "place:ListDevices"
  /** Retrieves the object representing the hub at this place or null if the place has no hub */
  static let placeGetHub: String = "place:GetHub"
  /** Prepares this location to have devices added (paired) any devices added during this time will emit the device added event */
  static let placeStartAddingDevices: String = "place:StartAddingDevices"
  /** Cleans up anything enabled into the home for having devices added (paired) */
  static let placeStopAddingDevices: String = "place:StopAddingDevices"
  /** Registered a hub at this place.  At some point later the HubAddedEvent will be posted */
  static let placeRegisterHub: String = "place:RegisterHub"
  /** Add a new person with permissions to this place. */
  static let placeAddPerson: String = "place:AddPerson"
  /** The list of persons who have access to this place. */
  static let placeListPersons: String = "place:ListPersons"
  /** The list of persons who have access to this place plus their role */
  static let placeListPersonsWithAccess: String = "place:ListPersonsWithAccess"
  /** Returns a list of the high-importance history log entries associated with this place */
  static let placeListDashboardEntries: String = "place:ListDashboardEntries"
  /** Returns a list of all the history log entries associated with this place */
  static let placeListHistoryEntries: String = "place:ListHistoryEntries"
  /** Remove the place and any associated entities. */
  static let placeDelete: String = "place:Delete"
  /** Creates an invitation for the user */
  static let placeCreateInvitation: String = "place:CreateInvitation"
  /** Sends the given invitation */
  static let placeSendInvitation: String = "place:SendInvitation"
  /** Lists all pending invitations for the place */
  static let placePendingInvitations: String = "place:PendingInvitations"
  /** Cancels and deletes an invitation */
  static let placeCancelInvitation: String = "place:CancelInvitation"
  /** Updates the current place&#x27;s address if it is changed and potentially other third-party systems.  The address is optional and if not specified will use the address of the current place. */
  static let placeUpdateAddress: String = "place:UpdateAddress"
  /** This attempts to register the addressed place with the given hub.  This call will not succeed until the hub is (1) online and (2) above the minimum firmware version.  At that point the call is idempotent, so may be safely retried. */
  static let placeRegisterHubV2: String = "place:RegisterHubV2"
  
}

// MARK: Errors
public struct PlaceUpdateAddressError: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** The address does not pass validation as one recognized by UCC. */
    case addressInvalid = "address.invalid"
    /** The address is not in an area where professionally monitoring is currently available. */
    case addressUnavailable = "address.unavailable"
    /** If residential is not set to true. */
    case addressUnsupported = "address.unsupported"
    
  }
}
// MARK: Errors
public struct PlaceRegisterHubV2Error: ArcusError {
  public var errorType: ErrorType!
  public var code: String {
    return errorType.rawValue
  }
  public var message: String!

  public init() {}

  public init(errorType: ErrorType, message: String = "") {
    self.errorType = errorType
    self.message = message
  }

  public init?(code: String, message: String) {
    guard let errorType = ErrorType(rawValue: code) else { return nil }

    self.init(errorType: errorType, message: message)
  }

  public var localizedDescription: String {
    return message
  }

  public enum ErrorType: String {
    /** If the hub is registered to someone else. */
    case errorRegisterAlreadyregistered = "error.register.alreadyregistered"
    /** The place already has a hub associated with it. */
    case errorRegisterActivehub = "error.register.activehub"
    /** The hub is associated with a place that has been deleted. */
    case errorRegisterOrphanedhub = "error.register.orphanedhub"
    /** There was a failure while attempting to apply the firmware upgrade. */
    case errorFwupgradeFailed = "error.fwupgrade.failed"
    
  }
}
// MARK: Enumerations

/** Platform-owned service level at this place */
public enum PlaceServiceLevel: String {
  case basic = "BASIC"
  case premium = "PREMIUM"
  case premium_free = "PREMIUM_FREE"
  case premium_promon = "PREMIUM_PROMON"
  case premium_promon_free = "PREMIUM_PROMON_FREE"
  case premium_promon_myarcus_discount = "PREMIUM_PROMON_MYARCUS_DISCOUNT"
}

// MARK: Requests

/** Lists all devices associated with this place */
public class PlaceListDevicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeListDevices
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
    return PlaceListDevicesResponse(message)
  }

  
}

public class PlaceListDevicesResponse: SessionEvent {
  
  
  /** The list of devices associated with this place */
  public func getDevices() -> [Any]? {
    return self.attributes["devices"] as? [Any]
  }
}

/** Retrieves the object representing the hub at this place or null if the place has no hub */
public class PlaceGetHubRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeGetHub
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
    return PlaceGetHubResponse(message)
  }

  
}

public class PlaceGetHubResponse: SessionEvent {
  
  
  /** The hub associated with this place or null if no hub has been registered at this location */
  public func getHub() -> Any? {
    return self.attributes["hub"]
  }
}

/** Prepares this location to have devices added (paired) any devices added during this time will emit the device added event */
public class PlaceStartAddingDevicesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceStartAddingDevicesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeStartAddingDevices
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
    return PlaceStartAddingDevicesResponse(message)
  }

  // MARK: StartAddingDevicesRequest Attributes
  struct Attributes {
    /** The amount of time in milliseconds for which the place will be able to add devices */
    static let time: String = "time"
 }
  
  /** The amount of time in milliseconds for which the place will be able to add devices */
  public func setTime(_ time: Int) {
    attributes[Attributes.time] = time as AnyObject
  }

  
}

public class PlaceStartAddingDevicesResponse: SessionEvent {
  
}

/** Cleans up anything enabled into the home for having devices added (paired) */
public class PlaceStopAddingDevicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeStopAddingDevices
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
    return PlaceStopAddingDevicesResponse(message)
  }

  
}

public class PlaceStopAddingDevicesResponse: SessionEvent {
  
}

/** Registered a hub at this place.  At some point later the HubAddedEvent will be posted */
public class PlaceRegisterHubRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceRegisterHubRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeRegisterHub
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
    return PlaceRegisterHubResponse(message)
  }

  // MARK: RegisterHubRequest Attributes
  struct Attributes {
    /** The hub ID in the format AAA-NNNN */
    static let hubId: String = "hubId"
 }
  
  /** The hub ID in the format AAA-NNNN */
  public func setHubId(_ hubId: String) {
    attributes[Attributes.hubId] = hubId as AnyObject
  }

  
}

public class PlaceRegisterHubResponse: SessionEvent {
  
}

/** Add a new person with permissions to this place. */
public class PlaceAddPersonRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceAddPersonRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeAddPerson
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
    return PlaceAddPersonResponse(message)
  }

  // MARK: AddPersonRequest Attributes
  struct Attributes {
    /** The person you would like to create with person to this place. */
    static let person: String = "person"
/** The login password for this person. */
    static let password: String = "password"
 }
  
  /** The person you would like to create with person to this place. */
  public func setPerson(_ person: Any) {
    guard let model = person as? ArcusModel else { return }
    attributes[Attributes.person] = model.get() as AnyObject
    
  }

  
  /** The login password for this person. */
  public func setPassword(_ password: String) {
    attributes[Attributes.password] = password as AnyObject
  }

  
}

public class PlaceAddPersonResponse: SessionEvent {
  
  
  /** The address of the person added. */
  public func getNewPerson() -> String? {
    return self.attributes["newPerson"] as? String
  }
}

/** The list of persons who have access to this place. */
public class PlaceListPersonsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeListPersons
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
    return PlaceListPersonsResponse(message)
  }

  
}

public class PlaceListPersonsResponse: SessionEvent {
  
  
  /** The list of persons who have access to this place. */
  public func getPersons() -> [Any]? {
    return self.attributes["persons"] as? [Any]
  }
}

/** The list of persons who have access to this place plus their role */
public class PlaceListPersonsWithAccessRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeListPersonsWithAccess
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
    return PlaceListPersonsWithAccessResponse(message)
  }

  
}

public class PlaceListPersonsWithAccessResponse: SessionEvent {
  
  
  /** The list of people with their role at this place */
  public func getPersons() -> [Any]? {
    return self.attributes["persons"] as? [Any]
  }
}

/** Returns a list of the high-importance history log entries associated with this place */
public class PlaceListDashboardEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceListDashboardEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeListDashboardEntries
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
    return PlaceListDashboardEntriesResponse(message)
  }

  // MARK: ListDashboardEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class PlaceListDashboardEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this place */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

/** Returns a list of all the history log entries associated with this place */
public class PlaceListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeListHistoryEntries
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
    return PlaceListHistoryEntriesResponse(message)
  }

  // MARK: ListHistoryEntriesRequest Attributes
  struct Attributes {
    /** The maximum number of events to return (defaults to 10) */
    static let limit: String = "limit"
/** The token from a previous query to use for retrieving the next set of results */
    static let token: String = "token"
 }
  
  /** The maximum number of events to return (defaults to 10) */
  public func setLimit(_ limit: Int) {
    attributes[Attributes.limit] = limit as AnyObject
  }

  
  /** The token from a previous query to use for retrieving the next set of results */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class PlaceListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this place */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

/** Remove the place and any associated entities. */
public class PlaceDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placeDelete
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
    return PlaceDeleteResponse(message)
  }

  
}

public class PlaceDeleteResponse: SessionEvent {
  
}

/** Creates an invitation for the user */
public class PlaceCreateInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceCreateInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeCreateInvitation
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
    return PlaceCreateInvitationResponse(message)
  }

  // MARK: CreateInvitationRequest Attributes
  struct Attributes {
    /** The first name of the invitee */
    static let firstName: String = "firstName"
/** The last name of the invitee */
    static let lastName: String = "lastName"
/** The email address where the invitee can be reached */
    static let email: String = "email"
/** The relationship of the invitee to the invitor.  If not provided, defaults to other */
    static let relationship: String = "relationship"
 }
  
  /** The first name of the invitee */
  public func setFirstName(_ firstName: String) {
    attributes[Attributes.firstName] = firstName as AnyObject
  }

  
  /** The last name of the invitee */
  public func setLastName(_ lastName: String) {
    attributes[Attributes.lastName] = lastName as AnyObject
  }

  
  /** The email address where the invitee can be reached */
  public func setEmail(_ email: String) {
    attributes[Attributes.email] = email as AnyObject
  }

  
  /** The relationship of the invitee to the invitor.  If not provided, defaults to other */
  public func setRelationship(_ relationship: String) {
    attributes[Attributes.relationship] = relationship as AnyObject
  }

  
}

public class PlaceCreateInvitationResponse: SessionEvent {
  
  
  /** The default invitation */
  public func getInvitation() -> Any? {
    return self.attributes["invitation"]
  }
}

/** Sends the given invitation */
public class PlaceSendInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceSendInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeSendInvitation
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
    return PlaceSendInvitationResponse(message)
  }

  // MARK: SendInvitationRequest Attributes
  struct Attributes {
    /** The invitation */
    static let invitation: String = "invitation"
 }
  
  /** The invitation */
  public func setInvitation(_ invitation: Any) {
    attributes[Attributes.invitation] = invitation as AnyObject
  }

  
}

public class PlaceSendInvitationResponse: SessionEvent {
  
}

/** Lists all pending invitations for the place */
public class PlacePendingInvitationsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.placePendingInvitations
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
    return PlacePendingInvitationsResponse(message)
  }

  
}

public class PlacePendingInvitationsResponse: SessionEvent {
  
  
  /** The list of all pending invitations sent for this place */
  public func getInvitations() -> [Any]? {
    return self.attributes["invitations"] as? [Any]
  }
}

/** Cancels and deletes an invitation */
public class PlaceCancelInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceCancelInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeCancelInvitation
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
    return PlaceCancelInvitationResponse(message)
  }

  // MARK: CancelInvitationRequest Attributes
  struct Attributes {
    /** The code to cancel */
    static let code: String = "code"
 }
  
  /** The code to cancel */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
}

public class PlaceCancelInvitationResponse: SessionEvent {
  
}

/** Updates the current place&#x27;s address if it is changed and potentially other third-party systems.  The address is optional and if not specified will use the address of the current place. */
public class PlaceUpdateAddressRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceUpdateAddressRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeUpdateAddress
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

      let error = PlaceUpdateAddressError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PlaceUpdateAddressResponse(message)
  }

  // MARK: UpdateAddressRequest Attributes
  struct Attributes {
    /** If specified the place address will be updated to use this given address. */
    static let streetAddress: String = "streetAddress"
 }
  
  /** If specified the place address will be updated to use this given address. */
  public func setStreetAddress(_ streetAddress: Any) {
    attributes[Attributes.streetAddress] = streetAddress as AnyObject
  }

  
}

public class PlaceUpdateAddressResponse: SessionEvent {
  
}

/** This attempts to register the addressed place with the given hub.  This call will not succeed until the hub is (1) online and (2) above the minimum firmware version.  At that point the call is idempotent, so may be safely retried. */
public class PlaceRegisterHubV2Request: ClientMessage, ArcusClientRequest {
  
  // MARK: PlaceRegisterHubV2Request Enumerations
  
  override init() {
    super.init()
    self.command = Commands.placeRegisterHubV2
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

      let error = PlaceRegisterHubV2Error(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PlaceRegisterHubV2Response(message)
  }

  // MARK: RegisterHubV2Request Attributes
  struct Attributes {
    /** The ID of the hub to pair */
    static let hubId: String = "hubId"
 }
  
  /** The ID of the hub to pair */
  public func setHubId(_ hubId: String) {
    attributes[Attributes.hubId] = hubId as AnyObject
  }

  
}

public class PlaceRegisterHubV2Response: SessionEvent {
  
  
  /** The current state of the hub */
  public enum PlaceState: String {
    case online = "ONLINE"
    case offline = "OFFLINE"
    case downloading = "DOWNLOADING"
    case applying = "APPLYING"
    case registered = "REGISTERED"
    
  }
  /** The current state of the hub */
  public func getState() -> PlaceState? {
    guard let attribute = self.attributes["state"] as? String,
      let enumAttr: PlaceState = PlaceState(rawValue: attribute) else { return nil }
    return enumAttr
  }
  /** An integer from 0 to 100 indicating the progress for the current state. */
  public func getProgress() -> Int? {
    return self.attributes["progress"] as? Int
  }
  /** The full hub model, only reported if state == REGISTERED */
  public func getHub() -> Any? {
    return self.attributes["hub"]
  }
}

