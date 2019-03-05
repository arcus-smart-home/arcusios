//
//  PetDoorScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 1/4/16.
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
#import "PetDoorScheduledEventModel.h"
#import "SchedulerSettingViewController.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionTextPickerView.h"
#import "PetDoorCapability.h"

@implementation PetDoorScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        [self setLockState:kEnumPetDoorLockstateAUTO];
    }
    return self;
}

- (NSString *)getLockState {
    return self.attributes[kAttrPetDoorLockstate];
}

- (void)setLockState:(NSString *)lockState {
    [self.attributes setObject:lockState forKey:kAttrPetDoorLockstate];
}

#pragma mark - override
- (NSString *)getSideValue {
    NSString *lockState = [self getLockState];

    if ([lockState isEqualToString:kEnumPetDoorLockstateAUTO]) {
        return @"Auto";
    }
    if ([lockState isEqualToString:kEnumPetDoorLockstateLOCKED]) {
        return @"Locked";
    }
    if ([lockState isEqualToString:kEnumPetDoorLockstateUNLOCKED]) {
        return @"Unlocked";
    }
    return @"Auto";
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"STATE"
                                                    sideValue:[self getSideValue]
                                                   eventOwner:self
                                                      onClick:@selector(chooseLockState)] setTag:1]];
    return items;
}

#pragma mark - on click actions
- (void)chooseLockState {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    [dic setObject:kEnumPetDoorLockstateAUTO forKey:@"Auto"];
    [dic setObject:kEnumPetDoorLockstateLOCKED forKey:@"Locked"];
    [dic setObject:kEnumPetDoorLockstateUNLOCKED forKey:@"Unlocked"];
    
    PopupSelectionTextPickerView *textPicker = [PopupSelectionTextPickerView create:@"LOCK" list:dic];
    [textPicker setCurrentKey:[self getSideValue]];
    
    [self.delegate popup:textPicker complete:@selector(lockStateUpdate:) withOwner:self];
}

- (void)lockStateUpdate:(id)value {
    if (value && ![value isEqualToString:[self getLockState]]) {
        [self setLockState:value];
        [self.delegate reloadData];
    }
}

@end
