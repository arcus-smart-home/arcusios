
//
// PlaceCap.swift
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
  public static var placeNamespace: String = "place"
  public static var placeName: String = "Place"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let placeAccount: String = "place:account"
  static let placePopulation: String = "place:population"
  static let placeName: String = "place:name"
  static let placeState: String = "place:state"
  static let placeStreetAddress1: String = "place:streetAddress1"
  static let placeStreetAddress2: String = "place:streetAddress2"
  static let placeCity: String = "place:city"
  static let placeStateProv: String = "place:stateProv"
  static let placeZipCode: String = "place:zipCode"
  static let placeZipPlus4: String = "place:zipPlus4"
  static let placeTzId: String = "place:tzId"
  static let placeTzName: String = "place:tzName"
  static let placeTzOffset: String = "place:tzOffset"
  static let placeTzUsesDST: String = "place:tzUsesDST"
  static let placeCountry: String = "place:country"
  static let placeAddrValidated: String = "place:addrValidated"
  static let placeAddrType: String = "place:addrType"
  static let placeAddrZipType: String = "place:addrZipType"
  static let placeAddrLatitude: String = "place:addrLatitude"
  static let placeAddrLongitude: String = "place:addrLongitude"
  static let placeAddrGeoPrecision: String = "place:addrGeoPrecision"
  static let placeAddrRDI: String = "place:addrRDI"
  static let placeAddrCounty: String = "place:addrCounty"
  static let placeAddrCountyFIPS: String = "place:addrCountyFIPS"
  static let placeLastServiceLevelChange: String = "place:lastServiceLevelChange"
  static let placeServiceLevel: String = "place:serviceLevel"
  static let placeServiceAddons: String = "place:serviceAddons"
  static let placeCreated: String = "place:created"
  static let placeModified: String = "place:modified"
  
}

public protocol ArcusPlaceCapability: class, RxArcusService {
  /** Platform-owned globally unique identifier for the account owning the place */
  func getPlaceAccount(_ model: PlaceModel) -> String?
  /** Indicates the population name this place belongs to. If not specified, the general population will be assumed */
  func getPlacePopulation(_ model: PlaceModel) -> String?
  /** The name of the place */
  func getPlaceName(_ model: PlaceModel) -> String?
  /** The name of the place */
  func setPlaceName(_ name: String, model: PlaceModel)
/** The state of the place */
  func getPlaceState(_ model: PlaceModel) -> String?
  /** The state of the place */
  func setPlaceState(_ state: String, model: PlaceModel)
/** First part of the street address */
  func getPlaceStreetAddress1(_ model: PlaceModel) -> String?
  /** First part of the street address */
  func setPlaceStreetAddress1(_ streetAddress1: String, model: PlaceModel)
/** Second part of the street address */
  func getPlaceStreetAddress2(_ model: PlaceModel) -> String?
  /** Second part of the street address */
  func setPlaceStreetAddress2(_ streetAddress2: String, model: PlaceModel)
/** The city */
  func getPlaceCity(_ model: PlaceModel) -> String?
  /** The city */
  func setPlaceCity(_ city: String, model: PlaceModel)
/** The state or province */
  func getPlaceStateProv(_ model: PlaceModel) -> String?
  /** The state or province */
  func setPlaceStateProv(_ stateProv: String, model: PlaceModel)
/** The zip code */
  func getPlaceZipCode(_ model: PlaceModel) -> String?
  /** The zip code */
  func setPlaceZipCode(_ zipCode: String, model: PlaceModel)
/** Extended zip +4 digits */
  func getPlaceZipPlus4(_ model: PlaceModel) -> String?
  /** Extended zip +4 digits */
  func setPlaceZipPlus4(_ zipPlus4: String, model: PlaceModel)
/** System assigned timezone identifier */
  func getPlaceTzId(_ model: PlaceModel) -> String?
  /** System assigned timezone identifier */
  func setPlaceTzId(_ tzId: String, model: PlaceModel)
/** Timezone as Alaska, Atlantic, Central, Eastern, Hawaii, Mountain, None, Pacific, Samoa, UTC+10, UTC+11, UTC+12, UTC+9, valid only for US addresses */
  func getPlaceTzName(_ model: PlaceModel) -> String?
  /** Timezone as Alaska, Atlantic, Central, Eastern, Hawaii, Mountain, None, Pacific, Samoa, UTC+10, UTC+11, UTC+12, UTC+9, valid only for US addresses */
  func setPlaceTzName(_ tzName: String, model: PlaceModel)
/** Timezone hour offset from UTC [-9, -4, -6, -5, -10, -7, 0, -8, -11, 10, 11, 12, 9], valid only for US addresses */
  func getPlaceTzOffset(_ model: PlaceModel) -> Double?
  /** Timezone hour offset from UTC [-9, -4, -6, -5, -10, -7, 0, -8, -11, 10, 11, 12, 9], valid only for US addresses */
  func setPlaceTzOffset(_ tzOffset: Double, model: PlaceModel)
/** True if timezone uses daylight savings time, false otherwise */
  func getPlaceTzUsesDST(_ model: PlaceModel) -> Bool?
  /** True if timezone uses daylight savings time, false otherwise */
  func setPlaceTzUsesDST(_ tzUsesDST: Bool, model: PlaceModel)
/** The country */
  func getPlaceCountry(_ model: PlaceModel) -> String?
  /** The country */
  func setPlaceCountry(_ country: String, model: PlaceModel)
/** True if address is US address and passed USPS address validation */
  func getPlaceAddrValidated(_ model: PlaceModel) -> Bool?
  /** True if address is US address and passed USPS address validation */
  func setPlaceAddrValidated(_ addrValidated: Bool, model: PlaceModel)
/** Address type according to address validation service [F=firm (best), G=general (held at local post office), H=high-rise (contains apartment no.), P=PO box, R=rural route, S=street (addr only matched to valid range of house numbers on street), blank (invalid)] */
  func getPlaceAddrType(_ model: PlaceModel) -> String?
  /** Address type according to address validation service [F=firm (best), G=general (held at local post office), H=high-rise (contains apartment no.), P=PO box, R=rural route, S=street (addr only matched to valid range of house numbers on street), blank (invalid)] */
  func setPlaceAddrType(_ addrType: String, model: PlaceModel)
/** Zip code type [Unique, Military, POBox, Standard] */
  func getPlaceAddrZipType(_ model: PlaceModel) -> String?
  /** Zip code type [Unique, Military, POBox, Standard] */
  func setPlaceAddrZipType(_ addrZipType: String, model: PlaceModel)
/** Approximate latitude of address (averaged over zipcode) */
  func getPlaceAddrLatitude(_ model: PlaceModel) -> Double?
  /** Approximate latitude of address (averaged over zipcode) */
  func setPlaceAddrLatitude(_ addrLatitude: Double, model: PlaceModel)
/** Approximate longitude of address (averaged over zipcode) */
  func getPlaceAddrLongitude(_ model: PlaceModel) -> Double?
  /** Approximate longitude of address (averaged over zipcode) */
  func setPlaceAddrLongitude(_ addrLongitude: Double, model: PlaceModel)
/** Precision of address lat,long [Unknown, None, Zip5, Zip6, Zip7, Zip8, Zip9] */
  func getPlaceAddrGeoPrecision(_ model: PlaceModel) -> String?
  /** Precision of address lat,long [Unknown, None, Zip5, Zip6, Zip7, Zip8, Zip9] */
  func setPlaceAddrGeoPrecision(_ addrGeoPrecision: String, model: PlaceModel)
/** USPS Residential Delivery Indicatory for address [Residential, Commercial, Unknown] */
  func getPlaceAddrRDI(_ model: PlaceModel) -> String?
  /** USPS Residential Delivery Indicatory for address [Residential, Commercial, Unknown] */
  func setPlaceAddrRDI(_ addrRDI: String, model: PlaceModel)
/** County name */
  func getPlaceAddrCounty(_ model: PlaceModel) -> String?
  /** County name */
  func setPlaceAddrCounty(_ addrCounty: String, model: PlaceModel)
/** 5 digit FIPS code as 2 digit FIPS and 3 digit county code */
  func getPlaceAddrCountyFIPS(_ model: PlaceModel) -> String?
  /** 5 digit FIPS code as 2 digit FIPS and 3 digit county code */
  func setPlaceAddrCountyFIPS(_ addrCountyFIPS: String, model: PlaceModel)
/** Date of last change to the service level at this place */
  func getPlaceLastServiceLevelChange(_ model: PlaceModel) -> Date?
  /** Platform-owned service level at this place */
  func getPlaceServiceLevel(_ model: PlaceModel) -> PlaceServiceLevel?
  /** Platform-owned set of service addons subscribed to at this place */
  func getPlaceServiceAddons(_ model: PlaceModel) -> [String]?
  /** Date of creation of the place. */
  func getPlaceCreated(_ model: PlaceModel) -> Date?
  /** Last time that the place was modified. */
  func getPlaceModified(_ model: PlaceModel) -> Date?
  
  /** Lists all devices associated with this place */
  func requestPlaceListDevices(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Retrieves the object representing the hub at this place or null if the place has no hub */
  func requestPlaceGetHub(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Prepares this location to have devices added (paired) any devices added during this time will emit the device added event */
  func requestPlaceStartAddingDevices(_  model: PlaceModel, time: Int)
   throws -> Observable<ArcusSessionEvent>/** Cleans up anything enabled into the home for having devices added (paired) */
  func requestPlaceStopAddingDevices(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Registered a hub at this place.  At some point later the HubAddedEvent will be posted */
  func requestPlaceRegisterHub(_  model: PlaceModel, hubId: String)
   throws -> Observable<ArcusSessionEvent>/** Add a new person with permissions to this place. */
  func requestPlaceAddPerson(_  model: PlaceModel, person: Any, password: String)
   throws -> Observable<ArcusSessionEvent>/** The list of persons who have access to this place. */
  func requestPlaceListPersons(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** The list of persons who have access to this place plus their role */
  func requestPlaceListPersonsWithAccess(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Returns a list of the high-importance history log entries associated with this place */
  func requestPlaceListDashboardEntries(_  model: PlaceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>/** Returns a list of all the history log entries associated with this place */
  func requestPlaceListHistoryEntries(_  model: PlaceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent>/** Remove the place and any associated entities. */
  func requestPlaceDelete(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Creates an invitation for the user */
  func requestPlaceCreateInvitation(_  model: PlaceModel, firstName: String, lastName: String, email: String, relationship: String)
   throws -> Observable<ArcusSessionEvent>/** Sends the given invitation */
  func requestPlaceSendInvitation(_  model: PlaceModel, invitation: Any)
   throws -> Observable<ArcusSessionEvent>/** Lists all pending invitations for the place */
  func requestPlacePendingInvitations(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent>/** Cancels and deletes an invitation */
  func requestPlaceCancelInvitation(_  model: PlaceModel, code: String)
   throws -> Observable<ArcusSessionEvent>/** Updates the current place&#x27;s address if it is changed and potentially other third-party systems.  The address is optional and if not specified will use the address of the current place. */
  func requestPlaceUpdateAddress(_  model: PlaceModel, streetAddress: Any)
   throws -> Observable<ArcusSessionEvent>/** This attempts to register the addressed place with the given hub.  This call will not succeed until the hub is (1) online and (2) above the minimum firmware version.  At that point the call is idempotent, so may be safely retried. */
  func requestPlaceRegisterHubV2(_  model: PlaceModel, hubId: String)
   throws -> Observable<ArcusSessionEvent>
}

extension ArcusPlaceCapability {
  public func getPlaceAccount(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAccount] as? String
  }
  
  public func getPlacePopulation(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placePopulation] as? String
  }
  
  public func getPlaceName(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeName] as? String
  }
  
  public func setPlaceName(_ name: String, model: PlaceModel) {
    model.set([Attributes.placeName: name as AnyObject])
  }
  public func getPlaceState(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeState] as? String
  }
  
  public func setPlaceState(_ state: String, model: PlaceModel) {
    model.set([Attributes.placeState: state as AnyObject])
  }
  public func getPlaceStreetAddress1(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeStreetAddress1] as? String
  }
  
  public func setPlaceStreetAddress1(_ streetAddress1: String, model: PlaceModel) {
    model.set([Attributes.placeStreetAddress1: streetAddress1 as AnyObject])
  }
  public func getPlaceStreetAddress2(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeStreetAddress2] as? String
  }
  
  public func setPlaceStreetAddress2(_ streetAddress2: String, model: PlaceModel) {
    model.set([Attributes.placeStreetAddress2: streetAddress2 as AnyObject])
  }
  public func getPlaceCity(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeCity] as? String
  }
  
  public func setPlaceCity(_ city: String, model: PlaceModel) {
    model.set([Attributes.placeCity: city as AnyObject])
  }
  public func getPlaceStateProv(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeStateProv] as? String
  }
  
  public func setPlaceStateProv(_ stateProv: String, model: PlaceModel) {
    model.set([Attributes.placeStateProv: stateProv as AnyObject])
  }
  public func getPlaceZipCode(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeZipCode] as? String
  }
  
  public func setPlaceZipCode(_ zipCode: String, model: PlaceModel) {
    model.set([Attributes.placeZipCode: zipCode as AnyObject])
  }
  public func getPlaceZipPlus4(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeZipPlus4] as? String
  }
  
  public func setPlaceZipPlus4(_ zipPlus4: String, model: PlaceModel) {
    model.set([Attributes.placeZipPlus4: zipPlus4 as AnyObject])
  }
  public func getPlaceTzId(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeTzId] as? String
  }
  
  public func setPlaceTzId(_ tzId: String, model: PlaceModel) {
    model.set([Attributes.placeTzId: tzId as AnyObject])
  }
  public func getPlaceTzName(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeTzName] as? String
  }
  
  public func setPlaceTzName(_ tzName: String, model: PlaceModel) {
    model.set([Attributes.placeTzName: tzName as AnyObject])
  }
  public func getPlaceTzOffset(_ model: PlaceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeTzOffset] as? Double
  }
  
  public func setPlaceTzOffset(_ tzOffset: Double, model: PlaceModel) {
    model.set([Attributes.placeTzOffset: tzOffset as AnyObject])
  }
  public func getPlaceTzUsesDST(_ model: PlaceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeTzUsesDST] as? Bool
  }
  
  public func setPlaceTzUsesDST(_ tzUsesDST: Bool, model: PlaceModel) {
    model.set([Attributes.placeTzUsesDST: tzUsesDST as AnyObject])
  }
  public func getPlaceCountry(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeCountry] as? String
  }
  
  public func setPlaceCountry(_ country: String, model: PlaceModel) {
    model.set([Attributes.placeCountry: country as AnyObject])
  }
  public func getPlaceAddrValidated(_ model: PlaceModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrValidated] as? Bool
  }
  
  public func setPlaceAddrValidated(_ addrValidated: Bool, model: PlaceModel) {
    model.set([Attributes.placeAddrValidated: addrValidated as AnyObject])
  }
  public func getPlaceAddrType(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrType] as? String
  }
  
  public func setPlaceAddrType(_ addrType: String, model: PlaceModel) {
    model.set([Attributes.placeAddrType: addrType as AnyObject])
  }
  public func getPlaceAddrZipType(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrZipType] as? String
  }
  
  public func setPlaceAddrZipType(_ addrZipType: String, model: PlaceModel) {
    model.set([Attributes.placeAddrZipType: addrZipType as AnyObject])
  }
  public func getPlaceAddrLatitude(_ model: PlaceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrLatitude] as? Double
  }
  
  public func setPlaceAddrLatitude(_ addrLatitude: Double, model: PlaceModel) {
    model.set([Attributes.placeAddrLatitude: addrLatitude as AnyObject])
  }
  public func getPlaceAddrLongitude(_ model: PlaceModel) -> Double? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrLongitude] as? Double
  }
  
  public func setPlaceAddrLongitude(_ addrLongitude: Double, model: PlaceModel) {
    model.set([Attributes.placeAddrLongitude: addrLongitude as AnyObject])
  }
  public func getPlaceAddrGeoPrecision(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrGeoPrecision] as? String
  }
  
  public func setPlaceAddrGeoPrecision(_ addrGeoPrecision: String, model: PlaceModel) {
    model.set([Attributes.placeAddrGeoPrecision: addrGeoPrecision as AnyObject])
  }
  public func getPlaceAddrRDI(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrRDI] as? String
  }
  
  public func setPlaceAddrRDI(_ addrRDI: String, model: PlaceModel) {
    model.set([Attributes.placeAddrRDI: addrRDI as AnyObject])
  }
  public func getPlaceAddrCounty(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrCounty] as? String
  }
  
  public func setPlaceAddrCounty(_ addrCounty: String, model: PlaceModel) {
    model.set([Attributes.placeAddrCounty: addrCounty as AnyObject])
  }
  public func getPlaceAddrCountyFIPS(_ model: PlaceModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeAddrCountyFIPS] as? String
  }
  
  public func setPlaceAddrCountyFIPS(_ addrCountyFIPS: String, model: PlaceModel) {
    model.set([Attributes.placeAddrCountyFIPS: addrCountyFIPS as AnyObject])
  }
  public func getPlaceLastServiceLevelChange(_ model: PlaceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.placeLastServiceLevelChange] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPlaceServiceLevel(_ model: PlaceModel) -> PlaceServiceLevel? {
    let attributes: [String: AnyObject] = model.get()
    guard let attribute = attributes[Attributes.placeServiceLevel] as? String,
      let enumAttr: PlaceServiceLevel = PlaceServiceLevel(rawValue: attribute) else { return nil }
    return enumAttr
  }
  
  public func getPlaceServiceAddons(_ model: PlaceModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.placeServiceAddons] as? [String]
  }
  
  public func getPlaceCreated(_ model: PlaceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.placeCreated] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  public func getPlaceModified(_ model: PlaceModel) -> Date? {
    let attributes: [String: AnyObject] = model.get()
    
    if let timestamp = attributes[Attributes.placeModified] as? Double {
      return Date(milliseconds: timestamp)
    }
    return nil
  }
  
  
  public func requestPlaceListDevices(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceListDevicesRequest = PlaceListDevicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceGetHub(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceGetHubRequest = PlaceGetHubRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceStartAddingDevices(_  model: PlaceModel, time: Int)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceStartAddingDevicesRequest = PlaceStartAddingDevicesRequest()
    request.source = model.address
    
    
    
    request.setTime(time)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceStopAddingDevices(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceStopAddingDevicesRequest = PlaceStopAddingDevicesRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceRegisterHub(_  model: PlaceModel, hubId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceRegisterHubRequest = PlaceRegisterHubRequest()
    request.source = model.address
    
    
    
    request.setHubId(hubId)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceAddPerson(_  model: PlaceModel, person: Any, password: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceAddPersonRequest = PlaceAddPersonRequest()
    request.source = model.address
    
    
    
    request.setPerson(person)
    
    request.setPassword(password)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceListPersons(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceListPersonsRequest = PlaceListPersonsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceListPersonsWithAccess(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceListPersonsWithAccessRequest = PlaceListPersonsWithAccessRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceListDashboardEntries(_  model: PlaceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceListDashboardEntriesRequest = PlaceListDashboardEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceListHistoryEntries(_  model: PlaceModel, limit: Int, token: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceListHistoryEntriesRequest = PlaceListHistoryEntriesRequest()
    request.source = model.address
    
    
    
    request.setLimit(limit)
    
    request.setToken(token)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceDelete(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlaceDeleteRequest = PlaceDeleteRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceCreateInvitation(_  model: PlaceModel, firstName: String, lastName: String, email: String, relationship: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceCreateInvitationRequest = PlaceCreateInvitationRequest()
    request.source = model.address
    
    
    
    request.setFirstName(firstName)
    
    request.setLastName(lastName)
    
    request.setEmail(email)
    
    request.setRelationship(relationship)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceSendInvitation(_  model: PlaceModel, invitation: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceSendInvitationRequest = PlaceSendInvitationRequest()
    request.source = model.address
    
    
    
    request.setInvitation(invitation)
    
    return try sendRequest(request)
  }
  
  public func requestPlacePendingInvitations(_ model: PlaceModel) throws -> Observable<ArcusSessionEvent> {
    let request: PlacePendingInvitationsRequest = PlacePendingInvitationsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
  public func requestPlaceCancelInvitation(_  model: PlaceModel, code: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceCancelInvitationRequest = PlaceCancelInvitationRequest()
    request.source = model.address
    
    
    
    request.setCode(code)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceUpdateAddress(_  model: PlaceModel, streetAddress: Any)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceUpdateAddressRequest = PlaceUpdateAddressRequest()
    request.source = model.address
    
    
    
    request.setStreetAddress(streetAddress)
    
    return try sendRequest(request)
  }
  
  public func requestPlaceRegisterHubV2(_  model: PlaceModel, hubId: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: PlaceRegisterHubV2Request = PlaceRegisterHubV2Request()
    request.source = model.address
    
    
    
    request.setHubId(hubId)
    
    return try sendRequest(request)
  }
  
}
