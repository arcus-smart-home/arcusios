//
//  DevicePetdoorSmartKeysController.m
//  i2app
//
//  Created by Arcus Team on 1/14/16.
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
#import "DevicePetdoorSmartKeysSimpleDelegate.h"
#import "CommonCheckableImageCell.h"
#import "DeviceRenamePetSmartKeyViewController.h"
#import "DoorsNLocksSubsystemController.h"
#import "PetTokenCapability.h"
#import "AKFileManager.h"
#import "DevicePairingWizard.h"

@interface DevicePetdoorSmartKeysSimpleDelegate ()

@end


@implementation DevicePetdoorSmartKeysSimpleDelegate {
    NSDictionary    *_namesDictionary;
    DeviceModel     *_deviceModel;
}

- (instancetype)initWithDeviceModel:(DeviceModel *)device {
    if (self = [super init]) {
        _deviceModel = device;
    }
    return self;
}

- (NSString *)getTitle {
    return _deviceModel.name;
}

- (NSString *) getSubheaderText {
    return @"";
}

- (void) initializeData {
    _namesDictionary = [DoorsNLocksSubsystemController getPetTokenNames:_deviceModel];
}

- (NSString *)getHeaderText {
    return @"The Smart Keys listed below have access to this door while in Auto Mode.";
}

- (void)refresh {
    _namesDictionary = [DoorsNLocksSubsystemController getPetTokenNames:_deviceModel];
    
    [[self getOwner] refresh];
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSMutableArray<SimpleTableCell *> *cells = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tokenData in _namesDictionary.allValues) {
        
        CommonCheckableImageCell *tableCell = [CommonCheckableImageCell create:tableView];
        
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:[NSString stringWithFormat:@"%@-%@", _deviceModel.modelId,[tokenData objectForKey:@"PetToken"]] atSize:[UIScreen mainScreen].bounds.size withScale:[UIScreen mainScreen].scale];
        
        if (!image) {
            image = [UIImage imageNamed:@"SmartKey_small"];
        } else {
            [tableCell setCircleImage:YES];
        }
        
        [tableCell setIcon:image withTitle:((NSString *)tokenData[kAttrPetTokenPetName]).uppercaseString subtitle:nil andSide:nil withBlackFont:newStyle];
        [tableCell hideCheckbox];
        [tableCell displayArrow:YES];
        
        SimpleTableCell *cell = [SimpleTableCell create:tableCell withOwner:self andPressSelector:@selector(onClickCell:)];
        cell.dataObject = tokenData;
        
        [cells addObject:cell];
    }
    return cells;
}

- (NSString *)getBottomButtonText {
    return @"Add Smart Key";
}

- (void)onClickBottomButton {
    [DevicePairingWizard createPetDoorSmartKeyPairingSteps:_deviceModel];
}

- (void)onClickCell:(SimpleTableCell *)cell {
    DeviceRenamePetSmartKeyViewController *vc = [DeviceRenamePetSmartKeyViewController createWithDeviceModel:_deviceModel withPetData:(NSDictionary *)cell.dataObject];
    [self.ownerController.navigationController pushViewController:vc animated:YES];
}

@end
