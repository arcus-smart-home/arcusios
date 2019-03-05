//
//  CareStatusViewController.m
//  i2app
//
//  Created by Arcus Team on 1/21/16.
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
#import "CareSubsystemCapability.h"
#import "CareStatusViewController.h"
#import "DevicesAlarmRingView.h"
#import "SegmentModelsBuilder.h"
#import "RingTextContentsView.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"
#import "CareBehaviorsListViewController.h"
#import "ArcusSwitchTableViewCell.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"
#import "CareSubsystemControllerEnums.h"


#import "UIImage+ImageEffects.h"

#define MAIN_CELL_HEIGHT 70
#define SWITCH_CELL_HEIGHT 45

typedef NS_ENUM(NSInteger, CareStatusCellType) {
    CareStatusCellTypeBehaviors = 0,
    CareStatusCellTypeAlarmHistory,
    CareStatusCellTypeNotificationList,
    CareStatusCellTypeSwitch
};

NSString *const kCareStatusMainTextKey = @"mainText";
NSString *const kCareStatusImageKey = @"image";
NSString *const kCareStatusBehaviorsSegue = @"careBehaviorsSegue";
NSString *const kCareStatusAlarmHistorySegue = @"careAlarmHistorySegue";
NSString *const kCareStatusNotificationListSegue = @"careNotificationListSegue";

@interface CareStatusViewController ()

@property (weak, nonatomic) IBOutlet RingTextContentsView *ringContents;
@property (weak, nonatomic) IBOutlet DevicesAlarmRingView *ringView;

@end

@implementation CareStatusViewController {
    NSMutableArray *statusItems;
    BOOL isShowingSelectCell;
    CareAlarmMode alarmMode;
    int numberOfCareBehaviors;
    int numberOfActiveCareBehaviors;
}

#pragma mark - Creation
+ (CareStatusViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CareStatus" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareStatusViewController class])];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    statusItems = [NSMutableArray array];
    [statusItems addObject:@{kCareStatusMainTextKey : @"CARE BEHAVIORS", kCareStatusImageKey : [[UIImage imageNamed:@"care"] invertColor]}];
    [statusItems addObject:@{kCareStatusMainTextKey : @"CARE ALARM HISTORY", kCareStatusImageKey : [UIImage imageNamed:@"icon_alert"]}];
    [statusItems addObject:@{kCareStatusMainTextKey : @"ALARM NOTIFICATION LIST", kCareStatusImageKey : [UIImage imageNamed:@"CareNotificationIcon"]}];
    [self registerForNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)dealloc {
    [self deregisterForNotifications];
}

#pragma mark - Data
- (void)loadData {
    numberOfCareBehaviors = (int)[[SubsystemsController sharedInstance].careController numberOfBehaviors];
    numberOfActiveCareBehaviors = (int)[[SubsystemsController sharedInstance].careController numberOfActiveBehaviors];
    
    alarmMode = [[SubsystemsController sharedInstance].careController getCareAlarmMode];
    isShowingSelectCell = numberOfCareBehaviors > 0;
    
    [self updateUI];
}

#pragma mark - UI
- (void)updateUI {
    RunOnMain(^{
        [self updateRing];
        [self.tableView reloadData];
    })
}

- (void)updateRing {
    if (numberOfCareBehaviors == 0) {
        self.ringContents.mainText = NSLocalizedString(@"NO CARE BEHAVIORS ADDED", nil);
        self.ringContents.contentsStyle = RingTextContentsStyleSmallTextOnly;
    } else {
        switch (alarmMode) {
            case CareAlarmModeOn:
                self.ringContents.mainText = NSLocalizedString(@"ACTIVE BEHAVIORS", nil);
                self.ringContents.totalNumberOfDevices = [NSNumber numberWithInteger:numberOfCareBehaviors];
                self.ringContents.numberOfActiveDevices = [NSNumber numberWithInteger:numberOfActiveCareBehaviors];
                self.ringContents.contentsStyle = RingTextContentsStyleTextAndFractional;
                break;
                
            default:
                self.ringContents.mainText = NSLocalizedString(@"Off", nil);
                self.ringContents.contentsStyle = RingTextContentsStyleLargeTextOnly;
                break;
        }
    }

    [self.ringView setSegmentModels:[SegmentModelsBuilder ringSegmentsCareDevices]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isShowingSelectCell ? 4 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CareStatusCellType type = [self cellTypeForIndexPath:indexPath];
    UITableViewCell *cell;
    
    if (type == CareStatusCellTypeSwitch) {
        ArcusSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        switchCell.mainSwitch.on = (alarmMode == CareAlarmModeOn);
        [switchCell.mainSwitch addTarget:self action:@selector(alarmModeSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell = switchCell;
    } else {
        ArcusImageTitleDescriptionTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
        
        [mainCell.titleLabel setText:statusItems[type][kCareStatusMainTextKey]];
        [mainCell.detailImage setImage:statusItems[type][kCareStatusImageKey]];
        [mainCell.detailImage setTintColor:[UIColor whiteColor]];
        [mainCell.descriptionLabel setText:[self detailTextForCell:type]];
        
        cell = mainCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([self cellTypeForIndexPath:indexPath]) {
        case CareStatusCellTypeBehaviors:
            [self performSegueWithIdentifier:kCareStatusBehaviorsSegue sender:self];
            break;
        case CareStatusCellTypeAlarmHistory:
            [self performSegueWithIdentifier:kCareStatusAlarmHistorySegue sender:self];
            break;
        case CareStatusCellTypeNotificationList:
            [self performSegueWithIdentifier:kCareStatusNotificationListSegue sender:self];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight;
    
    switch ([self cellTypeForIndexPath:indexPath]) {
        case CareStatusCellTypeSwitch:
            rowHeight = SWITCH_CELL_HEIGHT;
            break;
            
        default:
            rowHeight = MAIN_CELL_HEIGHT;
            break;
    }
    
    return rowHeight;
}

#pragma mark - Target-action functions
- (void)alarmModeSwitchChanged:(id) sender {
    UISwitch *theSwitch = (UISwitch *) sender;
    CareAlarmMode newAlarmMode;
    
    if (theSwitch.on) {
        [ArcusAnalytics tagWithNamed: AnalyticsTags.CareAlarmOn];
        newAlarmMode = CareAlarmModeOn;
    } else {
        [ArcusAnalytics tagWithNamed: AnalyticsTags.CareAlarmOn];
        newAlarmMode = CareAlarmModeVisit;
    }
    
    [[SubsystemsController sharedInstance].careController setCareAlarmMode:newAlarmMode];
}

#pragma mark - Helpers
- (CareStatusCellType)cellTypeForIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return isShowingSelectCell ? CareStatusCellTypeSwitch : CareStatusCellTypeBehaviors;
            break;
        case 1:
            return isShowingSelectCell ? CareStatusCellTypeBehaviors : CareStatusCellTypeAlarmHistory;
        case 2:
            return isShowingSelectCell ? CareStatusCellTypeAlarmHistory : CareStatusCellTypeNotificationList;
        case 3:
            return CareStatusCellTypeNotificationList;
        default:
            return CareStatusCellTypeNotificationList;
            break;
    }
}

- (NSString *)detailTextForCell:(CareStatusCellType)type {
    NSString *returnString;
    
    switch (type) {
        case CareStatusCellTypeBehaviors:
            if (numberOfCareBehaviors == 0) {
                returnString =  NSLocalizedString(@"Add Care Behaviors", nil);
            } else {
                switch (alarmMode) {
                    case CareAlarmModeOn:
                        returnString = [NSString stringWithFormat:NSLocalizedString(@"%d of %d Active", nil), numberOfActiveCareBehaviors, numberOfCareBehaviors];
                        break;
                    case CareAlarmModeVisit:
                        returnString = NSLocalizedString(@"Disabled", nil);
                        break;
                }
                
            } 
            break;
        case CareStatusCellTypeAlarmHistory:
            returnString = [[SubsystemsController sharedInstance].careController lastTriggeredString];
            break;
        case CareStatusCellTypeNotificationList:
            returnString = [self subTextStringForNotificationList];
            break;
        case CareStatusCellTypeSwitch:
            break;
    }
    
    return returnString;
}

- (NSString *)subTextStringForNotificationList {
    NSString *subtext = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].careController getCallTree];
    
    if (callTree.count == 0) {
        subtext = NSLocalizedString(@"Learn How To Alert Others", @"");
    } else {
        subtext = [self subTextForCallTree];
    }

    return subtext;
}

- (NSString *)subTextForCallTree {
    NSString *callTreeSubText = nil;
    
    NSArray *callTree = [[SubsystemsController sharedInstance].careController getCallTree];
    
    BOOL firstEnabledFound = NO;
    
    NSInteger enabledCount = 0;
    
    for (NSDictionary *callTreeInfo in callTree) {
        if (callTreeInfo[@"person"] && [callTreeInfo[@"enabled"] boolValue]) {
            if (!firstEnabledFound) {
                callTreeSubText = [(PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:callTreeInfo[@"person"]] firstName];
                
                firstEnabledFound = YES;
            }
        }
        
        if ([callTreeInfo[@"enabled"] boolValue]) {
            enabledCount++;
        }
    }
    
    
        if (enabledCount >= 2) {
            callTreeSubText = [NSString stringWithFormat:@"%@ & %i More", callTreeSubText, (int)(enabledCount - 1)];
        } else if (enabledCount == 1){
             callTreeSubText = [NSString stringWithFormat:@"%@", callTreeSubText];
        }else {
            callTreeSubText = NSLocalizedString(@"Learn How To Alert Others", @"");
        }

    
    return callTreeSubText;
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:kSubsystemInitializedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:kSubsystemUpdatedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:[Model attributeChangedNotification:kAttrCareSubsystemAlarmMode]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:[Model attributeChangedNotification:kAttrCareSubsystemBehaviors]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:[Model attributeChangedNotification:kAttrCareSubsystemActiveBehaviors]
                                               object:nil];
}

- (void)deregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kSubsystemInitializedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kSubsystemUpdatedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Model attributeChangedNotification:kAttrCareSubsystemAlarmMode]
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Model attributeChangedNotification:kAttrCareSubsystemBehaviors]
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:[Model attributeChangedNotification:kAttrCareSubsystemActiveBehaviors]
                                                  object:nil];
}

@end
