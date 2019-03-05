//
// Created by Arcus Team on 3/1/16.
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
#import "LawnNGardenMoreViewController.h"
#import "CommonCheckableImageCell.h"
#import "AKFileManager.h"
#import "CommonTitleWithSubtitleCell.h"
#import "SubsystemsController.h"
#import "OrderedDictionary.h"
#import "LawnNGardenSubsystemController.h"
#import "LawnNGardenMoreZoneListViewController.h"

@interface LawnNGardenMoreViewController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LawnNGardenMoreViewController {
    NSMutableArray          *_cellItems;
}

+ (LawnNGardenMoreViewController *)create {
//    _fromDashboardCell = YES;
    return [[UIStoryboard storyboardWithName:@"LawnNGarden" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([LawnNGardenMoreViewController class])];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setTitle:NSLocalizedString(@"More", nil)];

    _cellItems = [[NSMutableArray alloc] init];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor clearColor]];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];

    [_cellItems addObject:[[CommonTitleWithSubtitleCell create:_tableView] setWhiteTitle:NSLocalizedString(@"ZONES", nil) subtitle:NSLocalizedString(@"Name zones and set your default watering times.", nil) side:nil]];
}

- (void)loadData {
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self loadData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_cellItems objectAtIndex:indexPath.row];

    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_cellItems objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[CommonTitleWithSubtitleCell class]]) {
        return 85;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    LawnNGardenMoreZoneListViewController *vc = [LawnNGardenMoreZoneListViewController create];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell sizeToFit];
    [cell layoutIfNeeded];
}

@end
