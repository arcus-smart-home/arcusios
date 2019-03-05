//
//  DeviceSettingCells.h
//  i2app
//
//  Created by Arcus Team on 8/7/15.
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

#import "DeviceSettingModels.h"

#pragma mark - base setting ccell
@interface DeviceSettingCell : UITableViewCell

@property (strong, nonatomic) DeviceSettingUnitBase *unitData;

@property (nonatomic) SEL pressedBackgroupSelector;

+ (DeviceSettingCell *)create:(DeviceSettingUnitBase *)unit;
- (IBAction)pressedBackgroup:(id)sender;
- (void)refreshView;

@end

#pragma mark - extension cell style
// Camera example cells
@interface DeviceSettingTextSubtitleCell : DeviceSettingCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@end

@interface DeviceSettingTextSubtitleSwitchCell : DeviceSettingCell

@property (nonatomic) SEL switchSelector;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchButton;

@end

// Fob example cells
@interface DeviceSettingLogoTitleCell : DeviceSettingCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@end

// Garage door example cells
@interface DeviceSettingTitleButtonCell : DeviceSettingCell

@end




