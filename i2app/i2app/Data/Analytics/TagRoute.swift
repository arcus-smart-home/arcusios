//
//  TagRoute.swift
//  i2app
//
//  Arcus Team on 4/25/16.
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
import Cornea

@objc
class TagRoute: NSObject {

    fileprivate var matchAll: Bool
    fileprivate var conditions: [RoutePredicate]
    fileprivate var destinations: [AnalyticsEndpoint]

    init (matchAll: Bool, conditions: [RoutePredicate], destinations: [AnalyticsEndpoint]) {
        self.matchAll = matchAll
        self.conditions = conditions
        self.destinations = destinations
    }

    func route (_ tag: ArcusTag, globalAttributes: GlobalTagAttributes) {
        if apply(tag) {
            for thisEndpoint in destinations {
                thisEndpoint
                  .commitTag(tag.getName(),
                             attributes: mergeAttributes(tag.getAttributes(),
                                                         globalAttributes: GlobalTagAttributes.getInstance()))
            }
        }
    }

    fileprivate func apply (_ tag: ArcusTag) -> Bool {

        var matchesAny: Bool = false
        var matchesAll: Bool = true

        for thisCondition in self.conditions {
            if thisCondition.apply(tag) {
                matchesAny = true
            } else {
                matchesAll = false
            }
        }

      if matchAll == true {
        return matchesAll
      } else {
        return matchesAny
      }
    }

    fileprivate func mergeAttributes (_ localAttributes: [String:AnyObject],
                                      globalAttributes: GlobalTagAttributes) -> [String : AnyObject] {
        var mergedAttributes: [String:AnyObject] = [:]

        for (attribute, value) in globalAttributes.getGlobalAttributes() {
            mergedAttributes[attribute] = value
        }

        for (attribute, value) in localAttributes {
            mergedAttributes[attribute] = value
        }

        return mergedAttributes
    }

}
