//
//  CameraNetworkSettingsNewViewController.m
//  i2app
//
//  Created by Arcus Team on 12/3/15.
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
#import "CameraNetworkSettingsViewController.h"
#import "WifiNetworkSelectionPopupViewController.h"
#import "SettingsTextFieldTableViewCell.h"
#import "ArcusTitleDetailTableViewCell.h"
#import "PasswordTextField.h"
#import "UIImage+ImageEffects.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionButtonsView.h"
#import "WifiScanResultModel.h"

#import "CameraCapability.h"
#import "WifiCapability.h"
#import "WifiScanCapability.h"
#import "CameraSettingsController.h"

NSString *const kWifiPasswordPlaceholder = @"●●●●●●●●●●●●●";

@interface CameraNetworkSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *networkSettingsTable;
@property (nonatomic, weak) IBOutlet UILabel *connectionTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel *connectionDetailsLabel;
@property (nonatomic, weak) IBOutlet UILabel *securityDetailsLabel;
@property (nonatomic, weak) IBOutlet UIView *wifiNetworkSelectionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *connectionDetailsTopSpace;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *connectionDetailsHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *wifiNetworkSelectionMenuBottomConstraint;

@property (nonatomic, strong) AccountTextField *networkNameField;
@property (nonatomic, strong) PasswordTextField *networkKeyField;
@property (nonatomic, strong) PasswordTextField *confirmNetworkKeyField;
@property (nonatomic, strong) UIButton *clearNameButton;
@property (nonatomic, strong) UIButton *clearKeyButton;
@property (nonatomic, strong) UIButton *clearConfirmButton;
@property (nonatomic, strong) WifiNetworkSelectionPopupViewController *wifiSelectionViewController;
@property (nonatomic, strong) PopupSelectionWindow *networkTypePopUp;
@property (nonatomic, strong) PopupSelectionWindow *errorPopUp;

@property (nonatomic, strong) NSArray *wifiInfoArray;
@property (nonatomic, strong) NSArray *wifiNetworksArray;
@property (nonatomic, strong) NSArray *wifiSecurityTypesArray;

@property (nonatomic, assign) BOOL isWifi;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL isManualSSID;
@property (nonatomic, assign) BOOL isWifiSelectionOpen;
@property (nonatomic, strong) NSString *networkName;
@property (nonatomic, strong) NSString *networkKey;
@property (nonatomic, strong) NSString *confirmNetworkKey;
@property (nonatomic, strong) NSString *networkType;

@property (nonatomic, strong) WifiNetworkScanNotifier* notifier;

@end

@implementation CameraNetworkSettingsViewController

#pragma mark - View LifeCycle

+ (CameraNetworkSettingsViewController *)create {
    CameraNetworkSettingsViewController *viewController = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CameraNetworkSettingsViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wifiScanResultReceived:)
                                                 name:kEvtWiFiScanWiFiScanResults
                                               object:nil];
    
    self.isWifi = [[[WiFiCapability getStateFromModel:self.cameraModel] uppercaseString] isEqualToString:kEnumWiFiStateCONNECTED];
    self.isEditing = NO;
    self.isWifiSelectionOpen = NO;
    self.isManualSSID = NO;
    self.notifier = [[WifiNetworkScanNotifier alloc] init];

    [self.notifier startNotifying];  
    [self fetchWifiNetworksFromCamera];
    
    [self configureNavigationBarForEditDoneState:self.isEditing
                            initialConfiguration:YES];
    [self configureBackground];
    [self configureTableView];
    [self configureHeaderText:self.isWifi];
    [self configureFooterText];
    
    [self removeBaseTextViewControllerGestureRecognizers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.wifiInfoArray = nil;
    self.wifiNetworksArray = nil;
    self.wifiSecurityTypesArray = nil;
}

#pragma mark - UI Configuration

- (void)configureNavigationBarForEditDoneState:(BOOL)isEditing
                          initialConfiguration:(BOOL)initial {
    NSString *editDoneTitle = isEditing ? NSLocalizedString(@"Done", nil) : NSLocalizedString(@"Edit", nil);
    
    [self navBarWithTitle:self.navigationItem.title
       andRightButtonText:editDoneTitle
             withSelector:@selector(editDoneButtonPressed:)];
    
    if (initial) {
        [self addBackButtonItemAsLeftButtonItem];
    }
}

- (void)configureBackground {
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)configureHeaderText:(BOOL)isWifi {
    NSString *headerTitle = (isWifi) ? NSLocalizedString(@"You are currently using Wi-Fi.", @"") : NSLocalizedString(@"You are currently using ethernet.", @"");
    NSAttributedString *attributedHeaderTitle = [[NSAttributedString alloc] initWithString:headerTitle
                                                                                attributes:[FontData getWhiteFontWithSize:18.0f
                                                                                                                     bold:NO
                                                                                                                  kerning:0.0f]];
    [self.connectionTypeLabel setAttributedText:attributedHeaderTitle];
    
    if (!isWifi) {
        NSString *connectToWifiString = NSLocalizedString(@"If you would like to use Wi-Fi, please ensure \nthat your network name and password \nare correct then remove the ethernet \nwire from the camera.", @"");
        NSAttributedString *attributedConnectToWifiString = [[NSAttributedString alloc] initWithString:connectToWifiString
                                                                                            attributes:[FontData getFontWithSize:14.0f
                                                                                                                            bold:NO
                                                                                                                         kerning:0.0f
                                                                                                                           color:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]]];
        [self.connectionDetailsLabel setAttributedText:attributedConnectToWifiString];
    } else {
        [self collapseConnectionDetailLabel];
    }
}

- (void)collapseConnectionDetailLabel {
    self.connectionDetailsLabel.text = nil;
    self.connectionDetailsTopSpace.constant = 0.0f;
    self.connectionDetailsHeight.constant = 0.0f;
}

- (void)configureFooterText {
    NSString *footerText = NSLocalizedString(@"WPA2 is recommended for optimal security. Contact \nyour router manufacturer for help in securing your \nhome network. All Arcus communication and \nimage transmissions are encrypted even if your \nnetwork is unsecure.", @"");
    NSAttributedString *attributedFooterText = [[NSAttributedString alloc] initWithString:footerText
                                                                               attributes:[FontData getFontWithSize:14.0f
                                                                                                               bold:NO
                                                                                                            kerning:0.0f
                                                                                                              color:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]]];
    
    [self.securityDetailsLabel setAttributedText:attributedFooterText];
}

- (void)configureTableView {
    self.networkSettingsTable.backgroundColor = [UIColor clearColor];
    self.networkSettingsTable.backgroundView = nil;
    self.networkSettingsTable.estimatedRowHeight = 200.0f;
    self.networkSettingsTable.rowHeight = UITableViewAutomaticDimension;
}

- (void)removeBaseTextViewControllerGestureRecognizers {
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gestureRecognizer];
    }
}

#pragma mark - Getters & Setters

- (NSArray *)wifiInfoArray {
    return _wifiInfoArray  = @[@{@"title" : NSLocalizedString(@"WI-FI NETWORK", @""),
                                 @"value" : self.networkName},
                               @{@"title" : NSLocalizedString(@"PASSWORD", @""),
                                 @"value" : [self networkKeyDisplayString]},
                               @{@"title" : NSLocalizedString(@"SECURITY SETTING", @""),
                                 @"value" : [self networkTypeDisplayString]}];;
}

- (NSString *)networkKeyDisplayString {
    NSString *displayString = @"";
    
    if (!self.isEditing && self.networkKey.length > 0) {
        for (int i = 0; i < self.networkKey.length; i++) {
            displayString = [displayString stringByAppendingString:@"●"];
        }
    }
    else {
        displayString = self.networkKey;
    }
    
    return displayString;
}

- (NSString *)networkTypeDisplayString {
    NSString *displayString = [self.networkType stringByReplacingOccurrencesOfString:@"_"
                                                                          withString:@" "];
    displayString = [displayString stringByReplacingOccurrencesOfString:@"-"
                                                             withString:@" "];
    
    return displayString;
}

- (NSArray *)wifiSecurityTypesArray {
    if (!_wifiSecurityTypesArray) {
        _wifiSecurityTypesArray = @[kEnumWiFiSecurityNONE,
                                    kEnumWiFiSecurityWEP,
                                    kEnumWiFiSecurityWPA_PSK,
                                    kEnumWiFiSecurityWPA2_PSK,
                                    kEnumWiFiSecurityWPA_ENTERPRISE,
                                    kEnumWiFiSecurityWPA2_ENTERPRISE];
    }
    return _wifiSecurityTypesArray;
}

- (NSArray *)popupSelectionButtonModelsForSecurityTypesArray:(NSArray *)enumeratedTypes {
    NSMutableArray *mutableSecurityTypesArray = [[NSMutableArray alloc] init];
    for (NSString *type in enumeratedTypes) {
        NSString *typeTitle = [type stringByReplacingOccurrencesOfString:@"_"
                                                              withString:@" "];
        //        typeTitle = [NSString stringWithFormat:@"   %@", typeTitle];
        
        PopupSelectionButtonModel *typeSelection = [PopupSelectionButtonModel create:typeTitle
                                                                               event:@selector(networkTypeSelected:)
                                                                                 obj:(id)type];
        
        [mutableSecurityTypesArray addObject:typeSelection];
    }
    
    return [NSArray arrayWithArray:mutableSecurityTypesArray];
}

- (NSString *)networkName {
    if (!_networkName) {
        _networkName = ([WiFiCapability getSsidFromModel:self.cameraModel]) ? [WiFiCapability getSsidFromModel:self.cameraModel] : @"";
    }
    return _networkName;
}

- (NSString *)networkKey {
    if (!_networkKey) {
        // If not editting the form, and wifi configured then show placeholder
        // Otherwise set _networkKey to an empty string.
        if (!self.isEditing) {
            if (self.networkName && ![self.networkType isEqualToString:kEnumWiFiSecurityNONE]) {
              _networkKey = kWifiPasswordPlaceholder;
            } else {
                _networkKey = @"";
            }
        } else {
            _networkKey = @"";
        }
    }
    return _networkKey;
}

- (NSString *)networkType {
    if (!_networkType) {
        _networkType = ([WiFiCapability getSecurityFromModel:self.cameraModel]) ? [WiFiCapability getSecurityFromModel:self.cameraModel] : @"";
    }
    return _networkType;
}

- (void)setIsEditing:(BOOL)isEditing {
    if (isEditing) {
        [self.view endEditing:YES];
    }
    _isEditing = isEditing;
}

#pragma mark - IBActions

- (IBAction)editDoneButtonPressed:(id)sender {
    BOOL isEditing = self.isEditing;

    [self updateEditDoneState];

    // Save if Needed
    if (isEditing) {
        if (![self updateCameraNetworkSettings]) {
            [self updateEditDoneState];
        }
    }
}

- (void)updateEditDoneState {
    // Update UI State BOOL by flipping edit state
    [self setIsEditing:!self.isEditing];
    
    // Update Button State
    [self configureNavigationBarForEditDoneState:self.isEditing
                            initialConfiguration:NO];
    
    // Reload TableView
    [self.networkSettingsTable reloadData];
}

- (IBAction)clearTextButtonPressed:(id)sender {
    UIButton *clearButton = (UIButton *)sender;
    if (clearButton == self.clearNameButton) {
        self.networkNameField.text = nil;
        self.networkName = @"";
    } else if (clearButton == self.clearKeyButton) {
        self.networkKeyField.text = nil;
        self.networkKey = @"";
    } else if (clearButton == self.clearConfirmButton) {
        self.confirmNetworkKeyField.text = nil;
        self.confirmNetworkKey = @"";
    }
    
    [self.networkSettingsTable reloadData];
}

- (IBAction)contactSupport:(id)sender {
    NSString *phNo = @"+18554694747";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

#pragma mark - Data I/O

- (void)fetchWifiNetworksFromCamera {
    if (self.cameraModel) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            [CameraSettingsController getWifiNetworksForDevice:self.cameraModel
                                                   withTimeout:@(20)].catch(^(NSError *error){
                [self displayErrorMessage:error.description withTitle:@"Error!"];
            });
        });
    }
}

- (BOOL)updateCameraNetworkSettings {
    BOOL settingsValid = [self validateSecurityField];
    if (settingsValid) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            [CameraSettingsController updateNetworkSettingsWithWifiSSID:self.networkName
                                                            securityKey:self.networkKey
                                                           securityType:self.networkType
                                                          onDeviceModel:self.cameraModel].then(^(NSDictionary *responseAttributes) {
                if ([responseAttributes[@"status"] isEqualToString:@"REFUSED"]) {
                    [self displayErrorPopUpWithTitle:[NSLocalizedString(@"Connection Error", nil) uppercaseString]
                                            subtitle:NSLocalizedString(@"The camera was unable to save \nthe settings. Please try again. If this occurs \nagain, please call the Arcus support \nteam for more assistance.", nil)];
                } else {
                    [self executeCompletion];
                }
            }).catch(^ (NSError *error) {
                [self displayErrorPopUpWithTitle:[NSLocalizedString(@"Connection Error", nil) uppercaseString]
                                        subtitle:NSLocalizedString(@"The camera was unable to save \nthe settings. Please try again. If this occurs \nagain, please call the Arcus support \nteam for more assistance.", nil)];
            });
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayErrorMessage:NSLocalizedString(@"Please enter and confirm the password for your selected wifi network, and try again.", nil)
                            withTitle:NSLocalizedStringFromTable(@"Hmmm, Something’s Wrong", @"ErrorMessages", nil)];
        });
    }
    
    return settingsValid;
}

- (BOOL)validateSecurityField {
    BOOL isValid = YES;
    
    if (![self.networkType isEqualToString:kEnumWiFiSecurityNONE]) {
        NSString *netWorkKeyTrim = [self.networkKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *confirmKeyTrim = [self.confirmNetworkKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (![netWorkKeyTrim isEqualToString:confirmKeyTrim]) {
            isValid = NO;
        } else if (!netWorkKeyTrim || netWorkKeyTrim.length == 0) {
            isValid = NO;
            //        }
            // else if (netWorkKeyTrim.length != [self requiredKeyLengthForSecurityType:self.networkType]) {
            //            isValid = NO;
        } else if ([netWorkKeyTrim isEqualToString:kWifiPasswordPlaceholder]) {
            isValid = NO;
        }
    }
    
    return isValid;
}

- (NSInteger)requiredKeyLengthForSecurityType:(NSString *)securityType {
    return 0;
}

- (void)executeCompletion {
    if (self.saveSettingsCompletion) {
        self.saveSettingsCompletion(self.isWifi);
    }
}

#pragma mark - Notification Handling

- (void)wifiScanResultReceived:(NSNotification *)notification {
    if (notification) {
        NSDictionary *scanResultInfo = [notification object];
        
        // Check Source against device ID
        if ([[self.cameraModel address] isEqualToString:scanResultInfo[@"source"]]) {
            // Parse Attributes into model
            if (scanResultInfo[@"attributes"][@"scanResults"]) {
                [self parseWifiScanResult:scanResultInfo[@"attributes"][@"scanResults"]];
            }
        }
    }
}

- (void)parseWifiScanResult:(NSArray *)scanResults {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *mutableScanResults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in scanResults) {
            WifiScanResultModel *scanResultModel = [WifiScanResultModel wifiScanResultModelFromAttributes:result];
            if (scanResultModel) {
                [mutableScanResults addObject:scanResultModel];
            }
        }
        
        if ([mutableScanResults count] > 0) {
            NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"ssid" ascending:YES];
            [mutableScanResults sortUsingDescriptors:@[sd]];

            self.wifiNetworksArray = [NSArray arrayWithArray:mutableScanResults];
            self.wifiSelectionViewController.wifiNetworksArray = self.wifiNetworksArray;
            [self.wifiSelectionViewController configureMenu];
        }

    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isEditing ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (self.isEditing) {
        switch (section) {
            case 0:
                rows = 1;
                break;
            case 1:
                rows = self.isManualSSID ? 3 : 2;
                break;
            case 2:
                rows = 1;
                break;
            default:
                break;
        }
    }
    else {
        rows = [self.wifiInfoArray count];
    }
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    
    if (self.isEditing) {
        switch (indexPath.section) {
            case 0:
                height = 44.0f;
                break;
            case 1:
                if (IS_IPHONE_5) {
                    height = 60.f;
                }
                else {
                    height = 75.0f;
                }
                break;
            case 2:
                height = 44.0f;
                break;
            default:
                break;
        }
    } else {
        height = 44.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *cellIdentifier = @"NetworkInfoCell";
    
    if (!self.isEditing) {
        cell = [self tableView:tableView
   titleDetailCellForIndexPath:indexPath
               reuseIdentifier:cellIdentifier
                         title:self.wifiInfoArray[indexPath.row][@"title"]
                        detail:self.wifiInfoArray[indexPath.row][@"value"]
                 showAccessory:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        switch (indexPath.section) {
            case 0: {
                NSString *networkName = !self.isManualSSID ? self.wifiInfoArray[indexPath.section][@"value"] : @"";
                
                cell = [self tableView:tableView
           titleDetailCellForIndexPath:indexPath
                       reuseIdentifier:cellIdentifier
                                 title:self.wifiInfoArray[indexPath.section][@"title"]
                                detail:networkName
                         showAccessory:YES];
                break;
            }
            case 1:
                cellIdentifier = @"NetworkTextFieldCell";
                
                cell = [self tableView:tableView
             textFieldCellForIndexPath:indexPath
                       reuseIdentifier:cellIdentifier];
                break;
            case 2: {
                cell = [self tableView:tableView
           titleDetailCellForIndexPath:indexPath
                       reuseIdentifier:cellIdentifier
                                 title:self.wifiInfoArray[indexPath.section][@"title"]
                                detail:self.wifiInfoArray[indexPath.section][@"value"]
                         showAccessory:YES];
                break;
            }
            default:
                break;
        }
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (ArcusTitleDetailTableViewCell *)tableView:(UITableView *)tableView
                titleDetailCellForIndexPath:(NSIndexPath *)indexPath
                            reuseIdentifier:(NSString *)cellIdentifier
                                      title:(NSString *)title
                                     detail:(NSString *)detail
                              showAccessory:(BOOL)showAccessory {
    
    ArcusTitleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ArcusTitleDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *titleFontData = [FontData getFont:FontDataTypeSettingsTextFieldPlaceholder];
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:title
                                                                      attributes:titleFontData];
    
    [cell.titleLabel setAttributedText:titleString];
    
    NSDictionary *fontData = [FontData getFont:FontDataTypeSettingsSubTextTranslucent];
    NSAttributedString *accessoryString = [[NSAttributedString alloc] initWithString:detail
                                                                          attributes:fontData];
    
    [cell.accessoryLabel setAttributedText:accessoryString];
    
    if (!showAccessory) {
        cell.accessoryImageTrailingSpace.constant = 0.0f;
        cell.accessoryImage.image = nil;
    } else {
        cell.accessoryImageTrailingSpace.constant = 15.0f;
        cell.accessoryImage.image = [[UIImage imageNamed:@"Chevron"] invertColor];
    }
    
    return cell;
}

- (SettingsTextFieldTableViewCell *)tableView:(UITableView *)tableView textFieldCellForIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)cellIdentifier {
    
    SettingsTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingsTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:cellIdentifier];
    }
    
    cell.textField.tag = indexPath.row;
    cell.textField.textColor = [UIColor whiteColor];
    cell.textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    cell.textField.floatingLabelActiveTextColor = [UIColor whiteColor];
    cell.textField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    cell.textField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    
    [cell.textField setupType:(indexPath.row == 0 && self.isManualSSID) ? AccountTextFieldTypeGeneral : AccountTextFieldTypePassword
                     fontType:FontDataTypeSettingsTextField
          placeholderFontType:FontDataTypeSettingsTextFieldPlaceholder];
    
    cell.textField.delegate = self;
    
    [cell.clearButton setImage:[[UIImage imageNamed:@"RoleCloseEditButton"] invertColor]
                      forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textField.placeholder = self.isManualSSID ? @"Network Name" : @"Password";
        cell.textField.secureTextEntry = !self.isManualSSID;
        
        if (self.isManualSSID) {
            cell.textField.text = self.networkName;
        } else {
            NSString *keyText = self.networkKey;
            if ([keyText isEqualToString:Constants.kPasswordPlaceholder]) {
                keyText = nil;
            }
            
            cell.textField.text = keyText;
        }
        cell.clearButton.hidden = (cell.textField.text.length == 0);
        
        if (self.isManualSSID) {
            self.networkNameField = cell.textField;
            self.clearNameButton = cell.clearButton;
        } else {
            self.networkKeyField = (PasswordTextField *)cell.textField;
            self.clearKeyButton = cell.clearButton;
        }
    } else if (indexPath.row == 1) {
        cell.textField.placeholder = self.isManualSSID ? @"Password" : @"Confirm Password";
        cell.textField.secureTextEntry = YES;
        
        NSString *keyText = self.isManualSSID ?  self.networkKey : self.confirmNetworkKey;
        if ([keyText isEqualToString:Constants.kPasswordPlaceholder]) {
            keyText = nil;
        }
        
        cell.textField.text = keyText;
        cell.textField.secureTextEntry = YES;
        cell.clearButton.hidden = (cell.textField.text.length == 0);
        
        if (self.isManualSSID) {
            self.networkKeyField = (PasswordTextField *)cell.textField;
            self.clearKeyButton = cell.clearButton;
        } else {
            self.confirmNetworkKeyField = (PasswordTextField *)cell.textField;
            self.clearConfirmButton = cell.clearButton;
        }
        
    } else if (indexPath.row == 2) {
        cell.textField.placeholder = @"Confirm Password";
        cell.textField.secureTextEntry = YES;
        
        NSString *keyText = self.confirmNetworkKey;
        if ([keyText isEqualToString:Constants.kPasswordPlaceholder]) {
            keyText = nil;
        }
        
        cell.textField.text = keyText;
        
        self.confirmNetworkKeyField = (PasswordTextField *)cell.textField;
        self.clearConfirmButton = cell.clearButton;
        self.clearConfirmButton.hidden = (cell.textField.text.length == 0);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        if (indexPath.section == 0) {
            [self openWifiNetworkSelectionMenu];
        } else if (indexPath.section == 2) {
            [self openSecurityTypeSelectionMenu];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.isWifiSelectionOpen) {
        [self closeWifiSelectionMenu];
    }
    
    if ([self.networkTypePopUp displaying]) {
        [self.networkTypePopUp close];
    }
    
    self.networkSettingsTable.scrollEnabled = YES;
    
    [super textFieldDidBeginEditing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UIButton *clearButton = nil;
    if (textField == self.networkNameField) {
        clearButton = self.clearNameButton;
    } else if (textField == self.networkKeyField) {
        clearButton = self.clearKeyButton;
    } else if (textField == self.confirmNetworkKeyField) {
        clearButton = self.clearConfirmButton;
    }
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:string];
    clearButton.hidden = !(newText.length > 0);
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.networkSettingsTable.scrollEnabled = NO;
    
    if (textField == self.networkNameField) {
        self.networkName = self.networkNameField.text;
    } else if (textField == self.networkKeyField) {
        self.networkKey = [self.networkKeyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else if (textField == self.confirmNetworkKeyField) {
        self.confirmNetworkKey = [self.confirmNetworkKeyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    [super textFieldDidEndEditing:textField];
}

#pragma mark - Wifi Network Selection Handling

- (void)openWifiNetworkSelectionMenu {
    if (!self.isWifiSelectionOpen) {
        [self.view endEditing:YES];
        
        WifiSelectionCompletion completion = ^ (NSNumber *selectedIndex, BOOL isManualEntry) {
            self.isManualSSID = isManualEntry;
            if (!self.isManualSSID) {
                if ([selectedIndex integerValue] > -1 &&
                    [selectedIndex integerValue] < [self.wifiNetworksArray count]) {
                    WifiScanResultModel *wifiNetwork = self.wifiNetworksArray[[selectedIndex integerValue]];
                    
                    [self networkNameSelected:wifiNetwork.ssid];
                    
                    if ([wifiNetwork.security count] > 0) {
                        [self networkTypeSelected:wifiNetwork.security[0]];
                    }
                }
            } else {
                [self.networkSettingsTable reloadData];
            }
            
            [self closeWifiSelectionMenu];
        };
        self.wifiSelectionViewController.selectionCompletion = completion;
        self.wifiSelectionViewController.wifiNetworksArray = self.wifiNetworksArray;
        [self.wifiSelectionViewController configureMenu];
        
        self.wifiNetworkSelectionView.alpha = 1.0f;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ (void) {
                             self.wifiNetworkSelectionMenuBottomConstraint.constant = 0;
                             [self.view layoutIfNeeded];
                             [self.wifiNetworkSelectionView layoutIfNeeded];
                             [self.wifiSelectionViewController.view layoutIfNeeded];
                         }
                         completion:^ (BOOL finished) {
                             
                         }];
        self.isWifiSelectionOpen = !self.isWifiSelectionOpen;
    }
}

- (void)closeWifiSelectionMenu {
    if (self.isWifiSelectionOpen) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^ (void) {
                             self.wifiNetworkSelectionMenuBottomConstraint.constant = -self.wifiNetworkSelectionView.frame.size.height;
                             [self.view layoutIfNeeded];
                         }
                         completion:^ (BOOL finished) {
                             self.wifiNetworkSelectionView.alpha = 0.0f;
                         }];
        self.isWifiSelectionOpen = !self.isWifiSelectionOpen;
    }
}

- (void)networkNameSelected:(id)selectedValue {
    self.networkName = selectedValue;
    
    [self.networkSettingsTable reloadData];
}

#pragma mark - Security Type Selection Handling

- (void)openSecurityTypeSelectionMenu {
    [self.view endEditing:YES];
    
    PopupSelectionButtonsView *networkTypeSelectionPopUp = [PopupSelectionButtonsView createWithTitle:@"SECURITY SETTINGS" buttons:[self popupSelectionButtonModelsForSecurityTypesArray:self.wifiSecurityTypesArray]];
    networkTypeSelectionPopUp.owner = self;
    
    self.networkTypePopUp = [PopupSelectionWindow popup:self.view
                                                subview:networkTypeSelectionPopUp
                                                  owner:self
                                          closeSelector:@selector(close)];
}

- (void)close {
    [self.networkSettingsTable reloadData];
}

- (void)networkTypeSelected:(id)selectedValue {
    self.networkType = selectedValue;
    
    if ([self.networkType isEqualToString:kEnumWiFiSecurityWEP]) {
        [self displayErrorMessage:NSLocalizedString(@"Warning! Arcus does not support all WEP \nconfigurations as they are not the most \nsecure. For security reasons please consider \nusing WPA\\WPA2 instead. Contact your router \nmanufacturer for assistance in securing \nyour home network.", nil)
                        withTitle:NSLocalizedString(@"Warning!", nil).uppercaseString];
    }
    [self.networkSettingsTable reloadData];
    
}

#pragma mark - Error PopUp Handling

- (void)displayErrorPopUpWithTitle:(NSString *)title subtitle:(NSString *)subtitle {    PopupSelectionButtonModel *contactSupportSelectionModel = [PopupSelectionButtonModel create:NSLocalizedString(@"1-0", nil) event:@selector(contactSupport:)];
    
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:[title uppercaseString]
                                                                              subtitle:subtitle
                                                                                button:contactSupportSelectionModel, nil];
    buttonView.owner = self;
    
    self.errorPopUp = [PopupSelectionWindow popup:self.view
                                          subview:buttonView
                                            owner:self
                                    closeSelector:nil
                                            style:PopupWindowStyleCautionWindow];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmbedWifiSelectionSegue"]) {
        self.wifiSelectionViewController = (WifiNetworkSelectionPopupViewController *)segue.destinationViewController;
    }
}

@end
