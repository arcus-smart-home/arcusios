//
//  PopupSelectionCheckedTextCell.h
//  i2app
//
//  Created by Arcus Team on 12/18/15.
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

@class PopupSelectionCheckedTextView;

@interface PopupSelectionCheckedItemModel: NSObject

@property (assign, nonatomic) BOOL selected;


+ (PopupSelectionCheckedItemModel*) createWithTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected;

- (PopupSelectionCheckedItemModel*) setTitleText:(NSString *)title;
- (PopupSelectionCheckedItemModel*) setSubtitleText:(NSString *)subtitle;
- (PopupSelectionCheckedItemModel*) setReturnObj:(NSObject *)obj;

- (NSObject *) getReturningObj;

@end


@interface PopupSelectionCheckedTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;

- (void) set:(PopupSelectionCheckedItemModel *)itemModel owner:(PopupSelectionCheckedTextView *)owner;

@end
