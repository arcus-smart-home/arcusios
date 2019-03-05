// 
// LawnNGardenMoreZoneListCell.m
//
// Created by Arcus Team on 3/14/16.
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
#import "LawnNGardenMoreZoneListCell.h"
#import "IrrigationZoneModel.h"
#import "UIImage+ImageEffects.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"

@implementation LawnNGardenMoreZoneListCell {

}

- (void)initializeWithZone:(IrrigationZoneModel *)zoneModel
            andDeviceModel:(DeviceModel *)device
        withTextColorBlack:(BOOL)isBlack {
    if (zoneModel.name.length > 0) {
        self.titleLabel.text = zoneModel.name;
    }
    self.titleLabel.hidden = zoneModel.name.length == 0;
    self.subtitleLabel.text = zoneModel.defaultZoneName;

    self.sideLabel.text = [NSString stringWithFormat:@"%d Mins", zoneModel.defaultDuration];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                               withDevTypeId:[device devTypeHintToImageName]
                             withPlaceHolder:nil
                                     isLarge:NO
                                isBlackStyle:NO].then(^(UIImage *image) {
            if (isBlack) {
                self.deviceImage.image = [image invertColor];
            }
            else {
                self.deviceImage.image = image;
            }
        });
    });
}

@end
