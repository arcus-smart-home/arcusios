//
//  DashBoardHistoryManager.h
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

#import <Foundation/Foundation.h>

@interface DashBoardHistoryManager : NSObject

#pragma mark - Properties

/**
 * The start of the day (midnight) of the day we are viewing history of, an implied End Date is 24 
 * hours later
 */
@property (readonly, atomic) NSDate *_Nonnull filterDay;

/**
 * The device to fetch history for, if Nil fetch all history for a place
 */
@property (readonly, atomic) NSString *_Nullable filterDeviceAddress;

/**
 * The maximum date to fetch history for, it nil use distantPast
 */
@property (nonatomic, strong) NSDate *_Nullable maximumFilterDate;

/**
 * Singleton Instance
 */
+ (DashBoardHistoryManager * _Nonnull)shareInstance;

/** 
 * The history data to present
 */
@property (readonly, atomic) NSMutableArray *_Nonnull historiesList;

#pragma mark - Functions

/** Returns true if the requested filters can continue paging
 * Returns false when all data has been loaded
 */
- (BOOL)hasMorePages;

/** 
 * Public interface to set the filters, `filterDay` and `filterDeviceAddress`
 * Returns true if filters changed, the pagination will be reset on a change automatically
 */
- (BOOL)setFilterDay:(NSDate * _Nonnull)toDate device:(NSString * _Nullable)deviceAddress;

/** 
 *Request the next page of history data, returns a promise which contains the historiesList property
 */
- (PMKPromise * _Nonnull)getHistoriesMatchedFilter;

@end
