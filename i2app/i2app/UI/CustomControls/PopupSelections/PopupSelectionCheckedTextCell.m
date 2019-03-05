//
//  PopupSelectionCheckedTextCell.m
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

#import <i2app-Swift.h>
#import "PopupSelectionCheckedTextCell.h"
#import "PopupSelectionCheckedTextView.h"


@interface PopupSelectionCheckedItemModel()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;

@property (strong, nonatomic) NSObject *returningObj;
@property (strong, nonatomic) Model    *dynamicModel;

@end


@implementation PopupSelectionCheckedItemModel


+ (PopupSelectionCheckedItemModel*) createWithTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected {
    PopupSelectionCheckedItemModel *model = [[PopupSelectionCheckedItemModel alloc] init];
    [model setTitle:title];
    [model setSubtitle:subtitle];
    [model setSelected:selected];
    return model;
}

- (PopupSelectionCheckedItemModel*) setTitleText:(NSString *)title {
    self.title = title;
    return self;
}

- (PopupSelectionCheckedItemModel*) setSubtitleText:(NSString *)subtitle {
    self.subtitle = subtitle;
    return self;
}

- (PopupSelectionCheckedItemModel*) setReturnObj:(NSObject *)obj {
    self.returningObj = obj;
    return self;
}

- (NSObject *) getReturningObj {
    if (self.returningObj) {
        return self.returningObj;
    }
    else if (self.dynamicModel) {
        return self.dynamicModel;
    }
    return self;
}


@end


@implementation PopupSelectionCheckedTextCell {
    __weak PopupSelectionCheckedTextView *_controller;
    PopupSelectionCheckedItemModel *_itemModel;
    __weak IBOutlet NSLayoutConstraint *titlePositionConstraint;
    __weak IBOutlet NSLayoutConstraint *titleLeftConstraint;
}

- (void) set:(PopupSelectionCheckedItemModel *)itemModel owner:(PopupSelectionCheckedTextView *)owner {
    _itemModel = itemModel;
    _controller = owner;
    
    [self.titleLabel setText:itemModel.title];
    
    if (itemModel.subtitle && itemModel.subtitle.length > 0) {
        titlePositionConstraint.constant = 9.0f;
        [self.subtitleLabel setText:itemModel.subtitle];
    }
    else {
        titlePositionConstraint.constant = 15.0f;
        self.subtitleLabel.text = @"";
    }
    
    [self.checkIcon setImage:itemModel.selected ? [UIImage imageNamed:@"CheckMark"] : [UIImage imageNamed : @"CheckmarkEmptyIcon"]];

    titleLeftConstraint.constant = 15;
}

@end
