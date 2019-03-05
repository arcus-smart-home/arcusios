//
//  SmartButtonSelectionController.m
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
#import "SmartButtonSelectionController.h"
#import "RulesController.h"

#import "DeviceCapability.h"
#import "CommonCheckableCell.h"
#import "AlertActionSheetViewController.h"

#import "RuleCapability.h"
#import "DevicePairingWizard.h"
#import "DevicePairingManager.h"



@interface SmartButtonSelectionController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray * settingArray;
@property (strong, nonatomic) NSArray *rules;

@end

@implementation SmartButtonSelectionController{
    NSArray                 *_ruleTemplateNames;
    NSArray                 *_ruleTemplateIds;
    
    int                     _initiallySelectedButtonIndex;
    int                     _activateRuleRowIndex;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Smart Button", nil);
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step device:(DeviceModel*)deviceModel {
    SmartButtonSelectionController *vc = [self createWithDeviceStep:step];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToParentColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [_nextButton styleSet:NSLocalizedString(@"NEXT", nil) andButtonType:FontDataTypeButtonDark];

    [self navBarWithBackButtonAndTitle:self.title];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [RulesController listRulesWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId forDevice:self.deviceModel forButton:nil].then(^(NSArray *rules) {
            self.rules = rules;
            
            if (self.rules.count > 1 || self.rules.count == 0) {
                _initiallySelectedButtonIndex = _activateRuleRowIndex;
            }
            else {
                RuleModel *rule = self.rules[0];
                _initiallySelectedButtonIndex = (int)[_ruleTemplateIds indexOfObject:[RuleCapability getTemplateFromModel:rule]];
            }
            [self.tableView reloadData];
        }).catch(^(NSError *error) {
            [self displayGenericErrorMessage];
        });
    });
    
    _ruleTemplateNames = [DeviceModel arcusSmartButtonRuleTemplateNames];
    _ruleTemplateIds = kSmartButtonRuleTemplateIds;
    _activateRuleRowIndex = 1;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ruleTemplateNames.count;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        for (int row = 0; row < [tableView numberOfRowsInSection:0]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            CommonCheckableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setSelectedBox:NO];
        }
        [((CommonCheckableCell *)[tableView cellForRowAtIndexPath:indexPath]) setSelectedBox:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CommonCheckableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBlackTitle:_ruleTemplateNames[indexPath.row]];
    
    [cell setSelectedBox:indexPath.row == _initiallySelectedButtonIndex];
}

- (void)nextButtonPressed:(id)sender {
    // try to save the rule
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        CommonCheckableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.cellSelected) {
            NSDictionary *contextDict;
            BOOL deleteRules = NO;
            contextDict = @{@"button" : self.deviceModel.address};
        
            if (self.rules.count > 0 && (row == _activateRuleRowIndex || row != _initiallySelectedButtonIndex)) {
                deleteRules = YES;
            }
            if (deleteRules) {
                // From all the rules delete only the rules that have been
                // created through this functionality. The rest of the rules
                // we need to leave
                
                NSMutableArray *rulesToDelete = [[NSMutableArray alloc] initWithCapacity:self.rules.count];
                for (RuleModel *rule in self.rules) {
                    if ([_ruleTemplateIds containsObject:[RuleCapability getTemplateFromModel:rule]]) {
                        [rulesToDelete addObject:rule];
                    }
                }
                if (rulesToDelete.count > 0) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                        [RulesController deleteRules:rulesToDelete].thenInBackground(^ {
                            [self addRule:row withContect:contextDict andSender:sender];
                        });
                    });
                }
                else {
                    [self addRule:row withContect:contextDict andSender:sender];
                }
            }
            else {
                [self addRule:row withContect:contextDict andSender:sender];
            }
            break;
        }
    }
}
#pragma clang diagnostic pop

- (void)addRule:(int)templateIdIndex withContect:(NSDictionary *)contextDict andSender:(id)sender {
    // If the selection is "Activate a Rule" - no need to add a template
    if (templateIdIndex < _ruleTemplateIds.count) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            
            [RulesController createRuleWithTemplateId:_ruleTemplateIds[templateIdIndex] withPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId withContext:contextDict].then(^ {
                [super nextButtonPressed:sender];
            }).catch(^(NSError *error) {
                DDLogWarn(@"Adding template error: %@", error.localizedDescription);
                [self displayGenericErrorMessage];
            });
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [super nextButtonPressed:sender];

        });
    }
}


@end
