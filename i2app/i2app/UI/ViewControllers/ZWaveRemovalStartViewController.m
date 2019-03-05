//
//  ZWaveRemovalStartViewController.m
//  i2app
//
//  Created by Arcus Team on 12/15/15.
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
#import "ZWaveRemovalStartViewController.h"
#import "ZWaveRemovalSearchingViewController.h"

#import "ZWaveUnpairingController.h"

NSString *const kStartRemovalSegue = @"StartZWaveRemoveSegue";

@interface ZWaveRemovalStartViewController () <ZWaveUnpairingControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *removeZWaveTitle;
@property (nonatomic, weak) IBOutlet UILabel *removeZWaveDetail;
@property (nonatomic, weak) IBOutlet UIButton *startRemoveButton;

@property (nonatomic, strong) ZWaveUnpairingController *unpairingController;

@end

@implementation ZWaveRemovalStartViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureBackground];
    [self configureLabels];
    [self configureStartRemoveButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.unpairingController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        if (self.unpairingController.isUnPairing) {
            [self.unpairingController stopUnParing];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters & Setters

- (ZWaveUnpairingController *)unpairingController {
    if (!_unpairingController) {
        _unpairingController = [[ZWaveUnpairingController alloc] initWithHub:[[[CorneaHolder shared] settings] currentHub]];
        _unpairingController.delegate = self;
    }
    return _unpairingController;
}

#pragma mark - UI Configuration

- (void)configureNavigationBar {
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
}

- (void)configureBackground {
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)configureLabels {
    // Configure Z-Wave Title Label
    NSString *zWaveTitle = NSLocalizedString(@"Remove Z-Wave Device", @"");
    NSAttributedString *attributedZWaveTitle = [[NSAttributedString alloc] initWithString:zWaveTitle
                                                                               attributes:[FontData getWhiteFontWithSize:18.0f
                                                                                                                    bold:NO
                                                                                                                 kerning:0.0f]];
    [self.removeZWaveTitle setAttributedText:attributedZWaveTitle];
    
    // Configure Z-Wave Detail Label
    NSString *zWaveDetail = NSLocalizedString(@"Perhaps you’re having trouble adding a \nZ-Wave device that was previously paired \nor maybe your new device won’t connect \n after several attempts.\n\nTap ‘Remove Z-Wave Devices’ below to \nremove orphaned Z-Wave devices that \nno longer appear on your device list \npage. These devices believe they are \npaired to the hub, but the hub does \nnot know about them.", @"");
    NSAttributedString *attributedZWaveDetail = [[NSAttributedString alloc] initWithString:zWaveDetail
                                                                                        attributes:[FontData getFontWithSize:14.0f
                                                                                                                        bold:NO
                                                                                                                     kerning:0.0f
                                                                                                                       color:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]]];
    [self.removeZWaveDetail setAttributedText:attributedZWaveDetail];
}

- (void)configureStartRemoveButton {
    [self.startRemoveButton styleSet:NSLocalizedString(@"REMOVE Z-WAVE DEVICES", nil)
                       andButtonType:FontDataTypeButtonLight
                           upperCase:YES];
}

#pragma mark - IBActions

- (IBAction)startRemoveButtonPressed:(id)sender {
    if (self.unpairingController.isUnPairing) {
        [self.unpairingController stopUnParing];
    }
    [self.unpairingController startUnParing];
    [self performSegueWithIdentifier:kStartRemovalSegue
                              sender:self];
}

#pragma mark - ZWaveUnpairingControllerDelegate

- (void)successStartUnpairWithResponse:(HubUnpairingRequestResponse *)response {

}

- (void)failToStartUnpairWithError:(NSError*)error {

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kStartRemovalSegue]) {
        ZWaveRemovalSearchingViewController *searchingViewController = (ZWaveRemovalSearchingViewController *)segue.destinationViewController;
        searchingViewController.unpairingController = self.unpairingController;
    }
}

@end
