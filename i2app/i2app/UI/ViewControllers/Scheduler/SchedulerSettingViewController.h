//
//  SchedulerSettingViewController.h
//  i2app
//
//  Created by Arcus Team on 10/29/15.
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

#import <UIKit/UIKit.h>
#import "ScheduledEventModel.h"

typedef enum {
    ScheduledOptionTypeSideOption = 0,
    ScheduledOptionTypeSwitch,
} ScheduledOptionType;

@interface SchedulerSettingOption : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *sideValue;
@property (strong, nonatomic) NSString *subtitle;

@property (assign, nonatomic) ScheduledOptionType optionType;
@property (assign, nonatomic) BOOL isChecked;
@property (assign, nonatomic) SEL onClick;
@property (weak, nonatomic) id eventOwner;

// less then 0 means standard option. e.g. time, repeat
@property (readonly, nonatomic) NSInteger tag;

+ (SchedulerSettingOption *)createSwitch:(NSString *)title isChecked:(BOOL)checked eventOwner:(id)owner onClick:(SEL)onclick;
+ (SchedulerSettingOption *)createSideValue:(NSString *)title sideValue:(NSString *)side eventOwner:(id)owner onClick:(SEL)onclick;

- (SchedulerSettingOption *)setDescription:(NSString *)text;

- (SchedulerSettingOption *)setTag:(NSInteger)tag;


@end

@interface SchedulerSettingViewController : UIViewController

+ (SchedulerSettingViewController *)createNewEventInWithEventDay:(ScheduleRepeatType)eventDay;
+ (SchedulerSettingViewController *)createWithEventModel:(ScheduledEventModel *)model;

- (void)chooseRuleState:(NSNumber *)value;
@end
