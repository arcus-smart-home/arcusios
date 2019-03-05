//
//  CareActivityEventInfo.m
//  i2app
//
//  Created by Arcus Team on 2/10/16.
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
#import "CareActivityEventInfo.h"

@implementation CareActivityEventInfo

+ (CareActivityEventInfo *)careEventWithInfo:(NSDictionary *)info {
    CareActivityEventInfo *eventInfo = [[CareActivityEventInfo alloc] init];
    
    if (info[@"timestamp"]) {
        eventInfo.eventDate = [NSDate dateWithTimeIntervalSince1970:[info[@"timestamp"] doubleValue] / 1000.0];
    }
    
    if (info[@"key"]) {
        eventInfo.eventKey = info[@"key"];
    }
    
    if (info[@"subjectName"]) {
        eventInfo.eventTitle = info[@"subjectName"];
    }
    
    if (info[@"longMessage"]) {
        eventInfo.eventDescriptionLong = info[@"longMessage"];
    }

    if (info[@"shortMessage"]) {
        eventInfo.eventDescriptionShort = info[@"shortMessage"];
    }
    
    if (info[@"subjectAddress"]) {
        eventInfo.deviceAddress = info[@"subjectAddress"];
    }

    return eventInfo;
}

@end
