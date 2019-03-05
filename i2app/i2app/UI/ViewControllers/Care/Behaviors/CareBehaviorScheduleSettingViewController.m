//
//  CareBehaviorScheduleSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 3/1/16.
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
#import "CareBehaviorScheduleSettingViewController.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "PopupSelectionTimerView.h"
#import "NSDate+Convert.h"
#import <i2app-Swift.h>

#define TABLE_CONSTRAINT_NO_REMOVE 60
#define TABLE_CONSTRAINT_WITH_REMOVE 135
#define SAVE_CONSTRAINT_NO_REMOVE 15
#define SAVE_CONSTRAINT_WITH_REMOVE 75
#define DISABLED_ALPHA 0.4f

typedef NS_ENUM(NSInteger, CareScheduleSettingCellType) {
    CareScheduleSettingCellTypeStartDate,
    CareScheduleSettingCellTypeEndDate
};

@interface CareBehaviorScheduleSettingViewController ()

@property (strong, nonatomic) CareTimeWindowModel *timeWindow;
@property (nonatomic) BOOL isCreation;
@property (nonatomic) BOOL saveButtonShouldBeEnabled;

@property (nonatomic,strong) PopupSelectionWindow *popupWindow;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerSeparator;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;

@end

@implementation CareBehaviorScheduleSettingViewController

#pragma mark - Creation
+ (CareBehaviorScheduleSettingViewController *)createWithTimeWindow:(CareTimeWindowModel *)timeWindow {
    CareBehaviorScheduleSettingViewController *vc = [[UIStoryboard storyboardWithName:@"CareBehaviors" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    CareTimeWindowModel *theTimeWindow = timeWindow;
    if (!theTimeWindow) {
        theTimeWindow = [CareTimeWindowModel new];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"ccc hh:mm a";        
        theTimeWindow.startDayTime = [dateFormatter dateFromString:@"Mon 8:00 PM"];
        theTimeWindow.endDayTime = [dateFormatter dateFromString:@"Tue 6:00 AM"];

        vc.isCreation = YES;
    } else {
        vc.isCreation = NO;
    }
    vc.timeWindow = theTimeWindow;
    return vc;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self oneTimeUIConfig];
    [self reloadData];
}

#pragma mark - Data
- (void)setSaveButtonShouldBeEnabled:(BOOL)saveButtonShouldBeEnabled {
    _saveButtonShouldBeEnabled = saveButtonShouldBeEnabled;
    self.saveButton.enabled = saveButtonShouldBeEnabled;
    self.saveButton.alpha = saveButtonShouldBeEnabled ? 1.0f : DISABLED_ALPHA;
}

#pragma mark - UI
- (void)oneTimeUIConfig {
    NSString *navBarTitle;
    if (self.isCreation) {
        navBarTitle = NSLocalizedString(@"New event", nil);
    } else {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"cccc";
        navBarTitle = NSLocalizedString([dateFormatter stringFromDate:self.timeWindow.startDayTime], nil);
    }
    [self navBarWithBackButtonAndTitle:navBarTitle];
    self.saveButton.layer.cornerRadius = 4.0f;
    self.removeButton.layer.cornerRadius = 4.0f;
    [self.removeButton styleSet:@"SAVE" andButtonType:FontDataTypeButtonPink];
    [self setBackgroundColorToDashboardColor];
    
    FontDataType saveButtonFont;
    CGFloat saveButtonConstraintConstant;
    CGFloat tableViewConstraintConstant;
    
    UIColor *tableSeparatorColor;
    UIColor *headerFooterSeparatorColor;
    
    if (self.isCreation) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        saveButtonFont = FontDataTypeButtonDark;
        saveButtonConstraintConstant = SAVE_CONSTRAINT_NO_REMOVE;
        tableViewConstraintConstant = TABLE_CONSTRAINT_NO_REMOVE;
        self.removeButton.hidden = YES;
        headerFooterSeparatorColor = [FontColors getCreationSeparatorColor];
        tableSeparatorColor = [FontColors getCreationSeparatorColor];
        
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];
        [self adjustHeaderViewSize];
    } else {
        [self addOverlay:BackgroupOverlayTypeDark];
        saveButtonFont = FontDataTypeButtonLight;
        saveButtonConstraintConstant = SAVE_CONSTRAINT_WITH_REMOVE;
        tableViewConstraintConstant = TABLE_CONSTRAINT_WITH_REMOVE;
        tableSeparatorColor = [FontColors getStandardSeparatorColor];
        headerFooterSeparatorColor = [UIColor clearColor];
        self.headerSeparator.hidden = YES;
        self.footerSeparator.hidden = YES;
        
        self.tableView.tableHeaderView = nil;
    }
    
    self.tableView.separatorColor = tableSeparatorColor;
    self.headerSeparator.backgroundColor = headerFooterSeparatorColor;
    self.footerSeparator.backgroundColor = headerFooterSeparatorColor;
    [self.removeButton styleSet:[NSLocalizedString(@"Remove", nil) uppercaseString] andButtonType:FontDataTypeButtonPink];
    [self.saveButton styleSet:[NSLocalizedString(@"Save", nil) uppercaseString] andButtonType:saveButtonFont];
    self.saveButtonBottomConstraint.constant = saveButtonConstraintConstant;
    self.tableViewBottomConstraint.constant = tableViewConstraintConstant;
}

- (void)adjustHeaderViewSize {
    CGSize headerNewSize = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint headerOrigin = self.headerView.frame.origin;
    self.headerView.frame = CGRectMake(headerOrigin.x,
                                            headerOrigin.y,
                                            headerNewSize.width,
                                            headerNewSize.height);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)reloadData {
    [self.tableView reloadData];
    if (self.timeWindow.startDayTime && self.timeWindow.endDayTime) {
        self.saveButtonShouldBeEnabled = [self validateStartDayTime:self.timeWindow.startDayTime endDayTime:self.timeWindow.endDayTime];
    } else {
        self.saveButtonShouldBeEnabled = NO;
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"cccc h:mm a";
    }
    
    UIImage *chevronImage;
    if (self.isCreation) {
        chevronImage = [UIImage imageNamed:@"Chevron"];
    } else {
        chevronImage = [UIImage imageNamed:@"ChevronWhite"];
    }
    cell.accessoryImage.image = chevronImage;
    
    CareScheduleSettingCellType cellType = [self cellTypeForIndexPath:indexPath];
    cell.titleLabel.text = [self titleTextForCellType:cellType];
    NSDate *dayTimeDate;
    
    switch (cellType) {
        case CareScheduleSettingCellTypeStartDate:
            dayTimeDate = self.timeWindow.startDayTime;
            break;
            
        case CareScheduleSettingCellTypeEndDate:
            dayTimeDate = self.timeWindow.endDayTime;
            break;
    }
    
    NSString *timeText;
    if (dayTimeDate) {
        timeText = [dateFormatter stringFromDate:dayTimeDate];
    }
    
    cell.descriptionLabel.text = timeText;
    return cell;
}

- (CareScheduleSettingCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    CareScheduleSettingCellType cellType;
    switch (indexPath.row) {
        case 0:
            cellType = CareScheduleSettingCellTypeStartDate;
            break;
            
        case 1:
            cellType = CareScheduleSettingCellTypeEndDate;
            break;
            
        default:
            cellType = CareScheduleSettingCellTypeStartDate;
            break;
    }
    return cellType;
}

- (NSString *) titleTextForCellType:(CareScheduleSettingCellType)cellType {
    NSString *titleText;
    switch (cellType) {
        case CareScheduleSettingCellTypeStartDate:
            titleText = NSLocalizedString(@"Start Date", nil);
            break;
            
        case CareScheduleSettingCellTypeEndDate:
            titleText = NSLocalizedString(@"End Date", nil);
            break;
    }
    return titleText;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusTitleDetailTableViewCell *theCell = (ArcusTitleDetailTableViewCell *)cell;
    theCell.backgroundColor = [UIColor clearColor];
    
    UIColor *titleColor;
    UIColor *dateColor;
    if (self.isCreation) {
        titleColor = [FontColors getCreationHeaderTextColor];
        dateColor = [FontColors getCreationSubheaderTextColor];
    } else {
        titleColor = [FontColors getStandardHeaderTextColor];
        dateColor = [FontColors getStandardSubheaderTextColor];
    }
    theCell.titleLabel.textColor = titleColor;
    theCell.descriptionLabel.textColor = dateColor;
    
    if (indexPath.row == 1) {//Hide separator on last cell
        theCell.separatorInset = UIEdgeInsetsMake(0, tableView.bounds.size.width/2, 0, tableView.bounds.size.width/2);
    } else {
        theCell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CareScheduleSettingCellType cellType = [self cellTypeForIndexPath:indexPath];
    NSString *popupTitle = cellType == CareScheduleSettingCellTypeStartDate ? NSLocalizedString(@"Start", nil) : NSLocalizedString(@"End", nil);
    NSDate *currentValue = cellType == CareScheduleSettingCellTypeStartDate ? self.timeWindow.startDayTime : self.timeWindow.endDayTime;
    
    PopupSelectionTimerView *popup = [PopupSelectionTimerView create:popupTitle withDate:currentValue timerStyle:TimerStyleDayHoursAndMinutes];
    [self popupWithBlockSetCurrentValue:popup completeBlock: ^(id selectedValue) {
        NSDate *selectedDate = (NSDate *)selectedValue;
        switch (cellType) {
            case CareScheduleSettingCellTypeStartDate:
                self.timeWindow.startDayTime = selectedDate;
                break;
                
            case CareScheduleSettingCellTypeEndDate:
                self.timeWindow.endDayTime = selectedDate;
                break;
        }
        
        [self reloadData];
    }];
}

#pragma mark - Popup view handling
- (void)popupWithBlockSetCurrentValue:(PopupSelectionBaseContainer *)container completeBlock:(void (^)(id selectedValue))closeBlock  {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    _popupWindow = [PopupSelectionWindow popupWithBlock:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                                subview:container
                                                  owner:self
                                             closeBlock:closeBlock];
}


#pragma mark - IBActions
- (IBAction)saveButtonTapped:(id)sender {
    if (self.saveCompletion) {
        self.saveCompletion(self.timeWindow);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeButtonTapped:(id)sender {
    if (self.removeCompletion) {
        self.removeCompletion();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Helpers
//Ensures that either: 1) start and end are on different days, or 2) if they are the same day, start is before end
- (BOOL)validateStartDayTime:(NSDate *)startDayTime endDayTime:(NSDate *)endDayTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *startComponents = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute
                                                    fromDate:startDayTime];
    NSDateComponents *endComponents = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute
                                                  fromDate:endDayTime];
    
    if ([startComponents weekday] == [endComponents weekday]) {
        if ([startComponents hour] > [endComponents hour]) {
            return NO;
        } else if ([startComponents hour] == [endComponents hour]) {
            if ([startComponents minute] >= [endComponents minute]) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
