//
//  PopupSelestionTitleTableView.m
//  i2app
//
//  Created by Arcus Team on 7/23/15.
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
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionCells.h"


@interface PopupSelectionTitleTableView () <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSArray *datasource;
@property (copy, nonatomic) NSString *titleString;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PopupSelectionTitleTableView {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.multipleSelect = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    if (_titleString) {
        [self.titleLable styleSet:_titleString andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    }
}

+ (PopupSelectionTitleTableView *)create:(NSString *)title data:(NSArray *)dataScoure {
    PopupSelectionTitleTableView *selection = [[PopupSelectionTitleTableView alloc] initWithNibName:@"PopupSelectionTitleTableView" bundle:nil];
    selection.datasource = dataScoure;
    selection.titleString = title;
    
    return selection;
}

+ (PopupSelectionTitleTableView *)create:(NSString *)title models:(PopupSelectionModel *)model, ... {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    va_list args;
    va_start(args, model);
    for (PopupSelectionModel *arg = model; arg != nil; arg = va_arg(args, PopupSelectionModel *)) {
        [array addObject:arg];
    }
    va_end(args);
    
    return [self create:title data:array];
}

#pragma mark - PickerDelegate
- (void)initializePicker {
}

- (NSObject *)getSelectedValue {
    if (self.multipleSelect) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (PopupSelectionModel *item in _datasource) {
            if (item.checked) {
                [result addObject:item.param];
            }
        }
        return result;
    }
    else {
        for (PopupSelectionModel *item in _datasource) {
            if (item.checked)
                return item.param;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopupSelectionModel *model = [_datasource objectAtIndex:indexPath.row];
    PopupSelectionTableCell *cell = [PopupSelectionTableCell createCell:model.title withValue:model.value];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setChecked:model.checked];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_multipleSelect) {
        PopupSelectionModel *currentItem = [_datasource objectAtIndex:indexPath.row];
        [currentItem setChecked:!currentItem.checked];
    }
    else {
        for (PopupSelectionModel *item in _datasource) {
            [item setChecked:NO];
        }
        [[_datasource objectAtIndex:indexPath.row] setChecked:YES];
    }
    
    [self.tableView reloadData];
}

@end


