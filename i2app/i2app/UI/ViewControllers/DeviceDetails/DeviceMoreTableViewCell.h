//
//  DeviceMoreTableViewCell.h
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

#import <UIKit/UIKit.h>

@interface DeviceMoreTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *settingsLabel;
@property (nonatomic, strong) IBOutlet UILabel *mainTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondaryTextLabel;
@property (nonatomic, strong) IBOutlet UIImageView *disclosureImage;
@property (nonatomic, strong) IBOutlet UIButton *primaryButton;
@property (nonatomic, strong) IBOutlet UIView *cellSeperator;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *sideValueLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disclosureImageWidthConstraint;

@property (nonatomic, strong) NSDictionary *attributes;

- (void)setData:(NSString *)mainText secondText:(NSString *)secondtext iconType:(NSInteger)icon;

@end
