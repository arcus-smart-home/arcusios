//
//  ArcusAlarmHistoryListCell.m
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
#import "ArcusAlarmHistoryListCell.h"

#import "AKFileManager.h"
#import "UIImage+ScaleSize.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "CareBehaviorModel.h"
#import "NSDate+Convert.h"
#import "UIImage+ImageEffects.h"

@implementation ArcusAlarmHistoryListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTime:(NSString *)time name:(NSString *)name event:(NSString *)event eventModel:(Model *)eventModel {
    if (eventModel != nil) {
        if ([eventModel isKindOfClass:[RuleModel class]]) {
            RuleModel *model = (RuleModel *)eventModel;
            NSDate *created = [model getCreatedDate];
            NSString *modelName = [model getName];
            
            [_timeLabel styleSet:[created formatDate:@"hh:mm a"] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
            [_titleLabel styleSet:@"ALARM TRIGGERED" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES] upperCase:YES];
            [_subtitleLabel styleSet:modelName andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:YES alpha:YES]];
            _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [_iconImage setTintColor:[UIColor blackColor]];
            [_iconImage setImage:[UIImage imageNamed:@"care"]];
        } else if ([eventModel isKindOfClass:[CareBehaviorModel class]]) {
            CareBehaviorModel *model = (CareBehaviorModel *)eventModel;
            NSDate *created = [model lastFired];
            NSString *modelName = [model name];

            [_timeLabel styleSet:[created formatDate:@"hh:mm a"] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
            if ([[model name] isEqualToString:@"by Panic"]) {
                [_titleLabel styleSet:@"TRIGGERED" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES] upperCase:YES];
            } else {
                [_titleLabel styleSet:@"BEHAVIOR TRIGGERED" andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES] upperCase:YES];
            }
            [_subtitleLabel styleSet:modelName andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:YES alpha:YES]];
            _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [_iconImage setTintColor:[UIColor blackColor]];
            [_iconImage setImage:[UIImage imageNamed:@"care"]];
        } else {
            [_timeLabel styleSet:time andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
            [_titleLabel styleSet:name andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES] upperCase:YES];
            [_subtitleLabel styleSet:event andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:YES alpha:YES]];
            _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }
    } else {
        [_timeLabel styleSet:time andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
        [_titleLabel styleSet:name andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES] upperCase:YES];
        [_subtitleLabel styleSet:event andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:YES alpha:YES]];
        _subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
}


@end
