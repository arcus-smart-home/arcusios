
//
// Somfy1CapEvents.swift
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


// MARK: Enumerations

/** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
public enum Somfy1Mode: String {
  case shade = "SHADE"
  case blind = "BLIND"
}

/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
public enum Somfy1Reversed: String {
  case normal = "NORMAL"
  case reversed = "REVERSED"
}

// MARK: Requests

