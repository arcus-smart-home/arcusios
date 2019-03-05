//
//  AlarmingViewController.h
//  i2app
//
//  Created by Arcus Team on 1/29/16.
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
#import "AlarmConfiguration.h"

@class AlarmBaseViewController;

@interface AlarmingHistoryListCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sideIcon;

@end

@interface AlarmingViewController : UIViewController

+ (AlarmingViewController *)createWithOwner:(AlarmBaseViewController *)owner alarmType:(AlarmType)type name:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color ;
- (void)setDeviceIcon:(UIImage *)icon;

@end
