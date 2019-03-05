//
//  DashboardHistoryListViewController.h
//  i2app
//
//  Created by Arcus Team on 8/5/15.
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
@class HistoryModel;
#import "CareActivityManager.h"

// History item model
@interface HistoryModel : NSObject

@property (nonatomic) NSNumber *Stamp;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *eventName;

+ (HistoryModel *)create:(NSNumber *)stamp deviceName:(NSString *)deviceName eventName:(NSString *)eventName;

@end

@interface DashboardHistoryListViewController : UIViewController

+ (DashboardHistoryListViewController *)create;


@end

@interface DashboardHistoryListCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

- (void)setAttribute:(HistoryModel *)model;

@end


@interface DashboardHistoryLoadingCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noHistoryLabel;

@end
