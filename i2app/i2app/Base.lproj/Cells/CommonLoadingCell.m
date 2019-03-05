//
//  LoadingTableViewCell.m
//  i2app
//
//  Created by Arcus Team on 12/1/15.
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
#import "CommonLoadingCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "UIImage+ImageEffects.h"

@implementation CommonLoadingCell {


    __weak IBOutlet UIProgressView *progressBar;
    __weak IBOutlet UIImageView *loadingCheckMark;
    __weak IBOutlet UILabel *deviceSubTitle;
    __weak IBOutlet UILabel *deviceTitle;
    __weak IBOutlet UIImageView *deviceImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

+ (CommonLoadingCell *)create:(UITableView *)tableview {
    CommonLoadingCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    return cell;
}

- (void)setIconPath:(NSString *)iconPath withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:iconPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        image = [image invertColor];
        [deviceImage setImage:image];
    }];
    
    [self setBlackTitle:title subTitle:subtitle];
}

- (void)setBlackTitle:(NSString *)title subTitle:(NSString *)subtitle {
    [deviceTitle styleSet:title andButtonType:FontDataType_DemiBold_14_Black];
    if (subtitle && subtitle.length > 0) {
        [deviceSubTitle styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:YES alpha:YES]];
    }
    else {
        [deviceSubTitle setText:@""];
    }

    [loadingCheckMark setImage:[UIImage imageNamed:@"checkedMark"]];

}


- (void)setIcon:(UIImage *)icon withBlackTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (icon) {
        [deviceImage setImage:icon];
    }
    else {
        [deviceImage setImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]];
    }
    
    [self setBlackTitle:title subTitle:subtitle];

}

- (void)setIcon:(UIImage *)icon {
    [deviceImage setImage:icon];
}

- (void)displayCheckMark:(BOOL)display {
    loadingCheckMark.hidden = !display;
}

- (void)setProgressValue:(float)progress {
    [progressBar setProgress:progress animated:YES];
}


@end
