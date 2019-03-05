//
//  CareSubsystemController.m
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"
#import "SubsystemCapability.h"
#import "CareBehaviorModel.h"
#import "CareBehaviorTemplateModel.h"
#import "CareBehaviorSerialization.h"
#import "NSDate+Convert.h"

@interface CareSubsystemController ()

@property (nonatomic, strong) SubsystemModel *subsystemModel;

@end

@implementation CareSubsystemController

@dynamic numberOfDevices;
@dynamic allDeviceIds;
@dynamic numberOfOfflineDevices;
@dynamic numberOfOnlineDevices;
@dynamic onlineDeviceIds;
@dynamic offlineDeviceIds;
@dynamic callTree;
@dynamic isCallTreeEnabled;

NSString  *const kErrorCareNameInUse = @"care.name_in_use";
NSString  *const kErrorCareDuplicateWindows = @"care.duplicate_windows";

#pragma mark - Initialization

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

#pragma mark - Notification Handling

- (void)addChangeEventNotifiationObserver:(id)observer
                                 selector:(SEL)aSelector {
    if (observer && aSelector) {
        [[NSNotificationCenter defaultCenter] addObserver:observer
                                                 selector:aSelector
                                                     name:[Model attributeChangedNotification:kAttrCareSubsystemCallTree]
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:observer
                                                 selector:aSelector
                                                     name:[Model attributeChangedNotification:kAttrCareSubsystemCallTreeEnabled]
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:observer
                                                 selector:aSelector
                                                     name:kSubsystemUpdatedNotification
                                                   object:nil];
    }
}

- (void)removeChangeEventNotifiationObserver:(id)observer
                                    selector:(SEL)aSelector {
    if (observer && aSelector) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                        name:[Model attributeChangedNotification:kAttrCareSubsystemCallTree]
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                        name:[Model attributeChangedNotification:kAttrCareSubsystemCallTreeEnabled]
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:observer
                                                 selector:aSelector
                                                     name:[Model attributeChangedNotification:kSubsystemUpdatedNotification]
                                                   object:nil];
    }
}

#pragma mark - Care Activity Methods

- (PMKPromise *)careActivityListWithStart:(NSDate *)startDate
                                  withEnd:(NSDate *)endDate
                           withResolution:(NSTimeInterval)resolution
                              withDevices:(NSArray *)devices {
    return [CareSubsystemCapability listActivityWithStart:([startDate timeIntervalSince1970] * 1000)
                                                  withEnd:([endDate timeIntervalSince1970] * 1000)
                                               withBucket:resolution
                                              withDevices:((devices != nil) ? devices : @[])
                                                  onModel:self.subsystemModel].then(^(CareSubsystemListActivityResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes]);
        }];        
    });
}

- (PMKPromise *)careActivityDetailsWithLimit:(NSInteger)limit
                                   withToken:(NSString *)token
                                 withDevices:(NSArray *)devices {
    return [CareSubsystemCapability listDetailedActivityWithLimit:(int)limit
                                                        withToken:token
                                                      withDevices:((devices != nil) ? devices : @[])
                                                          onModel:self.subsystemModel].then(^(CareSubsystemListDetailedActivityResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes]);
        }];
    });
}

- (void)setCareDevices:(NSArray *)careDevices {
    if (careDevices) {
        [CareSubsystemCapability setCareDevices:careDevices onModel:self.subsystemModel];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.subsystemModel commit];
        });
    }
}

#pragma mark - Care Status Methods

- (PMKPromise *)careAlarmHistoryWithLimit:(NSInteger)limit
                                withToken:(NSString *)token {
    return [SubsystemCapability listHistoryEntriesWithLimit:(int)limit
                                                  withToken:token
                                       withIncludeIncidents:false
                                                    onModel:self.subsystemModel]
    .then(^ (SubsystemListHistoryEntriesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response attributes]);
        }];
    });
}

- (CareAlarmMode)getCareAlarmMode {
    NSString *alarmModeString = [CareSubsystemCapability getAlarmModeFromModel:self.subsystemModel];
    if ([alarmModeString isEqualToString:kEnumCareSubsystemAlarmModeON]) {
        return CareAlarmModeOn;
    }
    return CareAlarmModeVisit;
}

- (void)setCareAlarmMode:(CareAlarmMode)mode {
    NSString *alarmModeString;
    switch (mode) {
        case CareAlarmModeOn:
            alarmModeString = kEnumCareSubsystemAlarmModeON;
            break;
        case CareAlarmModeVisit:
            alarmModeString = kEnumCareSubsystemAlarmModeVISIT;
            break;
    }
    
    [CareSubsystemCapability setAlarmMode:alarmModeString onModel:self.subsystemModel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.subsystemModel commit];
    });
}

#pragma mark - Care Behaviors methods
- (NSArray *)allBehaviorIDs {
    return [CareSubsystemCapability getBehaviorsFromModel:self.subsystemModel];
}

- (NSArray *)allActiveBehaviorIDs {
    return [CareSubsystemCapability getActiveBehaviorsFromModel:self.subsystemModel];
}

- (NSInteger)numberOfBehaviors {
    return [self allBehaviorIDs].count;
}

- (NSInteger)numberOfActiveBehaviors {
    return [self allActiveBehaviorIDs].count;
}



- (PMKPromise *)listBehaviorTemplates {
    return [CareSubsystemCapability listBehaviorTemplatesOnModel:self.subsystemModel].then(^(CareSubsystemListBehaviorTemplatesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            
            NSArray *behaviorTemplatesAttributes = [response attributes][@"behaviorTemplates"];
            NSMutableArray *templates = [NSMutableArray array];
            
            for (int i = 0; i < behaviorTemplatesAttributes.count; i++) {
                [templates addObject:[[CareBehaviorTemplateModel alloc] initWithDictionary:behaviorTemplatesAttributes[i]]];
            }
            
            fulfill(templates);
        }];
    });
}

- (PMKPromise *)getTemplateForBehaviorWithID:(NSString *)behaviorTemplateID {
    return [CareSubsystemCapability listBehaviorTemplatesOnModel:self.subsystemModel].then(^(CareSubsystemListBehaviorTemplatesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            
            NSArray *behaviorTemplatesAttributes = [response attributes][@"behaviorTemplates"];
            CareBehaviorTemplateModel *template;
            
            for (int i = 0; i < behaviorTemplatesAttributes.count; i++) {
                NSString *templateID = behaviorTemplatesAttributes[i][@"id"];
                
                if ([templateID isEqualToString:behaviorTemplateID]) {
                    template = [[CareBehaviorTemplateModel alloc] initWithDictionary:behaviorTemplatesAttributes[i]];
                    break;
                }
            }
            
            fulfill(template);
        }];
    });
}

- (PMKPromise *)addBehavior:(CareBehaviorModel *)behavior {
    NSMutableDictionary *behaviorDict = [CareBehaviorSerialization getJSONDictForCreationOfBehavior:behavior];
    return [CareSubsystemCapability addBehaviorWithBehavior:behaviorDict onModel:self.subsystemModel].then(^(CareSubsystemAddBehaviorResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSString *responseString = response.getId;
            fulfill(responseString);
        }];
    });
}

- (PMKPromise *)updateBehavior:(CareBehaviorModel *)behavior {
    NSMutableDictionary *behaviorDict = [CareBehaviorSerialization getJSONDictForEditingOfBehavior:behavior];
    return [CareSubsystemCapability updateBehaviorWithBehavior:behaviorDict onModel:self.subsystemModel].then(^(CareSubsystemUpdateBehaviorResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSString *responseString = response.type;
            fulfill(responseString);
        }];
    });
}

- (PMKPromise *)removeBehavior:(CareBehaviorModel *)behavior {
    return [CareSubsystemCapability removeBehaviorWithId:behavior.identifier onModel:self.subsystemModel].then(^(CareSubsystemRemoveBehaviorResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([NSNumber numberWithBool:[response attributes][@"removed"]]);
        }];
    });
}

- (PMKPromise *)listBehaviors {
    return [CareSubsystemCapability listBehaviorsOnModel:self.subsystemModel].then(^(CareSubsystemListBehaviorsResponse *response){
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSMutableArray *behaviors = [NSMutableArray array];
            
            for (NSDictionary *behaviorDict in response.getBehaviors) {
                CareBehaviorModel *behaviorObject = [CareBehaviorSerialization createModelFrom:behaviorDict];
                [behaviors addObject:behaviorObject];
            }
            
            fulfill(behaviors);
        }];
        
    });
}

- (NSArray *)activeDeviceIds {
    return [CareSubsystemCapability getCareDevicesFromModel:self.subsystemModel];
}

#pragma mark - SubsystemProtocol

- (NSArray *)allDeviceIds {
    return [CareSubsystemCapability getCareCapableDevicesFromModel:self.subsystemModel];
}

- (int)numberOfDevices {
    return (int)[[self allDeviceIds] count];
}

- (BOOL)isAlarmTriggered {
    return [[self stateString] isEqualToString:kEnumCareSubsystemAlarmStateALERT];
}

- (NSString *)stateString {
    NSString *state = [CareSubsystemCapability getAlarmStateFromModel:self.subsystemModel];
    
    return state;
}

- (NSDictionary *)getLastAlertTrigger {
    return [CareSubsystemCapability getLastAlertTriggersFromModel:self.subsystemModel];
}

- (NSString *)getLastAlertCause {
    return [CareSubsystemCapability getLastAlertCauseFromModel:self.subsystemModel];
}

- (PMKPromise *)clear {
    return [CareSubsystemCapability clearOnModel:self.subsystemModel];
}

- (PMKPromise *)panic {
    return [CareSubsystemCapability panicOnModel:self.subsystemModel];
}

- (BOOL)setSilent:(BOOL)silent {
    BOOL state = [CareSubsystemCapability setSilent:silent onModel:self.subsystemModel];
    [self.subsystemModel commit];
    
    return state;
}

- (BOOL)getSilentStatus {
    return [CareSubsystemCapability getSilentFromModel:self.subsystemModel];
}

- (NSArray *)triggerDeviceIds {
    return [CareSubsystemCapability getTriggeredDevicesFromModel:self.subsystemModel];
}

- (NSArray *)getCallTree {
    return [CareSubsystemCapability getCallTreeFromModel:self.subsystemModel];
}

- (NSString *)lastTriggeredString {
    NSString *lastTriggered = @"No Alarms Triggered";
    
    NSDate *lastTriggeredDate = [CareSubsystemCapability getLastAlertTimeFromModel:self.subsystemModel];
    if ([lastTriggeredDate compare:[NSDate dateWithTimeIntervalSince1970:0]] != NSOrderedSame) {
        if ([lastTriggeredDate isSameDayWith:[NSDate date]]) {
            lastTriggered = [NSString stringWithFormat:@"Last Alarm: Today %@", [lastTriggeredDate formatDateTimeStamp]];
        } else {
            lastTriggered = [NSString stringWithFormat:@"Last Alarm: %@", [lastTriggeredDate formatFullDate]];
        }
    }
    
    return lastTriggered;
}

#pragma mark - PersonCallTreeDataProtocol

- (NSArray *)fetchPersonCallTree {
    return [self getCallTree];
}

- (void)saveUpdatedPersonCallTree:(NSArray *)callTree {
    if (callTree) {
        [CareSubsystemCapability setCallTree:callTree
                                         onModel:self.subsystemModel];
        [self.subsystemModel commit];
    }
}

@end
