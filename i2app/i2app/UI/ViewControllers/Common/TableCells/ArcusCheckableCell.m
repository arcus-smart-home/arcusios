//
//  ArcusCheckableCell.m
//  i2app
//
//  Created by Arcus Team on 2/19/16.
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
#import "ArcusCheckableCell.h"

@implementation ArcusCheckableCell

#pragma mark - Setters
- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    [self updateCheckmark:isChecked];
}

#pragma mark - Helpers
- (void)updateCheckmark:(BOOL)isChecked {
    UIImage *checkViewImage;
    if (isChecked) {
        checkViewImage = self.checkedImage ? self.checkedImage : [UIImage imageNamed:@"CheckmarkDetail"];
    } else {
        checkViewImage = self.uncheckedImage ? self.uncheckedImage : [UIImage imageNamed:@"UncheckmarkDetail"];
    }
    
    self.checkMarkImageView.image = checkViewImage;
}

@end
