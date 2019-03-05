//
//  DashboardCardsManager.m
//  i2app
//
//  Created by Arcus Team on 7/29/15.
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
#import "DashboardCardsManager.h"
#import "DashboardCardModel.h"

#import "NSDate+Convert.h"
#import "SantaTracker.h"
#import "SubsystemsController.h"
#import "SecuritySubsystemCapability.h"
#import "SafetySubsystemCapability.h"
#import "SafetySubsystemAlertController.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemCapability.h"
#import "ClimateSubSystemCapability.h"
#import "ClimateSubSystemController.h"
#import "PresenceSubsystemController.h"
#import "LightsNSwitchesSubsystemController.h"

#import "HubCapability.h"
#import "DeviceController.h"
#import "CameraSubsystemController.h"
#import "DeviceOtaCapability.h"
#import "WaterSubsystemController.h"
#import "SubsystemsController.h"

@interface DashboardCardsManager()

@property (nonatomic, strong) NSArray *enabledCards;

@end

@implementation DashboardCardsManager {
    NSMutableArray *_cards;
}

@dynamic allCards;

+ (DashboardCardsManager *)shareInstance {
    static dispatch_once_t pred = 0;
    __strong static DashboardCardsManager *_manager = nil;
    dispatch_once(&pred, ^{
        _manager = [[DashboardCardsManager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSArray *savedCards = [self getSavedCards];
        if (!savedCards || ![savedCards isKindOfClass:[NSArray class]] || savedCards.count == 0) {
            _cards = [[NSMutableArray alloc] initWithArray:
                      @[[[DashboardCardModel alloc] initWithType:DashboardCardTypeFavorites],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeHistory],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeLightsSwitches],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeAlarms],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeClimate],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeDoorsLocks],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeCameras],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeCare],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeHomeFamily],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeLawnGarden],
                        [[DashboardCardModel alloc] initWithType:DashboardCardTypeWater],
                        ]];
        }
        else {
            _cards = [[NSMutableArray alloc] initWithArray:savedCards];
        }
      
        [self removeLegacyCards];
        [self checkAdditionalCards];
    }
    return self;
}

- (void)removeLegacyCards {
  NSMutableArray *newCards = [NSMutableArray new];
  
  for (DashboardCardModel *model in _cards)
  {
    if (model.type == DashboardCardTypeEnergy ||
        model.type == DashboardCardTypeWindowsBlinds ||
        model.type == DashboardCardTypeSafety)
    {
      continue;
    } else if (model.type == DashboardCardTypeSecurity) {
      [newCards addObject: [[DashboardCardModel alloc] initWithType:DashboardCardTypeAlarms]];
    } else {
      [newCards addObject:model];
    }
  }
  
  _cards = newCards;
}

#pragma mark - Dynamic Properties
- (NSArray *)allCards {
    return _cards.copy;
}

- (NSArray *)getEnabledCards {
    @synchronized(_cards) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (DashboardCardModel *card in _cards) {
            if (card.enabled)
                [array addObject:card];
        }
        return array;
    }
}

- (void) checkAdditionalCards {
    // Check Santa Tracker
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
    
    NSDate *openingDate = [SantaTracker dynamicOpenTime];
    NSDate *closingDate = [SantaTracker dynamicCloseTime];
    
    if ([NSDate isTimeOfDate:[NSDate date] betweenStartDate:openingDate andEndDate:closingDate]) {
        [self addServiceCardIfNotExist:DashboardCardTypeSantaTracker withIndex:1];
    }
    else {
        for (DashboardCardModel *cardModel in _cards) {
            if (cardModel.type == DashboardCardTypeSantaTracker) {
                [_cards removeObject:cardModel];
                break;
            }
        }
    }
}

- (void)addServiceCardIfNotExist:(DashboardCardType)type {
    [self addServiceCardIfNotExist:type withIndex:-1];
}
- (void)addServiceCardIfNotExist:(DashboardCardType)type withIndex:(NSInteger)index {
    for (DashboardCardModel *cardModel in _cards) {
        if (cardModel.type == type) {
            return;
        }
    }
    
    if (index >= 0) {
        [_cards insertObject:[[DashboardCardModel alloc] initWithType:type] atIndex:index];
    }
    else {
        [_cards addObject:[[DashboardCardModel alloc] initWithType:type]];
    }
    
}
- (void)setState:(BOOL)state byIndex:(NSInteger)index {
    if (_cards.count > index) {
        DashboardCardModel *card = [_cards objectAtIndex:index];
        [card setEnabled:state];
    }
}

- (void)setState:(BOOL)state byType:(DashboardCardType)type {
    for (DashboardCardModel *card in _cards) {
        if (card.type == type)
            [card setEnabled:state];
    }
}

- (void)tiggerStateByType:(DashboardCardType)type {
    for (DashboardCardModel *card in _cards) {
        if (card.type == type)
            [card setEnabled:!card.enabled];
    }
}

- (BOOL)getStateFromType:(DashboardCardType)type {
    for (DashboardCardModel *card in _cards) {
        if (card.type == type)
            return card.enabled;
    }
    return NO;
}

- (void)switchCardOrder:(NSInteger)originalLocation to:(NSInteger)newLocation {
    @synchronized(_cards) {
        if (_cards.count > originalLocation && _cards.count > newLocation) {
            id item = _cards[originalLocation];
            [_cards removeObjectAtIndex:originalLocation];
            [_cards insertObject:item atIndex:newLocation];
        }
        else {
            DDLogWarn(@"Switch card error");
        }
    }
}

#pragma mark - helping functions
- (void)save {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DashboardCardOrderSaved" object:nil userInfo:nil];
  
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_cards];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:@"dashServiceCards"];
    [userDefaults synchronize];
}

- (NSArray *)getSavedCards {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:@"dashServiceCards"];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return [NSArray new];
}

@end



