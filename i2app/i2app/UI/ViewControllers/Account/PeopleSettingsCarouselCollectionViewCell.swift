//
//  PeopleSettingsCarouselCollectionViewCell.swift
//  i2app
//
//  Created by Arcus Team on 5/11/16.
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

protocol PeopleSettingsCarouselViewCellDelegate: class {
    func changeImageButtonPressed(_ button: UIButton, cell: PeopleSettingsCarouselViewCell)
}

class PeopleSettingsCarouselViewCell: ArcusCarouselViewCell {
    @IBOutlet var personImageView: ArcusBorderedImageView!
    @IBOutlet var changeImageButton: UIButton!
    @IBOutlet var cameraIcon: UIImageView!
    @IBOutlet var nameLabel: ArcusLabel!
    @IBOutlet var descriptionLabel: ArcusLabel!

    weak var delegate: PeopleSettingsCarouselViewCellDelegate?

    // MARK: IBActions
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        if delegate != nil {
            self.delegate?.changeImageButtonPressed(sender, cell: self)
        }
    }
}
