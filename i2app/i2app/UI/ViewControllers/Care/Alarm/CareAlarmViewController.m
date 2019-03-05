//
//  CareAlarmViewController.m
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "CareAlarmViewController.h"

#import "CareAlarmBaseViewController.h"
#import "ArcusAlarmHistoryListCell.h"
#import "AlarmConfiguration.h"

#import "SubsystemCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"
#import "PlaceCapability.h"
#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"

#import "UIImage+ImageEffects.h"
#import "NSDate+Convert.h"




#import "OrderedDictionary.h"
#import <PureLayout/PureLayout.h>
#import "RulesController.h"
#import "RuleCapability.h"
#import "Capability.h"
#import "CareAlarmTransitionAnimator.h"
#import "ArcusLabel.h"

@interface CareAlarmHistoryObject : NSObject

@property(nonatomic, strong) NSString *timeText;
@property(nonatomic, strong) NSString *headerText;
@property(nonatomic, strong) NSString *descriptionText;
@property(nonatomic) BOOL isBehavior;

@end

@implementation CareAlarmHistoryObject

@end

@interface CareAlarmViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *cancelBarAreaView;
@property (weak, nonatomic) IBOutlet UIView *AlarmView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmDeviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceEvent;

@property (strong, nonatomic) UILabel *mainRingLabel;
@property (strong, nonatomic) UILabel *titleRingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallwaveLeftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *smallwaveRightIcon;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *event;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

@property (assign, nonatomic) AlarmType type;
@property (strong, nonatomic) NSMutableArray<CareAlarmHistoryObject *> *history;

@property (weak, nonatomic) IBOutlet ArcusLabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *placeAddressLabel;

@end

@implementation CareAlarmViewController

#pragma mark - Creation

+ (void)createWithCompletionBlock:( void (^_Nonnull) (CareAlarmViewController*))completionBlock{
  CareAlarmViewController *vc = [CareAlarmViewController createWithStoryboard:@"CareAlarm" title:@"Care Alarm" borderColor:purpleAlertColor type:AlarmTypeCare];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [[SubsystemsController sharedInstance].careController listBehaviors].thenInBackground(^(NSArray<CareBehaviorModel *> *behaviors) {
      vc.existingBehaviors = behaviors;
      [RulesController listRulesWithPlaceId:[[[CorneaHolder shared] settings].currentPlace getAttribute:kAttrId]].then(^(NSArray *rules) {
        vc.existingRules = [[[CorneaHolder shared] modelCache] fetchModels:[RuleCapability namespace]];
        RunOnMain(^{
          completionBlock(vc);
        })
      });
    });
  });
}

+ (CareAlarmViewController *)createWithOwner:(CareAlarmBaseViewController *)owner alarmType:(AlarmType)type name:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color  {
    CareAlarmViewController *vc = [[UIStoryboard storyboardWithName:@"CareAlarm" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.name = name;
    vc.event = event;
    vc.icon = icon;
    vc.color = color;
    vc.owner = owner;
    vc.type = type;
    
    return vc;
}

+ (CareAlarmViewController *)createWithStoryboard:(NSString *)storyboard title:(NSString *)title borderColor:(UIColor *)color type:(AlarmType)type{
    CareAlarmViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.color = color;
    
    vc.event = @"ALARM";
    vc.type = type;
    vc.icon = [[UIImage imageNamed:@"icon_unfilled_care"] invertColor];
    
    return vc;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(careAlarmStateChanged:)
                                                 name: [Model attributeChangedNotification:kAttrCareSubsystemAlarmState]
                                               object:nil];
    [self UIconfig];
    [self processDataUpdateUI];
}

- (void)UIconfig {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if(self.viewTitle == nil) {
        [self setViewTitle:@"CARE ALARM"];
    }
    [self navBarWithBackButtonAndTitle:self.viewTitle];
    
    self.alarmDeviceIcon.tintColor = [UIColor blackColor];
    
    _AlarmView.layer.cornerRadius = _AlarmView.frame.size.width / 2.0f;
    _AlarmView.layer.borderColor = _color.CGColor;
    _AlarmView.layer.borderWidth = 20.0f;
    _AlarmView.layer.shadowColor = _color.CGColor;
    _AlarmView.layer.masksToBounds = NO;
    _AlarmView.layer.shadowOffset = CGSizeMake(0, 0);
    _AlarmView.layer.shadowRadius = 15.0f;
    _AlarmView.layer.shadowOpacity = 1.0f;
    
    [self.smallwaveLeftIcon setImage:[[UIImage imageNamed:@"smallwavesLeft"] invertColor]];
    [self.smallwaveRightIcon setImage:[[UIImage imageNamed:@"smallwavesRight"] invertColor]];
    
    self.cancelBarAreaView.backgroundColor = [_color colorWithAlphaComponent:0.6];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data methods
- (void)processDataUpdateUI {
    NSString *lastAlertCauseAddress = [[SubsystemsController sharedInstance].careController getLastAlertCause];
    NSDictionary *lastAlertTriggers = [[SubsystemsController sharedInstance].careController getLastAlertTrigger];
    NSString *alarmTitle;
    UIImage *alarmImage;
    
    BOOL isRuleCause = NO;
    BOOL isBehaviorCause = NO;
    id causeModel = nil;
    
    for (RuleModel *rule in self.existingRules) {
        if ([rule.address isEqualToString:lastAlertCauseAddress]) {
            causeModel = rule;
            isRuleCause = YES;
            break;
        }
    }
    
    if (!isRuleCause) {
        for (CareBehaviorModel *behavior in self.existingBehaviors) {
            if ([behavior.identifier isEqualToString:lastAlertCauseAddress]) {
                causeModel = behavior;
                isBehaviorCause = YES;
                break;
            }
        }
    }
    
    if (isRuleCause) {
        RuleModel *rule = (RuleModel *)causeModel;
        alarmTitle = [rule getAttribute:kAttrRuleName];
        alarmImage = [UIImage imageNamed:@"icon_rules"];
    } else if (isBehaviorCause) {
        CareBehaviorModel *behavior = (CareBehaviorModel *)causeModel;
        alarmTitle = behavior.name;
        alarmImage = [[UIImage imageNamed:@"icon_unfilled_care"] invertColor];
    } else {
        alarmTitle = NSLocalizedString(@"Panic", nil);
        alarmImage = [UIImage imageNamed:@"icon_rules"];
    }
    
    [self generateTableHistoryDataForLastCauseModel:causeModel
                                withLastCauseString:lastAlertCauseAddress
                                    andLastTriggers:lastAlertTriggers];
    
    self.alarmDeviceName.text = alarmTitle;
    self.alarmDeviceIcon.image = alarmImage;
    
    self.placeNameLabel.text = [[CorneaHolder shared] settings].currentPlace.getName;
    self.placeAddressLabel.text = [PlaceCapability getStreetAddress1FromModel:[[CorneaHolder shared] settings].currentPlace];
    
    [self.tableView reloadData];
}

- (id)getModelForTriggerAddress:(NSString *)address {
    for (RuleModel *rule in self.existingRules) {
        if ([rule.address isEqualToString:address]) {
            return rule;
        }
    }
    
    for (CareBehaviorModel *behavior in self.existingBehaviors) {
        if ([behavior.identifier isEqualToString:address]) {
            return behavior;
        }
    }
    
    return nil;
}

- (void)generateTableHistoryDataForLastCauseModel:(id)lastAlertCauseModel withLastCauseString:lastCauseString andLastTriggers:(NSDictionary *)lastAlertTriggers {
    self.history = [NSMutableArray array];
    NSMutableDictionary *lastAlertTriggersDictionary = [NSMutableDictionary dictionaryWithDictionary:lastAlertTriggers];
    
    [self generateHistoryObjectsForModel:lastAlertCauseModel withKey:lastCauseString andLastAlertTriggers:lastAlertTriggersDictionary];
    lastAlertTriggersDictionary[lastCauseString] = nil;
    
    NSMutableArray *sortedTriggers = [NSMutableArray array];
    for (NSString *key in lastAlertTriggersDictionary.keyEnumerator) {
        [sortedTriggers addObject:key];
    }
    [sortedTriggers sortUsingComparator:^NSComparisonResult(NSString *address1, NSString *address2) {
        NSString *dateString1 = lastAlertTriggersDictionary[address1];
        NSString *dateString2 = lastAlertTriggersDictionary[address2];
        NSInteger dateNum1 = dateString1.integerValue;
        NSInteger dateNum2 = dateString2.integerValue;
        
        if (dateNum1 > dateNum2) {
            return NSOrderedDescending;
        } else if (dateNum1 == dateNum2) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    for (NSString *modelID in sortedTriggers) {
        [self generateHistoryObjectsForModel:[self getModelForTriggerAddress:modelID] withKey:modelID andLastAlertTriggers:lastAlertTriggersDictionary];
        lastAlertTriggersDictionary[modelID] = nil;
    }
}

- (void)generateHistoryObjectsForModel:(id)model withKey:(NSString *)key andLastAlertTriggers:(NSDictionary *)lastAlertTriggers {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"h:mm a";
    }
    
    if (model) {
        if ([model isKindOfClass:[CareBehaviorModel class]]) {
            CareBehaviorModel *behavior = (CareBehaviorModel *)model;
            CareAlarmHistoryObject *careObject = [CareAlarmHistoryObject new];
            careObject.headerText = NSLocalizedString(@"ALARM TRIGGERED", nil);
            // Display nothing instead of "by (null)"
            careObject.descriptionText = behavior.name ? [NSString stringWithFormat:NSLocalizedString(@"by %@", nil), behavior.name] : @"";
            careObject.isBehavior = YES;
            
            NSNumber *timeStamp = lastAlertTriggers[key];
            if (timeStamp) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
                careObject.timeText = [dateFormatter stringFromDate:date];
            }
            
            [self.history insertObject:careObject atIndex:0];
        } else if ([model isKindOfClass:[RuleModel class]]) {
            RuleModel *rule = (RuleModel *)model;
            CareAlarmHistoryObject *careObject1 = [CareAlarmHistoryObject new];
            CareAlarmHistoryObject *careObject2 = [CareAlarmHistoryObject new];
            careObject1.headerText = NSLocalizedString(@"ALARM TRIGGERED", nil);
            // Display nothing instead of "by (null)"
            careObject1.descriptionText = [rule getAttribute:kAttrRuleName] ? [NSString stringWithFormat:NSLocalizedString(@"by %@", nil), [rule getAttribute:kAttrRuleName]] : @"";
            careObject1.isBehavior = NO;
            
            NSNumber *timeStamp = lastAlertTriggers[key];
            if (timeStamp) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
                NSString *dateString = [dateFormatter stringFromDate:date];
                careObject1.timeText = dateString;
                careObject2.timeText = dateString;
            }
            
            careObject2.headerText = NSLocalizedString(@"RULE TRIGGERED", nil);
            NSString *deviceTriggerName;
            NSDictionary *ruleContext = [rule getAttribute:kAttrRuleContext];
            for (NSString *key in ruleContext.keyEnumerator) {
                NSString *potentialAddress = ruleContext[key];
                if ([potentialAddress isKindOfClass:[NSString class]] && potentialAddress.length > 9) {
                    potentialAddress = [potentialAddress substringFromIndex:9];
                    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:potentialAddress];
                    if (device) {
                        deviceTriggerName = device.name;
                        break;
                    }
                }
            }
            careObject2.descriptionText = deviceTriggerName ? [NSString stringWithFormat:NSLocalizedString(@"by %@", nil), deviceTriggerName] : @"";
            careObject2.isBehavior = NO;
            
            [self.history insertObject:careObject1 atIndex:0];
            [self.history insertObject:careObject2 atIndex:0];
        } else {
            CareAlarmHistoryObject *careObject = [CareAlarmHistoryObject new];
            careObject.headerText = NSLocalizedString(@"Triggered", nil);
            careObject.descriptionText = NSLocalizedString(@"by Panic", nil);
            careObject.isBehavior = NO;
            
            NSNumber *timeStamp = lastAlertTriggers[key];
            if (timeStamp) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
                NSString *dateString = [dateFormatter stringFromDate:date];
                careObject.timeText = dateString;
            }
            [self.history insertObject:careObject atIndex:0];
        }
    } else {
        CareAlarmHistoryObject *careObject = [CareAlarmHistoryObject new];
        careObject.headerText = NSLocalizedString(@"Triggered", nil);
        careObject.descriptionText = NSLocalizedString(@"by Panic", nil);
        careObject.isBehavior = NO;
        
        NSNumber *timeStamp = lastAlertTriggers[key];
        if (timeStamp) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.doubleValue/1000];
            NSString *dateString = [dateFormatter stringFromDate:date];
            careObject.timeText = dateString;
        }
        [self.history insertObject:careObject atIndex:0];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusAlarmHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    CareAlarmHistoryObject *historyObject = self.history[indexPath.row];
    
    cell.timeLabel.text = historyObject.timeText;
    cell.titleLabel.text = historyObject.headerText;
    cell.subtitleLabel.text = historyObject.descriptionText;
    cell.iconImage.image = historyObject.isBehavior ? [[UIImage imageNamed:@"icon_unfilled_care"] invertColor] : [UIImage imageNamed:@"icon_rules"];
    cell.iconImage.tintColor = [UIColor blackColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Notification selectors
- (void)careAlarmStateChanged:(NSNotification *)notification {
    BOOL alarmTriggered = [[SubsystemsController sharedInstance].careController isAlarmTriggered];
    if (alarmTriggered == YES) { return; }
    RunOnMain(^{
        CareTabBarController *tabBarController = [[CareTabBarController alloc] initWithTitle:NSLocalizedString(@"CARE",nil)];
        tabBarController.shouldShowStatusOnAppear = YES;
        UIViewController *rootVC = self.navigationController.viewControllers[0];
        NSMutableArray *newNavStack = [NSMutableArray array];
        if (tabBarController && rootVC) {
            [newNavStack addObject:self.navigationController.viewControllers[0]];
            [newNavStack addObject:tabBarController];
//            [newNavStack addObject:self];
            self.navigationController.delegate = self;
            [self.navigationController setViewControllers:newNavStack animated:NO];
//            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    })
}

#pragma mark - IBAction methods
- (IBAction)onClickCancel:(id)sender {
    self.isAlarming = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].careController == nil) {
            return;
        }
        
        [[SubsystemsController sharedInstance].careController clear].then(^{
            RunOnMain(^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        });
    });
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    return [CareAlarmTransitionAnimator new];
}

@end
