//
//  NSDictionary+SmartyStreets.h
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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

@interface NSDictionary (SmartyStreets)

extern NSString *const kSmartyStreetsLatitudeKey;
extern NSString *const kSmartyStreetsLongitudeKey;

extern NSString *const kSmartyStreetsTimeZoneKey;
extern NSString *const kSmartyStreetsUTCOffsetKey;
extern NSString *const kSmartyStreetsDoesObserveDaylightSavingsKey;

#pragma mark - Location

- (BOOL)hasSmartyStreetsLatitude;
- (double)getSmartyStreetsLatitude;
- (BOOL)hasSmartyStreetsLongitude;
- (double)getSmartyStreetsLongitude;

#pragma mark - Time
//Returns nil as the default value
- (NSString *)getSmartyStreetsTimeZone;
- (BOOL)hasSmartyStreetsUTCOffset;
- (double)getSmartyStreetsUTCOffset;
- (BOOL)hasSmartyStreetsDoesObserveDaylightSavingsInfo;
- (BOOL)getSmartyStreetsDoesObserveDaylightSavings;

@end
