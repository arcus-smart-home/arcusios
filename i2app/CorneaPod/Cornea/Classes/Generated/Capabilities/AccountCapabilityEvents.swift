
//
// AccountCapEvents.swift
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
  /** Lists all devices associated with this account */
  static let accountListDevices: String = "account:ListDevices"
  /** Lists all hubs associated with this account */
  static let accountListHubs: String = "account:ListHubs"
  /** Lists all the places associated with this account */
  static let accountListPlaces: String = "account:ListPlaces"
  /** Lists all Recurly invoices associated with this account */
  static let accountListInvoices: String = "account:ListInvoices"
  /** Lists all adjustments associated with this account */
  static let accountListAdjustments: String = "account:ListAdjustments"
  /** Send a state transition to indicate where in the sign-up process the account is */
  static let accountSignupTransition: String = "account:SignupTransition"
  /** Updates billing info that contains Credit Card information using a token from ReCurly. */
  static let accountUpdateBillingInfoCC: String = "account:UpdateBillingInfoCC"
  /** Method invoked to inform the platform that the user has explicitly decided to skip the premium trial. */
  static let accountSkipPremiumTrial: String = "account:SkipPremiumTrial"
  /** Create a users billing account and sets up the initial subscription */
  static let accountCreateBillingAccount: String = "account:CreateBillingAccount"
  /** Updates the subscription level and addons for the specified place ID. */
  static let accountUpdateServicePlan: String = "account:UpdateServicePlan"
  /** Adds a place for this account */
  static let accountAddPlace: String = "account:AddPlace"
  /** Deletes an account with optional removal of the login */
  static let accountDelete: String = "account:Delete"
  /** An account has be marked Delinquent */
  static let accountDelinquentAccountEvent: String = "account:DelinquentAccountEvent"
  /** Creates a credit adjustment using ReCurly. */
  static let accountIssueCredit: String = "account:IssueCredit"
  /** Creates a refund of an entire invoice using ReCurly. */
  static let accountIssueInvoiceRefund: String = "account:IssueInvoiceRefund"
  /** Method invoked to signal that account signup is complete. */
  static let accountActivate: String = "account:Activate"
  /** Applies the MyArcus discount and associates this account with the specified MyArcus account.  May be called again to update the linked myArcusEmail, the resolved MyArcus account, or both. */
  static let accountApplyMyArcusDiscount: String = "account:ApplyMyArcusDiscount"
  /** Removes the MyArcus discount and disassociates this account from the specified MyArcus account */
  static let accountRemoveMyArcusDiscount: String = "account:RemoveMyArcusDiscount"
  
}

// MARK: Errors
public struct AccountApplyMyArcusDiscountError: ArcusError {
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
    /** The specified MyArcus email address was not found in MyArcus */
    case myArcusEmailNotFound = "myArcus.emailNotFound"
    /** The specified MyArcus password did not match in MyArcus */
    case myArcusPasswordMismatch = "myArcus.passwordMismatch"
    /** The specified MyArcus account will soon be locked in MyArcus */
    case myArcusAccountAlmostLocked = "myArcus.accountAlmostLocked"
    /** The specified MyArcus account has been locked in MyArcus */
    case myArcusAccountLocked = "myArcus.accountLocked"
    /** The discount for the specified MyArcus account has already been applied to another Arcus account */
    case discountInUse = "discountInUse"
    /** The specified account has no place with a Professional Monitoring service plan */
    case accountNotPromon = "accountNotPromon"
    
  }
}
// MARK: Enumerations

// MARK: Requests

/** Lists all devices associated with this account */
public class AccountListDevicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountListDevices
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
    return AccountListDevicesResponse(message)
  }

  
}

public class AccountListDevicesResponse: SessionEvent {
  
  
  /** The list of devices associated with this account */
  public func getDevices() -> [Any]? {
    return self.attributes["devices"] as? [Any]
  }
}

/** Lists all hubs associated with this account */
public class AccountListHubsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountListHubs
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
    return AccountListHubsResponse(message)
  }

  
}

public class AccountListHubsResponse: SessionEvent {
  
  
  /** The list of hubs associated with this account */
  public func getHubs() -> [Any]? {
    return self.attributes["hubs"] as? [Any]
  }
}

/** Lists all the places associated with this account */
public class AccountListPlacesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountListPlaces
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
    return AccountListPlacesResponse(message)
  }

  
}

public class AccountListPlacesResponse: SessionEvent {
  
  
  /** The list of places associated with this account */
  public func getPlaces() -> [Any]? {
    return self.attributes["places"] as? [Any]
  }
}

/** Lists all Recurly invoices associated with this account */
public class AccountListInvoicesRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountListInvoices
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
    return AccountListInvoicesResponse(message)
  }

  
}

public class AccountListInvoicesResponse: SessionEvent {
  
  
  /** The list of invoices associated with this account */
  public func getInvoices() -> [Any]? {
    return self.attributes["invoices"] as? [Any]
  }
}

/** Lists all adjustments associated with this account */
public class AccountListAdjustmentsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountListAdjustments
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
    return AccountListAdjustmentsResponse(message)
  }

  
}

public class AccountListAdjustmentsResponse: SessionEvent {
  
  
  /** The list of adjustments associated with this account */
  public func getAdjustments() -> [Any]? {
    return self.attributes["adjustments"] as? [Any]
  }
}

/** Send a state transition to indicate where in the sign-up process the account is */
public class AccountSignupTransitionRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountSignupTransitionRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountSignupTransition
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
    return AccountSignupTransitionResponse(message)
  }

  // MARK: SignupTransitionRequest Attributes
  struct Attributes {
    /** The last step the account has completed during the signup process */
    static let stepcompleted: String = "stepcompleted"
 }
  
  /** The last step the account has completed during the signup process */
  public func setStepcompleted(_ stepcompleted: String) {
    attributes[Attributes.stepcompleted] = stepcompleted as AnyObject
  }

  
}

public class AccountSignupTransitionResponse: SessionEvent {
  
}

/** Updates billing info that contains Credit Card information using a token from ReCurly. */
public class AccountUpdateBillingInfoCCRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountUpdateBillingInfoCCRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountUpdateBillingInfoCC
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
    return AccountUpdateBillingInfoCCResponse(message)
  }

  // MARK: UpdateBillingInfoCCRequest Attributes
  struct Attributes {
    /** Billing token recevied from ReCurly */
    static let billingToken: String = "billingToken"
 }
  
  /** Billing token recevied from ReCurly */
  public func setBillingToken(_ billingToken: String) {
    attributes[Attributes.billingToken] = billingToken as AnyObject
  }

  
}

public class AccountUpdateBillingInfoCCResponse: SessionEvent {
  
}

/** Method invoked to inform the platform that the user has explicitly decided to skip the premium trial. */
public class AccountSkipPremiumTrialRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountSkipPremiumTrial
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
    return AccountSkipPremiumTrialResponse(message)
  }

  
}

public class AccountSkipPremiumTrialResponse: SessionEvent {
  
}

/** Create a users billing account and sets up the initial subscription */
public class AccountCreateBillingAccountRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountCreateBillingAccountRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountCreateBillingAccount
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
    return AccountCreateBillingAccountResponse(message)
  }

  // MARK: CreateBillingAccountRequest Attributes
  struct Attributes {
    /** Billing token recevied from ReCurly */
    static let billingToken: String = "billingToken"
/** Place ID to associate the initial subscription to */
    static let placeID: String = "placeID"
 }
  
  /** Billing token recevied from ReCurly */
  public func setBillingToken(_ billingToken: String) {
    attributes[Attributes.billingToken] = billingToken as AnyObject
  }

  
  /** Place ID to associate the initial subscription to */
  public func setPlaceID(_ placeID: String) {
    attributes[Attributes.placeID] = placeID as AnyObject
  }

  
}

public class AccountCreateBillingAccountResponse: SessionEvent {
  
}

/** Updates the subscription level and addons for the specified place ID. */
public class AccountUpdateServicePlanRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountUpdateServicePlanRequest Enumerations
  /** The new service level for the specified place. */
  public enum AccountServiceLevel: String {
   case basic = "BASIC"
   case premium = "PREMIUM"
   case premium_free = "PREMIUM_FREE"
   case premium_promon_free = "PREMIUM_PROMON_FREE"
   case premium_promon = "PREMIUM_PROMON"
   
  }
  override init() {
    super.init()
    self.command = Commands.accountUpdateServicePlan
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
    return AccountUpdateServicePlanResponse(message)
  }

  // MARK: UpdateServicePlanRequest Attributes
  struct Attributes {
    /** Place ID to associate the new service plan info with. */
    static let placeID: String = "placeID"
/** The new service level for the specified place. */
    static let serviceLevel: String = "serviceLevel"
/** Map of addons to booleans indicating if the addon is active for the specified place. */
    static let addons: String = "addons"
 }
  
  /** Place ID to associate the new service plan info with. */
  public func setPlaceID(_ placeID: String) {
    attributes[Attributes.placeID] = placeID as AnyObject
  }

  
  /** The new service level for the specified place. */
  public func setServiceLevel(_ serviceLevel: String) {
    if let value: AccountServiceLevel = AccountServiceLevel(rawValue: serviceLevel) {
      attributes[Attributes.serviceLevel] = value.rawValue as AnyObject
    }
  }
  
  /** Map of addons to booleans indicating if the addon is active for the specified place. */
  public func setAddons(_ addons: Any) {
    attributes[Attributes.addons] = addons as AnyObject
  }

  
}

public class AccountUpdateServicePlanResponse: SessionEvent {
  
}

/** Adds a place for this account */
public class AccountAddPlaceRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountAddPlaceRequest Enumerations
  /** The service level the new place will be at. */
  public enum AccountServiceLevel: String {
   case basic = "BASIC"
   case premium = "PREMIUM"
   case premium_free = "PREMIUM_FREE"
   
  }
  override init() {
    super.init()
    self.command = Commands.accountAddPlace
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
    return AccountAddPlaceResponse(message)
  }

  // MARK: AddPlaceRequest Attributes
  struct Attributes {
    /** Instance of the writable place model attributes represented as a map */
    static let place: String = "place"
/** Deprecated - population will always be assigned as general for the new place. */
    static let population: String = "population"
/** The service level the new place will be at. */
    static let serviceLevel: String = "serviceLevel"
/** Map of addons to booleans indicating if the addon will be actived for the new place. */
    static let addons: String = "addons"
 }
  
  /** Instance of the writable place model attributes represented as a map */
  public func setPlace(_ place: Any) {
    guard let model = place as? ArcusModel else { return }
    attributes[Attributes.place] = model.get() as AnyObject
    
  }

  
  /** Deprecated - population will always be assigned as general for the new place. */
  public func setPopulation(_ population: String) {
    attributes[Attributes.population] = population as AnyObject
  }

  
  /** The service level the new place will be at. */
  public func setServiceLevel(_ serviceLevel: String) {
    if let value: AccountServiceLevel = AccountServiceLevel(rawValue: serviceLevel) {
      attributes[Attributes.serviceLevel] = value.rawValue as AnyObject
    }
  }
  
  /** Map of addons to booleans indicating if the addon will be actived for the new place. */
  public func setAddons(_ addons: Any) {
    attributes[Attributes.addons] = addons as AnyObject
  }

  
}

public class AccountAddPlaceResponse: SessionEvent {
  
  
  /** The newly created place */
  public func getPlace() -> Any? {
    return self.attributes["place"]
  }
}

/** Deletes an account with optional removal of the login */
public class AccountDeleteRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountDeleteRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountDelete
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
    return AccountDeleteResponse(message)
  }

  // MARK: DeleteRequest Attributes
  struct Attributes {
    /** When set to true will also remove the login for the owner of the account, false will leave it.  If not specified, defaults to false */
    static let deleteOwnerLogin: String = "deleteOwnerLogin"
 }
  
  /** When set to true will also remove the login for the owner of the account, false will leave it.  If not specified, defaults to false */
  public func setDeleteOwnerLogin(_ deleteOwnerLogin: Bool) {
    attributes[Attributes.deleteOwnerLogin] = deleteOwnerLogin as AnyObject
  }

  
}

public class AccountDeleteResponse: SessionEvent {
  
}

/** An account has be marked Delinquent */
public class AccountDelinquentAccountEventRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountDelinquentAccountEventRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountDelinquentAccountEvent
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
    return AccountDelinquentAccountEventResponse(message)
  }

  // MARK: DelinquentAccountEventRequest Attributes
  struct Attributes {
    /** The account id for the deliquent invoice */
    static let accountId: String = "accountId"
 }
  
  /** The account id for the deliquent invoice */
  public func setAccountId(_ accountId: String) {
    attributes[Attributes.accountId] = accountId as AnyObject
  }

  
}

public class AccountDelinquentAccountEventResponse: SessionEvent {
  
}

/** Creates a credit adjustment using ReCurly. */
public class AccountIssueCreditRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountIssueCreditRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountIssueCredit
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
    return AccountIssueCreditResponse(message)
  }

  // MARK: IssueCreditRequest Attributes
  struct Attributes {
    /** The amount to credit. Must be a negative amount of cents */
    static let amountInCents: String = "amountInCents"
/** The reason for the credit, or empty */
    static let description: String = "description"
 }
  
  /** The amount to credit. Must be a negative amount of cents */
  public func setAmountInCents(_ amountInCents: String) {
    attributes[Attributes.amountInCents] = amountInCents as AnyObject
  }

  
  /** The reason for the credit, or empty */
  public func setDescription(_ description: String) {
    attributes[Attributes.description] = description as AnyObject
  }

  
}

public class AccountIssueCreditResponse: SessionEvent {
  
}

/** Creates a refund of an entire invoice using ReCurly. */
public class AccountIssueInvoiceRefundRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountIssueInvoiceRefundRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountIssueInvoiceRefund
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
    return AccountIssueInvoiceRefundResponse(message)
  }

  // MARK: IssueInvoiceRefundRequest Attributes
  struct Attributes {
    /** The invoice number to refund. */
    static let invoiceNumber: String = "invoiceNumber"
 }
  
  /** The invoice number to refund. */
  public func setInvoiceNumber(_ invoiceNumber: String) {
    attributes[Attributes.invoiceNumber] = invoiceNumber as AnyObject
  }

  
}

public class AccountIssueInvoiceRefundResponse: SessionEvent {
  
}

/** Method invoked to signal that account signup is complete. */
public class AccountActivateRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountActivate
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
    return AccountActivateResponse(message)
  }

  
}

public class AccountActivateResponse: SessionEvent {
  
}

/** Applies the MyArcus discount and associates this account with the specified MyArcus account.  May be called again to update the linked myArcusEmail, the resolved MyArcus account, or both. */
public class AccountApplyMyArcusDiscountRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: AccountApplyMyArcusDiscountRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.accountApplyMyArcusDiscount
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

      let error = AccountApplyMyArcusDiscountError(code: errorCode, message: errorMessage)
      
      return SessionErrorEvent(message, error: error)
    }
    return AccountApplyMyArcusDiscountResponse(message)
  }

  // MARK: ApplyMyArcusDiscountRequest Attributes
  struct Attributes {
    /** The MyArcus email address of the account owner */
    static let myArcusEmail: String = "myArcusEmail"
/** The MyArcus password of the account owner */
    static let myArcusPassword: String = "myArcusPassword"
 }
  
  /** The MyArcus email address of the account owner */
  public func setMyArcusEmail(_ myArcusEmail: String) {
    attributes[Attributes.myArcusEmail] = myArcusEmail as AnyObject
  }

  
  /** The MyArcus password of the account owner */
  public func setMyArcusPassword(_ myArcusPassword: String) {
    attributes[Attributes.myArcusPassword] = myArcusPassword as AnyObject
  }

  
}

public class AccountApplyMyArcusDiscountResponse: SessionEvent {
  
}

/** Removes the MyArcus discount and disassociates this account from the specified MyArcus account */
public class AccountRemoveMyArcusDiscountRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.accountRemoveMyArcusDiscount
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
    return AccountRemoveMyArcusDiscountResponse(message)
  }

  
}

public class AccountRemoveMyArcusDiscountResponse: SessionEvent {
  
}

