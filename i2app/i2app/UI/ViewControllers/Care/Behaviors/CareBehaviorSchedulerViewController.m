//
//  CareBehaviorSchedulerViewController.m
//  i2app
//
//  Created by Arcus Team on 2/12/16.
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
#import "CareBehaviorSchedulerViewController.h"
#import "SchedulerListCell.h"
#import "UIImage+ImageEffects.h"
#import "CareBehaviorScheduleSettingViewController.h"
#import "NSDate+Convert.h"

#define DATE_FORMAT @"cccccc h:mm a"
#define SCHEDULER_SEPARATOR_LEFT_INSET 65.0f


@interface CareBehaviorSchedulerViewController ()

@property (strong, nonatomic) NSMutableArray<CareTimeWindowModel *> *timeWindows;
@property (strong, nonatomic) CareTimeWindowModel *timeWindowBeingEdited;

@end


@implementation CareBehaviorSchedulerViewController {
    NSDateFormatter *dateFormatter;
    NSCalendar *calendar;
}

#pragma mark - Creation
+ (CareBehaviorSchedulerViewController *)createWithTimeWindows:(NSMutableArray<CareTimeWindowModel *>*)timeWindows {
    CareBehaviorSchedulerViewController *vc = [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareBehaviorSchedulerViewController class])];
    vc.timeWindows = timeWindows;
    return vc;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    calendar = [NSCalendar currentCalendar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController] && self.completion) {
        self.completion([self.timeWindows copy]);
    }
}

#pragma mark - WeeklyScheduleViewControllermethods
- (NSString *)titleText {
    return NSLocalizedString(@"Behavior Scheduling Empty Title Text", nil);
}

- (NSString *)subtitleText {
    return NSLocalizedString(@"Behavior Scheduling Empty Subtitle Text", nil);
}

- (NSString *)getNavBarTitle {
    return NSLocalizedString(@"SCHEDULE", nil);
}

- (BOOL)isRegularSchedule {
    return YES;
}

- (NSArray *)loadEventForDay:(ScheduleRepeatType)day {
    NSInteger weekDay = [self dateComponentWeekDayFor:day];
    NSNumber *weekDayObject = @(weekDay);
    
    NSArray<CareTimeWindowModel *> *filteredTimeWindows = [_timeWindows filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(CareTimeWindowModel *timeWindow, NSDictionary *bindings) {
        NSArray<NSNumber *> *daysInvolvedForTimeWindow = [NSDate weekDaysInvolvedFromDate:timeWindow.startDayTime toDate:timeWindow.endDayTime];
        return [daysInvolvedForTimeWindow containsObject:weekDayObject];
    }]];
    
    NSArray<CareTimeWindowModel *> *sortedTimeWindows = [filteredTimeWindows sortedArrayUsingComparator:^NSComparisonResult(CareTimeWindowModel *timeWindow1, CareTimeWindowModel *timeWindow2) {
        NSComparisonResult comparisonResult;
        
        NSInteger componentWeekDayTimeWindow1Start = [calendar component:NSCalendarUnitWeekday fromDate:timeWindow1.startDayTime];
        NSInteger componentWeekDayTimeWindow2Start = [calendar component:NSCalendarUnitWeekday fromDate:timeWindow2.startDayTime];
        NSInteger dayButtonWeekDayTimeWindow1Start = [self weekDayInDayButtonTagOrderForCalendarWeekDay:componentWeekDayTimeWindow1Start];
        NSInteger dayButtonWeekDayTimeWindow2Start = [self weekDayInDayButtonTagOrderForCalendarWeekDay:componentWeekDayTimeWindow2Start];
        
        if ((componentWeekDayTimeWindow1Start == weekDay && componentWeekDayTimeWindow2Start != weekDay)
            || (componentWeekDayTimeWindow1Start != weekDay && componentWeekDayTimeWindow2Start == weekDay)) {
            comparisonResult = componentWeekDayTimeWindow1Start == weekDay ? NSOrderedDescending : NSOrderedAscending;
        } else {
            if (dayButtonWeekDayTimeWindow1Start == dayButtonWeekDayTimeWindow2Start) {
                comparisonResult = [timeWindow1.startDayTime dateIndependentTimeComparison:timeWindow2.startDayTime];
            } else {
                comparisonResult = dayButtonWeekDayTimeWindow1Start < dayButtonWeekDayTimeWindow2Start ? NSOrderedAscending : NSOrderedDescending;
            }
        }
        
        return comparisonResult;
    }];
    
    return sortedTimeWindows;
}

- (void)updateEventButtons {
    NSDictionary<NSNumber *, NSNumber *> *daysWithScheduledStart = [self daysWithScheduledBehavior];
    for (UIButton *btn in self.dayButtons) {
        ScheduleRepeatType day = [self dayForDayButtonTag:btn.tag];
        BOOL hasScheduledStart = [daysWithScheduledStart[@(day)] boolValue];
        btn.layer.cornerRadius = btn.bounds.size.width/2.0f;
        btn.layer.borderWidth = hasScheduledStart ? 1.0 : 0.0;
    }
}

- (IBAction)onClickAdd:(id)sender {
    CareBehaviorScheduleSettingViewController *vc = [CareBehaviorScheduleSettingViewController createWithTimeWindow:nil];
    vc.saveCompletion = ^(CareTimeWindowModel *timeWindow) {
        [self.timeWindows addObject:timeWindow];
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchedulerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CareTimeWindowModel *timeWindow = self.scheduledEvents[indexPath.row];
    
    NSString *sideLabelText = [NSString stringWithFormat:@"%@ - %@",
                               [dateFormatter stringFromDate:timeWindow.startDayTime],
                               [dateFormatter stringFromDate:timeWindow.endDayTime]];
    cell.sideLabel.text = sideLabelText;
    
    NSInteger startHour = [calendar component:NSCalendarUnitHour fromDate:timeWindow.startDayTime];
    if (startHour < 6 || startHour > 18) {
        [cell.eventIcon setImage:self.hasLightBackground?[[UIImage imageNamed:@"icon_night"] invertColor]:[UIImage imageNamed:@"icon_night"]];
    } else {
        [cell.eventIcon setImage:self.hasLightBackground?[[UIImage imageNamed:@"icon_day"] invertColor]:[UIImage imageNamed:@"icon_day"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CareTimeWindowModel *timeWindow = self.scheduledEvents[indexPath.row];
    CareBehaviorScheduleSettingViewController *vc = [CareBehaviorScheduleSettingViewController createWithTimeWindow:[timeWindow copy]];
    self.timeWindowBeingEdited = timeWindow;
    vc.saveCompletion = ^(CareTimeWindowModel *newTimeWindow) {
        [self.timeWindows removeObject:self.timeWindowBeingEdited];
        self.timeWindowBeingEdited = nil;
        [self.timeWindows addObject:newTimeWindow];
        [self loadData];
    };
    vc.removeCompletion = ^{
        [self.timeWindows removeObject:self.timeWindowBeingEdited];
        self.timeWindowBeingEdited = nil;
        [self loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    CGFloat tableViewWidth = self.tableView.bounds.size.width;
    if (indexPath.row == self.scheduledEvents.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, tableViewWidth/2, 0, tableViewWidth/2);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, SCHEDULER_SEPARATOR_LEFT_INSET, 0, 0);
    }
}

#pragma mark - Helpers
- (NSDictionary<NSNumber *, NSNumber *> *)daysWithScheduledBehavior {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (CareTimeWindowModel *timeWindow in self.timeWindows) {
        NSArray *weekDaysWithScheduledBehaviors = [NSDate weekDaysInvolvedFromDate:timeWindow.startDayTime toDate:timeWindow.endDayTime];
        for (NSNumber *weekDay in weekDaysWithScheduledBehaviors) {
            NSNumber *key = @([self scheduleRepeatTypeForDateComponentWeekday:[weekDay integerValue]]);
            NSNumber *value = [NSNumber numberWithBool:@(YES)];
            dictionary[key] = value;
        }
    }
    
    return dictionary;
}

- (ScheduleRepeatType)dayForDayButtonTag:(NSInteger)dayButtonTag {
    ScheduleRepeatType scheduleRepeatDay;
    switch (dayButtonTag) {
        case 1:
            scheduleRepeatDay = ScheduleRepeatTypeMon;
            break;
            
        case 2:
            scheduleRepeatDay = ScheduleRepeatTypeTue;
            break;
            
        case 3:
            scheduleRepeatDay = ScheduleRepeatTypeWed;
            break;
            
        case 4:
            scheduleRepeatDay = ScheduleRepeatTypeThu;
            break;
            
        case 5:
            scheduleRepeatDay = ScheduleRepeatTypeFri;
            break;
            
        case 6:
            scheduleRepeatDay = ScheduleRepeatTypeSat;
            break;
            
        default:
            scheduleRepeatDay = ScheduleRepeatTypeSun;
            break;
    }
    return scheduleRepeatDay;
}

- (NSInteger)weekDayInDayButtonTagOrderForCalendarWeekDay:(NSInteger)calendarWeekDay {
    NSInteger dayButtonWeekDay = calendarWeekDay;
    dayButtonWeekDay -= 1;
    return dayButtonWeekDay == 0 ? 7 : dayButtonWeekDay;
}

- (NSInteger)dateComponentWeekDayFor:(ScheduleRepeatType)scheduleDay {
    NSInteger dateComponentWeekDay;
    switch (scheduleDay) {
        case ScheduleRepeatTypeSun:
            dateComponentWeekDay = 1;
            break;
            
        case ScheduleRepeatTypeMon:
            dateComponentWeekDay = 2;
            break;
            
        case ScheduleRepeatTypeTue:
            dateComponentWeekDay = 3;
            break;
            
        case ScheduleRepeatTypeWed:
            dateComponentWeekDay = 4;
            break;
            
        case ScheduleRepeatTypeThu:
            dateComponentWeekDay = 5;
            break;
            
        case ScheduleRepeatTypeFri:
            dateComponentWeekDay = 6;
            break;
            
        case ScheduleRepeatTypeSat:
            dateComponentWeekDay = 7;
            break;
    }
    return dateComponentWeekDay;
}

- (ScheduleRepeatType)scheduleRepeatTypeForDateComponentWeekday:(NSInteger)dateComponentWeekday {
    ScheduleRepeatType scheduleRepeatDay;
    switch (dateComponentWeekday) {
        case 1:
            scheduleRepeatDay = ScheduleRepeatTypeSun;
            break;
            
        case 2:
            scheduleRepeatDay = ScheduleRepeatTypeMon;
            break;
            
        case 3:
            scheduleRepeatDay = ScheduleRepeatTypeTue;
            break;
            
        case 4:
            scheduleRepeatDay = ScheduleRepeatTypeWed;
            break;
            
        case 5:
            scheduleRepeatDay = ScheduleRepeatTypeThu;
            break;
        
        case 6:
            scheduleRepeatDay = ScheduleRepeatTypeFri;
            break;
            
        default:
            scheduleRepeatDay = ScheduleRepeatTypeSat;
            break;
    }
    return scheduleRepeatDay;
}

@end
