//
//  NameDevicePresenter.swift
//  i2app
//
//  Created by Arcus Team on 2/20/18.
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
import RxSwift
import SDWebImage

struct NameDeviceViewModel {
  var deviceName = ""
  var deviceImage: UIImage?
  var deviceImagePlaceholder: UIImage?
}

protocol NameDevicePresenter: ArcusDeviceCapability {
  
  /**
   The address of the devices to fetch and update.
   */
  var deviceAddress: String { get }

  /**
   The scale of the image to be used for the device
   */
  var deviceImageSize: CGSize { get }
  
  /**
   The scale of the image to be used for the device
   */
  var deviceImageScale: CGFloat { get }
  
  /**
   The data used to populate the views
   */
  var nameDeviceViewModel: NameDeviceViewModel { get set }
  
  /**
   Called when the data for the view has been updated
   */
  func nameDeviceDataUpdated()

  // MARK: Extended

  /**
   Fetches the data for the view
   */
  func nameDevicePresenterFetchData()
  
  /**
   Saves the data from the view model
   */
  func nameDevicePresenterSaveData()
}

extension NameDevicePresenter {
  
  func nameDevicePresenterFetchData() {
    guard let device = deviceModel() else {
      return
    }
    
    var viewModel = NameDeviceViewModel()
    
    if let image = AKFileManager.default().cachedImage(forHash: device.modelId,
                                                       at: deviceImageSize,
                                                       withScale: deviceImageScale) {
      self.nameDeviceViewModel.deviceImage = image
      self.nameDeviceDataUpdated()
    }
    fetchDeviceProductImage { [weak self] image in
      if let image = image {
        self?.nameDeviceViewModel.deviceImagePlaceholder = image
        self?.nameDeviceDataUpdated()
      } else {
        self?.fetchDeviceTypeHintImage(completion: { [weak self] image in
          if let image = image {
            self?.nameDeviceViewModel.deviceImagePlaceholder = image
            self?.nameDeviceDataUpdated()
          }
        })
      }
    }
    
    if let name = getDeviceName(device) {
      viewModel.deviceName = name
    }
    
    nameDeviceViewModel = viewModel
    nameDeviceDataUpdated()
  }
  
  func nameDevicePresenterSaveData() {
    nameDevicePresenterSaveDeviceName()
    nameDevicePresenterSaveImage()
  }
  
  private func shouldInvertColor() -> Bool {
    guard let device = deviceModel() else {
      return true
    }
    
    // Filtered devices that already have a black image and therefore do not need to have the image
    // color inverted.
    if device.deviceTypeName?.uppercased() == "NESTTHERMOSTAT" ||
      device.deviceTypeName?.uppercased() == "TCCTHERMOSTAT" {
      return false
    }
    
    return true
  }
  
  private func fetchDeviceTypeHintImage(completion: @escaping (UIImage?) -> Void) {
    guard let device = deviceModel(),
      let deviceTypeHint = getDeviceDevtypehint(device),
      let urlString = ImagePaths.getProductImage(fromDevTypeHint: deviceTypeHint,
                                                 isLarge: true),
      let imageManager = SDWebImageManager.shared() else {
        completion(nil)
        return
    }
    
    let url = URL(string: urlString)
    
    if imageManager.cachedImageExists(for: url) && false {
      let key = imageManager.cacheKey(for: url)
      
      if let image = SDImageCache.shared().imageFromDiskCache(forKey: key) {
        completion(shouldInvertColor() ? image.invertColor() : image)
      } else {
        completion(nil)
      }
    } else {
      imageManager.downloadImage(with: url,
                                 options: .retryFailed,
                                 progress: { (_, _) in },
                                 completed: { [weak self] (image, _, _, _, _) in
                                  if let image = image,
                                    let strongSelf = self {
                                    completion(strongSelf.shouldInvertColor() ? image.invertColor() : image)
                                  } else {
                                    completion(nil)
                                  }
                                  
      })
    }
  }
  
  private func fetchDeviceProductImage(completion: @escaping (UIImage?) -> Void) {
    guard let device = deviceModel(),
      let productId = getDeviceProductId(device),
      let urlString = ImagePaths.getProductImage(fromProductId: productId, isLarge: true),
      let imageManager = SDWebImageManager.shared() else {
        completion(nil)
        return
    }
    
    let url = URL(string: urlString)
    
    if imageManager.cachedImageExists(for: url) {
      let key = imageManager.cacheKey(for: url)
      
      if let image = SDImageCache.shared().imageFromDiskCache(forKey: key).invertColor() {
        completion(image)
      } else {
        completion(nil)
      }
    } else {
      imageManager.downloadImage(with: url,
                                 options: .retryFailed,
                                 progress: { (_, _) in },
                                 completed: { (image, _, _, _, _) in
                                  if let image = image?.invertColor() {
                                    completion(image)
                                  } else {
                                    completion(nil)
                                  }
                                  
      })
    }
  }
  
  private func nameDevicePresenterSaveDeviceName() {
    guard let model = deviceModel() else {
      return
    }
    
    setDeviceName(nameDeviceViewModel.deviceName, model: model)
    model.commitChanges().subscribe().disposed(by: disposeBag)
  }
  
  private func nameDevicePresenterSaveImage() {
    guard let model = deviceModel(),
      let image = nameDeviceViewModel.deviceImage else {
        return
    }
    
    AKFileManager.default().cacheImage(image, forHash: model.modelId)
  }
  
  private func deviceModel() -> DeviceModel? {
    return RxCornea.shared.modelCache?.fetchModel(deviceAddress) as? DeviceModel ?? nil
  }
  
}
