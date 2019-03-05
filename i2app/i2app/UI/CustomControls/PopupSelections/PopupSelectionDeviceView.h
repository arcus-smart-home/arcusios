//
//  PopupSelectionDeviceView.h
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

#import "PopupSelectionBaseContainer.h"



@interface DeviceSelectModel : NSObject

@property (assign, nonatomic) BOOL selected;
@property (strong, nonatomic) DeviceModel *deviceModel;

+ (DeviceSelectModel *)create:(DeviceModel *)model withSelected:(BOOL)selected;
+ (NSArray<DeviceSelectModel *> *)convertDevices:(NSArray<DeviceModel *> *)devices withSelectedDevices:(NSArray<DeviceModel *> *)selectedDevices;

@end


@interface PopupSelectionDeviceView : PopupSelectionBaseContainer

+ (PopupSelectionDeviceView *)create:(NSString *)title;
+ (PopupSelectionDeviceView *)create:(NSString *)title devices:(NSArray<DeviceModel *> *)devices;
+ (PopupSelectionDeviceView *)create:(NSString *)title deviceSelectModels:(NSArray<DeviceSelectModel *> *)models;
+ (PopupSelectionDeviceView *)create:(NSString *)title devices:(NSArray<DeviceModel *> *)devices withInitialSelection:(DeviceModel *)initialSelection;

- (PopupSelectionDeviceView *)setMultipleSelect:(BOOL)allowMultiple;

@end
