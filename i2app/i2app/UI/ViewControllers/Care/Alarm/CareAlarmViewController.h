//
//  CareAlarmViewController.h
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "CareAlarmBaseViewController.h"
#import "CareBehaviorModel.h"

@interface CareAlarmViewController : CareAlarmBaseViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *viewTitle;

@property (strong, nonatomic) NSArray<CareBehaviorModel *> *existingBehaviors;
@property (strong, nonatomic) NSArray<RuleModel *> *existingRules;

@property (strong, nonatomic) id previousViewController;

+ (void)createWithCompletionBlock:( void (^) (CareAlarmViewController*))completionBlock;
+ (CareAlarmViewController *)createWithStoryboard:(NSString *)storyboard title:(NSString *)title borderColor:(UIColor *)color type:(AlarmType)type;
+ (CareAlarmViewController *)createWithOwner:(CareAlarmBaseViewController *)owner alarmType:(AlarmType)type name:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color ;

@end
