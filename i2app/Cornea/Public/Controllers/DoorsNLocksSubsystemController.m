//
//  DoorsNLocksSubsystemController.m
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

#import <i2app-Swift.h>
#import "DoorsNLocksSubsystemController.h"
#import "DoorsNLocksSubsystemCapability.h"
#import "PetDoorCapability.h"
#import "PetTokenCapability.h"
#import "PetDoorCapability.h"
#import "Capability.h"


#import <PromiseKit/PromiseKit.h>

NSString *const kPetToken = @"PetToken";
NSString const *kPetTokenId = @"tokenId";

@interface DoorsNLocksSubsystemController ()

@end

@implementation DoorsNLocksSubsystemController {
}

@synthesize subsystemModel;
@synthesize numberOfDevices;

@dynamic allDeviceIds;

@dynamic allDoorLockDeviceAddresses;
@dynamic unlockedDoorLockDeviceAddresses;
@dynamic OfflineDoorLockDeviceAddresses;

@dynamic allGarageDoorDeviceAddresses;
@dynamic openedGarageDoorDeviceAddresses;
@dynamic OfflineGarageDoorDeviceAddresses;

@dynamic allContactSensorDeviceAddresses;
@dynamic openedContactSensorDeviceAddresses;
@dynamic OfflineContactSensorDeviceAddresses;

@dynamic allPetDoorDeviceAddresses;
@dynamic openedPetDoorDeviceAddresses;
@dynamic autoPetDoorDeviceAddresses;
@dynamic OfflinePetDoorDeviceAddresses;

@dynamic hasDevices;
@dynamic allDevicesAreClosed;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

#pragma mark - Creating and Sorting Device Array
- (NSArray *)getAllDevicesSorted {
    NSArray *lockDeviceAddresses = [self getModelSourcesFromSourcesSortedAlphabetically:self.allDoorLockDeviceAddresses];
    
    NSArray *garageDoorDeviceAddresses = [self getModelSourcesFromSourcesSortedAlphabetically:self.allGarageDoorDeviceAddresses];
    
    NSArray *petDoorAddresses = [self getModelSourcesFromSourcesSortedAlphabetically:self.allPetDoorDeviceAddresses];
    
    NSArray *contactSensorAddresses = [self getModelSourcesFromSourcesSortedAlphabetically:self.allContactSensorDeviceAddresses];
    
    
    NSMutableArray *allDevices = lockDeviceAddresses.mutableCopy;
    [allDevices addObjectsFromArray:garageDoorDeviceAddresses];
    [allDevices addObjectsFromArray:petDoorAddresses];
    [allDevices addObjectsFromArray:contactSensorAddresses];
    
    return allDevices.copy;
}

// Get an array of model Ids sorted alphabetically based on the Model Name
- (NSArray *)getModelSourcesFromSourcesSortedAlphabetically:(NSArray *)sources {

  NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:sources.count];
  for (NSString *source in sources) {
    Model *model = [[[CorneaHolder shared] modelCache] fetchModel:source];
    if (model) {
      [models addObject:model];
    }
  }

  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [models sortUsingDescriptors:@[sort]];

  NSMutableArray *sortedModelIds = [[NSMutableArray alloc] initWithCapacity:models.count];

  for (Model *model in models) {
    [sortedModelIds addObject:model.modelId];
  }
  return sortedModelIds.copy;
}

#pragma mark - Dynamic Properties
- (NSArray *)allDeviceIds {
    return [self getAllDevicesSorted];
}

- (int)numberOfDevices {
    return (int)(self.allDoorLockDeviceAddresses.count +
                 self.allGarageDoorDeviceAddresses.count +
                 self.allContactSensorDeviceAddresses.count +
                 self.allPetDoorDeviceAddresses.count);
}

- (NSArray *)allDoorLockDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getLockDevicesFromModel:self.subsystemModel];
}

- (NSArray *)unlockedDoorLockDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getUnlockedLocksFromModel:self.subsystemModel];
}

- (NSArray *)OfflineDoorLockDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOfflineLocksFromModel:self.subsystemModel];
}

- (NSArray *)allGarageDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getMotorizedDoorDevicesFromModel:self.subsystemModel];
}

- (NSArray *)openedGarageDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOpenMotorizedDoorsFromModel:self.subsystemModel];
}

- (NSArray *)OfflineGarageDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOfflineMotorizedDoorsFromModel:self.subsystemModel];
}

- (NSArray *)allContactSensorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getContactSensorDevicesFromModel:self.subsystemModel];
}

- (NSArray *)openedContactSensorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOpenContactSensorsFromModel:self.subsystemModel];
}

- (NSArray *)OfflineContactSensorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOfflineContactSensorsFromModel:self.subsystemModel];
}

- (NSArray *)allPetDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getPetDoorDevicesFromModel:self.subsystemModel];
}

- (NSArray *)autoPetDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getAutoPetDoorsFromModel:self.subsystemModel];
}

- (NSArray *)openedPetDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getUnlockedPetDoorsFromModel:self.subsystemModel];
}

- (NSArray *)OfflinePetDoorDeviceAddresses {
    return [DoorsNLocksSubsystemCapability getOfflinePetDoorsFromModel:self.subsystemModel];
}

- (BOOL)allDevicesAreClosed {
    return ([self openedContactSensorDeviceAddresses].count == 0 &&
            [self unlockedDoorLockDeviceAddresses].count == 0 &&
            [self openedGarageDoorDeviceAddresses].count == 0 &&
            [self openedPetDoorDeviceAddresses].count == 0);
}

- (BOOL)hasOnlyClosedLocks {
    if (self.allDoorLockDeviceAddresses.count == 0) {
        return NO;
    }
    if (self.allGarageDoorDeviceAddresses.count == 0 ||
        self.allContactSensorDeviceAddresses.count == 0) {
        if (self.OfflineDoorLockDeviceAddresses.count == 0) {
            return self.unlockedDoorLockDeviceAddresses.count == 0;
        }
        return NO;
    }
    return NO;
}

- (NSArray *)allPeople {
    return [DoorsNLocksSubsystemCapability getAllPeopleFromModel:self.subsystemModel];
}

- (BOOL)hasDevices {
    return (self.allDeviceIds.count > 0);
}

- (NSDictionary *)authorizationByLockPersons {
    return [DoorsNLocksSubsystemCapability getAuthorizationByLockFromModel:self.subsystemModel];
}

- (void)saveAuthorization:(NSArray *)list device:(DeviceModel *)deviceModel complete:(void(^)(void))complete {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemCapability authorizePeopleWithDevice:deviceModel.address
                                        withOperations:list
                                        onModel:self.subsystemModel].then(^
                                        {
                                            complete();
                                        });
    });
}

- (BOOL)getChimeConfigFromModel:(DeviceModel *)deviceModel {
    NSArray *chimeArray = [DoorsNLocksSubsystemCapability getChimeConfigFromModel:self.subsystemModel];
    
    for (NSDictionary *device in chimeArray) {
        
        if ([deviceModel.address isEqualToString:device[@"device"]]) {
            return ((NSNumber *)device[@"enabled"]).boolValue;
        }
    }
    return NO;}

//[ { “device”: <addr>, “enabled”: <boolean> }, {“device”: <addr2>, “enabled”: <boolean> } ]
- (void)setChimeConfiguration:(BOOL)enable onModel:(DeviceModel *)deviceModel {
    NSMutableArray *newConfiguration = [DoorsNLocksSubsystemCapability getChimeConfigFromModel:self.subsystemModel].mutableCopy;
    //remove the old setting
    [newConfiguration filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return ![[object objectForKey:@"device"] isEqualToString:deviceModel.address];
        
    }]];
    //add new setting
    [newConfiguration addObject:@{@"device": deviceModel.address, @"enabled":@(enable)}];
    
    [DoorsNLocksSubsystemCapability setChimeConfig:newConfiguration onModel:self.subsystemModel];
    [self.subsystemModel commit];
}

- (BOOL)hasDeviceWithAddress:(NSString *)address {
    for (NSString *dnlId in self.allDeviceIds) {
        if([dnlId isEqualToString:address]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Pet Door
+ (PMKPromise *)setPetDoorLockStateToAutoForModel:(DeviceModel *)deviceModel {
    [PetDoorCapability setLockstate:kEnumPetDoorLockstateAUTO onModel:deviceModel];
    return [deviceModel commit].thenInBackground(^ {
        return [deviceModel refresh];
    });
}

+ (PMKPromise *)setPetDoorLockStateToLockedForModel:(DeviceModel *)deviceModel {
    [PetDoorCapability setLockstate:kEnumPetDoorLockstateLOCKED onModel:deviceModel];
    return [deviceModel commit].thenInBackground(^ {
        return [deviceModel refresh];
    });
}

+ (PMKPromise *)setPetDoorLockStateToUnlockedForModel:(DeviceModel *)deviceModel {
    [PetDoorCapability setLockstate:kEnumPetDoorLockstateUNLOCKED onModel:deviceModel];
    return [deviceModel commit].thenInBackground(^ {
        return [deviceModel refresh];
    });
}

+ (BOOL)getLastPetDoorEntranceParametersForDevice:(DeviceModel *)deviceModel
                                          petName:(NSString **)petName
                                        eventTime:(NSDate **)eventDate {
    // Extract tokens
    NSArray *tokens = [Capability instancesForModel:deviceModel];
    
    // Walk through all tokens and get the token details of the token that has the
    // most recent kAttrPetDoorLastaccesstime
    NSNumber *lastAccessTime = [deviceModel getAttribute:kAttrPetDoorLastaccesstime];
    if (!lastAccessTime || [lastAccessTime isEqual:[NSNull null]]) {
        // the pet door has not been accessed so far
        *petName = @"";
        *eventDate = nil;
        
        return NO;
    }
    NSString *multiInstanceKey;
    NSString *mostRecentToken = nil;
    for (NSString *token in tokens) {
        NSString *multiInstanceKey = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenLastAccessTime, token];
        NSNumber *instanceLastAccessTime = [deviceModel getAttribute:multiInstanceKey];
        if (instanceLastAccessTime && ![instanceLastAccessTime isEqual:[NSNull null]]) {
            if (instanceLastAccessTime.doubleValue == lastAccessTime.doubleValue) {
                mostRecentToken = token;
                break;
            }
        }
    }
    if (mostRecentToken.length > 0) {
        *eventDate = [NSDate dateWithTimeIntervalSince1970:(lastAccessTime.doubleValue / 1000)];
        multiInstanceKey = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenPetName, mostRecentToken];
        NSString *name = [deviceModel getAttribute:multiInstanceKey];
        if (!name || ![name isEqual:[NSNull null]]) {
            *petName = @"Pet";
        }
        return YES;
    }
    *petName = @"";
    *eventDate = nil;
    
    return NO;
}

+ (NSDictionary *)getPetTokenNames:(DeviceModel *)deviceModel {
    NSArray *tokens = [Capability instancesForModel:deviceModel];
    NSMutableDictionary *names = [[NSMutableDictionary alloc] initWithCapacity:tokens.count];
    
    NSString *multiInstanceId;
    NSNumber *tokenId;
    NSString *name;
    for (NSString *token in tokens) {
        NSMutableDictionary <NSString *, NSString *> *params = [[NSMutableDictionary alloc] initWithCapacity:3];

        multiInstanceId = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenPaired, token];
        if (((NSNumber *)[deviceModel getAttribute:multiInstanceId]).boolValue) {
            multiInstanceId = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenTokenId, token];
            tokenId = [deviceModel getAttribute:multiInstanceId];
            
            if (tokenId.intValue != -1) {
                //params[kAttrPetTokenTokenId] = tokenId;
                multiInstanceId = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenPetName, token];
                name = [deviceModel getAttribute:multiInstanceId];
                if (!name || [name isEqual:[NSNull null]] || name.length == 0) {
                    name = @"UNNAMED SMART KEY";
                }
                params[kAttrPetTokenPetName] =  name;
                params[kPetToken]= token;
                names[token] = params;
            }
        }
    }
    return names.copy;
}

+ (NSString *)getPetTokenForTokenId:(int)tokenId onPetModel:(DeviceModel *)deviceModel {
    NSArray *tokens = [Capability instancesForModel:deviceModel];
    
    NSString *multiInstanceId;
    for (NSString *token in tokens) {
        multiInstanceId = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenTokenId, token];
        NSNumber *currId = [deviceModel getAttribute:multiInstanceId];
        
        if (currId && ![currId isEqual:[NSNull null]]) {
            if (currId.intValue == tokenId) {
                // Get the token name
                NSArray *arr = [multiInstanceId componentsSeparatedByString:@":"];
                if (arr.count > 2) {
                    return arr[2];
                }
            }
        }
    }
    return @"";
}

+ (int)getPetTokenIdForTokenKey:(NSString *)tokenKey onPetModel:(DeviceModel *)deviceModel {
    return ((NSNumber *)[deviceModel getAttribute:[NSString stringWithFormat:@"%@:%@", kAttrPetTokenTokenId, tokenKey]]).intValue;
}

+ (PMKPromise *)renamePetToken:(NSString *)name withPetToken:(NSString *)petTokenKey onPetModel:(DeviceModel *)deviceModel {
    return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSString *multiInstanceId = [NSString stringWithFormat:@"%@:%@", kAttrPetTokenPetName, petTokenKey];
        
      [deviceModel set:@{name: multiInstanceId}];
        [deviceModel commit].thenInBackground(^{
            [deviceModel refresh].then(^(ClientEvent *event) {
                fulfill(event);
            });
        });
    }];
}

+ (PMKPromise *)removePetToken:(NSString *)tokenKey onPetModel:(DeviceModel *)deviceModel {
    int tokenId = [self getPetTokenIdForTokenKey:tokenKey onPetModel:deviceModel];

    return [PetDoorCapability removeTokenWithTokenId:tokenId onModel:deviceModel].thenInBackground(^{
        return [deviceModel refresh];
    });
}
@end
