//
//  CareOpenCountDevicePickerViewController.h
//  i2app
//
//  Created by Arcus Team on 2/25/16.
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

#import <UIKit/UIKit.h>
#import "CareOpenCountDeviceModel.h"

typedef void (^OpenCountPickerCompletion)(NSMutableArray<CareOpenCountDeviceModel *> *);

@interface CareOpenCountDevicePickerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray<CareOpenCountDeviceModel *> *deviceCounts;
@property (copy, nonatomic)   OpenCountPickerCompletion completion;
@property (nonatomic)         BOOL isCreationMode;

@end
