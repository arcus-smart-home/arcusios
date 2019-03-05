//
//  SmartFobSelectionViewController.m
//  i2app
//
//  Created by Arcus Team on 7/14/15.
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
#import "SmartFobPairingSelectionController.h"
#import "SmartFobPairingSelectionDetailController.h"
#import "OrderedDictionary.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"
#import "RulesController.h"
#import "DeviceModel+Extension.h"
#import "DeviceCapability.h"

@interface SmartFobPairingSelectionController() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * settingArray;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SmartFobPairingSelectionController {
    ButtonType _type;
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step device:(DeviceModel*)model {
    SmartFobPairingSelectionController *controller = [self createWithDeviceStep:step];
    controller.deviceModel = model;
    return controller;
}

+ (SmartFobPairingSelectionController *)createWithDeviceModel:(DeviceModel*)deviceModel {
    SmartFobPairingSelectionController *controller = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SmartFobPairingSelectionController class])];
    controller.deviceModel = deviceModel;
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"key fob", nil).uppercaseString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColorToParentColor];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:[[UIView alloc] init]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.settingArray = nil;
    [self loadData];
}

#pragma mark - Load Data Methods
- (void)loadData {
  NSArray *orderArray = @[@"circle", @"diamond", @"square", @"hexagon", @"away", @"home", @"none", @"a", @"b"];
  NSArray *toSort = self.deviceModel.instances.allKeys;
  NSMutableArray *toSortOrderMapping = [NSMutableArray new];
  [toSort enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSInteger orderedIdx = [orderArray indexOfObject:obj]; // NSIntegerMax if not found
    [toSortOrderMapping addObject:@{obj: [NSNumber numberWithInteger:orderedIdx]}];
  }];
  [toSortOrderMapping sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
    NSNumber *obj1Idx = obj1[obj1.allKeys.firstObject];
    NSNumber *obj2Idx = obj2[obj2.allKeys.firstObject];
    return [obj1Idx compare:obj2Idx];
  }];
  NSMutableArray *finalOrdering = [NSMutableArray new];
  [toSortOrderMapping enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [finalOrdering addObject:obj.allKeys.firstObject];
  }];
  self.settingArray = finalOrdering;
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return self.settingArray.count;
    }
    return 0;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        SmartFobPairingSelectionControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
        NSString *instance = [self.settingArray objectAtIndex:indexPath.row];

        //TODO: use KeyfobV3ImageMap
      NSString *productId = [DeviceCapability getProductIdFromModel:self.deviceModel];
      if ([productId isEqualToString:kGen3FourButtonFob]) {
        NSDictionary *map = KeyfobV3ImageMap;
        [cell setTitle:[ButtonTypeToString(stringToButtonType(instance)) uppercaseString]
                 image:map[instance]];
      } else {
        [cell setTitle:[ButtonTypeToString(stringToButtonType(instance)) uppercaseString]
                 image:ButtonTypeToString(stringToButtonType(instance))];
      }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *instance = [self.settingArray objectAtIndex:indexPath.row];

    UIViewController *controller = [SmartFobPairingSelectionDetailController create:stringToButtonType(instance)
                                                                             device:self.deviceModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

@implementation SmartFobPairingSelectionControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setTitle:(NSString *)title image:(NSString *)imageName {
    [self.titleLabel styleSet:title andButtonType:FontDataTypeDeviceKeyfobSettingSheetTitle];
    [self.logoImage setImage:[[UIImage imageNamed:imageName] invertColor]];
}

@end


