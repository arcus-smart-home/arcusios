//
//  CareAlarmDeviceListCell.m
//  i2app
//
//  Created by Arcus Team on 2/3/16.
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
#import "CareAlarmDeviceListCell.h"

#import "SDWebImageManager.h"
#import "ImagePaths.h"
#import "UIImage+ImageEffects.h"

@implementation CareAlarmDeviceListCell {
    DeviceModel *_model;
}

- (void)setToEmptyCell {
    [self setToEmptyCellWithImage:@"PlaceholderWhite"];
}

- (void)setToEmptyCellWithImage:(NSString *)imageName {
    [self.titleLabel styleSet:@"-" andButtonType:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace upperCase:NO];
    [self.sideLabel styleSet:@"" andButtonType:FontDataType_Medium_12_White];
    [self.deviceImage setImage:[UIImage imageNamed:imageName]];
}

- (void)setModel:(DeviceModel *)model type:(AlarmDevicePageType)type {
    _model = model;
    [self.titleLabel styleSet:model.name andButtonType:FontDataType_DemiBold_13_White upperCase:YES];
    
    if (type == AlarmDeviceTypeSecurityOnMode || type == AlarmDeviceTypeSecurityPartialMode) {
        [self.subtitleLabel styleSet:[model securityDeviceStatus] andButtonType:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace upperCase:NO];
    }
    else {
        [self.subtitleLabel styleSet:model.vendor andButtonType:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace upperCase:YES];
    }
    
    if (type == AlarmDeviceTypeSecurityDevicesMore) {
        [self.sideLabel styleSet:[model securityModeStatus] andButtonType:FontDataType_Medium_12_White];
    }
    else {
        [self.sideLabel styleSet:@"" andButtonType:FontDataType_Medium_12_White];
    }
    
    NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[_model devTypeHintToImageName]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [self.deviceImage setImage:image];
    }];
}

@end
