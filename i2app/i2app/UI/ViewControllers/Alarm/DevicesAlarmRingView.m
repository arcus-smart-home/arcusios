//
//  DevicesAlarmRingView.m
//  i2app
//
//  Created by Arcus Team on 8/20/15.
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
#import "DevicesAlarmRingView.h"
#define kLineWidth 5.0

@implementation DevicesAlarmRingView {
    CAShapeLayer *_circle;
}

- (void)setSegmentModels:(NSArray *)segmentModels {
    _segmentModels = segmentModels;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if ((self.segmentModels == nil) || (self.segmentModels.count == 0)) {
        return;
    }
    
    [self drawArcArray:self.segmentModels];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)drawArcArray:(NSArray *)segments {

    CGFloat arcStartAngle = - (M_PI_2);
    UIColor *aFillColor = [UIColor clearColor];
    [aFillColor setFill];
    
    for (int index = 0; index < segments.count; index++) {
        NSArray *segment = [segments objectAtIndex:index];
        UIColor *arcColor = [segment objectAtIndex:1];
        BOOL glow = NO;
        
        if (segment.count >2) {
            glow = [[segment objectAtIndex:2] boolValue];
        }
        
        NSNumber *percentage = [segment objectAtIndex:0];
        CGFloat arcEndAngle = arcStartAngle + (percentage.floatValue * 2.0f * M_PI);
        
        if (glow) {
            [self drawGlowArc:arcStartAngle endAngle:arcEndAngle strokeColor:arcColor];

        }
        else {
            [self drawArc:arcStartAngle endAngle:arcEndAngle strokeColor:arcColor];
        }
        
        arcStartAngle = arcEndAngle;
    }
}

- (void)drawGlowArc:(CGFloat)startAngle
           endAngle:(CGFloat)endAngle
        strokeColor:(UIColor *)strokeColor {
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.origin.x + self.bounds.size.width/2.0f,
                                                                             self.bounds.origin.y + self.bounds.size.height/2.0f)
                                                          radius:self.frame.size.width/2.0f - 24.0f
                                                      startAngle:startAngle
                                                        endAngle:endAngle
                                                       clockwise:YES];
    [strokeColor setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, circle.CGPath);
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetShadowWithColor(context, CGSizeMake(5.0, 5.0), 20.0, strokeColor.CGColor);
    CGContextStrokePath(context);
    
}

- (void)drawArc:(CGFloat)startAngle
       endAngle:(CGFloat)endAngle
    strokeColor:(UIColor *)strokeColor {
    
    [[UIColor clearColor] setFill];
    [strokeColor setStroke];
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.origin.x + self.bounds.size.width/2.0f,
                                                                             self.bounds.origin.y + self.bounds.size.height/2.0f)
                                                          radius:self.frame.size.width/2.0f - 24.0f
                                                      startAngle:startAngle
                                                        endAngle:endAngle
                                                       clockwise:YES];
    [circle setLineWidth:kLineWidth];
    
    [circle fill];
    [circle stroke];
}

@end
