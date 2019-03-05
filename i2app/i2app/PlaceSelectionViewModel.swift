//
//  PlaceSelectionViewModel.swift
//  i2app
//
//  Created by Arcus Team on 12/21/17.
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

/**
 Data object representing a place in the place for place selection.
 */
struct PlaceSelectionViewModel {

  /**
   Indicator for the selected place.
   */
  var isSelected = false

  /**
   Place identifier.
   */
  var identifier = ""

  /**
   Name of the place.
   */
  var title = ""

  /**
   Address of the place.
   */
  var description = ""

  /**
   Image for the place.
   */
  var image = UIImage()

}
