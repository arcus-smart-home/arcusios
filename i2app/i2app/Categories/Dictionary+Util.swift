//
//  Dictionary+Key.swift
//  i2app
//
//  Created by Arcus Team on 5/18/16.
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

extension Dictionary where Value : Equatable {
    func allKeysForValue(_ val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }

    func firstKeyForValue(_ val: Value) -> Key? {
        return self.allKeysForValue(val).first
    }
}

/**
 `Dictionary` extension that allows for merging to dictionaries into one.
 */
extension Dictionary {
  mutating func merge(_ dictonary: [Key: Value]) {
    for (key, value) in dictonary {
      updateValue(value, forKey: key)
    }
  }

  mutating func outerLeftJoin(_ rightDictionary: [Key: Value]) {
    for (key, _) in rightDictionary {
      removeValue(forKey: key)
    }
  }
}
