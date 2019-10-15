//
//  SearchHubViewController.m
//  i2app
//
//  Created by Arcus Team on 5/4/15.
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
#import "SearchHubViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "PlaceCapability.h"

#import "DevicePairingWizard.h"


@interface SearchHubViewController ()

@end

@implementation SearchHubViewController {
    __weak IBOutlet UILabel *hubSearchingLabel;
    NSString    *_hubId;
    BOOL        _retryPairingHub;
}

const int kRegisterHubRetrySec = 5;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Pairing Hub", nil)];
    
    // Check every second for a hub to be registered
    _retryPairingHub = YES;
    [self scheduleLoopInSeconds:kRegisterHubRetrySec];
    
    _hubId = [[DevicePairingManager sharedInstance].pairingWizard.parameters[@"HubID"] uppercaseString];
    hubSearchingLabel.text = [NSLocalizedString(@"Searching for Hub with\nID ", nil) stringByAppendingString:_hubId];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAdded:) name:Constants.kModelAddedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _retryPairingHub = NO;
}

- (void)scheduleLoopInSeconds:(NSTimeInterval)delayInSeconds {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_retryPairingHub) {
            [self registerHub];
        }
    });
}

- (void)playSound {
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"108" ofType:@"wav"]] error:NULL];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}

- (void)registerHub {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [PlaceCapability registerHubWithHubId:_hubId onModel:[[CorneaHolder shared] settings].currentPlace].catch(^(NSError *error) {
            if (![error.userInfo[@"code"] isEqualToString:@"error.register.alreadyregistered"]) {
                [self scheduleLoopInSeconds:kRegisterHubRetrySec];
            }
            else {
                [self displayMessage:NSLocalizedString(@"Invalid Hub ID", nil) subtitle:NSLocalizedString(@"Ensure your hub ID is correct and try again.", nil) buttonOne:NSLocalizedString(@"try again", nil)  buttonTwo:NSLocalizedString(@"contact support", nil) withTarget:self withButtonOneSelector:@selector(dismiss) andButtonTwoSelector:@selector(callSupport)];
            }
        });
    });
}

- (void)deviceAdded:(NSNotification *)note {
    if (![note.name isEqualToString:Constants.kModelAddedNotification] ||
        ![note.object isKindOfClass:[HubModel class]]) {
        return;
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(playSound) withObject:nil afterDelay:0.0f];
        [super nextButtonPressed:self];
    });
}

- (void)dismiss {
    [self slideOutTwoButtonAlert];
    [[DevicePairingManager sharedInstance].pairingWizard backToPreviousPage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)callSupport {
    NSString *URLString = [@"tel://" stringByAppendingString:NSLocalizedString(@"Customer support phone", nil)];
    NSURL *URL = [NSURL URLWithString:URLString];
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    [self slideOutTwoButtonAlert];
    [[DevicePairingManager sharedInstance].pairingWizard backToPreviousPage];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
