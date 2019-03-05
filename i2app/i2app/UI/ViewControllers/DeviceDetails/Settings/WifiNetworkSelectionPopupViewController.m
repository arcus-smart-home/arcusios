//
//  WifiNetworkSelectionPopupViewController.m
//  i2app
//
//  Created by Arcus Team on 12/11/15.
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
#import "WifiNetworkSelectionPopupViewController.h"
#import "WifiNetworkSelectionTableViewCell.h"
#import "WifiScanResultModel.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>
#import "WiFiCapability.h"

@interface WifiNetworkSelectionPopupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UITableView *selectionTable;
@property (nonatomic, weak) IBOutlet UILabel *footerLabel;
@property (nonatomic, weak) IBOutlet UIButton *enterSSIDManuallyButton;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation WifiNetworkSelectionPopupViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Config

- (void)configureMenu {
    self.selectedIndex = -1;
    self.enterSSIDManuallyButton.layer.borderWidth = 1.0f;
    self.enterSSIDManuallyButton.layer.cornerRadius = 4.0f;

    [self.selectionTable reloadData];
}

#pragma mark - IBActions

- (IBAction)closeButtonPressed:(id)sender {
    if (self.selectionCompletion) {
        self.selectionCompletion(@(self.selectedIndex), NO);
    }
}

- (IBAction)enterSSIDManuallyPressed:(id)sender {
    if (self.selectionCompletion) {
        self.selectionCompletion(nil, YES);
    }
}

#pragma mark - TableViewDataSouce

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return ([self.wifiNetworksArray count] == 0) ? 1 : [self.wifiNetworksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = ([self.wifiNetworksArray count] == 0) ? @"SearchingCell" : @"WifiNetworkCell";
    
    UITableViewCell *cell;
    
    if ([cellIdentifier isEqualToString:@"WifiNetworkCell"]) {
        cell = (WifiNetworkSelectionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[WifiNetworkSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:cellIdentifier];
        }
        
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        }
        
        NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:@"SEARCHING FOR NETWORKS, PLEASE WAIT..."
                                                                        attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                             bold:NO
                                                                                                          kerning:2.0f]];
        [cell.textLabel setAttributedText:titleText];
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WifiNetworkSelectionTableViewCell class]]) {
        WifiNetworkSelectionTableViewCell *wifiCell = (WifiNetworkSelectionTableViewCell *)cell;
        WifiScanResultModel *wifiNetwork = self.wifiNetworksArray[indexPath.row];
        if (wifiNetwork) {
            NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[wifiNetwork.ssid uppercaseString]
                                                                            attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                                 bold:NO
                                                                                                              kerning:2.0f]];
            [wifiCell.networkSSIDLabel setAttributedText:titleText];
            
            if ([wifiNetwork.security count] > 0) {
                wifiCell.networkIsSecureImage.hidden = [wifiNetwork.security[0] isEqualToString:kEnumWiFiSecurityNONE];
            }
            else {
                wifiCell.networkIsSecureImage.hidden = YES;
            }
            
            int strengValue = (int)floor([wifiNetwork.signal doubleValue] / 33.0f);
            if (strengValue == 0) {
                strengValue++;
            }
            
            wifiCell.signalStrengthImage.image = [[UIImage imageNamed:[NSString stringWithFormat:@"wifiStrength%i", strengValue]] invertColor];
        }
        
        wifiCell.networkIsSecureImage.image = [[UIImage imageNamed:@"lockIcon"] invertColor];
        
        [wifiCell.selectionImage setHighlighted:(indexPath.row == self.selectedIndex)];
    }
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedIndex = indexPath.row;
    
    [tableView reloadData];

    if (self.selectionCompletion) {
        self.selectionCompletion(@(self.selectedIndex), NO);
    }
}

@end
