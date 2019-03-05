
//
// PersonCapEvents.swift
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
  /** Sets the security answers for the given person.  The first question and answer are required, those for the second and third are optional. */
  static let personSetSecurityAnswers: String = "person:SetSecurityAnswers"
  /** Retrieves the security responses for the given person */
  static let personGetSecurityAnswers: String = "person:GetSecurityAnswers"
  /** Adds and associates a mobile device for the given person */
  static let personAddMobileDevice: String = "person:AddMobileDevice"
  /** Removes/disassociates a mobile device from this person */
  static let personRemoveMobileDevice: String = "person:RemoveMobileDevice"
  /** Lists all mobile devices associated with this person */
  static let personListMobileDevices: String = "person:ListMobileDevices"
  /** Returns a list of all the history log entries associated with this person */
  static let personListHistoryEntries: String = "person:ListHistoryEntries"
  /** Remove/Deactivate the person record indicated. */
  static let personDelete: String = "person:Delete"
  /** Removes a person from a specific place.  If the person is a hobbit they will be completely deleted. */
  static let personRemoveFromPlace: String = "person:RemoveFromPlace"
  /** Changes the person&#x27;s pin at their currPlace.  Deprecated, use ChangePinV2 instead. */
  static let personChangePin: String = "person:ChangePin"
  /** Changes the person&#x27;s pin at the specified place.  People are allowed to change their own pin or a hobbit at the specified place assuming the person invoking the call has access to the place. */
  static let personChangePinV2: String = "person:ChangePinV2"
  /** Verifies that the pins match and that the requester is logged in as the person that the pin is being verified for. */
  static let personVerifyPin: String = "person:VerifyPin"
  /** Accepts an invitation */
  static let personAcceptInvitation: String = "person:AcceptInvitation"
  /** Rejects an invitation */
  static let personRejectInvitation: String = "person:RejectInvitation"
  /** Retrieves the list of pending invitations for this user */
  static let personPendingInvitations: String = "person:PendingInvitations"
  /** Promotes a user with a login to full fledged IRIS account */
  static let personPromoteToAccount: String = "person:PromoteToAccount"
  /** Deletes complete the login and any associations with it */
  static let personDeleteLogin: String = "person:DeleteLogin"
  /** Lists the available places for a person.  Returns the same structure as the session service&#x27;s method */
  static let personListAvailablePlaces: String = "person:ListAvailablePlaces"
  /** Accept terms &amp; conditions and/or privacy policy */
  static let personAcceptPolicy: String = "person:AcceptPolicy"
  /** Reject terms &amp; conditions and/or privacy policy. NOTE THIS IS GENERALLY FOR TESTING ONLY */
  static let personRejectPolicy: String = "person:RejectPolicy"
  /** Generates an email address verification email. */
  static let personSendVerificationEmail: String = "person:SendVerificationEmail"
  /** Verifies that the user has access to their current email address by providing the token from the email. */
  static let personVerifyEmail: String = "person:VerifyEmail"
  
}
// MARK: Events
public struct PersonEvents {
  /** Emitted when the the user changes their pin */
  public static let personPinChangedEvent: String = "person:PinChangedEvent"
  /** Emitted when an invitation has been sent to this user */
  public static let personInvitationPending: String = "person:InvitationPending"
  /** Emitted when authorization to a place is removed for this user.  This is an internal platform event that the client-bridge listens. */
  public static let personAuthorizationRemoved: String = "person:AuthorizationRemoved"
  }

// MARK: Errors
public struct PersonChangePinError: ArcusError {
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
    /** If no person exists with that ID. */
    case personNotFound = "person.notFound"
    /** If the pin isn&#x27;t unique at this place. */
    case pinNotUniqueAtPlace = "pin.notUniqueAtPlace"
    
  }
}
// MARK: Errors
public struct PersonChangePinV2Error: ArcusError {
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
    /** If no person exists with that ID. */
    case personNotFound = "person.notFound"
    /** If the place is blank, empty, or missing. */
    case placeMissing = "place.missing"
    /** If the pin is blank, empty, or missing. */
    case pinMissing = "pin.missing"
    /** If the pin doesn&#x27;t have exactly 4 characters or contains non-digit characters. */
    case pinInvalid = "pin.invalid"
    /** If the pin isn&#x27;t unique at this place. */
    case pinNotUniqueAtPlace = "pin.notUniqueAtPlace"
    
  }
}
// MARK: Errors
public struct PersonVerifyEmailError: ArcusError {
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
    /** If the token does not match the current email address. */
    case tokenInvalid = "token.invalid"
    
  }
}
// MARK: Enumerations

// MARK: Requests

/** Sets the security answers for the given person.  The first question and answer are required, those for the second and third are optional. */
public class PersonSetSecurityAnswersRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonSetSecurityAnswersRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personSetSecurityAnswers
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
    return PersonSetSecurityAnswersResponse(message)
  }

  // MARK: SetSecurityAnswersRequest Attributes
  struct Attributes {
    /** The identifier for the first question answered */
    static let securityQuestion1: String = "securityQuestion1"
/** The user&#x27;s answer for the question identified in securityQuestion1 */
    static let securityAnswer1: String = "securityAnswer1"
/** The identifier for the second question answered */
    static let securityQuestion2: String = "securityQuestion2"
/** The user&#x27;s answer for the question identified in securityQuestion2 */
    static let securityAnswer2: String = "securityAnswer2"
/** The identifier for the third question answered */
    static let securityQuestion3: String = "securityQuestion3"
/** The user&#x27;s answer for the question identified in securityQuestion3 */
    static let securityAnswer3: String = "securityAnswer3"
 }
  
  /** The identifier for the first question answered */
  public func setSecurityQuestion1(_ securityQuestion1: String) {
    attributes[Attributes.securityQuestion1] = securityQuestion1 as AnyObject
  }

  
  /** The user&#x27;s answer for the question identified in securityQuestion1 */
  public func setSecurityAnswer1(_ securityAnswer1: String) {
    attributes[Attributes.securityAnswer1] = securityAnswer1 as AnyObject
  }

  
  /** The identifier for the second question answered */
  public func setSecurityQuestion2(_ securityQuestion2: String) {
    attributes[Attributes.securityQuestion2] = securityQuestion2 as AnyObject
  }

  
  /** The user&#x27;s answer for the question identified in securityQuestion2 */
  public func setSecurityAnswer2(_ securityAnswer2: String) {
    attributes[Attributes.securityAnswer2] = securityAnswer2 as AnyObject
  }

  
  /** The identifier for the third question answered */
  public func setSecurityQuestion3(_ securityQuestion3: String) {
    attributes[Attributes.securityQuestion3] = securityQuestion3 as AnyObject
  }

  
  /** The user&#x27;s answer for the question identified in securityQuestion3 */
  public func setSecurityAnswer3(_ securityAnswer3: String) {
    attributes[Attributes.securityAnswer3] = securityAnswer3 as AnyObject
  }

  
}

public class PersonSetSecurityAnswersResponse: SessionEvent {
  
}

/** Retrieves the security responses for the given person */
public class PersonGetSecurityAnswersRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personGetSecurityAnswers
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
    return PersonGetSecurityAnswersResponse(message)
  }

  
}

public class PersonGetSecurityAnswersResponse: SessionEvent {
  
  
  /** A map where the key is the identifier for the security question and the value is the user&#x27;s answer */
  public func getSecurityAnswers() -> [String: String]? {
    return self.attributes["securityAnswers"] as? [String: String]
  }
}

/** Adds and associates a mobile device for the given person */
public class PersonAddMobileDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonAddMobileDeviceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personAddMobileDevice
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
    return PersonAddMobileDeviceResponse(message)
  }

  // MARK: AddMobileDeviceRequest Attributes
  struct Attributes {
    /** A user-assigned name for this mobile device; useful when specifying which devices will receive notifications. */
    static let name: String = "name"
/** The version of the Arcus app running on the device. */
    static let appVersion: String = "appVersion"
/** The type of operating system the mobile device is running (iOS, Android for example). */
    static let osType: String = "osType"
/** The version of the operating system running on the mobile device. */
    static let osVersion: String = "osVersion"
/** The form factor of the device (phone, tablet for example). */
    static let formFactor: String = "formFactor"
/** The phone number of the device if present. */
    static let phoneNumber: String = "phoneNumber"
/** Device specific unique identifier for the mobile device if possible. */
    static let deviceIdentifier: String = "deviceIdentifier"
/** The model of the device if known. */
    static let deviceModel: String = "deviceModel"
/** The vendor of the device if known. */
    static let deviceVendor: String = "deviceVendor"
/** The screen resolution of the device (ex. xhdpi) */
    static let resolution: String = "resolution"
/** The token for sending push notifications to this device if it is registered to do so. */
    static let notificationToken: String = "notificationToken"
/** The last measured latitude if collected. */
    static let lastLatitude: String = "lastLatitude"
/** The last measured longitude if collected. */
    static let lastLongitude: String = "lastLongitude"
 }
  
  /** A user-assigned name for this mobile device; useful when specifying which devices will receive notifications. */
  public func setName(_ name: String) {
    attributes[Attributes.name] = name as AnyObject
  }

  
  /** The version of the Arcus app running on the device. */
  public func setAppVersion(_ appVersion: String) {
    attributes[Attributes.appVersion] = appVersion as AnyObject
  }

  
  /** The type of operating system the mobile device is running (iOS, Android for example). */
  public func setOsType(_ osType: String) {
    attributes[Attributes.osType] = osType as AnyObject
  }

  
  /** The version of the operating system running on the mobile device. */
  public func setOsVersion(_ osVersion: String) {
    attributes[Attributes.osVersion] = osVersion as AnyObject
  }

  
  /** The form factor of the device (phone, tablet for example). */
  public func setFormFactor(_ formFactor: String) {
    attributes[Attributes.formFactor] = formFactor as AnyObject
  }

  
  /** The phone number of the device if present. */
  public func setPhoneNumber(_ phoneNumber: String) {
    attributes[Attributes.phoneNumber] = phoneNumber as AnyObject
  }

  
  /** Device specific unique identifier for the mobile device if possible. */
  public func setDeviceIdentifier(_ deviceIdentifier: String) {
    attributes[Attributes.deviceIdentifier] = deviceIdentifier as AnyObject
  }

  
  /** The model of the device if known. */
  public func setDeviceModel(_ deviceModel: String) {
    attributes[Attributes.deviceModel] = deviceModel as AnyObject
  }

  
  /** The vendor of the device if known. */
  public func setDeviceVendor(_ deviceVendor: String) {
    attributes[Attributes.deviceVendor] = deviceVendor as AnyObject
  }

  
  /** The screen resolution of the device (ex. xhdpi) */
  public func setResolution(_ resolution: String) {
    attributes[Attributes.resolution] = resolution as AnyObject
  }

  
  /** The token for sending push notifications to this device if it is registered to do so. */
  public func setNotificationToken(_ notificationToken: String) {
    attributes[Attributes.notificationToken] = notificationToken as AnyObject
  }

  
  /** The last measured latitude if collected. */
  public func setLastLatitude(_ lastLatitude: Double) {
    attributes[Attributes.lastLatitude] = lastLatitude as AnyObject
  }

  
  /** The last measured longitude if collected. */
  public func setLastLongitude(_ lastLongitude: Double) {
    attributes[Attributes.lastLongitude] = lastLongitude as AnyObject
  }

  
}

public class PersonAddMobileDeviceResponse: SessionEvent {
  
}

/** Removes/disassociates a mobile device from this person */
public class PersonRemoveMobileDeviceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonRemoveMobileDeviceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personRemoveMobileDevice
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
    return PersonRemoveMobileDeviceResponse(message)
  }

  // MARK: RemoveMobileDeviceRequest Attributes
  struct Attributes {
    /** Platform-owned index for the device that uniquely identifies it within the context of this person */
    static let deviceIndex: String = "deviceIndex"
 }
  
  /** Platform-owned index for the device that uniquely identifies it within the context of this person */
  public func setDeviceIndex(_ deviceIndex: Int) {
    attributes[Attributes.deviceIndex] = deviceIndex as AnyObject
  }

  
}

public class PersonRemoveMobileDeviceResponse: SessionEvent {
  
}

/** Lists all mobile devices associated with this person */
public class PersonListMobileDevicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personListMobileDevices
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
    return PersonListMobileDevicesResponse(message)
  }

  
}

public class PersonListMobileDevicesResponse: SessionEvent {
  
  
  /** The list of mobile devices associated with this person */
  public func getMobileDevices() -> [Any]? {
    return self.attributes["mobileDevices"] as? [Any]
  }
}

/** Returns a list of all the history log entries associated with this person */
public class PersonListHistoryEntriesRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonListHistoryEntriesRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personListHistoryEntries
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
    return PersonListHistoryEntriesResponse(message)
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

public class PersonListHistoryEntriesResponse: SessionEvent {
  
  
  /** The token to use for getting the next page, if null there is no next page */
  public func getNextToken() -> String? {
    return self.attributes["nextToken"] as? String
  }
  /** The entries associated with this person */
  public func getResults() -> [Any]? {
    return self.attributes["results"] as? [Any]
  }
}

/** Remove/Deactivate the person record indicated. */
public class PersonDeleteRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personDelete
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
    return PersonDeleteResponse(message)
  }

  
}

public class PersonDeleteResponse: SessionEvent {
  
}

/** Removes a person from a specific place.  If the person is a hobbit they will be completely deleted. */
public class PersonRemoveFromPlaceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonRemoveFromPlaceRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personRemoveFromPlace
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
    return PersonRemoveFromPlaceResponse(message)
  }

  // MARK: RemoveFromPlaceRequest Attributes
  struct Attributes {
    /** The place to remove the person from.  If not provided the place header (active place) from the message will be used. */
    static let placeId: String = "placeId"
 }
  
  /** The place to remove the person from.  If not provided the place header (active place) from the message will be used. */
  public func setPlaceId(_ placeId: String) {
    attributes[Attributes.placeId] = placeId as AnyObject
  }

  
}

public class PersonRemoveFromPlaceResponse: SessionEvent {
  
}

/** Changes the person&#x27;s pin at their currPlace.  Deprecated, use ChangePinV2 instead. */
public class PersonChangePinRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonChangePinRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personChangePin
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

      let error = PersonChangePinError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PersonChangePinResponse(message)
  }

  // MARK: ChangePinRequest Attributes
  struct Attributes {
    /** The current pin of the person if they have one.  If they have a pin this must match their existing pin */
    static let currentPin: String = "currentPin"
/** The new pin for the person */
    static let newPin: String = "newPin"
 }
  
  /** The current pin of the person if they have one.  If they have a pin this must match their existing pin */
  public func setCurrentPin(_ currentPin: String) {
    attributes[Attributes.currentPin] = currentPin as AnyObject
  }

  
  /** The new pin for the person */
  public func setNewPin(_ newPin: String) {
    attributes[Attributes.newPin] = newPin as AnyObject
  }

  
}

public class PersonChangePinResponse: SessionEvent {
  
  
  /** True if the pin was successfully changed, false otherwise */
  public func getSuccess() -> Bool? {
    return self.attributes["success"] as? Bool
  }
}

/** Changes the person&#x27;s pin at the specified place.  People are allowed to change their own pin or a hobbit at the specified place assuming the person invoking the call has access to the place. */
public class PersonChangePinV2Request: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonChangePinV2Request Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personChangePinV2
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

      let error = PersonChangePinV2Error(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PersonChangePinV2Response(message)
  }

  // MARK: ChangePinV2Request Attributes
  struct Attributes {
    /** The identifier for the place where the person will use the pin */
    static let place: String = "place"
/** The pin to set for the person */
    static let pin: String = "pin"
 }
  
  /** The identifier for the place where the person will use the pin */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** The pin to set for the person */
  public func setPin(_ pin: String) {
    attributes[Attributes.pin] = pin as AnyObject
  }

  
}

public class PersonChangePinV2Response: SessionEvent {
  
  
  /** True if the pin was successfully changed, false otherwise */
  public func getSuccess() -> Bool? {
    return self.attributes["success"] as? Bool
  }
}

/** Verifies that the pins match and that the requester is logged in as the person that the pin is being verified for. */
public class PersonVerifyPinRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonVerifyPinRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personVerifyPin
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
    return PersonVerifyPinResponse(message)
  }

  // MARK: VerifyPinRequest Attributes
  struct Attributes {
    /** The identifier of the place with the pin for the person to compare against */
    static let place: String = "place"
/** The pin to compare against */
    static let pin: String = "pin"
 }
  
  /** The identifier of the place with the pin for the person to compare against */
  public func setPlace(_ place: String) {
    attributes[Attributes.place] = place as AnyObject
  }

  
  /** The pin to compare against */
  public func setPin(_ pin: String) {
    attributes[Attributes.pin] = pin as AnyObject
  }

  
}

public class PersonVerifyPinResponse: SessionEvent {
  
  
  /** True if the pin successfully matches current pin, false otherwise */
  public func getSuccess() -> Bool? {
    return self.attributes["success"] as? Bool
  }
}

/** Accepts an invitation */
public class PersonAcceptInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonAcceptInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personAcceptInvitation
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
    return PersonAcceptInvitationResponse(message)
  }

  // MARK: AcceptInvitationRequest Attributes
  struct Attributes {
    /** The invitation code the person is accepting */
    static let code: String = "code"
/** The email the invitation was sent to */
    static let inviteeEmail: String = "inviteeEmail"
 }
  
  /** The invitation code the person is accepting */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
  /** The email the invitation was sent to */
  public func setInviteeEmail(_ inviteeEmail: String) {
    attributes[Attributes.inviteeEmail] = inviteeEmail as AnyObject
  }

  
}

public class PersonAcceptInvitationResponse: SessionEvent {
  
}

/** Rejects an invitation */
public class PersonRejectInvitationRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonRejectInvitationRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personRejectInvitation
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
    return PersonRejectInvitationResponse(message)
  }

  // MARK: RejectInvitationRequest Attributes
  struct Attributes {
    /** The invitation code the person is rejecting */
    static let code: String = "code"
/** The email the invitation was sent to */
    static let inviteeEmail: String = "inviteeEmail"
/** The reason the person is rejecting the code */
    static let reason: String = "reason"
 }
  
  /** The invitation code the person is rejecting */
  public func setCode(_ code: String) {
    attributes[Attributes.code] = code as AnyObject
  }

  
  /** The email the invitation was sent to */
  public func setInviteeEmail(_ inviteeEmail: String) {
    attributes[Attributes.inviteeEmail] = inviteeEmail as AnyObject
  }

  
  /** The reason the person is rejecting the code */
  public func setReason(_ reason: String) {
    attributes[Attributes.reason] = reason as AnyObject
  }

  
}

public class PersonRejectInvitationResponse: SessionEvent {
  
}

/** Retrieves the list of pending invitations for this user */
public class PersonPendingInvitationsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personPendingInvitations
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
    return PersonPendingInvitationsResponse(message)
  }

  
}

public class PersonPendingInvitationsResponse: SessionEvent {
  
  
  /** The list of all pending invitations that could be associated with this user or empty */
  public func getInvitations() -> [Any]? {
    return self.attributes["invitations"] as? [Any]
  }
}

/** Promotes a user with a login to full fledged IRIS account */
public class PersonPromoteToAccountRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonPromoteToAccountRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personPromoteToAccount
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
    return PersonPromoteToAccountResponse(message)
  }

  // MARK: PromoteToAccountRequest Attributes
  struct Attributes {
    /** The place information or the new account */
    static let place: String = "place"
 }
  
  /** The place information or the new account */
  public func setPlace(_ place: Any) {
    guard let model = place as? ArcusModel else { return }
    attributes[Attributes.place] = model.get() as AnyObject
    
  }

  
}

public class PersonPromoteToAccountResponse: SessionEvent {
  
  
  /** The instance of AccountModel created for the new registration */
  public func getAccount() -> Any? {
    return self.attributes["account"]
  }
  /** The instance of PlaceModel created for the place */
  public func getPlace() -> Any? {
    return self.attributes["place"]
  }
}

/** Deletes complete the login and any associations with it */
public class PersonDeleteLoginRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personDeleteLogin
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
    return PersonDeleteLoginResponse(message)
  }

  
}

public class PersonDeleteLoginResponse: SessionEvent {
  
}

/** Lists the available places for a person.  Returns the same structure as the session service&#x27;s method */
public class PersonListAvailablePlacesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.personListAvailablePlaces
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
    return PersonListAvailablePlacesResponse(message)
  }

  
}

public class PersonListAvailablePlacesResponse: SessionEvent {
  
  
  /** The places this person has access to */
  public func getPlaces() -> [Any]? {
    return self.attributes["places"] as? [Any]
  }
}

/** Accept terms &amp; conditions and/or privacy policy */
public class PersonAcceptPolicyRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonAcceptPolicyRequest Enumerations
  /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to accept both, need to call the method twice. */
  public enum PersonType: String {
   case privacy = "PRIVACY"
   case terms = "TERMS"
   
  }
  override init() {
    super.init()
    self.command = Commands.personAcceptPolicy
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
    return PersonAcceptPolicyResponse(message)
  }

  // MARK: AcceptPolicyRequest Attributes
  struct Attributes {
    /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to accept both, need to call the method twice. */
    static let type: String = "type"
 }
  
  /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to accept both, need to call the method twice. */
  public func setType(_ type: String) {
    if let value: PersonType = PersonType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class PersonAcceptPolicyResponse: SessionEvent {
  
}

/** Reject terms &amp; conditions and/or privacy policy. NOTE THIS IS GENERALLY FOR TESTING ONLY */
public class PersonRejectPolicyRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonRejectPolicyRequest Enumerations
  /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to reject both, need to call the method twice. */
  public enum PersonType: String {
   case privacy = "PRIVACY"
   case terms = "TERMS"
   
  }
  override init() {
    super.init()
    self.command = Commands.personRejectPolicy
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
    return PersonRejectPolicyResponse(message)
  }

  // MARK: RejectPolicyRequest Attributes
  struct Attributes {
    /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to reject both, need to call the method twice. */
    static let type: String = "type"
 }
  
  /** PRIVACY for privacy policy, TERMS for terms &amp; condition.  In order to reject both, need to call the method twice. */
  public func setType(_ type: String) {
    if let value: PersonType = PersonType(rawValue: type) {
      attributes[Attributes.type] = value.rawValue as AnyObject
    }
  }
  
}

public class PersonRejectPolicyResponse: SessionEvent {
  
}

/** Generates an email address verification email. */
public class PersonSendVerificationEmailRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonSendVerificationEmailRequest Enumerations
  /** The source where the email verification request comes from.  Default is WEB. */
  public enum PersonSource: String {
   case android = "ANDROID"
   case ios = "IOS"
   case web = "WEB"
   
  }
  override init() {
    super.init()
    self.command = Commands.personSendVerificationEmail
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
    return PersonSendVerificationEmailResponse(message)
  }

  // MARK: SendVerificationEmailRequest Attributes
  struct Attributes {
    /** The source where the email verification request comes from.  Default is WEB. */
    static let source: String = "source"
 }
  
  /** The source where the email verification request comes from.  Default is WEB. */
  public func setSource(_ source: String) {
    if let value: PersonSource = PersonSource(rawValue: source) {
      attributes[Attributes.source] = value.rawValue as AnyObject
    }
  }
  
}

public class PersonSendVerificationEmailResponse: SessionEvent {
  
}

/** Verifies that the user has access to their current email address by providing the token from the email. */
public class PersonVerifyEmailRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: PersonVerifyEmailRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.personVerifyEmail
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

      let error = PersonVerifyEmailError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return PersonVerifyEmailResponse(message)
  }

  // MARK: VerifyEmailRequest Attributes
  struct Attributes {
    /** The verification token. */
    static let token: String = "token"
 }
  
  /** The verification token. */
  public func setToken(_ token: String) {
    attributes[Attributes.token] = token as AnyObject
  }

  
}

public class PersonVerifyEmailResponse: SessionEvent {
  
}

