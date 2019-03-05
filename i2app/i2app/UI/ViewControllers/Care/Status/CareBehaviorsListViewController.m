 //
//  CareBehaviorsListViewController.m
//  i2app
//
//  Created by Arcus Team on 2/1/16.
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
#import "CareBehaviorsListViewController.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"
#import "ArcusTwoLabelTableViewSectionHeader.h"
#import "CareAddEditBehaviorViewController.h"
#import "ArcusCheckableCell.h"
#import "CareBehaviorModel.h"
#import "CareSubsystemCapability.h"

#define ESTIMATED_ROW_HEIGHT 105.0f
#define CALENDAR_LEFT_PADDING 10.0f

@interface CareBehaviorsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTextLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property(nonatomic, strong) NSArray<CareBehaviorModel *> *allBehaviors;
@property(nonatomic, strong) NSArray<CareBehaviorTemplateModel *> *templates;

@end

@implementation CareBehaviorsListViewController

NSString *const careBehaviorListNavBarTitle = @"Care Behaviors";

#pragma mark - Creation

+ (CareBehaviorsListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CareStatus" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareBehaviorsListViewController class])];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ArcusTwoLabelTableViewSectionHeader class]) bundle:nil]
forHeaderFooterViewReuseIdentifier:@"sectionHeader"];
    
    [self registerForNotifications];
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self navBarWithBackButtonAndTitle:careBehaviorListNavBarTitle];
    [self loadDataAndFetchTemplates:YES];
}

- (void)dealloc {
    [self deregisterForNotifications];
}

#pragma mark - Data
- (void)loadDataAndFetchTemplates:(BOOL)shouldFetchTemplates {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createGif];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SubsystemsController sharedInstance].careController listBehaviors].then(^(NSArray<CareBehaviorModel *> *behaviors) {
            _allBehaviors = behaviors;
            if (shouldFetchTemplates) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[SubsystemsController sharedInstance].careController listBehaviorTemplates].then(^(NSArray<CareBehaviorTemplateModel *> *templates) {
                        _templates = templates;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideGif];
                        });
                        [self updateUI];
                    });
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideGif];
                });
                [self updateUI];
            }
        });
    });
}

#pragma mark - UI
- (void)adjustHeaderViewSize {
    CGSize headerNewSize = [self.headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint headerOrigin = self.headerView.frame.origin;
    self.headerView.frame = CGRectMake(headerOrigin.x,
                                       headerOrigin.y,
                                       headerNewSize.width,
                                       headerNewSize.height);
}

- (void)updateUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *subText;
        
        if (_allBehaviors.count == 0) {
            subText = NSLocalizedString(@"Behavior List Add Behaviors", nil);
        } else {
            subText = NSLocalizedString(@"Behavior List Turn On Behaviors", nil);
        }
        
        [self.subTextLabel setText:subText];
        [self adjustHeaderViewSize];
        [self.tableView reloadData];
        [self manageNavBar];
    });
}

- (void)manageNavBar {
    if (_allBehaviors.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        NSString *editButtonTitle;
        if (self.tableView.isEditing) {
            editButtonTitle = NSLocalizedString(@"Done", nil);
        } else {
            editButtonTitle = NSLocalizedString(@"Edit", nil);
        }
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setAttributedTitle:[FontData getString:[editButtonTitle uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
        rightButton.frame = CGRectMake(0, 0, 50, 12);
        [rightButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allBehaviors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ArcusCheckableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"behaviorCell"];
#pragma clang diagnostic pop
    CareBehaviorModel *behavior = _allBehaviors[indexPath.row];
    
    cell.titleLabel.text = behavior.name;
    cell.descriptionLabel.text = [self templateForID:behavior.templateId].templateDescription;
    cell.isChecked = behavior.enabled;
    
    if (behavior.timeWindows.count > 0) {
        cell.detailImageView.hidden = NO;
        cell.detailImageView.tintColor = [UIColor whiteColor];
        cell.descriptionLabelRightHorizontalConstraint.constant = CALENDAR_LEFT_PADDING;
    } else {
        cell.detailImageView.hidden = YES;
        cell.descriptionLabelRightHorizontalConstraint.constant = 0;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(behaviorEnableCheckPressed:)];
    [cell.checkMarkImageView addGestureRecognizer:gestureRecognizer];
    cell.checkMarkImageView.tag = indexPath.row;//Used for determining which enabled button was tapped
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ESTIMATED_ROW_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CareBehaviorModel *behavior = [_allBehaviors[indexPath.row] copy];
    CareBehaviorTemplateModel *template = [self templateForID:behavior.templateId];
    CareAddEditBehaviorViewController *vc = [CareAddEditBehaviorViewController createWithBehavior:behavior andTemplate:template];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SubsystemsController sharedInstance].careController removeBehavior:_allBehaviors[indexPath.row]].then(^(NSNumber *didRemove) {
                BOOL removed = [didRemove boolValue];
                if (removed) {
                    [self loadDataAndFetchTemplates:NO];
                    [self updateUI];
                }
            });
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header;
    
    if (_allBehaviors.count > 0) {
        ArcusTwoLabelTableViewSectionHeader *sectionHeader = (ArcusTwoLabelTableViewSectionHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader"];
        [sectionHeader.accessoryTextLabel setText:[NSString stringWithFormat:@"%li", (unsigned long)_allBehaviors.count]];
        sectionHeader.hasBlurEffect = YES;
        sectionHeader.backingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
        header = sectionHeader;
    } else {
        header = [UIView new];
    }
    
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Selectors
- (void)editButtonPressed:(id)sender {
    [self.tableView setEditing:!self.tableView.isEditing];
    [self manageNavBar];
    [self.tableView reloadData];
}

- (void)behaviorEnableCheckPressed:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *gestureRecognizer = (UITapGestureRecognizer *)sender;
        NSInteger index = gestureRecognizer.view.tag;
        
        CareBehaviorModel *behavior = _allBehaviors[index];
        behavior.enabled = !behavior.enabled;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[SubsystemsController sharedInstance].careController updateBehavior:behavior].then(^(NSString *response) {
                [self loadDataAndFetchTemplates:NO];
            });
        });
        
        
    }
}

#pragma mark - Helpers
- (CareBehaviorTemplateModel *)templateForID:(NSString *)templateID {
    CareBehaviorTemplateModel *returnTemplate;
    
    for (CareBehaviorTemplateModel *template in _templates) {
        if ([template.templateIdentifier isEqualToString:templateID]) {
            returnTemplate = template;
            break;
        }
    }
    
    return returnTemplate;
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAndFetchTemplates:) name:[Model attributeChangedNotification:kAttrCareSubsystemBehaviors] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAndFetchTemplates:) name:[Model attributeChangedNotification:kAttrCareSubsystemActiveBehaviors] object:nil];
}

- (void)deregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[Model attributeChangedNotification:kAttrCareSubsystemBehaviors] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[Model attributeChangedNotification:kAttrCareSubsystemActiveBehaviors] object:nil];
}

@end
