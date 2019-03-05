//
//  ArcusSettings.swift
//  i2app
//
//  Created by Arcus Team on 10/31/17.
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
//

import Foundation

extension Constants {
  public static let kNumberOfBackgroundImages: Int = 12
  public static let kNumberOfOldBackgroundImages: Int = 6
  public static let kNumberOfNewBackgroundImages: Int = 6
  public static let kBackgroundIndexNotAssigned: Int = -1

  public static let kDoNotShowClimateTutorial: String = "DoNotShowClimateTutorial"
  public static let kDoNotShowRulesTutorial: String = "DoNotShowRulesTutorial"
  public static let kDoNotShowScenesTutorial: String = "DoNotShowScenesTutorial"
  public static let kDoNotShowSecurityTutorial: String = "DoNotShowSecurityTutorial"
  public static let kDoNotShowChoosePlaceTutorial: String = "DoNotShowChoosePlaceTutorial"
  public static let kDoNotShowHistoryTutorial: String = "DoNotShowHistoryTutorial"

  //The key used to lookup what the next image to be assigned to a place is; this is implemented person
  //independent right now, but can be modified later
  public static let kCurrentPlaceImageIndexKeyPrefix: String = "currPlaceImageIndexFor:"
  //The key used to lookup which default image is assigned to a place; this is implemented person
  //independent right now, but can be modified later
  public static let kAssignedDefaultPlaceImageIndexKeyPrefix: String = "assignedDefaultPlaceImageIndexFor:"
}

public protocol ServiceLevelable {
  static func isPremiumPlace(_ place: PlaceModel) -> Bool
  static func isProMonitoredPlace(_ place: PlaceModel) -> Bool
  static func getServiceLevelDescription(_ place: PlaceModel) -> String
  static func getInheritedServiceLevelFrom(_ place: PlaceModel) -> String
}

@objc public class AnyServiceLevelable: NSObject, ServiceLevelable {
  public static func isPremiumPlace(_ place: PlaceModel) -> Bool {
    guard let serviceLevel: String = PlaceCapabilityLegacy.getServiceLevel(place) else {
      return false
    }

    return isProMonitoredPlace(place) ||
           serviceLevel == "PREMIUM" ||
           serviceLevel == "PREMIUM_FREE"
  }
  
  public static func isProMonitoredPlace(_ place: PlaceModel) -> Bool {
    guard let serviceLevel: String = PlaceCapabilityLegacy.getServiceLevel(place) else {
      return false
    }
    
    return serviceLevel == "PREMIUM_PROMON" ||
           serviceLevel == "PREMIUM_PROMON_FREE" ||
           serviceLevel == "PREMIUM_PROMON_MYARCUS_DISCOUNT"
  }

  public static func getServiceLevelDescription(_ place: PlaceModel) -> String {
    if let serviceLevel: String = PlaceCapabilityLegacy.getServiceLevel(place),
      let plan = PlaceServiceLevel(rawValue: serviceLevel) {
      switch plan {
      case .basic:
          return "Basic Plan"
      case .premium:
          return "Premium Plan"
      case .premium_free:
          return "Premium Free Plan"
      case .premium_promon:
          return "Professional Monitoring Plan"
      case .premium_promon_free:
          return "Professional Monitoring Free Plan"
      case .premium_promon_myarcus_discount:
          return "Professional Monitoring with MyLowe's Discount"
      default:
          return "Unknown"
      }
    }
    
    return "Unknown"
  }
  
  public static func getInheritedServiceLevelFrom(_ place: PlaceModel) -> String {
    if isProMonitoredPlace(place) {
      return "PREMIUM"
    } else {
      return PlaceCapabilityLegacy.getServiceLevel(place) ?? "BASIC"
    }
  }
  
}

/**
 `ArcusSettings` protocol.
 */
public protocol ArcusSettings {
  var currentAccount: AccountModel? { get set }
  var currentHub: HubModel? { get set }
  var currentPerson: PersonModel? { get set }
  var currentPlace: PlaceModel? { get set }

  // MARK: Acccount/Person Registration

  func currentAccountState() -> AccountStateNew
  func userHasFinishedRegisteringAccount() -> Bool
  func userHasFinishedRegisteringPerson() -> Bool

  // MARK: Service Level

  func isPremiumAccount() -> Bool
  func isProMonitoredAccount() -> Bool

  func isAddressGeoPrecisionEnabled() -> Bool

  // MARK: Tutorials

  func displayClimateTutorial() -> Bool
  func displayRulesTutorial() -> Bool
  func displayScenesTutorial() -> Bool
  func displaySecurityTutorial() -> Bool
  func displayChoosePlaceTutorial() -> Bool
  func displayHistoryTutorial() -> Bool

  func setDoNotShowClimateTutorial(_ dontShow: Bool)
  func setDoNotShowRulesTutorial(_ dontShow: Bool)
  func setDoNotShowScenesTutorial(_ dontShow: Bool)
  func setDoNotShowSecurityTutorial(_ dontShow: Bool)
  func setDoNotShowChoosePlaceTutorial(_ dontShow: Bool)
  func setDoNotShowHistoryTutorial(_ dontShow: Bool)

//  // MARK: Home Image
//
//  func fetchHomeImage(_ placeId: String) -> UIImage?
//  func saveHomeImage(_ image: UIImage, placeId: String)
}

/**
 `ArcusSettings` extension.
 */
extension ArcusSettings {
  public func currentAccountState() -> AccountStateNew {
      guard let currentAccount: AccountModel = self.currentAccount else {
        return .none
      }
      guard let accountStateString = currentAccount.getAttribute("account:state") as? String else {
        return .none // TEST
      }

      return AccountStateNew.state(forString: accountStateString)
    }

  public func userHasFinishedRegisteringAccount() -> Bool {
    let currentState: AccountStateNew = currentAccountState()
    let result: Bool = currentState == .signUpComplete
    return result
  }

  public func userHasFinishedRegisteringPerson() -> Bool {
    if let currentPerson: PersonModel = self.currentPerson, currentPerson.firstName != nil {
        return currentPerson.hasPin
    }
    return true
  }

  public func isPremiumAccount() -> Bool {
    guard let currentPlace: PlaceModel = self.currentPlace else {
      return false
    }

    return AnyServiceLevelable.isPremiumPlace(currentPlace)
  }

  public func isProMonitoredAccount() -> Bool {
    guard let currentPlace: PlaceModel = self.currentPlace else {
      return false
    }

    return AnyServiceLevelable.isProMonitoredPlace(currentPlace)
  }

  public func isAddressGeoPrecisionEnabled() -> Bool {
    guard let currentPlace: PlaceModel = self.currentPlace else {
      return false
    }
    guard let precision: String = PlaceCapabilityLegacy.getAddrGeoPrecision(currentPlace) else {
      return false
    }
    if precision.count == 0 {
      return false
    }
    if precision == "NONE" {
      return false
    }
    return true
  }

  public func displayClimateTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowClimateTutorial)
  }

  public func displayRulesTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowRulesTutorial)
  }

  public func displayScenesTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowScenesTutorial)
  }

  public func displaySecurityTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowSecurityTutorial)
  }

  public func displayChoosePlaceTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowChoosePlaceTutorial)
  }

  public func displayHistoryTutorial() -> Bool {
    return !UserDefaults.standard.bool(forKey: Constants.kDoNotShowHistoryTutorial)
  }

  public func setDoNotShowClimateTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowClimateTutorial)
    UserDefaults.standard.synchronize()
  }

  public func setDoNotShowRulesTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowRulesTutorial)
    UserDefaults.standard.synchronize()
  }

  public func setDoNotShowScenesTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowScenesTutorial)
    UserDefaults.standard.synchronize()
  }

  public func setDoNotShowSecurityTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowSecurityTutorial)
    UserDefaults.standard.synchronize()
  }

  public func setDoNotShowChoosePlaceTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowChoosePlaceTutorial)
    UserDefaults.standard.synchronize()
  }

  public func setDoNotShowHistoryTutorial(_ dontShow: Bool) {
    UserDefaults.standard.set(dontShow, forKey: Constants.kDoNotShowHistoryTutorial)
    UserDefaults.standard.synchronize()
  }

//  func fetchHomeImage(_ placeId: String) -> UIImage? {
//    guard let homeImage: UIImage = AKFileManager.default().cachedImage(forHash: placeId,
//                                                                       at: UIScreen.main.bounds.size,
//                                                                       withScale: UIScreen.main.scale) else {
//        // TODO: REFACTOR INTO CLEANER IMPLEMENTATION.
//        var assignedImageIndex = getAssignedImageIndex(placeId, personId: "")
//        if assignedImageIndex == Constants.kBackgroundIndexNotAssigned {
//          var indexToAssign = getPlaceImageIndex("")
//          if indexToAssign == 0 {
//            indexToAssign = Constants.kNumberOfOldBackgroundImages
//          }
//          setAssignedImageIndex(indexToAssign, placeId: placeId, personId: "")
//
//          var nextIndex = indexToAssign + 1
//          if nextIndex >= Constants.kNumberOfBackgroundImages {
//            nextIndex = Constants.kNumberOfOldBackgroundImages
//          }
//          setNextPlaceImageIndex(nextIndex, personId: "")
//
//          assignedImageIndex = indexToAssign
//        }
//        return UIImage(named: "DashboardBackgroundImage\(assignedImageIndex)")
//    }
//    return homeImage
//  }
//
//  func saveHomeImage(_ image: UIImage, placeId: String) {
//    AKFileManager.default().cacheImage(image, forHash: placeId)
//  }

//  private func getAssignedImageIndex(_ placeId: String, personId: String) -> Int {
//    let index: Int = UserDefaults.standard.integer(forKey: assignedImageIndexKey(placeId, personId: personId))
//    if index <= 0 {
//      return Constants.kBackgroundIndexNotAssigned
//    }
//    return index - 1
//  }
//
//  private func setAssignedImageIndex(_ index: Int, placeId: String, personId: String) {
//    let defaults: UserDefaults = UserDefaults.standard
//    let modifiedIndex: Int = index + 1
//    let key: String = assignedImageIndexKey(placeId, personId: personId)
//    defaults.set(modifiedIndex, forKey: key)
//    defaults.synchronize()
//  }
//
//  private func assignedImageIndexKey(_ placeId: String, personId: String) -> String {
//    return Constants.kAssignedDefaultPlaceImageIndexKeyPrefix + placeId
//  }
//
//  private func getPlaceImageIndex(_ personId: String) -> Int {
//    let index: Int = UserDefaults.standard.integer(forKey: placeImageIndexKey(personId))
//    if index <= Constants.kNumberOfOldBackgroundImages {
//      return Constants.kNumberOfOldBackgroundImages
//    }
//    return index
//  }
//
//  private func setNextPlaceImageIndex(_ index: Int, personId: String) {
//    let defaults: UserDefaults = UserDefaults.standard
//    let key: String = placeImageIndexKey(personId)
//    defaults.set(index, forKey: key)
//    defaults.synchronize()
//  }
//
//  private func placeImageIndexKey(_ personId: String) -> String {
//    // Append the person id if it's decided that images should cycle based on person
//    // and device instead of just device - will have to migrate images then
//    return Constants.kCurrentPlaceImageIndexKeyPrefix
//  }
}
