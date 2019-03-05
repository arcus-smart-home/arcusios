//
//  UIView+FirstResponder.m
//  i2app
//
//  Created by Arcus Team on 8/12/15.
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

#import <i2app-Swift.h>
#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)firstResponder {
    id firstResponder = nil;
    
    if (self.isFirstResponder) {
        firstResponder = self;
    }
    else {
        for (UIView *subView in self.subviews) {
            id responder = [subView firstResponder];
            if (responder) {
                firstResponder = responder;
                break;
            }
        }
    }
    return firstResponder;
}

@end
