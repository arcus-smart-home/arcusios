//
//  CareActivityInterval.h
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

#import <Foundation/Foundation.h>
#import "ActivityGraphView.h"

typedef NS_OPTIONS(NSInteger, CareActivityIntervalType) {
    CareActivityIntervalTypeNone                = 0,
    CareActivityIntervalTypeGeneral             = 1 << 0,
    CareActivityIntervalTypeMotionStart         = 1 << 1,
    CareActivityIntervalTypeMotionContinuous    = 1 << 2,
    CareActivityIntervalTypeMotionStop          = 1 << 3,
    CareActivityIntervalTypeContactStart        = 1 << 4,
    CareActivityIntervalTypeContactContinuous   = 1 << 5,
    CareActivityIntervalTypeContactStop         = 1 << 6
};

@interface CareActivityInterval : NSObject  <ActivityGraphViewUnitProtocol>

/**
 * Used by ActivityGraphViewUnitProtocol to determine the type of line to be
 * drawn in ActivityGraphView.
 **/
@property (nonatomic, assign) ActivityGraphUnitType activityGraphUnitType;

/**
 * Used by ActivityGraphViewUnitProtocol to determine the type of line to be
 * drawn in ActivityGraphView.
 **/
@property (nonatomic, strong) UIColor *lineColor;

/**
 * Used to determine the type of Activity contained in interval.
 **/
@property (nonatomic, assign) CareActivityIntervalType intervalType;

/**
 * Represents the point in time that the Interval contains activeDeviceIds for.
 **/
@property (nonatomic, strong) NSDate *intervalDate;

/**
 * Array of Dictionaries representing device address & reported activity for 
 * the current activity interval.
 **/
@property (nonatomic, strong) NSArray *activeDeviceInfo;

/**
 * BOOL used to indicate whether of not the interval is being used as a placeholder
 * to indicate continuous activity values.  Setting to YES is necessary to prevent
 * placeholder interval from being reported as a CareActivityEvent;
 **/
@property (nonatomic, assign) BOOL continuousPlaceHolder;

/**
 * Constructor method used to configure an instance of the object from a dictionary.
 * 
 * @params: Dictionary of key/values used to instantiate CareActivityInterval.
 * @return: CareActivityInterval configured by the received dictionary.
 **/
+ (CareActivityInterval *)intervalWithInfo:(NSDictionary *)info;

/**
 * Method used to return an array of dictionaries from activeDeviceInfo for
 * Contact Sensors.  Used to determine whether or not to
 * display continuous activity on the graph.
 *
 * @return: CareActivityInterval configured by the received dictionary.
 **/
- (NSArray *)deviceInfoForContactActivity;

/**
 * Method used to return an array of dictionaries from activeDeviceInfo for
 * Motion & Camera Motion Sensors.  Used to determine whether or not to
 * display continuous activity on the graph.
 *
 * @return: CareActivityInterval configured by the received dictionary.
 **/
- (NSArray *)deviceInfoForMotionActivity;

/**
 * Convenience method to determine if CareActivityIntervalType is included in 
 * intervalType
 *
 * @return: BOOL indicating if intervalType contains type.
 **/
- (BOOL)intervalTypeContainsType:(CareActivityIntervalType)type;

@end
