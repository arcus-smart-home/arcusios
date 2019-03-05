//
//  PopupSelectionLogoTextView.m
//  i2app
//
//  Created by Arcus Team on 12/18/15.
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
#import "PopupSelectionLogoTextView.h"
#import "UIImageView+WebCache.h"
#import "ImagePaths.h"

#import <PureLayout/PureLayout.h>

@interface PopupSelectionLogoTextView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<PopupSelectionLogoItemModel *> *items;

@end

@implementation PopupSelectionLogoTextView {
    BOOL _allowMultiple;
    NSString *footerText;
}

- (PopupSelectionLogoTextView *)setMultipleSelect:(BOOL)allowMultiple {
    _allowMultiple = allowMultiple;
    return self;
}

- (PopupSelectionLogoTextView *)setFooterText:(NSString *)text {
    footerText = text;
    return self;
}

+ (PopupSelectionLogoTextView *)create:(NSString *)title items:(NSArray<PopupSelectionLogoItemModel *> *)items {
    PopupSelectionLogoTextView *selection = [[PopupSelectionLogoTextView alloc] initWithNibName:@"PopupSelectionLogoTextView" bundle:nil];
    selection.titleString = title;
    selection.items = items;
    
    return selection;
}

+ (PopupSelectionLogoTextView *)create:(NSString *)title devices:(NSArray<DeviceModel *> *)devices {
    PopupSelectionLogoTextView *selection = [[PopupSelectionLogoTextView alloc] initWithNibName:@"PopupSelectionLogoTextView" bundle:nil];
    selection.titleString = title;
    
    NSMutableArray<PopupSelectionLogoItemModel *> *list = [[NSMutableArray alloc] init];
    for (DeviceModel *model in devices) {
        [list addObject:[PopupSelectionLogoItemModel createWithDeviceModel:model selected:NO]];
    }
    selection.items = list;
    
    return selection;
}

+ (PopupSelectionLogoTextView *)create:(NSString *)title persons:(NSArray<PersonModel *> *)persons {
    PopupSelectionLogoTextView *selection = [[PopupSelectionLogoTextView alloc] initWithNibName:@"PopupSelectionLogoTextView" bundle:nil];
    selection.titleString = title;
    
    NSMutableArray<PopupSelectionLogoItemModel *> *list = [[NSMutableArray alloc] init];
    for (PersonModel *model in persons) {
        [list addObject:[PopupSelectionLogoItemModel createWithPersonModel:model selected:NO]];
    }
    selection.items = list;
    
    return selection;
}

- (void)initializePicker {
    [self.titleLabel styleSetWithSpace:self.titleString andFontSize:14 bold:YES upperCase:YES];
    if (footerText) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 600, 150)];
        UILabel *footerLabel = [[UILabel alloc] init];
        [footerView addSubview:footerLabel];
        
        [footerLabel setTextAlignment:NSTextAlignmentCenter];
        [footerLabel setNumberOfLines:0];
        [footerLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [footerLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView withOffset:50];
        [footerLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView withOffset:-50];
        [footerLabel styleSet:footerText andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:YES alpha:YES]];
        
        [self.tableView setTableFooterView:footerView];
    }
    else {
        [self.tableView setTableFooterView:[UIView new]];
    }
}

- (NSObject *)getSelectedValue {
    if (_allowMultiple) {
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (PopupSelectionLogoItemModel *item in _items) {
            if (item.selected) {
                [result addObject:[item getReturningObj]];
            }
        }
        return result;
    }
    else {
        for (PopupSelectionLogoItemModel *item in _items) {
            if (item.selected) {
                return [item getReturningObj];
            }
        }
        return nil;
    }
}
- (void)setCurrentKey:(id)currentValue {}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PopupSelectionCells" owner:self options:nil];
    PopupSelectionLogoTextCell *cell = (PopupSelectionLogoTextCell *)[nib objectAtIndex:3];

    [cell setBackgroundColor:[UIColor clearColor]];

    if (indexPath.row < self.items.count) {
        PopupSelectionLogoItemModel *item = [self.items objectAtIndex:indexPath.row];
        [cell set:item owner:self];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _items.count) {
        
        PopupSelectionLogoItemModel *item = [_items objectAtIndex:indexPath.row];
        if (_allowMultiple) {
            item.selected = !item.selected;
        }
        else {
            for (PopupSelectionLogoItemModel *item in _items) {
                item.selected = NO;
            }
            item.selected = YES;
        }
        [self.tableView reloadData];
    }
}

@end
