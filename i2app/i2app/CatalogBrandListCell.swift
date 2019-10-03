//
//  CatalogBrandListCell.swift
//  i2app
//
//  Created by Arcus Team on 1/30/18.
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

/**
 This cell is used to display a brand image with it's corresponding device count.
 */
class CatalogBrandListCell: UITableViewCell {
  
  /**
   Image for the brand.
   */
  @IBOutlet weak var brandImage: UIImageView!

  /**
   Device's vendor.
   */
  @IBOutlet weak var brandName: UILabel!

  /**
   Count of devices available in the brand.
   */
  @IBOutlet weak var deviceCount: UILabel!
}
