//
//  LawnNGardenScheduleModeSelectionDelegate.m
//  i2app
//
//  Created by Arcus Team on 3/1/16.
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
#import "LawnNGardenScheduleModeSelectionDelegate.h"
#import "CommonCheckableImageCell.h"

#import "LawnNGardenScheduleController.h"
#import "WeeklyScheduleViewController.h"
#import "NonWeeklyScheduleViewController.h"
#import "SubsystemsController.h"
#import "LawnNGardenSubsystemController.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionNumberView.h"
#import "IrrigationControllerCapability.h"
#import "CommonIconTitleCellTableViewCell.h"
#import <i2app-Swift.h>

@interface LawnNGardenScheduleModeSelectionDelegate ()

@property (nonatomic, assign) DeviceModel *deviceModel;
@end


@implementation LawnNGardenScheduleModeSelectionDelegate {
    LawnNGardenScheduleController   *_scheduler;
    NSArray <CommonCheckableImageCell *>    *_tableCells;

    PopupSelectionWindow    *_popupWindow;
}

- (instancetype)initWithScheduler:(LawnNGardenScheduleController *)scheduler {
    if (self = [super init]) {
        _scheduler = scheduler;
        _scheduler.scheduleMode = [_scheduler getCurrentMode];
    }
    return self;
}

- (DeviceModel *)deviceModel {
    return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:_scheduler.schedulingModelAddress];
}

- (NSString *)getTitle {
    return self.deviceModel.name;
}

- (NSString *) getSubheaderText {
    return @"";
}

- (void) initializeData {
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(devicesRefreshed)
   name:kSubsystemUpdatedNotification
   object:nil];

  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(devicesRefreshed)
   name:kSubsystemInitializedNotification
   object:nil];
}

- (void)devicesRefreshed {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self refresh];
  });
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSArray *subtitles = @[NSLocalizedString(@"Weekly subtitle", nil),
                           NSLocalizedString(@"Interval subtitle", nil),
                           NSLocalizedString(@"Odd subtitle", nil),
                           NSLocalizedString(@"Even subtitle", nil),
                           NSLocalizedString(@"Manual subtitle", nil)];
    
    NSMutableArray *cells = [[NSMutableArray alloc] initWithCapacity:subtitles.count];
    NSMutableArray *checkableCells = [[NSMutableArray alloc] initWithCapacity:subtitles.count];

    NSString *currentModeStr;
    BOOL isScheduleEnabled = [[SubsystemsController sharedInstance].lawnNGardenController isScheduleForCurrentIrrigationModeForModelEnabled:ScheduleController.scheduleController.schedulingModelAddress currentMode:&currentModeStr];
    // If Scheduler is not enabled, then we need to set the mode to manual
    IrrigationSystemMode currentMode = isScheduleEnabled ? [LawnNGardenScheduleController scheduleStringToMode:currentModeStr] : IrrigationSystemModeManual;
    
    CommonIconTitleCellTableViewCell *titleCell = [CommonIconTitleCellTableViewCell create:tableView];
    SimpleTableCell *tableCell = [SimpleTableCell create:titleCell withOwner:self andPressSelector:@selector(changeWaterSaver:)];
    titleCell.backgroundColor = [UIColor clearColor];
    titleCell.imageHeightConstraint.constant = 30;
    titleCell.imageWidthConstraint.constant = 30;
    [titleCell setIcon:[UIImage imageNamed:@"icon_unfilled_water"] withWhiteTitle:@"WATER SAVER" subtitle:nil andSide:[NSString stringWithFormat:@"%d%%", [self getWaterPercentage]]];
    
    [cells addObject:tableCell];
    [checkableCells addObject:titleCell];

    for (int i = 0; i < subtitles.count; i++) {
        CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
        SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:i < subtitles.count - 1 ? @selector(goToSchedulerViewController:) : nil];
        // Ther is the "Water saver" cell that is first
        tableCell.dataObject = @(i + 1);
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setIcon:nil withWhiteTitle:[LawnNGardenScheduleController scheduleModeToString:i] subtitle:subtitles[i]];
        [cell hideIconImage];
        [cell displayArrow:i < subtitles.count - 1];
        
        [cell setCheck:(i == currentMode) styleBlack:NO];
        [cell setOnClickEvent:@selector(onClickCheckbox:withIndex:) owner:self withObj:@(i)];
        
        if ([ScheduleController.scheduleController hasScheduledEventsForMode:i]) {
            [cell attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
        }
        else {
            [cell removeSideIcon];
        }
        
        [cells addObject:tableCell];
        [checkableCells addObject:cell];
    }
    
    _tableCells = checkableCells.copy;
    return cells.copy;
}

- (void)onClickCheckbox:(CommonCheckableImageCell *)cell withIndex:(NSNumber *)index {
    if (index.intValue < IrrigationSystemModeManual && ![cell getChecked]) {
        if (![ScheduleController.scheduleController hasScheduledEventsForMode:index.intValue]) {
            PopupSelectionButtonsView *popup = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"NO EVENTS ON SCHEDULE", nil) subtitle:NSLocalizedString(@"You need to add at least 1 event to the schedule", nil) button:nil];
            [self popupWarning:popup complete:nil];
            return;
        }
    }
    
    [((LawnNGardenScheduleController *)ScheduleController.scheduleController) onClickCheckbox:cell withMode:index.intValue allCells:_tableCells];
}

- (void)changeWaterSaver:(SimpleTableCell *)cell {
    PopupSelectionNumberView *picker = [PopupSelectionNumberView create:@"WATER SAVER" subtitle:NSLocalizedString(@"Save water and money by reducing your\nwatering time by a percentage for the\nentire schedule.\n\ne.g. If every event in the schedule is set\nto 10 min/zone during the summer, you\nmay want to set Water Saver to 50% in the fall,\nwhich will reduce watering to 5 min/zone.", nil) withMinNumber:0 maxNumber:100 stepNumber:10 withSign:@"%"];
    [self popupWithBlockSetCurrentValue:picker currentValue:@([self getWaterPercentage]) completeBlock:^(id selectedValue) {
        [self setWaterPercentage:((NSNumber*)selectedValue).intValue];
    }];
}

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

- (void)setWaterPercentage:(int)percentage {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [IrrigationControllerCapability setBudget:percentage onModel:self.deviceModel];
        [self.deviceModel commit].thenInBackground(^{
            [self.deviceModel refresh].then(^{
                [self.ownerController refresh];
            });
        });
    });
}

- (int)getWaterPercentage {
    return [IrrigationControllerCapability getBudgetFromModel:self.deviceModel];
}

- (void)goToSchedulerViewController:(SimpleTableCell *)cell {
    if ([cell.dataObject isKindOfClass:[NSNumber class]]) {
        ScheduleController.scheduleController.scheduleMode = ((NSNumber *)cell.dataObject).intValue - 1;
    }
    if (ScheduleController.scheduleController.scheduleMode == IrrigationSystemModeWeekly) {
        WeeklyScheduleViewController *vc = [WeeklyScheduleViewController createAndAlwaysShowNextEvent];
        vc.hasLightBackground = NO;
        [self.ownerController.navigationController pushViewController:vc animated:YES];
    }
    else {
        NonWeeklyScheduleViewController *vc = [NonWeeklyScheduleViewController create];
        vc.hasLightBackground = NO;
        [self.ownerController.navigationController pushViewController:vc animated:YES];
    }
}
@end
