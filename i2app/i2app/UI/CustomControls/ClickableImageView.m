//
//  ClickableImageView.m
//  i2app
//
//  Created by Arcus Team on 12/10/15.
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
#import "ClickableImageView.h"

@interface ClickableImageView()

@property (strong, nonatomic) id obj;
@property (weak, nonatomic) id owner;
@property (assign, nonatomic) SEL selector;

@end

@implementation ClickableImageView


- (void)setOnClick:(id)owner selector:(SEL)selector obj:(id)obj {
    self.owner = owner;
    self.selector = selector;
    self.obj = obj;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.owner && self.selector && [self.owner respondsToSelector:self.selector]) {
        [self.owner performSelector:self.selector withObject:self.obj afterDelay:0];
    }
}


@end
