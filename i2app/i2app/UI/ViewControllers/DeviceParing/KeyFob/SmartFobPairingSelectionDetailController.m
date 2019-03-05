//
//  SmartFobPairingSelectionDetailController.m
//  i2app
//
//  Created by Arcus Team on 7/14/15.
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
#import "SmartFobPairingSelectionDetailController.h"


#import "CommonCheckableCell.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "RulesController.h"
#import "DeviceCapability.h"
#import "RuleCapability.h"

@interface SmartFobPairingSelectionDetailController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *settingArray;
@property (nonatomic, strong) NSArray *rules;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (strong, nonatomic) DeviceModel *deviceModel;

@end

@implementation SmartFobPairingSelectionDetailController {
    NSArray                 *_ruleTemplateNames;
    NSArray                 *_ruleTemplateIds;
    
    int                     _initiallySelectedButtonIndex;
    int                     _activateRuleRowIndex;
}

+ (SmartFobPairingSelectionDetailController *)createWithDeviceModel:(DeviceModel*)deviceModel {
    SmartFobPairingSelectionDetailController *controller = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SmartFobPairingSelectionDetailController class])];
    controller.deviceModel = deviceModel;
    return controller;
}

+ (SmartFobPairingSelectionDetailController *)create:(ButtonType)buttonType device:(DeviceModel*)deviceModel {
    SmartFobPairingSelectionDetailController *controller = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.buttonType = buttonType;
    controller.deviceModel = deviceModel;
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"key fob", nil).uppercaseString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToParentColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];

    _initiallySelectedButtonIndex = -1;
    self.selectedIndex = -1;
    
    if (self.buttonType != ButtonTypeNone) {
        self.title = ButtonTypeToString(self.buttonType);
    }
    else {
        self.title = [NSLocalizedString(@"Settings", nil) uppercaseString];
    }
    [self navBarWithBackButtonAndTitle:self.title];
    
    NSString *buttonName = self.buttonType != ButtonTypeNone ? ButtonTypeToString(self.buttonType) : nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [RulesController listRulesWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId forDevice:self.deviceModel forButton:buttonName].then(^(NSArray *rules) {
            self.rules = rules;
            
            if (self.rules.count > 1 || self.rules.count == 0) {
                _initiallySelectedButtonIndex = _activateRuleRowIndex;
            }
            else {
                RuleModel *rule = self.rules[0];
                _initiallySelectedButtonIndex = (int)[_ruleTemplateIds indexOfObject:[RuleCapability getTemplateFromModel:rule]];
            }

            if (_initiallySelectedButtonIndex == -1) {
                _initiallySelectedButtonIndex = (int)_ruleTemplateNames.count - 1;
            }
            
            if (_initiallySelectedButtonIndex >= 0 && _initiallySelectedButtonIndex < [self.tableView numberOfRowsInSection:0]) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_initiallySelectedButtonIndex
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
    } else if ([productId isEqualToString:kGen2FourButtonFob]) {
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ruleTemplateNames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isActivateRule = [_ruleTemplateNames[indexPath.row] isEqualToString:NSLocalizedString(@"Activate a Rule", nil)];
    
    return isActivateRule ? 70.0f : 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isActivateRule = [_ruleTemplateNames[indexPath.row] isEqualToString:NSLocalizedString(@"Activate a Rule", nil)];
    
    NSString *cellIdentifier = isActivateRule ? @"ArcusSelectionCellMultiLine" : @"ArcusSelectionCellSingleLine";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:cellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.titleLabel.text = _ruleTemplateNames[indexPath.row];
    
    if ([_ruleTemplateNames[indexPath.row] isEqualToString:NSLocalizedString(@"Activate a Rule", nil)]) {
        cell.descriptionLabel.text = NSLocalizedString(@"Use this button to trigger a rule", @"");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSelected:(indexPath.row == _initiallySelectedButtonIndex)
             animated:YES];
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= _activateRuleRowIndex) {
        self.selectedIndex = indexPath.row;
    }
}

- (void)back:(NSObject *)sender {
    // try to save the rule
    if (self.selectedIndex != -1 &&
        self.selectedIndex != _initiallySelectedButtonIndex) {
        NSDictionary *contextDict;
        NSString *productId = [DeviceCapability getProductIdFromModel:self.deviceModel];

        if ([productId isEqualToString:kGen2FourButtonFob]
            || [productId isEqualToString:kGen3FourButtonFob]) {
            contextDict = @{@"smart fob" : self.deviceModel.address, @"button" : ButtonTypeToString(self.buttonType)};
        } else if ([productId isEqualToString:kGen1TwoButtonFob]) {
            contextDict = @{@"key fob" : self.deviceModel.address, @"button" : ButtonTypeToString(self.buttonType)};
        } else if ([productId isEqualToString:kGen1SmartButton] ||
                   [productId isEqualToString:kGen2SmartButton]) {
            contextDict = @{@"button" : self.deviceModel.address};
        }
        
        if (self.rules.count > 0 &&
            (self.selectedIndex == _activateRuleRowIndex ||
             self.selectedIndex != _initiallySelectedButtonIndex)) {
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRule:(NSInteger)templateIdIndex withContect:(NSDictionary *)contextDict {
    // If the selection is "Activate a Rule" - no need to add a template
    if (templateIdIndex < _ruleTemplateIds.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            [RulesController createRuleWithTemplateId:_ruleTemplateIds[templateIdIndex] withPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId withContext:contextDict].then(^ {
                [self.navigationController popViewControllerAnimated:YES];
            }).catch(^(NSError *error) {
                DDLogWarn(@"Adding template error: %@", error.localizedDescription);
                [self displayGenericErrorMessage];
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end







