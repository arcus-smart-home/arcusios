//
//  CareActivitySection.m
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
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "SubsystemsController.h"
#import "CareSubsystemController.h"
#import "NSDate+Convert.h"



@interface CareActivitySection ()

@end

@implementation CareActivitySection

#pragma mark - Getters & Setters

- (CareCalendarUnit)sectionType {
    if (!_sectionType) {
        _sectionType = CareCalendarUnitDay;
    }
    return _sectionType;
}

- (NSInteger)sectionMultiplier {
    if (_sectionMultiplier < 1) {
        _sectionMultiplier = 1;
    }
    return _sectionMultiplier;
}

- (CareCalendarUnit)unitType {
    if (!_unitType) {
        _unitType = CareCalendarUnitHour;
    }
    return _unitType;
}

- (NSInteger)unitMultiplier {
    if (_unitMultiplier < 1) {
        _unitMultiplier = 1;
    }
    return _unitMultiplier;
}

- (CareCalendarUnit)intervalResolution {
    if (!_intervalResolution) {
        _intervalResolution = CareCalendarUnitMinute;
    }
    return _intervalResolution;
}

- (NSInteger)resolutionMultipler {
    if (_resolutionMultipler < 1) {
        _resolutionMultipler = 1;
    }
    return _resolutionMultipler;
}

- (NSArray *)filterDevices {
    if (!_filterDevices) {
        _filterDevices = self.careSubsystem.activeDeviceIds;
    }
    return _filterDevices;
}

- (NSString *)detailsToken {
    if (!_detailsToken) {
      _detailsToken = @"";
    }
    return _detailsToken;
}

- (CareSubsystemController *)careSubsystem {
    if (!_careSubsystem) {
        _careSubsystem = [[SubsystemsController sharedInstance] careController];
    }
    return _careSubsystem;
}

#pragma mark - Configuration

- (void)configureSectionWithIntervals:(NSArray <CareActivityInterval *> *)intervals {
    [self configureUnits];
    [self configureIntervals:intervals];
}

- (void)configureUnits {
    NSInteger unitCount = [CareActivityManager careCalendarUnitCountBetweenStartDate:self.startDate
                                                              endDate:self.endDate
                                                         calendarUnit:self.unitType] / self.unitMultiplier;
    
    NSMutableArray *mutableUnits = [[NSMutableArray alloc] init];
    
    for (int unitIndex = 0; unitIndex < unitCount; unitIndex++) {
        CareActivityUnit *unit = [[CareActivityUnit alloc] init];
        unit.startDate = [CareActivityManager startDateForIndex:unitIndex
                                                           unit:self.unitType
                                                     multiplier:self.unitMultiplier
                                                referenceDate:self.startDate];
        unit.endDate = [CareActivityManager endDateForIndex:unitIndex
                                                       unit:self.unitType
                                                 multiplier:self.unitMultiplier
                                              referenceDate:self.startDate];
        
        [mutableUnits addObject:unit];

        if ([[NSDate date] compare:unit.startDate] == NSOrderedAscending) {
            break;
        }
    }
    
    self.activityUnits = [NSArray arrayWithArray:mutableUnits];
}

- (void)configureIntervals:(NSArray *)receivedIntervals {
    NSMutableArray *mutableIntervals = [[NSMutableArray alloc] init];
    for (CareActivityInterval *interval in receivedIntervals) {
        if ([NSDate isDate:interval.intervalDate
greaterThanEqualToStartDate:self.startDate
        andLessThanEndDate:self.endDate]) {
            [mutableIntervals addObject:interval];

            for (CareActivityUnit *unit in self.activityUnits) {
                if ([NSDate isDate:interval.intervalDate
       greaterThanEqualToStartDate:unit.startDate
                andLessThanEndDate:unit.endDate]) {
                    NSMutableArray *intervalsArray = [[NSMutableArray alloc] initWithArray:unit.unitIntervals];
                    [intervalsArray addObject:interval];
                    unit.unitIntervals = [NSArray arrayWithArray:intervalsArray];
                }
            }
        }
    }
    
    self.activityIntervals = [NSArray arrayWithArray:mutableIntervals];
}

@end
