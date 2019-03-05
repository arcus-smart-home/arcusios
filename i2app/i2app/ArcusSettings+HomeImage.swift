//
//  ArcusSettings+HomeImage.swift
//  i2app
//
//  Created by Arcus Team on 3/16/18.
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

// MARK: Home Image
extension ArcusSettings {
  public func fetchHomeImage(_ placeId: String) -> UIImage? {
    guard let homeImage: UIImage = AKFileManager.default()
      .cachedImage(forHash: placeId,
                   at: UIScreen.main.bounds.size,
                   withScale: UIScreen.main.scale) else {
                    // TODO: REFACTOR INTO CLEANER IMPLEMENTATION.
                    var assignedImageIndex = getAssignedImageIndex(placeId, personId: "")
                    if assignedImageIndex == Constants.kBackgroundIndexNotAssigned {
                      var indexToAssign = getPlaceImageIndex("")
                      if indexToAssign == 0 {
                        indexToAssign = Constants.kNumberOfOldBackgroundImages
                      }
                      setAssignedImageIndex(indexToAssign, placeId: placeId, personId: "")

                      var nextIndex = indexToAssign + 1
                      if nextIndex >= Constants.kNumberOfBackgroundImages {
                        nextIndex = Constants.kNumberOfOldBackgroundImages
                      }
                      setNextPlaceImageIndex(nextIndex, personId: "")

                      assignedImageIndex = indexToAssign
                    }
                    return UIImage(named: "DashboardBackgroundImage\(assignedImageIndex)")
    }
    return homeImage
  }

  public func saveHomeImage(_ image: UIImage, placeId: String) {
    AKFileManager.default().cacheImage(image, forHash: placeId)
  }

  private func getAssignedImageIndex(_ placeId: String, personId: String) -> Int {
    let index: Int = UserDefaults.standard.integer(forKey: assignedImageIndexKey(placeId, personId: personId))
    if index <= 0 {
      return Constants.kBackgroundIndexNotAssigned
    }
    return index - 1
  }

  private func setAssignedImageIndex(_ index: Int, placeId: String, personId: String) {
    let defaults: UserDefaults = UserDefaults.standard
    let modifiedIndex: Int = index + 1
    let key: String = assignedImageIndexKey(placeId, personId: personId)
    defaults.set(modifiedIndex, forKey: key)
    defaults.synchronize()
  }

  private func assignedImageIndexKey(_ placeId: String, personId: String) -> String {
    return Constants.kAssignedDefaultPlaceImageIndexKeyPrefix + placeId
  }

  private func getPlaceImageIndex(_ personId: String) -> Int {
    let index: Int = UserDefaults.standard.integer(forKey: placeImageIndexKey(personId))
    if index <= Constants.kNumberOfOldBackgroundImages {
      return Constants.kNumberOfOldBackgroundImages
    }
    return index
  }

  private func setNextPlaceImageIndex(_ index: Int, personId: String) {
    let defaults: UserDefaults = UserDefaults.standard
    let key: String = placeImageIndexKey(personId)
    defaults.set(index, forKey: key)
    defaults.synchronize()
  }

  private func placeImageIndexKey(_ personId: String) -> String {
    // Append the person id if it's decided that images should cycle based on person
    // and device instead of just device - will have to migrate images then
    return Constants.kCurrentPlaceImageIndexKeyPrefix
  }
}

@objc public class ArcusSettingsHomeImageHelper: NSObject {
  public static func fetchHomeImage(_ placeId: String) -> UIImage? {
    return RxCornea.shared.settings?.fetchHomeImage(placeId)
  }

  public static func saveHomeImage(_ image: UIImage, placeId: String) {
    RxCornea.shared.settings?.saveHomeImage(image, placeId: placeId)
  }
}
