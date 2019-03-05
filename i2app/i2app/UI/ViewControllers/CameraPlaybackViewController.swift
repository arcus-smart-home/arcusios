//
//  CameraPlaybackViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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
import AVKit
import AVFoundation

protocol CameraPlaybackViewController: class {
  var avPlayerViewController: AVPlayerViewController? { get set }
  var avPlayer: AVQueuePlayer? { get set }
  
  ///  to indicate not set, use NSNotFound
  var loadingIndicatorTag: Int { get set }
  
  // Key-value observing context
  var playerItemContext: Int { get set }

  //extended for UIViewControllers
  func addPlayerObservers()
  func removePlayerObservers()
  func handleNotification(forKeyPath keyPath: String?,
                          of object: Any?,
                          change: [NSKeyValueChangeKey : Any]?,
                          context: UnsafeMutableRawPointer?)
  func displayLoadingIndicator()
  func hideLoadingIndicator()
  func shouldDisplayVideo(withURL: URL)
  func shouldDisplayVideoError(err: Error)
  func handleAVPlayersDidClose(withLogging: Bool)
  func safelyDismissAVPlayerViewController()
}

extension CameraPlaybackViewController where Self: UIViewController {
  
  func addPlayerObservers() {
    avPlayer?.addObserver(self,
                          forKeyPath: #keyPath(AVPlayer.status),
                          options: [.old, .new],
                          context: &playerItemContext)
  }

  func removePlayerObservers() {
    avPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status), context: &playerItemContext)
  }

  func handleNotification(forKeyPath keyPath: String?,
                          of object: Any?,
                          change: [NSKeyValueChangeKey : Any]?,
                          context: UnsafeMutableRawPointer?) {
    guard context == &playerItemContext else {
      return
    }
    guard let incObj = object as? AVQueuePlayer,
      incObj == avPlayer else {
        return
    }
    if keyPath == #keyPath(AVPlayer.status){
      
      var status: AVPlayerItemStatus
      if let statusNumber = change?[.newKey] as? NSNumber {
        status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
      } else {
        status = .unknown
      }
      
      if status == .readyToPlay {
        // Only present something once
        guard self.presentedViewController == nil,
          let avPlayerViewController = avPlayerViewController else {
          return
        }
        present(avPlayerViewController, animated: true) {
          self.hideLoadingIndicator()
          incObj.play()
        }
      } else if status == .failed {
        safelyDismissAVPlayerViewController()
      }
    }
  }

  func displayLoadingIndicator() {
    loadingIndicatorTag = popupAlert("Loading...",
                                     type:.typeCamera,
                                     canClose: true,
                                     sceneType: .inDevice)
    createGif()
  }

  func hideLoadingIndicator() {
    if loadingIndicatorTag != NSNotFound {
      closePopupAlert(withTag: loadingIndicatorTag)
      loadingIndicatorTag = NSNotFound
    }
    hideGif()
  }
  
  func safelyDismissAVPlayerViewController() {
    ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamClosed)
    if let presented = self.presentedViewController,
      presented == avPlayerViewController {
      self.dismiss(animated: true) {
        self.hideLoadingIndicator()
      }
    }
  }

  func shouldDisplayVideo(withURL: URL) {
    ArcusAnalytics.tag(named: AnalyticsTags.DeviceCameraStreamOpened)
    let avPlayVC =  AVPlayerViewController()
    let queuePlayer = AVQueuePlayer(url: withURL)
    avPlayVC.player = queuePlayer
    avPlayerViewController = avPlayVC
    avPlayer = queuePlayer
    addPlayerObservers()
  }

  func shouldDisplayVideoError(err: Error) {
    removePlayerObservers()
    hideLoadingIndicator()
    displayGenericErrorMessageWithError(err)
  }

  func handleAVPlayersDidClose(withLogging: Bool) {
    if withLogging,
      let avPlayer = avPlayer {
      let accessLog = avPlayer.currentItem?.accessLog()
      let errorLog = avPlayer.currentItem?.errorLog()
      VideoPlayerLogger.postLogs(accessLog, errorLog: errorLog)
    }
    removePlayerObservers()
    avPlayer = nil
    avPlayerViewController = nil
  }

}
