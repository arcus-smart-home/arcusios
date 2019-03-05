//
//  CameraClipsDownloadPresenter.swift
//  i2app
//
//  Created by Arcus Team on 6/9/16.
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
import Proposer
import MZDownloadManager
import AssetsLibrary
import CocoaLumberjack

@objc protocol CameraClipsDownloadCallback: class {
  // currentId is nil if no devices found to be currently downloading
  func isDownloading(_ currentId: String?)

  // showProgress -1 for finished
  func showProgress(_ progress: Float)

  func showPermissionsError()
  func showDownloadSpaceError()
  func showDownloadError()
  func showDownloadInProgressError()

  func showDownloadStarted()
}

class CameraClipsDownloadPresenter: NSObject, MZDownloadManagerDelegate {
  static let sharedInstance = CameraClipsDownloadPresenter()

  fileprivate weak var callback: CameraClipsDownloadCallback?
  fileprivate weak var userDefaults: UserDefaults?

  var downloadingId: String? {
    get {
      return self.userDefaults?.value(forKey: "currentDownloadingId") as? String
    }
    set(value) {
      self.userDefaults?.set(value, forKey: "currentDownloadingId")
    }
  }

  fileprivate var downloadSize: Int = -1

  fileprivate lazy var downloadManager: MZDownloadManager = {
    [unowned self] in

    let sessionIdentifier: String = ""

    let downloadManager = MZDownloadManager(session: sessionIdentifier,
                                            delegate: self,
                                            completion: nil)

    return downloadManager
    }()

  override init() { }

  // Must call setup before acting upon this singleton manager
  // This isn't the best way to handle this but the download manager
  // loses progress across instances.
  @objc func setup(_ callback: CameraClipsDownloadCallback, userDefaults: UserDefaults) {
    self.callback = callback
    self.userDefaults = userDefaults

    if self.downloadManager.downloadingArray.count > 0 {
      DDLogInfo("Downloading!")
      // Show Banner
      self.callback?.showProgress(0.0)

      // Show Progress
      let progress = self.downloadManager.downloadingArray[0].progress

      if progress > 0.0 {
        self.callback?.showProgress(self.downloadManager.downloadingArray[0].progress)
      }
    } else {
      // If we're not currently downloading anything according to the manager
      // then set the downloading Id to nil so that we can clear if we've lost
      // our ability to tell what is going on with the download.
      self.downloadingId = nil
    }

    // Disable the current clip that is downloading
    if let modelId = self.downloadingId {
      self.callback?.isDownloading(modelId)
    } else {
      self.callback?.isDownloading(nil)
    }
  }

  // MARK: Camera Downloading Model Handling

  @objc func clearDownloadingModel() {
    self.downloadingId = nil
  }

  // MARK: Camera Clips Downloader

  func downloadClip(_ model: ClipItem) {
    guard self.callback != nil && self.userDefaults != nil else {
      DDLogError("CameraClipsDownloadPresenter was called upon without setup!!!")
      return
    }

    // Check if download is currently running
    if self.downloadManager.downloadingArray.count > 0 {
      self.callback?.showDownloadInProgressError()
      return
    }

    DispatchQueue.global(qos: .background).async {
      let recordingModel = model.recordingModel

      _ = RecordingCapability.download(on: recordingModel).swiftThen { response in
        if let recordingResponse = (response as? RecordingDownloadResponse) {

          // Set to downloading
          self.downloadingId = recordingModel.modelId as String?
          self.callback?.isDownloading(self.downloadingId)

          // Fetch the video from the url
          guard let cString = recordingResponse.getMp4()?.cString(using: String.Encoding.isoLatin1),
            let sizeEstimate = recordingResponse.getMp4SizeEstimate() else {
            return nil
          }

          let decodedString: String = String(cString: cString)

          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "YYYY-MM-dd-HH-mm"

          if let date = recordingModel.recordingTime() as? Date {
            let dateString = dateFormatter.string(from: date)

            let camera = RecordingCapability.getCameraidFrom(recordingModel).components(separatedBy: "-")[0]

            let fileName: String = "\(dateString)-\(camera).mp4"

            self.fetchDownload(fileName,
                               urlString: decodedString,
                               downloadSize: sizeEstimate)
          }
        }

        return nil
        }
        .swiftCatch { _ in
          self.callback?.showDownloadError()

          return nil
      }
    }
  }

  fileprivate func fetchDownload(_ fileName: String, urlString: String, downloadSize: Int) {
    // Check for Photos Permissions
    let photos: PrivateResource = .photos

    proposeToAccess(photos, agreed: {
      // Download Video and Save
      self.downloadSize = downloadSize

      let fileUrl: NSString = urlString as NSString

      self.downloadManager.addDownloadTask(fileName, fileURL: fileUrl as String)

      // Download Started
      self.callback?.showDownloadStarted()

    }, rejected: {
      // Show Permissions Error
      self.callback?.showPermissionsError()
    })
  }

  @objc func cancelDownload() {
    if self.downloadManager.downloadingArray.count > 0 {
      self.downloadManager.cancelTaskAtIndex(0)
      self.cleanup()
    }
  }

  // MARK: Camera Clips Save/Removal

  fileprivate func saveClipToCameraRoll(_ fileUrl: URL) {
    ALAssetsLibrary().writeVideoAtPath(toSavedPhotosAlbum: fileUrl) {
      (_, error) in

      if error != nil {
        self.callback?.showDownloadError()
      } else {
        // Done Saving

        // Remove App Clip
        self.removeDownloadedClip(fileUrl)
      }
    }
  }

  fileprivate func removeDownloadedClip(_ fileUrl: URL) {
    do {
      try FileManager.default.removeItem(at: fileUrl)
    } catch {
      DDLogError("Error while deleting file: \(error)")
      // TODO: Tell fabric that files aren't deleting
    }
  }

  // MARK: Device Space Check

  fileprivate func hasRequiredSpace(_ requiredSpace: CUnsignedLongLong) -> Bool {
    if requiredSpace == 0 {
      return false
    }

    let freeDiskSpace = UIDevice.freeDiskSpace()

    // Need more than 200MB + (File Size * 2)
    // swiftlint:disable line_length
    // http://stackoverflow.com/questions/9270027/iphone-free-space-left-on-device-reported-incorrectly-200-mb-difference
    // swiftlint:enable line_length

    let requiredSize: CUnsignedLongLong = requiredSpace * 2 + (200 * 1024 * 1024)

    return requiredSize < freeDiskSpace
  }

  fileprivate func sizeInUnitsToBytes(_ size: Int, unit: String) -> CUnsignedLongLong {
    // Catch
    if size == -1 || unit.isEmpty {
      return 0
    }

    switch unit {
    case "GB":
      return UInt64(size * 1024 * 1024 * 1024)
    case "MB":
      return UInt64(size * 1024 * 1024)
    case "KB":
      return UInt64(size * 1024)
    default:
      return UInt64(size)
    }
  }

  // MARK: MZDownloadManagerDelegate

  func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
    // NOTE: File size is not present at this time, we need to check during
    // the first call to update progress

    // Present Banner with Progress of 0
    self.callback?.showProgress(0)
  }

  func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {

  }

  func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
    // Check For System Space Availability

    guard downloadModel.file != nil else {
      DDLogError("Download updated but File is Nil")
      return
    }

    if self.downloadSize > 0 && !hasRequiredSpace(self.sizeInUnitsToBytes(self.downloadSize, unit: "B")) {
      // Present Error
      self.callback?.showDownloadSpaceError()

      // Cancel
      self.downloadManager.cancelTaskAtIndex(index)
      self.cleanup()

      return
    }

    let currentSize = self.sizeInUnitsToBytes(Int(downloadModel.downloadedFile!.size),
                                              unit: downloadModel.downloadedFile!.unit)

    var currentPercentage: Float = Float(currentSize) / Float(self.downloadSize)

    if  currentPercentage > 1.0 {
      currentPercentage = 1.0
    }
    self.callback?.showProgress(currentPercentage)
  }

  func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {

  }

  func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {

  }

  func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
    self.callback?.showProgress(-1)
    self.cleanup()
  }

  func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
    let fileName: NSString = downloadModel.fileName as NSString
    let fileUrl: URL =
      URL(fileURLWithPath: (MZUtility.baseFilePath as NSString).appendingPathComponent(fileName as String))

    // Save Clip
    self.saveClipToCameraRoll(fileUrl)

    self.cleanup()
  }

  func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
    self.callback?.showDownloadError()
    self.cleanup()
  }

  // MARK: Clean up
  fileprivate func cleanup() {
    self.downloadSize = -1
    self.downloadingId = nil
    self.callback?.isDownloading(nil)
    self.callback?.showProgress(-1)
  }
}
