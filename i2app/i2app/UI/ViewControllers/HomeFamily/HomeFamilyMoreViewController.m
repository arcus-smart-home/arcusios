//
//  HomeFamilyMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 11/16/15.
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
#import "HomeFamilyMoreViewController.h"

#import "DeviceManager.h"

#import "DeviceController.h"

#import "DeviceCapability.h"
#import "HubCapability.h"

#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"

#import "CommonCheckableImageCell.h"
#import "DeviceRenameAssignmentController.h"

#import "SubsystemsController.h"



#import "PersonController.h"

@interface HomeFamilyMoreViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HomeFamilyMoreViewController {
    NSArray<DeviceModel *> *_devices;
}

+ (HomeFamilyMoreViewController *)create {
    HomeFamilyMoreViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:NSLocalizedString(@"More", nil)];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];

    [self observeNotifications];
}

- (void)dealloc {
  [self removeNotificationObservers];
}

- (void)observeNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadData)
                                               name:kSubsystemInitializedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadData)
                                               name:kSubsystemUpdatedNotification
                                             object:nil];
}

- (void)removeNotificationObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSubsystemInitializedNotification
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSubsystemUpdatedNotification
                                                object:nil];
}

- (void)loadData {
  _devices = [[DeviceManager instance] filterDevicesWithMultiType:@[@(DeviceTypeKeyFob), @(DeviceTypeCarePendant)]];

  if ([[[[CorneaHolder shared] modelCache] fetchModels:[PersonCapability namespace]] count] == 0) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
      [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace]
      .then(^(NSArray *personList) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
      });
    });
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    [self.tableView reloadData];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
    
    [cell displayArrow:YES];
    [cell hideCheckbox];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    DeviceModel *model = [_devices objectAtIndex:indexPath.row];
    PersonModel *assignedPerson = [model getAssignedPerson];
    
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    
    NSString *titleLabelStr = [[model name] uppercaseString];
    if (assignedPerson) {
        titleLabelStr = [[NSString stringWithFormat:@"%@'s %@", assignedPerson.firstName, [model name]] uppercaseString];
    }
    
    if (image) {
        image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
        image = [image roundCornerImageWithsize:CGSizeMake(45, 45)];
        
        
//        [NSString stringWithFormat:@"%@'s %@", assignedPerson]
        
        [cell setIcon:image withWhiteTitle: titleLabelStr subtitle:assignedPerson?assignedPerson.fullName:@"Unassigned"];
        
        if (!assignedPerson) {
            [cell attachSideIcon:[UIImage imageNamed:@"userIcon"] inverseColor:NO];
        }
    }
    else {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model] withDevTypeId:[(DeviceModel *)model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *returnImage) {
            
            [cell setIcon:returnImage withWhiteTitle:titleLabelStr subtitle:assignedPerson?assignedPerson.fullName:@"Unassigned"];
            
            if (!assignedPerson) {
                [cell attachSideIcon:[UIImage imageNamed:@"userIcon"] inverseColor:NO];
            }
        });
    }
    
    if (assignedPerson) {
        UIImage *personImage = [assignedPerson image];
        if (!personImage) {
            personImage = [UIImage imageNamed:@"userIcon"];
        }
        else {
            personImage = [personImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(30, 30)];
            personImage = [personImage roundCornerImageWithsize:CGSizeMake(30, 30)];
        }
        [cell attachSideIcon:personImage inverseColor:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceModel *model = [_devices objectAtIndex:indexPath.row];
    DeviceRenameAssignmentController *vc = [DeviceRenameAssignmentController createWithDeviceModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
