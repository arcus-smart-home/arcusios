//
//  WeeklyScheduleViewController.h
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
#import "PopupSelectionWindow.h"
#import "DeviceNotificationLabel.h"
#import "ScheduledEventModel.h"

@class ScheduleController;


@interface WeeklyScheduleViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

+ (WeeklyScheduleViewController *)createWithOwner:(UIViewController *)owner;
+ (WeeklyScheduleViewController *)create;
+ (WeeklyScheduleViewController *)createAndAlwaysShowNextEvent;

@property (atomic, assign) BOOL hasLightBackground;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dayButtons;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *scheduledEvents;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

- (IBAction)onClickAdd:(id)sender;

- (void)loadData;
- (void)updateEventButtons;
- (NSArray *)loadEventForDay:(ScheduleRepeatType)day;
- (NSString *)titleText;
- (NSString *)subtitleText;
- (NSString *)getNavBarTitle;
- (BOOL)isRegularSchedule;

@end
