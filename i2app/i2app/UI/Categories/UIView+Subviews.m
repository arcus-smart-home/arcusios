//
//  UIView+Subviews.m
//  i2app
//
//  Created by Arcus Team on 4/5/15.
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
#import "UIView+Subviews.h"

@implementation UIView (Subviews)

+ (void)executeBlock:(UIViewTreeBlock)block forViewAndSubviewTree:(UIView *)view {
    if (block) {
        block(view);
    }
    for (UIView *subview in view.subviews) {
        [UIView executeBlock:block forViewAndSubviewTree:subview];
    }
}



- (void)removeAllSubviews {
    NSArray *views = [self subviews];
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    if ([self.nextResponder isKindOfClass:UIViewController.class]) {
        return (UIViewController *)self.nextResponder;
    }
    return nil;
}

- (UIView *)getSubviewByTag:(NSInteger)tag {
    NSArray *views = [self subviews];
    for (UIView *view in views) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

- (NSArray *)getSubviewsExcludeTag:(NSInteger)tag {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *view in [self subviews]) {
        if (view.tag != tag) {
            [views addObject:view];
        }
    }
    
    return views;
}

- (NSArray *)allSubviews {
    __block NSArray *allSubviews = [NSArray arrayWithObject:self];
    
    [self.subviews enumerateObjectsUsingBlock:^( UIView *view, NSUInteger idx, BOOL *stop) {
        allSubviews = [allSubviews arrayByAddingObjectsFromArray:[view allSubviews]];
    }];
    return allSubviews;
}

- (UIViewController *)getParentViewController {
    // get to the parent UIViewController
    id nextResponder = [self.superview nextResponder];
    while (nextResponder && ![nextResponder isKindOfClass:[UIViewController class]])
    {
        nextResponder = [nextResponder nextResponder];
    }
    return nextResponder;
}

@end
