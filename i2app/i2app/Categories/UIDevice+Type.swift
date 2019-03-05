//
//  UIDevice+Type.swift
//  i2app
//
//  Created by Arcus Team on 5/17/16.
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

extension UIDevice {

    class func isIPad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == .pad
    }

    class func isIPhone() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == .phone
    }

    class func isRetina() -> Bool {
        return UIScreen.main.scale >= 2.0
    }

    class func screenWidth() -> Float {
        return Float(UIScreen.main.bounds.size.width)
    }

    class func screenHeight() -> Float {
        return Float(UIScreen.main.bounds.size.height)
    }

    class func screenMaxLength() -> Float {
        return max(screenWidth(), screenHeight())
    }

    class func screenMinLength() -> Float {
        return min(screenWidth(), screenHeight())
    }

    class func isIPhone5() -> Bool {
        return isIPhone() && screenMaxLength() == 568.0
    }

    class func isIPhone6() -> Bool {
        return isIPhone() && screenMaxLength() == 667.0
    }

    class func isIPhone6P() -> Bool {
        return isIPhone() && screenMaxLength() == 736.0
    }
}
