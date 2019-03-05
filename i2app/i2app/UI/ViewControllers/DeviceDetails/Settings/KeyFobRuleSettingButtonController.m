//
//  KeyFobRuleSettingButtonController.m
//  i2app
//
//  Created by Arcus Team on 10/6/15.
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
#import "KeyFobRuleSettingButtonController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "UIImage+ImageEffects.h"

#import "DeviceSettingModels.h"

#import "AlertActionSheetViewController.h"

#import "RulesController.h"
#import "DeviceCapability.h"
#import "RuleCapability.h"

@interface KeyFobRuleSettingButtonController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (atomic, assign) ButtonType buttonType;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleAreaHeightConstraint;
@property (nonatomic, strong) NSArray <RuleModel *> *rules;
@property (strong, nonatomic) DeviceModel *deviceModel;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger initiallySelectedButtonIndex;

@end

@implementation KeyFobRuleSettingButtonController {
    NSArray                 *_ruleTemplateNames;
    NSArray                 *_ruleTemplateIds;
    
    int                     _activateRuleRowIndex;
    
    DeviceSettingUnitBase * _unit;
}

+ (KeyFobRuleSettingButtonController *)create:(ButtonType)buttonType device:(DeviceModel*)deviceModel  {
    KeyFobRuleSettingButtonController *controller = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.buttonType = buttonType;
    controller.deviceModel = deviceModel;
    return controller;
}

- (void)setPopupOwner:(DeviceSettingUnitBase *)unit Style:(BOOL)style {
    _popupStyle = style;
    _unit = unit;
}

- (void)setInitiallySelectedButtonIndex:(NSInteger)initiallySelectedButtonIndex {
    _initiallySelectedButtonIndex = initiallySelectedButtonIndex;
    self.selectedIndex = initiallySelectedButtonIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = -1;
    self.initiallySelectedButtonIndex = -1;
    
    if (_popupStyle) {
        [self.titleLabel styleSet:@"Select an action" andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:YES] upperCase:YES];
        
        self.titleAreaHeightConstraint.constant = 80.0f;
        [self.titleLabel setHidden:NO];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.closeButton setHidden:NO];
    } else {
        self.titleAreaHeightConstraint.constant = -1.0f;
        [self.titleLabel setHidden:YES];
        [self setBackgroundColorToLastNavigateColor];
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [self.closeButton setHidden:YES];
    }
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    if (self.buttonType != ButtonTypeNone) {
        self.title = ButtonTypeToString(self.buttonType);
    } else {
        self.title = self.deviceModel.name.uppercaseString;
    }
    [self navBarWithBackButtonAndTitle:self.title];
    
    NSString *buttonName = self.buttonType != ButtonTypeNone ? ButtonTypeToString(self.buttonType) : nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [RulesController listRulesWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId forDevice:self.deviceModel forButton:buttonName].then(^(NSArray *rules) {
            self.rules = rules;
            
            if (self.rules.count == 0) {
                self.initiallySelectedButtonIndex = _activateRuleRowIndex;
            } else {
                RuleModel *rule = self.rules[0];
                self.initiallySelectedButtonIndex = (int)[_ruleTemplateIds indexOfObject:[RuleCapability getTemplateFromModel:rule]];
            }
          
            if (self.initiallySelectedButtonIndex < 0) {
                self.initiallySelectedButtonIndex = _activateRuleRowIndex;
            }
            
            if (self.initiallySelectedButtonIndex >= 0 && self.initiallySelectedButtonIndex < [self.tableView numberOfRowsInSection:0]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.initiallySelectedButtonIndex
                                                                        inSection:0]
                                            animated:YES
                                      scrollPosition:UITableViewScrollPositionNone];
            }
        }).catch(^(NSError *error) {
            [self displayGenericErrorMessage];
        });
    });
    NSString *productId = [DeviceCapability getProductIdFromModel:self.deviceModel];
    if ([productId isEqualToString:kGen3FourButtonFob]) {
        _ruleTemplateNames = [DeviceModel arcusGen3FourButtonFobRuleTemplateLongNames];
        _ruleTemplateIds = kGen3FourButtonFobRuleTemplateIds;
        _activateRuleRowIndex = 4;
    }
    else if ([productId isEqualToString:kGen2FourButtonFob]) {
        _ruleTemplateNames = [DeviceModel arcusGen2FourButtonFobRuleTemplateLongNames];
        _ruleTemplateIds = kGen2FourButtonFobRuleTemplateIds;
        _activateRuleRowIndex = 4;
    }
    else if ([productId isEqualToString:kGen1TwoButtonFob]) {
        _ruleTemplateNames = [DeviceModel arcusGen1TwoButtonFobRuleTemplateLongNames];
        _ruleTemplateIds = kGen1TwoButtonFobRuleTemplateIds;
        _activateRuleRowIndex = 4;
    }
    else if ([productId isEqualToString:kGen1SmartButton] ||
             [productId isEqualToString:kGen2SmartButton]) {
        _ruleTemplateNames = [DeviceModel arcusSmartButtonRuleTemplateNames];
        _ruleTemplateIds = kSmartButtonRuleTemplateIds;
        _activateRuleRowIndex = 2;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tableView.separatorColor = _popupStyle ? [[UIColor blackColor] colorWithAlphaComponent:0.6f] : [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
}

- (IBAction)onClickClose:(id)sender {
    [self back:sender];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ruleTemplateNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == _ruleTemplateIds.count ? 70.0f : 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isActivateRule = indexPath.row == _ruleTemplateIds.count;

    NSString *cellIdentifier = isActivateRule ? @"ArcusSelectionCellMultiLine" : @"ArcusSelectionCellSingleLine";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:cellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLabel.text = _ruleTemplateNames[indexPath.row];
    cell.titleLabel.textColor = _popupStyle ? [UIColor blackColor] : [UIColor whiteColor];
    
    if (!_popupStyle) {
        cell.selectionImage.image = [[UIImage imageNamed:@"RoleUncheckButton"] invertColor];
        cell.selectionImage.highlightedImage = [[UIImage imageNamed:@"RoleCheckedIcon"] invertColor];
    }
    
    if (isActivateRule) {
        cell.descriptionLabel.text = NSLocalizedString(@"Use this button to trigger a rule", @"");
        cell.descriptionLabel.textColor = _popupStyle ? [[UIColor blackColor] colorWithAlphaComponent:0.6f] : [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSelected:(indexPath.row == self.initiallySelectedButtonIndex)
             animated:YES];
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row <= _activateRuleRowIndex) {
        self.selectedIndex = indexPath.row;
    } else {
        [self presentViewController:[ AlertActionSheetViewController create:AlertActionTypePremimumRuleTEASER] animated:YES completion:nil];
    }
}

- (void)back:(NSObject *)sender {
    // try to save the rule
    
    if (self.selectedIndex != self.initiallySelectedButtonIndex) {
        NSDictionary *contextDict;
        NSString *productId = [DeviceCapability getProductIdFromModel:self.deviceModel];

        if ([productId isEqualToString:kGen2FourButtonFob] || [productId isEqualToString:kGen3FourButtonFob]) {
              contextDict = @{@"smart fob" : self.deviceModel.address, @"button" : ButtonTypeToString(self.buttonType)};
        } else if ([productId isEqualToString:kGen1TwoButtonFob]) {
            contextDict = @{@"key fob" : self.deviceModel.address, @"button" : ButtonTypeToString(self.buttonType)};
        } else if ([productId isEqualToString:kGen1SmartButton] ||
                 [productId isEqualToString:kGen2SmartButton]) {
            contextDict = @{@"button" : self.deviceModel.address};
        }
        
        if (self.rules.count > 0 &&
            (self.selectedIndex == _activateRuleRowIndex ||
             self.selectedIndex != self.initiallySelectedButtonIndex)) {
            // From all the rules delete only the rules that have been
            // created through this functionality. The rest of the rules
            // we need to leave
            
            NSMutableArray<RuleModel *> *rulesToDelete = [[NSMutableArray alloc] initWithCapacity:self.rules.count];
            for (RuleModel *rule in self.rules) {
                if ([_ruleTemplateIds containsObject:[RuleCapability getTemplateFromModel:rule]]) {
                    [rulesToDelete addObject:rule];
                }
            }
                
            if (rulesToDelete.count > 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [RulesController deleteRules:rulesToDelete].thenInBackground(^ {
                        [self addRule:self.selectedIndex withContect:contextDict];
                    });
                });
                return;
            } else {
                [self addRule:self.selectedIndex withContect:contextDict];
                return;
            }
        } else {
            [self addRule:self.selectedIndex withContect:contextDict];
            return;
        }
    }
    [self dismissViewController];
}

- (void)addRule:(NSInteger)templateIdIndex withContect:(NSDictionary *)contextDict {
    // If the selection is "Activate a Rule" - no need to add a template
    if (templateIdIndex < _ruleTemplateIds.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            [RulesController createRuleWithTemplateId:_ruleTemplateIds[templateIdIndex] withPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId withContext:contextDict].then(^ {
                [self dismissViewController];
            }).catch(^(NSError *error) {
                DDLogWarn(@"Adding template error: %@", error.localizedDescription);
                [self displayGenericErrorMessage];
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewController];
        });
    }
}

- (void)dismissViewController {
    if (_popupStyle) {
        [self dismissViewControllerAnimated:YES completion:^{
            [_unit loadData];
        }];
    } else {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [_unit loadData];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [CATransaction commit];
    }
}

@end
