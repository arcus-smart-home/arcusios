//
//  ArcusCatalogSorting.swift
//  i2app
//
//  Created by Arcus Team on 9/5/18.
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

protocol ArcusStringSortable {
  var sortableName: String { get }
}

func ArcusBrandSort (lhs: ArcusStringSortable, rhs: ArcusStringSortable) -> Bool {
  let lHas = lhs.sortableName == "Arcus"
  let rHas = rhs.sortableName == "Arcus"

  if lHas && !rHas {
    return true
  } else if !lHas && rHas {
    return false
  }
  //Trival Case handles if both are Arcus and both are not Arcus
  return lhs.sortableName.caseInsensitiveCompare(rhs.sortableName) == .orderedAscending
}

func ArcusProductSort (lhs: ArcusStringSortable, rhs: ArcusStringSortable) -> Bool {

  let lHas = lhs.sortableName.contains("1st Gen")
  let rHas = rhs.sortableName.contains("1st Gen")

  if lHas && !rHas {
    return false
  } else if !lHas && rHas {
    return true
  }
  //Trival Case handles if both are 1st Gen and both are not
  return lhs.sortableName.caseInsensitiveCompare(rhs.sortableName) == .orderedAscending
}
