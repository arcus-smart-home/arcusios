//
//  AlarmMoreViewController.h
//  i2app
//
//  Created by Arcus Team on 8/19/15.
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
#import "AlarmMorePackage.h"

@class AlarmMoreViewControllerOld;
@class PopupSelectionBaseContainer;

typedef enum {
    AlarmUnitLabelType     = 0,
    AlarmUnitSwitchType,
} AlarmUnitType;

@interface AlarmMoreUnitModel : NSObject

typedef void(^alarmUnitEvent)(AlarmMoreUnitModel *model);

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *sideValue;
@property (nonatomic) BOOL enable;
@property (nonatomic) BOOL disabled;

@property (strong, nonatomic) id tag;
@property (copy, nonatomic) alarmUnitEvent pressedEvent;
@property (copy, nonatomic) alarmUnitEvent updateEvent;

@property (nonatomic) AlarmUnitType unitType;
@property (weak, nonatomic) AlarmMoreViewControllerOld *owner;

+ (AlarmMoreUnitModel *)createLabelModel: (NSString *)title subtitle:(NSString *)subtitle pressedEvent:(alarmUnitEvent)event;
+ (AlarmMoreUnitModel *)createLabelModel: (NSString *)title subtitle:(NSString *)subtitle sideValue:(NSString *)value pressedEvent:(alarmUnitEvent)event;
+ (AlarmMoreUnitModel *)createSwitchModel: (NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected switchEvent:(alarmUnitEvent)event;

@end




@interface AlarmMoreViewControllerOld : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

+ (AlarmMoreViewControllerOld *)create:(AlarmType)type withStoryboard:(NSString *)storyboard;
+ (AlarmMoreViewControllerOld *)createWithPackage:(AlarmBaseMorePackage *)package withStoryboard:(NSString *)storyboard;

- (void)popupWithBlockSetCurrentValue:(PopupSelectionBaseContainer *)container currentValue:(id)currentValue completeBlock:(void (^)(id selectedValue))closeBlock;

- (void)closePopup;

@end




@interface AlarmMoreViewBaseCell : UITableViewCell

@property (readonly, nonatomic) AlarmMoreUnitModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (readonly, nonatomic) CGFloat cellHeight;
- (void)setModel:(AlarmMoreUnitModel *)model;
- (IBAction)onClickBackgroup:(id)sender;

@end




@interface AlarmMoreViewLabelCell : AlarmMoreViewBaseCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end


@interface AlarmMoreViewSwitchCell : AlarmMoreViewBaseCell

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
- (IBAction)onClickSwitch:(id)sender;

@end

