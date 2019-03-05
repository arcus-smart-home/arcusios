//
//  CommonCheckableCell.h
//  i2app
//
//  Created by Arcus Team on 10/6/15.
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

__attribute__((deprecated(("CommonCheckableCell does not use storyboard prototyping for cells, and cannot be used dynamically.  Use ArcusSelectOptionTableViewCell instead."))))
@interface CommonCheckableCell : UITableViewCell

+ (CommonCheckableCell *)create:(UITableView *)tableview;

@property (atomic, assign, readonly) BOOL cellSelected;

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title;
- (CommonCheckableCell *)setBlackTitle:(NSString *)title;
- (CommonCheckableCell *)setTitle:(NSString *)title isBlack:(BOOL)isBlack;

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSubtitle:(NSString *)subtitle;
- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSubtitle:(NSString *)subtitle;
- (CommonCheckableCell *)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle isBlack:(BOOL)isBlack;

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSide:(NSString *)sideText;
- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSide:(NSString *)sideText;

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSubtitle:(NSString *)subtitle andSide:(NSString *)sideText;
- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSubtitle:(NSString *)subtitle andSide:(NSString *)sideText;

- (void)setSelectedBox:(BOOL)selected;
- (void)displayArrow:(BOOL)display;

@end
