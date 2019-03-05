//
//  DashboardCardsSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 7/29/15.
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
#import "DashboardCardsSettingViewController.h"
#import "DashboardCardModel.h"
#import "DashboardCardsManager.h"

@interface DashboardCardsSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation DashboardCardsSettingViewController {

}

+ (DashboardCardsSettingViewController *) create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(EditCards:)];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[DashboardCardsManager shareInstance] save];
}

- (void)EditCards:(UIButton *)sender {
    if (_tableView.editing) {
        [_tableView setEditing:NO animated: YES];
        [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(EditCards:)];
    }
    else {
        [_tableView setEditing:YES animated: YES];
        [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Done" withSelector:@selector(EditCards:)];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DashboardCardsManager shareInstance].allCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCardSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSArray *cards = [DashboardCardsManager shareInstance].allCards;
    if (cards.count > indexPath.row) {
        DashboardCardModel *card = cards[indexPath.row];
        [cell setTitle:card.serviceName withImage:[card getIconImage] type:card.type];
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.editing) {
        DashboardCardSettingCell *cell = (DashboardCardSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell tiggerSelection];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[DashboardCardsManager shareInstance] switchCardOrder:sourceIndexPath.row to:destinationIndexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Hide";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

@end


@interface DashboardCardSettingCell ()

@property (weak, nonatomic) IBOutlet UIImageView *serviceCardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@end

@implementation DashboardCardSettingCell {
    DashboardCardType _type;
}

- (void)setTitle:(NSString *)title withImage:(UIImage *)image type:(DashboardCardType)type {
    _type = type;
    [_checkButton setSelected:[[DashboardCardsManager shareInstance] getStateFromType:_type]];
    if (image) {
        [_serviceCardImage setImage:image];
    }
    if (title) {
        [_cardNameLabel styleSet:title andButtonType:FontDataType_DemiBold_12_White upperCase:YES];
    }
}

- (void)tiggerSelection {
    [[DashboardCardsManager shareInstance] tiggerStateByType:_type];
    [_checkButton setSelected:[[DashboardCardsManager shareInstance] getStateFromType:_type]];
}

- (IBAction)pressedSelect:(id)sender {
    [self tiggerSelection];
}

- (void)layoutSubviews {
    if (self.editing) {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = 0;
        cellFrame.size.width = self.superview.frame.size.width;
        [self setFrame:cellFrame];
    }
    else {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = -50;
        cellFrame.size.width = self.superview.frame.size.width + 50;
        [self setFrame:cellFrame];
    }
    [super layoutSubviews];
}

@end



