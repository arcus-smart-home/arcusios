//
//  RingTextContentsView.m
//  i2app
//
//  Created by Arcus Team on 1/27/16.
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
#import "RingTextContentsView.h"

@implementation RingTextContentsView {
    UILabel *mainTextLabel;
    UILabel *deviceCountLabel;
}

#pragma mark - Setters
- (void)setMainText:(NSString *)mainText {
    _mainText = mainText;
    [mainTextLabel setText:mainText];
    [self setNeedsLayout];
}

- (void)setNumberOfActiveDevices:(NSNumber *)numberOfActiveDevices {
    _numberOfActiveDevices = numberOfActiveDevices;
    [self setNeedsLayout];
}

- (void)setTotalNumberOfDevices:(NSNumber *)totalNumberOfDevices {
    _totalNumberOfDevices = totalNumberOfDevices;
    [self setNeedsLayout];
}

- (void)setContentsStyle:(RingTextContentsStyle)contentsStyle {
    _contentsStyle = contentsStyle;
    [self setNeedsLayout];
}

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit {
    mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.7, 20)];
    deviceCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    mainTextLabel.numberOfLines = 0;
    mainTextLabel.textAlignment = NSTextAlignmentCenter;
    deviceCountLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:mainTextLabel];
    [self addSubview:deviceCountLabel];
}

#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
    FontData *fontForMainText;
    CGPoint mainCenter;
    BOOL shouldCenterMainTextLabel = NO;
    
    switch (self.contentsStyle) {
        case RingTextContentsStyleSmallTextOnly:
            fontForMainText = [FontData createFontData:FontTypeDemiBold size:12 blackColor:NO alpha:YES];
            shouldCenterMainTextLabel = YES;
            [deviceCountLabel setHidden:YES];
            break;
            
        case RingTextContentsStyleLargeTextOnly:
            fontForMainText = [FontData createFontData:FontTypeUltraLight size:64 blackColor:NO alpha:NO];
            shouldCenterMainTextLabel = YES;
            [deviceCountLabel setHidden:YES];
            break;
            
        case RingTextContentsStyleTextAndTotal:
            fontForMainText = [FontData createFontData:FontTypeDemiBold size:12 blackColor:NO alpha:YES];
            [deviceCountLabel styleSet:[self.totalNumberOfDevices stringValue] andButtonType:FontDataType_UltraLight_60_White];
            [deviceCountLabel sizeToFit];
            
            [deviceCountLabel setHidden:NO];
            break;
            
        case RingTextContentsStyleTextAndFractional:
            fontForMainText = [FontData createFontData:FontTypeDemiBold size:12 blackColor:NO alpha:YES];
            NSString *deviceCountText = [NSString stringWithFormat:@"/%d", [self.totalNumberOfDevices intValue]];
            [deviceCountLabel setAttributedText:[FontData getString:[self.numberOfActiveDevices stringValue] andString2:deviceCountText withCombineFont:FontDataCombineTypeAlarmText]];
            [deviceCountLabel sizeToFit];
            
            [deviceCountLabel setHidden:NO];
            break;
    }
    
    
    //Reset max dimensions of labels, then size to fit
    [mainTextLabel styleSet:self.mainText andFontData:fontForMainText];
    mainTextLabel.frame = CGRectMake(0, 0, self.bounds.size.width * 0.9, self.bounds.size.height * 0.5);
    deviceCountLabel.frame = CGRectMake(0, 0, self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [mainTextLabel sizeToFit];
    if (shouldCenterMainTextLabel) {
        mainCenter = [self convertPoint:self.center fromView:self.superview];
    } else {
        mainCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - mainTextLabel.bounds.size.height/2 - 15);
    }
    
    CGPoint deviceCountCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + deviceCountLabel.bounds.size.height/2 - 10);
    mainTextLabel.center = mainCenter;
    deviceCountLabel.center = deviceCountCenter;
}

@end
