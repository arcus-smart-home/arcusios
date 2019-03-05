//
//  DeviceSettingModels.h
//  i2app
//
//  Created by Arcus Team on 8/6/15.
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

#import <Foundation/Foundation.h>



/*
 * // For the cell of setting
 *
 * DeviceSettingUnitBase -> base data, for only cell/group data
 * DeviceSettingCells -> base cell UIs, from UITableViewCell
 * DeviceSettingCellController -> special function for special device model, derive from DeviceSettingUnitBase
 *
 */
@interface DeviceSettingUnitBase : NSMutableArray

@property (strong, nonatomic) NSString *title;
// operating controller
@property (weak, nonatomic) UIViewController *controlOwner;
@property (weak, nonatomic) DeviceModel *deviceModel;

// for table view to get cell
- (UITableViewCell *)getCell;

// for over override to generate appropriate cell
- (UITableViewCell *)generateCell;

- (void)loadData;

- (void)setValue:(id)value to:(NSString *)key;
- (id)getValueFrom:(NSString *)key;

- (void)setBoolean:(BOOL)value to:(NSString *)key;
- (BOOL)getBooleanFrom:(NSString *)key;

- (void)setInt:(NSInteger)value to:(NSString *)key;
- (NSInteger)getIntFrom:(NSString *)key;

- (void)setString:(NSString *)text to:(NSString *)key;
- (NSString *)getStringFrom:(NSString *)key;

@end

// Data for a table
@interface DeviceSettingUnitCollection: NSObject

- (instancetype)initWithOwner: (UIViewController *)owner deviceModel:(DeviceModel *)model;

- (NSInteger)getNumberOfSection;
- (NSInteger)getNumberOfRows:(NSInteger)section;
- (NSString *)getSectionTitle:(NSInteger)section;
- (CGFloat)getHeightOfCell:(NSIndexPath *)indexPath;
- (DeviceSettingUnitBase *)getUnit:(NSIndexPath *)indexPath;
- (UITableViewCell *)getCell:(NSIndexPath *)indexPath;
- (void)addUnit:(DeviceSettingUnitBase *)unit;
- (void)removeUnit:(DeviceSettingUnitBase *)unit;
- (void)removeAllUnit ;
- (BOOL)hasSecondLevelUnits;

@end


// Data package for one device
@interface DeviceSettingPackage : NSObject

+ (DeviceSettingPackage *)generateDeviceSetting: (DeviceModel *)model controlOwner:(UIViewController *)owner;
+ (DeviceSettingPackage *)generateDeviceSettingFromDevice:(UIViewController *)owner device:(DeviceModel*)deviceModel;
+ (BOOL)hasSetting:(DeviceModel *)model;

@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSString *subscriptionText;

@property (readonly, strong, nonatomic) DeviceSettingUnitCollection *unitCollection;

- (instancetype)initWithOwner: (UIViewController *)owner deviceModel:(DeviceModel *)model;
- (void)loadData;
- (BOOL)shouldDisplay;

@end



