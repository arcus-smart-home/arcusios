//
//  UIViewController+Gif.m
//  i2app
//
//  Created by Arcus Team on 9/2/15.
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
#import "UIViewController+Gif.h"
#import <PureLayout/PureLayout.h>

#import <objc/runtime.h>

@implementation UIViewController (Gif)


static char _aControllerLoadingGif;
static char _aControllerLoadingBackgroup;

- (void)createGif {
    [self createGifWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)createGifWithStyle:(UIActivityIndicatorViewStyle) style {

    UIActivityIndicatorView *spinner = objc_getAssociatedObject(self, &_aControllerLoadingGif);
    UIView *backgroup = objc_getAssociatedObject(self, &_aControllerLoadingBackgroup);
    
    if (spinner && backgroup && spinner.alpha != 0.0f && backgroup.alpha != 0.0f) {
        return;
    }
    
    backgroup = [[UIView alloc] initForAutoLayout];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    
    [self.view addSubview:spinner];
    [spinner autoCenterInSuperview];
    [spinner startAnimating];

    objc_setAssociatedObject(self, &_aControllerLoadingGif, spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [backgroup setBackgroundColor:[UIColor blackColor]];
    [backgroup setAlpha:0.0f];
    [self.view addSubview:backgroup];
    [backgroup autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [backgroup autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [backgroup autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [backgroup autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    objc_setAssociatedObject(self, &_aControllerLoadingBackgroup, backgroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        spinner.alpha = 1.0f;
        backgroup.alpha = 0.2f;
    }];
}

- (void)hideGif {
    UIActivityIndicatorView *spinner = objc_getAssociatedObject(self, &_aControllerLoadingGif);
    UIView *backgroup = objc_getAssociatedObject(self, &_aControllerLoadingBackgroup);
    
    if (spinner && [spinner isKindOfClass:[UIActivityIndicatorView class]] && spinner.alpha > 0.0f && backgroup.alpha > 0.0f) {
        [spinner setHidden:YES];
        [UIView animateWithDuration:0.3f animations:^{
            spinner.alpha = .0f;
            backgroup.alpha = .0f;
        } completion:^(BOOL finished) {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            [backgroup removeFromSuperview];
            
            objc_removeAssociatedObjects(spinner);
            objc_removeAssociatedObjects(backgroup);
        }];
    }
}



@end

