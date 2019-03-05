//
//  WaterDevicesController.m
//  i2app
//
//  Created by Arcus Team on 1/13/16.
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
#import "WaterDevicesController.h"
#import "ServiceControlCell.h"
#import "SubsystemsController.h"

#import "WaterSubsystemController.h"

@interface WaterDevicesController ()

@end

@implementation WaterDevicesController {
    NSArray *_devices;
}

- (NSString *)getTitle {
    return @"Devices";
}

- (void) initializeData {
    _devices = [[SubsystemsController sharedInstance].waterController allWaterDevices];
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSMutableArray<SimpleTableCell *> *cells = [[NSMutableArray alloc] init];
    
    for (DeviceModel *device in _devices) {
        
        ServiceControlCell *cell = [ServiceControlCell createCell:device owner:[self getOwner]];
        
        [cell loadData];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:nil];
        [tableCell setForceCellHeight:145];
        [cells addObject:tableCell];
    }
    
    return cells;
}

@end
