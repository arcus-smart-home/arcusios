//
//  HoneywellC2CStatusViewController.m
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
#import "HoneywellC2CStatusViewController.h"
#import "PairingStep.h"

#import "PlaceCapability.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"

#import "DevicePairingManager.h"
#import "DeviceCapability.h"
#import "PopupSelectionButtonsView.h"
#import "HoneywellC2CViewController.h"
#import <i2app-Swift.h>

@interface HoneywellC2CStatusViewController()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (weak, nonatomic) IBOutlet UILabel *devicesFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *devicePlaceLabel;

- (IBAction)actionButtonPressed:(id)sender;

@end

int kTimerTimeoutTimeSec = 60;

@implementation HoneywellC2CStatusViewController {
    PopupSelectionWindow    *_popupWindow;
}

const NSString *kHoneywellErrorUrl = @"https://mytotalconnectcomfort.com/portal";

+ (instancetype)create {
    HoneywellC2CStatusViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    [[NSNotificationCenter defaultCenter] addObserver:vc selector:@selector(deviceAdded:) name:Constants.kModelAddedNotification object:nil];
    return vc;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.bounds;
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
    
    if (self.isSuccessful) {
        [self.statusLabel styleSet:@"success" andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] upperCase:YES];
        [self.textLabel styleSet:@"Honeywell login succeeded" andFontData:[FontData createFontData:FontTypeDemiBold size:15 blackColor:NO]];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"spinner" ofType:@"gif"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
        
        [self.devicesFoundLabel styleSet:NSLocalizedString(@"Searching for Devices", nil) andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO alpha:YES]];
        [self.devicePlaceLabel styleSet:@"" andFontData:[FontData createFontData:FontTypeDemiBold size:15 blackColor:NO]];
        
        [self.actionButton styleSet:NSLocalizedString(@"I'm Done",  nil).uppercaseString andButtonType:FontDataTypeButtonLight upperCase:YES];
        self.actionButton.hidden = YES;
        
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:110.f/255.f green:137.f/255.f blue:200.f/255.f alpha:1].CGColor,
                                      (__bridge id)[UIColor colorWithRed:77.f/255.f green:71.f/255.f blue:143.f/255.0f alpha:1].CGColor];
    }
    else {
        [self.statusLabel styleSet:@"Oops" andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO space:YES] upperCase:YES];
        
        self.textLabel.text = NSLocalizedString(@"Honeywell login failed", nil);
        self.textLabel.text = [NSString stringWithFormat:@"%@\n%@", self.textLabel.text, kHoneywellErrorUrl];
        [self.actionButton styleSet:NSLocalizedString(@"Return to Dashboard", nil).uppercaseString andButtonType:FontDataTypeButtonLight upperCase:YES];
        
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:224.f/255.f green:24.f/255.f blue:92.f/255.f alpha:1].CGColor,
                                      (__bridge id)[UIColor colorWithRed:153.f/255.f green:34.f/255.f blue:114.f/255.0f alpha:1].CGColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    if (self.isSuccessful) {
        // Start a timer
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kTimerTimeoutTimeSec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil] isKindOfClass:[self class]]) {
                [self actionButtonPressed:self];
            }
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)actionButtonPressed:(id)sender {
    if (self.isSuccessful) {
        if ([DevicePairingManager sharedInstance].justPairedDevices.count == 0) {
            PopupSelectionButtonsView *buttonView =
              [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"No Devices Found", nil).uppercaseString
                                                subtitle:NSLocalizedString(@"Make sure that you're the primary account owner", nil)
                                                  button:[PopupSelectionButtonModel create:NSLocalizedString(@"RETRY", nil) event:@selector(retryPressed)],
                                                         [PopupSelectionButtonModel create:NSLocalizedString(@"CANCEL", nil) event:@selector(cancelPressed)],
                                                          nil];
            buttonView.owner = self;

            _popupWindow = [PopupSelectionWindow popup:self.view
                                               subview:buttonView
                                                 owner:self
                                     displyCloseButton:NO
                                         closeSelector:nil
                                                 style:PopupWindowStyleCautionWindow];
        }
        else {
            [[DevicePairingManager sharedInstance] customizeDevice:self];
        }
    }
    else {
        [[DevicePairingManager sharedInstance] stopPairingProcessAndNotifications];
        [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    }
}

- (void)deviceAdded:(NSNotification *)note {
    if (![note.name isEqualToString:Constants.kModelAddedNotification] ||
        ![note.object isKindOfClass:[DeviceModel class]] ||
        ![((DeviceModel *)note.object) isC2CDevice]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.actionButton.hidden = NO;

        NSString *names;
        for (DeviceModel *deviceModel in [DevicePairingManager sharedInstance].justPairedDevices) {
            NSString *truncatedDeviceName = [DeviceCapability getNameFromModel:deviceModel];
            NSInteger maxCharsNumber = (NSInteger)roundf((self.view.bounds.size.width - 20.0) / 12.0f);
            
            if (truncatedDeviceName.length > maxCharsNumber) {
                truncatedDeviceName =  [[truncatedDeviceName substringToIndex:maxCharsNumber] stringByAppendingString:@"..."];
            }
            
            if (names.length == 0) {
                names = [NSString stringWithFormat:@"%@\n", truncatedDeviceName];
            }
            else {
                names = [NSString stringWithFormat:@"%@%@\n", names, truncatedDeviceName];
            }
        }
        if (names.length > 0) {
            [self.devicesFoundLabel styleSet:NSLocalizedString(@"Devices Found", nil) andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
            [self.devicePlaceLabel styleSet:names andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO]];
        }
    });
}

- (void)retryPressed {
    UIViewController *vc = [self findLastViewController:[HoneywellC2CViewController class]];
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (void)cancelPressed {
    [[DevicePairingManager sharedInstance] stopPairingProcessAndNotifications];
  [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
}
@end
