//
// Created by Arcus Team on 2/4/16.
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
#import "DeviceEventStore.h"


@implementation DeviceEventStore {
    /**
     * "deviceId" : {"attribute1":12345, "attribute2":12345}
     */
    NSMutableDictionary *devices;
}

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static DeviceEventStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        devices = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (NSMutableDictionary*)getEventsForDeviceId:(NSString *)deviceId {
    return [devices objectForKey:deviceId];
}

- (int)count:(NSString *)deviceId {
    NSMutableDictionary *attributes = [self getEventsForDeviceId:deviceId];

    if (attributes == nil)
        return 0;

    return (int)attributes.count;
}

- (nonnull NSArray*)getEventAttributes:(NSString *)deviceId {
    NSMutableDictionary *attributes = [self getEventsForDeviceId:deviceId];

    if (attributes != nil) {
        return [attributes allKeys];
    }

    return @[];
}

- (NSDate*)getEventForAttribute:(NSString *)attribute deviceId:(NSString *)deviceId {
    if ([self count:deviceId] > 0) {
        NSMutableDictionary *attributes = [self getEventsForDeviceId:deviceId];

        NSNumber *value = [attributes objectForKey:attribute];

        if (value != nil)
            return [[NSDate alloc] initWithTimeIntervalSince1970:[value doubleValue]];
    }

    return nil;
}

- (BOOL)hasEvents:(NSString *)deviceId {
    return [self count:deviceId] > 0 ? YES : NO;
}

- (BOOL)hasEventForAttribute:(NSString *)attribute deviceId:(NSString *)deviceId {
    return [self getEventForAttribute:attribute deviceId:deviceId] == nil ? NO : YES;
}

- (void)addNewEventForAttribute:(NSString *)attribute deviceId:(NSString *)deviceId {
    NSMutableDictionary *attributes = [self getEventsForDeviceId:deviceId];

    if (attributes == nil) {
        attributes = [[NSMutableDictionary alloc] init];
        [devices setObject:attributes forKey:deviceId];
    }

    [attributes setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:attribute];
}

- (void)removeEventForAttribute:(NSString *)attribute deviceId:(NSString *)deviceId {
    if ([self count:deviceId] > 0) {
        NSMutableDictionary *attributes = [self getEventsForDeviceId:deviceId];

        [attributes removeObjectForKey:attribute];
    }
}

- (void)clearEventsForDeviceId:(NSString *)deviceId {
    [devices removeObjectForKey:deviceId];
}

- (void)clearDevices {
    [devices removeAllObjects];
}

- (void)clearStaleEventsWithDuration:(NSTimeInterval)seconds deviceId:(NSString *)deviceId {
    NSMutableDictionary *events = [self getEventsForDeviceId:deviceId];

    for (NSString *attribute in [events allKeys]) {
        NSNumber *eventTime = [events objectForKey:attribute];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

        if ([eventTime doubleValue] + seconds <= now ) {
            [events removeObjectForKey:attribute];
        }
    }
}

@end
