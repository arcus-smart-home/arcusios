//
//  UIViewController+Keyboard.m
//  i2app
//
//  Created by Arcus Team on 3/21/16.
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
#import "UIViewController+Keyboard.h"
#import <i2app-Swift.h>

@implementation UIViewController (Keyboard)

- (UIToolbar *)initializeKeyboardToolbarWithSelectors:(SEL)doneSelector {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.bounds.size.width, 44.0f)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:doneSelector];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.items = @[flex, rightButton];
    toolbar.tintColor = [UIColor whiteColor];
    
    return toolbar;
}

@end
