//
//  AlarmHistoryCell.m
//  i2app
//
//  Created by Arcus Team on 3/3/16.
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
#import "AlarmHistoryCell.h"
#import "UIImage+ImageEffects.h"

@implementation AlarmHistoryCell


- (void)setTime:(NSString *)time alarmType:(NSString *)alarmType event:(NSString *)event eventModel:(Model *)eventModel {
    [_timeLabel styleSet:time andButtonType:FontDataType_Medium_12_WhiteAlpha_NoSpace];
    [_titleLabel styleSet:event andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [_subtitleLabel styleSet:alarmType andButtonType:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace];
    _iconImage.hidden = YES;
}

- (void)setTime:(NSString *)time alarmType:(NSString *)alarmType event:(NSString *)event eventModel:(Model *)eventModel image:(NSString *)image invertImage:(BOOL)invert {
    [_timeLabel styleSet:time andButtonType:FontDataType_DemiBold_12_White_NoSpace];
    [_titleLabel styleSet:event andButtonType:FontDataType_DemiBold_12_White_NoSpace upperCase:NO];
    [_subtitleLabel styleSet:alarmType andButtonType:FontDataType_Medium_13_WhiteAlpha_NoSpace];
    _iconImage.image = (invert)? [[UIImage imageNamed:image] invertColor] : [UIImage imageNamed:image];
    
    /*
     if (eventModel) {
     
     UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:eventModel.modelId atSize:_iconImage.frame.size withScale:[UIScreen mainScreen].scale];
     
     if (image) {
     image = [image exactZoomScaleAndCutSizeInCenter:_iconImage.bounds.size];
     image = [image roundCornerImageWithsize:_iconImage.bounds.size];
     
     _iconImage.layer.cornerRadius = _iconImage.bounds.size.width / 2.0f;
     _iconImage.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f].CGColor;
     _iconImage.layer.borderWidth = 2.0f;
     
     [_iconImage setImage:image];
     }
     else {
     if ([eventModel isKindOfClass:[DeviceModel class]]) {
     NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[(DeviceModel *)eventModel devTypeHintToImageName]];
     [_iconImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"PlaceholderWhite"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
     _iconImage.layer.borderWidth = 0.0f;
     image = [image invertColor];
     [_iconImage setImage:image];
     }];
     }
     else if ([eventModel isKindOfClass:[PlaceModel class]]) {
     [_iconImage setImage:[[UIImage imageNamed:@"account_Home"] invertColor]];
     }
     else if ([eventModel isKindOfClass:[PersonModel class]]) {
     [_iconImage setImage:[[UIImage imageNamed:@"account_user"] invertColor]];
     }
     }
     }*/
}

@end
