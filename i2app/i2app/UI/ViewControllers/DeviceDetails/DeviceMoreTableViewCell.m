//
//  DeviceMoreTableViewCell.m
//  i2app
//
//  Created by Arcus Team on 11/20/15.
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
#import "DeviceMoreTableViewCell.h"

@implementation DeviceMoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    
    // Initialization code
    self.attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                        NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:11.0],
                        NSKernAttributeName: @(2.0f)};
    self.primaryButton.hidden = true;
    self.mainTextLabel.numberOfLines = 0;
    self.secondaryTextLabel.numberOfLines = 0;
    self.settingsLabel.numberOfLines = 0;
    self.settingsLabel.center = self.disclosureImage.center;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setData:(NSString *)mainText secondText:(NSString *)secondtext iconType:(NSInteger)icon {
    [self.mainTextLabel styleSet:mainText andButtonType:FontDataType_DemiBold_13_White upperCase:YES];
    [self.secondaryTextLabel styleSet:secondtext andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    
    self.sideValueLabelConstraint.constant = 35;
    switch (icon) {
        case 0:
            [self.disclosureImage setImage:[UIImage imageNamed:@"ChevronWhite"]];
            break;
            
        case 1:
            [self.disclosureImage setImage:[UIImage imageNamed:@"switchButtonWhiteOn"]];
            self.disclosureImageWidthConstraint.constant = 52;
            break;
            
        case 2:
            [self.disclosureImage setImage:[UIImage imageNamed:@"switchButtonWhiteOff"]];
            self.disclosureImageWidthConstraint.constant = 52;
            break;
            
        case 3:
            [self.disclosureImage setImage:nil];
            self.sideValueLabelConstraint.constant = 10;
            break;
        default:
            break;
    }
}

@end
