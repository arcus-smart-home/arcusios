//
//  SessionController.swift
//  i2app
//
//  Created by Arcus Team on 11/22/17.
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
import PromiseKit

public protocol _SessionController {
  static func listAvailablePlaces() -> PMKPromise
  static func setActivePlace(_ placeId: String) -> PMKPromise
  static func needsTermsAndConditionsConsent() -> Bool
  static func acceptNewTermsAndConditions(_ person: PersonModel,
                                          completion: @escaping () -> Void)
  //  func sessionStartTime() -> Date
}

extension _SessionController {
  public static func listAvailablePlaces() -> PMKPromise {
    return SessionServiceLegacy.listAvailablePlaces()
  }
  
  public static func setActivePlace(_ placeId: String) -> PMKPromise {
    return SessionServiceLegacy.setActivePlace(placeId)
  }
  
  public static func needsTermsAndConditionsConsent() -> Bool {
    guard let sessionInfo = RxCornea.shared.session?.sessionInfo,
    let requiresTC = sessionInfo.requiresTermsAndConditionsConsent,
    let requiresConsent = sessionInfo.requiresPrivacyPolicyConsent else {
      return false
    }

    return requiresTC || requiresConsent
  }

  public static func acceptNewTermsAndConditions(_ person: PersonModel,
                                                 completion: @escaping () -> Void) {
    if RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent == true
      && RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "TERMS").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent = false
        _ = PersonCapabilityLegacy.acceptPolicy(person, type: "PRIVACY").swiftThenInBackground({ _ in
          RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent = false
          completion()
          return nil
        })
        return nil
      })
    } else if RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "TERMS").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent = false
        completion()
        return nil
      })
    } else if RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "PRIVACY").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent = false
        completion()
        return nil
      })
    } else {
      completion()
    }
  }
}

// TODO: Fix Naming
public class SessionController: NSObject, _SessionController {
  
  // Duplicate implementation `_SessionController` in order to expose to ObjC
  
  public static func listAvailablePlaces() -> PMKPromise {
    return SessionServiceLegacy.listAvailablePlaces()
      .swiftThenInBackground({ response in
        guard let response = response as? SessionServiceListAvailablePlacesResponse,
          let placesAndRoles = response.getPlaces() as? [[String: AnyObject]] else {
            return PMKPromise.new { (_: PMKFulfiller!, rejector: PMKRejecter!) in
              rejector(nil)
            }
        }
        
        var availablePlaces: [PlaceAndRoleModel] = []
        
        for dict: [String: AnyObject] in placesAndRoles {
          let placeRoleModel: PlaceAndRoleModel = PlaceAndRoleModel(dict: dict)
          availablePlaces.append(placeRoleModel)
        }
        
        return PMKPromise.new { (fulfiller: PMKFulfiller!, _: PMKRejecter!) in
          fulfiller(availablePlaces)
        }
      })
  }
  
  public static func setActivePlace(_ placeId: String) -> PMKPromise {
    return SessionServiceLegacy.setActivePlace(placeId)
  }
  
  public static func needsTermsAndConditionsConsent() -> Bool {
    guard let sessionInfo = RxCornea.shared.session?.sessionInfo,
      let requiresTC = sessionInfo.requiresTermsAndConditionsConsent,
      let requiresConsent = sessionInfo.requiresPrivacyPolicyConsent else {
        return false
    }

    return requiresTC || requiresConsent
  }

  public static func acceptNewTermsAndConditions(_ person: PersonModel,
                                                 completion: @escaping () -> Void) {
    if RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent == true
      && RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "TERMS").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent = false
        _ = PersonCapabilityLegacy.acceptPolicy(person, type: "PRIVACY").swiftThenInBackground({ _ in
          RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent = false
          completion()
          return nil
        })
        return nil
      })
    } else if RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "TERMS").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresTermsAndConditionsConsent = false
        completion()
        return nil
      })
    } else if RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent == true {
      _ = PersonCapabilityLegacy.acceptPolicy(person, type: "PRIVACY").swiftThenInBackground({ _ in
        RxCornea.shared.session?.sessionInfo?.requiresPrivacyPolicyConsent = false
        completion()
        return nil
      })
    } else {
      completion()
    }
  }
}
