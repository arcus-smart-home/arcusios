//
//  TemperatureMath.h
//  i2app
//
//  Created by Arcus Team on 3/22/16.
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

/**
 * The TemperatureMath class is intended to be a utility class to centralize all
 * math related to temperatures.
 **/

@interface TemperatureMath : NSObject

/**
 * Returns the fahrenheit representation of a celsius value
 **/
+ (double)fahrenheitFromCelsiusValue:(double)celsiusValue;

/**
 * Returns the celsius representation of a fahrenheit value
 **/
+ (double)celsiusFromFahrenheitValue:(double)fahrenheitValue;



/**
 * Returns the rounded fahrenheit representation of a celsius value.
 * This method returns the accurate integral representation in the case
 * that the celsius value is the result of converting an integral
 * fahrenheit to celsius.
 **/
+ (NSInteger)roundedFarenheitFromCelsisuValue:(double)celsiusValue;

@end
