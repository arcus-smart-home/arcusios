//
//  CustomTag.swift
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
class CustomTag: NSObject, ArcusTag {

    fileprivate var name: String
    fileprivate var attributes: [String:AnyObject]

    init (name: String) {
        self.name = name
        self.attributes = [:]
    }

    init (name: String, attributes: [String:AnyObject]) {
        self.name = name
        self.attributes = attributes
    }

    func getName() -> String {
        return self.name
    }

    func getAttributes() -> [String:AnyObject] {
        return self.attributes
    }

    func addAttribute(_ attribute: String, value: AnyObject) {
        self.attributes[attribute] = value
    }
}
