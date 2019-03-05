//
//  SceneScheduleController.m
//  i2app
//
//  Created by Arcus Team on 2/16/16.
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
#import "SceneScheduleController.h"
#import "SceneManager.h"
#import "PromiseKit/Promise.h"


#import "SceneCapability.h"
#import "SceneScheduledEventModel.h"

#import "CommonCheckableImageCell.h"
#import "UIImage+ImageEffects.h"

#import "SettingSceneViewController.h"
#import "ScheduleController.h"


NSString *const kSceneSchedule = @"FIRE";


@interface SceneScheduleController ()

@end


@implementation SceneScheduleController

#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Scene";
}

- (SceneModel *)schedulingModel {
    return (SceneModel *)[[[CorneaHolder shared] modelCache] fetchModel:super.schedulingModelAddress];
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (NSString *)getHeaderText {
    return NSLocalizedString(@"Tap on the device below\nto manage its schedule.", nil);
}

- (NSString *)getSubheaderText {
    return @"Turn on the schedule by selecting the\ncheckmark. Uncheck to deactivate the schedule.";
}

- (NSArray<SimpleTableCell *> *)getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    NSMutableArray<SimpleTableCell *> *cells = [[NSMutableArray alloc] init];
    
    for (NSString *sceneId in self.modelsIds) {
        SceneModel *scene = (SceneModel *)[[[CorneaHolder shared] modelCache] fetchModel:[SceneModel addressForId:sceneId]];
        CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
        [cell setIcon:nil withTitle:scene.name subtitle:nil andSide:nil withBlackFont:NO];
        
        [cell setCheck:[self isScheduleEnabledForModel:scene] styleBlack:NO];
        [cell setOnClickEvent:@selector(onCheckEnable:withModel:) owner:self withObj:scene];
        [cell displayArrow:YES];
        
        if ([ScheduleController.scheduleController hasScheduledEventsForModelWithAddress:scene.address]) {
            [cell attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
        }
        else {
            [cell removeSideIcon];
        }
        
        SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onClickCell:)];
        [tableCell setDataObject:scene];
        [cells addObject:tableCell];
        
        UIImage *icon = nil;
        switch ([scene getTemplateType]) {
            case SceneModelTemplateTypeCustom:
                icon = [UIImage imageNamed:@"scene_custom_white"];
                break;
            case SceneModelTemplateTypeAway:
                icon = [UIImage imageNamed:@"scene_away_white"];
                break;
            case SceneModelTemplateTypeHome:
                icon = [UIImage imageNamed:@"scene_home_white"];
                break;
            case SceneModelTemplateTypeMorning:
                icon = [UIImage imageNamed:@"scene_morning_white"];
                break;
            case SceneModelTemplateTypeNight:
                icon = [UIImage imageNamed:@"scene_night_white"];
                break;
            case SceneModelTemplateTypeVacation:
                icon = [UIImage imageNamed:@"scene_vacation_white"];
                break;
            default:
                break;
        }
        
        [cell setIcon:icon withWhiteTitle:scene.name subtitle:[self numberOfActionsString:scene]];
        [cell displayArrow:YES];
        
        if ([self hasScheduledEventsForModelWithAddress:scene.address]) {
            [cell attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
        }
        else {
            [cell removeSideIcon];
        }
    }
    
    return cells;
}

- (void)onClickCell:(SimpleTableCell *)cell {
    [SceneManager sharedInstance].currentScene = (SceneModel *)cell.dataObject;
    self.schedulingModelAddress = ((SceneModel *)cell.dataObject).address;
    [SceneManager sharedInstance].isNewScene = NO;
    
    SettingSceneViewController *vc = [SettingSceneViewController create];
    [self.ownerController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (NSString *)numberOfActionsString:(SceneModel *)sceneModel {
    if ( [SceneCapability getActionsFromModel:sceneModel].count == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%d %@", (int)[SceneCapability getActionsFromModel:sceneModel].count, NSLocalizedString(@"Actions", nil)];
}


#pragma mark - ScheduledEventModel
- (ScheduledEventModel *)getNewEventModel {
    return [SceneScheduledEventModel new];
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay
                               withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    return [[SceneScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    return kSceneSchedule;
}

@end
