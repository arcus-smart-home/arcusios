//
//  SantaReindeerLandViewController.m
//  i2app
//
//  Created by Arcus Team on 11/3/15.
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
#import "SantaReindeerLandViewController.h"
#import "SantaEnterHomeViewController.h"
#import "CommonCheckableCell.h"
#import "SantaTracker.h"

@interface SantaReindeerLandViewController ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *savedButton;

@property (nonatomic) BOOL createModel;

@end

@implementation SantaReindeerLandViewController {
    
    __weak IBOutlet NSLayoutConstraint *tableViewConstraint;
}

+ (SantaReindeerLandViewController *)create:(BOOL)createModel {
    SantaReindeerLandViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.createModel = createModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Santa Tracker™"];
    [self.tableView setBackgroundView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    if (self.createModel) {
        [self.savedButton styleSet:@"Next" andButtonType:FontDataTypeButtonLight upperCase:YES];
    }
    else {
        [self.savedButton setHidden:YES];
        tableViewConstraint.constant = 0;
    }
    
    [self.titleLabel styleSet:@"Where do the reindeer normally land?" andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO]];
}

- (IBAction)onClickSave:(id)sender {
    if (self.createModel) {
        [[SantaTracker shareInstance] save];
        [self.navigationController pushViewController:[SantaEnterHomeViewController create:self.createModel] animated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
    
    switch (indexPath.row) {
        case 0:
            [cell setWhiteTitle:@"ROOF"];
            [cell setSelectedBox: ([[[SantaTracker shareInstance] getReindeerLandStatus] integerValue] == 0)];
            break;
        case 1:
            [cell setWhiteTitle:@"LAWN"];
            [cell setSelectedBox: ([[[SantaTracker shareInstance] getReindeerLandStatus] integerValue] == 1)];
            break;
        case 2:
            [cell setWhiteTitle:@"BACK DECK/PATIO"];
            [cell setSelectedBox: ([[[SantaTracker shareInstance] getReindeerLandStatus] integerValue] == 2)];
            break;
        case 3:
            [cell setWhiteTitle:@"NEARBY PARK"];
            [cell setSelectedBox: ([[[SantaTracker shareInstance] getReindeerLandStatus] integerValue] == 3)];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[SantaTracker shareInstance] saveReindeerLand:@(indexPath.row)];
    
    CommonCheckableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectedBox:YES];
    
    [tableView reloadData];
}
#pragma clang diagnostic pop

@end
