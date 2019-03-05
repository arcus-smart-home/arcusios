//
//  CommonTitleValueonRightCell.m
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

#import <i2app-Swift.h>
#import "CommonTitleValueonRightCell.h"

@implementation CommonTitleValueonRightCell {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *sidevalueLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIImageView *arrowIcon;
    __weak IBOutlet UIImageView *titleSideIcon;
    BOOL _isInBlackColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

+ (CommonTitleValueonRightCell *)create:(UITableView *)tableview {
    CommonTitleValueonRightCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

- (void)setDescription:(NSString *)text {
    [descriptionLabel styleSet:text andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:_isInBlackColor space:NO alpha:YES]];
}

- (void)setWhiteTitle:(NSString *)title {
    [self setWhiteTitle:title sideValue:nil];
}
- (void)setWhiteTitle:(NSString *)title sideValue:(NSString *)sideValue {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_13_White];
    [sidevalueLabel styleSet:sideValue andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
    [arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
    _isInBlackColor = NO;
}

- (void)setBlackTitle:(NSString *)title  {
    [self setBlackTitle:title sideValue:nil];
}

- (void)setBlackTitle:(NSString *)title sideValue:(NSString *)sideValue {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black];
    [sidevalueLabel styleSet:sideValue andButtonType:FontDataType_Medium_14_BlackAlpha_NoSpace];
    [arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
    _isInBlackColor = YES;
}

- (void)setTitle:(NSString *)title isBlack:(BOOL)isBlack {
    if (isBlack) {
        [self setBlackTitle:title];
    }
    else {
        [self setWhiteTitle:title];
    }
}

- (void)setTitle:(NSString *)title sideValue:(NSString *)sideValue isBlack:(BOOL)isBlack {
    if (isBlack) {
        [self setBlackTitle:title sideValue:sideValue];
    }
    else {
        [self setWhiteTitle:title sideValue:sideValue];
    }
}

- (void)displaySideIcon:(UIImage *)icon {
    [titleSideIcon setImage:icon];
    [titleSideIcon setHidden:NO];
}
- (void)hideSideIcon {
    [titleSideIcon setHidden:YES];
}

@end
