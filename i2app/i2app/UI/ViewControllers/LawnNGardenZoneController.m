// 
// LawnNGardenZoneController.m
//
// Created by Arcus Team on 3/16/16.
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
#import "LawnNGardenZoneController.h"


#import "IrrigationZoneCapability.h"

@interface LawnNGardenZoneController()

@property (strong, nonatomic) id<LawnNGardenZoneProtocol> callback;

@end

@implementation LawnNGardenZoneController {

}

- (instancetype)initWithCallback:(id<LawnNGardenZoneProtocol>)delegate {
    self = [super init];
    if (self) {
        self.callback = delegate;
    }
    return self;
}


- (void)saveZoneName:(NSString *)name duration:(int)minutes forDevice:(NSString *)address andZone:(NSString *)zoneId {
    __block DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    NSString *durationAttr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneDefaultDuration, zoneId];
    NSString *nameAttr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneZonename, zoneId];
    if (deviceModel != nil) {
        [deviceModel set:@{nameAttr:name}];
        [deviceModel set:@{durationAttr:@(minutes)}];
        
        [deviceModel commit].thenInBackground(^(){
            [deviceModel refresh].then(^ {
                if (self.callback != nil) {
                    [self.callback didSaveZone];
                }
            });
        });
    }
}

+ (NSString *)getNameForZone:(NSString *)zoneId device:(DeviceModel *)deviceModel {
    NSString *zoneNameAttr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneZonename, zoneId];
    
    return [deviceModel get][zoneNameAttr];
}


+ (NSString *)getSafeNameForZone:(NSString *)zoneId device:(DeviceModel *)deviceModel {
    NSString *zoneNameAttr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneZonename, zoneId];
    
    NSString *zoneName = [deviceModel get][zoneNameAttr];
    
    // If the zone name is nil then let's just give it the name of Zone #
    if (zoneName.length == 0) {
        NSString *zoneNumberAttr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneZonenum, zoneId];
        
        zoneName = [NSString stringWithFormat:@"Zone %@", [deviceModel get][zoneNumberAttr]];
    }
    return zoneName;
}

+ (int)getDefaultDurationForZone:(NSString *)zone device:(DeviceModel *)deviceModel {
    NSString *zoneAddr = [NSString stringWithFormat:@"%@:%@", kAttrIrrigationZoneDefaultDuration, zone];

    return [[deviceModel get][zoneAddr] intValue];
}


@end
