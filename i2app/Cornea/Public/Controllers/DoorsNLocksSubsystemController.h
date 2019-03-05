//
//  DoorsNLocksSubsystemController.h
//  Pods
//
//  Created by Arcus Team on 9/16/15.
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
#import "SubsystemsController.h"

extern NSString *const kPetToken;
extern NSString const *kPetTokenId;

@class PMKPromise;

 
@interface DoorsNLocksSubsystemController : NSObject <SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, assign, readonly) NSArray *allDoorLockDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *unlockedDoorLockDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *OfflineDoorLockDeviceAddresses;

@property (nonatomic, assign, readonly) NSArray *allGarageDoorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *openedGarageDoorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *OfflineGarageDoorDeviceAddresses;

@property (nonatomic, assign, readonly) NSArray *allContactSensorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *openedContactSensorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *OfflineContactSensorDeviceAddresses;

@property (nonatomic, assign, readonly) NSArray *allPetDoorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *openedPetDoorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *autoPetDoorDeviceAddresses;
@property (nonatomic, assign, readonly) NSArray *OfflinePetDoorDeviceAddresses;

@property (nonatomic, assign, readonly) NSDictionary *authorizationByLockPersons;
@property (nonatomic, assign, readonly) NSArray *allPeople;

@property (nonatomic, assign, readonly) BOOL hasDevices;
@property (nonatomic, assign, readonly) BOOL allDevicesAreClosed;

- (void)saveAuthorization:(NSArray *)list device:(DeviceModel *)deviceModel complete:(void(^)(void))complete;

- (BOOL)getChimeConfigFromModel:(DeviceModel *)deviceModel;
- (void)setChimeConfiguration:(BOOL)enable onModel:(DeviceModel *)deviceModel;

- (BOOL)hasDeviceWithAddress:(NSString *)address;

#pragma mark - Pet Door
+ (PMKPromise *)setPetDoorLockStateToAutoForModel:(DeviceModel *)deviceModel;
+ (PMKPromise *)setPetDoorLockStateToLockedForModel:(DeviceModel *)deviceModel;
+ (PMKPromise *)setPetDoorLockStateToUnlockedForModel:(DeviceModel *)deviceModel;

+ (BOOL)getLastPetDoorEntranceParametersForDevice:(DeviceModel *)deviceModel
                                          petName:(NSString **)petName
                                        eventTime:(NSDate **)eventDate;
+ (NSDictionary *)getPetTokenNames:(DeviceModel *)deviceModel;

+ (NSString *)getPetTokenForTokenId:(int)tokenId onPetModel:(DeviceModel *)deviceModel;
+ (int)getPetTokenIdForTokenKey:(NSString *)tokenKey onPetModel:(DeviceModel *)deviceModel;
+ (PMKPromise *)renamePetToken:(NSString *)name withPetToken:(NSString *)petToken onPetModel:(DeviceModel *)deviceModel;
+ (PMKPromise *)removePetToken:(NSString *)tokenKey onPetModel:(DeviceModel *)deviceModel;

@end
