//
//  CareActivityManager.m
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
#import "CareActivityManager.h"
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "CareActivityEventInfo.h"
#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"
#import "SubsystemsController.h"


#import "NSDate+Convert.h"

NSInteger const kMaxRetainedSections = 30;
NSInteger const kMaxDetailsReturned = 30;

@interface CareActivityManager ()

@property (nonatomic, assign) NSInteger sectionCount;
@property (nonatomic, strong, readwrite) NSArray <CareActivitySection *> *activitySections;

@end

@implementation CareActivityManager

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserversForChangeEventNotifications];
    }
    return self;
}

- (void)dealloc {
    [self removeObserversForChangeEventNotifications];
}

#pragma mark - Getters & Setters

- (CareSubsystemController *)careSubsystem {
    if (!_careSubsystem) {
        _careSubsystem = [[SubsystemsController sharedInstance] careController];
    }
    return _careSubsystem;
}

- (NSInteger)eventInfoPageSize {
    return kMaxDetailsReturned;
}

#pragma mark - Configuration Methods

- (NSArray <CareActivityInterval *> *)careActivityIntervalsFromResponseDictionary:(NSDictionary *)response
                                                                       forSection:(CareActivitySection *)section {
    NSArray *result = [self configureEmptyCareActivityIntervalsBetweenStartDate:section.startDate
                                                                        endDate:section.endDate
                                                             intervalResolution:section.intervalResolution
                                                             intervalMultiplier:section.resolutionMultipler];
    
    for (NSDictionary *intervalDictionary in response[@"intervals"]) {
        CareActivityInterval *interval = [CareActivityInterval intervalWithInfo:intervalDictionary];
        
        result = [self mergeReceivedInterval:interval
                           existingIntervals:result];
    }
    
    result = [self sortActivityIntervals:result dateAscending:YES];
    result = [self configureIntervalsForContinuousActivities:result];
    
    return result;
}

- (NSArray <CareActivityInterval *> *)mergeReceivedInterval:(CareActivityInterval *)receivedInterval
                                          existingIntervals:(NSArray <CareActivityInterval *> *)existingIntervals {
    NSInteger existingIndex = -1;
    NSMutableArray *mutableResult = [[NSMutableArray alloc] initWithArray:existingIntervals];
    for (CareActivityInterval *existingInterval in mutableResult) {
        if ([existingInterval.intervalDate compare:receivedInterval.intervalDate] == NSOrderedSame) {
            existingIndex = [mutableResult indexOfObject:existingInterval];
            break;
        }
    }
    
    if (existingIndex >= 0 && existingIndex < [mutableResult count]) {
        [mutableResult replaceObjectAtIndex:existingIndex withObject:receivedInterval];
    } else {
        [mutableResult addObject:receivedInterval];
    }

    return [NSArray arrayWithArray:mutableResult];
}

- (NSArray <CareActivityInterval *> *)sortActivityIntervals:(NSArray <CareActivityInterval *> *)intervals
                                              dateAscending:(BOOL)ascendingDescending {
    if ([intervals count] > 0) {
        intervals = [intervals sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [(CareActivityInterval*)a intervalDate];
            NSDate *second = [(CareActivityInterval*)b intervalDate];
            return ascendingDescending ? [first compare:second] : [second compare:first];
        }];
    }
    return intervals;
}

- (NSArray <CareActivityInterval *> *)configureIntervalsForContinuousActivities:(NSArray <CareActivityInterval *> *)intervals {
    
    /* This approach is not very efficient, but simply keeping track of motion/contact state by the use of counters does not handle the possibility of duplicate ACTIVATION events.  This approach should no add duplicates, and should fix issues with motion */
    NSMutableArray *mutableContactActivities = [[NSMutableArray alloc] init];
    NSMutableArray *mutableMotionActivities = [[NSMutableArray alloc] init];
    for (CareActivityInterval *interval in intervals) {
        for (NSDictionary *contactSensorInfo in [interval deviceInfoForContactActivity]) {
            if ([contactSensorInfo[@"deviceEvent"] isEqualToString:@"ACTIVATED"]) {
                if ([mutableContactActivities containsObject:contactSensorInfo]) {
                    [mutableContactActivities replaceObjectAtIndex:[mutableContactActivities indexOfObject:contactSensorInfo]
                                                        withObject:contactSensorInfo];
                } else {
                    [mutableContactActivities addObject:contactSensorInfo];
                }
            } else if ([contactSensorInfo[@"deviceEvent"] isEqualToString:@"DEACTIVATED"]) {
                NSDictionary *existingTest = @{@"deviceAddress" : contactSensorInfo[@"deviceAddress"],
                                               @"deviceEvent" : @"ACTIVATED"};
                [mutableContactActivities removeObject:existingTest];
            }
        }

        for (NSDictionary *motionSensorInfo in [interval deviceInfoForMotionActivity]) {
            if ([motionSensorInfo[@"deviceEvent"] isEqualToString:@"ACTIVATED"]) {
                if ([mutableMotionActivities containsObject:motionSensorInfo]) {
                    [mutableMotionActivities replaceObjectAtIndex:[mutableMotionActivities indexOfObject:motionSensorInfo]
                                                        withObject:motionSensorInfo];
                } else {
                    [mutableMotionActivities addObject:motionSensorInfo];
                }
            } else if ([motionSensorInfo[@"deviceEvent"] isEqualToString:@"DEACTIVATED"]) {
                NSDictionary *existingTest = @{@"deviceAddress" : motionSensorInfo[@"deviceAddress"],
                                               @"deviceEvent" : @"ACTIVATED"};
                [mutableMotionActivities removeObject:existingTest];
            }
        }

        if (([mutableContactActivities count] > 0 || [mutableMotionActivities count] > 0) &&
            [interval.intervalDate compare:[NSDate date]] != NSOrderedDescending) {
            interval.activeDeviceInfo = [NSArray arrayWithArray:mutableContactActivities];
            
            if ([mutableContactActivities count] > 0) {
                interval.intervalType = interval.intervalType | CareActivityIntervalTypeContactContinuous;
            }

            if ([mutableMotionActivities count] > 0) {
                interval.intervalType = interval.intervalType | CareActivityIntervalTypeMotionContinuous;
            }
        }
    }
    
    return intervals;
}

- (NSArray <CareActivityInterval *> *)configureEmptyCareActivityIntervalsBetweenStartDate:(NSDate *)startDate
                                                                                  endDate:(NSDate *)endDate
                                                                       intervalResolution:(CareCalendarUnit)intervalResolution
                                                                       intervalMultiplier:(NSInteger)intervalMutliplier {
    NSMutableArray *mutableIntervals = [[NSMutableArray alloc] init];
    
    if (startDate && endDate) {
        NSInteger intervalCount = [CareActivityManager careCalendarUnitCountBetweenStartDate:startDate
                                                                                     endDate:endDate
                                                                                calendarUnit:intervalResolution] / intervalMutliplier;
        for (int intervalIndex = 0; intervalIndex < intervalCount; intervalIndex++) {
            CareActivityInterval *interval = [[CareActivityInterval alloc] init];
            interval.intervalDate = [CareActivityManager startDateForIndex:intervalIndex
                                                       unit:intervalResolution
                                                 multiplier:intervalMutliplier
                                              referenceDate:startDate];
            
            interval.intervalType = CareActivityIntervalTypeNone;
            
            [mutableIntervals addObject:interval];
        }
    }
    
    return [NSArray arrayWithArray:mutableIntervals];
}

#pragma mark - Notification Handling

- (void)addObserversForChangeEventNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeEventNotificationReceived:)
                                                 name:[Model attributeChangedNotification:kCmdCareSubsystemListActivity]
                                               object:nil];
}

- (void)removeObserversForChangeEventNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Model attributeChangedNotification:kCmdCareSubsystemListActivity]
                                                  object:nil];
}

- (void)changeEventNotificationReceived:(NSNotification *)notification {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(careActivityManager:receivedChangeEventNotification:)]) {
        [self.delegate careActivityManager:self
           receivedChangeEventNotification:notification];
    }
}

#pragma mark - Care Section Searching

- (NSDictionary *)dictionaryForSection:(CareActivitySection *)section {
    NSDictionary *result = nil;
    
    if (section) {
        result = @{@"section" : section,
                   @"date" : section.startDate,
                   @"filters" : section.filterDevices};
    }
    
    return result;
}

- (void)addActivitySectionDictionary:(NSDictionary *)sectionDictionary {
    if (sectionDictionary) {
        NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithArray:self.activitySections];
        if ([mutableSections containsObject:sectionDictionary]) {
            // Remove replace to make sure that updated dicitonary is at index 0.
            [mutableSections removeObject:sectionDictionary];
            [mutableSections addObject:sectionDictionary];
        } else {
            [mutableSections addObject:sectionDictionary];
        }
        
        if ([mutableSections count] > kMaxRetainedSections) {
            [mutableSections removeObjectAtIndex:[mutableSections count] - 1];
        }
        self.activitySections = [NSArray arrayWithArray:mutableSections];
    }
}

- (CareActivitySection *)careActivitySectionForStartDate:(NSDate *)startDate
                                           filterDevices:(NSArray *)filterDevices {
    CareActivitySection *section = nil;
    
    NSArray *timestamps = @[[startDate dateByAddingTimeInterval:-1],
                            [startDate dateByAddingTimeInterval:1]];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", timestamps];
    NSArray *searchResult = [self.activitySections filteredArrayUsingPredicate:searchPredicate];
    
    
    for (NSDictionary *sectionInfo in searchResult) {
        if ([sectionInfo[@"filters"] count] == [filterDevices count]) {
            BOOL matches = NO;
            for (NSString *filterDevice in sectionInfo[@"filters"]) {
                matches = [filterDevices containsObject:filterDevice];
            }
            
            if (matches) {
                section = sectionInfo[@"section"];
                break;
            }
        }
    }
    
    return section;
}

#pragma mark - Data I/O

- (void)fetchActivityForSection:(CareActivitySection *)section
                     completion:(CareActivityFetchCompletion)completion {
    __block CareActivitySection *fetchSection = section;
    __block CareActivityFetchCompletion fetchCompletion = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (self.careSubsystem) {
            NSTimeInterval resolution = [CareActivityManager intervalForCalendarUnit:fetchSection.intervalResolution
                                                                           startDate:fetchSection.startDate
                                                                      unitMultiplier:fetchSection.resolutionMultipler];
            
            [self.careSubsystem careActivityListWithStart:fetchSection.startDate
                                                  withEnd:fetchSection.endDate
                                           withResolution:resolution
                                              withDevices:fetchSection.filterDevices].then(^ (NSDictionary *response) {
                __block NSArray *intervals = [self processActivityListResponse:response forSection:fetchSection];
                [fetchSection configureSectionWithIntervals:intervals];
                
                NSDictionary *sectionInfo = [self dictionaryForSection:fetchSection];
                [self addActivitySectionDictionary:sectionInfo];

                if (fetchCompletion) {
                    fetchCompletion(fetchSection, intervals);
                }
            });
        }
    });
}

- (NSArray <CareActivityInterval *> *)processActivityListResponse:(NSDictionary *)response forSection:(CareActivitySection *)section {
    NSArray *result = nil;
    
    if (response[@"intervals"]) {
        result = [self careActivityIntervalsFromResponseDictionary:response forSection:section];
    }
    
    return result;
}

- (void)advanceActivityToDate:(NSDate*)date
                    fromToken:(NSString*)token
                    inSection:(CareActivitySection *)section
                   completion:(CareActivityDetailFetchCompletion)completion {
  
    __block CareActivitySection *fetchSection = section;
    __block CareActivityDetailFetchCompletion fetchCompletion = completion;
    __block NSDate *startDate = date;
  
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (self.careSubsystem) {            
            [self.careSubsystem careActivityDetailsWithLimit:kMaxDetailsReturned
                                                   withToken:fetchSection.detailsToken
                                                 withDevices:fetchSection.filterDevices].then(^ (NSDictionary *response) {

                __block NSArray *eventInfo = [self processActivityDetailsResponse:response
                                                                       forSection:fetchSection];
              
                if (eventInfo) {
                    fetchSection.activityEvents = eventInfo;
                }
              
                // More data in history when token is non-nil
                if (response[@"nextToken"]) {
                    fetchSection.detailsToken = response[@"nextToken"];
              
                    // We've gone far enough back
                    if ([[NSDate dateFromTimeUuid:fetchSection.detailsToken] compare:startDate] != NSOrderedDescending) {
                        if (fetchCompletion) {
                            fetchCompletion(fetchSection, eventInfo);
                        }
                    }
                  
                    // Haven't yet reached our start date; recursively invoke this method for next page of data
                    else {
                        [self advanceActivityToDate:startDate fromToken:fetchSection.detailsToken inSection:fetchSection completion:fetchCompletion];
                    }
                }
              
                // No more data in history; either reached start date or can't go back any further.
                else if (fetchCompletion) {
                    fetchCompletion(fetchSection, eventInfo);
                }
            });
        }
    });
}

- (void)fetchActivityDetailForSection:(CareActivitySection *)section
                           completion:(CareActivityDetailFetchCompletion)completion {
    __block CareActivitySection *fetchSection = section;
    __block CareActivityDetailFetchCompletion fetchCompletion = completion;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (self.careSubsystem) {
        
            // Initial page of data requested; advance cursor (token) until it reaches the window
            // of data requested by the user.
            if (section.detailsToken == nil || [section.detailsToken isEqualToString:@""]) {
                [self advanceActivityToDate:section.endDate fromToken:section.detailsToken inSection:fetchSection completion:fetchCompletion];
            } else {

            // Token exists; fetch and return next page of data.
            [self.careSubsystem careActivityDetailsWithLimit:kMaxDetailsReturned
                                                   withToken:fetchSection.detailsToken
                                                 withDevices:fetchSection.filterDevices].then(^ (NSDictionary *response) {
                __block NSArray *eventInfo = [self processActivityDetailsResponse:response
                                                                       forSection:fetchSection];
                if (eventInfo) {
                    fetchSection.activityEvents = eventInfo;
                }
                
                if (response[@"nextToken"]) {
                    fetchSection.detailsToken = response[@"nextToken"];
                }
                
                if (fetchCompletion) {
                    fetchCompletion(fetchSection, eventInfo);
                }
            });
            }
        }
    });
}

- (NSArray <CareActivityInterval *> *)processActivityDetailsResponse:(NSDictionary *)response
                                                          forSection:(CareActivitySection *)section {
    NSMutableArray *mutableEvents = [[NSMutableArray alloc] initWithArray:section.activityEvents];
    
    for (NSDictionary *info in response[@"results"]) {
        NSDate *infoDate = [NSDate dateWithTimeIntervalSince1970:[info[@"timestamp"] doubleValue] / 1000.0];
        if ([infoDate compare:section.startDate] != NSOrderedAscending) {
            CareActivityEventInfo *eventInfo = [CareActivityEventInfo careEventWithInfo:info];
            if (eventInfo) {
                [mutableEvents addObject:eventInfo];
            }        
        }
    }
    return [NSArray arrayWithArray:mutableEvents];
}

#pragma mark - Convenience Class Methods

+ (NSDate *)startDateForIndex:(NSInteger)index
                         unit:(CareCalendarUnit)unit
                   multiplier:(NSInteger)multiplier
                referenceDate:(NSDate *)referenceDate {
    return [[NSCalendar currentCalendar] dateByAddingUnit:(NSCalendarUnit)unit
                                                    value:(index * multiplier)
                                                   toDate:referenceDate
                                                  options:0];
}

+ (NSDate *)endDateForIndex:(NSInteger)index
                       unit:(CareCalendarUnit)unit
                 multiplier:(NSInteger)multiplier
              referenceDate:(NSDate *)referenceDate {
    return [[NSCalendar currentCalendar] dateByAddingUnit:(NSCalendarUnit)unit
                                                    value:((index + 1) * multiplier)
                                                   toDate:referenceDate
                                                  options:0];
}

+ (NSInteger)careCalendarUnitCountBetweenStartDate:(NSDate *)start
                                           endDate:(NSDate *)end
                                      calendarUnit:(CareCalendarUnit)unit {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnit)unit
                                               fromDate:start
                                                 toDate:end
                                                options:0];
    NSInteger diff = [components valueForComponent:(NSCalendarUnit)unit];
    
    return diff;
}

+ (NSTimeInterval)intervalForCalendarUnit:(CareCalendarUnit)unit
                                startDate:(NSDate *)startDate
                           unitMultiplier:(NSInteger)multiplier {
    NSTimeInterval interval = 0;
    
    NSDate *intervalDate = [[NSCalendar currentCalendar] dateByAddingUnit:(NSCalendarUnit)unit
                                                                    value:multiplier
                                                                   toDate:startDate
                                                                  options:0];
    
    interval = fabs([intervalDate timeIntervalSinceDate:startDate]);
    
    return interval;
}

@end
