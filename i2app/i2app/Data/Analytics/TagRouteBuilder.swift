//
//  TagRouteBuilder.swift
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
class TagRouteBuilder: NSObject {

    fileprivate var matchAll: Bool
    fileprivate var conditions: [RoutePredicate] = []
    fileprivate var destinations: [AnalyticsEndpoint]

    init (matchAll: Bool, destinations: [AnalyticsEndpoint]) {
        self.matchAll = matchAll
        self.destinations = destinations
    }

    static func routeAllTagsTo (_ endpoint: AnalyticsEndpoint) -> TagRoute {
        return TagRoute(matchAll: true, conditions: [], destinations: [endpoint])
    }

    static func routeTagsMatchingAll (_ endpoint: AnalyticsEndpoint) -> TagRouteBuilder {
        return TagRouteBuilder(matchAll: true, destinations: [endpoint])
    }

    static func routeTagsMatchingAny (_ endpoint: AnalyticsEndpoint) -> TagRouteBuilder {
        return TagRouteBuilder(matchAll: false, destinations: [endpoint])
    }

    func whereTagMatches (_ predicate: RoutePredicate) -> TagRouteBuilder {
        self.conditions.append(predicate)
        return self
    }

    func whereNameEquals (_ name: String) -> TagRouteBuilder {
        @objc
        class NameMatcher: NSObject, RoutePredicate {
            let name: String
            init (name: String) {
                self.name = name
            }
            @objc func apply(_ tag: ArcusTag) -> Bool {
                return name == tag.getName()
            }
        }

        conditions.append(NameMatcher(name: name))
        return self
    }

    func whereContainsAttribute(_ attribute: String) -> TagRouteBuilder {
        @objc
        class AttributeMatcher: NSObject, RoutePredicate {
            let attribute: String
            init (attribute: String) {
                self.attribute = attribute
            }
            @objc func apply(_ tag: ArcusTag) -> Bool {
                return tag.getAttributes().keys.contains(attribute)
            }
        }

        conditions.append(AttributeMatcher(attribute: attribute))
        return self
    }

    func build() -> TagRoute {
        return TagRoute(matchAll: self.matchAll, conditions: self.conditions, destinations: self.destinations)
    }
}
