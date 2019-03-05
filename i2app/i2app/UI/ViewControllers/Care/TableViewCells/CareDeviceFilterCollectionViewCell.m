//
//  CareDeviceFilterCollectionViewCell.m
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "CareDeviceFilterCollectionViewCell.h"
#import "ArcusLabel.h"

@implementation CareDeviceFilterCollectionViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.deviceImage.alpha = 1.0f;
        self.descriptionLabel.textColor = [self.descriptionLabel.textColor colorWithAlphaComponent:1.0f];
    } else {
        self.deviceImage.alpha = 0.4f;
        self.descriptionLabel.textColor = [self.descriptionLabel.textColor colorWithAlphaComponent:0.4f];
    }
}

@end
