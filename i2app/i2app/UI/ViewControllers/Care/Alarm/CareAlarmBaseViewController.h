//
//  CareAlarmBaseViewController.h
//  i2app
//
//  Created by Arcus Team on 2/1/16.
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

#import "DeviceAttributeGroupView.h"
#import "DeviceButtonGroupView.h"
#import "DeviceAttributeGroupView.h"
#import "CareTabBarController.h"

@class PopupSelectionBaseContainer;
@class CareAlarmTabBarViewController;

@protocol AlarmSubsystemProtocol;

@interface CareAlarmBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet DeviceAttributeGroupView *attributesView;
@property (weak, nonatomic) IBOutlet DeviceButtonGroupView *buttonsView;
@property (weak, nonatomic) id<AlarmSubsystemProtocol> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isAlarming;
@property (weak, nonatomic) CareAlarmBaseViewController *owner;

+ (CareAlarmBaseViewController *)createWithStoryboard:(NSString *)storyboard withOwner:(CareAlarmTabBarViewController *)owner;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)setRingTextWithTitle:(NSString *)title;
- (void)setRingText:(NSString *)text;
- (void)setRingText:(NSString *)text withSuperscript:(NSString *)script;
- (void)setRingTitle:(NSString *)title;

- (void)loadRingSigmentsWithModel:(NSArray *)segmentModels;

#pragma mark - assist function
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector;
- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector;

- (void)activeAlarmWithName:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color;
- (void)setIconByDevice:(DeviceModel *)device withImage:(NSString *)imageName;
- (void)deactivateAlarm;

- (void)removeButtons;
- (void)loadButton:(DeviceButtonBaseControl *)button;
- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2;
- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2 button3:(DeviceButtonBaseControl *)button3;

@end
