//
//  FullScreenImageView.m
//  i2app
//
//  Created by Arcus Team on 1/2/16.
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
#import "FullScreenImageView.h"
#import <PureLayout/PureLayout.h>
#import <objc/message.h>


@interface FullScreenImageView()

@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *arcusByArcusLogo;

@property (nonatomic, strong) UIImage *image;

@end

@implementation FullScreenImageView

+ (FullScreenImageView *)createWithImage:(UIImage *)image {
    FullScreenImageView *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    vc.image = image;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *rotatedImage = [[UIImage alloc] initWithCGImage:self.image.CGImage
                                                       scale:0.0
                                                 orientation:UIImageOrientationRight];
    
    [self.mainPhoto setImage:rotatedImage];
    
    self.arcusByArcusLogo.transform = CGAffineTransformMakeRotation(3.14/2);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (IBAction)dismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
