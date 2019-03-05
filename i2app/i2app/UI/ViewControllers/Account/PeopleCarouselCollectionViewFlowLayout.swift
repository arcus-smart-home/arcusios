//
//  PeopleCarouselCollectionViewFlowLayout.swift
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

@IBDesignable class PeopleCarouselCollectionViewFlowLayout: ArcusCarouselViewFlowLayout {

    override func prepare() {
        super.prepare()

        let visibleCells: [PeopleSettingsCarouselViewCell]? =
            self.collectionView!.visibleCells as? [PeopleSettingsCarouselViewCell]
        let visibleWidth: CGFloat = self.collectionView!.bounds.size.width
        for cell in visibleCells! {
            let cellX: CGFloat = self.collectionView!.superview!.convert(cell.center,
                                                                              from: self.collectionView).x
            let scaling: CGFloat = self.calculateScalingWithWidth(visibleWidth,
                                                                  andPosition: cellX)

            if scaling == self.minScale {
                cell.nameLabel.isHidden = true
                cell.descriptionLabel.isHidden = true
                cell.cameraIcon.isHidden = true
            } else {
                cell.nameLabel.isHidden = false
                cell.descriptionLabel.isHidden = false

                if cell.tag != PlaceAccessType.pending.rawValue {
                    cell.cameraIcon.isHidden = false
                }
            }
        }
    }
}
