//
//  DoorLockScheduleController.m
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
#import "DoorLockScheduleController.h"
#import "ImageDownloader.h"
#import <PureLayout/PureLayout.h>
#import "CommonCheckableImageCell.h"

#import "DeviceController.h"
#import "DeviceCapability.h"
#import "SubsystemsController.h"



#import "WeeklyScheduleViewController.h"
#import "ScheduleController.h"
#import "DoorsNLocksSubsystemController.h"
#import "GarageDoorScheduledEventModel.h"
#import "DoorLockScheduledEventModel.h"
#import "PetDoorScheduledEventModel.h"

NSString *const kDoorNLock = @"DOORS";


@interface DoorLockScheduleController ()

@end


@implementation DoorLockScheduleController

#pragma mark - dynamic properties
- (NSString *)scheduleName {
    return @"Doors";
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (void) initializeData {
    NSMutableArray *modelIds = [SubsystemsController sharedInstance].doorsNLocksController.allGarageDoorDeviceAddresses.mutableCopy;
    [modelIds addObjectsFromArray:[SubsystemsController sharedInstance].doorsNLocksController.allPetDoorDeviceAddresses];
    self.modelsIds = [self getModelSourcesFromSourcesSortedAlphabetically:modelIds.copy].mutableCopy;

    [self refresh];
}

// Get an array of model Ids sorted alphabetically based on the Model Name
- (NSArray *)getModelSourcesFromSourcesSortedAlphabetically:(NSArray *)sources {

  NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:sources.count];
  for (NSString *source in sources) {
    Model *model = [[[CorneaHolder shared] modelCache] fetchModel:source];
    if (model) {
      [models addObject:model];
    }
  }

  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [models sortUsingDescriptors:@[sort]];

  NSMutableArray *sortedModelIds = [[NSMutableArray alloc] initWithCapacity:models.count];

  for (Model *model in models) {
    [sortedModelIds addObject:model.modelId];
  }
  return sortedModelIds.copy;
}

- (NSString *)getTitle {
    return @"Schedule";
}

- (NSString *)getHeaderText {
    if (self.modelsIds.count == 0) {
        return @"";
    }
    else {
        return @"Tap on the door(s) below to have them open or close at a specific time.";
    }
}

- (NSString *)getSubheaderText {
    return NSLocalizedString(@"Doors & Locks schedule subheader text", nil);
}

- (UIView *)getFooterView {
    if (self.modelsIds.count == 0) {
        UIView *shopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        UILabel *title = [[UILabel alloc] initForAutoLayout];
        [title setNumberOfLines:0];
        [shopView addSubview:title];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:shopView withOffset:40];
        [title autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:shopView withOffset:40];
        [title autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:shopView withOffset:-40];
        [title styleSet:@"Automate Your Garage Door" andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO space:NO]];
        
        UILabel *subtitle = [[UILabel alloc] initForAutoLayout];
        [subtitle setNumberOfLines:0];
        [shopView addSubview:subtitle];
        [subtitle setTextAlignment:NSTextAlignmentCenter];
        [subtitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:title withOffset:20];
        [subtitle autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:shopView withOffset:40];
        [subtitle autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:shopView withOffset:-40];
        [subtitle styleSet:@"Manage your garage door schedule with ease using garage doors that \"Work with Arcus\"." andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO alpha:YES]];
        
        UIButton *button = [[UIButton alloc] initForAutoLayout];
        [shopView addSubview:button];
        [button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:subtitle withOffset:20];
        [button autoSetDimension:ALDimensionHeight toSize:24];
        [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [button styleSet:@"  SHOP  " andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO space:YES]];
        [button addTarget:self action:@selector(shopClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5.0f;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        
        return shopView;
    }
    else {
        return [super getFooterView];
    }
}

- (void)shopClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @""]];
}

#pragma mark - Scheduler Utilities
- (ScheduledEventModel *)getNewEventModel {
    if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeGarageDoor) {
        return [[GarageDoorScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeLocks) {
        return [[DoorLockScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypePetDoor) {
        return [PetDoorScheduledEventModel new];
    }
    return nil;
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay
                               withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    ScheduledEventModel *eventModel;
    if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeGarageDoor) {
        eventModel = [[GarageDoorScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeLocks) {
        eventModel = [[DoorLockScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypePetDoor) {
        return [[PetDoorScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }

    [eventModel preload];
    
    return eventModel;
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    return kDoorNLock;
}

@end
