//
//  CommonTitleValueonRightCell.h
//  i2app
//
//  Created by Arcus Team on 9/3/15.
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

@interface CommonTitleValueonRightCell : UITableViewCell

+ (CommonTitleValueonRightCell *)create:(UITableView *)tableview;

- (void)setDescription:(NSString *)text;

- (void)setWhiteTitle:(NSString *)title;
- (void)setWhiteTitle:(NSString *)title sideValue:(NSString *)sideValue;

- (void)setBlackTitle:(NSString *)title;
- (void)setBlackTitle:(NSString *)title sideValue:(NSString *)sideValue;

- (void)setTitle:(NSString *)title isBlack:(BOOL)isBlack;
- (void)setTitle:(NSString *)title sideValue:(NSString *)sideValue isBlack:(BOOL)isBlack;

- (void)displaySideIcon:(UIImage *)icon;
- (void)hideSideIcon;

@end
