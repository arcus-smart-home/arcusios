//
//  PairingCustomizationImagePresenter.swift
//  i2app
//
//  Created by Arcus Team on 5/4/18.
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
import SDWebImage

protocol PairingCustomizationImagePresenter: ArcusDeviceCapability {
  func fetchDeviceProductImage(device: DeviceModel, completion: @escaping (UIImage?) -> Void)
}

extension PairingCustomizationImagePresenter {
  
  func fetchDeviceProductImage(device: DeviceModel, completion: @escaping (UIImage?) -> Void) {
    guard let productId = getDeviceProductId(device),
      let typeHint = getDeviceDevtypehint(device),
      let urlString = ImagePaths.getProductImage(fromProductId: productId, isLarge: false),
      let fallbackURLString = ImagePaths.getSmallProductImage(fromDevTypeHint: typeHint),
      let imageManager = SDWebImageManager.shared() else {
        completion(nil)
        return
    }
    
    let url = URL(string: urlString)
    let fallbackURL = URL(string: fallbackURLString)
    
    if imageManager.cachedImageExists(for: url) {
      let key = imageManager.cacheKey(for: url)
      
      if let image = SDImageCache.shared().imageFromDiskCache(forKey: key) {
        completion(image)
      } else {
        completion(nil)
      }
    } else {
      imageManager.downloadImage(with: url,
                                 options: .retryFailed,
                                 progress: { (_, _) in },
                                 completed: { (image, _, _, _, _) in
                                  if let image = image {
                                    completion(image)
                                  } else {
                                    imageManager.downloadImage(with: fallbackURL,
                                                               options: .retryFailed,
                                                               progress: { (_, _) in },
                                                               completed: { (image, _, _, _, _) in
                                                                if let image = image {
                                                                  completion(image)
                                                                } else {
                                                                  completion(nil)
                                                                }
                                                                
                                    })
                                  }
                                  
      })
    }
  }
  
}
