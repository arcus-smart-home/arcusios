//
//  CommonCheckableCell.m
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

#import <i2app-Swift.h>
#import "CommonCheckableCell.h"

@implementation CommonCheckableCell {
    
    __weak IBOutlet UIImageView *checkSelector;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UIImageView *arrowIcon;
    __weak IBOutlet UILabel *sidevalueLabel;
    
    
    __weak IBOutlet NSLayoutConstraint *titleTopConstraint;
    __weak IBOutlet NSLayoutConstraint *titleTrailingConstraint;
    __weak IBOutlet NSLayoutConstraint *subtitleTrailingConstraint;
    
    __weak IBOutlet NSLayoutConstraint *titleLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *subtitleLeftConstraint;
    __weak IBOutlet NSLayoutConstraint *sidevalueWidthConstraint;
    
    BOOL _blackStyle;
    BOOL _cellSelected;
}

@dynamic cellSelected;

- (BOOL)cellSelected {
    return _cellSelected;
}

+ (CommonCheckableCell *)create:(UITableView *)tableview {
    CommonCheckableCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil][0];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    [subtitleLabel setText:@""];
    [subtitleLabel setHidden:YES];
    [sidevalueLabel setHidden:YES];
    
    titleTrailingConstraint.constant = 20;
    subtitleTrailingConstraint.constant = 20;
    titleTopConstraint.constant = 15;
    sidevalueWidthConstraint.constant = 0;
    [arrowIcon setHidden:YES];
    _blackStyle = NO;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setBlackTitle:(NSString *)title {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    [subtitleLabel setText:@""];
    [subtitleLabel setHidden:YES];
    [sidevalueLabel setHidden:YES];
    
    titleTrailingConstraint.constant = 20;
    subtitleTrailingConstraint.constant = 20;
    titleTopConstraint.constant = 15;
    sidevalueWidthConstraint.constant = 0;
    [arrowIcon setHidden:YES];
    _blackStyle = YES;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setTitle:(NSString *)title isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setBlackTitle:title];
    }
    else {
        return [self setWhiteTitle:title];
    }
}

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO alpha:YES]];
    
    [subtitleLabel setHidden:NO];
    [sidevalueLabel setHidden:YES];
    
    titleTopConstraint.constant = 6;
    titleTrailingConstraint.constant = 20;
    subtitleTrailingConstraint.constant = 20;
    sidevalueWidthConstraint.constant = 0;
    [arrowIcon setHidden:YES];
    _blackStyle = NO;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:YES alpha:YES]];
    
    [subtitleLabel setHidden:NO];
    [sidevalueLabel setHidden:YES];
    
    titleTopConstraint.constant = 6;
    titleTrailingConstraint.constant = 20;
    subtitleTrailingConstraint.constant = 20;
    sidevalueWidthConstraint.constant = 0;
    [arrowIcon setHidden:YES];
    _blackStyle = YES;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setBlackTitle:title withSubtitle:subtitle];
    }
    else {
        return [self setWhiteTitle:title withSubtitle:subtitle];
    }
}

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [sidevalueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    
    [subtitleLabel setHidden:YES];
    [sidevalueLabel setHidden:NO];
    
    titleTopConstraint.constant = 15;
    titleTrailingConstraint.constant = 80;
    subtitleTrailingConstraint.constant = 80;
    
    CGFloat sideWidth = [sidevalueLabel sizeThatFits:CGSizeMake(150, 21)].width;
    sidevalueWidthConstraint.constant =  MIN(130, sideWidth);
    
    [arrowIcon setHidden:YES];
    _blackStyle = NO;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    [sidevalueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    
    [subtitleLabel setHidden:YES];
    [sidevalueLabel setHidden:NO];
    
    titleTopConstraint.constant = 15;
    titleTrailingConstraint.constant = 80;
    subtitleTrailingConstraint.constant = 80;
    
    CGFloat sideWidth = [sidevalueLabel sizeThatFits:CGSizeMake(150, 21)].width;
    sidevalueWidthConstraint.constant =  MIN(130, sideWidth);
    
    [arrowIcon setHidden:YES];
    _blackStyle = YES;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setWhiteTitle:(NSString *)title withSubtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO alpha:YES]];
    [sidevalueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    
    [subtitleLabel setHidden:NO];
    [sidevalueLabel setHidden:NO];
    
    titleTopConstraint.constant = 6;
    titleTrailingConstraint.constant = 80;
    subtitleTrailingConstraint.constant = 80;
    
    CGFloat sideWidth = [sidevalueLabel sizeThatFits:CGSizeMake(150, 21)].width;
    sidevalueWidthConstraint.constant =  MIN(130, sideWidth);
    
    [arrowIcon setHidden:YES];
    _blackStyle = NO;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (CommonCheckableCell *)setBlackTitle:(NSString *)title withSubtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:YES alpha:YES]];
    [sidevalueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    
    [subtitleLabel setHidden:NO];
    [sidevalueLabel setHidden:NO];
    
    titleTopConstraint.constant = 6;
    titleTrailingConstraint.constant = 80;
    subtitleTrailingConstraint.constant = 80;
    
    CGFloat sideWidth = [sidevalueLabel sizeThatFits:CGSizeMake(150, 21)].width;
    sidevalueWidthConstraint.constant =  MIN(130, sideWidth);
    
    [arrowIcon setHidden:YES];
    _blackStyle = YES;
    [self setSelectedBox:NO];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)displayCheckbox:(BOOL)display {
    checkSelector.hidden = !display;
    titleLeftConstraint.constant = display? 42: 5;
    subtitleLeftConstraint.constant = display? 42: 5;
}

- (void)setSelectedBox:(BOOL)selected {
    _cellSelected = selected;
    if (_cellSelected) {
        if (_blackStyle) {
            [checkSelector setImage:[UIImage imageNamed:@"CheckMark"]];
        }
        else {
            [checkSelector setImage:[UIImage imageNamed:@"CheckmarkDetail"]];
        }
    }
    else {
        if (_blackStyle) {
            [checkSelector setImage:[UIImage imageNamed:@"CheckmarkEmptyIcon"]];
        }
        else {
            [checkSelector setImage:[UIImage imageNamed:@"UncheckmarkDetail"]];
        }
    }
}

- (void)displayArrow:(BOOL)display {
    if (_blackStyle) {
        [arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
    }
    else {
        [arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
    }
    
    [arrowIcon setHidden:!display];
}


- (void)layoutSubviews {
    [self displayCheckbox: !self.editing];
    [super layoutSubviews];
}

@end
