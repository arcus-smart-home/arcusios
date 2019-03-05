//
//  CommonTitleWithSubtitleCell.h
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

@interface CommonTitleWithSubtitleCell : UITableViewCell

+ (CommonTitleWithSubtitleCell *)create:(UITableView *)tableview;

@property (nonatomic, assign) NSString *sideValueString;

- (CommonTitleWithSubtitleCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side;
- (CommonTitleWithSubtitleCell *)setNoSideWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle;

- (CommonTitleWithSubtitleCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side;
- (CommonTitleWithSubtitleCell *)setNoSideBlackTitle:(NSString *)title subtitle:(NSString *)subtitle;

- (CommonTitleWithSubtitleCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side isBlack:(BOOL)isBlack;
- (CommonTitleWithSubtitleCell *)setNoSideTitle:(NSString *)title subtitle:(NSString *)subtitle isBlack:(BOOL)isBlack;

@end
