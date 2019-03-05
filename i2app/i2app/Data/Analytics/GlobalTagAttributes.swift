//
//  GlobalTagAttributes.swift
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
open class GlobalTagAttributes: NSObject {

    fileprivate static let instance = GlobalTagAttributes()

    fileprivate var staticAttributes: [String:AnyObject] = [:]
    fileprivate var dynamicAttributes: [String:() -> AnyObject] = [:]

    fileprivate override init () {}

    static func getInstance () -> GlobalTagAttributes {
        return instance
    }

    open func getGlobalAttributes() -> [String:AnyObject] {
        var globalAttributes: [String:AnyObject] = [:]

        for thisStaticAttribute in self.staticAttributes.keys {
            globalAttributes[thisStaticAttribute] = self.staticAttributes[thisStaticAttribute]
        }

        for thisDynamicAttribute in self.dynamicAttributes.keys {
            if let dynamicAttributeProvider = self.dynamicAttributes[thisDynamicAttribute] {
                globalAttributes[thisDynamicAttribute] = dynamicAttributeProvider()
            }
        }

        return globalAttributes
    }

    open func put(_ attribute: String, withValue: AnyObject!) {
        self.staticAttributes[attribute] = withValue
    }

    open func put(_ attribute: String, withDynamicValue: @escaping () -> AnyObject) {
        self.dynamicAttributes[attribute] = withDynamicValue
    }
}
