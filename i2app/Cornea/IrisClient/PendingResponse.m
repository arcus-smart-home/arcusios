//
//  PendingResponse.m
//  i2app
//
//  Created by Arcus Team on 10/13/16.
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
#import "PendingResponse.h"
#import "ClientRequest.h"

@interface PendingResponse ()

- (NSString *)generateUUID;

@end

@implementation PendingResponse

#pragma mark - Life Cycle
- (instancetype)initWithPromise:(SettablePromise *)promise withTimeout:(NSInteger)timeoutMs {

    if (self = [super init]) {
        timeoutMs = timeoutMs > 0 ? [[NSDate date] timeIntervalSince1970] * 1000 + timeoutMs : [[NSDate date] timeIntervalSince1970] * 1000 + 30000;
        _expirationTimestamp = timeoutMs;
        _promise = promise;
        _correlationId = [self generateUUID];
    }
    return self;
}

- (instancetype)initWithExpirationTimestamp:(long)expirationTimestamp withPromise:(SettablePromise *)promise {

    if (self = [super init]) {
        _expirationTimestamp = expirationTimestamp;
        _promise = promise;
        _correlationId = [self generateUUID];
    }
    return self;
}

- (NSString *)generateUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);

    NSString *uuidValue = (__bridge_transfer NSString *)uuidStringRef;
    uuidValue = [uuidValue lowercaseString];
    uuidValue = [uuidValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuidValue;
}

@end
