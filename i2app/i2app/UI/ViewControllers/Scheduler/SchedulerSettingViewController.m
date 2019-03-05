//
//  SchedulerSettingViewController.m
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
#import "SchedulerSettingViewController.h"

#import "CommonTitleValueonRightCell.h"
#import "CommonTitleWithSwitchCell.h"
#import "NSDate+Convert.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionButtonsView.h"
#import "ScheduleController.h"
#import "ScheduledEventModel.h"
#import "RuleScheduledEventModel.h"
#import "LawnNGardenScheduleController.h"
#import "DimmerCapability.h"
#import "SwitchCapability.h"

#import <i2app-Swift.h>

@implementation SchedulerSettingOption

+ (SchedulerSettingOption *)createSwitch:(NSString *)title isChecked:(BOOL)checked eventOwner:(id)owner onClick:(SEL)onclick {
    SchedulerSettingOption *option = [[SchedulerSettingOption alloc] init];
    [option setOptionType:ScheduledOptionTypeSwitch];
    [option setTitle:title];
    [option setIsChecked:checked];
    [option setEventOwner:owner];
    [option setOnClick:onclick];
    return option;
}

+ (SchedulerSettingOption *)createSideValue:(NSString *)title sideValue:(NSString *)side eventOwner:(id)owner onClick:(SEL)onclick {
    SchedulerSettingOption *option = [[SchedulerSettingOption alloc] init];
    [option setOptionType:ScheduledOptionTypeSideOption];
    [option setTitle:title];
    [option setSideValue:side];
    [option setEventOwner:owner];
    [option setOnClick:onclick];
    return option;
}

- (SchedulerSettingOption *)setDescription:(NSString *)text {
    self.subtitle = text;
    return self;
}

- (SchedulerSettingOption *)setTag:(NSInteger)tag {
    _tag = tag;
    return self;
}

@end


@interface SchedulerSettingViewController () <ScheduledEventModelDelegate>


@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *openRepeatView;
@property (weak, nonatomic) IBOutlet UIView *repeatViewSeparator;
@property (weak, nonatomic) IBOutlet UILabel *repeatIntroLabel;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;


@property (strong, nonatomic, readonly) ScheduledEventModel *scheduledEventModel;
@property (strong, nonatomic, readonly) ScheduledEventModel *updatedEventModel;
@property (nonatomic) ScheduleRepeatType localEventDay;
@property (nonatomic, readonly) BOOL isNewModel;

@end

@implementation SchedulerSettingViewController {
    NSMutableArray <SchedulerSettingOption *>*_settingItems;
    PopupSelectionWindow    *_popupWindow;
    
    __weak IBOutlet NSLayoutConstraint *_saveBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *_titleHeightConstraint;
}

@dynamic scheduledEventModel;
@dynamic updatedEventModel;
@dynamic isNewModel;

+ (SchedulerSettingViewController *)createNewEventInWithEventDay:(ScheduleRepeatType)eventDay {
    SchedulerSettingViewController *vc = [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    vc.localEventDay = eventDay;
    
    ScheduleController.scheduleController.scheduledEventModel = [ScheduleController.scheduleController createNewEventItem:eventDay withDelegate:vc];
    return vc;
}

+ (SchedulerSettingViewController *)createWithEventModel:(ScheduledEventModel *)model  {
    SchedulerSettingViewController *vc = [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    model.delegate = vc;
    
    ScheduleController.scheduleController.scheduledEventModel = model;
    
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[@"WEEKLY" uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    [self addOverlay:!self.isNewModel];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    if (ScheduleController.scheduleController.isWeeklySchedule) {
        [self navBarWithBackButtonAndTitle:[ScheduledEventModel getWeekDayForDayType:self.scheduledEventModel.eventDay]];
    }
    else {
        self.openRepeatView.hidden = YES;
        [self navBarWithBackButtonAndTitle:[ScheduleController.scheduleController scheduleViewControllerNavBarTitle]];
    }
    ScheduleController.scheduleController.updatedEventModel = self.scheduledEventModel.copy;
    
    NSString *settingTitle = [ScheduleController.scheduleController getSchedulerSettingViewControllerSubheader];
    if (settingTitle.length > 0) {
        _titleHeightConstraint.constant = 150;
        [self.titleLabel styleSet:settingTitle andFontData:[FontData createFontData:FontTypeDemiBold size:18 blackColor:self.isNewModel]];
    }
    else {
        _titleHeightConstraint.constant = 1;
        self.titleLabel.text = @"";
    }
    
    self.repeatButton.layer.cornerRadius = 4.0f;
    self.repeatButton.layer.borderWidth = 1.0f;
    
    if (self.isNewModel) {
        [self.saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonDark upperCase:YES];
        [self.removeButton setHidden:YES];
        _saveBottomConstraint.constant = 14;
    }
    else {
        [self.saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonLight upperCase:YES];
        [self.removeButton styleSet:@"Remove" andButtonType:FontDataTypeButtonPink upperCase:YES];
    }
    
    [self.repeatDescriptionLabel setText:[ScheduleController.scheduleController.scheduledEventModel getRepeatDescription]];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

#pragma mark - Dynamic Properties
- (ScheduledEventModel *)scheduledEventModel {
    return ScheduleController.scheduleController.scheduledEventModel;
}

- (ScheduledEventModel *)updatedEventModel {
    return ScheduleController.scheduleController.updatedEventModel;
}

- (BOOL)isNewModel {
    return ScheduleController.scheduleController.scheduledEventModel.isNewModel;
}

- (void)reloadData {
    _settingItems = [[NSMutableArray alloc] init];
    

    [_settingItems addObjectsFromArray:[self.updatedEventModel getScheduleEventOptions]];
    
    SchedulerSettingOption *timeOption = [[SchedulerSettingOption createSideValue:[self.scheduledEventModel timeTitle]
                                                                        sideValue:[self.updatedEventModel.eventTime formatDateTimeStamp]
                                                                       eventOwner:self
                                                                          onClick:@selector(chooseStartTime)] setTag:-1];
    if ([self.updatedEventModel timeDescription].length > 0) {
        [timeOption setDescription:[self.updatedEventModel timeDescription]];
    }
    
    [_settingItems insertObject:timeOption atIndex:[self.updatedEventModel indexOfTimeOption]];
    
    if (ScheduleController.scheduleController.isWeeklySchedule) {
        if ([self hasRepeat]) {
            [_settingItems addObject:[[SchedulerSettingOption createSideValue:@"Repeat On"
                                                                    sideValue:(_localEventDay > 0 ?
                                                                               [ScheduledEventModel generateStringOfRepeatDays:_localEventDay]:
                                                                               [ScheduledEventModel generateStringOfRepeatDays:[self.updatedEventModel repeatDays]])
                                                                   eventOwner:self
                                                                      onClick:@selector(chooseRepeatDays)] setTag:-2]];
            
            self.openRepeatView.hidden = YES;
            [self.tableView setTableFooterView:[[UIView alloc] init]];
        }
        else {
            self.openRepeatView.hidden = NO;
            [self.tableView setTableFooterView:self.openRepeatView];
            if (self.isNewModel) {
                [self.repeatButton styleSet:@"Repeat" andButtonType:FontDataType_Medium_13_Black upperCase:YES];
                self.repeatButton.layer.borderColor = [UIColor blackColor].CGColor;
                self.repeatIntroLabel.textColor = [UIColor blackColor];
                
                [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
                [self.repeatViewSeparator setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
            }
            else {
                [self.repeatButton styleSet:@"Repeat" andButtonType:FontDataType_Medium_13_White upperCase:YES];
                self.repeatButton.layer.borderColor = [UIColor whiteColor].CGColor;
                self.repeatIntroLabel.textColor = [UIColor whiteColor];
                
                [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
                [self.repeatViewSeparator setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4]];
            }
        }
    }
    
    self.saveButton.enabled = [ScheduleController.scheduleController canSaveEvent:self.updatedEventModel];
    self.saveButton.alpha = self.saveButton.enabled ? 1.0 : 0.5;
    
    [self.tableView reloadData];
}

#pragma mark - button onclick actions
- (IBAction)onClickRemove:(id)sender {
    [ArcusAnalytics tag:AnalyticsTags.RuleDelete attributes:@{}];
  
    if (ScheduleController.scheduleController.isWeeklySchedule) {
        BOOL hasRelated = [self hasRepeat];
        if (hasRelated) {
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Remove Event", nil) subtitle:NSLocalizedString(@"Would you like to remove this event for this day only, or for all days where it occurs?", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"THIS DAY ONLY", nil) event:@selector(removeForThisDayOnly)], [PopupSelectionButtonModel create:NSLocalizedString(@"ALL DAYS", nil) event:@selector(removeForAllDays)], nil];
            buttonView.owner = self;
            [self popupWarning:buttonView complete:nil];
        }
        else {
            [self removeForThisDayOnly];
        }
    }
    else {
        [self removeForAllDays];
    }
}

- (void)removeForAllDays {
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [ScheduleController.scheduleController deleteScheduleWithEventId:self.updatedEventModel.eventId withDay:@""].then(^{
            //Tag Edit Scene
            
            [ArcusAnalytics tag:[NSString stringWithFormat:@"Scheduler - Edited %@ schedule", ScheduleController.scheduleController.scheduleName] attributes:@{}];
            
            if (![ScheduleController.scheduleController hasScheduledEventsForCurrentModel]) {
                // disable scheduler if it's the last one
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [ScheduleController.scheduleController setSchedulerForModel:ScheduleController.scheduleController.schedulingModel enable:NO];
                });
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }).catch(^(NSError *error) {
            [self displayError:error];
        }).finally(^ {
            [self hideGif];
        });
    });
}

- (void)removeForThisDayOnly {
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        if (![ScheduleController.scheduleController isKindOfClass:[LawnNGardenScheduleController class]]) {
            NSArray *events = [self.updatedEventModel getRelatedEvents];
            
            if (events.count > 0) {
                [self updateWeeklyScheduleWithDays:[self daysFromEvents:events]];
            }
            else {
                [ScheduleController.scheduleController deleteScheduleWithEventId:self.updatedEventModel.eventId withDay:[ScheduledEventModel stringWithRepeatDayType:self.updatedEventModel.eventDay]].then(^{
                    //Tag Edit Scene
                    [ArcusAnalytics tag:[NSString stringWithFormat:@"Scheduler - Edited %@ schedule", ScheduleController.scheduleController.scheduleName] attributes:@{}];
                    
                    if ([ScheduleController.scheduleController getScheduledEventsCount] == 1) {
                        // disable scheduler if it's the last one
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                            [ScheduleController.scheduleController setSchedulerForModel:ScheduleController.scheduleController.schedulingModel enable:NO];
                        });
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }).catch(^(NSError *error) {
                    [self displayError:error];
                }).finally(^ {
                    [self hideGif];
                });
            }
        }
        else {
            [ScheduleController.scheduleController deleteScheduleWithEventId:self.updatedEventModel.eventId withDay:[ScheduledEventModel stringWithRepeatDayType:self.updatedEventModel.eventDay]].then(^{
                [self.navigationController popViewControllerAnimated:YES];
            }).catch(^(NSError *error) {
                // If the error is "IllegalStateException" - "couldn't find day of week even after iterating for 7 days" then ignore it: that is a platform issue
                if ([error.userInfo.allValues containsObject:@"couldn't find day of week even after iterating for 7 days"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self displayError:error];
                }
            }).finally(^ {
                [self hideGif];
            });
        }
    });
}

- (void)updateWeeklyScheduleWithDays:(NSArray *)days {
    [ScheduleController.scheduleController updateScheduleWithEvent:self.updatedEventModel withDays:days].then(^{
        [self.navigationController popViewControllerAnimated:YES];
    }).catch(^(NSError *error) {
        [self displayError:error];
    }).finally(^ {
        [self hideGif];
    });
}

- (void)updateOnlyDays:(NSArray *)days complete:(void (^)(void))completeBlock {
    [ScheduleController.scheduleController updateScheduleWithEvent:self.scheduledEventModel withDays:days].then(^{
        completeBlock();
    }).catch(^(NSError *error) {
        [self displayError:error];
    }).finally(^ {
        [self hideGif];
    });
}


- (NSArray *)daysFromEvents:(NSArray *)events {
    NSMutableArray *days = [NSMutableArray array];
    
    for(ScheduledEventModel *event in events) {
        [days addObject:[ScheduledEventModel stringWithRepeatDayType:event.eventDay]];
    }
    
    return days;
}

- (IBAction)onClickSave:(id)sender {
    if (ScheduleController.scheduleController.isWeeklySchedule) {
        if ([self.scheduledEventModel repeatDays] != _localEventDay && _localEventDay != 0) {
            [self saveForAllDays];
            return ;
        }
        
        if ([self.updatedEventModel hasRelatedEvents]) {
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Edit Event", nil) subtitle:NSLocalizedString(@"Would you like to edit this event for this day only, or for all days where it occurs?", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"THIS DAY ONLY", nil) event:@selector(saveForThisDayOnly)], [PopupSelectionButtonModel create:NSLocalizedString(@"ALL DAYS", nil) event:@selector(saveForAllDays)], nil];
            buttonView.owner = self;
            [self popup:buttonView complete:nil];
        }
        else {
            [self saveForThisDayOnly];
        }
    }
    else {
        [self saveForAllDays];
    }
}

- (void)saveForAllDays {
    
    if (!self.isNewModel) {
        [self editForAllDays];
        return;
    }
    
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        BOOL needToFire = NO;
        if (![ScheduleController.scheduleController isScheduleEnabledForCurrentModel] && ![ScheduleController.scheduleController hasScheduledEventsForCurrentModel]) {
            needToFire = YES;
        }
        
        [ScheduleController.scheduleController saveScheduleWithEvent:self.updatedEventModel withDays:[ScheduledEventModel generateArrayOfRepeatDays:_localEventDay]].then(^{
            //Tag Edit Scene
            [ArcusAnalytics tag:[NSString stringWithFormat:@"Scheduler - Edited %@ schedule", ScheduleController.scheduleController.scheduleName] attributes:@{}];

            if (needToFire) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [ScheduleController.scheduleController setSchedulerForModel:ScheduleController.scheduleController.schedulingModel enable:YES].then(^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }).catch(^(NSError *error) {
                        [self displayError:error];
                    });
                });
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
         }).catch(^(NSError *error) {
            [self displayError:error];
        }).finally(^ {
            [self hideGif];
        });
    });
}

- (void)saveForThisDayOnly {
    if (!self.isNewModel) {
        [self editForThisDayOnly];
        return;
    }
    
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        BOOL needToFire = NO;
        if (![ScheduleController.scheduleController isScheduleEnabledForCurrentModel] && ![ScheduleController.scheduleController hasScheduledEventsForCurrentModel]) {
            needToFire = YES;
        }
        
        [ScheduleController.scheduleController saveScheduleWithEvent:self.updatedEventModel withDays:[ScheduledEventModel generateArrayOfRepeatDays:_localEventDay]].then(^{
            //Tag Edit Scheduler
            [ArcusAnalytics tag:[NSString stringWithFormat:@"Scheduler - Edited %@ schedule", ScheduleController.scheduleController.scheduleName] attributes:@{}];
            
            if (needToFire) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [ScheduleController.scheduleController setSchedulerForModel:ScheduleController.scheduleController.schedulingModel enable:YES];
                });
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }).catch(^(NSError *error) {
            [self displayError:error];
        }).finally(^ {
            [self hideGif];
        });
    });
}

- (void)editForAllDays {
    // Edit for all days
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        if (_localEventDay != 0) {
            //update old one by removing the current day
            [self updateWeeklyScheduleWithDays:[ScheduledEventModel generateArrayOfRepeatDays:_localEventDay]];
        }
        else {
            [self updateWeeklyScheduleWithDays:[ScheduledEventModel generateArrayOfRepeatDays:[self.scheduledEventModel repeatDays]]];
        }
    });
}

- (void)editForThisDayOnly {
    if ([self.updatedEventModel getRelatedEvents].count == 0) {
        [self editForAllDays];
        return;
    }
    
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        if (![ScheduleController.scheduleController isKindOfClass:[LawnNGardenScheduleController class]] ) {
            __block ScheduledEventModel *_storeScheduleEventModel = self.scheduledEventModel.copy;
            
            // Delete curent day
            ScheduleRepeatType newEventDay = _localEventDay;
            if (_localEventDay == 0) {
                newEventDay = [_storeScheduleEventModel repeatDays];
            }
            newEventDay ^= _storeScheduleEventModel.eventDay;
            [self updateOnlyDays:[ScheduledEventModel generateArrayOfRepeatDays:newEventDay] complete:^{
                
                //create new one
                [ScheduleController.scheduleController saveScheduleWithEvent:self.updatedEventModel withDays:[ScheduledEventModel generateArrayOfRepeatDays:_storeScheduleEventModel.eventDay]].then(^{
                    [self hideGif];
                    [self.navigationController popViewControllerAnimated:YES];
                 });
            }];
        }
        else {
            [self updateOnlyDays:[ScheduledEventModel generateArrayOfRepeatDays:self.scheduledEventModel.eventDay] complete:^{
                [self hideGif];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    });
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:owner
                                 closeSelector:selector];
}

- (void)chooseStartTime {
    PopupSelectionBaseContainer *timerPicker = [ScheduleController.scheduleController getScheduledTimePickerWithDateTime:self.updatedEventModel.eventTime];
    [self popup:timerPicker complete:@selector(chooseTime:)];
}

- (IBAction)onClickOpenRepeatDays:(id)sender {
    [self chooseRepeatDays];
}

#pragma mark - popup choosing action
- (void)chooseTime:(ArcusDateTime *)value {
    DDLogWarn(@"%@", value);
    
    // TODO: this may not be needed - the self.updatedEventModel is already updated
    [self.updatedEventModel.eventTime updateTime:value];
    [self.tableView reloadData];
 }

- (void)chooseRepeatDays {
    NSArray *relatedEvents = [self.updatedEventModel getRelatedEvents];
    ScheduleRepeatType repeats = self.localEventDay;
    if (repeats == 0) {
        for (ScheduledEventModel *item in relatedEvents) {
            repeats |= item.eventDay;
        }
        repeats |= self.updatedEventModel.eventDay;
    }
    
    NSMutableArray *models = [NSMutableArray array];
    [models addObject:[PopupSelectionModel create:@"Monday" selected:(repeats & ScheduleRepeatTypeMon) obj:@(ScheduleRepeatTypeMon)]];
    [models addObject:[PopupSelectionModel create:@"Tuesday" selected:(repeats & ScheduleRepeatTypeTue) obj:@(ScheduleRepeatTypeTue)]];
    [models addObject:[PopupSelectionModel create:@"Wednesday" selected:(repeats & ScheduleRepeatTypeWed) obj:@(ScheduleRepeatTypeWed)]];
    [models addObject:[PopupSelectionModel create:@"Thursday" selected:(repeats & ScheduleRepeatTypeThu) obj:@(ScheduleRepeatTypeThu)]];
    [models addObject:[PopupSelectionModel create:@"Friday" selected:(repeats & ScheduleRepeatTypeFri) obj:@(ScheduleRepeatTypeFri)]];
    [models addObject:[PopupSelectionModel create:@"Saturday" selected:(repeats & ScheduleRepeatTypeSat) obj:@(ScheduleRepeatTypeSat)]];
    [models addObject:[PopupSelectionModel create:@"Sunday" selected:(repeats & ScheduleRepeatTypeSun) obj:@(ScheduleRepeatTypeSun)]];
    
    PopupSelectionTitleTableView *popupSelection = [PopupSelectionTitleTableView create:@"Repeat event to" data:models];
    [popupSelection setMultipleSelect:YES];
    [self popup:popupSelection complete:@selector(selectedRepeat:)];
}

- (void)selectedRepeat:(id)value {
    NSInteger _eventDays = 0;
    if (value && [value isKindOfClass:[NSArray class]]) {
        for (NSNumber *param in value) {
            _eventDays |= [param integerValue];
        }
    }
    
    self.localEventDay = _eventDays;
    [self reloadData];
}

- (void)chooseRuleState:(NSNumber *)value {
    if (value && [value boolValue] != [(RuleScheduledEventModel *)self.updatedEventModel getState]) {
        [(RuleScheduledEventModel *)self.updatedEventModel setState:[value boolValue]];
        [self reloadData];
    }
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchedulerSettingOption *option = _settingItems[indexPath.row];
    
    switch (option.optionType) {
        case ScheduledOptionTypeSideOption: {
            CommonTitleValueonRightCell *cell = [CommonTitleValueonRightCell create:tableView];
            [cell setBackgroundColor:[UIColor clearColor]];
            switch (option.tag) {
                case -1: {
                    [cell setTitle:[option.title uppercaseString] sideValue:[self.updatedEventModel.eventTime formatDateTimeStamp] isBlack:self.isNewModel];
                }
                    break;
                case -2: {
                    [cell setTitle:[option.title uppercaseString] sideValue:option.sideValue isBlack:self.isNewModel];
                }
                    break;
                default: {
                    [cell setTitle:[option.title uppercaseString] sideValue:option.sideValue isBlack:self.isNewModel];
                }
                    break;
            }
            if (option.subtitle && option.subtitle.length > 0) {
                [cell setDescription:option.subtitle];
            }
            return cell;
        }
            break;
        case ScheduledOptionTypeSwitch: {
            CommonTitleWithSwitchCell *cell = [CommonTitleWithSwitchCell create:tableView];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            if (self.isNewModel) {
                [cell setBlackTitle:[option.title uppercaseString] selected:option.isChecked];
            }
            else {
                [cell setWhiteTitle:[option.title uppercaseString] selected:option.isChecked];
            }
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SchedulerSettingOption *option = _settingItems[indexPath.row];
    if (option.eventOwner && option.onClick && [option.eventOwner respondsToSelector:option.onClick]) {
        [option.eventOwner performSelector:option.onClick withObject:nil afterDelay:0];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - Helper methods
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow];
}

- (void)present:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow present:self
                                         subview:container
                                           owner:owner
                                   closeSelector:selector];
}

- (BOOL)hasRepeat {
    BOOL hasRelated = [self.scheduledEventModel hasRelatedEvents];
    if (!hasRelated) {
        hasRelated = (_localEventDay > 0 && _localEventDay != self.updatedEventModel.eventDay);
    }
    return hasRelated;
}

- (void)displayError:(NSError *)error {
    if ([error.userInfo[@"code"] isEqualToString:@"lawnngarden.scheduling.has_overlaps"]) {
        [self displayErrorMessage:@"You currently have an event scheduled that overlaps with the start time you have chosen. Please select a later time." withTitle:@"OVERLAPPING EVENTS"];
    }
    else {
        [self displayGenericErrorMessage];
    }
}

@end
