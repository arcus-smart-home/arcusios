//
//  CareActivityBaseViewController.m
//  i2app
//
//  Created by Arcus Team on 2/8/16.
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
#import "CareActivityBaseViewController.h"
#import "PopupSelectionDayView.h"
#import "PopupSelectionWindow.h"
#import "CareActivityManager.h"
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"
#import "NSDate+Convert.h"


NSInteger const kHistoryNumberOfDays = 14;

@interface CareActivityBaseViewController ()

@end

@implementation CareActivityBaseViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureDateButton];
}

#pragma mark - UI Configuration

- (void)configureDateButton {
    self.dateButton.layer.cornerRadius = 4.0f;
    self.dateButton.layer.borderWidth = 1.0f;
    self.dateButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self setDateButtonText:[self dateStringForDate:self.dateFilter]];
}

- (NSString *)dateStringForDate:(NSDate *)date {
    NSString *dateString = nil;
    
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        dateString = @"Today";
    } else if ([[NSCalendar currentCalendar] isDateInYesterday:date]) {
        dateString = @"Yesterday";
    } else {
        dateString = [date formatDateByDay];
    }
    
    return dateString;
}

- (void)setDateButtonText:(NSString *)string {
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:[string uppercaseString]
                                                                      attributes:[FontData getFontWithSize:12.0f
                                                                                                      bold:YES
                                                                                                   kerning:2.0f
                                                                                                     color:[UIColor whiteColor]]];
    
    [self.dateButton setAttributedTitle:buttonTitle
                               forState:UIControlStateNormal];
}

- (void)moveCollectionViewToEndPosition:(UICollectionView *)collectionView
                               endIndex:(NSInteger)index {
    if (index >= 0) {
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                   inSection:0]
                               atScrollPosition:UICollectionViewScrollPositionRight
                                       animated:NO];
    }
}

- (NSInteger)indexOfUnitForCurrentTime {
    // Start with last index.
    NSInteger index = [self.careActivityUnits count] - 1;
    
    for (CareActivityUnit *unit in self.careActivityUnits) {
        if ([unit.startDate compare:[NSDate date]] == NSOrderedDescending) {
            index = [self.careActivityUnits indexOfObject:unit];
            break;
        }
    }
    
    return index;
}

#pragma mark - Getters & Setters

- (CareActivityManager *)activityManager {
    if (!_activityManager) {
        _activityManager = [[CareActivityManager alloc] init];
        _activityManager.delegate = self;
        _activityManager.careSubsystem = [[SubsystemsController sharedInstance] careController];
    }
    return _activityManager;
}

- (NSArray *)careDevicesArray {
    NSMutableArray *mutableDevices = [[NSMutableArray alloc] init];
    NSArray *allDeviceIds = [[[SubsystemsController sharedInstance] careController] allDeviceIds];
    [mutableDevices addObjectsFromArray:[allDeviceIds sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull devAddr1, NSString *  _Nonnull devAddr2) {
        DeviceModel *device1 = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:devAddr1];
        DeviceModel *device2 = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:devAddr2];
        return [[device1 name] localizedCaseInsensitiveCompare:[device2 name]];
    }]];
    [mutableDevices insertObject:@"Summary" atIndex:0];
    return _careDevicesArray = [NSArray arrayWithArray:mutableDevices];
}

- (CareActivitySection *)careActivitySection {
    if (!_careActivitySection) {    
        _careActivitySection = [[CareActivitySection alloc] init];
        _careActivitySection.endDate = [self convertDateToNextMidnight:self.dateFilter];
        _careActivitySection.startDate = [self convertDateToMidnightMinusOneHour:self.dateFilter];
        _careActivitySection.sectionType = CareCalendarUnitHour;
        _careActivitySection.sectionMultiplier = 23;
        _careActivitySection.unitType = CareCalendarUnitMinute;
        _careActivitySection.unitMultiplier = 30;
        _careActivitySection.intervalResolution = CareCalendarUnitMinute;
        _careActivitySection.resolutionMultipler = 5;
        _careActivitySection.filterDevices = self.filteredDevices;
    }
    return _careActivitySection;
}

- (NSDate *)dateFilter {
    if (!_dateFilter) {
        _dateFilter =  [self convertDateToMidnight:[NSDate date]];
    }
    return _dateFilter;
}

- (NSArray *)filteredDevices {
    if (!_filteredDevices) {
        _filteredDevices = [[[SubsystemsController sharedInstance] careController] activeDeviceIds];
    }
    return _filteredDevices;
}

- (NSArray *)careActivityUnits {
    // Band-aid for ITWO-5147
    NSMutableArray <CareActivityUnit *> *mutableUnits = [[NSMutableArray alloc] init];
    
    for (CareActivityUnit *unit in self.careActivitySection.activityUnits) {
        if ([unit.startDate compare:self.dateFilter] != NSOrderedAscending ) {
            [mutableUnits addObject:unit];
        }
    }
    return _careActivityUnits = (NSArray <CareActivityUnit *> *)[NSArray arrayWithArray:mutableUnits];    
}

#pragma mark - Data I/O

- (void)fetchActivityListData:(void (^)(BOOL reload))completion {
    [self.activityManager fetchActivityForSection:self.careActivitySection
                                       completion:^(CareActivitySection *section, NSArray *intervals) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               self.careActivitySection = section;
                                               
                                               if (completion) {
                                                   completion(YES);
                                               }
                                           });
                                       }];
}

- (void)updateCareDevices:(NSArray *)careDevices {
    NSMutableArray *mutableDevices = [[NSMutableArray alloc] initWithArray:careDevices];
    if ([mutableDevices containsObject:@"Summary"]) {
        [mutableDevices removeObject:@"Summary"];
    }
    [[[SubsystemsController sharedInstance] careController] setCareDevices:[NSArray arrayWithArray:mutableDevices]];
}

#pragma mark - IBActions

- (IBAction)dateButtonPressed:(id)sender {
    [self showDateSelectionPopUp];
}

#pragma mark - PopUp Handling

- (void)showDateSelectionPopUp {
    self.daySelectionView = [PopupSelectionDayView create:NSLocalizedString(@"Choose a day", @"")
                                          withNumberOfDay:kHistoryNumberOfDays];
    
    self.daySelectionWindow = [PopupSelectionWindow popup:self.view
                                                  subview:self.daySelectionView
                                                    owner:self
                                            closeSelector:@selector(dateFilterSelected:)];
}

- (void)dateFilterSelected:(NSDate *)selectedDate {
    self.dateFilter = selectedDate;
    
    _careActivitySection.endDate = [self convertDateToNextMidnight:self.dateFilter];
    _careActivitySection.startDate = [self convertDateToMidnightMinusOneHour:self.dateFilter];
    
    [self configureDateButton];
    [self reloadData];
}

- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createGif];
    });

    self.careActivitySection = nil;
    [self fetchActivityListData:(^(BOOL refresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideGif];
            if (refresh) {
                [self reloadUserInterface];
            }
        });
    })];
}

- (void)reloadUserInterface {
    
}

#pragma mark - CareActivityManagerDelegate 

- (void)careActivityManager:(CareActivityManager *)manager
receivedChangeEventNotification:(NSNotification *)notification {
    if ([self.dateFilter compare:[self convertDateToMidnight:[NSDate date]]] == NSOrderedSame) {
        [self reloadData];
    }
}

#pragma mark - Convenience Methods

- (NSDate *)convertDateToMidnight:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:[components day]];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)convertDateToMidnightMinusOneHour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:date];
    [components setHour:23];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:[components day] - 1];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)convertDateToNextMidnight:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour| NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:flags
                                               fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    [components setDay:[components day] + 1];
    
    return [calendar dateFromComponents:components];
}

@end
