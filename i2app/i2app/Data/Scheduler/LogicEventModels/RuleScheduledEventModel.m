//
//  RuleScheduledEventModel.m
//  i2app
//
//  Created by Arcus Team on 12/18/15.
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
#import "RuleScheduledEventModel.h"
#import "SchedulerSettingViewController.h"
#import "OrderedDictionary.h"
#import "PopupSelectionLogoTextView.h"
#import "RuleCapability.h"

@implementation RuleScheduledEventModel

- (instancetype)initWithEventDay:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    if (self = [super initWithEventDay:eventDay withDelegate:delegate]) {
        // Set the default attributes
        [self setState:YES];
         self.messageType = kCmdRuleEnable;

    }
    return self;
}

- (BOOL)getState {
    return [self.messageType isEqualToString:kCmdRuleEnable];
}

- (void)setState:(BOOL)enable {
    if (enable) {
        self.messageType = kCmdRuleEnable;
    }
    else {
        self.messageType = kCmdRuleDisable;
    }
}


#pragma mark - override
- (NSString *)getSideValue {
    return [self getState] ? @"Active": @"Inactive";
}

- (NSArray <SchedulerSettingOption *>*)getScheduleEventOptions {
    NSMutableArray <SchedulerSettingOption *>*items = [[NSMutableArray alloc] init];
    
    [items addObject:[[SchedulerSettingOption createSideValue:@"STATE"
                                                    sideValue:[self getState] ? @"Active": @"Inactive"
                                                   eventOwner:self
                                                      onClick:@selector(chooseState)] setTag:1]];
    return items;
}

- (void) chooseState {
    NSMutableArray<PopupSelectionLogoItemModel *> *items = [[NSMutableArray alloc] init];
    [items addObject:[[PopupSelectionLogoItemModel createWithTitle:@"ACTIVE" subtitle:@"Choose the time you want the rule to start running" selected:[self getState]] setReturnObj:@(YES)]];
    [items addObject:[[PopupSelectionLogoItemModel createWithTitle:@"INACTIVE" subtitle:@"Choose the time you want the rule to stop running" selected:![self getState]] setReturnObj:@(NO)]];
    
    PopupSelectionLogoTextView *statePicker = [PopupSelectionLogoTextView create:@"CHOOSE A STATE" items:items];
    [statePicker setFooterText:@"If you choose to make a rule inactive, the rule won't become active again until you schedule a new active event."];
    
    [self.delegate present:statePicker complete:@selector(chooseRuleState:) withOwner:self.delegate];
}

- (void)stateUpdate:(NSNumber *)value {
    if (value && [value boolValue] != [self getState]) {
        [self setState:[value boolValue]];
        [self.delegate reloadData];
    }
}


@end
