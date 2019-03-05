//
//  CachedImageLoader.swift
//  i2app
//
//  Created by Arcus Team on 11/7/16.
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

import UIKit

protocol CachedImageLoader {
  func imageFromCache(_ hash: String) -> UIImage?
  func downloadImage(_ productId: String,
                     devTypeId: String,
                     placeHolder: String,
                     isLarge: Bool,
                     isBlack: Bool,
                     completionHandler: @escaping ((_ image: UIImage?) -> Void))
}

extension CachedImageLoader {
  func imageFromCache(_ hash: String) -> UIImage? {
    let image: UIImage? = (AKFileManager
      .default() as AnyObject).cachedImage(forHash: hash,
                                                  at: UIScreen.main.bounds.size,
                                                  withScale: UIScreen.main.scale)

    return image
  }

  func downloadImage(_ productId: String,
                     devTypeId: String,
                     placeHolder: String,
                     isLarge: Bool,
                     isBlack: Bool,
                     completionHandler: @escaping ((_ image: UIImage?) -> Void)) {
    _ = ImageDownloader.downloadDeviceImage(productId,
                                            withDevTypeId: devTypeId,
                                            withPlaceHolder: placeHolder,
                                            isLarge: isLarge,
                                            isBlackStyle: isBlack)
      .swiftThen { result in
        if let image = result as? UIImage {
          completionHandler(image)
        }
        return nil
    }
  }
}
