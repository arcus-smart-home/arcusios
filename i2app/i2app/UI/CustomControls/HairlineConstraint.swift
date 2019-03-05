//
//  HairlineConstraint.swift
//  i2app
//
//  Created by Arcus Team on 1/13/17.
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

/**
 Used to create a One Pixel Divider, often seperating content.
 
 This will change the height of a UIView to be 1 real pixel on all devices
 
 Usage: 
 
 1. Create a UIView in a Storyboard with 1 pixel in height. 
 2. Pin the UIView's as normal. Add Height constraint and set it to 1, a value which will later be overriden
 3. Change the class of the `UILayoutContraint` to `HairlineConstraint`
 
 */
class HairlineConstraint: NSLayoutConstraint {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.constant = 1.0 / UIScreen.main.scale
    }
}
