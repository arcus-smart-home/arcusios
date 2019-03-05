//
//  ContactSensorPairingSelectionViewController.m
//  i2app
//
//  Created by Arcus Team on 9/8/15.
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
#import "ContactSensorPairingSelectionViewController.h"
#import "DevicePairingManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import "AKFileManager.h"
#import "ContactCapability.h"
#import "DeviceCapability.h"
#import <i2app-Swift.h>


@interface ContactSensorPairingSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *settingArray;

@property (atomic, assign) NSInteger selectedIndex;

@end

@implementation ContactSensorPairingSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToParentColor];
    if (self.deviceModel) {
        [self navBarWithBackButtonAndTitle:self.deviceModel.name];
    }
    
    [self navBarWithBackButtonAndTitle:self.deviceModel.name];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.separatorColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.tableView.scrollEnabled = NO;
    
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData {
    self.settingArray = @[@"DOOR", @"WINDOW", @"OTHER"];
    NSString *hint = [ContactCapability getUsehintFromModel:self.deviceModel];
    if ([hint isEqualToString:kEnumContactUsehintUNKNOWN]) {
        int index = 0;
        for (NSString *item in self.settingArray) {
            if ([item isEqualToString:kEnumContactUsehintDOOR]) {
                [self setUseHintForItemWithIndex:index];
            }
            index++;
        }
    }
    else {
        int index = 0;
        for (NSString *item in self.settingArray) {
            if ([hint isEqualToString:item]) {
                self.selectedIndex = index;
            }
            index++;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusSimpleCheckableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSString *item = [self.settingArray objectAtIndex:indexPath.item];
    [cell setTitle:item checked:indexPath.row == self.selectedIndex];

    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self setUseHintForItemWithIndex:indexPath.row];
}

- (void)setUseHintForItemWithIndex:(NSInteger)index {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *item = [self.settingArray objectAtIndex:index];
        [ContactCapability setUsehint:item onModel:self.deviceModel];

        [self.deviceModel commit].then(^(NSObject *obj) {
            self.selectedIndex = index;
            [self.tableView reloadData];
        });
    });
}

@end
