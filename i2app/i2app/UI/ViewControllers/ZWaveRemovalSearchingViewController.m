//
//  ZWaveRemovalSuccessViewController.m
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
#import "ZWaveRemovalSearchingViewController.h"
#import "ZWaveDeviceRemovedCell.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"


#import "ZWaveUnpairingController.h"
#import "HubCapability.h"

@interface ZWaveRemovalSearchingViewController () <UITableViewDataSource, ZWaveUnpairingControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UILabel *footerLabel;
@property (nonatomic, weak) IBOutlet UITableView *removedDevicesTableView;
@property (nonatomic, weak) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) PopupSelectionWindow *popupWindow;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *searchActivityIndicator;

@property (atomic, assign) BOOL appIdleTimerDisabled;

@end

@implementation ZWaveRemovalSearchingViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureBackground];
    [self configureLabels];
    [self configureDoneButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.unpairingController.delegate = self;

    // Disable app sleep mode
    self.appIdleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Need to stop unpairing if user backs out of screen from nav-bar
    if (self.unpairingController.isUnPairing) {
        [self.unpairingController stopUnParing];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = self.appIdleTimerDisabled;
}

#pragma mark - Getters
- (ZWaveUnpairingController *)unpairingController {
    if (!_unpairingController) {
        _unpairingController = [[ZWaveUnpairingController alloc] initWithHub:[[CorneaHolder shared] settings].currentHub];
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
    NSString *searchingTitle = nil;
    if (self.removedDevicesArray.count > 0) {
        searchingTitle = [NSString stringWithFormat:@"The %d Z-Wave device(s) below have been reset.", (int)self.removedDevicesArray.count];
    }
    else {
        searchingTitle = NSLocalizedString(@"Searching", @"");
    }
    
    NSAttributedString *attributedSearchingTitle = [[NSAttributedString alloc] initWithString:searchingTitle
                                                                                   attributes:[FontData getWhiteFontWithSize:18.0f
                                                                                                                        bold:NO
                                                                                                                     kerning:0.0f]];
    [self.headerLabel setAttributedText:attributedSearchingTitle];
    
    // Configure Z-Wave Detail Label
    NSString *footerDetail = NSLocalizedString(@"To reset the device, put the device in \n”learn mode” which usually involves \n pressing the Z-Wave button on the \ndevice. Check your manufacturer’s manual for details. \n\nNote: Do not use any other Z-Wave \ndevices during this process as they may \nbe removed inadvertently.", @"");
    NSAttributedString *attributedFooterDetail = [[NSAttributedString alloc] initWithString:footerDetail
                                                                                 attributes:[FontData getFontWithSize:14.0f
                                                                                                                 bold:NO
                                                                                                              kerning:0.0f
                                                                                                                color:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]]];
    [self.footerLabel setAttributedText:attributedFooterDetail];
}

- (void)configureDoneButton {
    [self.doneButton styleSet:NSLocalizedString(@"DONE", nil)
                andButtonType:FontDataTypeButtonLight
                    upperCase:YES];
}

#pragma mark - IBActions

- (IBAction)doneButtonPressed:(id)sender {
    [self.unpairingController stopUnParing];
    [self dismissUnpairing];
}

- (void)dismissUnpairing {
    if (self.unpairingController.isUnPairing) {
        [self.unpairingController stopUnParing];
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[1]
                                          animated:YES];
}

#pragma mark - Pop Up Handling

- (void)showTimeoutPopup {
    NSString *subtitle = [self.removedDevicesArray count] > 0 ? @"Do you \n want to keep looking?" :  @"A device was not removed. Do you \n want to keep looking?";
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:@"TIMEOUT" subtitle:subtitle button:[PopupSelectionButtonModel create:@"YES" event:@selector(yesButtonPressed)], [PopupSelectionButtonModel create:@"NO" event:@selector(noButtonPressed)], nil];
    [buttonView setOwner:self];
    
    self.popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:buttonView
                                             owner:self
                                     closeSelector:nil
                                             style:PopupWindowStyleCautionWindow];
}

- (void)yesButtonPressed {
    if (self.unpairingController.isUnPairing) {
        [self.unpairingController stopUnParing];
    }
    [self.unpairingController startUnParing];
}

- (void)noButtonPressed {
    [self dismissUnpairing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.removedDevicesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RemovedDeviceCell";
    
    ZWaveDeviceRemovedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ZWaveDeviceRemovedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *deviceName = self.removedDevicesArray[indexPath.row];
    
    NSAttributedString *attributedDeviceName = [[NSAttributedString alloc] initWithString:deviceName
                                                                               attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                            NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-MediumItalic"
                                                                                                                                size:12.0]}];
    [cell.deviceLabel setAttributedText:attributedDeviceName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - ZWaveUnpairingControllerDelegate

- (void)successStartUnpairWithResponse:(HubUnpairingRequestResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startSearchIndicator];
    });
}

- (void)failToStartUnpairWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([[HubCapability getStateFromModel:[[CorneaHolder shared] settings].currentHub] isEqualToString:kEnumHubStateUNPAIRING]) {
            [self startSearchIndicator];
            return;
        }
        
        [self stopSearchIndicator];
        [self showTimeoutPopup];
        
    });
}

- (void)timeOut {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self stopSearchIndicator];
        [self showTimeoutPopup];
    });
}

- (void)deviceRemovedName:(NSString *)deviceRemovedName {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self addRemovedDevice:deviceRemovedName];
        [self.removedDevicesTableView reloadData];
    });
}

- (void)addRemovedDevice:(NSString *)deviceRemovedName {
    NSMutableArray *mutableRemovedDevices = [[NSMutableArray alloc] initWithArray:self.removedDevicesArray];
    if (deviceRemovedName) {
        [mutableRemovedDevices addObject:deviceRemovedName];
        self.removedDevicesArray = [NSArray arrayWithArray:mutableRemovedDevices];
    }
}
#pragma mark - Indicator

- (void)startSearchIndicator {
    self.searchActivityIndicator.hidden = NO;
    [self.searchActivityIndicator startAnimating];
}

- (void)stopSearchIndicator {
    self.searchActivityIndicator.hidden = YES;
    [self.searchActivityIndicator stopAnimating];
}

@end
