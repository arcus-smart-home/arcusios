//
//  CameraPlaybackPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/8/17.
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
import PromiseKit
import CocoaLumberjack

// TODO: Users of CameraPlaybackPresenter should store a reference to this protocol
/// Manage the different ways to start a stream, returns the url to start streaming to its delegate
/// handles the polling of the hls URL to ensure the stream is ready to view
protocol CameraPlaybackPresenterProtocol {
  weak var delegate: CameraPlaybackDelegate? { get set }
  init(delegate: CameraPlaybackDelegate?)

  /// fetchActive is true when a active fetch of a stream is taking place
  /// The presenter gaurds against more than one fetch being active
  /// An observer of fetchActive can optimize itself to not request more than one playback stream
  var fetchActive: Bool { get }

  /// start a recording from a camera
  func startRecording(withDeviceAddress address: String)

  /// start streaming from a camera
  func startStreaming(withDeviceAddress address: String)

  /// piggyback on a recording
  /// callers should be aware that if an active recording or stream is taking place the best course of action
  /// is to piggyback
  func piggyBack(onRecordingModelAddress address: String)
}

/// Custom Camera Errors for requesting recordings & streams 
enum CameraPlaybackError: Error {
  /// retryed and timed out
  case timedOut
  /// A request is already being handled
  case fetchAlreadyActive
  /// something is wrong wtih the URL sent to the CameraPlaybackPresenter
  case URLError
  /// Something unexpected has gone wrong from the platform side, please fail gracefully
  case unknownError(String)
}

protocol CameraPlaybackDelegate: class {
  /// Signifies the url is ready to begin viewing
  func cameraPlayback(presenter: CameraPlaybackPresenter,
                      didReceiveStreamUrl streamUrl: URL)
  /// An Error has occured 
  /// - seealso: CameraPlaybackError
  func cameraPlayback(presenter: CameraPlaybackPresenter,
                      didFailWithError error: Error)
}

class CameraPlaybackPresenter: CameraPlaybackPresenterProtocol,
  CamerasSubsystemController, CameraStatusController {
  weak var delegate: CameraPlaybackDelegate?

  required init(delegate: CameraPlaybackDelegate?) {
    self.delegate = delegate
  }

  fileprivate(set) var fetchActive: Bool = false

  /// Private Variables for state during the Polling request

  private var timer: Timer?
  private var currentVideoUrl: URL!
  private var currentVideoId: String?
  private var retryCounter: UInt = 0
  private let pollInterval: Double = 1 // in seconds
  private let pollAttempts: UInt = 40

  ///Start a Recording of a recorded clip
  func playRecordingModel(_ recordingModel: RecordingModel) {
    guard fetchActive != true else {
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
      delegate?.cameraPlayback(presenter: self,
                               didFailWithError: CameraPlaybackError.fetchAlreadyActive)
      return
    }
    fetchActive = true
    DispatchQueue.global(qos: .background).async {
      _ = RecordingCapability.view(on: recordingModel)
      .swiftThen({ response in
        self.fetchActive = false
        guard let res = response as? RecordingViewResponse,
          let urlString = res.getHls(),
          let url = URL(string: urlString) else {
          let message = "Incorrect Response from Server"
          ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamError)
          self.delegate?.cameraPlayback(presenter: self,
                                   didFailWithError: CameraPlaybackError.unknownError(message))
            return nil
        }
        self.delegate?.cameraPlayback(presenter: self,
                                      didReceiveStreamUrl: url)

        return nil
      })
      .swiftCatch({ err in
        self.fetchActive = false
        guard let err = err as? Error else {
          ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
          self.delegate?.cameraPlayback(presenter: self,
                                        didFailWithError: CameraPlaybackError.URLError)
          return nil
        }
        self.delegate?.cameraPlayback(presenter: self,
                                      didFailWithError: err)
        return nil
      })
    }
  }

  /// Start Piggy Backing on a RecordingModel Address
  func piggyBack(onRecordingModelAddress address: String) {
    guard fetchActive != true else {
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
      delegate?.cameraPlayback(presenter: self,
                               didFailWithError: CameraPlaybackError.fetchAlreadyActive)
      return
    }

    let record = RecordingModel(attributes: [kAttrAddress: address as AnyObject])

    fetchActive = true
    DispatchQueue.global(qos: .background).async {
      _ = record.refresh()
        .swiftThenInBackground({ _ in
          return RecordingCapability.view(on: record)
        })
        .swiftThen({ res in
          guard let res = res as? RecordingViewResponse,
            let urlString = res.getHls(),
            let url = URL(string: urlString),
            let videoID = self.streamId(withStreamURL:url) else {
              ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
              let message = "The platform responded with an unexpected format"
              self.delegate?.cameraPlayback(presenter: self,
                                            didFailWithError: CameraPlaybackError.unknownError(message))
              return nil
          }
          return self.handle(url: url, streamId: videoID)
        })
        .swiftCatch({ err in
          self.fetchActive = false
          guard let err = err as? Error else {
            ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
            self.delegate?.cameraPlayback(presenter: self,
                                          didFailWithError: CameraPlaybackError.URLError)
            return nil
          }
          self.delegate?.cameraPlayback(presenter: self,
                                        didFailWithError: err)
          return nil
        })
    }
  }


  /// Start a stream on a device,
  /// will return the caller the stream URL in a delegate method
  /// or fail with error passed in a delegate method
  func startStreaming(withDeviceAddress address: String) {
    guard fetchActive != true else {
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
      delegate?.cameraPlayback(presenter: self,
                               didFailWithError: CameraPlaybackError.fetchAlreadyActive)
      return
    }
    fetchActive = true
    DispatchQueue.global(qos: .background).async {
      guard let placeId = RxCornea.shared.settings?.currentPlace?.modelId,
        let accountId = RxCornea.shared.settings?.currentAccount?.modelId else { return }

      _ = VideoService.startRecording(withPlaceId: placeId,
                                      withAccountId: accountId,
                                      withCameraAddress: address,
                                      withStream: true,
                                      withDuration: 0)
        .swiftThen(self.handleStartRecordingResponse)
        .swiftCatch(self.handleStartRecordingError)
    }
  }

  /// Start a Recording on a device
  /// will return the caller the stream URL in a delegate method
  /// or fail with error passed in a delegate method
  func startRecording(withDeviceAddress address: String) {
    guard fetchActive != true else {
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
      delegate?.cameraPlayback(presenter: self,
                               didFailWithError: CameraPlaybackError.fetchAlreadyActive)
      return
    }
    fetchActive = true
    DispatchQueue.global(qos: .background).async {
      guard let placeId = RxCornea.shared.settings?.currentPlace?.modelId,
        let accountId = RxCornea.shared.settings?.currentAccount?.modelId else { return }

      _ = VideoService.startRecording(withPlaceId: placeId,
                                      withAccountId: accountId,
                                      withCameraAddress: address,
                                      withStream: false,
                                      withDuration: 0)
        .swiftThen(self.handleStartRecordingResponse)
        .swiftCatch(self.handleStartRecordingError)
    }
  }

  func handleStartRecordingResponse(_ res: Any?) -> PMKPromise? {
    guard let res = res as? VideoServiceStartRecordingResponse,
      let urlString = res.getHls(),
      let url = URL(string: urlString),
      let videoID = self.streamId(withStreamURL: url) else {
        ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
        let message = "The platform responded with an unexpected format"
        self.delegate?.cameraPlayback(presenter: self,
                                      didFailWithError: CameraPlaybackError.unknownError(message))
        return nil
    }
    return self.handle(url:url, streamId: videoID)
  }

  func handleStartRecordingError(_ err: Any?) -> PMKPromise? {
    self.fetchActive = false
    guard let err = err as? Error else {
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
      self.delegate?.cameraPlayback(presenter: self,
                                    didFailWithError: CameraPlaybackError.URLError)
      return nil
    }
    self.delegate?.cameraPlayback(presenter: self,
                                  didFailWithError: err)
    return nil
  }

  private func handle(url: URL, streamId: String?) -> PMKPromise? {
    self.currentVideoUrl = url
    self.currentVideoId = streamId
    DDLogInfo("Got stream url \(self.currentVideoUrl.absoluteString)")
    self.retryCounter = 0
    self.fetchVideoStream(withUrl: self.currentVideoUrl)
    return nil
  }

  private func fetchVideoStream(withUrl url: URL) {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    let task = session.dataTask(with: url) { (_, res, err) in
      guard err == nil else {
        self.fetchActive = false
        self.delegate?.cameraPlayback(presenter: self, didFailWithError: err!)
        return
      }
      guard let res = res as? HTTPURLResponse else {
        ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamFailed)
        self.fetchActive = false
        self.delegate?.cameraPlayback(presenter: self, didFailWithError: CameraPlaybackError.URLError)
        return
      }
      guard res.statusCode == 200 else {
        self.startRetryTimer()
        return
      }
      self.fetchActive = false
      self.stopRetryTimer()
      self.delegate?.cameraPlayback(presenter: self,
                                    didReceiveStreamUrl: self.currentVideoUrl)
    }
    task.resume()
  }

  private func startRetryTimer() {
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(timeInterval: self.pollInterval,
                                   target: self,
                                   selector: #selector(CameraPlaybackPresenter.attemptRetry(_:)),
                                   userInfo: nil,
                                   repeats: false)
    }
  }

  @objc fileprivate func attemptRetry(_ sender: Any) {
    if retryCounter < pollAttempts {
      DDLogInfo("Retry pulling url at \(retryCounter) times")
      fetchVideoStream(withUrl: self.currentVideoUrl)
      retryCounter += 1
    } else {
      self.fetchActive = false
      stopRetryTimer()
      ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamTimeout)
      delegate?.cameraPlayback(presenter: self, didFailWithError: CameraPlaybackError.timedOut)
    }
  }

  private func stopRetryTimer() {
    timer?.invalidate()
    timer = nil
  }

  private func streamId(withStreamURL hlsUrl: URL) -> String? {
    if hlsUrl.pathComponents.count >= 3 {
      return hlsUrl.pathComponents[2]
    }
    return nil
  }

  deinit {
    stopRetryTimer()
  }
}
