//
//  AddPlaceHomeInfoData.h
//  i2app
//
//  Created by Arcus Team on 5/9/16.
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

@interface AddPlaceHomeInfoData : NSObject

@property (strong, nonatomic) NSString *homeName;
@property (strong, nonatomic) NSString *addressOne;
@property (strong, nonatomic) NSString *addressTwo;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *timeZoneName;
@property (strong, nonatomic) NSString *timeZoneID;
@property (strong, nonatomic) NSNumber *timeZoneOffset;
@property (assign, nonatomic) BOOL      timeZoneUsesDST;
@property (strong, nonatomic) NSDictionary *smartyStreetsInfo;

@property (strong, nonatomic) UIImage *homeImage;

@end
