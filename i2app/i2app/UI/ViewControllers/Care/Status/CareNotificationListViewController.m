//
//  CareNotificationListViewController.m
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
#import "CareNotificationListViewController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"


#import "UIImage+ImageEffects.h"

NSString *const kNotificationListCellIdentifier = @"notificationListCell";

@interface CareNotificationListViewController ()

@property (nonatomic, strong) NSArray *notificationList;
@property (nonatomic, strong) CareSubsystemController *careSubsystemController;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;

@end


@implementation CareNotificationListViewController

+ (CareNotificationListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CareStatus" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareNotificationListViewController class])];
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navigationItem.title;
    self.editButtonTitle = NSLocalizedString(@"Edit", @"");
    self.doneButtonTitle = NSLocalizedString(@"Done", @"");
    
    self.delegate = self.careSubsystemController;
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self.callTreeTableView setNeedsLayout];
    [self.callTreeTableView layoutIfNeeded];
    [self adjustHeaderViewSize];
}

#pragma mark - UI
- (void)adjustHeaderViewSize {
    CGSize newSize = [self.tableHeader systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint currentOrigin = self.tableHeader.frame.origin;
    CGRect newFrame = (CGRect) {
        .origin = currentOrigin,
        .size = newSize
    };
    self.tableHeader.frame = newFrame;
    self.callTreeTableView.tableHeaderView = self.tableHeader;
}

#pragma mark - Getters & Setters 

- (CareSubsystemController *)careSubsystemController {
    if (!_careSubsystemController) {
        _careSubsystemController = [[SubsystemsController sharedInstance] careController];
    }
    return _careSubsystemController;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusSelectOptionTableViewCell *cell = (ArcusSelectOptionTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        cell.selectionImageWidth = 0.0f;
        cell.selectionImageLeadingSpace = 0.0f;
        cell.selectionImageTrailingSpace = 15.0f;
        cell.selectionImageEditWidth = 20.0f;
        cell.selectionImageEditLeadingSpace = 16.0f;
        cell.selectionImageEditTrailingSpace = 15.0f;
    
        cell.selectionImage.image = [[UIImage imageNamed:@"RoleUncheckButton"] invertColor];
        cell.selectionImage.highlightedImage = [[UIImage imageNamed:@"RoleCheckedIcon"] invertColor];
    }
    
    return cell;
}

@end
