//
//  SantaConfigruredController.m
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
#import "SantaConfigruredController.h"
#import "SantaConfigruredEditController.h"
#import "SantaTracker.h"
#import "NSDate+Convert.h"
#import "NSDate+TimeAgo.h"

@interface SantaConfigruredControllerCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

- (void) setTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end

@implementation SantaConfigruredControllerCell

- (void) setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self.timeLabel styleSet:[[NSDate date] formatDateTimeStamp] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
    [self.titleLabel styleSet:title andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO space:YES]];
    [self.subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO alpha:YES]];
}

@end




@interface SantaConfigruredController ()

@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;

@end

@implementation SantaConfigruredController {
    
    __weak IBOutlet NSLayoutConstraint *photoImageHeightConstraint;
    NSMutableArray *_participatingDevices;
}

+ (SantaConfigruredController *)create {
    SantaConfigruredController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithCloseButtonAndTitle:@"Santa Tracker™"];
    
    [self.editLabel styleSet:@"Edit" andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] upperCase:YES];
    
    [self.imageView setImage:[[SantaTracker shareInstance] getSantaImage]];
    [self.notFoundLabel styleSet:@"Santa not found" andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO space:YES] upperCase:YES];
    
    [self.tableView setBackgroundView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    
    if (IS_IPAD) {
        photoImageHeightConstraint.constant *= 2;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[SantaTracker shareInstance] cancel];
    [self.imageView setImage:[[SantaTracker shareInstance] getSantaImage]];
    _participatingDevices = [[SantaTracker shareInstance] participatingDevices];
    [self.tableView reloadData];
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onClickEdit:(id)sender {
    [self.navigationController pushViewController:[SantaConfigruredEditController create] animated:YES];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _participatingDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SantaConfigruredControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SantaHistoryItemModel *model = [_participatingDevices objectAtIndex:indexPath.row];
    [cell setTitle:[model.title uppercaseString] subtitle:@"No Santa Detected"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
