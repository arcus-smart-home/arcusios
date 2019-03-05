//
//  DashboardCardModel.m
//  i2app
//
//  Created by Arcus Team on 2/12/16.
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
#import "DashboardCardModel.h"
#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"
#import "SecuritySubsystemAlertController.h"
#import "LightsNSwitchesSubsystemController.h"
#import "ClimateSubSystemController.h"
#import "DoorsNLocksSubsystemController.h"
#import "PresenceSubsystemController.h"
#import "CameraSubsystemController.h"
#import "WaterSubsystemController.h"
#import "CareSubsystemController.h"

#import "LawnNGardenSubsystemController.h"

@implementation DashboardCardModel

- (instancetype)initWithType:(DashboardCardType) type {
    if (self = [super init]) {
        self.enabled = YES;
        self.type = type;
        self.serviceName = DashboardCardTypeToString(type);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"serviceName = %@; dashboardCardType = %d; enabled = %d", self.serviceName, self.type, self.enabled];
}

- (UIImage *)getSmallIcon {
    switch (self.type) {
        case DashboardCardTypeFavorites:
            return [UIImage imageNamed:@"icon_white_favorites"];
        case DashboardCardTypeCameras:
            return [UIImage imageNamed:@"icon_unfilled_camera"];
        case DashboardCardTypeCare:
            return [UIImage imageNamed:@"icon_unfilled_care"];
        case DashboardCardTypeClimate:
            return [UIImage imageNamed:@"icon_unfilled_climate"];
        case DashboardCardTypeDoorsLocks:
            return [UIImage imageNamed:@"icon_unfilled_doorlocks"];
        case DashboardCardTypeEnergy:
            return [UIImage imageNamed:@"icon_unfilled_energy"];
        case DashboardCardTypeHistory:
            return [UIImage imageNamed:@"icon_unfilled_history"];
        case DashboardCardTypeHomeFamily:
            return [UIImage imageNamed:@"icon_unfilled_familyfriends"];
        case DashboardCardTypeLawnGarden:
            return [UIImage imageNamed:@"icon_unfilled_lawngarden"];
        case DashboardCardTypeLightsSwitches:
            return [UIImage imageNamed:@"icon_unfilled_lightsswitches"];
        case DashboardCardTypeSafety:
            return [UIImage imageNamed:@"icon_unfilled_safetyAndPanicAlarm"];
        case DashboardCardTypeSecurity:
            return [UIImage imageNamed:@"icon_unfilled_securityalarm"];
      case DashboardCardTypeAlarms:
        return [UIImage imageNamed:@"icon_unfilled_securityalarm"];
        case DashboardCardTypeWater:
            return [UIImage imageNamed:@"icon_unfilled_water"];
        case DashboardCardTypeWindowsBlinds:
            return [UIImage imageNamed:@"icon_unfilled_windowblinds"];
        case DashboardCardTypeSantaTracker:
            return [UIImage imageNamed:@"santa_hat"];
        default:
            return [UIImage imageNamed:@"PlaceholderWhite"];
    }
}

- (UIImage *)getIconImage {
    switch (self.type) {
        case DashboardCardTypeFavorites:
            return [UIImage imageNamed:@"icon_white_favorites"];
        case DashboardCardTypeCameras:
            return [UIImage imageNamed:@"icon_camera"];
        case DashboardCardTypeCare:
            return [UIImage imageNamed:@"icon_care"];
        case DashboardCardTypeClimate:
            return [UIImage imageNamed:@"icon_climate"];
        case DashboardCardTypeDoorsLocks:
            return [UIImage imageNamed:@"icon_doorlocks"];
        case DashboardCardTypeEnergy:
            return [UIImage imageNamed:@"icon_energy"];
        case DashboardCardTypeHistory:
            return [UIImage imageNamed:@"icon_history"];
        case DashboardCardTypeHomeFamily:
            return [UIImage imageNamed:@"icon_familyfriends"];
        case DashboardCardTypeLawnGarden:
            return [UIImage imageNamed:@"icon_lawngarden"];
        case DashboardCardTypeLightsSwitches:
            return [UIImage imageNamed:@"icon_lightsswitches"];
        case DashboardCardTypeSafety:
            return [UIImage imageNamed:@"icon_safetyalarm"];
        case DashboardCardTypeSecurity:
            return [UIImage imageNamed:@"icon_securityalarm"];
      case DashboardCardTypeAlarms:
        return [UIImage imageNamed:@"icon_securityalarm"];
        case DashboardCardTypeWater:
            return [UIImage imageNamed:@"icon_water"];
        case DashboardCardTypeWindowsBlinds:
            return [UIImage imageNamed:@"icon_windowblinds"];
        case DashboardCardTypeSantaTracker:
            return [UIImage imageNamed:@"santa_hat"];
        default:
            return [UIImage imageNamed:@"PlaceholderWhite"];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_serviceName forKey:@"ServiceName"];
    [encoder encodeObject:@(_type) forKey:@"Type"];
    [encoder encodeObject:@(_enabled) forKey:@"Enable"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        _serviceName = [decoder decodeObjectForKey:@"ServiceName"];
        id valueType = [decoder decodeObjectForKey:@"Type"];
        if (valueType) {
            _type = [valueType intValue];
        }
        valueType = [decoder decodeObjectForKey:@"Enable"];
        if (valueType) {
            _enabled = [valueType boolValue];
        }
    }
    return self;
}

- (DashboardCardStatus)getDefineServiceCardType {
    switch (self.type) {
        case DashboardCardTypeFavorites:
            return DashboardCardStatusActive;
            
        case DashboardCardTypeHistory:
            return DashboardCardStatusActive;
            
        case DashboardCardTypeSafety:
            if ([SubsystemsController sharedInstance].safetyController.numberOfDevices > 0) {
                return DashboardCardStatusActive;
            }
            else {
                return DashboardCardStatusDisabled;
            }
            
        case DashboardCardTypeSecurity:
            if ([SubsystemsController sharedInstance].securityController.numberOfDevices > 0) {
                return DashboardCardStatusActive;
            }
            else {
                // TEMP: DO NOT COMMIT
                return DashboardCardStatusActive;
            }
        
        case DashboardCardTypeAlarms:
          if ([SubsystemsController sharedInstance].securityController.numberOfDevices > 0) {
            return DashboardCardStatusActive;
          }
          else if ([SubsystemsController sharedInstance].safetyController.numberOfDevices > 0) {
            return DashboardCardStatusActive;
          }
          else {
            return DashboardCardStatusDisabled;
          }
        
        case DashboardCardTypeLightsSwitches:
            if ([SubsystemsController sharedInstance].lightsNSwitchesController.numberOfDevices == 0) {
                return DashboardCardStatusDisabled;
            }
            else {
                return DashboardCardStatusActive;
            }
            
        case DashboardCardTypeClimate:
            if ([[SubsystemsController sharedInstance].climateController temperatureDeviceIds].count == 0) {
                return DashboardCardStatusDisabled;
            }
            else {
                return DashboardCardStatusActive;
            }
        case DashboardCardTypeDoorsLocks:
            if (![SubsystemsController sharedInstance].doorsNLocksController.hasDevices) {
                return DashboardCardStatusDisabled;
            }
            else if ([SubsystemsController sharedInstance].doorsNLocksController.allDevicesAreClosed) {
                return DashboardCardStatusInactive;
            }
            else {
                return DashboardCardStatusActive;
            }
            
        case DashboardCardTypeHomeFamily:
            if ([SubsystemsController sharedInstance].presenceController.allAddresses.count > 0) {
                return DashboardCardStatusActive;
            }
            else {
                return DashboardCardStatusDisabled;
            }
            
        case DashboardCardTypeWindowsBlinds:
            return DashboardCardStatusDisabled;
            
        case DashboardCardTypeCameras:
            if ( [[SubsystemsController sharedInstance].camerasController allDeviceIds].count == 0 ) {
                return DashboardCardStatusDisabled;
            }
            return DashboardCardStatusActive;
            
        case DashboardCardTypeLawnGarden:
            if ([[SubsystemsController sharedInstance].lawnNGardenController isAvailable]) {
                return DashboardCardStatusActive;
            } else {
                return DashboardCardStatusDisabled;
            }
            
        case DashboardCardTypeCare:
            if([[CorneaHolder shared] settings].isPremiumAccount == YES) {
                if ([[[SubsystemsController sharedInstance] careController] allDeviceIds].count > 0) {
                    return DashboardCardStatusActive;
                } else {
                    return DashboardCardStatusDisabled;
                }
            } else {
                return DashboardCardStatusDisabled;
            }
            
        case DashboardCardTypeWater:
            if ([[SubsystemsController sharedInstance].waterController allWaterDeviceAddresses].count > 0) {
                return DashboardCardStatusActive;
            }
            else {
                return DashboardCardStatusDisabled;
            }
            
        case DashboardCardTypeEnergy:
            return DashboardCardStatusDisabled;
            
        case DashboardCardTypeSantaTracker:
            return DashboardCardStatusActive;
            
        default:
            return DashboardCardStatusDisabled;
    }
    
    return DashboardCardStatusDisabled;
    
}

// GAB - remove Care so it will display
// self.type == DashboardCardTypeCare ||
- (BOOL) isComingSoon {
    return (self.type == DashboardCardTypeWindowsBlinds ||
            self.type == DashboardCardTypeEnergy);
}

@end
