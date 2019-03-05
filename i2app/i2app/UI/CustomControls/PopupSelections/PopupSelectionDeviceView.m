//
//  PopupSelectionDeviceView.m
//  i2app
//
//  Created by Arcus Team on 8/18/15.
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
#import "PopupSelectionDeviceView.h"
#import "DeviceManager.h"
#import "DeviceCapability.h"
#import "ImageDownloader.h"

@implementation DeviceSelectModel

+ (DeviceSelectModel *)create:(DeviceModel *)model withSelected:(BOOL)selected {
    DeviceSelectModel *m = [[DeviceSelectModel alloc] init];
    m.deviceModel = model;
    m.selected = selected;
    return m;
}

+ (NSArray<DeviceSelectModel *> *)convertDevices:(NSArray<DeviceModel *> *)devices withSelectedDevices:(NSArray<DeviceModel *> *)selectedDevices {
    NSMutableArray<DeviceSelectModel *> *selectModels = [[NSMutableArray alloc] init];
    
    for (DeviceModel *item in devices) {
        [selectModels addObject:[DeviceSelectModel create:item withSelected:[selectedDevices containsObject:item]]];
    }
    
    return selectModels;
}

@end


@interface PopupSelectionDeviceViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;

- (void) setDevice:(DeviceModel *)device checked:(BOOL)check owner:(PopupSelectionDeviceView *)owner;

@end


@interface PopupSelectionDeviceView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *titleString;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<DeviceSelectModel *> *devices;

@end

@implementation PopupSelectionDeviceView {
    BOOL _allowMultiple;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_devices == nil) {
        _devices = [DeviceSelectModel convertDevices:[DeviceManager instance].devices withSelectedDevices:nil];
    }
    
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:12 bold:YES upperCase:YES];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 110.0f, 0, 0)];
}

- (CGFloat)getHeight {
    if (self.devices.count >= 5) {
        UIView *container = self.window.container;
        if (container) {
            return container.frame.size.height - 120;
        }
    }
    return [super getHeight];
}

+ (PopupSelectionDeviceView *)create:(NSString *)title {
    PopupSelectionDeviceView *selection = [[PopupSelectionDeviceView alloc] initWithNibName:@"PopupSelectionDeviceView" bundle:nil];
    selection.titleString = title;
    
    return selection;
}

+ (PopupSelectionDeviceView *)create:(NSString *)title devices:(NSArray<DeviceModel *> *)devices {
    PopupSelectionDeviceView *selection = [[PopupSelectionDeviceView alloc] initWithNibName:@"PopupSelectionDeviceView" bundle:nil];
    selection.titleString = title;
    selection.devices = [DeviceSelectModel convertDevices:devices withSelectedDevices:nil];

    return selection;
}

+ (PopupSelectionDeviceView *)create:(NSString *)title devices:(NSArray<DeviceModel *> *)devices withInitialSelection:(DeviceModel *)initialSelection {
    PopupSelectionDeviceView *selection = [[PopupSelectionDeviceView alloc] initWithNibName:@"PopupSelectionDeviceView" bundle:nil];
    selection.titleString = title;
    
    if (initialSelection) {
        selection.devices = [DeviceSelectModel convertDevices:devices withSelectedDevices:[NSArray arrayWithObject:initialSelection]];
    } else {
        selection.devices = [DeviceSelectModel convertDevices:devices withSelectedDevices:nil];
    }
    
    return selection;
}

+ (PopupSelectionDeviceView *)create:(NSString *)title deviceSelectModels:(NSArray<DeviceSelectModel *> *)models {
    PopupSelectionDeviceView *selection = [[PopupSelectionDeviceView alloc] initWithNibName:@"PopupSelectionDeviceView" bundle:nil];
    selection.titleString = title;
    selection.devices = models;
    
    return selection;
}

- (PopupSelectionDeviceView *)setMultipleSelect:(BOOL)allowMultiple {
    _allowMultiple = allowMultiple;
    return self;
}

#pragma mark - PickerDelegate
- (void)initializePicker {
}

- (NSObject *)getSelectedValue {
    if (_allowMultiple) {
        NSMutableArray<DeviceModel *> *result = [[NSMutableArray alloc] init];
        for (DeviceSelectModel *item in _devices) {
            if (item.selected) {
                [result addObject:item.deviceModel];
            }
        }
        return result;
    }
    else {
        for (DeviceSelectModel *item in _devices) {
            if (item.selected) {
                return item.deviceModel;
            }
        }
        return nil;
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PopupSelectionCells" owner:self options:nil];
    PopupSelectionDeviceViewCell *cell = (PopupSelectionDeviceViewCell *)[nib objectAtIndex:1];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row < _devices.count) {
        DeviceSelectModel *device = [_devices objectAtIndex:indexPath.row];
        [cell setDevice:device.deviceModel checked:device.selected owner:self];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _devices.count) {
        
        DeviceSelectModel *device = [_devices objectAtIndex:indexPath.row];
        if (_allowMultiple) {
            device.selected = !device.selected;
        }
        else {
            for (DeviceSelectModel *item in _devices) {
                item.selected = NO;
            }
            device.selected = YES;
        }
        [self.tableView reloadData];
    }
}

@end




@implementation PopupSelectionDeviceViewCell {
    __weak PopupSelectionDeviceView *_controller;
    DeviceModel *_device;
}

- (void) setDevice:(DeviceModel *)device checked:(BOOL)check owner:(PopupSelectionDeviceView *)owner {
    [self.deviceNameLabel styleSet:device.name andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    [self.subtitleLabel styleSet:device.vendor andButtonType:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
    
    _controller = owner;
    _device = device;
    
    [self.checkIcon setImage:check?[UIImage imageNamed:@"CheckMark"]:[UIImage imageNamed:@"CheckmarkEmptyIcon"]];

    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:YES].then(^(UIImage *image) {
        self.deviceImage.image = image;
    });
}


@end

