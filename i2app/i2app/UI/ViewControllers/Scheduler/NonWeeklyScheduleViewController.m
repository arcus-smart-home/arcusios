//
//  WeeklyScheduleViewController.m
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

#import <i2app-Swift.h>
#import "NonWeeklyScheduleViewController.h"
#import "SchedulerSettingViewController.h"
#import "FontData.h"
#import "ContolsStyleSheet.h"
#import "SchedulerCapability.h"

#import "IrrigationScheduledEventModel.h"
#import "SchedulerListCell.h"
#import "ScheduleController.h"
#import "LawnNGardenScheduleController.h"
#import "LawnNGardenSchedulerListCell.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "NSDate+Convert.h"

#pragma mark - DurationCell
@interface DurationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *waterEveryLabel;

@end


@implementation DurationCell

- (void)initializeCellWithDuration:(int)duration {
    NSString *sideStr = duration == 1 ? [NSString stringWithFormat:@"Every Day"] : [NSString stringWithFormat:@"%d Days", duration];
    [self.waterEveryLabel styleSet:sideStr andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChevronWhite"]];
}

@end

#pragma mark - Private interface
@interface NonWeeklyScheduleViewController () <ScheduledEventModelDelegate>

@property (weak, nonatomic) UIViewController *owner;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIView *nextEventView;
@property (weak, nonatomic) IBOutlet UILabel *nextEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *nextEventSubtitle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewToTopConstraint;

@property (nonatomic) NSArray <IrrigationScheduledEventModel *> *scheduledEvents;

@property (nonatomic, readonly) LawnNGardenScheduleController *controller;

- (void)reloadData;

- (IBAction)onClickAdd:(id)sender;

@end


@implementation NonWeeklyScheduleViewController {
    
    PopupSelectionWindow    *_popupWindow;
    int                     _initialTableViewToTopConstraint;
}

+ (NonWeeklyScheduleViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nextEventView.hidden = YES;
    _initialTableViewToTopConstraint = self.tableViewToTopConstraint.constant;
    
    [self navBarWithBackButtonAndTitle:[ScheduleController.scheduleController scheduleViewControllerNavBarTitle]];
    [self setBackgroundColorToLastNavigateColor];
    
    if (self.owner) {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [self setBackgroundColorToLastNavigateColor];
    }
    self.titleLabel.text = NSLocalizedString([ScheduleController.scheduleController emptyScheduleTitleText], nil);
    self.subtitleLabel.text = NSLocalizedString([ScheduleController.scheduleController emptyScheduleSubtitleText], nil);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;

    if (self.hasLightBackground) {
        if (!self.owner) {
            [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        }
        [self.addButton styleSet:@"Add Event" andButtonType:FontDataTypeButtonDark upperCase:YES];
        
        self.titleLabel.textColor = [UIColor blackColor];
        self.subtitleLabel.textColor = [UIColor blackColor];
    }
    else {
        if (!self.owner) {
            [self addDarkOverlay:BackgroupOverlayLightLevel];
        }
        [self.addButton styleSet:@"Add Event" andButtonType:FontDataTypeButtonLight upperCase:YES];
        
        self.titleLabel.textColor = [UIColor whiteColor];
        self.subtitleLabel.textColor = [UIColor whiteColor];
    }
    
    [self.addButton addTarget:self action:@selector(onClickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model attributeChangedNotification:kAttrSchedulerCommands] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerAdded:) name:Constants.kModelAddedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadData];
}

#pragma mark - Dynamic Properties
- (LawnNGardenScheduleController *)controller {
    return (LawnNGardenScheduleController *)ScheduleController.scheduleController;
}

- (void)reloadData {
    self.scheduledEvents = [self.controller loadScheduledEvents];
    
    if ([ScheduleController.scheduleController isKindOfClass:[LawnNGardenScheduleController class]]) {
        if (self.scheduledEvents.count > 0) {
            
            self.nextEventView.hidden = NO;
            self.nextEventSubtitle.hidden = NO;
            self.titleLabel.hidden = YES;
            self.subtitleLabel.hidden = YES;
            
            NSDate *eventTime;
            NSString *eventValue;
            if ([LawnNGardenScheduleController nextEventForModel:ScheduleController.scheduleController.schedulingModel eventTime:&eventTime eventValue:&eventValue]) {
                self.nextEventView.hidden = NO;
                self.tableViewToTopConstraint.constant = _initialTableViewToTopConstraint;
                
                self.nextEventSubtitle.text = [eventTime formatBasedOnDayOfWeekAndHoursExceptToday];
            }
            else {
                self.nextEventView.hidden = YES;
                self.tableViewToTopConstraint.constant = 0;
            }
        }
        else {
            self.nextEventView.hidden = YES;
            self.nextEventSubtitle.hidden = YES;
            self.titleLabel.hidden = NO;
            self.subtitleLabel.hidden = NO;
            self.titleLabel.text = NSLocalizedString([ScheduleController.scheduleController emptyScheduleTitleText], nil);
            self.subtitleLabel.text = NSLocalizedString([ScheduleController.scheduleController emptyScheduleSubtitleText], nil);
        }
    }
    
    [self.tableView reloadData];
}

- (void)onClickAdd:(UIButton *)sender {
    SchedulerSettingViewController *vc = [SchedulerSettingViewController createNewEventInWithEventDay:ScheduleRepeatTypeMon];
    if (self.owner) {
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (BOOL)isIntervalMode {
    return ScheduleController.scheduleController.scheduleMode == IrrigationSystemModeInterval;
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isIntervalMode] && self.scheduledEvents.count > 0) {
        return self.scheduledEvents.count + 1;
    }
    return self.scheduledEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isIntervalMode] && indexPath.row == 0) {
        DurationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DurationCell"];
        [cell initializeCellWithDuration:self.scheduledEvents[indexPath.row].wateringIntervalInDays];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    LawnNGardenSchedulerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LawnNGardenCell"];
    NSInteger index = [self isIntervalMode] ? indexPath.row - 1 : indexPath.row;
    [cell setModel:self.scheduledEvents[index] hasLightBackground:self.hasLightBackground];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ScheduleController.scheduleController.scheduledEventModel.isNewModel = NO;
    
    int selectedIndex;
    if ([self isIntervalMode]) {
        if (indexPath.row == 0) {
            self.scheduledEvents[0].delegate = self;
            [self.scheduledEvents[0] chooseWaterInterval];
            return;
        }
        selectedIndex = (int)indexPath.row - 1;
    }
    else {
        selectedIndex = (int)indexPath.row;
    }
    SchedulerSettingViewController *vc = [SchedulerSettingViewController createWithEventModel:self.scheduledEvents[selectedIndex]];
    if (self.owner) {
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Notifications
- (void)reloadData:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(),^{
        [self reloadData];
    });
}

- (void)schedulerAdded:(NSNotification *)note {
    if (![note.object isKindOfClass:SchedulerModel.class]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self reloadData];
    });
}

#pragma mark - ScheduledEventModelDelegate
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:owner
                                 closeSelector:selector];
}

- (void)present:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow present:self
                                         subview:container
                                           owner:owner
                                   closeSelector:selector];
}

@end
