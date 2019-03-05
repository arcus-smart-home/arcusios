// 
// DisabledDeviceCell.m
//
// Created by Arcus Team on 3/17/16.
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
#import "DisabledDeviceCell.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "ArcusLabel.h"
#import "DisabledDeviceCard.h"
#import <i2app-Swift.h>


@interface DisabledDeviceCell ()

@end

@implementation DisabledDeviceCell {

}

@dynamic titleLabel;
@dynamic subtitleLabel;

+ (DisabledDeviceCell *)createCell:(DeviceModel *)deviceModel owner:(UIViewController *)owner {
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"DisabledDeviceCell" owner:self options:nil];
    DisabledDeviceCell *cell = [xibViews objectAtIndex:0];
    cell.parentController = owner;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(getDeviceStateChangedNotification:) name:deviceModel.modelChangedNotification object:nil];
    return cell;
}

#pragma mark - CardCell Protocol

- (void)bindCard:(Card *)card {
    DisabledDeviceCard *disabledCard = (DisabledDeviceCard*)card;

    self.deviceModel = disabledCard.model;

    [self.titleLabel setText:disabledCard.title];
    [self.subtitleLabel setText:disabledCard.subtitle];

    switch (disabledCard.type) {
        case ALERT:
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [self.subtitleLabel setTextColor:[UIColor whiteColor]];
            [self.alertContainer setBackgroundColor:pinkAlertColor];
            break;
            
        case MESSAGE:
            [self.titleLabel setTextColor:[UIColor darkTextColor]];
            [self.subtitleLabel setTextColor:[UIColor darkTextColor]];
            [self.alertContainer setBackgroundColor:[UIColor whiteColor]];
            break;
    }

    [self loadDeviceImageFromPlatform];
}

#pragma mark - Load Data
- (void)loadData {
    // Handled By bindModel:
}

# pragma mark Helping Functions

- (void)loadDeviceImageFromPlatform {
    if (self.centerIcon.image && ![self.centerIcon.image isEqual:[UIImage imageNamed:@"PlaceholderWhite"]]) {
        return;
    }

    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:self.deviceModel] withDevTypeId:[self.deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {

        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground) {
            return;
        }

        [self.centerIcon setImage:image];
    });
}

@end
