//
//  RuleSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 6/25/15.
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
#import "RuleSettingViewController.h"
#import "ArcusTitleDetailTableViewCell.h"
#import <PureLayout/PureLayout.h>

#import "RuleCapability.h"
#import "RuleTemplateCapability.h"
#import "RulesController.h"


#import "PersonService.h"
#import "RuleTemplateResolutionModel.h"
#import "UIImage+ImageEffects.h"
#import "ClickableLabel.h"
#import "WeeklyScheduleViewController.h"
#import "ScheduleController.h"
#import "PopupSelectionButtonsView.h"
#import "RuleEditNameViewController.h"
#import "UIViewController+AlertBar.h"
#import "RuleScheduleController.h"

#import "PopupSelectionLogoTextView.h"
#import "PopupSelectionTextPickerView.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionNumberView.h"

NSString *const kMenuTypeTable = @"Table";
NSString *const kMenuTypePicker = @"Picker";

NSString *const kOptionTypeUnknown = @"UNKNOWN";
NSString *const kOptionTypeText = @"TEXT";
NSString *const kOptionTypeList = @"LIST";
NSString *const kOptionTypeTimeOfDay = @"TIME_OF_DAY";
NSString *const kOptionTypeDayOfWeek = @"DAY_OF_WEEK";
NSString *const kOptionTypeDuration = @"duration";
NSString *const kOptionTypeForAWhile = @"for awhile";
NSString *const kOptionTypePerson = @"person";
NSString *const kOptionTypeDevice = @"device";
NSString *const kOptionTypeTimeRange = @"TIME_RANGE";



@interface RuleSchduleTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImage;

@end

@implementation RuleSchduleTableCell

@end



NSString *const kSegueSetRuleName = @"SetRuleNameSegue";

@interface RuleSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet ClickableLabel *settingLabel;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIView *selectionContainerDismissOverlayView;
@property (weak, nonatomic) IBOutlet UITableView *ruleTableView;

@property (nonatomic, strong) RuleTemplateResolutionModel *ruleResolution;
@property (nonatomic, strong) RuleModel *ruleModel;
@property (nonatomic, readonly) BOOL isEditMode;


@property (nonatomic, strong, readonly) NSString *placeId;

@property (nonatomic, assign) NSInteger currentEditingParamOrderID;
@property (nonatomic, assign) BOOL selectionMenuIsOpen;

@property (nonatomic, assign) FontDataType sentenceType;
@property (nonatomic, assign) FontDataType parameterType;
@property (nonatomic, assign) FontDataType settingsLabelType;

@property (nonatomic, strong) NSDictionary *cellTitleFontData;
@property (nonatomic, strong) NSDictionary *cellDescFontData;

@property (nonatomic, strong) NSString *settingsLabelText;

@property (nonatomic, assign) BOOL isSatisfiable;

@end

@implementation RuleSettingViewController {
    PopupSelectionWindow    *_popupWindow;
    PopupSelectionBaseContainer     *_popupPickerContainer;
}

#pragma mark - View LifeCycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelAddedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ruleTableView.backgroundColor = [UIColor clearColor];
    self.ruleTableView.backgroundView = nil;
    [self.ruleTableView setTableFooterView:[UIView new]];
    self.ruleTableView.scrollEnabled = NO;
    
    self.selectionMenuIsOpen = NO;
    
    if (self.isEditMode) {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
    }
    else {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    }
    [self setBackgroundColorToLastNavigateColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        // Only resolve on viewWillAppear from parent when not editing rule.
        // (Resolve is called later for edit.)
        if (!self.isEditMode) {
            [self resolveRuleTemplate];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        self.ruleModel = nil;
    }
}

#pragma mark - UI Configuration

- (void)resolveRuleTemplate {
    if (self.ruleTemplate) {
        if (self.ruleResolution.ruleName.length == 0) {
            self.ruleResolution.ruleName = [self.ruleTemplate getAttribute:kAttrRuleTemplateName];
        }
        self.ruleResolution.templateSentence = (NSString *)[self.ruleTemplate getAttribute:@"ruletmpl:template"];
        
        if (self.placeId.length > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [RulesController resolveWithPlaceId:self.placeId
                                            onModel:self.ruleTemplate].then(^(NSDictionary *responseData) {
                    if (responseData) {
                        self.ruleResolution.selectorDictionary = responseData[@"selectors"];
                        
                        if (self.isEditMode) {
                            self.ruleResolution.ruleName = [RuleCapability getNameFromModel:self.ruleModel];
                            self.ruleResolution.ruleDescription = [RuleCapability getDescriptionFromModel:self.ruleModel];
                            [self.ruleResolution configurSelectionDictionariesForExistinRuleContext:[RuleCapability getContextFromModel:self.ruleModel]];
                        }
                        
                        [self configureView];
                    }
                }).catch(^(NSError *error) {
                    [self displayGenericErrorMessage];
                });
            });
        }
    }
}

- (void)configureView {
    [self.settingLabel setTemplateSentence:self.ruleResolution.cleanSentence
                          changeableParams:(self.isEditMode ? [self.ruleResolution cleanEditSentenceSelectors] : [self.ruleResolution cleanSentenceSelectors])
                                 withstype:self.sentenceType
                         andChangeableType:self.parameterType];
    
    [self.settingLabel setUserInteractionEnabled:self.isSatisfiable];
    
    clickableLabelTouchEvent touchEvent = ^(NSInteger orderID) {
        if (orderID >= 0) {
            self.currentEditingParamOrderID = orderID;
            
            [self openPopupMenu];
        }
    };
    self.settingLabel.touchEvent = touchEvent;
    
    [self navBarWithBackButtonAndTitle:[[self.ruleTemplate getAttribute:kAttrRuleTemplateName] uppercaseString]];
        
    [self.settingLabel setFooterSentence:self.settingsLabelText
                                   style:self.settingsLabelType];
    
    [self.saveButton styleSet:self.isSatisfiable ? NSLocalizedString(@"save", nil) : NSLocalizedString(@"shop now", nil)
                andButtonType:self.isEditMode ? FontDataTypeButtonLight : FontDataTypeButtonDark
                    upperCase:YES];
}

// This method should only be called from
- (void)configureViewToEditRuleModel:(RuleModel *)ruleModel {
    self.ruleModel = ruleModel;
    _isEditMode = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *templateId = [RuleCapability getTemplateFromModel:self.ruleModel];
        if (self.placeId.length > 0 && templateId.length > 0) {
            [RulesController getRuleTemplateModelForTemplateId:[RuleCapability getTemplateFromModel:self.ruleModel] placeId:self.placeId].then(^(RuleTemplateModel *matchingTemplate) {
                if (matchingTemplate) {
                    self.ruleTemplate = matchingTemplate;
                    
                    [self resolveRuleTemplate];
                }
            });
        }
    });
}

#pragma mark - Notifications
- (void)ruleAdded:(NSNotification *)note {
    if ([note.object isKindOfClass:[RuleModel class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideGif];
            
            self.ruleModel = note.object;
            
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Schedule a Rule", nil) subtitle:NSLocalizedString(@"Would you like to set up a schedule for this rule?", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"YES", nil) event:@selector(goToSchedule)], [PopupSelectionButtonModel create:NSLocalizedString(@"NO", nil) event:@selector(exit)], nil];
            buttonView.owner = self;
            [self popupWarning:buttonView complete:nil];
            // Display "Schedule" cell
            [self.ruleTableView reloadData];
        });
    }
}

- (void)exit {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goToSchedule {
    WeeklyScheduleViewController *vc = [WeeklyScheduleViewController create];
    vc.hasLightBackground = NO;
    
    ScheduleController.scheduleController = [RuleScheduleController new];
    ScheduleController.scheduleController.schedulingModelAddress = self.ruleModel.address;
    ScheduleController.scheduleController.ownerController = (SimpleTableViewController *)self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters & Setters
- (NSString *)placeId {
    return [[CorneaHolder shared] settings].currentPlace.modelId;
}

- (RuleTemplateResolutionModel *)ruleResolution {
    if (!_ruleResolution) {
        _ruleResolution = [[RuleTemplateResolutionModel alloc] init];
    }
    return _ruleResolution;
}

- (FontDataType)sentenceType {
    if (!_sentenceType) {
        _sentenceType = self.isEditMode ? FontDataType_DemiBold_18_WhiteAlpha_NoSpace : FontDataType_DemiBold_18_BlackAlpha_NoSpace;
    }
    return _sentenceType;
}

- (FontDataType)parameterType {
    if (!_parameterType) {
        _parameterType = self.isEditMode ? FontDataType_DemiBold_18_White_Underline_NoSpace : FontDataType_DemiBold_18_Black_Underline_NoSpace;
    }
    return _parameterType;
}

- (FontDataType)settingsLabelType {
    if (!_settingsLabelType) {
        _settingsLabelType = self.isEditMode ? FontDataType_Medium_12_WhiteAlpha_NoSpace : FontDataType_MediumMedium_12_BlackAlpha_NoSpace;
    }
    return _settingsLabelType;
}

- (NSString *)settingsLabelText {
    if (self.isSatisfiable) {
        _settingsLabelText = NSLocalizedString(@"\r\n\r\n\r\nTap on the underlined items to edit", nil);
    }
    else {
        _settingsLabelText = NSLocalizedString(@"\r\n\r\n\r\nOops! Looks like you need to pair an additional device for this rule to work", nil);
    }

    return _settingsLabelText;
}

- (BOOL)isSatisfiable {
    return _isSatisfiable = [[self.ruleTemplate getAttribute:@"ruletmpl:satisfiable"] boolValue];
}

- (NSDictionary *)cellTitleFontData {
    if (!_cellDescFontData) {
        if (self.isEditMode) {
            _cellTitleFontData = [FontData getBlackFontWithSize:14.0f
                                                           bold:NO
                                                        kerning:2.0f];
        }
    }
    
    return _cellTitleFontData;
}

- (NSDictionary *)cellDescFontData {
    return _cellDescFontData;
}

- (void)menuCompletionReceivedKey:(NSString *)keyString value:(id)value {
    NSString *selectorKey = self.ruleResolution.sentenceSelectors[self.currentEditingParamOrderID];
    
    if (keyString.length > 0 && value) {
        [self.ruleResolution.selectedKeyDictionary setObject:keyString forKey:selectorKey];
        [self.ruleResolution.selectedValueDictionary setObject:value forKey:selectorKey];
        
        [self.settingLabel substituteParam:self.currentEditingParamOrderID
                                        to:keyString];
    }
    else {
        if ([self.ruleResolution.selectedKeyDictionary objectForKey:selectorKey]) {
            [self.ruleResolution.selectedKeyDictionary removeObjectForKey:selectorKey];
        }
        
        if ([self.ruleResolution.selectedValueDictionary objectForKey:selectorKey]) {
            [self.ruleResolution.selectedValueDictionary removeObjectForKey:selectorKey];
        }
        
        [self.settingLabel substituteParam:self.currentEditingParamOrderID
                                        to:self.ruleResolution.sentenceSelectors[self.currentEditingParamOrderID]];
    }
}

#pragma mark - IBActions

- (IBAction)saveButtonPressed:(id)sender {
    if (self.isSatisfiable) {
        if ([self validateRuleSentence]) {
            if (!self.ruleModel) {
                [self saveNewRule];
            }
            else {
                [self saveExistingRule];
            }
        }
    }
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""] options:@{} completionHandler:nil];
    }
}

- (BOOL)validateRuleSentence {
    BOOL isValid = YES;
    NSString *errorMessage = nil;
    
    if (self.ruleResolution.ruleName.length == 0) {
        isValid = NO;
        errorMessage = NSLocalizedStringFromTable(@"Please enter a name for this rule.", @"ErrorMessages", nil);
    }
    
    for (NSString *selectorKeys in self.ruleResolution.sentenceSelectors) {
        if (![self.ruleResolution.selectedValueDictionary objectForKey:selectorKeys]) {
            isValid = NO;
            errorMessage = NSLocalizedStringFromTable(@"Please select a", @"ErrorMessages", nil);
            errorMessage = [NSString stringWithFormat:@"%@ %@", errorMessage, selectorKeys];
            break;
        }
    }
    
    if (!isValid) {
        [self displayErrorMessage:errorMessage];
    }
    
    return isValid;
}

- (void)saveNewRule {
    if (self.placeId.length > 0) {
        [self createGif];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ruleAdded:) name:Constants.kModelAddedNotification object:nil];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            [RulesController createRuleWithPlaceId:self.placeId
                                          withName:self.ruleResolution.ruleName
                                   withDescription:self.ruleResolution.ruleDescription
                                       withContext:self.ruleResolution.selectedValueDictionary
                                           onModel:self.ruleTemplate].then(^(NSObject *obj) {
            }).catch(^(NSError *error) {
                [self displayErrorMessage:error.localizedDescription];
            }).finally(^ {
                [self hideGif];
            });
        });
    }
}

- (void)saveExistingRule {
    if (self.placeId.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            [RulesController updateRuleWithName:self.ruleResolution.ruleName
                                withDescription:self.ruleResolution.ruleDescription
                                    withContext:self.ruleResolution.selectedValueDictionary
                                        onModel:self.ruleModel].then(^(NSObject *obj) {
                if (self.isEditMode) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }).catch(^(NSError *error) {
                [self displayErrorMessage:error.localizedDescription];
            });
        });
    }
}

// Close the picker
- (IBAction)closeSelectionMenu:(id)sender {
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 70;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.ruleModel) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"RuleCell";
        
        ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (!cell) {
            cell = [[ArcusTitleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:CellIdentifier];

        }

        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];

        UIColor *textColor = self.isEditMode ? [UIColor whiteColor] : [UIColor blackColor];
        
        NSString *titleString = [NSLocalizedString(@"Rule Name", @"") uppercaseString];
        NSDictionary *titleAttributes = [FontData getFontWithSize:14.0f
                                                             bold:NO
                                                          kerning:2.0f
                                                            color:textColor];
        NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:titleString
                                                                        attributes:titleAttributes];
        [cell.titleLabel setAttributedText:titleText];
        
        NSString *descriptionString = (self.ruleResolution.ruleName.length > 0) ? self.ruleResolution.ruleName : [self.ruleTemplate getAttribute:kAttrRuleTemplateName];
        descriptionString = (indexPath.row == 0) ? descriptionString : NSLocalizedString(@"", @"");
        if (descriptionString) {
            NSDictionary *descriptionAttributes = [FontData getFontWithSize:14.0f
                                                                       bold:NO
                                                                    kerning:0.0f
                                                                      color:[textColor colorWithAlphaComponent:0.6f]];
            NSAttributedString *descriptionText = [[NSAttributedString alloc] initWithString:descriptionString
                                                                                  attributes:descriptionAttributes];
            [cell.descriptionLabel setAttributedText:descriptionText];
        }
        
        if (self.isEditMode) {
            cell.accessoryImage.image = [UIImage imageNamed:@"RuleBlackChevron"].invertColor;
        }
        
        return cell;
    }
    else {
        RuleSchduleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell"];

        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];

        [cell.titleLabel styleSet:@"Schedule" andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:!self.isEditMode space:YES] upperCase:YES];
        [cell.subtitleLabel styleSet:@"Choose the time window this Rule is active." andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:!self.isEditMode space:NO alpha:YES]];
        if (self.isEditMode) {
            cell.accessoryImage.image = [UIImage imageNamed:@"RuleBlackChevron"].invertColor;
        }
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:kSegueSetRuleName sender:self];
    }
    else if (indexPath.row == 1) {
        [self goToSchedule];
    }
}

#pragma mark - PrepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueSetRuleName]) {
        RuleEditNameViewController *ruleEditNameViewController = (RuleEditNameViewController *)segue.destinationViewController;
        RuleEditNameCompletion completion = ^ (NSString *ruleName) {
            self.ruleResolution.ruleName = ruleName;
            [self.ruleTableView reloadData];
        };
        ruleEditNameViewController.completion = completion;
        ruleEditNameViewController.ruleName = self.ruleResolution.ruleName;
        ruleEditNameViewController.editMode = self.isEditMode;
    }
}

#pragma mark - Open & Close Selection Menu
- (void)openPopupMenu {
    NSString *selectorKey = self.ruleResolution.sentenceSelectors[self.currentEditingParamOrderID];
    NSString *type = [self.ruleResolution optionsTypeForSelectorKey:selectorKey];
    NSArray *optionsArray = [self.ruleResolution optionsArrayForSelectorKey:selectorKey];

    NSString *title = selectorKey.length > 0 ? [NSString stringWithFormat:@"choose a %@", selectorKey].uppercaseString : 0;
    
    if ([type isEqualToString:kOptionTypeList]) {
        id optionModel = [self modelObjectForOptionValue:optionsArray[0][1]];
        if ([optionModel isKindOfClass:[DeviceModel class]] ||
            [optionModel isKindOfClass:[PersonModel class]]) {
            NSString *currentValue = self.ruleResolution.selectedValueDictionary[selectorKey];

            NSMutableArray<PopupSelectionLogoItemModel *> *items = [[NSMutableArray alloc] init];
            
            for (NSArray *params in optionsArray) {
                Model *model = [[[CorneaHolder shared] modelCache] fetchModel:params[1]];
                
                if ([model isKindOfClass:[PersonModel class]]) {
                    [items addObject:[[[PopupSelectionLogoItemModel createWithPersonModel:(PersonModel *)model selected:[currentValue isEqualToString:params[1]]] setTitleText:params[0]] setReturnObj:params]];
                }
                if ([model isKindOfClass:[DeviceModel class]]) {
                    [items addObject:[[[PopupSelectionLogoItemModel createWithDeviceModel:(DeviceModel *)model selected:[currentValue isEqualToString:params[1]]] setTitleText:params[0]] setReturnObj:params]];
                }
            }
            _popupPickerContainer = [PopupSelectionLogoTextView create:title items:items];
            [self popupWithBlockSetCurrentValue:_popupPickerContainer currentValue:currentValue completeBlock:^(id selectedValue) {
                if (selectedValue) {
                    [self menuCompletionReceivedKey:selectedValue[0] value:selectedValue[1]];
                }
            }];
        }
        else if ([optionsArray[0] isKindOfClass:[NSArray class]] && [selectorKey isEqualToString:kOptionTypeForAWhile]) {
            NSString *title = NSLocalizedString(@"Duration", "");
            NSString *currentValue = self.ruleResolution.selectedKeyDictionary[selectorKey];
            
            OrderedDictionary *dic = [self orderedDictionaryOptionsWithOptions:optionsArray];
            
            _popupPickerContainer = [PopupSelectionTextPickerView create:title list:dic];
            
            [self popupWithBlockSetCurrentValue:_popupPickerContainer currentValue:currentValue completeBlock:^(id selectedValue) {
                if (selectedValue) {
                    [self menuCompletionReceivedKey:selectedValue[0] value:selectedValue[1]];
                }
            }];
        }
        else if ([selectorKey isEqualToString:kOptionTypeDuration] ||
                 ([selectorKey isEqualToString:@"button"]) ||
                 ([optionsArray[0] isKindOfClass:[NSArray class]]) ) {
            
            NSString *currentValue = self.ruleResolution.selectedKeyDictionary[selectorKey];

            OrderedDictionary *dic = [[OrderedDictionary alloc] init];
            
            for (NSArray *item in optionsArray) {
                dic[item[0]] = item;
            }
            _popupPickerContainer = [PopupSelectionTextPickerView create:title list:dic];
            
            [self popupWithBlockSetCurrentValue:_popupPickerContainer currentValue:currentValue completeBlock:^(id selectedValue) {
                if (selectedValue) {
                    [self menuCompletionReceivedKey:selectedValue[0] value:selectedValue[1]];
                }
            }];
        }
    }
    else if ([type isEqualToString:kOptionTypeTimeRange]) {
        NSString *currentValue = self.ruleResolution.selectedValueDictionary[selectorKey];

        PopupSelectionNumberView *picker = [PopupSelectionNumberView create:title withMinNumber:30 maxNumber:100 stepNumber:1 withSign:@""];
        
        _popupPickerContainer = picker;
        // To handle the closing call back
        [self popupWithBlockSetCurrentValue:_popupPickerContainer currentValue:@([currentValue integerValue]) completeBlock:^(id selectedValue) {
            if (selectedValue) {
                [self updateSelectedValueInRule:selectedValue];
            }
        }];
    }
    self.selectionMenuIsOpen = YES;
}

- (NSArray *)orderedDurationWithOptions:(NSArray *)optionsArray {
    NSMutableArray *orderedArray = [NSMutableArray arrayWithArray:optionsArray];
    [orderedArray sortUsingComparator: ^ NSComparisonResult(NSArray *item1, NSArray *item2) {
        if (((NSString *)item1[1]).intValue < ((NSString *)item2[1]).intValue) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    
    return orderedArray;
}

- (OrderedDictionary *)orderedDictionaryOptionsWithOptions:(NSArray *)optionsArray {
    OrderedDictionary *dic = [[OrderedDictionary alloc] init];
    NSArray *orderedOptionsArray = [self orderedDurationWithOptions:optionsArray];
    
    for (int index = 0 ;index < orderedOptionsArray.count; index++) {
        NSArray *item = orderedOptionsArray[index];
        [dic insertObject:item forKey:item[0] atIndex:index];
    }
    
    return dic;
}

- (void)updateSelectedValueInRule:(id)selectedValue {
    // TODO: update the rule with this value
    // First we need to figure out how to determine which rule value needs to be updated
}

- (id)modelObjectForOptionValue:(NSString *)optionValue {
    id returnObject = nil;
    if (optionValue) {
        if ([optionValue containsString:[PersonService address]]) {
            PersonModel *personModel = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:optionValue];

            if (personModel) {
                returnObject = personModel;
            }
        }
        else if ([optionValue containsString:DeviceCapability.namespace]) {
            DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:optionValue];

            if (deviceModel) {
                returnObject = deviceModel;
            }
        }
    }
    return returnObject;
}

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


- (void)openSelectionMenu {
    if (self.selectionMenuIsOpen) {
        [self closeSelectionMenu];
    }
    
    self.selectionContainerDismissOverlayView.hidden = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ (void) {
                         [self.view layoutIfNeeded];
                     }
                     completion:^ (BOOL finished) {
                         
                     }];
    
    self.selectionMenuIsOpen = !self.selectionMenuIsOpen;
}

- (void)closeSelectionMenu {
    if (self.selectionMenuIsOpen) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ (void) {
                             [self.view layoutIfNeeded];
                         }
                         completion:^ (BOOL finished) {
                             
                         }];
        
        self.selectionMenuIsOpen = !self.selectionMenuIsOpen;
        self.selectionContainerDismissOverlayView.hidden = YES;
    }
}

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
                                         style:PopupWindowStyleMessageWindow];
}

@end
