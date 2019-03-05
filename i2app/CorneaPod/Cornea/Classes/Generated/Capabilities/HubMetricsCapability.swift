
//
// HubMetricsCap.swift
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
import RxSwift
import PromiseKit

// MARK: Constants

extension Constants {
  public static var hubMetricsNamespace: String = "hubmetric"
  public static var hubMetricsName: String = "HubMetrics"
}

// MARK: Attributes
fileprivate struct Attributes {
  static let hubMetricsMetricsjobs: String = "hubmetric:metricsjobs"
  
}

public protocol ArcusHubMetricsCapability: class, RxArcusService {
  /** List of the active metrics reporting jobs. */
  func getHubMetricsMetricsjobs(_ model: HubModel) -> [String]?
  
  /** Start a job of the given name with the given parameters. */
  func requestHubMetricsStartMetricsJob(_  model: HubModel, jobname: String, periodMs: Int, durationMs: Int, metrics: [String])
   throws -> Observable<ArcusSessionEvent>/** Instructs the hub to cancel the name metrics reporting job. */
  func requestHubMetricsEndMetricsJobs(_  model: HubModel, jobname: String)
   throws -> Observable<ArcusSessionEvent>/** Get information about a running job. */
  func requestHubMetricsGetMetricsJobInfo(_  model: HubModel, jobname: String)
   throws -> Observable<ArcusSessionEvent>/** List all of the current metrics.. */
  func requestHubMetricsListMetrics(_  model: HubModel, regex: String)
   throws -> Observable<ArcusSessionEvent>/** Retrieves the metrics stored in the long term metrics store. */
  func requestHubMetricsGetStoredMetrics(_ model: HubModel) throws -> Observable<ArcusSessionEvent>
}

extension ArcusHubMetricsCapability {
  public func getHubMetricsMetricsjobs(_ model: HubModel) -> [String]? {
    let attributes: [String: AnyObject] = model.get()
    return attributes[Attributes.hubMetricsMetricsjobs] as? [String]
  }
  
  
  public func requestHubMetricsStartMetricsJob(_  model: HubModel, jobname: String, periodMs: Int, durationMs: Int, metrics: [String])
   throws -> Observable<ArcusSessionEvent> {
    let request: HubMetricsStartMetricsJobRequest = HubMetricsStartMetricsJobRequest()
    request.source = model.address
    
    
    
    request.setJobname(jobname)
    
    request.setPeriodMs(periodMs)
    
    request.setDurationMs(durationMs)
    
    request.setMetrics(metrics)
    
    return try sendRequest(request)
  }
  
  public func requestHubMetricsEndMetricsJobs(_  model: HubModel, jobname: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubMetricsEndMetricsJobsRequest = HubMetricsEndMetricsJobsRequest()
    request.source = model.address
    
    
    
    request.setJobname(jobname)
    
    return try sendRequest(request)
  }
  
  public func requestHubMetricsGetMetricsJobInfo(_  model: HubModel, jobname: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubMetricsGetMetricsJobInfoRequest = HubMetricsGetMetricsJobInfoRequest()
    request.source = model.address
    
    
    
    request.setJobname(jobname)
    
    return try sendRequest(request)
  }
  
  public func requestHubMetricsListMetrics(_  model: HubModel, regex: String)
   throws -> Observable<ArcusSessionEvent> {
    let request: HubMetricsListMetricsRequest = HubMetricsListMetricsRequest()
    request.source = model.address
    
    
    
    request.setRegex(regex)
    
    return try sendRequest(request)
  }
  
  public func requestHubMetricsGetStoredMetrics(_ model: HubModel) throws -> Observable<ArcusSessionEvent> {
    let request: HubMetricsGetStoredMetricsRequest = HubMetricsGetStoredMetricsRequest()
    request.source = model.address
    
    
    return try sendRequest(request)
  }
  
}
