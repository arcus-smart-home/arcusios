//
//  DashBoardHistoryManager.m
//  i2app
//
//  Created by Arcus Team on 8/17/15.
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
#import "DashBoardHistoryManager.h"
#import "NSDate+Convert.h"
#import "DashboardHistoryListViewController.h"

#import "PlaceCapability.h"


#import "DeviceCapability.h"

int kDefaultNumberHistoryEntries = 10;

@interface DashBoardHistoryManager ()

@property (atomic, strong) NSDate *_Nonnull filterDay;
@property (atomic, strong) NSString *_Nullable filterDeviceAddress;
@property (atomic, strong) NSMutableArray *_Nonnull historiesList;
@property (atomic, strong) NSDate *_Nullable lastDateLoaded;
@property (atomic, strong) NSString *_Nonnull nextLogEntryToken;
@property BOOL isRunOutOfData;

@end

@implementation DashBoardHistoryManager

+ (DashBoardHistoryManager *)shareInstance {
    static dispatch_once_t onceToken;
    static DashBoardHistoryManager *_manager = nil;
    dispatch_once(&onceToken, ^{
        _manager = [[DashBoardHistoryManager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.historiesList = [[NSMutableArray alloc] initWithCapacity:kDefaultNumberHistoryEntries];
        self.lastDateLoaded = nil;
        self.maximumFilterDate = [NSDate distantFuture];
        self.nextLogEntryToken = @"";
        self.isRunOutOfData = false;
        self.filterDay = [[NSDate new] toDay];
        self.filterDeviceAddress = nil;
    }
    return self;
}

#pragma mark - public methods

- (void)setMaximumFilterDate:(NSDate*) date {
    _maximumFilterDate = date != nil ? date : [NSDate distantPast];
}

- (BOOL)setFilterDay:(NSDate * _Nonnull)toDate device:(NSString * _Nullable)deviceAddress {
    BOOL didChange = false;
    if ([self.filterDay compare:[toDate toDay]] != NSOrderedSame) {
        didChange = true;
        self.filterDay = [toDate toDay];
    }
    if (![self.filterDeviceAddress isEqualToString:deviceAddress]){
        didChange = true;
        self.filterDeviceAddress = deviceAddress;
    }
    if (didChange){
        [self clearCache];
    }
    return didChange;
}

- (void)clearCache {
    [self.historiesList removeAllObjects];
    self.nextLogEntryToken = @"";
    self.lastDateLoaded = nil;
    self.isRunOutOfData = false;
}

- (BOOL)hasMorePages {
    return !self.isRunOutOfData;
}

- (PMKPromise * _Nonnull)getHistoriesMatchedFilter {
    if([self.nextLogEntryToken isEqualToString:@""]) {
        self.nextLogEntryToken = [self tokenFromFilterDate];
    }
    if (self.isRunOutOfData){
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(self.historiesList);
        }];
    }
    else if (self.filterDeviceAddress) {
        return [self loadDeviceHistory];
    }
    else {
        return [self loadPlaceHistory];
    }
}
#pragma mark - Helpers

- (void)addWithResults:(NSArray *)results {
    NSUInteger appendedCount = 0;

    for (NSDictionary *result in results) {
        Model *model = [[Model alloc] initWithAttributes:result];
        NSNumber *timeStamp = (NSNumber *)[model getAttribute:@"timestamp"];
        NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:(timeStamp.doubleValue / 1000)];
        if ([eventTime isSameDayWith:self.filterDay] &&
            [eventTime compare:self.maximumFilterDate] != NSOrderedAscending) {
            NSMutableArray *group = self.historiesList;
            self.lastDateLoaded = eventTime;
            HistoryModel *addingModel = [self historyModelWithResult:model];
            [group addObject:addingModel];
            appendedCount++;
        }
    }
    
    if (results.count > 0 && appendedCount == results.count && results.count >= kDefaultNumberHistoryEntries) {
        self.isRunOutOfData = false;
    } else {
        self.isRunOutOfData = true;
    }
}

- (HistoryModel *)historyModelWithResult:(Model *)model {
    NSString *name = (NSString *)[model getAttribute:@"subjectName"];
    NSString *longMessage = (NSString *)[model getAttribute:@"longMessage"];
    NSNumber *timeStamp = (NSNumber *)[model getAttribute:@"timestamp"];
    return [HistoryModel create:timeStamp deviceName:name eventName: longMessage];
}

- (NSString *_Nonnull)tokenFromFilterDate {
    NSDate *timeForToken;
    NSDate *now = [NSDate new];
    if ([self.filterDay isSameDayWith:now]) {
        timeForToken = now;
    } else {
        timeForToken = [self convertDateToNextMidnight:self.filterDay];
    }
    return [timeForToken toNextToken];
}

- (NSDate *_Nonnull)convertDateToNextMidnight:(NSDate *_Nonnull)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:[components day] + 1];
    
    return [calendar dateFromComponents:components];
}

#pragma mark - Promises

- (PMKPromise *)loadPlaceHistory {
    return [PlaceCapability listHistoryEntriesWithLimit:kDefaultNumberHistoryEntries
                                              withToken:self.nextLogEntryToken
                                                onModel:[[CorneaHolder shared] settings].currentPlace]
    .thenInBackground(^(PlaceListHistoryEntriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSArray *results = [response getResults];
            [self addWithResults:results];
            self.nextLogEntryToken = [response getNextToken];
            fulfill(self.historiesList);
        }];
    });
}

- (PMKPromise *)loadDeviceHistory {
    DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.filterDeviceAddress];
    return [DeviceCapability listHistoryEntriesWithLimit:kDefaultNumberHistoryEntries
                                               withToken:self.nextLogEntryToken
                                                 onModel:deviceModel]
    .thenInBackground(^(DeviceListHistoryEntriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSArray *results = [response getResults];
            [self addWithResults:results];
            self.nextLogEntryToken = response.getNextToken;
            fulfill(self.historiesList);
        }];
    });
}

@end
