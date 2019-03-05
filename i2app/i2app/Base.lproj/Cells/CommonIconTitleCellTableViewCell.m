//
//  CommonIconTitleCellTableViewCell.m
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

#import <i2app-Swift.h>
#import "CommonIconTitleCellTableViewCell.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageEffects.h"

#define commConstaintWithSide 50.0f
#define commConstaintWithoutSide 15.0f

@implementation CommonIconTitleCellTableViewCell {
    
    __weak IBOutlet UIImageView *iconImage;
    __weak IBOutlet UILabel *logoLabel;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UILabel *sideValueLabel;
    __weak IBOutlet UIImageView *arrowIcon;
    
    __weak IBOutlet NSLayoutConstraint *iconYConstraint;
    __weak IBOutlet NSLayoutConstraint *titleTopConsaint;
    __weak IBOutlet NSLayoutConstraint *titlePositionConstaint;
    __weak IBOutlet NSLayoutConstraint *subtitlePositionConstaint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

+ (CommonIconTitleCellTableViewCell *)create:(UITableView *)tableview {
    CommonIconTitleCellTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIconPath:iconPath withWhiteTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIconPath:(NSString *)iconPath withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:iconPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [iconImage setImage:image];
    }];
    
    logoLabel.text = @"";
    [self setWhiteTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIcon:icon withWhiteTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIcon:(UIImage *)icon withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    if (icon) {
        [iconImage setImage:icon];
    }
    else {
        [iconImage setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
    }
    
    logoLabel.text = @"";
    [self setWhiteTitle:title subtitle:subtitle andSide:sideText];

}

- (void)setLogoText:(NSString *)iconTxt withWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [logoLabel styleSet:iconTxt andButtonType:FontDataType_Medium_18_White_NoSpace];
    
    [iconImage setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
    
    [self setWhiteTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIconPath:iconPath withBlackTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:iconPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [iconImage setImage:image];
    }];
    
    logoLabel.text = @"";
    
    [self setBlackTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [self setIcon:icon withBlackTitle:title subtitle:subtitle andSide:nil];
}

- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    logoLabel.text = @"";
    
    if (icon) {
        [iconImage setImage:icon];
    }
    else {
        [iconImage setImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]];
    }
    
    [self setBlackTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setLogoText:(NSString *)iconTxt withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [logoLabel styleSet:iconTxt andButtonType:FontDataType_Medium_18_Black_NoSpace];
    [iconImage setImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]];

    [self setBlackTitle:title subtitle:subtitle andSide:sideText];
}

- (void)setIcon:(UIImage *)icon {
    if (icon) {
        [iconImage setImage:icon];
    }
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


#pragma mark - helping function
- (void)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    logoLabel.text = @"";
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White];
    if (subtitle && subtitle.length > 0) {
        titleTopConsaint.constant = 8;
        iconYConstraint.constant = 6;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
    }
    else {
        titleTopConsaint.constant = 26;
        iconYConstraint.constant = 0;
        [subtitleLabel setText:@""];
    }
    
    if (sideText && sideText.length > 0) {
        [sideValueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
        titlePositionConstaint.constant = commConstaintWithSide;
        subtitlePositionConstaint.constant = commConstaintWithSide;
    }
    else {
        [sideValueLabel setText:@""];
        titlePositionConstaint.constant = commConstaintWithoutSide;
        subtitlePositionConstaint.constant = commConstaintWithoutSide;
    }
    
    [arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
}

- (void)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText {
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black];
    if (subtitle && subtitle.length > 0) {
        titleTopConsaint.constant = 8;
        iconYConstraint.constant = 6;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_Medium_14_BlackAlpha_NoSpace];
    }
    else {
        titleTopConsaint.constant = 26;
        iconYConstraint.constant = 0;
        [subtitleLabel setText:@""];
    }
    
    if (sideText && sideText.length > 0) {
        [sideValueLabel styleSet:sideText andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
        titlePositionConstaint.constant = commConstaintWithSide;
        subtitlePositionConstaint.constant = commConstaintWithSide;
    }
    else {
        [sideValueLabel setText:@""];
        titlePositionConstaint.constant = commConstaintWithoutSide;
        subtitlePositionConstaint.constant = commConstaintWithoutSide;
    }
    
    [arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
}

- (void)setIcon:(UIImage *)icon withTitle:(NSString *)title subtitle:(NSString *)subtitle withBlackFont:(BOOL)isBlackFont {
    if (isBlackFont) {
        [self setIcon:icon withBlackTitle:title subtitle:subtitle];
    }
    else {
        [self setIcon:icon withWhiteTitle:title subtitle:subtitle];
    }
}

- (void)setIcon:(UIImage *)icon withTitle:(NSString *)title subtitle:(NSString *)subtitle andSide:(NSString *)sideText withBlackFont:(BOOL)isBlackFont {
    if (isBlackFont) {
        [self setIcon:icon withBlackTitle:title subtitle:subtitle andSide:sideText];
    }
    else {
        [self setIcon:icon withWhiteTitle:title subtitle:subtitle andSide:sideText];
    }
}
@end
