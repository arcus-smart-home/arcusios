//
//  DeviceSettingCells.m
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

#import <i2app-Swift.h>
#import "DeviceSettingCells.h"
#import "DeviceSettingsViewController.h"
#import "SDWebImageManager.h"

#pragma mark - base setting ccell
@implementation DeviceSettingCell

+ (DeviceSettingCell *)create:(DeviceSettingUnitBase *)unit {
    return [[DeviceSettingCell alloc] init];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (IBAction)pressedBackgroup:(id)sender {
    if (_pressedBackgroupSelector && _unitData && [_unitData respondsToSelector:_pressedBackgroupSelector]) {
        [_unitData performSelector:_pressedBackgroupSelector withObject:self afterDelay:0];
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

- (void)refreshView {
    
}

@end

#pragma mark - extension cell style
@implementation DeviceSettingTextSubtitleCell

+ (DeviceSettingCell *)create:(DeviceSettingUnitBase *)unit {
    DeviceSettingsViewController *controller = (DeviceSettingsViewController *)unit.controlOwner;
    DeviceSettingTextSubtitleCell *cell = [controller.tableView dequeueReusableCellWithIdentifier:@"TextSubtitleCell"];
    [cell setUnitData:unit];
    
    return cell;
}

- (void)refreshView {
    [self.subtitleLabel setNumberOfLines:0];
    
    [self.titleLabel styleSet:self.unitData.title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [self.subtitleLabel styleSet:[self.unitData getStringFrom:@"subtitle"] andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    [self.valueLabel styleSet:[self.unitData getStringFrom:@"value"] andButtonType:FontDataType_Medium_13_WhiteAlpha_NoSpace];
    [self.arrowIcon setHidden:[self.unitData getBooleanFrom:@"disableArrow"]];
    
    [self layoutIfNeeded];
    [self.subtitleLabel sizeToFit];
    if (self.subtitleLabel.frame.size.height > 10) {
        [self setHeight:self.subtitleLabel.frame.size.height + 50];
    }
    else {
        [self setHeight:self.subtitleLabel.frame.size.height + 30];
    }
}

@end

@implementation DeviceSettingTextSubtitleSwitchCell

+ (DeviceSettingCell *)create:(DeviceSettingUnitBase *)unit {
    DeviceSettingsViewController *controller = (DeviceSettingsViewController *)unit.controlOwner;
    DeviceSettingTextSubtitleCell *cell = [controller.tableView dequeueReusableCellWithIdentifier:@"TextSwitchCell"];
    [cell setUnitData:unit];
    
    return cell;
}

- (void)refreshView {
    [self.subtitleLabel setNumberOfLines:0];
    
    [self.titleLabel styleSet:self.unitData.title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [self.subtitleLabel styleSet:[self.unitData getStringFrom:@"subtitle"] andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    [self.switchButton setSelected:[self.unitData getBooleanFrom:@"switchState"]];
    
    [self layoutIfNeeded];
    [self.subtitleLabel sizeToFit];
    if (self.subtitleLabel.frame.size.height > 10) {
        [self setHeight:self.subtitleLabel.frame.size.height + 80];
    }
    else {
        [self setHeight:self.subtitleLabel.frame.size.height + 50];
    }
}

- (IBAction)pressedSwitch:(id)sender {
    [_switchButton setSelected:!_switchButton.selected];
    
    if (_switchSelector && self.unitData && [self.unitData respondsToSelector:_switchSelector]) {
        [self.unitData performSelector:_switchSelector withObject:self afterDelay:0];
    }
}

@end

@implementation DeviceSettingLogoTitleCell

+ (DeviceSettingCell *)create:(DeviceSettingUnitBase *)unit {
    DeviceSettingsViewController *controller = (DeviceSettingsViewController *)unit.controlOwner;
    DeviceSettingTextSubtitleCell *cell = [controller.tableView dequeueReusableCellWithIdentifier:@"LogoTitleCell"];
    [cell setUnitData:unit];
    
    return cell;
}

- (void)refreshView {
    [self.titleLabel setNumberOfLines:0];

    [self.titleLabel styleSet:self.unitData.title andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:NO space:NO]];
    [self.arrowIcon setHidden:[self.unitData getBooleanFrom:@"disableArrow"]];
    UIImage *image = (UIImage *)[self.unitData getValueFrom:@"logoImage"];
    if (image && [image isKindOfClass:[UIImage class]]) {
        [_logoImage setImage:image];
    }
    else {
        NSString *imageUrl =[self.unitData getStringFrom:@"logoImageUrl"];
        if (imageUrl && imageUrl.length > 0) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [_logoImage setImage:image];
            }];
        }
    }
    
    [self setHeight:70];
}

@end

