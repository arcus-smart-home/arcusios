//
//  UIView+Animation.m
//  i2app
//
//  Created by Arcus Team on 9/15/15.
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
#import "UIView+Animation.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#define kRubberBandNormalSize 1.00
#define kRubberBandExpandedSize 1.20
#define kRubberBandAnimationStep .05

#define kAnimationDuration 0.3f
#define ringTag 1233211234567

@implementation UIView (Animation)

static char _rubberbandCircleView;
static char _rubberBandAnimationIsExpanded;
static char _lightAnimationIsShining;

- (BOOL) getRubberBandStatus {
    id rubberbandStatus = objc_getAssociatedObject(self, &_rubberBandAnimationIsExpanded);
    return ([rubberbandStatus boolValue]);
}
- (void) setRubberBandStatus:(BOOL)status {
    objc_setAssociatedObject(self, &_rubberBandAnimationIsExpanded,@(status), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL) getShiningStatus {
    id rubberbandStatus = objc_getAssociatedObject(self, &_lightAnimationIsShining);
    return ([rubberbandStatus boolValue]);
}
- (void) setShiningStatus:(BOOL)status {
    objc_setAssociatedObject(self, &_lightAnimationIsShining,@(status), OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void) animateRubberBandExpand:(void (^)(void))block {
    [self animateRubberBandExpand:block circleBroad:4.0f alpha:.5f];
}
- (void) animateRubberBandExpand:(void (^)(void))block circleBroad:(CGFloat)board alpha:(CGFloat)alpha {
    if ([self getRubberBandStatus]) {
        if (block) {
            block();
        }
        return;
    }
    [self setRubberBandStatus:YES];
    
    UIView *_circleRing = [self setRubberBandExpandedWithBoard:board alpha:alpha expended:NO];
    
    __block CGFloat scale;
    
    [UIView animateWithDuration:0.3 animations:^{
        scale = kRubberBandExpandedSize;
        [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            scale = kRubberBandExpandedSize - kRubberBandAnimationStep;
            [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                scale = kRubberBandExpandedSize;
                [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
            } completion:^(BOOL finished) {
                if (block) {
                    block();
                }
            }];
        }];
    }];
}

- (UIView *) setRubberBandExpanded {
    return [self setRubberBandExpandedWithBoard:3.0f alpha:1.0f expended:YES];
}
- (UIView *) setRubberBandExpandedWithBoard:(CGFloat)board alpha:(CGFloat)alpha expended:(BOOL)status {
    
    @synchronized(self) {
        [self setRubberBandStatus:YES];
        
        for (UIView *item in self.subviews) {
            if ([item isKindOfClass:[UIView class]] && (item.tag == ringTag)) {
                [item removeFromSuperview];
            }
        }
        
        self.layer.borderWidth = 0.0f;
        
        UIView *_circleRing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)];
        _circleRing.tag = ringTag;
        [_circleRing.layer setCornerRadius:_circleRing.frame.size.width / 2];
        [_circleRing setBackgroundColor:[UIColor clearColor]];
        [self insertSubview:_circleRing atIndex:0];
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.height, self.frame.size.width)] CGPath]];
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        circleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:alpha].CGColor;
        circleLayer.lineWidth = board;
        [_circleRing.layer addSublayer:circleLayer];
        
        objc_setAssociatedObject(self, &_rubberbandCircleView,_circleRing, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (status) {
            [_circleRing setTransform:CGAffineTransformMakeScale(kRubberBandExpandedSize, kRubberBandExpandedSize)];
        }
        
        return _circleRing;
    }
}

- (void) animateRubberBandContract:(void (^)(void))block {
    @synchronized(self) {
        UIView *_circleRing = objc_getAssociatedObject(self, &_rubberbandCircleView);
        if (![self getRubberBandStatus]) {
            if (!_circleRing) {
                return;
            }
            for (UIView *item in self.subviews) {
                if ([item isKindOfClass:[UIView class]] && (item.tag == ringTag) && item != _circleRing) {
                    [item removeFromSuperview];
                }
            }
            if (block) {
                block();
            }
            return;
        }
        [self setRubberBandStatus:NO];
        


        
        __block CGFloat scale;
        scale = kRubberBandExpandedSize;
        [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
        
        scale = kRubberBandNormalSize;
        [UIView animateWithDuration:0.3 animations:^{
            
            [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                
                scale = kRubberBandNormalSize - kRubberBandAnimationStep;
                [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    
                    scale = kRubberBandNormalSize;
                    [_circleRing setTransform:CGAffineTransformMakeScale(scale, scale)];
                    
                } completion:^(BOOL finished) {
                    [_circleRing removeFromSuperview];
                    objc_removeAssociatedObjects(self);
                    if (block) {
                        block();
                    }
                }];
            }];
        }];
    }
}

- (void) animateStartShining:(void (^)(void))block withBoarderWidth:(CGFloat)boarder {
    if ([self getShiningStatus]) {
        if (block) {
            block();
        }
        return;
    }
    [self setShiningStatus:YES];

    CGFloat finalBorderWidth = boarder;
    
    CGFloat ringBroad = self.bounds.size.width / 6.0f;
    CGRect newBounds = CGRectMake(self.bounds.origin.x - ringBroad, self.bounds.origin.y - ringBroad, self.bounds.size.width + ringBroad, self.bounds.size.height + ringBroad);
    
    self.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 15.0f;
    self.layer.shadowOpacity = 0.0f;
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            self.layer.borderWidth = boarder;
            if (block) {
                block();
            }
        }];
        
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.beginTime = 0.0f;
        cornerRadiusAnimation.duration = kAnimationDuration;
        cornerRadiusAnimation.toValue = [NSNumber numberWithFloat:(self.bounds.size.width + ringBroad) / 2.0f];
        cornerRadiusAnimation.removedOnCompletion = NO;
        cornerRadiusAnimation.fillMode = kCAFillModeBoth;
        cornerRadiusAnimation.additive = NO;
        [self.layer addAnimation:cornerRadiusAnimation forKey:@"cornerRadiusAnimation"];
        
        CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderColorAnimation.beginTime = 0.0f;
        borderColorAnimation.duration = kAnimationDuration;
        borderColorAnimation.toValue = (id)[UIColor whiteColor].CGColor;
        borderColorAnimation.removedOnCompletion = NO;
        borderColorAnimation.fillMode = kCAFillModeBoth;
        borderColorAnimation.additive = NO;
        [self.layer addAnimation:borderColorAnimation forKey:@"borderColorAnimation"];
        
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.beginTime = 0.0f;
        boundsAnimation.duration = kAnimationDuration;
        boundsAnimation.fromValue = [NSValue valueWithCGRect:self.bounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:newBounds];
        boundsAnimation.removedOnCompletion = NO;
        boundsAnimation.fillMode = kCAFillModeBoth;
        boundsAnimation.additive = NO;
        [self.layer addAnimation:boundsAnimation forKey:@"boundsAnimation"];
        
        CABasicAnimation *borderWidthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        borderWidthAnimation.beginTime = 0.0f;
        borderWidthAnimation.duration = kAnimationDuration;
        borderWidthAnimation.toValue = [NSNumber numberWithFloat:finalBorderWidth];
        borderWidthAnimation.removedOnCompletion = NO;
        borderWidthAnimation.fillMode = kCAFillModeBoth;
        borderWidthAnimation.additive = NO;
        [self.layer addAnimation:borderWidthAnimation forKey:@"borderWidthAnimation"];
        
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowOpacityAnimation.beginTime = 0.0f;
        shadowOpacityAnimation.duration = kAnimationDuration;
        shadowOpacityAnimation.fromValue = @(0.0f);
        shadowOpacityAnimation.toValue = @(0.9f);
        shadowOpacityAnimation.removedOnCompletion = NO;
        shadowOpacityAnimation.fillMode = kCAFillModeBoth;
        shadowOpacityAnimation.additive = NO;
        shadowOpacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacityAnimation"];
        
    } [CATransaction commit];
}
- (void) animateStopShining:(void (^)(void))block withBoarderWidth:(CGFloat)boarder {
    if (![self getShiningStatus]) {
        if (block) {
            block();
        }
        return;
    }
    [self setShiningStatus:NO];
    
    CGFloat ringBroad = self.bounds.size.width / 6.0f;
    CGRect oiginalBounds = CGRectMake(self.bounds.origin.x - ringBroad, self.bounds.origin.y - ringBroad, self.bounds.size.width + ringBroad, self.bounds.size.height + ringBroad);
    
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:^{
            self.layer.borderWidth = boarder;
            if (block) {
                block();
            }
        }];
        
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.beginTime = 0.0f;
        cornerRadiusAnimation.duration = kAnimationDuration;
        cornerRadiusAnimation.fromValue = [NSNumber numberWithFloat:(190 + 25.0f) / 2.0f];
        cornerRadiusAnimation.toValue = [NSNumber numberWithFloat:190 / 2.0f];
        cornerRadiusAnimation.removedOnCompletion = NO;
        cornerRadiusAnimation.fillMode = kCAFillModeBoth;
        cornerRadiusAnimation.additive = NO;
        [self.layer addAnimation:cornerRadiusAnimation forKey:@"cornerRadiusAnimation"];
        
        CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderColorAnimation.beginTime = 0.0f;
        borderColorAnimation.duration = kAnimationDuration;
        borderColorAnimation.fromValue = (id)[UIColor whiteColor].CGColor;
        borderColorAnimation.toValue = (id)[[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
        borderColorAnimation.removedOnCompletion = NO;
        borderColorAnimation.fillMode = kCAFillModeBoth;
        borderColorAnimation.additive = NO;
        [self.layer addAnimation:borderColorAnimation forKey:@"borderColorAnimation"];
        
        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.beginTime = 0.0f;
        boundsAnimation.duration = kAnimationDuration;
        boundsAnimation.fromValue = [NSValue valueWithCGRect:oiginalBounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:self.bounds];
        boundsAnimation.removedOnCompletion = NO;
        boundsAnimation.fillMode = kCAFillModeBoth;
        boundsAnimation.additive = NO;
        [self.layer addAnimation:boundsAnimation forKey:@"boundsAnimation"];
        
        CABasicAnimation *borderWidthAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        borderWidthAnimation.beginTime = 0.0f;
        borderWidthAnimation.duration = kAnimationDuration;
        borderWidthAnimation.toValue = [NSNumber numberWithFloat:boarder];
        borderWidthAnimation.removedOnCompletion = NO;
        borderWidthAnimation.fillMode = kCAFillModeBoth;
        borderWidthAnimation.additive = NO;
        [self.layer addAnimation:borderWidthAnimation forKey:@"borderWidthAnimation"];
        
        // Hide the shadow
        CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        shadowOpacityAnimation.beginTime = 0.0f;
        shadowOpacityAnimation.duration = kAnimationDuration;
        shadowOpacityAnimation.toValue = @(0.0f);
        shadowOpacityAnimation.removedOnCompletion = NO;
        shadowOpacityAnimation.fillMode = kCAFillModeBoth;
        shadowOpacityAnimation.additive = NO;
        [self.layer addAnimation:shadowOpacityAnimation forKey:@"shadowOpacityAnimation"];
    }
    [CATransaction commit];
}

- (CAShapeLayer *)createCircleFrame:(UIColor *)color {
    CAShapeLayer *rectShape = [[CAShapeLayer alloc] init];
    CGRect bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);

    rectShape.frame = bounds;
    rectShape.cornerRadius = self.frame.size.width / 2.0 + 4.0f;

    rectShape.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f)
                                                    radius:self.frame.size.width / 2.0f + 4.0f
                                                startAngle: (3.0f / 4.0f) / (2.0f * M_PI) + M_PI_2
                                                  endAngle: M_PI_2
                                                 clockwise:YES].CGPath;
    rectShape.lineWidth = 3.0;
    rectShape.strokeColor = color.CGColor;
    rectShape.fillColor = [UIColor clearColor].CGColor;

    rectShape.strokeStart = aDimmerCirclePoint(0.0);
    rectShape.strokeEnd = aDimmerCirclePoint(1.0);

    rectShape.shadowOffset = CGSizeMake(0, 0);
    rectShape.shadowColor = [UIColor whiteColor].CGColor;
    rectShape.shadowOpacity = 1.0f;
    rectShape.shadowRadius = 4.0f;

    return rectShape;
}

@end
