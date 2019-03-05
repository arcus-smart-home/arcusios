
//
// PlaceCapabilityLegacy.swift
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

public class PlaceCapabilityLegacy: NSObject, ArcusPlaceCapability, ArcusPromiseConverter {
  public var disposeBag: DisposeBag = DisposeBag()
  private static let capability: PlaceCapabilityLegacy  = PlaceCapabilityLegacy()
  
  static let PlaceServiceLevelBASIC: String = PlaceServiceLevel.basic.rawValue
  static let PlaceServiceLevelPREMIUM: String = PlaceServiceLevel.premium.rawValue
  static let PlaceServiceLevelPREMIUM_FREE: String = PlaceServiceLevel.premium_free.rawValue
  static let PlaceServiceLevelPREMIUM_PROMON: String = PlaceServiceLevel.premium_promon.rawValue
  static let PlaceServiceLevelPREMIUM_PROMON_FREE: String = PlaceServiceLevel.premium_promon_free.rawValue
  static let PlaceServiceLevelPREMIUM_PROMON_MYARCUS_DISCOUNT: String = PlaceServiceLevel.premium_promon_myarcus_discount.rawValue
  

  
  public static func getAccount(_ model: PlaceModel) -> String? {
    return capability.getPlaceAccount(model)
  }
  
  public static func getPopulation(_ model: PlaceModel) -> String? {
    return capability.getPlacePopulation(model)
  }
  
  public static func getName(_ model: PlaceModel) -> String? {
    return capability.getPlaceName(model)
  }
  
  public static func setName(_ name: String, model: PlaceModel) {
    
    
    capability.setPlaceName(name, model: model)
  }
  
  public static func getState(_ model: PlaceModel) -> String? {
    return capability.getPlaceState(model)
  }
  
  public static func setState(_ state: String, model: PlaceModel) {
    
    
    capability.setPlaceState(state, model: model)
  }
  
  public static func getStreetAddress1(_ model: PlaceModel) -> String? {
    return capability.getPlaceStreetAddress1(model)
  }
  
  public static func setStreetAddress1(_ streetAddress1: String, model: PlaceModel) {
    
    
    capability.setPlaceStreetAddress1(streetAddress1, model: model)
  }
  
  public static func getStreetAddress2(_ model: PlaceModel) -> String? {
    return capability.getPlaceStreetAddress2(model)
  }
  
  public static func setStreetAddress2(_ streetAddress2: String, model: PlaceModel) {
    
    
    capability.setPlaceStreetAddress2(streetAddress2, model: model)
  }
  
  public static func getCity(_ model: PlaceModel) -> String? {
    return capability.getPlaceCity(model)
  }
  
  public static func setCity(_ city: String, model: PlaceModel) {
    
    
    capability.setPlaceCity(city, model: model)
  }
  
  public static func getStateProv(_ model: PlaceModel) -> String? {
    return capability.getPlaceStateProv(model)
  }
  
  public static func setStateProv(_ stateProv: String, model: PlaceModel) {
    
    
    capability.setPlaceStateProv(stateProv, model: model)
  }
  
  public static func getZipCode(_ model: PlaceModel) -> String? {
    return capability.getPlaceZipCode(model)
  }
  
  public static func setZipCode(_ zipCode: String, model: PlaceModel) {
    
    
    capability.setPlaceZipCode(zipCode, model: model)
  }
  
  public static func getZipPlus4(_ model: PlaceModel) -> String? {
    return capability.getPlaceZipPlus4(model)
  }
  
  public static func setZipPlus4(_ zipPlus4: String, model: PlaceModel) {
    
    
    capability.setPlaceZipPlus4(zipPlus4, model: model)
  }
  
  public static func getTzId(_ model: PlaceModel) -> String? {
    return capability.getPlaceTzId(model)
  }
  
  public static func setTzId(_ tzId: String, model: PlaceModel) {
    
    
    capability.setPlaceTzId(tzId, model: model)
  }
  
  public static func getTzName(_ model: PlaceModel) -> String? {
    return capability.getPlaceTzName(model)
  }
  
  public static func setTzName(_ tzName: String, model: PlaceModel) {
    
    
    capability.setPlaceTzName(tzName, model: model)
  }
  
  public static func getTzOffset(_ model: PlaceModel) -> NSNumber? {
    guard let tzOffset: Double = capability.getPlaceTzOffset(model) else {
      return nil
    }
    return NSNumber(value: tzOffset)
  }
  
  public static func setTzOffset(_ tzOffset: Double, model: PlaceModel) {
    
    
    capability.setPlaceTzOffset(tzOffset, model: model)
  }
  
  public static func getTzUsesDST(_ model: PlaceModel) -> NSNumber? {
    guard let tzUsesDST: Bool = capability.getPlaceTzUsesDST(model) else {
      return nil
    }
    return NSNumber(value: tzUsesDST)
  }
  
  public static func setTzUsesDST(_ tzUsesDST: Bool, model: PlaceModel) {
    
    
    capability.setPlaceTzUsesDST(tzUsesDST, model: model)
  }
  
  public static func getCountry(_ model: PlaceModel) -> String? {
    return capability.getPlaceCountry(model)
  }
  
  public static func setCountry(_ country: String, model: PlaceModel) {
    
    
    capability.setPlaceCountry(country, model: model)
  }
  
  public static func getAddrValidated(_ model: PlaceModel) -> NSNumber? {
    guard let addrValidated: Bool = capability.getPlaceAddrValidated(model) else {
      return nil
    }
    return NSNumber(value: addrValidated)
  }
  
  public static func setAddrValidated(_ addrValidated: Bool, model: PlaceModel) {
    
    
    capability.setPlaceAddrValidated(addrValidated, model: model)
  }
  
  public static func getAddrType(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrType(model)
  }
  
  public static func setAddrType(_ addrType: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrType(addrType, model: model)
  }
  
  public static func getAddrZipType(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrZipType(model)
  }
  
  public static func setAddrZipType(_ addrZipType: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrZipType(addrZipType, model: model)
  }
  
  public static func getAddrLatitude(_ model: PlaceModel) -> NSNumber? {
    guard let addrLatitude: Double = capability.getPlaceAddrLatitude(model) else {
      return nil
    }
    return NSNumber(value: addrLatitude)
  }
  
  public static func setAddrLatitude(_ addrLatitude: Double, model: PlaceModel) {
    
    
    capability.setPlaceAddrLatitude(addrLatitude, model: model)
  }
  
  public static func getAddrLongitude(_ model: PlaceModel) -> NSNumber? {
    guard let addrLongitude: Double = capability.getPlaceAddrLongitude(model) else {
      return nil
    }
    return NSNumber(value: addrLongitude)
  }
  
  public static func setAddrLongitude(_ addrLongitude: Double, model: PlaceModel) {
    
    
    capability.setPlaceAddrLongitude(addrLongitude, model: model)
  }
  
  public static func getAddrGeoPrecision(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrGeoPrecision(model)
  }
  
  public static func setAddrGeoPrecision(_ addrGeoPrecision: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrGeoPrecision(addrGeoPrecision, model: model)
  }
  
  public static func getAddrRDI(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrRDI(model)
  }
  
  public static func setAddrRDI(_ addrRDI: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrRDI(addrRDI, model: model)
  }
  
  public static func getAddrCounty(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrCounty(model)
  }
  
  public static func setAddrCounty(_ addrCounty: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrCounty(addrCounty, model: model)
  }
  
  public static func getAddrCountyFIPS(_ model: PlaceModel) -> String? {
    return capability.getPlaceAddrCountyFIPS(model)
  }
  
  public static func setAddrCountyFIPS(_ addrCountyFIPS: String, model: PlaceModel) {
    
    
    capability.setPlaceAddrCountyFIPS(addrCountyFIPS, model: model)
  }
  
  public static func getLastServiceLevelChange(_ model: PlaceModel) -> Date? {
    guard let lastServiceLevelChange: Date = capability.getPlaceLastServiceLevelChange(model) else {
      return nil
    }
    return lastServiceLevelChange
  }
  
  public static func getServiceLevel(_ model: PlaceModel) -> String? {
    return capability.getPlaceServiceLevel(model)?.rawValue
  }
  
  public static func getServiceAddons(_ model: PlaceModel) -> [String]? {
    return capability.getPlaceServiceAddons(model)
  }
  
  public static func getCreated(_ model: PlaceModel) -> Date? {
    guard let created: Date = capability.getPlaceCreated(model) else {
      return nil
    }
    return created
  }
  
  public static func getModified(_ model: PlaceModel) -> Date? {
    guard let modified: Date = capability.getPlaceModified(model) else {
      return nil
    }
    return modified
  }
  
  public static func listDevices(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceListDevices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func getHub(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceGetHub(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func startAddingDevices(_  model: PlaceModel, time: Int) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceStartAddingDevices(model, time: time))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func stopAddingDevices(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceStopAddingDevices(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func registerHub(_  model: PlaceModel, hubId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceRegisterHub(model, hubId: hubId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func addPerson(_  model: PlaceModel, person: Any, password: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceAddPerson(model, person: person, password: password))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listPersons(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceListPersons(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listPersonsWithAccess(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceListPersonsWithAccess(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listDashboardEntries(_  model: PlaceModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceListDashboardEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func listHistoryEntries(_  model: PlaceModel, limit: Int, token: String) -> PMKPromise {
  
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceListHistoryEntries(model, limit: limit, token: token))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func delete(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlaceDelete(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func createInvitation(_  model: PlaceModel, firstName: String, lastName: String, email: String, relationship: String) -> PMKPromise {
  
    
    
    
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceCreateInvitation(model, firstName: firstName, lastName: lastName, email: email, relationship: relationship))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func sendInvitation(_  model: PlaceModel, invitation: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceSendInvitation(model, invitation: invitation))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func pendingInvitations(_ model: PlaceModel) -> PMKPromise { 
    
    do {
      return try capability.promiseForObservable(capability.requestPlacePendingInvitations(model))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func cancelInvitation(_  model: PlaceModel, code: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceCancelInvitation(model, code: code))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func updateAddress(_  model: PlaceModel, streetAddress: Any) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceUpdateAddress(model, streetAddress: streetAddress))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
  public static func registerHubV2(_  model: PlaceModel, hubId: String) -> PMKPromise {
  
    
    
    do {
      return try capability.promiseForObservable(capability
        .requestPlaceRegisterHubV2(model, hubId: hubId))
    } catch {
      return PMKPromise.new { (_: PMKFulfiller?, rejecter: PMKRejecter?) in
        rejecter?(error)
      }
    }
  }
  
}
