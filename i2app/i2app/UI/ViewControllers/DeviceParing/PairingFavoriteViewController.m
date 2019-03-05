//
//  PairingFavoriteViewController.m
//  i2app
//
//  Created by Arcus Team on 9/30/15.
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
#import "PairingFavoriteViewController.h"
#import "Checkbox.h"
#import "FavoriteController.h"
#import "DevicePairingManager.h"

@interface PairingFavoriteViewController() 
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet Checkbox *checkboxButton;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)checkboxButtonPressed:(id)sender;

@end

@implementation PairingFavoriteViewController

+ (instancetype)createWithDeviceStep:(PairingStep *)step device:(DeviceModel*)deviceModel {
    PairingFavoriteViewController *vc = [self createWithDeviceStep:step];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToParentColor];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Add to favorites", nil)];

    self.mainLabel.text = NSLocalizedString(@"Do you want to add this\ndevice to Favorites?", nil);
    self.secondaryLabel.text = NSLocalizedString(@"Gain fast access to your Favorite\ndevices at the top of your Dashboard", nil);
    self.favoritesLabel.text = NSLocalizedString(@"Add this device to Favorites", nil);
    
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [FavoriteController addTag:kFavoriteTag onModel:self.deviceModel];
    });
    self.checkboxButton.isChecked = YES;
}

- (IBAction)nextButtonPressed:(id)sender {
    [super nextButtonPressed:sender];
}

- (IBAction)checkboxButtonPressed:(id)sender {
    self.checkboxButton.isChecked = !self.checkboxButton.isChecked;
    [FavoriteController toggleFavorite:[DevicePairingManager sharedInstance].currentDevice];

}
@end
