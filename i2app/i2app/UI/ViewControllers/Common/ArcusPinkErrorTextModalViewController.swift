//
//  ArcusPinkErrorTextModalViewController.swift
//  i2app
//
//  Arcus Team on 2/20/17.
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
import Cornea

class ArcusPinkErrorTextModalViewController: UIViewController {

  fileprivate var errorTitle: String?
  fileprivate var errorDescription: String?

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UITextView!

  class func create(_ title: String, description: String) -> ArcusPinkErrorTextModalViewController {
    if let vc: ArcusPinkErrorTextModalViewController = UIStoryboard(name: "Common", bundle: nil)
      .instantiateViewController(withIdentifier: "ArcusPinkErrorTextModal")
      as? ArcusPinkErrorTextModalViewController {

      vc.errorTitle = title
      vc.errorDescription = description

      return vc
    }
    return ArcusPinkErrorTextModalViewController()
  }

  override func viewDidLoad() {
    self.titleLabel.text = errorTitle?.uppercased()
    self.descriptionLabel.text = errorDescription
  }

  @IBAction func onClose(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
}
