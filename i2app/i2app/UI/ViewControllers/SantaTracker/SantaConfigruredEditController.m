//
//  SantaConfigruredEditController.m
//  i2app
//
//  Created by Arcus Team on 11/5/15.
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
#import "SantaConfigruredEditController.h"
#import "CommonIconTitleCellTableViewCell.h"

#import "SantaEnterHomeViewController.h"
#import "SantaMotionViewController.h"
#import "SantaReindeerLandViewController.h"
#import "SantaTakePhotoViewController.h"
#import "SantaTracker.h"

@interface SantaConfigruredEditController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation SantaConfigruredEditController

+ (SantaConfigruredEditController *)create {
    SantaConfigruredEditController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Edit"];
    [self.tableView setBackgroundView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    [self.saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonLight upperCase:YES];
}

- (IBAction)onClickSave:(id)sender {
    [[SantaTracker shareInstance] save];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(NSObject *)sender {
  [[SantaTracker shareInstance] save];
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonIconTitleCellTableViewCell *cell = [CommonIconTitleCellTableViewCell create:tableView];
    
    switch (indexPath.row) {
        case 0:
            [cell setIcon:[UIImage imageNamed:@"santa_deer"] withWhiteTitle:@"REINDEER" subtitle:@"Where do the reindeer land?"];
            break;
        case 1:
            [cell setIcon:[UIImage imageNamed:@"santa_house"] withWhiteTitle:@"ENTER/EXIT" subtitle:@"How does Santa enter & exit?"];
            break;
        case 2:
            [cell setIcon:[UIImage imageNamed:@"santa_snow"] withWhiteTitle:@"MOTION SENSORS" subtitle:@"What sensors will Santa trip?"];
            break;
        case 3:
            [cell setIcon:[UIImage imageNamed:@"santa_tree"] withWhiteTitle:@"PHOTO" subtitle:@"Edit your Photo"];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:{
            [self.navigationController pushViewController:[SantaReindeerLandViewController create:NO] animated:YES];
        }
            break;
        case 1:{
            [self.navigationController pushViewController:[SantaEnterHomeViewController create:NO] animated:YES];
        }
            break;
        case 2:{
            [self.navigationController pushViewController:[SantaMotionViewController create:NO] animated:YES];
        }
            break;
        case 3:{
            [self.navigationController pushViewController:[SantaTakePhotoViewController create:NO] animated:YES];
        }
            break;
    }
}



@end
