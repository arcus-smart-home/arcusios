//
//  DeviceNotificationLabel.h
//  i2app
//
//  Created by Arcus Team on 7/6/15.
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

typedef void(^deviceNotificationCloseBlock)(id sender);

@interface DeviceNotificationLabelModel : NSObject

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *contentString;

@property (strong, nonatomic) UIImage *leftIcon;
@property (strong, nonatomic) UIImage *rightIcon;

@property (nonatomic) BOOL hasCloseButton;
@property (copy) deviceNotificationCloseBlock closeEvent;

@end

@interface DeviceNotificationLabel : UILabel

- (DeviceNotificationLabelModel *) getLabelModel;
- (void) setLabelModel: (DeviceNotificationLabelModel *)model;

- (void) setTitle:(NSString *)title andContent:(NSString *)content;
- (void) setTitle:(NSString *)title andTime:(NSDate *)date;
- (void) setTitle:(NSString *)title andDurationInMinute:(int)duration;

- (void) setTitle:(NSString *)title withLeftIcon:(UIImage *)icon;
- (void) setTitle:(NSString *)title withRightIcon:(UIImage *)icon;

- (void) setTitle:(NSString *)title;
- (void) setContent:(NSString *)content;

- (void) enableClose:(deviceNotificationCloseBlock)block;
- (void) onClickClose;
- (void) hideClose;
@end
