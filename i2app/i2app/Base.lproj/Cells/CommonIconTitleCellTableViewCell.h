//
//  CommonIconTitleCellTableViewCell.h
//  i2app
//
//  Created by Arcus Team on 9/9/15.
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

@interface CommonIconTitleCellTableViewCell : UITableViewCell

+ (CommonIconTitleCellTableViewCell *)create:(UITableView *)tableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;

- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;
- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;
- (void)setLogoText:(NSString *)iconTxt withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;

- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;
- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle;
- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;
- (void)setLogoText:(NSString *)iconTxt withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText;

- (void)setIcon:(UIImage *)icon;
- (void)setIconBorderWithBlock:(BOOL)isBlackStyle isTranslucence:(BOOL)translucence isCircle:(BOOL)circle;

- (void)setIcon:(UIImage *)icon withTitle:(NSString *)title subtitle:(NSString *)subtitle withBlackFont:(BOOL)isBlackFont;

- (void)setIcon:(UIImage *)icon withTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText withBlackFont:(BOOL)isBlackFont;

@end
