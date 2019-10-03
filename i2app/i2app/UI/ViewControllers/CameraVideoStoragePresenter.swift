//
//  CameraVideoStoragePresenter.swift
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

extension Notification.Name {
  static let videoClipsDeleted = Notification.Name("VideoClipsDeleted")
}

/**
 `CameraVideoStoragePresenter` protocol
 */
protocol CameraVideoStoragePresenter {
  var delegate: CameraVideoStoragePresenterDelegate? { get set }

  /**
   Confirm that user wants to clean up their video storage.
   */
  func confirmClean()

  /**
   Confirm that user wants to delete all from video storage.
   */
  func confirmDelete()

  /**
   Clean up video storage.
   */
  func cleanStorage()

  /**
   Deleta all from video storage.
   */
  func deleteAll()
}

/**
 `CameraVideoStoragePresenterDelegate` protocol
 */
protocol CameraVideoStoragePresenterDelegate: class {
  /**
   Used to display confirm video storage clean up popup.
   */
  func showConfirmCleanPopup()

  /**
   Used to display confirm delete all video storage popup.
   */
  func showConfirmDeletePopup()
}

class CameraStoragePresenter: CameraVideoStoragePresenter {
  weak var delegate: CameraVideoStoragePresenterDelegate?

  required init(delegate: CameraVideoStoragePresenterDelegate?) {
    self.delegate = delegate
  }

  func confirmClean() {
    delegate?.showConfirmCleanPopup()
  }

  func confirmDelete() {
    delegate?.showConfirmDeletePopup()
  }

  func cleanStorage() {
    delete(false)
  }

  func deleteAll() {
    delete(true)
  }

  private func delete(_ deleteAll: Bool) {
    if let placeId = RxCornea.shared.settings?.currentPlace?.modelId {
      _ = VideoService.deleteAll(withPlaceId: placeId, withIncludeFavorites: deleteAll).swiftThen {
        _ in

        NotificationCenter.default.post(name: Notification.Name.videoClipsDeleted, object: nil, userInfo: nil)

        return nil
      }
    }
  }
}
