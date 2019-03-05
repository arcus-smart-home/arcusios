//
//  DeviceImagerLoader.swift
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
import Cornea

protocol DeviceImageLoader: CachedImageLoader {
    func imageForDeviceModel(_ model: DeviceModel,
                             completionHandler: @escaping ((_ image: UIImage?, _ fromCache: Bool) -> Void))
    func imageForDeviceModel(_ model: DeviceModel,
                             large: Bool,
                             black: Bool,
                             completionHandler: @escaping ((_ image: UIImage?, _ fromCache: Bool) -> Void))
}

extension DeviceImageLoader {
    func imageForDeviceModel(_ model: DeviceModel,
                             completionHandler: @escaping ((_ image: UIImage?, _ fromCache: Bool) -> Void)) {
        imageForDeviceModel(model,
                            large: false,
                            black: true,
                            completionHandler: {
                                (image: UIImage?, fromCache: Bool) in
                                completionHandler(image, fromCache)
        })
    }

    func imageForDeviceModel(_ model: DeviceModel,
                             large: Bool,
                             black: Bool,
                             completionHandler: @escaping ((_ image: UIImage?, _ fromCache: Bool) -> Void)) {
        var deviceImage: UIImage? = imageFromCache(model.modelId as String)
        var fromCache: Bool = false
        if deviceImage != nil {
            completionHandler(deviceImage, fromCache)
        } else {
            if let productId: String? = DeviceCapability.getProductId(from: model) {
                if productId != nil {
                    if let _: String? = ImagePaths.getLargeProductImage(fromProductId: productId) {
                        downloadImage(productId!,
                                      devTypeId: model.devTypeHintToImageName(),
                                      placeHolder: "",
                                      isLarge: large,
                                      isBlack: black,
                                      completionHandler: { (image) in
                                        fromCache = true
                                        deviceImage = image
                                        completionHandler(deviceImage, fromCache)
                        })
                    }
                }
            }
        }
    }

    func imageForDeviceModel(_ model: DeviceModel) -> (image: UIImage?, fromCache: Bool) {
        return imageForDeviceModel(model, large: false,
                                   black: true)
    }

    func imageForDeviceModel(_ model: DeviceModel,
                             large: Bool,
                             black: Bool) -> (image: UIImage?, fromCache: Bool) {
        var deviceImage: UIImage? = imageFromCache(model.modelId as String)
        var fromCache: Bool = false
        if deviceImage == nil {
            if let productId: String? = DeviceCapability.getProductId(from: model) {
                if productId != nil {
                    if let _: String? = ImagePaths.getLargeProductImage(fromProductId: productId) {
                        downloadImage(productId!,
                                      devTypeId: model.devTypeHintToImageName(),
                                      placeHolder: "",
                                      isLarge: large,
                                      isBlack: black,
                                      completionHandler: { (image) in
                                        fromCache = true
                                        deviceImage = image
                        })
                    }
                }
            }
        }

        return (deviceImage, fromCache)
    }
}
