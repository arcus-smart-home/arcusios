//
//  CareActivityEventInfo.h
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

#import <Foundation/Foundation.h>

@interface CareActivityEventInfo : NSObject

/**
 * Represents the point in time that the event occurred.
 **/
@property (nonatomic, strong) NSDate *eventDate;

/**
 * String key that can be used to identify event type.
 **/
@property (nonatomic, strong) NSString *eventKey;

/**
 * String title of the event.
 **/
@property (nonatomic, strong) NSString *eventTitle;

/**
 * Long description of the event.
 **/
@property (nonatomic, strong) NSString *eventDescriptionLong;

/**
 * Short description of the event.
 **/
@property (nonatomic, strong) NSString *eventDescriptionShort;

/**
 * Address of the device of the event.
 **/
@property (nonatomic, strong) NSString *deviceAddress;

/**
 * Constructor method used to configure an instance of the object from a dictionary.
 *
 * @params: Dictionary of key/values used to instantiate CareActivityEventInfo.
 * @return: CareActivityEventInfo configured by the received dictionary.
 **/
+ (CareActivityEventInfo *)careEventWithInfo:(NSDictionary *)info;

@end
