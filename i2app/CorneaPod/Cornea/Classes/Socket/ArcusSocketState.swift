//
//  ArcusSocketState.swift
//  i2app
//
//  Created by Arcus Team on 5/24/17.
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

/**
 `ArcusSocketState` enumeration of states that can that an `ArcusSocket` have.
 */
public enum ArcusSocketState {
  case uninitialized
  case connecting
  case connected
  case disconnecting
  case disconnected
  case reconnecting
  case closed
  case unknown
}
