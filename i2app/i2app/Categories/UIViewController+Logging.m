//
//  UIViewController+Logging.m
//  i2app
//
//  Arcus Team on 11/30/16.
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
#import "UIViewController+Logging.h"
#import <objc/runtime.h>

@implementation UIViewController (Logging)

-(void)logging_viewDidAppear:(BOOL)animated
{
    DDLogDebug(@"View controller: %@", NSStringFromClass(self.class));
    [self logging_viewDidAppear:animated];
}

+ (void)load
{
    Method original, swizzled;
    
    original = class_getInstanceMethod(self, @selector(viewDidAppear:));
    swizzled = class_getInstanceMethod(self, @selector(logging_viewDidAppear:));
    
    method_exchangeImplementations(original, swizzled);
}

@end
