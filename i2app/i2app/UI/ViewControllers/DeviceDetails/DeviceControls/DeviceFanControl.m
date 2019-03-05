//
//  DeviceFanControl.m
//  i2app
//
//  Created by Arcus Team on 6/10/15.
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
#import "DeviceFanControl.h"
#import "UIImage+ScaleSize.h"
#import "FanOperationViewController.h"

@implementation DeviceFanControl {
    UIImage *_lineImage;
    FanOperationViewController *_fanController;
}


- (void)setImage:(UIImage *)image {
    _lineImage = image;
    
    [super setImage:nil];
}

- (void)setStep:(NSInteger)step {
    if (step <= 0) {
        [super setImage:nil];
    }
    else if (step >= self.maximumStep) {
        [super setImage:_lineImage];
    }
    else {
        if (self.maximumStep == 0) {
            [super setImage:[_lineImage cutImage:CGRectMake(0, 0, 0, 10)]];
        }
        else {
            [super setImage:[_lineImage cutImage:CGRectMake(0, 0, (_lineImage.size.width / self.maximumStep) * step, 10)]];
        }
    }
}

- (void)setFanController:(FanOperationViewController *)controller {
    _fanController = controller;
}

- (void)setProcess:(NSInteger)value {
    [super setImage:[UIImage image:@"DeviceFanSteps" withCut:CGRectMake(0, 0, value, 10)]];
}

- (void)touchDone:(int)xPos {
    double stepSize = (_lineImage.size.width / self.maximumStep);
    if (xPos <= stepSize / 2) {
        [_fanController selectStep:0];
    }
    else if (xPos >= (stepSize * (self.maximumStep - 1)) + (stepSize / 2)) {
        [_fanController selectStep:(int)self.maximumStep];
    }
    else {
        [_fanController selectStep: ((int)((xPos - (stepSize / 2)) / stepSize) + 1)];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    
    [_fanController parentSwipe:YES];
    if (!_fanController) return;
    
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    int xPos = tappedPt.x;
    [self touchDone:xPos];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_fanController parentSwipe:NO];
    
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    int xPos = tappedPt.x;
    
    [super setImage:[UIImage image:@"DeviceFanSteps" withCut:CGRectMake(0, 0, xPos, 10)]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    int xPos = tappedPt.x;
    
    [self setStep:xPos];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    [_fanController parentSwipe:YES];
    if (!_fanController) return;
    
    CGPoint tappedPt = [[touches anyObject] locationInView: self];
    int xPos = tappedPt.x;
    [self touchDone:xPos];
}

@end
