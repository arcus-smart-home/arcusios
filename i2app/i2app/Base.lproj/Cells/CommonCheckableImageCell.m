//
//  CommonCheckableImageCell.m
//  i2app
//
//  Created by Arcus Team on 9/11/15.
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
#import "CommonCheckableImageCell.h"

@interface CommonCheckableImageCell()

@end

#import "SDWebImageManager.h"
#import "UIImage+ImageEffects.h"
#import "UILabel+Extension.h"
#import "NSObject+PerformSelector.h"

#define commConstaintWithSide 50.0f
#define commConstaintWithoutSide 15.0f

@implementation CommonCheckableImageCell {
    
    __weak IBOutlet UIImageView *checkBox;
    __weak IBOutlet UIImageView *iconImage;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UILabel *sideValueLabel;
    __weak IBOutlet UIImageView *arrowIcon;
    __weak IBOutlet UIButton *checkButton;
    
    __weak IBOutlet NSLayoutConstraint *iconXConstraint;
    __weak IBOutlet NSLayoutConstraint *iconYConstraint;
    __weak IBOutlet NSLayoutConstraint *titleTopPositionConstaint;
    __weak IBOutlet NSLayoutConstraint *titlePositionConstaint;
    __weak IBOutlet NSLayoutConstraint *subtitlePositionConstaint;
    __weak IBOutlet NSLayoutConstraint *sidelabelRightConstaint;
    __weak IBOutlet NSLayoutConstraint *titleLeftPositionConstaint;
    
    __weak IBOutlet UIImageView *sideIcon;
    
    BOOL _checked;
    BOOL _hidingCheckbox;
    BOOL _hasSideIcon;
    
    id   _onClickOwner;
    SEL  _onClickSelector;
    id   _attachedObj;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

+ (CommonCheckableImageCell *)create:(UITableView *)tableview {
    CommonCheckableImageCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    return cell;
}

- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIconPath:iconPath withWhiteTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    
    titleLeftPositionConstaint.constant = 105.0f;
    [iconImage setHidden:NO];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:iconPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [iconImage setImage:image];
    }];
    
    [self setWhiteTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIcon:(UIImage *)icon {
    [iconImage setImage:icon];
}

- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIcon:icon withWhiteTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    
    titleLeftPositionConstaint.constant = 105.0f;
    [iconImage setHidden:NO];
    
    if (icon) {
        [iconImage setImage:icon];
    }
    else {
        [iconImage setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
    }
    
    [self setWhiteTitle:title subtitle:subtitle andSide:sideText];
    [checkBox setImage:[UIImage imageNamed:_checked ? @"CheckmarkDetail" : @"UncheckmarkDetail"]];
}


- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIconPath:iconPath withBlackTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    
    titleLeftPositionConstaint.constant = 105.0f;
    [iconImage setHidden:NO];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:iconPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [iconImage setImage:image];
    }];
    
    [self setBlackTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIcon:icon withBlackTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {

    titleLeftPositionConstaint.constant = 105.0f;
    [iconImage setHidden:NO];
    
    if (icon) {
        [iconImage setImage:icon];
    }
    else {
        [iconImage setImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]];
    }
    
    [self setBlackTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setCheck:(BOOL)checked styleBlack:(BOOL)blackStyle {
    _checked = checked;
    _hidingCheckbox = NO;
    checkBox.hidden = NO;
    if (blackStyle) {
        [checkBox setImage:[UIImage imageNamed:checked ? @"CheckMark" : @"CheckmarkEmptyIcon"]];
    }
    else {
        [checkBox setImage:[UIImage imageNamed:checked ? @"CheckmarkDetail" : @"UncheckmarkDetail"]];
    }
    
    [iconXConstraint setConstant:50];
}

- (void)hideCheckbox {
    _hidingCheckbox = YES;
    checkBox.hidden = YES;
    [iconXConstraint setConstant:15];
}

- (void)hideIconImage {
    titleLeftPositionConstaint.constant = _hidingCheckbox ? 15.0f : 50.0f;
    [iconImage setHidden:YES];
}

- (void)displayArrow:(BOOL)display {
    [arrowIcon setHidden:!display];
    sidelabelRightConstaint.constant = display ? 24 : 0;
}

- (BOOL)getChecked {
    return _checked;
}

- (void)attachSideIcon:(UIImage *)icon inverseColor:(BOOL)inverse {
    if (!icon) {
        return;
    }
    
    [sideIcon setHidden:NO];
    _hasSideIcon = YES;
    
    titlePositionConstaint.constant = commConstaintWithSide;
    subtitlePositionConstaint.constant = commConstaintWithSide;
    
    if (inverse) {
        [sideIcon setImage:[icon invertColor]];
    }
    else {
        [sideIcon setImage:icon];
    }
}

- (void)removeSideIcon {
    [sideIcon setHidden:YES];
    _hasSideIcon = NO;
}

- (void)setIconBorderWithBlock:(BOOL)isBlackStyle isTranslucence:(BOOL)translucence isCircle:(BOOL)circle {
    iconImage.layer.borderWidth = 1.0f;
    if (circle) {
        iconImage.layer.cornerRadius = iconImage.frame.size.width/2.0f;
    }
    else {
        iconImage.layer.cornerRadius = 3.0f;
    }
    iconImage.layer.borderColor = isBlackStyle?(translucence?[[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor:[UIColor blackColor].CGColor):(translucence?[[UIColor whiteColor] colorWithAlphaComponent:0.6f].CGColor:[UIColor whiteColor].CGColor);
}

- (void)setCircleImage:(BOOL)status {
    if (status) {
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
        iconImage.clipsToBounds = YES;
        iconImage.layer.cornerRadius = iconImage.bounds.size.width/2;
    }
    else {
        iconImage.clipsToBounds = NO;
        iconImage.layer.cornerRadius = 0.0f;
    }
}

- (void)setOnClickEvent:(SEL)selector owner:(id)owner withObj:(id)obj {
    _onClickOwner = owner;
    _onClickSelector = selector;
    _attachedObj = obj;
    [checkButton setHidden:NO];
}

- (void)disableClickEvent {
    _onClickOwner = nil;
    _onClickSelector = nil;
    [checkButton setHidden:YES];
}

- (IBAction)onClickCheckArea:(id)sender {
    if (_onClickOwner && _onClickSelector) {
        if ([_onClickOwner respondsToSelector:_onClickSelector]) {
            [_onClickOwner performSelector:_onClickSelector withTarget:_onClickOwner withObject:self withObject:_attachedObj];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_hidingCheckbox) {
        [checkBox setHidden:self.editing];
        [iconXConstraint setConstant:self.editing ? 15 : 50];
    }
}

#pragma mark - helping function
- (void)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White];
    if (subtitle && subtitle.length > 0) {
        [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO alpha:YES]];
        
        titleTopPositionConstaint.constant = subtitleLabel.getNumberOfLines > 1 ? 15 : 18;
    }
    else {
        titleTopPositionConstaint.constant = 16;
        [subtitleLabel setText:@""];
    }
    
    [sideValueLabel styleSet:(sideText && sideText.length > 0) ? sideText : @"" andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    titlePositionConstaint.constant = (_hasSideIcon || (sideText && sideText.length > 0)) ? commConstaintWithSide : commConstaintWithoutSide;
    subtitlePositionConstaint.constant = (_hasSideIcon || (sideText && sideText.length > 0)) ? commConstaintWithSide : commConstaintWithoutSide;
    
    [arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
}

- (void)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black];
    if (subtitle && subtitle.length > 0) {
        [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:YES alpha:YES]];
        titleTopPositionConstaint.constant = subtitleLabel.getNumberOfLines > 1 ? 15 : 18;
    }
    else {
        titleTopPositionConstaint.constant = 16;
        [subtitleLabel setText:@""];
    }
    
    [sideValueLabel styleSet:(sideText && sideText.length > 0) ? sideText : @"" andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    titlePositionConstaint.constant = (_hasSideIcon || (sideText && sideText.length > 0)) ? commConstaintWithSide : commConstaintWithoutSide;
    subtitlePositionConstaint.constant = (_hasSideIcon || (sideText && sideText.length > 0)) ? commConstaintWithSide : commConstaintWithoutSide;
    
    [arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
}

- (void)setIcon:(UIImage *)icon withTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText  withBlackFont:(BOOL)isBlack {
    if (isBlack) {
        [self setIcon:icon withBlackTitle:title subtitle:subtitle andSide:sideText];
    }
    else {
        [self setIcon:icon withWhiteTitle:title subtitle:subtitle andSide:sideText];
    }
}

@end
