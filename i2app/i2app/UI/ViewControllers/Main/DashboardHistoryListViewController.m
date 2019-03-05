//
//  DashboardHistoryListViewController.m
//  i2app
//
//  Created by Arcus Team on 8/5/15.
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
#import "DashboardHistoryListViewController.h"
#import "OrderedDictionary.h"
#import "PureLayout.h"
#import "CareActivityFullscreenViewController.h"
#import "NSDate+Convert.h"

#import "DashBoardHistoryManager.h"
#import "CareActivityCollectionViewCell.h"
#import "PopupSelectionDayView.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionDeviceView.h"
#import "CareActivityManager.h"
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"
#import "DeviceCapability.h"
#import "NSDate+Convert.h"


#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import "i2app-Swift.h"

NSString *kAllActivityTitle = @"ALL ACTIVITY";
NSString *kAllActivitySubtitle =@"All History Information";
NSString *kAllActivityImageName = @"DevicesIcon";

#define ESTIMATED_ROW_HEIGHT 70.0f
#define APPTENTIVE_DELAY_SEC 2

@implementation HistoryModel

+ (HistoryModel *)create:(NSNumber *)stamp deviceName:(NSString *)deviceName eventName:(NSString *)eventName {
    HistoryModel *model = [[HistoryModel alloc] init];
    [model setStamp:stamp];
    NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:(stamp.doubleValue / 1000)];
    [model setTime:[eventTime formatDateTimeStamp]];
    [model setDeviceName:deviceName];
    [model setEventName:eventName];
    return model;
}

@end


// Dashboard history list view controller
@interface DashboardHistoryListViewController () <UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ArcusModalSelectionDelegate, CareActivityManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DashboardHistoryLoadingCell *footerView;
@property (nonatomic, weak) IBOutlet UICollectionView *activityCollectionView;
@property (nonatomic, weak) IBOutlet UIButton *dateButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
///A Label anchored in the center of the graph section of the header
@property (weak, nonatomic) IBOutlet UILabel *heroLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *graphViews;
@property (nonatomic, weak) IBOutlet UIButton *showAllButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *graphContainer;
@property (nonatomic, strong) PopupSelectionDayView *daySelectionView;
@property (nonatomic, strong) PopupSelectionWindow *daySelectionWindow;

@property (nonatomic, strong) CareActivityManager *activityManager;
@property (nonatomic, strong) CareActivitySection *careActivitySection;
@property (nonatomic, strong) NSArray <CareActivityUnit *> *careActivityUnits;
@property (nonatomic, strong) NSArray *careDevicesArray;
@property (nonatomic, strong) NSArray *filteredDevices;
@property (nonatomic, strong) NSDate *dateFilter;

@property (strong) NSArray *historyList;
@property (nonatomic) BOOL isFilteredByDevice;
@property (nonatomic) BOOL isGraphDisplaying;
@property (nonatomic) BOOL isGraphNoData;

@property BOOL stopLoadNext;

- (void)configureDateButton;
- (void)setDateButtonText:(NSString *)string;
- (void)fetchActivityListData:(void (^)(BOOL reload))completion;
- (void)reloadData;
- (void)reloadUserInterface;
- (void)showDateSelectionPopUp;
- (void)moveCollectionViewToEndPosition:(UICollectionView *)collectionView
                               endIndex:(NSInteger)index;
- (NSInteger)indexOfUnitForCurrentTime;

- (IBAction)dateButtonPressed:(id)sender;

@end

@implementation DashboardHistoryListViewController

NSString *const kHistoryActivityImageCachePrefix = @"CareActivityVC:";

+ (DashboardHistoryListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stopLoadNext = NO;
    self.isFilteredByDevice = NO;
    self.isGraphNoData = NO;
    self.isGraphDisplaying = [[CorneaHolder shared] settings].isPremiumAccount;
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"History", nil) uppercaseString]];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    self.activityCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self fetchActivityListData:(^(BOOL refresh){
        if (refresh) {
            [self reloadUserInterface];
        }
    })];
    
    [DashBoardHistoryManager shareInstance].maximumFilterDate = [self calculateMaximumDate];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self buildFooterView];
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4f]];
    self.tableView.estimatedRowHeight = ESTIMATED_ROW_HEIGHT;
    [self configureFooterView];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self configureDateButton];
    [self configureGraphSection];
    self.activityManager.delegate = self;
    if (self.isGraphDisplaying == NO) {
        self.graphHeightConstraint.constant = 0;
        [self.graphContainer setHidden:YES];
        //http://stackoverflow.com/a/20927069/283460
        [self.view setNeedsLayout];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    [self fireApptentiveAfterDelay];
}

- (void)buildFooterView {
    DashboardHistoryLoadingCell *loadingCell = [self.tableView dequeueReusableCellWithIdentifier:@"loadingCell"];
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [loadingCell setBackgroundColor:[UIColor clearColor]];
    self.footerView = loadingCell;
}

- (void)fireApptentiveAfterDelay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, APPTENTIVE_DELAY_SEC * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
      if (delegate != nil && [[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil] isKindOfClass:[DashboardHistoryListViewController class]]) {
        [ArcusAnalytics tag: AnalyticsTags.DashboardHistoryClick attributes: @{}];
      }
    });
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    DashboardHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    HistoryModel *model = [self.historyList objectAtIndex:row];
    [cell setAttribute:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BOOL isLastRow = indexPath.row == self.historyList.count - 1;
    if (isLastRow && [[DashBoardHistoryManager shareInstance] hasMorePages]) {
        [self loadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma CorneaCall to get data

- (void)loadData {
    if (self.stopLoadNext == YES) {
        return;
    }
    self.stopLoadNext = YES;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[DashBoardHistoryManager shareInstance] getHistoriesMatchedFilter]
        .then(^(NSArray *theHistoryList) {
            self.stopLoadNext = NO;
            self.historyList = theHistoryList;
            [self configureFooterView];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Getters & Setters

- (void)setFilteredDevicesWithIndexArray:(NSArray *)selectedIndexes {
    ArcusModalSelectionModel *selectionModel = selectedIndexes.firstObject;
    if ([selectionModel.title isEqualToString:kAllActivityTitle]){
        self.filteredDevices = @[];
        self.careActivitySection.filterDevices = [[[SubsystemsController sharedInstance] careController] allDeviceIds];
        self.isFilteredByDevice = NO;
        self.isGraphNoData = NO;
    }
    else if (selectionModel.deviceAddress){
        if ([self.careDevicesArray containsObject:selectionModel.deviceAddress]) {
            self.careActivitySection.filterDevices = @[selectionModel.deviceAddress];
            self.isGraphNoData = NO;
        }
        else {
            self.isGraphNoData = YES;
        }
        self.isFilteredByDevice = YES;
        self.filteredDevices = @[selectionModel.deviceAddress];
    }
}

#pragma mark - Data I/O

- (void)fetchActivityListData:(void (^)(BOOL reload))completion {
    [self firstFetchActivityListData:(^(BOOL reload) {
        [self fetchActivityListDetails:^(BOOL listReload) {
            if (completion) {
                completion(reload);
            }
        }];
    })];
}

- (void)fetchActivityListDetails:(void (^)(BOOL listReload))completion {
    if (![self.careActivitySection.detailsToken isKindOfClass:[NSNull class]]) {
        NSDate *tokenDate = [NSDate dateWithTimeIntervalSince1970:[self.careActivitySection.detailsToken doubleValue] / 1000.0];
        if ([tokenDate compare:self.careActivitySection.startDate] != NSOrderedAscending) {
            [self.activityManager fetchActivityDetailForSection:self.careActivitySection
                                                     completion:^(CareActivitySection *section, NSArray *evnts) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             self.careActivitySection = section;
                                                             if (completion) {
                                                                 completion(YES);
                                                             }
                                                         });
                                                     }];
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

- (void)firstFetchActivityListData:(void (^)(BOOL reload))completion {
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.careActivityUnits count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    CareActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                     forIndexPath:indexPath];
    
    CareActivityUnit *activityUnit = self.careActivityUnits[indexPath.row];
    
    if (activityUnit) {
        NSString *time = [activityUnit.startDate formatDateTimeStamp];
        
        cell.titleLabel.attributedText = [cell attributeTimeString:time];
        
        cell.graphView.graphStyle = ActivityGraphUnitTypeSolid;
        [cell configureActivityGraphView:(NSArray <ActivityGraphViewUnitProtocol> *)activityUnit.unitIntervals];
    }
    
    return cell;
}

#pragma mark - ArcusModalSelection Convienence Methods

- (NSArray *)deviceFilterSelectionArray {
    NSMutableArray *mutableSelectionInfo = [[NSMutableArray alloc] init];
    NSArray *devices = [DeviceManager instance].devices;
    for (DeviceModel *device in devices) {
        ArcusModalSelectionModel *selectionModel = [ArcusModalSelectionModel selectionModelForDevice:device];
        selectionModel.isSelected = [self.filteredDevices containsObject:[device address]];
        [mutableSelectionInfo addObject:selectionModel];
    }
    
    ArcusModalSelectionModel *selectAllModel = [[ArcusModalSelectionModel alloc] init];
    selectAllModel.title = kAllActivityTitle;
    selectAllModel.itemDescription = kAllActivitySubtitle;
    selectAllModel.image = [[UIImage imageNamed:kAllActivityImageName] invertColor];
    selectAllModel.isSelectAll = YES;
    selectAllModel.isSelected = !self.isFilteredByDevice;
    
    mutableSelectionInfo = [NSMutableArray arrayWithArray:[mutableSelectionInfo sortedArrayUsingComparator:^(ArcusModalSelectionModel *a, ArcusModalSelectionModel *b) {
        return [a.title caseInsensitiveCompare:b.title];
    }]];
    [mutableSelectionInfo insertObject:selectAllModel atIndex:0];
    return [NSArray arrayWithArray:mutableSelectionInfo];
}

#pragma mark - UI Configuration

- (void)configureGraphSection {
    if (!self.isGraphDisplaying) {
        [self.fullScreenButton setHidden:YES];
        return;
    }
    if (self.isGraphNoData){
        [self.graphViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setHidden:YES];
        }];
        [self.heroLabel setHidden:NO];
        [self.fullScreenButton setHidden:YES];
        self.heroLabel.text = NSLocalizedString(@"Activity Graph is limited to Contact, Motion, & Tilt sensors.", @"Title when Activity Graph is limited in History");
    } else {
        [self.graphViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setHidden:NO];
        }];
        [self.fullScreenButton setHidden:NO];
        [self.heroLabel setHidden:YES];
    }
}

- (void)configureDateButton {
    self.dateButton.layer.cornerRadius = 4.0f;
    self.dateButton.layer.borderWidth = 1.0f;
    self.dateButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setDateButtonText:[self dateStringForDate:self.dateFilter]];
}

- (void)configureFooterView {
    if (self.historyList.count == 0) {
        self.tableView.tableFooterView = self.footerView;
        if (self.isFilteredByDevice) {
            NSString *deviceAddr = self.filteredDevices.firstObject;
            DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddr];
            NSString *deviceName = [DeviceCapability getNameFromModel:device];
            self.footerView.noHistoryLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Device-No-History-Format", @""), deviceName];
        } else {
            self.footerView.noHistoryLabel.text = NSLocalizedString(@"All-No-History-Text", nil);
        }
    } else {
        self.tableView.tableFooterView = [UIView new];
    }
    [self.tableView reloadData];
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
    NSAttributedString *buttonTitle =
    [[NSAttributedString alloc] initWithString:[string uppercaseString]
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

- (void)moveActivityCollectionViewScrollPositionToCurrent {
    [self moveCollectionViewToEndPosition:self.activityCollectionView
                                 endIndex:[self indexOfUnitForCurrentTime]];
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
        _careActivitySection.filterDevices = [[[SubsystemsController sharedInstance] careController] allDeviceIds];
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
        _filteredDevices = [NSArray new];
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



#pragma mark - IBActions

- (IBAction)dateButtonPressed:(id)sender {
    [self showDateSelectionPopUp];
}

#pragma mark - PopUp Handling

- (void)showDateSelectionPopUp {
    self.daySelectionView = [PopupSelectionDayView create:NSLocalizedString(@"Choose a day", @"")
                                          withNumberOfDay:[self numberOfDaysForHistory]];
    
    self.daySelectionWindow = [PopupSelectionWindow popup:self.view
                                                  subview:self.daySelectionView
                                                    owner:self
                                            closeSelector:@selector(dateFilterSelected:)];
}

- (void)dateFilterSelected:(NSDate *)selectedDate {
    self.dateFilter = selectedDate;
    self.careActivitySection.endDate = [self convertDateToNextMidnight:self.dateFilter];
    self.careActivitySection.startDate = [self convertDateToMidnightMinusOneHour:self.dateFilter];
    [self configureDateButton];
    [self reloadData];
}

///Assume that all the state needed to reload the data has already been set
- (void)reloadData {
    //Table View Loading
    if(self.isFilteredByDevice){
        [[DashBoardHistoryManager shareInstance] setFilterDay:self.dateFilter device:self.filteredDevices.firstObject];
    } else {
        [[DashBoardHistoryManager shareInstance] setFilterDay:self.dateFilter device:nil];
    }
    self.historyList = [NSArray new];
    [self.tableView reloadData];
    [self loadData];
    [self configureGraphSection];
    //Collection View Loading
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createGif];
    });
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityCollectionView reloadData];
        [self moveActivityCollectionViewScrollPositionToCurrent];
    });
}

#pragma mark - ArcusModalSelectionDelegate

- (void)modalSelectionController:(UIViewController *)selectionController
    didDismissWithSelectedModels:(NSArray<ArcusModalSelectionModel *> *)selectedIndexes {
    [self setFilteredDevicesWithIndexArray:selectedIndexes];
    [self reloadData];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ActivityFilterMenuSegue"]) {
        [ArcusAnalytics tag:AnalyticsTags.HistoryFilterDevice attributes:@{}];
        ArcusModalSelectionViewController *filterSelectionViewController = (ArcusModalSelectionViewController *)segue.destinationViewController;
        filterSelectionViewController.delegate = self;
        filterSelectionViewController.allowMultipleSelection = NO;
        filterSelectionViewController.selectionArray = [self deviceFilterSelectionArray];
    }
    else if ([segue.identifier isEqualToString:@"ActivityFullscreenModalSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CareActivityFullscreenViewController *activityFullscreenViewController = (CareActivityFullscreenViewController *)navigationController.topViewController;
        activityFullscreenViewController.dateFilter = self.dateFilter;
        
        if (self.isFilteredByDevice) {
            activityFullscreenViewController.filteredDevices = self.filteredDevices;
        }
        else {
            activityFullscreenViewController.filteredDevices = [[[SubsystemsController sharedInstance] careController] allDeviceIds];
        }
        
        activityFullscreenViewController.activityManager = self.activityManager;
        activityFullscreenViewController.activityManager.delegate = activityFullscreenViewController;
        [activityFullscreenViewController fetchActivityListData:(^(BOOL refresh){
            if (refresh) {
                [activityFullscreenViewController reloadUserInterface];
            }
        })];
    }
}


#pragma mark - CareActivityManagerDelegate

- (void)careActivityManager:(CareActivityManager *)manager
receivedChangeEventNotification:(NSNotification *)notification {
    if ([self.dateFilter compare:[self convertDateToMidnight:[NSDate date]]] == NSOrderedSame) {
        [self reloadData];
    }
}

#pragma mark - Convenience Methods

- (NSUInteger)numberOfDaysForHistory {
    if ([[CorneaHolder shared] settings].isPremiumAccount){
        return 14;
    } else {
        return 2;
    }
}

- (NSDate *)calculateMaximumDate {
    if ([[CorneaHolder shared] settings].isPremiumAccount) {
        return [NSDate distantPast];
    } else {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -60 * 60 * 24];
        return yesterday;
    }
}

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


@implementation DashboardHistoryListCell

- (void)setAttribute:(HistoryModel *)model {
    self.timeLabel.text = model.time;
    self.deviceLabel.text = model.deviceName;
    self.eventLabel.text = model.eventName;
}

@end

@implementation DashboardHistoryLoadingCell

@end
