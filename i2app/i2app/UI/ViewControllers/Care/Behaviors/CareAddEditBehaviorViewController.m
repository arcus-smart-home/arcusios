//
//  CareAddEditBehaviorViewController.m
//  i2app
//
//  Created by Arcus Team on 2/5/16.
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
#import "CareAddEditBehaviorViewController.h"
#import "SubsystemsController.h"
#import "CareSubsystemController.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"

#import "PopupSelectionTimerView.h"
#import "PopupSelectionNumberView.h"
#import "DeviceCapability.h"
#import "CareBehaviorSchedulerViewController.h"
#import "ArcusModalSelectionModel.h"
#import "ArcusEditStringViewController.h"
#import "CareBehaviorSerialization.h"
#import "CareSubsystemCapability.h"
#import "CareTimeMath.h"
#import "CareOpenCountDevicePickerViewController.h"
#import "CareAddBehaviorInstructionViewController.h"
#import "CareBehaviorValidation.h"
#import <i2app-Swift.h>

#define SMALL_PROPERTY_HEIGHT 45
#define LARGE_PROPERTY_HEIGHT 80
#define DISABLED_SAVE_ALPHA 0.4

#define LOW_TEMP_DEFAULT_VALUE 66
#define HIGH_TEMP_DEFAULT_VALUE 82

@interface CareAddEditBehaviorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheaderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subheaderBottomConstraint;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderSeparator;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) CareBehaviorTemplateModel *behaviorTemplate;
@property (nonatomic, strong) CareBehaviorModel *behavior;
@property (nonatomic) BOOL isCreationMode;
@property (nonatomic) BOOL isUnsatisfiableBehavior;

@property (nonatomic, strong) NSMutableArray *availableDevices;
@property (nonatomic, strong) NSArray *modalDataSource;

@property (nonatomic,strong) PopupSelectionWindow *popupWindow;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation CareAddEditBehaviorViewController

NSString *const careAddEditCurfewDefaultTimeString = @"9:00 PM";

// Label transform function for minute durations
NSString* (^minutesLabelTransform)(NSNumber* durationMins) = ^NSString *(NSNumber* durationMins) {
    if ([durationMins intValue] == 1) {
        return [NSString stringWithFormat:@"%d Min", [durationMins intValue]];
    } else if ([durationMins intValue] < 60){
        return [NSString stringWithFormat:@"%d Mins", [durationMins intValue]];
    } else if ([durationMins intValue] == 60){
        return [NSString stringWithFormat:@"%d Hour", [durationMins intValue] / 60];
    } else {
        return [NSString stringWithFormat:@"%d Hours", [durationMins intValue] / 60];
    }
};

// Label transform function for day durations
NSString* (^daysLabelTransform)(NSNumber* durationDays) = ^NSString *(NSNumber* durationDays) {
    if ([durationDays intValue] == 1) {
        return [NSString stringWithFormat:@"%d Day", [durationDays intValue]];
    } else {
        return [NSString stringWithFormat:@"%d Days", [durationDays intValue]];
    }
};

#pragma mark - Creation
+ (CareAddEditBehaviorViewController *)createWithTemplate:(CareBehaviorTemplateModel *)behaviorTemplate {
    CareAddEditBehaviorViewController *vc = [[UIStoryboard storyboardWithName:@"CareBehaviors" bundle:nil]
                                             instantiateViewControllerWithIdentifier:NSStringFromClass([CareAddEditBehaviorViewController class])];
    vc.behaviorTemplate = behaviorTemplate;
    vc.isCreationMode = YES;
    return vc;
}

+ (CareAddEditBehaviorViewController *)createWithBehavior:(CareBehaviorModel *)behavior andTemplate:(CareBehaviorTemplateModel *)template {
    CareAddEditBehaviorViewController *vc = [[UIStoryboard storyboardWithName:@"CareBehaviors" bundle:nil]
                                             instantiateViewControllerWithIdentifier:NSStringFromClass([CareAddEditBehaviorViewController class])];
    vc.behavior = behavior;
    vc.behaviorTemplate = template;
    vc.isCreationMode = NO;
    return vc;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.isUnsatisfiableBehavior = NO;
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"h:mm a";
    [self oneTimeUIConfig];
    [self updateUI];
}

#pragma mark - Data
- (void)loadData {
    if (!_behavior) {
        _behavior = [[CareBehaviorModel alloc] initWithTemplate:_behaviorTemplate];
    }
    self.availableDevices = [self fetchAvailableDevices];
    if (_availableDevices.count == 0) {
        self.isUnsatisfiableBehavior = YES;
    }
}

- (NSMutableArray *)fetchAvailableDevices {
    NSMutableArray *devices = [NSMutableArray array];
    
    for (NSString *deviceID in _behaviorTemplate.availableDevices) {
        [devices addObject:[[[CorneaHolder shared] modelCache] fetchModel:deviceID]];
    }
    
    return devices;
}

#pragma mark - UI
- (void)updateUI {
    if (!self.isUnsatisfiableBehavior) {
        BOOL behaviorIsValid = [CareBehaviorValidation behavior:_behavior isValidForTemplate:_behaviorTemplate];
        self.saveButton.enabled = behaviorIsValid;
        self.saveButton.alpha = behaviorIsValid ? 1.0 : DISABLED_SAVE_ALPHA;
    }
    
    [self.tableView reloadData];
}

- (void)adjustHeaderViewSize {
    if (self.subheaderLabel.text.length == 0) {
        self.subheaderBottomConstraint.constant = 0;
    }
    CGSize headerNewSize = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint headerOrigin = self.tableHeaderView.frame.origin;
    self.tableHeaderView.frame = CGRectMake(headerOrigin.x,
                                            headerOrigin.y,
                                            headerNewSize.width,
                                            headerNewSize.height);
}

- (void)oneTimeUIConfig {
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self navBarWithBackButtonAndTitle:_behaviorTemplate.name];
    
    self.headerLabel.text = _behaviorTemplate.templateDescription;
    NSString *subheaderLabelText = _behavior.type == CareBehaviorTypePresence ? NSLocalizedString(@"Care Add Presence Subheader", nil) : nil;
    self.subheaderLabel.text = subheaderLabelText;
    
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self adjustHeaderViewSize];
    
    NSString *saveButtonText = _isUnsatisfiableBehavior ? NSLocalizedString(@"shop now", nil) : NSLocalizedString(@"save", nil);
    [self.saveButton styleSet:NSLocalizedString(saveButtonText, nil)
                andButtonType:self.isCreationMode ? FontDataTypeButtonDark : FontDataTypeButtonLight
                    upperCase:YES];
    
    if (self.isCreationMode) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        self.headerLabel.textColor = [FontColors getCreationHeaderTextColor];
        self.subheaderLabel.textColor = [FontColors getCreationSubheaderTextColor];
        UIColor *separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
        self.tableView.separatorColor = separatorColor;
        self.tableHeaderSeparator.backgroundColor = separatorColor;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isUnsatisfiableBehavior) {
        return 1;
    }
    if (_behaviorTemplate) {
        return _behaviorTemplate.fields.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (_isUnsatisfiableBehavior) {
        ArcusTitleDetailTableViewCell *theCell;
        theCell = [tableView dequeueReusableCellWithIdentifier:@"oopsCell"];
        theCell.descriptionLabel.text = NSLocalizedString(@"Behavior additional devices required", nil);
        cell = theCell;
    } else {
        if (indexPath.row < self.behaviorTemplate.fields.count) {//Field cell
            CareBehaviorField *field = self.behaviorTemplate.fields[indexPath.row];
            if (field.fieldType == CareBehaviorFieldTypeSchedule && _behavior.type != CareBehaviorTypePresence) {
                ArcusImageTitleDescriptionTableViewCell *theCell;
                theCell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell"];
                theCell.titleLabel.text = field.name;
                theCell.descriptionLabel.text = field.fieldDescription;
                
                theCell.detailImage.tintColor = self.isCreationMode ? [UIColor blackColor] : [UIColor whiteColor];
                theCell.detailImage.hidden = self.behavior.timeWindows.count == 0;
                
                cell = theCell;
            } else {
                ArcusTitleDetailTableViewCell *theCell;
                NSString *fieldValueString;
                
                if (field.fieldType == CareBehaviorFieldTypeDevices) {
                    theCell = [tableView dequeueReusableCellWithIdentifier:@"largeBehaviorPropertyCell"];
                    if (_behaviorTemplate.type == CareBehaviorTypeOpenCount) {
                        NSArray *openCountDevices = _behavior.behaviorProperties[kCareBehaviorPropertyOpenCount];
                        if (!openCountDevices || openCountDevices.count == 0) {
                            fieldValueString = nil;
                        } else {
                            fieldValueString = [NSString stringWithFormat:@"%lu", (unsigned long)openCountDevices.count];
                        }
                    } else {
                        if (_behavior.participatingDevices.count == 0) {
                            fieldValueString = nil;
                        } else {
                            fieldValueString = [NSString stringWithFormat:@"%lu", (unsigned long)_behavior.participatingDevices.count];
                        }
                    }
                    
                    
                    [theCell.descriptionLabel setText:field.fieldDescription];
                } else {
                    
                    if (field.unit == CareBehaviorFieldUnitFahrenheit) {
                        theCell = [tableView dequeueReusableCellWithIdentifier:@"smallBehaviorPropertyCell"];
                    } else {
                        theCell = [tableView dequeueReusableCellWithIdentifier:@"largeBehaviorPropertyCell"];
                        [theCell.descriptionLabel setText:field.fieldDescription];
                    }
                    
                    NSObject *fieldValue = (NSObject *)self.behavior.behaviorProperties[field.fieldKey];
                    
                    switch (field.fieldType) {
                        case CareBehaviorFieldTypeDuration: {
                            NSNumber *durationInSeconds = self.behavior.behaviorProperties[kCareBehaviorPropertyDurationSecs];
                            if (durationInSeconds && ![durationInSeconds isEqualToNumber:@(0)]) {
                                NSNumber* value = [NSNumber numberWithLong:[CareTimeMath convertFromSeconds:durationInSeconds toUnit:field.unit]];
                                fieldValueString = field.unit == CareBehaviorFieldUnitDays ? daysLabelTransform((NSNumber*)value) : minutesLabelTransform((NSNumber*)value);
                            }
                            break;
                        }
                        case CareBehaviorFieldTypeSchedule: {
                            if (_behavior.type == CareBehaviorTypePresence) {
                                fieldValueString = [_dateFormatter stringFromDate:self.behavior.behaviorProperties[kCareBehaviorPropertyPresenceTimeOfDay]];
                            }
                        }
                            
                        default:
                            break;
                    }
                    
                    if (fieldValue) {
                        fieldValueString = fieldValue.description;
                        if ([fieldValue isKindOfClass:[NSNumber class]]) {
                            NSNumber *numValue = (NSNumber *) fieldValue;
                            BOOL isPlural = [numValue compare:@(1)] == NSOrderedDescending;
                            fieldValueString = [fieldValueString stringByAppendingString:[CareBehaviorEnums postFixForUnit:field.unit isPlural:isPlural]];
                        }
                    }
                }
                
                [theCell.titleLabel setText:field.name];
                [theCell.accessoryLabel setText:fieldValueString];
                cell = theCell;
            }
            
            
            
        } else {//Edit name cell
            ArcusTitleDetailTableViewCell *theCell;
            theCell = [tableView dequeueReusableCellWithIdentifier:@"smallBehaviorPropertyCell"];
            [theCell.titleLabel setText:@"EDIT NAME"];
            NSString *name = _behavior ? _behavior.name : _behaviorTemplate.name;
            [theCell.accessoryLabel setText:name];
            cell = theCell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isUnsatisfiableBehavior) {
        if (indexPath.row == _behaviorTemplate.fields.count) {//Edit name cell
            NSString *placeHolderText = NSLocalizedString(@"Behavior Name", nil);
            ArcusEditStringViewController *vc = [ArcusEditStringViewController createWithPlaceholderText:placeHolderText currentValue:self.behavior.name isEditMode:!self.isCreationMode];
            ArcusStringEditorCompletion completion = ^(NSString *itemName) {
                if (itemName && itemName.length > 0) {
                    _behavior.name = itemName;
                } else {
                    _behavior.name = _behaviorTemplate.name;
                }
                [self updateUI];
            };
            
            vc.completion = completion;
            vc.navBarText = NSLocalizedString(@"EDIT BEHAVIOR NAME", nil);
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {//Field cell
            CareBehaviorField *field = _behaviorTemplate.fields[indexPath.row];
            
            //This completion is reused for duration and low & high temps
            void (^numericPopupCompletion)(id object) = ^(id object) {
                if (object) {
                    NSNumber *returnedValue = (NSNumber *)object;
                    NSString *key;
                    
                    switch (field.fieldType) {
                        case CareBehaviorFieldTypeDuration:
                            key = kCareBehaviorPropertyDurationSecs;
                            returnedValue = [NSNumber numberWithLong:[CareTimeMath convertToSeconds:returnedValue ofUnit:field.unit]];
                            break;
                        default:
                            key = field.fieldKey;
                            break;
                    }
                    
                    self.behavior.behaviorProperties[key] = returnedValue;
                    [self updateUI];
                }
            };
            
            switch (field.fieldType) {
                case CareBehaviorFieldTypeDevices: {
                    if (_behavior.type == CareBehaviorTypeOpenCount) {
                        [self performSegueWithIdentifier:@"openCountPickerSegue" sender:self];
                    } else {
                        [self performSegueWithIdentifier:@"modalSelectionSegue" sender:self];
                    }
                    
                    break;
                }
                case CareBehaviorFieldTypeDuration: {
                    NSNumber *currentValue;
                    
                    NSNumber *durationInSeconds = self.behavior.behaviorProperties[field.fieldKey];
                    if (durationInSeconds) {
                        currentValue = [NSNumber numberWithLong:[CareTimeMath convertFromSeconds:durationInSeconds toUnit:field.unit]];
                    }
                    
                    // Duration value needs to be pretty-printed when rendered in the spinner (i.e., "120 mins" -> "2 hours"); label transform represents a function that converts a value to the appropriate string
                    NSString* (^labelTransform)(NSNumber*) = field.unit == CareBehaviorFieldUnitDays ? daysLabelTransform : minutesLabelTransform;
                    PopupSelectionNumberView *picker = [PopupSelectionNumberView create:@"Select a duration" withNumbers:field.possibleValues labelTransform:labelTransform];
                    
                    [self popupWithBlockSetCurrentValue:picker currentValue:currentValue completeBlock:numericPopupCompletion];
                    break;
                }
                case CareBehaviorFieldTypeLowTemperature: {
                    NSNumber *currentValue = self.behavior.behaviorProperties[field.fieldKey];
                    if (!currentValue || [[NSNull null] isEqual:currentValue]) {
                        currentValue = [NSNumber numberWithInteger:LOW_TEMP_DEFAULT_VALUE];
                    }
                    NSNumber *currentHighTemp = self.behavior.behaviorProperties[@"highTemp"];
                    NSNumber *minValue = field.possibleValues[0];
                    NSNumber *maxValue = field.possibleValues[1];
                    
                    float maxValueToUse = maxValue.floatValue - 3;
                    if (currentHighTemp) {
                        maxValueToUse = MIN(maxValueToUse, currentHighTemp.floatValue - 3);
                    }
                    PopupSelectionNumberView *picker = [PopupSelectionNumberView create:@"Choose a low temperature"
                                                                          withMinNumber:minValue.floatValue
                                                                              maxNumber:maxValueToUse
                                                                             andPostfix:[CareBehaviorEnums postFixForUnit:field.unit isPlural:NO]
                                                                       ignoreMinMaxRule:YES];
                    [self popupWithBlockSetCurrentValue:picker currentValue:currentValue completeBlock:numericPopupCompletion];
                    break;
                }
                case CareBehaviorFieldTypeHighTemperature: {
                    NSNumber *currentValue = self.behavior.behaviorProperties[field.fieldKey];
                    if (!currentValue || [[NSNull null] isEqual:currentValue]) {
                        currentValue = [NSNumber numberWithInteger:HIGH_TEMP_DEFAULT_VALUE];
                    }
                    NSNumber *currentLowTemp = self.behavior.behaviorProperties[@"lowTemp"];
                    NSNumber *minValue = field.possibleValues[0];
                    NSNumber *maxValue = field.possibleValues[1];
                    
                    float minValueToUse = minValue.floatValue + 3;
                    if (currentLowTemp) {
                        minValueToUse = MAX(minValueToUse, currentLowTemp.floatValue + 3);
                    }
                    PopupSelectionNumberView *picker = [PopupSelectionNumberView create:@"Choose a high temperature"
                                                                          withMinNumber:minValueToUse
                                                                              maxNumber:maxValue.floatValue
                                                                             andPostfix:[CareBehaviorEnums postFixForUnit:field.unit isPlural:NO]
                                                                       ignoreMinMaxRule:YES];
                    [self popupWithBlockSetCurrentValue:picker currentValue:currentValue completeBlock:numericPopupCompletion];
                    break;
                }
                case CareBehaviorFieldTypeSchedule: {
                    if (_behavior.type == CareBehaviorTypePresence) {
                        NSDate *currentValue = self.behavior.behaviorProperties[kCareBehaviorPropertyPresenceTimeOfDay];
                        if (!currentValue) {
                            currentValue = [self.dateFormatter dateFromString:careAddEditCurfewDefaultTimeString];
                        }
                        PopupSelectionTimerView *picker = [PopupSelectionTimerView create:NSLocalizedString(@"Curfew", nil)
                                                                                 withDate:currentValue
                                                                           timerStyle:TimerStyleHoursAndMinutes];
                        [self popupWithBlockSetCurrentValue:picker
                                               currentValue:nil
                                              completeBlock: ^(id object) {
                                                  NSDate *chosenDate = (NSDate *)object;
                                                  _behavior.behaviorProperties[kCareBehaviorPropertyPresenceTimeOfDay] = chosenDate;
                                                  [self updateUI];
                                              }];
                    } else {
                        CareBehaviorSchedulerViewController *vc = [CareBehaviorSchedulerViewController createWithTimeWindows:[[NSMutableArray alloc] initWithArray:self.behavior.timeWindows copyItems:YES]];
                        vc.completion = ^(NSArray<CareTimeWindowModel *> *timeWindows) {
                            self.behavior.timeWindows = timeWindows;
                            [self updateUI];
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    if (self.isCreationMode) {
        if (indexPath.row == _behaviorTemplate.fields.count
            || (_behaviorTemplate.fields[indexPath.row].fieldType != CareBehaviorFieldTypeSchedule)
            || (_behaviorTemplate.fields[indexPath.row].fieldType == CareBehaviorFieldTypeSchedule && _behaviorTemplate.type == CareBehaviorTypePresence)) {
            ArcusTitleDetailTableViewCell *tableCell = (ArcusTitleDetailTableViewCell *)cell;
            tableCell.titleLabel.textColor = [FontColors getCreationHeaderTextColor];
            tableCell.accessoryLabel.textColor = [FontColors getCreationSubheaderTextColor];
            tableCell.descriptionLabel.textColor = [FontColors getCreationSubheaderTextColor];
            tableCell.accessoryImage.image = [UIImage imageNamed:@"Chevron"];
        } else {
            ArcusImageTitleDescriptionTableViewCell *tableCell = (ArcusImageTitleDescriptionTableViewCell *)cell;
            tableCell.titleLabel.textColor = [FontColors getCreationHeaderTextColor];
            tableCell.descriptionLabel.textColor = [FontColors getCreationSubheaderTextColor];
            tableCell.accessoryImage.image = [UIImage imageNamed:@"Chevron"];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LARGE_PROPERTY_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isUnsatisfiableBehavior) {
        return LARGE_PROPERTY_HEIGHT;
    }
    if (indexPath.row == _behaviorTemplate.fields.count) {//Name cell
        return SMALL_PROPERTY_HEIGHT;
    }
    CareBehaviorField *field = _behaviorTemplate.fields[indexPath.row];
    return field.unit == CareBehaviorFieldUnitFahrenheit ? SMALL_PROPERTY_HEIGHT : UITableViewAutomaticDimension;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"modalSelectionSegue"]) {
        ArcusModalSelectionViewController *vc = (ArcusModalSelectionViewController *)segue.destinationViewController;
        vc.selectionArray = [self createModalDeviceSelectionArray];
        vc.delegate = self;
        vc.allowMultipleSelection = true;
    } else if ([segue.identifier isEqualToString:@"openCountPickerSegue"]) {
        CareOpenCountDevicePickerViewController *vc = (CareOpenCountDevicePickerViewController *)segue.destinationViewController;
        vc.deviceCounts = [self createOpenCountDeviceListWithDictionary:_behavior.behaviorProperties[kCareBehaviorPropertyOpenCount] andDeviceList:_availableDevices];
        vc.isCreationMode = self.isCreationMode;
        vc.completion = ^(NSMutableArray<CareOpenCountDeviceModel *> *deviceCounts) {
            [deviceCounts filterUsingPredicate:[NSPredicate predicateWithBlock: ^BOOL(id evaluatedObject, NSDictionary *bindings) {
                CareOpenCountDeviceModel *openCountModel = (CareOpenCountDeviceModel *)evaluatedObject;
                return openCountModel.active;
            }]];
            [self storeOpenCounts:deviceCounts inBehavior:self.behavior];
            [self updateUI];
        };
    } else if ([segue.identifier isEqualToString:@"careAddInfoSegue"]) {
        CareAddBehaviorInstructionViewController *vc = (CareAddBehaviorInstructionViewController *)segue.destinationViewController;
        vc.dismissalCompletion = ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        };
    }
}

#pragma mark - IBActions
- (IBAction)saveButtonTapped:(id)sender {
    if (_isUnsatisfiableBehavior) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
    } else {
        void (^saveBlock) (void);
        
        if (self.isCreationMode) {
            saveBlock = ^{
                [[SubsystemsController sharedInstance].careController addBehavior:self.behavior].then(^(NSString *response) {
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:kHasAcknowledBehaviorInfoKey]) {
                        [self performSegueWithIdentifier:@"careAddInfoSegue" sender:self];
                    } else {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }).catch(^(NSError *error ){
                    NSString *errorCode = (NSString *)error.userInfo[@"code"];
                    if (errorCode && [errorCode isEqualToString:kErrorCareNameInUse]) {
                        [self displayErrorMessage:NSLocalizedString(@"Create a unique name for this behavior", nil) withTitle:[NSLocalizedString(@"Name already in use", nil) uppercaseString]];
                    } else if (errorCode && [errorCode isEqualToString:kErrorCareDuplicateWindows]) {
                        [self displayErrorMessage:NSLocalizedString(@"Care schedule conflict message", nil) withTitle:[NSLocalizedString(@"Schedule conflict", nil) uppercaseString]];
                    } else {
                        [self displayErrorMessage:NSLocalizedString(@"Generic care behavior error message", nil) withTitle:@"OOPS!"];
                    }
                });
            };
        } else {//Editing a behavior
            saveBlock = ^{
                [[SubsystemsController sharedInstance].careController updateBehavior:self.behavior].then(^(NSString *response) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }).catch(^(NSError *error ){
                    NSString *errorCode = (NSString *)error.userInfo[@"code"];
                    if (errorCode && [errorCode isEqualToString:kErrorCareNameInUse]) {
                        [self displayErrorMessage:@"Create a unique name for this behavior" withTitle:[@"Name already in use" uppercaseString]];
                    } else if (errorCode && [errorCode isEqualToString:kErrorCareDuplicateWindows]) {
                        [self displayErrorMessage:NSLocalizedString(@"Care schedule conflict message", nil) withTitle:[NSLocalizedString(@"Schedule conflict", nil) uppercaseString]];
                    } else {
                        [self displayErrorMessage:NSLocalizedString(@"Generic care error message", nil) withTitle:@"OOPS!"];
                    }
                });
            };
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), saveBlock);
    }
}

#pragma mark - ArcusModalSelectionDelegate
- (void)modalSelectionController:(UIViewController *)selectionController
    didDismissWithSelectedModels:(NSArray <ArcusModalSelectionModel *> *)selectedIndexes {
    
    NSMutableArray *selectedDevices = [NSMutableArray array];
    
    for (ArcusModalSelectionModel *selectionModel in selectedIndexes) {
        [selectedDevices addObject:selectionModel.deviceAddress];
    }
    
    _behavior.participatingDevices = selectedDevices;
    [self updateUI];
}

#pragma mark - PopupWindow handling
- (void)popupWithBlockSetCurrentValue:(PopupSelectionBaseContainer *)container currentValue:(id)currentValue completeBlock:(void (^)(id selectedValue))closeBlock  {
    
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    [container setCurrentKey:currentValue];
    _popupWindow = [PopupSelectionWindow popupWithBlock:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                                subview:container
                                                  owner:self
                                             closeBlock:closeBlock];
}

#pragma mark - Setters
- (void)setAvailableDevices:(NSMutableArray *)availableDevices {
    [availableDevices sortUsingComparator:^NSComparisonResult (id device1, id device2) {
        DeviceModel *model1 = (DeviceModel *)device1;
        DeviceModel *model2 = (DeviceModel *)device2;
        return [model1.name caseInsensitiveCompare:model2.name];
    }];
    _availableDevices = availableDevices;
}


#pragma mark - Helpers
- (NSArray *)createModalDeviceSelectionArray {
    NSMutableArray *selectionArray = [NSMutableArray array];
    
    for (DeviceModel *model in self.availableDevices) {
        ArcusModalSelectionModel *selectionModel = [ArcusModalSelectionModel selectionModelForDevice:model];
        if ([self.behavior.participatingDevices containsObject:model.address]) {
            selectionModel.isSelected = YES;
        }
        [selectionArray addObject:selectionModel];
    }
    
    return selectionArray;
}

- (NSMutableArray *)createOpenCountDeviceListWithDictionary:(NSDictionary *)dict andDeviceList:(NSArray *)deviceList {
    NSMutableArray *deviceCountArray = [NSMutableArray array];
    for (DeviceModel *deviceModel in deviceList) {
        NSNumber *count = dict[deviceModel.address] ? dict[deviceModel.address] : [[NSNumber alloc] initWithInt:0];
        CareOpenCountDeviceModel *openCountModel = [[CareOpenCountDeviceModel alloc] initWithDeviceModel:deviceModel andCount:[count integerValue]];
        openCountModel.active = [count integerValue] > 0;
        [deviceCountArray addObject:openCountModel];
    }
    [deviceCountArray sortUsingComparator:^ NSComparisonResult(CareOpenCountDeviceModel *model1, CareOpenCountDeviceModel *model2){
        return [model1.deviceModel.name caseInsensitiveCompare:model2.deviceModel.name];
    }];
    return deviceCountArray;
}

- (void)storeOpenCounts:(NSArray <CareOpenCountDeviceModel *> *)openCounts inBehavior:(CareBehaviorModel *)behavior {
    NSMutableDictionary<NSString *, NSNumber *> *openCountsDict = [NSMutableDictionary dictionary];
    
    for (CareOpenCountDeviceModel *openCountModel in openCounts) {
        openCountsDict[openCountModel.deviceModel.address] = [NSNumber numberWithLong:openCountModel.count];
    }
    
    behavior.behaviorProperties[kCareBehaviorPropertyOpenCount] = openCountsDict;
}

@end
