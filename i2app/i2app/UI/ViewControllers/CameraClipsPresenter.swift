//
//  CameraClipsPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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
import UIKit
import PromiseKit
import RxSwift

protocol CameraClipsPresenterProtocol: class {
  weak var delegate: CameraClipsPresenterDelegate? { get set }

  var sections: [ClipsSection] { get set }
  var hasSetup: Bool { get }
  var isFinished: Bool { get }
  var filter: ClipFilter { get set }
  var favoriteQuotaLimit: Int { get }
  var favoriteQuotaUsed: Int { get }
  
  /// Check for an active Download to present
  func fetchDownloadData()

  /// Fetch the inital page
  func fetchTopData()

  /// fetch the next page (or inital page)
  /// is called when you change the det of filters
  func fetchNextData()

  /// nil if not yet fetched
  var quotaUsageString: String? { get }
  func fetchQuota(completion: @escaping () -> Void)
  
  func updated(section: ClipsSection, clipIndex: Int)

  func playPressed(atIndexpath: IndexPath)

  func deletePressed(atIndexpath: IndexPath)

  func downloadPressed(atIndexpath: IndexPath)

  func cancelDownloadPressed()

  func pinPressed(atIndexpath: IndexPath)
  
  func fetchPremiumStatus() -> Observable<Bool>
}

extension CameraClipsPresenterProtocol {
  func fetchPremiumStatus() -> Observable<Bool> {
    return Observable.create { observer in
      if let settings = RxCornea.shared.settings {
        if settings.isPremiumAccount() {
          observer.onNext(true)
        } else {
          observer.onNext(false)
        }
      }
      return Disposables.create { }
    }
  }
  
  // Returns the name of the device based on the id from the model cache
  func getDeviceName(for id: String?) -> String? {
    if let id = id, let model = RxCornea.shared.modelCache?.fetchModel(DeviceModel.addressForId(id)) as? DeviceModel {
      return model.name
    }
    return nil
  }
}

protocol CameraClipsPresenterDelegate: class, SimpleTableViewGenericPresenterDelegate,
CameraPlaybackViewController {
 var presenter: CameraClipsPresenterProtocol? { get }
  func showProgress(_ progress: Float)
  func shouldDisplayGenericErrorMessage()
  func shouldPopupMessage(_ title: String, subtitle: String)
  func shouldPopupErrorWindow(_ title: String, subtitle: String)
}

class CameraClipsPresenter: CameraClipsPresenterProtocol, BatchNotificationObserver {
  var favoriteQuotaUsed: Int = 0
  var favoriteQuotaLimit: Int = 0
  weak var delegate: CameraClipsPresenterDelegate?
  var sections: [ClipsSection]
  var hasSetup = false
  var isFinished: Bool
  private var isFetching = false
  let downloadPresenter = CameraClipsDownloadPresenter.sharedInstance
  var cameraPlaybackPresenter: CameraPlaybackPresenter?

  var filter: ClipFilter {
    didSet {
      pagingToken = nil
      sections = []
      isFinished = false
      hasSetup = false
      delegate?.updateLayout()
      fetchNextData()
    }
  }
  
  static var timeFilter: ClipTimeFilter {
    get {
      if let settings = RxCornea.shared.settings, settings.isPremiumAccount() {
        return ClipTimeFilter.defaultFilter
      } else {
        return ClipTimeFilter.last24Hours
      }
    }
  }

  var placeId: String

  required init(delegate: CameraClipsPresenterDelegate?,
                placeId: String) {
    self.delegate = delegate
    self.placeId = placeId
    sections = []
    isFinished = false
    filter = ClipFilter(cameraFilter: ClipCameraFilter.defaultFilter,
                        timeFilter: CameraClipsPresenter.timeFilter,
      pinnedOnly: false)
    downloadPresenter.setup(self, userDefaults: UserDefaults.standard)
    cameraPlaybackPresenter = CameraPlaybackPresenter(delegate: self)
    observeBatchNotifications([Notification.Name.modelDeleted, Notification.Name.videoClipsDeleted],
                              selector: #selector(CameraClipsPresenter.deletedClips(_:)))
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  //Config vars for Pagination
  fileprivate let limit: Int = 15
  var pagingToken: String?

  
  /// Call Function From Main Thread Only
  func fetchDownloadData() {
    if downloadPresenter.downloadingId == nil {
      return
    } else {
      delegate?.showProgress(0.0)
    }
  }

  /// Call Function From Main Thread Only
  func fetchTopData() {
    guard !isFetching else {
      return
    }

    var highWaterMark: Double {
      guard let first = sections[safe: 0]?.items[safe:0] else {
        return self.filter.earliest
      }

      if let recordingTime = first.recordingModel.recordingTime() as Date? {
        return recordingTime.millisecondsSince1970
      }
      return 0
    }

    DispatchQueue.global(qos: .background).async {
      self.isFetching = true
      _ = VideoService.pageRecordings(withPlaceId: self.placeId,
                                      withLimit: Int32(self.limit),
                                      withToken: "",
                                      withAll:false,
                                      withInprogress: false,
                                      withType: kEnumRecordingTypeRECORDING,
                                      withLatest: self.filter.latest,
                                      withEarliest: highWaterMark,
                                      withCameras:self.filter.cameras,
                                      withTags:self.filter.tags)
        .swiftThenInBackground(self.processPrependResults)
        .swiftThen({ _ in
          self.delegate?.updateLayout()
          self.isFetching = false
          return nil
        })
        .swiftCatch({ _ in
          self.isFetching = false
          return nil
        })
    }
  }

  /// Call Function From Main Thread Only
  func fetchNextData() {
    guard !self.isFinished, !isFetching else {
      return
    }
    DispatchQueue.global(qos: .background).async {
      self.isFetching = true
      var token = ""
      if self.pagingToken != nil {
        token = self.pagingToken!
      }
      let nextPagingToken = token
      _ = VideoService.pageRecordings(withPlaceId: self.placeId,
                                      withLimit: Int32(self.limit),
                                      withToken: nextPagingToken,
                                      withAll:false,
                                      withInprogress: false,
                                      withType: kEnumRecordingTypeRECORDING,
                                      withLatest: self.filter.latest,
                                      withEarliest: self.filter.earliest,
                                      withCameras:self.filter.cameras,
                                      withTags:self.filter.tags)
        .swiftThenInBackground(self.processPageResults)
        .swiftThen({ _ in
          self.delegate?.updateLayout()
          self.isFetching = false
          return nil
        })
        .swiftCatch({ _ in
          self.isFetching = false
          return nil
        })
    }
  }

  func processPrependResults(_ res: Any?) -> PMKPromise? {
    guard let response = res as? VideoServicePageRecordingsResponse,
      let results = response.getRecordings() as? [[String : AnyObject]]
      else {
        isFinished = true
        return nil
    }
    // Turn into Recording Models
    _ = results.map { result in
      return RecordingModel(attributes: result)
      }
      //Filter out anything we already have in the data
      .filter { record -> Bool in
        if let section = self.section(forRecordingModel: record) {
          let companion = section.items.filter({ clip -> Bool in
            return clip.recordingModel.address as String == record.address as String
          })
          if companion.count > 0 {
            return false
          }
        }
        return true
      }
      // add the things we don't have to thier perspective sections
      .forEach { record in
        let section = self.section(forRecordingModel: record)
        if let section = section {
          // we have a section for the date of this record so add the record to the section
          section.addRecord(record)
        } else {
          guard let recordingTimeDate = record.recordingTime(),
            let recordingTime = record.recordingTime() as Date? else { return }

          // no section for this date yet, make a section and add the record
          let toMidNight = recordingTime.startOfDay()
          var sectionTitle = ""
          if let title = recordingTimeDate.formatDateByDay() {
            sectionTitle = title
          }
          let section = ClipsSection(withTitle: sectionTitle, date: toMidNight, owner: self)
          section.addRecord(record)
          self.sections.append(section)
        }
    }
    return nil
  }

  /// Public For testing
  func processPageResults(_ res: Any?) -> PMKPromise? {
    guard let response = res as? VideoServicePageRecordingsResponse,
    let results = response.getRecordings() as? [[String: AnyObject]]
      else {
        pagingToken = nil
        isFinished = true
        return nil
    }
    if let nextToken = response.getNextToken() {
      pagingToken = nextToken
    } else {
      pagingToken = nil
      isFinished = true
    }
    hasSetup = true
    if results.count < self.limit {
      isFinished = true
    }
    return processResults(results)
  }

  /// Public For testing
  func processResults(_ results: [[String : AnyObject]]) -> PMKPromise? {
    _ = results.map { result in
      return RecordingModel(attributes: result)
      }
      //Filter out anything we already have in the data
      .filter { record -> Bool in
        if let section = self.section(forRecordingModel: record) {
          let companion = section.items.filter({ clip -> Bool in
            return clip.recordingModel.address as String == record.address as String
          })
          if companion.count > 0 {
            return false
          }
        }
        return true
      }
      .forEach { record in
        let section = self.section(forRecordingModel: record)
        if let section = section {
          // we have a section for the date of this record so add the record to the section
          section.addRecord(record)
        } else {
          guard let recordingTimeDate = record.recordingTime(),
            let recordingTime = record.recordingTime() as Date? else { return }

          // no section for this date yet, make a section and add the record
          let toMidNight = recordingTime.startOfDay()
          var sectionTitle = ""
          if let title = recordingTimeDate.formatDateByDay() {
            sectionTitle = title
          }
          let section = ClipsSection(withTitle: sectionTitle, date: toMidNight, owner: self)
          section.addRecord(record)
          self.sections.append(section)
        }
    }
    return nil
  }

  func section(forRecordingModel record: RecordingModel) -> ClipsSection? {
    return sections.filter({
      guard let recordingTime = record.recordingTime() as Date? else {
        return false
      }
      return $0.date.isSameDay(asDate: recordingTime)
    }).first
  }

  /// Public For testing
  func update(clip: ClipItem) {
    if let section = section(forRecordingModel: clip.recordingModel),
      let sectionIdx = sections.index(of: section) {
      for rowIdx in 0...section.items.count {
        let aclip = section.items[rowIdx]
        if clip == aclip {
          let indexPath = IndexPath(indexes: [sectionIdx, rowIdx])
          delegate?.updateAtIndexPath(indexPath)
          break
        }
      }
    }
  }

  private func togglePinned(clip: ClipItem) {
    DispatchQueue.global(qos: .background).async {
      if clip.isPinned {
        FavoriteController.removeFavoriteTag(clip.recordingModel)
      } else {
        FavoriteController.addFavoriteTag(clip.recordingModel)
      }
      clip.isPinned = !clip.isPinned
      self.update(clip: clip)
    }
  }

  private func playClip(_ clip: ClipItem, at atIndexpath: IndexPath) {
    guard let playback = cameraPlaybackPresenter,
      playback.fetchActive != true else {
        return
    }
    delegate?.displayLoadingIndicator()
    playback.playRecordingModel(clip.recordingModel)
  }

  private func deleteClip(_ clip: ClipItem, at indexpath: IndexPath) {
    DispatchQueue.global(qos: .background).async {
      _ = RecordingCapability.delete(on: clip.recordingModel)
        .swiftThen({ _ in
          if let section = self.sections[safe: indexpath.section],
          section.items.count > indexpath.row {
            section.items.remove(at: indexpath.row)
            if section.items.count == 0 {
              self.sections.remove(at: indexpath.section)
            }
            self.delegate?.updateLayout()
          }
          return nil
        })
    }
  }

  private func resetData() {
    sections.removeAll()
    isFinished = false
  }

  var quotaUsageString: String?
  
  func fetchQuota(completion: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async {
      _ = VideoService.getFavoriteQuota(withPlaceId: self.placeId).swiftThen {
          response in
        if let favoriteQuotaResponse = response as? VideoServiceGetFavoriteQuotaResponse {
          if let total = favoriteQuotaResponse.getTotal(),
            let used = favoriteQuotaResponse.getUsed() {
            self.favoriteQuotaUsed = used
            self.favoriteQuotaLimit = total
            completion()
          }
        }
        
        return nil
      }
    }
  }

  func updated(section: ClipsSection, clipIndex: Int) {
    if let idx = sections.index(of: section) {
      let indexPath = IndexPath(indexes: [idx, clipIndex])
      delegate?.updateAtIndexPath(indexPath)
    }
  }

  func playPressed(atIndexpath: IndexPath) {
    guard let section = sections[safe: atIndexpath.section],
      let clip = section.items[safe: atIndexpath.row] else {
        return
    }
    playClip(clip, at: atIndexpath)
  }

  func deletePressed(atIndexpath: IndexPath) {
    guard let section = sections[safe: atIndexpath.section],
      let clip = section.items[safe: atIndexpath.row] else {
        return
    }
    deleteClip(clip, at: atIndexpath)
  }

  func downloadPressed(atIndexpath: IndexPath) {
    guard let section = sections[safe: atIndexpath.section],
      let clip = section.items[safe: atIndexpath.row] else {
        return
    }
    downloadPresenter.downloadClip(clip)
  }

  func cancelDownloadPressed() {
    downloadPresenter.cancelDownload()
  }

  func pinPressed(atIndexpath: IndexPath) {
    //Toggle pin
    guard let section = sections[safe: atIndexpath.section],
      let clip = section.items[safe: atIndexpath.row] else {
        return
    }
    togglePinned(clip: clip)
  }

  @objc private func deletedClips(_ note: Notification) {
    pagingToken = nil
    sections = []
    isFinished = false
    delegate?.updateLayout()
    fetchNextData()
  }
}

extension CameraClipsPresenter: CameraClipsDownloadCallback {

  // currentId is nil if no devices found to be currently downloading
  func isDownloading(_ currentId: String?) {

  }

  // showProgress -1 for finished
  func showProgress(_ progress: Float) {
    delegate?.showProgress(progress)
  }

  func showPermissionsError() {
    self.delegate?.shouldPopupErrorWindow(NSLocalizedString("CANNOT ACCESS STORAGE", comment:""),
                                   subtitle:NSLocalizedString("Go to your iOS Settings to allow \"Arcus\" access to your storage.", comment:""))
  }

  func showDownloadError() {
    self.delegate?.shouldDisplayGenericErrorMessage()
  }

  func showDownloadSpaceError() {
    self.delegate?.shouldPopupErrorWindow(NSLocalizedString("UNABLE TO DOWNLOAD", comment:""),
                                   subtitle:NSLocalizedString("You do not have enough storage space on this device to download this clip.", comment:""))
  }

  func showDownloadInProgressError() {
    self.delegate?.shouldPopupMessage(NSLocalizedString("DOWNLOAD IN PROGRESS", comment:""),
                                   subtitle:NSLocalizedString("Please allow current download to complete.", comment:""))
  }

  func showDownloadStarted() {
    self.delegate?.shouldPopupMessage(NSLocalizedString("DOWNLOAD STARTED", comment:""),
                                   subtitle:NSLocalizedString("Your clips will continue to download, even if you close the Arcus app, and will appear in your Camera Roll.", comment:""))
  }
}

extension CameraClipsPresenter : CameraPlaybackDelegate {

  func cameraPlayback(presenter: CameraPlaybackPresenter, didReceiveStreamUrl streamUrl: URL) {
    delegate?.hideLoadingIndicator()
    delegate?.shouldDisplayVideo(withURL: streamUrl)
  }

  func cameraPlayback(presenter: CameraPlaybackPresenter, didFailWithError error: Error) {
    delegate?.hideLoadingIndicator()
    delegate?.shouldDisplayVideoError(err: error)
  }
}
