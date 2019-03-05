
//
// PopulationCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var populationNamespace: String = "population"
  public static var populationName: String = "Population"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let populationName: String = "population:name"
  static let populationDescription: String = "population:description"
  static let populationIsDefault: String = "population:isDefault"
  
}

public protocol ArcusPopulationCapability: class, RxArcusService {
  /** Population Name */
  func getPopulationName(_ model: PopulationModel) -> String?
  /** Population Description */
  func getPopulationDescription(_ model: PopulationModel) -> String?
  /** Indicates that this population is the default population */
  func getPopulationIsDefault(_ model: PopulationModel) -> Bool?
  
  /** Returns information on all populations. */
  func requestPopulationGetPopulations(_ model: PopulationModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusPopulationCapability {
  public func getPopulationName(_ model: PopulationModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.populationName] as? String
  }
  
  public func getPopulationDescription(_ model: PopulationModel) -> String? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.populationDescription] as? String
  }
  
  public func getPopulationIsDefault(_ model: PopulationModel) -> Bool? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.populationIsDefault] as? Bool
  }
  
  
  public func requestPopulationGetPopulations(_ model: PopulationModel) throws -> Observable<ArcusSessionEvent> {
    let request: PopulationGetPopulationsRequest = PopulationGetPopulationsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
