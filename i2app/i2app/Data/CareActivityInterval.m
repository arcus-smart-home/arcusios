//
//  CareActivityInterval.m
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
#import "CareActivityInterval.h"



@implementation CareActivityInterval

#pragma mark - Initialization

+ (CareActivityInterval *)intervalWithInfo:(NSDictionary *)info {
    CareActivityInterval *interval = [[CareActivityInterval alloc] init];
    if (info[@"start"] != [NSNull null]) {
        interval.intervalDate = [NSDate dateWithTimeIntervalSince1970:[info[@"start"] doubleValue] / 1000.0];
    }
    
    if (info[@"devices"] != [NSNull null]) {
        NSMutableArray *mutableActiveDevices = [[NSMutableArray alloc] init];
        
        NSDictionary *deviceDictionary = info[@"devices"];
        for (NSString *key in deviceDictionary.allKeys) {
            NSDictionary *activeDeviceDict = @{@"deviceAddress" : key,
                                               @"deviceEvent" : deviceDictionary[key]};
            [mutableActiveDevices addObject:activeDeviceDict];
        }
        interval.activeDeviceInfo = [NSArray arrayWithArray:mutableActiveDevices];
        [interval setIntervalTypeWithDeviceInfo:interval.activeDeviceInfo];
    }
        
    return interval;
}

- (void)setIntervalTypeWithDeviceInfo:(NSArray *)deviceInfoArray {
    CareActivityIntervalType intervalType = CareActivityIntervalTypeNone;
    
    for (NSDictionary *deviceInfo in deviceInfoArray) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceInfo[@"deviceAddress"]];
        if ([deviceInfo[@"deviceEvent"] isEqualToString:@"ACTIVATED"]) {
            switch ([device deviceType]) {
                case DeviceTypeContactSensor:
                    intervalType = (intervalType | CareActivityIntervalTypeContactStart);
                    break;
                case DeviceTypeMotionSensor:
                    intervalType = (intervalType | CareActivityIntervalTypeMotionStart);
                    break;
                case DeviceTypeCamera:
                    intervalType = (intervalType | CareActivityIntervalTypeMotionStart);
                    break;
                default:
                    intervalType = (intervalType | CareActivityIntervalTypeGeneral);
                    break;
            }
        } else if ([deviceInfo[@"deviceEvent"] isEqualToString:@"DEACTIVATED"]) {
            switch ([device deviceType]) {
                case DeviceTypeContactSensor:
                    intervalType = (intervalType | CareActivityIntervalTypeContactStop);
                    break;
                case DeviceTypeMotionSensor:
                    intervalType = (intervalType | CareActivityIntervalTypeMotionStop);
                    break;
                case DeviceTypeCamera:
                    intervalType = (intervalType | CareActivityIntervalTypeMotionStop);
                    break;
                default:
                    break;
            }
        }
    }
    
    [self setIntervalType:intervalType];
}

- (NSArray *)deviceInfoForContactActivity {
    NSMutableArray *mutableDeviceInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *deviceInfo in self.activeDeviceInfo) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceInfo[@"deviceAddress"]];
        if ([device deviceType] == DeviceTypeContactSensor) {
            [mutableDeviceInfo addObject:deviceInfo];
        }
    }
    
    NSSortDescriptor *sortByEvent = [NSSortDescriptor sortDescriptorWithKey:@"deviceEvent"
                                                                  ascending:YES];
    NSArray *sortedArray = [mutableDeviceInfo sortedArrayUsingDescriptors:@[sortByEvent]];
    
    return sortedArray;
}

- (NSArray *)deviceInfoForMotionActivity {
    NSMutableArray *mutableDeviceInfo = [[NSMutableArray alloc] init];
    for (NSDictionary *deviceInfo in self.activeDeviceInfo) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceInfo[@"deviceAddress"]];
        if ([device deviceType] == DeviceTypeMotionSensor ||
            [device deviceType] == DeviceTypeCamera) {
            [mutableDeviceInfo addObject:deviceInfo];
        }
    }
    
    NSSortDescriptor *sortByEvent = [NSSortDescriptor sortDescriptorWithKey:@"deviceEvent"
                                                                  ascending:YES];
    NSArray *sortedArray = [mutableDeviceInfo sortedArrayUsingDescriptors:@[sortByEvent]];
    
    return sortedArray;
}

#pragma mark - ActivityGraphViewProtocol

- (UIColor *)lineColor {
    return _lineColor = [UIColor whiteColor];
}

- (ActivityGraphUnitType)activityGraphUnitTypeWithGraphStyle:(ActivityGraphStyleType)styleType {
  
    ActivityGraphUnitType graphUnitType = ActivityGraphUnitTypeNone;
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeGeneral]) {
        graphUnitType = (graphUnitType | ActivityGraphUnitTypeSolid);
    }
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeMotionStart]) {
        graphUnitType = (graphUnitType | ActivityGraphUnitTypeContinuousStart);
    }
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeMotionContinuous]) {
        // Used to circumvent styleType == ActivityGraphStyleTypeSolidNoContinuous
        // in order to show continual activity for motion sensors.
        if (styleType == ActivityGraphStyleTypeSolid) {
            graphUnitType = (graphUnitType | ActivityGraphUnitTypeContinuousMid);
        } else if (styleType == ActivityGraphStyleTypeSolidNoContinuous) {
            graphUnitType = (graphUnitType | ActivityGraphUnitTypeSolid);
        }
    }
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeContactStart]) {
        graphUnitType = (graphUnitType | ActivityGraphUnitTypeContinuousStart);
    }
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeContactContinuous]) {
        // Used to circumvent styleType == ActivityGraphStyleTypeSolid
        // in order to not show continual activity for contact sensors.
        if (styleType != ActivityGraphStyleTypeSolid) {
            graphUnitType = (graphUnitType | ActivityGraphUnitTypeContinuousMid);
        }
    }
    
    if ([self intervalTypeContainsType:CareActivityIntervalTypeContactStop]) {
        graphUnitType = (graphUnitType | ActivityGraphUnitTypeContinuousStop);
    }
    
    return graphUnitType;
}

- (BOOL)intervalTypeContainsType:(CareActivityIntervalType)type {
    return (self.intervalType & type) == type;
}

@end
