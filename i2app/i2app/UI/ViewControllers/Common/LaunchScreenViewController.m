//
//  LaunchScreenViewController.m
//  i2app
//
//  Created by Arcus Team on 10/5/15.
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
#import "LaunchScreenViewController.h"
#import <PureLayout/PureLayout.h>

@implementation LaunchScreenViewController
+ (LaunchScreenViewController *)create {
    LaunchScreenViewController *vc = [[LaunchScreenViewController alloc] init];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash"]];
    [self.view addSubview:imgView];
    [imgView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view];
    [imgView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [imgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [imgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setColor: [UIColor darkGrayColor]];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    [spinner autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [spinner autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-100];
    [spinner setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)hide {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}

@end
