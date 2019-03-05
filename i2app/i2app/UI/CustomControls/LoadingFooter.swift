//
//  LoadingFooter.swift
//  i2app
//
//  Created by Arcus Team on 2/17/17.
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

class LoadingFooter: UIView {
  static var height: Int = 60
  var activityIndicator: UIActivityIndicatorView!
  var spinning: Bool  = true {
    didSet {
      if spinning && !activityIndicator.isAnimating {
          activityIndicator.startAnimating()
      }
      if !spinning && activityIndicator.isAnimating {
        activityIndicator.stopAnimating()
      }
    }
  }

  // MARK: Initialization

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    configure()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configure()
  }

  func configure() {
    activityIndicator = UIActivityIndicatorView()
    self.addSubview(activityIndicator)
    //TODO: add constraints
  }

}
