//
//  CareActivityGraphView.m
//  i2app
//
//  Created by Arcus Team on 1/22/16.
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
#import "ActivityGraphView.h"

@interface ActivityGraphView ()

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) double pointsPerUnit;

@end

@implementation ActivityGraphView

#pragma mark - Getters & Setters

- (NSInteger)height {
    return self.bounds.size.height;
}

- (NSInteger)width {
    return self.bounds.size.width;
}

- (double)pointsPerUnit {
    if ([self.activityUnits count] > 0) {
        _pointsPerUnit = ceil((double)self.width / (double)[self.activityUnits count]);
    } else {
        _pointsPerUnit = 0;
    }
    
    return _pointsPerUnit;
}

- (BOOL)graphUnitType:(ActivityGraphUnitType)type containsType:(ActivityGraphUnitType)containsType {
    return (type & containsType) == containsType;
}

#pragma mark - Drawing Methods

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
 
    for (id <ActivityGraphViewUnitProtocol> graphUnit in self.activityUnits) {
        [self drawActivityUnit:graphUnit
                         index:[self.activityUnits indexOfObject:graphUnit]
                       context:context];
    }
}

- (void)drawRect:(CGRect)rect
           color:(UIColor *)color
         context:(CGContextRef)context {
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

- (void)drawActivityUnit:(id <ActivityGraphViewUnitProtocol>)activityUnit
                   index:(NSInteger)index
                 context:(CGContextRef)context {
    
    ActivityGraphUnitType activityType = ActivityGraphUnitTypeNone;
    NSInteger startPoint = (NSInteger)ceil(self.pointsPerUnit * index);
    UIColor *activityColor = [UIColor clearColor];
    
    if ([activityUnit respondsToSelector:@selector(lineColor)]) {
        activityColor = [activityUnit lineColor];
    }
    
    if ([activityUnit respondsToSelector:@selector(activityGraphUnitTypeWithGraphStyle:)]) {
        activityType = [activityUnit activityGraphUnitTypeWithGraphStyle:self.graphStyle];
    }
    
    if (activityType != ActivityGraphUnitTypeNone) {
        if (self.graphStyle == ActivityGraphStyleTypeSolid) {
            if (activityType != ActivityGraphUnitTypeNone) {
                [self drawActivityEventLine:startPoint
                                      width:self.pointsPerUnit
                                      color:activityColor
                                    context:context];
            }
        } else if (self.graphStyle == ActivityGraphStyleTypeSolidNoContinuous) {
            if (activityType != ActivityGraphUnitTypeNone &&
                activityType != ActivityGraphUnitTypeContinuousMid) {
                [self drawActivityEventLine:startPoint
                                      width:self.pointsPerUnit
                                      color:activityColor
                                    context:context];
            }
        } else if (self.graphStyle == ActivityGraphStyleTypeEdgeTransparent) {
            if (activityType != ActivityGraphUnitTypeNone) {
                [self drawActivityEventLineWithTransparentEdges:startPoint
                                                          width:self.pointsPerUnit
                                                          color:activityColor
                                                        context:context];
            }
        }

    }
}

- (void)drawActivityEventLine:(NSInteger)startPosition
                        width:(NSInteger)width
                        color:(UIColor *)color
                      context:(CGContextRef)context {
    // Draw Solid Line
    [self drawRect:CGRectMake(startPosition,
                              0,
                              width,
                              self.height)
             color:color
           context:context];
    
}

- (void)drawActivityEventLineWithTransparentEdges:(NSInteger)startPosition
                                            width:(NSInteger)width
                                            color:(UIColor *)color
                                          context:(CGContextRef)context {
    // Draw 3-dashed Line
    [self drawRect:CGRectMake(startPosition,
                              0,
                              width,
                              self.height * 0.333f)
             color:[color colorWithAlphaComponent:0.6f]
           context:context];
    
    [self drawRect:CGRectMake(startPosition,
                              self.height * 0.333f,
                              width,
                              self.height * 0.333f)
             color:color
           context:context];
    
    [self drawRect:CGRectMake(startPosition,
                              self.height * 0.666f,
                              width,
                              self.height * 0.333f)
             color:[color colorWithAlphaComponent:0.6f]
           context:context];
}

@end
