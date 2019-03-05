//
//  RuleScheduleController.m
//  i2app
//
//  Created by Arcus Team on 2/22/16.
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
#import "RuleScheduleController.h"
#import "ScheduleController.h"
#import "RuleScheduledEventModel.h"

#import <i2app-Swift.h>

NSString *const kRuleSchedule = @"RULES";


@interface RuleScheduleController ()

@end


@implementation RuleScheduleController


- (instancetype)init {
    if (self = [super init]) {
        ScheduleController.scheduleController = self;
    }
    return self;
}

- (void) initializeData {
}

#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Rules";
}

- (RuleModel *)schedulingModel {
    return (RuleModel *)[[[CorneaHolder shared] modelCache] fetchModel:super.schedulingModelAddress];
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (NSString *)getHeaderText {
    return @"Tap on the Rule below to manage its schedule.";
}

- (NSString *)getSubheaderText {
    return @"Unchecking a rule will put the device";
}

- (NSString *)getSchedulerSettingViewControllerSubheader {
    return @"Create a time window by choosing an active and inactive state.";
}

- (NSString *)emptyScheduleTitleText {
    return @"Set it and Forget it";
}

- (NSString *)emptyScheduleSubtitleText {
    return @"Tap add event to choose the time window this rule will run.\n\nWithout any events, this rule will be active until you manually deactivate it on the My Rules page in the left hand navigation.";
}

#pragma mark - Scheduler Utilities
- (ScheduledEventModel *)getNewEventModel {
    return [RuleScheduledEventModel new];
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    ScheduledEventModel *eventModel = [[RuleScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];

    [eventModel preload];
    
    return eventModel;
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    return kRuleSchedule;
}

#pragma mark - Add/Update/Delete schedule events
- (PMKPromise *)updateScheduleWithEvent:(ScheduledEventModel *)eventModel
                               withDays:(NSArray *)days {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self saveScheduleWithEvent:eventModel withDays:days].thenInBackground(^{
            
            [ScheduleController.scheduleController deleteScheduleWithEventId:eventModel.eventId withDay:@""].then(^{
                
                //Tag Edit Scene
                [ArcusAnalytics tag:AnalyticsTags.RuleEditSchedule attributes:@{}];
                fulfill(eventModel);
            });
        });
    }];
}

@end
