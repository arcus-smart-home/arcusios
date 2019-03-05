//
//  CareOpenCountDevicePickerViewController.m
//  i2app
//
//  Created by Arcus Team on 2/25/16.
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
#import "CareOpenCountDevicePickerViewController.h"
#import "ArcusCheckableCell.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "PopupSelectionNumberView.h"
#import <i2app-Swift.h>

@interface CareOpenCountDevicePickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *headerViewSeparator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) PopupSelectionWindow *popupWindow;

@end


@implementation CareOpenCountDevicePickerViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColorToDashboardColor];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Participating devices", nil)];
    [self oneTimeUIConfig];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        self.completion(self.deviceCounts);
    }
}

#pragma mark - UI
- (void)adjustHeaderViewSize {
    CGSize headerNewSize = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGPoint headerOrigin = self.tableHeaderView.frame.origin;
    self.tableHeaderView.frame = CGRectMake(headerOrigin.x,
                                            headerOrigin.y,
                                            headerNewSize.width,
                                            headerNewSize.height);
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)oneTimeUIConfig {
    if (_isCreationMode) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        UIColor *headerColor = [FontColors getCreationHeaderTextColor];
        UIColor *separatorColor = [FontColors getCreationSeparatorColor];
        self.headerLabel.textColor = headerColor;
        self.tableView.separatorColor = separatorColor;
        self.headerViewSeparator.backgroundColor = separatorColor;
    }
    
    self.headerLabel.text = NSLocalizedString(@"Open count picker header text", nil);
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self adjustHeaderViewSize];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _deviceCounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ArcusCheckableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"arcusSelectionCell"];
#pragma clang diagnostic pop
    CareOpenCountDeviceModel *openCountModel = _deviceCounts[indexPath.row];
    DeviceModel *device = openCountModel.deviceModel;
    
    UIImage *uncheckedImage;
    UIImage *checkedImage;
    if (_isCreationMode) {
        uncheckedImage = [UIImage imageNamed:@"RoleUncheckButton"];
        checkedImage = [UIImage imageNamed:@"RoleCheckedIcon"];
        cell.chevronImageView.image = [UIImage imageNamed:@"Chevron"];
    } else {
        uncheckedImage = [UIImage imageNamed:@"UncheckmarkDetail"];
        checkedImage = [UIImage imageNamed:@"CheckmarkDetail"];
    }
    cell.uncheckedImage = uncheckedImage;
    cell.checkedImage = checkedImage;
    
    cell.titleLabel.text = device.name;
    cell.descriptionLabel.text = device.vendor;
    cell.isChecked = openCountModel.active;
    cell.detailLabel.text = openCountModel.count > 0 ? [NSString stringWithFormat:@"%lu", openCountModel.count] : nil;
    
    
    
    UIImage *deviceImage = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                       atSize:[UIScreen mainScreen].bounds.size
                                                                withScale:[UIScreen mainScreen].scale];
    if (!deviceImage) {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                               withDevTypeId:[device devTypeHintToImageName]
                             withPlaceHolder:nil
                                     isLarge:NO
                                isBlackStyle:self.isCreationMode].then(^(UIImage *image) {
            cell.detailImageView.image = image;
        });
    } else {
        cell.detailImageView.image = deviceImage;
    }
    
    cell.detailImageView.layer.cornerRadius = cell.detailImageView.bounds.size.width/2;
    cell.detailImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(countEnableCheckPressed:)];
    [cell.checkMarkImageView addGestureRecognizer:gestureRecognizer];
    cell.checkMarkImageView.tag = indexPath.row;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSNumber *currentValue = [NSNumber numberWithLong:self.deviceCounts[indexPath.row].count];
    PopupSelectionNumberView *picker = [PopupSelectionNumberView create:NSLocalizedString(@"Daily Open Limit", nil) withMinNumber:1 andMaxNumber:50];
    [self popupWithBlockSetCurrentValue:picker currentValue:currentValue completeBlock:^(id returnValue){
        if (returnValue) {
            NSNumber *selectedValue = (NSNumber *)returnValue;
            CareOpenCountDeviceModel *openCountModel = self.deviceCounts[indexPath.row];
            openCountModel.count = [selectedValue integerValue];
            openCountModel.active = YES;
            NSArray<NSIndexPath *> *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    ArcusCheckableCell *arcusCell = (ArcusCheckableCell *)cell;
#pragma clang diagnostic pop
    UIColor *mainTextColor;
    UIColor *detailTextColor;
    
    if (_isCreationMode) {
        mainTextColor = [FontColors getCreationHeaderTextColor];
        detailTextColor = [FontColors getCreationSubheaderTextColor];
    } else {
        mainTextColor = [FontColors getStandardHeaderTextColor];
        detailTextColor = [FontColors getStandardSubheaderTextColor];
    }
    
    arcusCell.titleLabel.textColor = mainTextColor;
    arcusCell.descriptionLabel.textColor = detailTextColor;
    arcusCell.detailLabel.textColor = detailTextColor;
    
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Handle count enable/disable
- (void)countEnableCheckPressed:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *gestureRecognizer = (UITapGestureRecognizer *)sender;
        NSInteger index = gestureRecognizer.view.tag;
        
        CareOpenCountDeviceModel *model = _deviceCounts[index];
        if (model.count > 0) {
            model.active = !model.active;
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            NSArray<NSIndexPath *> *rowsToUpdate = [NSArray arrayWithObject:indexPath];
            [self.tableView reloadRowsAtIndexPaths:rowsToUpdate withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - PopupWindow handling
- (void)popupWithBlockSetCurrentValue:(PopupSelectionBaseContainer *)container currentValue:(id)currentValue completeBlock:(void (^)(id selectedValue))closeBlock  {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    [container setCurrentKey:currentValue];
    _popupWindow = [PopupSelectionWindow popupWithBlock:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                                subview:container
                                                  owner:self
                                             closeBlock:closeBlock];
}

@end
