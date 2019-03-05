//
//  CommonTitleWithSubtitleCell.m
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

#import <i2app-Swift.h>
#import "CommonTitleWithSubtitleCell.h"

@implementation CommonTitleWithSubtitleCell {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet UILabel *sidevalueLabel;
    __weak IBOutlet UIImageView *arrowIcon;
    
    
    __weak IBOutlet NSLayoutConstraint *titleLabelTopConstaint;
    
    __weak IBOutlet NSLayoutConstraint *titleLabelConstaint;
    __weak IBOutlet NSLayoutConstraint *subtitleLabelConstaint;
}

@dynamic sideValueString;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

+ (CommonTitleWithSubtitleCell *)create:(UITableView *)tableview {
    CommonTitleWithSubtitleCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

#pragma mark - Dynamic Properties
- (NSString *)sideValueString {
    return sidevalueLabel.text;
}

- (CommonTitleWithSubtitleCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side {
    titleLabelConstaint.constant = 100;
    subtitleLabelConstaint.constant = 120;
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    if (subtitle && subtitle.length > 0) {
        titleLabelTopConstaint.constant = 15;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    }
    else {
        titleLabelTopConstaint.constant = 25;
        [subtitleLabel setText:@""];
    }
    
    [sidevalueLabel setTextAlignment:NSTextAlignmentRight];
    if (side && side.length > 0) {
        [sidevalueLabel styleSet:side andButtonType:FontDataType_Medium_14_WhiteAlpha_NoSpace];
    }
    else {
        [sidevalueLabel setText:@""];
    }
    
    [arrowIcon setImage:[UIImage imageNamed:@"ChevronWhite"]];
    
    return self;
}

- (CommonTitleWithSubtitleCell *)setNoSideWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle {
    titleLabelConstaint.constant = 15;
    subtitleLabelConstaint.constant = 15;
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    if (subtitle && subtitle.length > 0) {
        titleLabelTopConstaint.constant = 15;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    }
    else {
        titleLabelTopConstaint.constant = 25;
        [subtitleLabel setText:@""];
    }
    
    [sidevalueLabel setText:@""];
    [arrowIcon setImage:nil];
    return self;
}

- (CommonTitleWithSubtitleCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side {
    titleLabelConstaint.constant = 100;
    subtitleLabelConstaint.constant = 120;
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    if (subtitle && subtitle.length > 0) {
        titleLabelTopConstaint.constant = 15;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    }
    else {
        titleLabelTopConstaint.constant = 25;
        [subtitleLabel setText:@""];
    }
    
    if (side && side.length > 0) {
        [sidevalueLabel styleSet:side andButtonType:FontDataType_Medium_14_BlackAlpha_NoSpace];
    }
    else {
        [sidevalueLabel setText:@""];
    }
    
    [arrowIcon setImage:[UIImage imageNamed:@"Chevron"]];
    return self;
}

- (CommonTitleWithSubtitleCell *)setNoSideBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    titleLabelConstaint.constant = 15;
    subtitleLabelConstaint.constant = 15;
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    if (subtitle && subtitle.length > 0) {
        titleLabelTopConstaint.constant = 15;
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_BlackAlpha_NoSpace];
    }
    else {
        titleLabelTopConstaint.constant = 25;
        [subtitleLabel setText:@""];
    }
    
    [sidevalueLabel setText:@""];
    [arrowIcon setImage:nil];
    
    return self;
}

- (CommonTitleWithSubtitleCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle side:(NSString *)side isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setBlackTitle:title subtitle:subtitle side:side];
    }
    else {
        return [self setWhiteTitle:title subtitle:subtitle side:side];
    }
}

- (CommonTitleWithSubtitleCell *)setNoSideTitle:(NSString *)title subtitle:(NSString *)subtitle isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setNoSideBlackTitle:title subtitle:subtitle];
    }
    else {
        return [self setNoSideWhiteTitle:title subtitle:subtitle];
    }
}

@end
