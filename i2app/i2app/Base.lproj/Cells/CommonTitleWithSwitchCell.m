//
//  TitleWithSwitchCell.m
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
#import "CommonTitleWithSwitchCell.h"
#import "SDWebImageManager.h"
#import "UIImage+ImageEffects.h"
#import <PureLayout/PureLayout.h>

@implementation CommonTitleWithSwitchCell {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UIImageView *iconImage;
    __weak IBOutlet UISwitch *sideSwitch;

    BOOL _switchSelected;
    __weak IBOutlet NSLayoutConstraint *labelConstaint;
    __weak IBOutlet UILabel *subtitleLabel;
    __weak IBOutlet NSLayoutConstraint *labelTopConstaint;
}

@dynamic selected;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    [sideSwitch setUserInteractionEnabled:NO];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

+ (CommonTitleWithSwitchCell *)create:(UITableView *)tableview {
    CommonTitleWithSwitchCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected {
    return [self setWhiteTitle:title selected:selected withObj:nil];
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected withObj:(id)obj {
    return [self setWhiteTitle:title subtitle:nil selected:selected withObj:obj];
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected {
    return [self setWhiteTitle:title subtitle:subtitle selected:selected withObj:nil];
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:YES];
    labelConstaint.constant = 15;
    
    if (subtitle && subtitle.length > 0) {
        [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO alpha:YES]];
        labelTopConstaint.constant = 10.0;
    }
    else {
        [subtitleLabel setText:@""];
        labelTopConstaint.constant = 23.0;
    }
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    [sideSwitch setOn:selected animated:YES];
    sideSwitch.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    
    return self;
}

- (CommonTitleWithSwitchCell *)setLogo:(UIImage *)logo {
    [iconImage setHidden:NO];
    [iconImage setImage:logo];
    labelConstaint.constant = 65;
    return self;
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo {
    return [self setWhiteTitle:title selected:selected logoImage:logo withObj:nil];
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:NO];
    [iconImage setImage:logo];
    labelConstaint.constant = 65;
    [subtitleLabel setText:@""];
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    [sideSwitch setOn:selected animated:YES];
    sideSwitch.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];

    return self;
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath {
    return [self setWhiteTitle:title selected:selected imagePath:imagePath withObj:nil];
}

- (CommonTitleWithSwitchCell *)setWhiteTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:NO];
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    [sideSwitch setOn:selected animated:YES];
    [subtitleLabel setText:@""];
    sideSwitch.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];

    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imagePath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [iconImage setImage:image];
        labelConstaint.constant = 65;
    }];
    
    return self;
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected {
    return [self setBlackTitle:title selected:selected withObj:nil];
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected withObj:(id)obj {
    return [self setBlackTitle:title subtitle:nil selected:selected withObj:obj];
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected {
    return [self setBlackTitle:title subtitle:subtitle selected:selected withObj:nil];
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:YES];
    labelConstaint.constant = 15;
    
    if (subtitle && subtitle.length > 0) {
        [subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:YES alpha:YES]];
        labelTopConstaint.constant = 10.0;
    }
    else {
        [subtitleLabel setText:@""];
        labelTopConstaint.constant = 23.0;
    }
    
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    [sideSwitch setOn:selected animated:YES];
    sideSwitch.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    
    
    return self;
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo {
    return [self setBlackTitle:title selected:selected logoImage:logo withObj:nil];
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected logoImage:(UIImage *)logo withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:NO];
    [iconImage setImage:logo];
    labelConstaint.constant = 65;
    [subtitleLabel setText:@""];
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];

    [sideSwitch setOn:selected animated:YES];
    sideSwitch.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    
    return self;
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath {
    return [self setBlackTitle:title selected:selected imagePath:imagePath withObj:nil];
}

- (CommonTitleWithSwitchCell *)setBlackTitle:(NSString *)title selected:(BOOL)selected imagePath:(NSString *)imagePath withObj:(id)obj {
    _switchSelected = selected;
    
    _cellObj = obj;
    [iconImage setHidden:NO];
    [subtitleLabel setText:@""];
    [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    [sideSwitch setOn:selected animated:YES];
    sideSwitch.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    sideSwitch.onTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imagePath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [iconImage setImage:image];
        labelConstaint.constant = 65;
    }];
    
    return self;
}

- (CommonTitleWithSwitchCell *)setTitleStyle:(float)size blackColor:(BOOL)black {
    [titleLabel styleSet:titleLabel.text andFontData:[FontData createFontData:FontTypeDemiBold size:size blackColor:black] upperCase:YES];
    return self;
}

- (void)enableIndent:(BOOL)enable {
    labelConstaint.constant = enable?30:15;
}

- (void)setSwitchSelected:(BOOL)selected {
    _switchSelected = selected;
    [sideSwitch setOn:selected animated:YES];
}

- (BOOL)getSwitchSelected {
    return _switchSelected;
}

- (void)setDelegate:(id<CommonTitleWithSwitchCellDelegate>)delegate {
    _delegate = delegate;
    [self setSwitchSelector];
}

- (void)setSwitchSelector {
    if (sideSwitch) {
        [sideSwitch setUserInteractionEnabled:YES];
        [sideSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)switchValueChanged:(id)sender {
    _switchSelected = [(UISwitch *)sender isOn];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonTitleWithSwitchCell:title:switchControl:changedOnOffState:)]) {
        [self.delegate commonTitleWithSwitchCell:self
                                           title:titleLabel.text
                                   switchControl:sender
                               changedOnOffState:_switchSelected];
    }
}


- (CommonTitleWithSwitchCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setBlackTitle:title subtitle:subtitle selected:selected];
    }
    else {
        return [self setWhiteTitle:title subtitle:subtitle selected:selected];
    }
}

- (CommonTitleWithSwitchCell *)setTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected withObj:(id)obj isBlack:(BOOL)isBlack {
    if (isBlack) {
        return [self setBlackTitle:title subtitle:subtitle selected:selected withObj:obj];
    }
    else {
        return [self setWhiteTitle:title subtitle:subtitle selected:selected withObj:obj];
    }
}

@end
