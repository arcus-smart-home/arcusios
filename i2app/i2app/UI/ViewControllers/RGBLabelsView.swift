//
//  RGBLabelsView.swift
//  i2app
//
//  Created by Arcus Team on 6/27/16.
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

@objc class RGBLabelsView: UIView {
    @IBOutlet var titleLabel: ArcusLabel!
    @IBOutlet var redTitleLabel: ArcusLabel!
    @IBOutlet var redValueLabel: ArcusLabel!
    @IBOutlet var greenTitleLabel: ArcusLabel!
    @IBOutlet var greenValueLabel: ArcusLabel!
    @IBOutlet var blueTitleLabel: ArcusLabel!
    @IBOutlet var blueValueLabel: ArcusLabel!
    @IBOutlet var divider: UIView!

    func updateRGBLabels(_ red: Int, green: Int, blue: Int) {
        self.redValueLabel.text = String(red)
        self.greenValueLabel.text = String(green)
        self.blueValueLabel.text = String(blue)
    }
}
