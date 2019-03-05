//
//  BaseDeviceStepViewController.m
//  i2app
//
//  Created by Arcus Team on 4/30/15.
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
#import "BaseDeviceStepViewController.h"
#import "UIImageView+WebCache.h"
#import "DevicePairingWizard.h"
#import "PairingStep.h"
#import <i2app-Swift.h>

@interface BaseDeviceStepViewController ()

@property (weak, nonatomic) UILabel *stepNumber;
@property (weak, nonatomic) IBOutlet UILabel *mainStepLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryStepLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numberButton;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic) UIWebView *videoView;


- (IBAction)videoButtonPressed:(id)sender;

@end;

//
@implementation BaseDeviceStepViewController {
    
    __weak IBOutlet NSLayoutConstraint *topToImageConstraint;
    __weak IBOutlet NSLayoutConstraint *imageToNumberConstraint;
    __weak IBOutlet NSLayoutConstraint *mainTextToSubTextConstraint;
}

#pragma mark - Life Cycle
/*
 * Used to initialize all control IBOutlets and IBActions
 */
- (void)initializeTemplateViewController {
    [super initializeTemplateViewController];
    
    self.tutorialView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    if ([self.step isKindOfClass:[PairingStep class]]) {
 
        self.numberButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"Step%ld", (long)self.step.stepIndex + 1]];
        
        // Hub images are in the app bundle
        if ([self.step.imageUrl containsString:@"http"]) {
            [self.mainImage sd_setImageWithURL:[NSURL URLWithString:self.step.imageUrl]];
        }
        else {
            self.mainImage.image = [UIImage imageNamed:self.step.imageUrl];
        }

        self.mainStepLabel.text = self.step.mainStep;
        self.secondaryStepLabel.text = self.step.secondStep;
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];
    }

    [self refreshVideo];
    
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    if (IS_IPHONE_5) {
        imageToNumberConstraint.constant = 14;
        topToImageConstraint.constant = 14;
        mainTextToSubTextConstraint.constant = -10;
    }
}

- (void)refreshVideo {
    [self.tutorialView setHidden:!([DevicePairingManager sharedInstance].pairingWizard.videoURL &&
                                   [DevicePairingManager sharedInstance].pairingWizard.videoURL.length > 0)];
}

- (void)exitedFullScreen:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoView removeFromSuperview];
    });
}

- (IBAction)videoButtonPressed:(id)sender {
    [self playVideoWithId:[DevicePairingManager sharedInstance].pairingWizard.videoID];
}

- (void)playVideoWithId:(NSString *)videoId {
    
    NSString *youTubeVideoHTML = [NSString stringWithFormat:@"<html><head><style>body{margin:0px 0px 0px 0px;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:'%f', height:'%f', videoId:'%@', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>",((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.frame.size.width, ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.frame.size.height, videoId];
    
    self.videoView = [[UIWebView alloc] initWithFrame:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.frame];
    CGRect frame = self.videoView.frame;
    frame.origin.y = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.frame.origin.y + 20;
    self.videoView.frame = frame;
    self.videoView.backgroundColor = [UIColor clearColor];
    self.videoView.opaque = NO;
    [self.view addSubview:self.videoView];
    
    self.videoView.mediaPlaybackRequiresUserAction = NO;
    
    [self.videoView loadHTMLString:youTubeVideoHTML baseURL:[[NSBundle mainBundle] resourceURL]];
}

@end
