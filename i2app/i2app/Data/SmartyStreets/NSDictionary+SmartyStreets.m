//
//  NSDictionary+SmartyStreets.m
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

#import <i2app-Swift.h>
#import "NSDictionary+SmartyStreets.h"

@implementation NSDictionary (SmartyStreets)

NSString *const kSmartyStreetsLatitudeKey = @"metadata/latitude";
NSString *const kSmartyStreetsLongitudeKey = @"metadata/longitude";

NSString *const kSmartyStreetsTimeZoneKey = @"metadata/time_zone";
NSString *const kSmartyStreetsUTCOffsetKey = @"metadata/utc_offset";
NSString *const kSmartyStreetsDoesObserveDaylightSavingsKey = @"metadata/dst";

#pragma mark - Location
- (BOOL)hasSmartyStreetsLatitude {
    id latObject = [self objectForKey:kSmartyStreetsLatitudeKey];
    return latObject != nil && ![[NSNull null] isEqual:latObject];
}

- (double)getSmartyStreetsLatitude {
    NSString *latString = [self objectForKey:kSmartyStreetsLatitudeKey];
    if (latString) {
        return latString.doubleValue;
    }
    return 0.0;
}

- (BOOL)hasSmartyStreetsLongitude {
    id longObject = [self objectForKey:kSmartyStreetsLongitudeKey];
    return longObject != nil && ![[NSNull null] isEqual:longObject];
}

- (double)getSmartyStreetsLongitude {
    NSString *longitudeString = [self objectForKey:kSmartyStreetsLongitudeKey];
    if (longitudeString) {
        return longitudeString.doubleValue;
    }
    return 0.0;
}

#pragma mark - Time
- (NSString *)getSmartyStreetsTimeZone {
    return [self objectForKey:kSmartyStreetsTimeZoneKey];
}

- (BOOL)hasSmartyStreetsUTCOffset {
    id utcOffsetObject = [self objectForKey:kSmartyStreetsUTCOffsetKey];
    return utcOffsetObject != nil && ![[NSNull null] isEqual:utcOffsetObject];
}

- (double)getSmartyStreetsUTCOffset {
    NSString *utcOffsetString = [self objectForKey:kSmartyStreetsUTCOffsetKey];
    if (utcOffsetString) {
        return utcOffsetString.doubleValue;
    }
    return 0.0;
}

- (BOOL)hasSmartyStreetsDoesObserveDaylightSavingsInfo {
    id observeDSTObject = [self objectForKey:kSmartyStreetsDoesObserveDaylightSavingsKey];
    return observeDSTObject != nil && ![[NSNull null] isEqual:observeDSTObject];
}

- (BOOL)getSmartyStreetsDoesObserveDaylightSavings {
    NSString *doesObserveString = [self objectForKey:kSmartyStreetsDoesObserveDaylightSavingsKey];
    if (doesObserveString) {
        return doesObserveString.boolValue;
    }
    return false;
}

@end
