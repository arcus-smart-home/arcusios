//
//  ArcusModalSelectionModel.h
//  i2app
//
//  Created by Arcus Team on 2/12/16.
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

@class DeviceModel;

@interface ArcusModalSelectionModel : NSObject

@property (nonatomic, strong) NSString* _Nonnull title;
@property (nonatomic, strong) NSString* _Nonnull itemDescription;
@property (nonatomic, strong) NSString* _Nonnull deviceAddress;
@property (nonatomic, strong) UIImage* _Nonnull image;
@property (nonatomic, strong) NSString* _Nonnull tag;
@property (nonatomic, assign) BOOL isSelectAll;
@property (nonatomic, assign) BOOL isSelected;

+ (ArcusModalSelectionModel * _Nonnull)selectionModelForDevice:(DeviceModel * _Nonnull)model;

@end
