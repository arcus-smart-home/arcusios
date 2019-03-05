//
//  ImagePickerViewable.swift
//  i2app
//
//  Created by Arcus Team on 3/2/18.
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
import UIKit

protocol ImagePickerViewable: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  /**
   Image Picker Controller used to select an image from the Library or Camera.
   */
  var imagePicker: UIImagePickerController { get }
  
  // MARK: Extended
  
  /**
   Presents an alert controller with options to display an image picker. The user can pick a source for
   the photo (Camera or Photo Library) or Cancel the action which dismisses the alert controller.
   */
  func presentAlertControllerForImagePicker()
  
}

extension ImagePickerViewable where Self: UIViewController {
  
  func presentAlertControllerForImagePicker() {
    imagePicker.delegate = self
    let alertController = UIAlertController(title: "",
                                            message: "Select the image source:",
                                            preferredStyle: .actionSheet)
    let cameraAction = UIAlertAction(title: "Camera",
                                     style: .default) { (_) in
                                      self.presentImagePicker(withSourceType: .camera)
    }
    let photoLibraryAction = UIAlertAction(title: "Photo Library",
                                           style: .default) { (_) in
                                            self.presentImagePicker(withSourceType: .photoLibrary)
    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .cancel) { (_) in
                                      alertController.dismiss(animated: true, completion: nil)
    }
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alertController.addAction(cameraAction)
    }
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      alertController.addAction(photoLibraryAction)
    }
    alertController.addAction(cancelAction)
    
    alertController.popoverPresentationController?.sourceView = self.view
    alertController.popoverPresentationController?.sourceRect =
      CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
    alertController.popoverPresentationController?.permittedArrowDirections = []
    
    present(alertController, animated: true, completion: nil)
  }

  func getPickedMedia(withInfo info: [String : Any]) -> UIImage?{
    var newImage: UIImage?
    if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      newImage = editedImage
    }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      newImage = originalImage
    }
    return newImage
  }
  
  private func presentImagePicker(withSourceType sourceType: UIImagePickerControllerSourceType) {
    imagePicker.allowsEditing = true
    imagePicker.sourceType = sourceType
    
    present(imagePicker, animated: true, completion: nil)
  }
  
}
