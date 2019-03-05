//
//  GlobalEnumeration.h
//  i2app
//
//  Created by Arcus Team on 9/1/15.
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

#import <Foundation/Foundation.h>

#pragma mark - Thermostat type
typedef enum {
    ThermostatHeatMode   = 0,
    ThermostatCoolMode,
    ThermostatAutoMode,
    ThermostatOffMode,
} ThermostatModeType;
#define ThermostatModeStringToType(str) (ThermostatModeType)[@[@"HEAT", @"COOL", @"AUTO", @"OFF"] indexOfObject:str]

#pragma mark - Dashboard service type
typedef enum {
    DashboardCardTypeFavorites = 0,
    DashboardCardTypeHistory,
    DashboardCardTypeSafety,
    DashboardCardTypeSecurity,
    
    DashboardCardTypeLightsSwitches,
    DashboardCardTypeClimate,
    DashboardCardTypeDoorsLocks,
    DashboardCardTypeHomeFamily,
    DashboardCardTypeWindowsBlinds,
    DashboardCardTypeCameras,
    DashboardCardTypeLawnGarden,
    DashboardCardTypeCare,
    DashboardCardTypeWater,
    DashboardCardTypeEnergy,
    
    DashboardCardTypeSantaTracker,
    DashboardCardTypeAlarms,
} DashboardCardType;
#define DashboardCardTypeToString(enum) [@[@"Favorites", @"History", @"Safety Alarm", @"Security Alarm", @"Lights & Switches", @"Climate", @"Doors & Locks", @"Home & Family", @"Windows & Blinds", @"Cameras", @"Lawn & Garden", @"Care", @"Water", @"Energy", @"Santa Tracker™", @"Alarms"] objectAtIndex:enum]
#define DashboardCardTypeToCellIdentifier(enum) [@[@"favoritesCell", @"historyCell", @"safetyAlarmCell", @"securityAlarmCell", @"lightSwitchsCell", @"climateCell", @"doorsLocksCell", @"homeFamilyCell", @"windowsBlindsCell", @"camerasCell", @"lawnGardenCell", @"careCell", @"watersCell", @"energyCell", @"santaTrackerCell", @"alarms"] objectAtIndex:enum]

typedef enum {
    DashboardCardStatusDisabled     = 0,
    DashboardCardStatusActive       = 1,
    DashboardCardStatusInactive     = 2,
} DashboardCardStatus;
