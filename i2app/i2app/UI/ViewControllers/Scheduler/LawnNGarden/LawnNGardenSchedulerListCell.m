//
//  LawnNGardenSchedulerListCell.m
//  i2app
//
//  Created by Arcus Team on 3/10/16.
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
#import "LawnNGardenSchedulerListCell.h"
#import "IrrigationScheduledEventModel.h"
#import "NSDate+Convert.h"

@implementation LawnNGardenSchedulerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(IrrigationScheduledEventModel *)model hasLightBackground:(BOOL)hasLightBackground {
    
    if (hasLightBackground) {
        [self.timeLabel styleSet:[model.eventTime formatDateTimeStamp] andButtonType:FontDataType_Medium_12_Black];
        [self.sideLabel styleSet:[model getSideValue] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
        [self.eventTitle styleSet:model.title andFontData:[FontData createFontData:FontTypeBold size:14 blackColor:YES alpha:YES]];
        [self.eventDetails styleSet:model.details andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:YES alpha:YES]];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chevron"]];
    }
    else {
        [self.timeLabel styleSet:[model.eventTime formatDateTimeStamp] andButtonType:FontDataType_Medium_12_White_NoSpace];
        [self.sideLabel styleSet:[model getSideValue] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
        [self.eventTitle styleSet:model.title andFontData:[FontData createFontData:FontTypeBold size:14 blackColor:NO alpha:NO]];
        [self.eventDetails styleSet:model.details andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO alpha:YES]];
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChevronWhite"]];
    }
}

@end
