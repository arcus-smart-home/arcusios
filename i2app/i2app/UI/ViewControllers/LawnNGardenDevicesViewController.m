//
// Created by Arcus Team on 2/29/16.
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
#import "LawnNGardenDevicesViewController.h"
#import "ServiceControlCell.h"
#import "SubsystemsController.h"

#import "LawnNGardenSubsystemController.h"
#import "LawnNGardenDeviceCell.h"
#import "ALView+PureLayout.h"
#import "LawnNGardenScheduleModeSelectionDelegate.h"
#import "LawnNGardenScheduleController.h"
#import "LawnNGardenDeviceCardController.h"
#import "Card.h"
#import "DisabledDeviceCell.h"
#import "LawnNGardenDeviceCard.h"
#import "DisabledDeviceCard.h"

@interface LawnNGardenDevicesViewController ()

@property (strong, nonatomic) NSMutableArray <LawnNGardenDeviceCardController*> *controllers;

@end

@implementation LawnNGardenDevicesViewController {
}

- (NSString *)getTitle {
    return @"Devices";
}

- (void) initializeData {
    NSArray<NSString*> *devices = [SubsystemsController sharedInstance].lawnNGardenController.allDeviceIds;

    self.controllers = [[NSMutableArray alloc] initWithCapacity:devices.count];
    for (NSString *address in devices) {
        [self.controllers addObject:[[LawnNGardenDeviceCardController alloc] initWithCallback:self device:address]];
    }
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSMutableArray<SimpleTableCell *> *cells = [[NSMutableArray alloc] init];
    
    for (LawnNGardenDeviceCardController *controller in self.controllers) {
        
        //Get the device card
        Card *card = [controller getCard];

        ServiceControlCell *cell;

        // Create the cell from the card
        if ([[card identifier] isEqualToString:NSStringFromClass([LawnNGardenDeviceCard class])]) {
            cell = [LawnNGardenDeviceCell createCell:((LawnNGardenDeviceCard*)card).model owner:[self getOwner]];
        }
        else if ([[card identifier] isEqualToString:NSStringFromClass([DisabledDeviceCard class])]) {
            cell = [DisabledDeviceCell createCell:((DisabledDeviceCard*)card).model owner:[self getOwner]];
        }

        if ([cell conformsToProtocol:@protocol(CardCell)]) {
            [(ServiceControlCell <CardCell>*)cell bindCard:card];
        }

        cell.backgroundColor = [UIColor clearColor];

        SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:nil];
        [tableCell setForceCellHeight:179];
        [cells addObject:tableCell];
    }
    
    return cells;
}

- (void)updateCards:(LawnNGardenDeviceCardController*)controller {
    if (!self.ownerController.popupWindow) {
        [self refresh];
    }
}



@end
