
//
// PopulationCapEvents.swift
//
// Generated on 22/05/18
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

// MARK: Commands
fileprivate struct Commands {
  /** Returns information on all populations. */
  static let populationGetPopulations: String = "population:GetPopulations"
  
}

// MARK: Enumerations

// MARK: Requests

/** Returns information on all populations. */
public class PopulationGetPopulationsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.populationGetPopulations
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      let error = ClientError(errorType: .unknown)
      return SessionErrorEvent(message, error: error)
    }
    return PopulationGetPopulationsResponse(message)
  }

  
}

public class PopulationGetPopulationsResponse: SessionEvent {
  
  
  /**  */
  public func getPopulations() -> [Any]? {
    return self.attributes["populations"] as? [Any]
  }
}


