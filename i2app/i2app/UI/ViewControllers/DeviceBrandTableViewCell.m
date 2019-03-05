//
//  DeviceBrandTableViewCell.m
//  i2app
//
//  Created by Arcus Team on 10/29/15.
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
#import "DeviceBrandTableViewCell.h"

@implementation DeviceBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Configure the view for the selected state
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMarked:(BOOL)marked {
    if (marked) {
        [self.disclosureImage setImage:[UIImage imageNamed:@"checkedMark"]];
    }
    else {
        [self.disclosureImage setImage:[UIImage imageNamed:@"Chevron"]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.brandImage.frame = self.brandImage.frame;
    float limgW =  self.imageView.image.size.width;
    if (limgW > 0) {
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);
    }
}

@end
