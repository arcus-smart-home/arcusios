//
//  CareAlarmBaseViewControllerCell.m
//  i2app
//
//  Created by Arcus Team on 2/1/16.
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
#import "CareAlarmBaseViewControllerCell.h"

#import <PureLayout/PureLayout.h>
#import "DevicesAlarmRingView.h"

#import "SDWebImageManager.h"
#import "ImagePaths.h"
#import "UIImage+ImageEffects.h"

#import "ImageDownloader.h"
#import "DeviceCapability.h"

@implementation CareAlarmBaseViewControllerCell {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    
    NSArray *_logoImages;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (title) {
        [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_13_White];
    }
    if (subtitle) {
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    }
    else {
        [subtitleLabel setText:@""];
    }
    
    if (_logoImages && _logoImages.count > 1) {
        [titleLabel setHidden:YES];
        [subtitleLabel setHidden:YES];
    }
}

- (void)setLogo:(UIImage *)logo {
    for (UIView *view in _iconScroller.subviews) {
        [view removeFromSuperview];
    }
    _logoImages = nil;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:logo];
    [_iconScroller addSubview:image];
    [image autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [image autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_iconScroller withOffset:1];
    [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconScroller];
    _iconScroller.contentSize = CGSizeMake(_logoImages.count * 50, 50);
    
    self.iconScroller.userInteractionEnabled = NO;
}

- (void)setLogos:(NSArray *)logos {
    for (UIView *view in _iconScroller.subviews) {
        [view removeFromSuperview];
    }
    _logoImages = logos;
    
    [titleLabel setHidden:YES];
    [subtitleLabel setHidden:YES];
    
    // Only display first 5
    UIImageView *lastItem = nil;
    for (int i=0; i<(_logoImages.count>5?5:_logoImages.count); i++) {
        UIImage *logo = _logoImages[i];
        UIImageView *image = [[UIImageView alloc] initWithImage:logo];
        image.layer.cornerRadius = 25.0f;
        image.layer.masksToBounds = YES;
        image.userInteractionEnabled = NO;
        [_iconScroller addSubview:image];
        [image autoSetDimensionsToSize:CGSizeMake(50, 50)];
        [image autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_iconScroller withOffset:1];
        if (lastItem) {
            [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastItem withOffset:10.0f];
        }
        else {
            [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconScroller];
        }
        lastItem = image;
    }
    
    _iconScroller.contentSize = CGSizeMake(_logoImages.count * 60, 50);
    self.iconScroller.userInteractionEnabled = NO;
}

@end
