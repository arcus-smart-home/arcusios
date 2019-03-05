
//
// HubMetricsCapEvents.swift
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

// MARK: Commands
fileprivate struct Commands {
  /** Start a job of the given name with the given parameters. */
  static let hubMetricsStartMetricsJob: String = "hubmetric:StartMetricsJob"
  /** Instructs the hub to cancel the name metrics reporting job. */
  static let hubMetricsEndMetricsJobs: String = "hubmetric:EndMetricsJobs"
  /** Get information about a running job. */
  static let hubMetricsGetMetricsJobInfo: String = "hubmetric:GetMetricsJobInfo"
  /** List all of the current metrics.. */
  static let hubMetricsListMetrics: String = "hubmetric:ListMetrics"
  /** Retrieves the metrics stored in the long term metrics store. */
  static let hubMetricsGetStoredMetrics: String = "hubmetric:GetStoredMetrics"
  
}

// MARK: Enumerations

// MARK: Requests

/** Start a job of the given name with the given parameters. */
public class HubMetricsStartMetricsJobRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubMetricsStartMetricsJobRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubMetricsStartMetricsJob
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return HubMetricsStartMetricsJobResponse(message)
  }

  // MARK: StartMetricsJobRequest Attributes
  struct Attributes {
    /** Name of the job to run. */
    static let jobname: String = "jobname"
/** How often to get metric updates. */
    static let periodMs: String = "periodMs"
/** How long to run the metrics. */
    static let durationMs: String = "durationMs"
/** Name fo the metrics to run, can be a regex to match multiple metrics. */
    static let metrics: String = "metrics"
 }
  
  /** Name of the job to run. */
  public func setJobname(_ jobname: String) {
    attributes[Attributes.jobname] = jobname as AnyObject
  }

  
  /** How often to get metric updates. */
  public func setPeriodMs(_ periodMs: Int) {
    attributes[Attributes.periodMs] = periodMs as AnyObject
  }

  
  /** How long to run the metrics. */
  public func setDurationMs(_ durationMs: Int) {
    attributes[Attributes.durationMs] = durationMs as AnyObject
  }

  
  /** Name fo the metrics to run, can be a regex to match multiple metrics. */
  public func setMetrics(_ metrics: [String]) {
    attributes[Attributes.metrics] = metrics as AnyObject
  }

  
}

public class HubMetricsStartMetricsJobResponse: SessionEvent {
  
}

/** Instructs the hub to cancel the name metrics reporting job. */
public class HubMetricsEndMetricsJobsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubMetricsEndMetricsJobsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubMetricsEndMetricsJobs
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return HubMetricsEndMetricsJobsResponse(message)
  }

  // MARK: EndMetricsJobsRequest Attributes
  struct Attributes {
    /** Name of the job to stop stopping. */
    static let jobname: String = "jobname"
 }
  
  /** Name of the job to stop stopping. */
  public func setJobname(_ jobname: String) {
    attributes[Attributes.jobname] = jobname as AnyObject
  }

  
}

public class HubMetricsEndMetricsJobsResponse: SessionEvent {
  
}

/** Get information about a running job. */
public class HubMetricsGetMetricsJobInfoRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubMetricsGetMetricsJobInfoRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubMetricsGetMetricsJobInfo
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return HubMetricsGetMetricsJobInfoResponse(message)
  }

  // MARK: GetMetricsJobInfoRequest Attributes
  struct Attributes {
    /** Name of the job to fetch details about. */
    static let jobname: String = "jobname"
 }
  
  /** Name of the job to fetch details about. */
  public func setJobname(_ jobname: String) {
    attributes[Attributes.jobname] = jobname as AnyObject
  }

  
}

public class HubMetricsGetMetricsJobInfoResponse: SessionEvent {
  
  
  /** How often to get metrics get updates. */
  public func getPeriodMs() -> Int? {
    return self.attributes["periodMs"] as? Int
  }
  /** How much longer the job will run. */
  public func getRemainingDurationMs() -> Int? {
    return self.attributes["remainingDurationMs"] as? Int
  }
}

/** List all of the current metrics.. */
public class HubMetricsListMetricsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: HubMetricsListMetricsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.hubMetricsListMetrics
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return HubMetricsListMetricsResponse(message)
  }

  // MARK: ListMetricsRequest Attributes
  struct Attributes {
    /** Name of the metrics to view. */
    static let regex: String = "regex"
 }
  
  /** Name of the metrics to view. */
  public func setRegex(_ regex: String) {
    attributes[Attributes.regex] = regex as AnyObject
  }

  
}

public class HubMetricsListMetricsResponse: SessionEvent {
  
  
  /** The names of all metrics matching the regex. */
  public func getMetrics() -> [String]? {
    return self.attributes["metrics"] as? [String]
  }
}

/** Retrieves the metrics stored in the long term metrics store. */
public class HubMetricsGetStoredMetricsRequest: ClientMessage, ArcusClientRequest {
  
  override init() {
    super.init()
    self.command = Commands.hubMetricsGetStoredMetrics
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return HubMetricsGetStoredMetricsResponse(message)
  }

  
}

public class HubMetricsGetStoredMetricsResponse: SessionEvent {
  
  
  /** A gzip compressed and base64 encoded list&lt;HubMetric&gt;. */
  public func getMetrics() -> String? {
    return self.attributes["metrics"] as? String
  }
}

