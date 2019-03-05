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
#import "WeeklyScheduleViewController.h"

#import "SchedulerSettingViewController.h"
#import "ScheduleController.h"
#import "UIImage+ImageEffects.h"
#import "SchedulerCapability.h"
#import "SchedulerListCell.h"
#import "ScheduleController.h"
#import "LawnNGardenScheduleController.h"
#import "LawnNGardenSchedulerListCell.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "NSDate+Convert.h"

@implementation SchedulerListCell (ScheduledEventModelConfiguration)

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(ScheduledEventModel *)model hasLightBackground:(BOOL)hasLightBackground {
    
    if (hasLightBackground) {
        [self.timeLabel styleSet:[model.eventTime formatDateTimeStampShort] andButtonType:FontDataType_Medium_12_Black];
        [self.sideLabel styleSet:[model getSideValue] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
        [self.arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
    }
    else {
        [self.timeLabel styleSet:[model.eventTime formatDateTimeStampShort] andButtonType:FontDataType_Medium_12_White_NoSpace];
        [self.sideLabel styleSet:[model getSideValue] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
        [self.arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
    }
    
    switch (model.eventTime.dateTimeType) {
        case DateTimeDay:
            [self.eventIcon setImage:hasLightBackground?[[UIImage imageNamed:@"icon_day"] invertColor]:[UIImage imageNamed:@"icon_day"]];
            break;
            
        case DateTimeNight:
            [self.eventIcon setImage:hasLightBackground?[[UIImage imageNamed:@"icon_night"] invertColor]:[UIImage imageNamed:@"icon_night"]];
            break;
            
        case DateTimeSunrise:
            [self.eventIcon setImage:hasLightBackground?[[UIImage imageNamed:@"icon_night"] invertColor]:[UIImage imageNamed:@"icon_sunrise"]];
            break;
            
        case DateTimeSunset:
            [self.eventIcon setImage:hasLightBackground?[[UIImage imageNamed:@"icon_night"] invertColor]:[UIImage imageNamed:@"icon_sunset"]];
            break;
            
        default:
            break;
    }
}

@end


#pragma mark - Private interface
@interface WeeklyScheduleViewController ()

@property (weak, nonatomic) UIViewController *owner;
@property (weak, nonatomic) IBOutlet UIView *weeklyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weeklyViewToTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelToTopConstraint;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *spaceConstraint;

@property (weak, nonatomic) IBOutlet UIView *nextEventView;
@property (weak, nonatomic) IBOutlet UILabel *nextEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *nextEventSubtitle;

@property (atomic, assign) ScheduleRepeatType selectedDay;

@property (atomic, assign) BOOL alwaysShowNextEvent;
@end


@implementation WeeklyScheduleViewController {
    int     _initialWeeklyViewToTopConstraint;
    
    BOOL    _isRegularSchedule; // It is NOT a Lawn&Garden schedule
}

+ (WeeklyScheduleViewController *)createWithOwner:(UIViewController *)owner {
    WeeklyScheduleViewController *vc = [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.owner = owner;
    
    return vc;
}

+ (WeeklyScheduleViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (WeeklyScheduleViewController *)createAndAlwaysShowNextEvent {
    WeeklyScheduleViewController *vc =  [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.alwaysShowNextEvent = YES;
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if (self.owner != nil) {
        [ArcusAnalytics tagWithNamed:AnalyticsTags.DevicesScheduleEdit];
    }
    
    _isRegularSchedule = [self isRegularSchedule];
    
    if (IS_IPHONE_5) {
        for (NSLayoutConstraint *constraint in _spaceConstraint) {
            constraint.constant = 15;
        }
    }
    _initialWeeklyViewToTopConstraint = self.weeklyViewToTopConstraint.constant;
    self.nextEventView.hidden = YES;
    
    _selectedDay = ScheduleRepeatTypeMon;
    
    [self navBarWithBackButtonAndTitle:[self getNavBarTitle]];
    [self setBackgroundColorToLastNavigateColor];
    
    if (self.owner) {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    else {
        [self setBackgroundColorToLastNavigateColor];
    }
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];

    self.titleLabel.text = [self titleText];
    self.subtitleLabel.text = [self subtitleText];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
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
    
    [self setupWeeklyView];
    
    [self.addButton addTarget:self action:@selector(onClickAdd:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model attributeChangedNotification:kAttrSchedulerCommands] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schedulerAdded:) name:Constants.kModelAddedNotification
                                               object:nil];
}

- (NSString *)titleText {
    return NSLocalizedString([ScheduleController.scheduleController emptyScheduleTitleText], nil);
}

- (NSString *)subtitleText {
    return NSLocalizedString([ScheduleController.scheduleController emptyScheduleSubtitleText], nil);
}

- (NSString *)getNavBarTitle {
    return [ScheduleController.scheduleController scheduleViewControllerNavBarTitle];
}

- (BOOL)isRegularSchedule {
    return ![ScheduleController.scheduleController isKindOfClass:[LawnNGardenScheduleController class]];
}

- (void)setupWeeklyView {
    for (UIButton *btn in _dayButtons) {
        btn.layer.cornerRadius = btn.bounds.size.width/2.0f;
        
        if (self.hasLightBackground) {
            btn.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
            [btn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
        }
        else {
            btn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        if (btn.tag == 1) {
            [btn setSelected:YES];
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
        else {
            [btn setSelected:NO];
            [btn setBackgroundColor:[UIColor clearColor]];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)updateEventButtons {
    for (UIButton *btn in _dayButtons) {
        btn.layer.cornerRadius = btn.bounds.size.width/2.0f;
        btn.layer.borderWidth = [ScheduleController.scheduleController hasEventsForSelectedDay:(ScheduleRepeatType)(1 << btn.tag)] ? 1.0 : 0.0;
    }
}

- (void)loadData {
    self.scheduledEvents = [self loadEventForDay:_selectedDay];
    
    [self updateEventButtons];
    [self.tableView reloadData];
    
    [self setTitleAndSubtitleLabelVisibility];

    if (![self isRegularSchedule]) {
        if (self.alwaysShowNextEvent) {
            if ([self populateNextScheduledEvent]) {
                self.weeklyViewToTopConstraint.constant = 100;
                self.titleLabelToTopConstraint.constant = 80;
            }
            else {
                self.weeklyViewToTopConstraint.constant = _initialWeeklyViewToTopConstraint;
            }
        }
        else {
            if (self.scheduledEvents.count > 0) {
                [self populateNextScheduledEvent];
            }
            else {
                self.nextEventView.hidden = YES;
                self.weeklyViewToTopConstraint.constant = _initialWeeklyViewToTopConstraint;

                self.titleLabel.text = [self titleText];
                self.subtitleLabel.text = [self subtitleText];
            }
        }
    }
}

- (BOOL)populateNextScheduledEvent {
    self.weeklyViewToTopConstraint.constant = 100;

    self.nextEventView.hidden = NO;
    self.nextEventTitle.text = NSLocalizedString(@"NEXT EVENT", nil);
    NSDate *eventTime;
    NSString *eventValue;
    if ([LawnNGardenScheduleController nextEventForModel:ScheduleController.scheduleController.schedulingModel eventTime:&eventTime eventValue:&eventValue]) {
        self.nextEventView.hidden = NO;
        self.nextEventSubtitle.text = [eventTime formatBasedOnDayOfWeekAndHoursExceptToday];
        return YES;
    }
    else {
        self.nextEventView.hidden = YES;
        return NO;
    }
}

- (NSArray *)loadEventForDay:(ScheduleRepeatType)day {
    return [ScheduleController.scheduleController loadEventForSelectedDay:day];
}

- (IBAction)onClickDay:(UIButton *)sender {
    for (UIButton *btn in self.dayButtons) {
        btn.selected = NO;
        btn.backgroundColor = [UIColor clearColor];
    }
    
    sender.selected = YES;
    if (sender.selected) {
        sender.backgroundColor = [UIColor whiteColor];
    }
    else {
        sender.backgroundColor = [UIColor clearColor];
    }
    
    switch (sender.tag) {
        case 1:
            _selectedDay = ScheduleRepeatTypeMon;
            break;
            
        case 2:
            _selectedDay = ScheduleRepeatTypeTue;
            break;
            
        case 3:
            _selectedDay = ScheduleRepeatTypeWed;
            break;
            
        case 4:
            _selectedDay = ScheduleRepeatTypeThu;
            break;
            
        case 5:
            _selectedDay = ScheduleRepeatTypeFri;
            break;
            
        case 6:
            _selectedDay = ScheduleRepeatTypeSat;
            break;
            
        case 7:
            _selectedDay = ScheduleRepeatTypeSun;
            break;
            
        default:
            break;
    }
    
    [self loadData];
}

- (void)onClickAdd:(UIButton *)sender {
    SchedulerSettingViewController *vc = [SchedulerSettingViewController createNewEventInWithEventDay:self.selectedDay];
    if (self.owner) {
        [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesScheduleEventAdd];
        [self.owner.navigationController pushViewController:vc animated:YES];
    }
    else {
        [ArcusAnalytics tagWithNamed: AnalyticsTags.SceneScheduleEventAdd];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scheduledEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isRegularSchedule) {
        SchedulerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell setModel:self.scheduledEvents[indexPath.row] hasLightBackground:self.hasLightBackground];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else {
        LawnNGardenSchedulerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LawnNGardenCell"];
        [cell setModel:self.scheduledEvents[indexPath.row] hasLightBackground:self.hasLightBackground];
        [cell setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SchedulerSettingViewController *vc = [SchedulerSettingViewController createWithEventModel:self.scheduledEvents[indexPath.row]];
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
        [self loadData];
    });
}

- (void)schedulerAdded:(NSNotification *)note {
    if (![note.object isKindOfClass:SchedulerModel.class]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self loadData];
    });
}

#pragma mark - helper methods
- (void)setTitleAndSubtitleLabelVisibility {
    BOOL shouldShow = self.scheduledEvents.count == 0;
    
    [self.titleLabel setHidden:!shouldShow];
    [self.subtitleLabel setHidden:!shouldShow];
}


@end
