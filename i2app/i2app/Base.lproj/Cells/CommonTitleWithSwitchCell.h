//
//  TitleWithSwitchCell.h
//  i2app
//
//  Created by Arcus Team on 9/10/15.
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

@class CommonTitleWithSwitchCell;

@protocol CommonTitleWithSwitchCellDelegate <NSObject>

@optional

- (void)commonTitleWithSwitchCell:(CommonTitleWithSwitchCell *)cell
                            title:(NSString *)title
                    switchControl:(UISwitch *)switchControl
                changedOnOffState:(BOOL)state;

@end

@interface CommonTitleWithSwitchCell : UITableViewCell

+ (CommonTitleWithSwitchCell *)create:(UITableView *)tableview;

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected withObj:(id)obj;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo withObj:(id)obj;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath withObj:(id)obj;

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected;
- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj;

- (CommonTitleWithSwitchCell *)setLogo:(UIImage *)logo;

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected withObj:(id)obj;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo withObj:(id)obj;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath withObj:(id)obj;

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected;
- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj;

- (CommonTitleWithSwitchCell *)setTitleStyle:(float)size blackColor:(BOOL)black;

- (void)enableIndent:(BOOL)enable;

- (CommonTitleWithSwitchCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected isBlack:(BOOL)isBlack;
- (CommonTitleWithSwitchCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj isBlack:(BOOL)isBlack;

@property (nonatomic, assign) id <CommonTitleWithSwitchCellDelegate> delegate;
@property (nonatomic) BOOL switchSelected;
@property (readonly, strong, nonatomic) id cellObj;

@end
