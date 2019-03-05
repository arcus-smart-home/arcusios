//
//  DeviceMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 5/30/15.
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
#import "DeviceMoreViewController.h"
#import "DeviceProductInformationViewController.h"
#import "DeviceTestViewController.h"
#import "DeviceConnectivityAndPowerViewController.h"
#import "DeviceAdvancedViewController.h"
#import "DeviceMoreConnectDeviceListViewController.h"
#import "DeviceManager.h"
#import "DeviceTextfieldViewController.h"
#import "DeviceHoneywellConnectViewController.h"
#import "MessageWithButtonsViewController.h"
#import "DevicePairingWizard.h"
#import "DeviceListViewController.h"
#import "DeviceSettingsViewController.h"
#import "DeviceSettingModels.h"
#import "PopupSelectionTitleTableView.h"
#import "DeviceUnpairingManager.h"
#import "DeviceRenameAssignmentController.h"
#import "KeyFobRuleSettingButtonController.h"
#import "DevicePetdoorSmartKeysSimpleDelegate.h"
#import "DeviceSettingCellController.h"
#import "PopupSelectionButtonsView.h"

#import "DeviceMoreTableViewCell.h"
#import "SimpleTableViewController.h"
#import <PureLayout/PureLayout.h>

#import "BridgeCapability.h"
#import "BridgeChildCapability.h"
#import "DeviceAdvancedCapability.h"
#import "WiFiCapability.h"
#import "DeviceDetailsTabBarController.h"
#import "WiFiCapability.h"
#import "DeviceCapability.h"
#import "HubCapability.h"

#import "DeviceController.h"
#import "FavoriteController.h"
#import "ContactCapability.h"
#import "DeviceOtaCapability.h"
#import "DeviceSomfyBlindsSettingsViewController.h"
#import "HubCapability.h"
#import "HubAdvancedCapability.h"
#import "UIColor+Convert.h"
#import <i2app-Swift.h>

typedef enum {
    DeviceMoreControllerTypeNothing             = 0,
    DeviceMoreControllerTypeFavorites,
    DeviceMoreControllerTypeProductInformation,
    DeviceMoreControllerTypeTest,
    DeviceMoreControllerTypeRenameAndAssignment,
    DeviceMoreControllerTypeNameAndPhoto,
    DeviceMoreControllerTypeNameAndPhotoHalo,
    DeviceMoreControllerTypeConnectivityAndPower,
    DeviceMoreControllerTypeAdvanced,
    DeviceMoreControllerTypeHubFirmware,
    DeviceMoreControllerTypeSetting,
    DeviceMoreControllerTypeContactSetting,
    DeviceMoreControllerTypeTiltSetting,
    DeviceMoreControllerTypeButtonRule,
    DeviceMoreControllerTypeNetworkConnection,
    DeviceMoreControllerTypeGarageDoors,
    DeviceMoreControllerTypePetDoorSmartKeys,
    DeviceMoreControllerTypeHoneywellThermostat,
    DeviceMoreControllerTypeSomfyBlindsSetting,
    DeviceMoreControllerTypeHaloTesting,
    DeviceMoreControllerTypeHaloWeatherAlerts,
    DeviceMoreControllerTypeHaloWeatherRadio,
    DeviceMoreControllerTypeHubReboot
} DeviceMoreControllerType;

@interface DeviceMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *removeThisDeviceButton;
@property (nonatomic) NSMutableArray *modeArray;
@property (strong, nonatomic) DeviceModel *deviceModel;

@end

@implementation DeviceMoreViewController {
    PopupSelectionWindow    *_popupWindow;
}

#pragma mark - Life Cycle
+ (DeviceMoreViewController *)createWithDeviceModel:(DeviceModel *)deviceModel {
    DeviceMoreViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceMoreViewController class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"More", nil);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesMore];
  
    [self navBarWithBackButtonAndTitle:self.title];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setBackgroundColorToParentColor];
    
    [self.tableView setTableFooterView:[self createTableFooterView]];
    
    [_removeThisDeviceButton styleSet:NSLocalizedString(@"remove this device", nil) andButtonType:FontDataTypeButtonLight upperCase:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteChanged:) name:[Model tagChangedNotification:kFavoriteTag] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactUseHintChanged:) name:[Model attributeChangedNotification:kAttrContactUsehint] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:[Model attributeChangedNotification:kAttrDeviceName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:[Model attributeChangedNotification:kAttrHubName] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListChanged:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:[Model attributeChangedNotification:kAttrHubState] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self parseData];
    [self.tableView reloadData];
}

#pragma mark - Method
- (UIView *)createTableFooterView {
    UIView *footerView = [[UIView alloc] init];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    if (self.deviceModel.deviceType == DeviceTypeThermostat ||
        self.deviceModel.deviceType == DeviceTypeWaterHeater) {
        footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120);
        UILabel *label = [[UILabel alloc] initForAutoLayout];
        [label setNumberOfLines:0];
        [label setTextAlignment:NSTextAlignmentCenter];
        [footerView addSubview:label];
        NSString *text;
        if (self.deviceModel.deviceType == DeviceTypeThermostat) {
            text = @"Tap the Climate card on the Dashboard to manage your thermostat schedule.";
        } else if (self.deviceModel.deviceType == DeviceTypeWaterHeater) {
            text = NSLocalizedString(@"Tap the Water card on the Dashboard to manage your water heater's schedule.", nil);
        }
        [label styleSet:text andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO alpha:NO]];
        [label autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerView withOffset:30];
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerView withOffset:40];
        [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerView withOffset:-40];
    }
    
    return footerView;
}

- (IBAction)onRemoveThisDevice:(id)sender {
    NSString *subText = @"";
    NSString *title = nil;

    if ([self.deviceModel isKindOfClass:[HubModel class]]) {
        title = NSLocalizedString(@"REMOVE HUB", nil);
        subText = NSLocalizedString(@"To remove the hub, call our support team for assistance.", nil);

        PopupSelectionButtonModel *yesModel = [PopupSelectionButtonModel create:NSLocalizedString(@"CALL SUPPORT", nil)
                                                                          event:@selector(contactSupport:)];

        PopupSelectionButtonModel *noModel = [PopupSelectionButtonModel create:NSLocalizedString(@"CANCEL", nil)
                                                                         event:nil];

        PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:title
                                                                                  subtitle:subText
                                                                                    button:yesModel, noModel, nil];
        buttonView.owner = self;

        _popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:buttonView
                                             owner:self
                                     closeSelector:nil
                                             style:PopupWindowStyleCautionWindow];
        
        return;
    }


    // Navigation Flow
    if (self.deviceModel.deviceType == DeviceTypeSomfyBlinds) {
        MessageWithButtonsViewController *vc = [[DeviceUnpairingManager sharedInstance] productInfoRemovalWithDevice:self.deviceModel];
        if (vc) {
            self.removeThisDeviceButton.enabled = YES;

            [self.navigationController pushViewController:vc animated:YES];
        }

        return; // Exit early
    }

    // Popup Flow
    if (self.deviceModel.deviceType == DeviceTypeGarageDoorController ||
        self.deviceModel.deviceType == DeviceTypeSomfyBlindsController ||
        self.deviceModel.deviceType == DeviceTypeHueBridge) {
        title = NSLocalizedString(@"MULTIPLE DEVICES PAIRED", nil);
        subText = NSLocalizedString(@"Removing this parent device will also \nremove any child devices \ncontrolled through this device.\n\nARE YOU SURE?", nil);
    }
    else {
        title = NSLocalizedString(@"ARE YOU SURE?", nil);
    }
    
    PopupSelectionButtonModel *yesModel = [PopupSelectionButtonModel create:NSLocalizedString(@"YES", nil)
                                                                      event:@selector(doRemoveDevice)];
    PopupSelectionButtonModel *noModel = [PopupSelectionButtonModel create:NSLocalizedString(@"NO", nil)
                                                                     event:nil];
    
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:title
                                                                              subtitle:subText
                                                                                button:yesModel, noModel, nil];
    buttonView.owner = self;
    
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:buttonView
                                         owner:self
                                 closeSelector:nil
                                         style:PopupWindowStyleCautionWindow];
}

- (IBAction)contactSupport:(id)sender {
    NSString *phNo = @"+18554694747";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (void)doRemoveDevice {
    [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesMoreRemove];
  
    self.removeThisDeviceButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([self.deviceModel isKindOfClass:[HubModel class]]) {
            // Don't do anything to remove a HUB
            // A message was shown to the user previously and this case shouldn't occur
            // Check blame/history for hub removal code
        }
        else if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MessageWithButtonsViewController *vc = [[DeviceUnpairingManager sharedInstance] startRemovingDevice:self.deviceModel];
                if (vc) {
                    self.removeThisDeviceButton.enabled = YES;

                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    self.removeThisDeviceButton.enabled = YES;
                    [self displayErrorMessage:NSLocalizedStringFromTable(@"Device could not be removed.", @"ErrorMessages", nil)];
                }
            });
        }
    });
}

- (void)setDefineForTiltSensor:(NSNumber *)define {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DeviceController setTiltClosedPosition:(define.integerValue == 0) onModel:self.deviceModel].then(^(NSObject *obj) {
            for (NSMutableDictionary *dic in self.modeArray) {
                if (((NSNumber *)dic[@"tag"]).integerValue == DeviceMoreControllerTypeTiltSetting) {
                    [dic setObject:(define.integerValue == 0)?@"Horizontal":@"Vertical" forKey:@"sideValueBold"];
                    break;
                }
            }
            [self.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *dic = [self.modeArray objectAtIndex:indexPath.item];
    [cell setData:[dic objectForKey:@"title"] secondText:[dic objectForKey:@"text"] iconType:[[dic objectForKey:@"icon"] integerValue]];
    cell.tag = [[dic objectForKey:@"tag"] integerValue];
    
    if (cell.tag == DeviceMoreControllerTypeContactSetting &&
        [self.deviceModel.caps containsObject:[ContactCapability namespace]]) {
        
        NSString *hint = [ContactCapability getUsehintFromModel:self.deviceModel];
        [cell.settingsLabel styleSet:hint
                       andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
        
    } else if ([dic objectForKey:@"sideValue"]) {
        [cell.settingsLabel styleSet:[dic objectForKey:@"sideValue"]
                       andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    
    } else if ([dic objectForKey:@"sideValueBold"]) {
        if (dic[@"sideValueBold"]) {
            NSDictionary *settingsAttributes = [FontData getWhiteFontWithSize:13.0f
                                                                         bold:YES
                                                                      kerning:0.0f];
            cell.settingsLabel.attributedText = [[NSAttributedString alloc] initWithString:dic[@"sideValueBold"]
                                                                                attributes:settingsAttributes];
        }
    } else if (cell.tag == DeviceMoreControllerTypeHubReboot) {
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.primaryButton.hidden = false;
      cell.settingsLabel.hidden = true;
      cell.mainTextLabel.hidden = true;
      cell.secondaryTextLabel.hidden = true;
      cell.disclosureImage.hidden = true;
      [cell.primaryButton styleSet:NSLocalizedString(@"Reboot Hub", nil)
                     andButtonType:FontDataTypeButtonLight
                         upperCase:YES];
      [cell.primaryButton addTarget:self
                             action:@selector(hubRebootButtonPressed:)
                   forControlEvents:UIControlEventTouchUpInside];
      UIImage *backgroundColor = [UIColor UIImageWithColor:[UIColor colorWithWhite:0.6 alpha:1.0]];
      [cell.primaryButton setBackgroundImage:backgroundColor forState:UIControlStateDisabled];
      cell.cellSeperator.hidden = true;
      HubModel *hubModel = [[[CorneaHolder shared] settings] currentHub];
      if (hubModel == nil ||
          [hubModel isDeviceOffline] ||
          ![[HubCapability getStateFromModel:hubModel] isEqualToString:kEnumHubStateNORMAL]) {
        [cell.primaryButton setEnabled:false];
      } else {
        [cell.primaryButton  setEnabled:true];
      }
    }
    else {
        [cell.settingsLabel setHidden:YES];
    }
    
    [cell.disclosureImage setHidden:[[dic objectForKey:@"hideAccessory"] boolValue]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *currectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIViewController *vc;
    switch (currectCell.tag) {
        case DeviceMoreControllerTypeFavorites:
            [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesFav];
            [FavoriteController toggleFavorite:self.deviceModel];
            break;
            
        case DeviceMoreControllerTypeProductInformation:
            vc = [DeviceProductInformationViewController createWithDevice:self.deviceModel];
            break;
            
        case DeviceMoreControllerTypeNameAndPhoto:
            vc = [DeviceTextfieldViewController createWithDeviceModelFromDeviceDetail:self.deviceModel];
            break;
            
        case DeviceMoreControllerTypeRenameAndAssignment:
            vc = [DeviceRenameAssignmentController createWithDeviceModel:self.deviceModel];
            break;

        case DeviceMoreControllerTypeNameAndPhotoHalo:
            vc = [HaloNamePhotoRoomViewController createWithDeviceModel:self.deviceModel];
            break;

        case DeviceMoreControllerTypeTest:
            vc = [DeviceTestViewController create];
            break;
            
        case DeviceMoreControllerTypeConnectivityAndPower:
            vc = [DeviceConnectivityAndPowerViewController createWithDeviceModel:self.deviceModel];
            break;
            
        case DeviceMoreControllerTypeAdvanced:
            vc = [DeviceAdvancedViewController createWithDeviceModel:self.deviceModel];
            break;
            
        case DeviceMoreControllerTypeTiltSetting: {
            [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesSettings];
            BOOL isHorizontal = [DeviceController isCurrentTiltClosedPositionHorizontal:self.deviceModel];
            
            NSMutableArray *models = [NSMutableArray array];
            [models addObject:[PopupSelectionModel create:@"Horizontal (EX:Garage Door)" selected:isHorizontal obj:@(0)]];
            [models addObject:[PopupSelectionModel create:@"Vertical (EX:Jewelry box)" selected:!isHorizontal obj:@(1)]];
            
            PopupSelectionTitleTableView *popupSelection = [PopupSelectionTitleTableView create:@"Tilt Sensor Setting" data:models];
            [self popup:popupSelection complete:@selector(setDefineForTiltSensor:)];
            
        }
            break;
            
        case DeviceMoreControllerTypeContactSetting:
        {
            [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesSettings];
            if ([self.deviceModel.caps containsObject:[ContactCapability namespace]]) {
                NSMutableArray *models = [NSMutableArray array];
                [models addObject:[PopupSelectionModel create:@"Door" obj:@"DOOR"]];
                [models addObject:[PopupSelectionModel create:@"Window" obj:@"WINDOW"]];
                [models addObject:[PopupSelectionModel create:@"Other" obj:@"OTHER"]];
                for (PopupSelectionModel *selection in models) {
                    NSString *hint =  [ContactCapability getUsehintFromModel:self.deviceModel];
                    if ([hint isEqualToString:[selection.title uppercaseString]]) {
                        [selection setChecked:YES];
                    }
                }
                PopupSelectionTitleTableView *popupSelection = [PopupSelectionTitleTableView create:@"Choose One" data:models];
                [self popup:popupSelection complete:@selector(completedSelected:)];
            }
        }
            break;
        case DeviceMoreControllerTypeSetting:
        {
            [ArcusAnalytics tagWithNamed: AnalyticsTags.DevicesSettings];
            if (self.deviceModel.deviceType == DeviceTypeKeyFob) {
                if ([self.deviceModel instances].count >  0) {
                    vc = [KeyFobRulesListViewController create:self.deviceModel];
                }
                else {
                    vc = [KeyFobRuleSettingButtonController create:ButtonTypeCircle device:self.deviceModel];
                }
            }
            else if (self.deviceModel.deviceType == DeviceTypeButton) {
                vc = [KeyFobRuleSettingButtonController create:ButtonTypeNone device:self.deviceModel];
                [(KeyFobRuleSettingButtonController *)vc setPopupStyle:NO];
            }
            else {
                vc = [DeviceSettingsViewController createWithDeviceModel:self.deviceModel];
            }
        }
            break;
            
        case DeviceMoreControllerTypeGarageDoors: {
            DeviceMoreConnectDeviceListViewController *garageDoorsController = [DeviceMoreConnectDeviceListViewController create];
            garageDoorsController.deviceList = [self connectedDevicesForGarageController:self.deviceModel];
            vc = garageDoorsController;
            
            break;
        }
            
        case DeviceMoreControllerTypePetDoorSmartKeys:
            vc = [SimpleTableViewController createWithNewStyle:YES andDelegate:[[DevicePetdoorSmartKeysSimpleDelegate alloc] initWithDeviceModel:self.deviceModel]];
            break;

        case DeviceMoreControllerTypeHoneywellThermostat: {
            vc = [DeviceHoneywellConnectViewController create];
        }
            break;
        case DeviceMoreControllerTypeSomfyBlindsSetting: {
            vc = [DeviceSomfyBlindsSettingsViewController createWithDevice:[self.deviceModel address]];
        }
            break;

        case DeviceMoreControllerTypeNetworkConnection: {
            if (self.deviceModel.deviceType == DeviceTypeSwitch && self.deviceModel.hasWiFiCapability) {
                if ([self.deviceModel.productId isEqualToString:Constants.kWifiSmartSwitchId]) {
                    vc = [DeviceWifiSwitchConnectionSettingsViewController create:self.deviceModel];
                } else {
                    BLEDeviceNetworkSettingsViewController *networkSettingsVC = [BLEDeviceNetworkSettingsViewController create];
                    networkSettingsVC.deviceModel = self.deviceModel;
                    vc = networkSettingsVC;
                }
            }
        }
            break;

        case DeviceMoreControllerTypeHaloTesting: {
            vc = [HaloTestingViewController create:self.deviceModel];
        }
            break;

        case DeviceMoreControllerTypeHaloWeatherAlerts: {
            vc = [HaloWeatherAlertsViewController create:self.deviceModel];
       }
            break;

        case DeviceMoreControllerTypeHaloWeatherRadio: {
            vc = [HaloWeatherRadioSetupViewController create:self.deviceModel];
        }
            break;

        default:
            break;
    }
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)hubRebootButtonPressed:(UIButton *)sender {
  HubModel *hubModel = [[[CorneaHolder shared] settings] currentHub];
  if (hubModel != nil) {
    [self createGif];
    [sender setEnabled:false];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
      [HubAdvancedCapability rebootOnModel:hubModel]
      .then(^(HubAdvancedRestartResponse *res) {
        // NOTE: we dont enable the button here because we will let the hub state drive changes to the button
        // see logic in `cellForRowAtIndexPath:`
        [self hideGif];
      })
      .catch(^(NSError *error) {
        [self hideGif];
        [sender setEnabled:true];
        [self displayErrorMessage:error.localizedDescription withTitle:@"Failed to reboot"];
      });
    });
  }
}

- (NSArray *)connectedDevicesForGarageController:(DeviceModel *)controllerModel {
    NSMutableArray *mutableDevices = [[NSMutableArray alloc] init];
    
    NSString *protocolId = [DeviceAdvancedCapability getProtocolidFromModel:controllerModel];
    
    for (DeviceModel *deviceModel in [[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]]) {
        NSString *parentProtocolId = [BridgeChildCapability getParentAddressFromModel:deviceModel];
        
        if (parentProtocolId) {
            protocolId = [@"PROT:IPCD:" stringByAppendingString:protocolId];
            if ([parentProtocolId isEqualToString:protocolId]) {
                [mutableDevices addObject:deviceModel];
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableDevices];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)completedSelected:(id)selectValue {
    if (selectValue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ContactCapability setUsehint:selectValue onModel:self.deviceModel];
            [self.deviceModel commit];
        });
    }
}

#pragma mark - Parse Data
- (void)parseData {
    if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
        [self buildSettingsForDevice:self.deviceModel];
    }
    else if ([self.deviceModel isKindOfClass:[HubModel class]]) {
        [self buildSettingsForHub:(HubModel *)self.deviceModel];
    }
}

- (void)buildSettingsForHub:(HubModel *)model {
    NSArray *result = @[
                        [[NSMutableDictionary alloc] initWithDictionary:@{@"title": [((HubModel *)model) name], @"text":@"Edit Name & Photo", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeNameAndPhoto)}],
                        [[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"PRODUCT INFORMATION", @"text":@"Manufacturer, Model Number & More", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeProductInformation)}],
                        [[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"CONNECTIVITY & POWER", @"text":@"Online & Power Info", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeConnectivityAndPower)}],
                        [[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"FIRMWARE", @"text":@"Firmware, IP Address & Wireless Info", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeAdvanced)}],
                        ];
    NSMutableArray *modeArray = [[NSMutableArray alloc] initWithArray:result];

    HubModel *hubModel = [[[CorneaHolder shared] settings] currentHub];
    if (hubModel != nil && [[hubModel caps] containsObject:[HubAdvancedCapability namespace]]){
        [modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"icon":@(3), @"tag":@(DeviceMoreControllerTypeHubReboot)}]];
    }
    self.modeArray = modeArray;
}

- (void)buildSettingsForDevice:(DeviceModel *)model {
    self.modeArray = [[NSMutableArray alloc] init];
    
    [self addWifiSetting:model];
    [self addFavoriteSetting:model];
    [self addNameEditPhotoSetting:model];
    [self addGarageDoorSettings:model];
    [self addPetDoorSmartKeySettings:model];
    [self addMoreSetting:model];
    [self addSomfyBlindsSettings:model];
    [self addWifiSmartSwitchSettings:model];
    [self addHaloSettings:model];
    
    [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"PRODUCT INFORMATION", @"text":@"Model Number, Purchase Date & More", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeProductInformation)}]];
    
}

- (void)addWifiSetting:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeWaterHeater) {
        NSString *ssid = ([WiFiCapability getSsidFromModel:model] == nil) ? @"": [WiFiCapability getSsidFromModel:model];
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"WI-FI NETWORK", @"text":@"If this device is connected to the incorrect \nWi-Fi Network. please update it on the device.", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeNothing),@"sideValue":ssid, @"hideAccessory":@(YES)}]];
    }
}

- (void)addFavoriteSetting:(DeviceModel *)model {
    if (model.deviceType != DeviceTypeGarageDoorController && model.deviceType != DeviceTypeSomfyBlindsController) {
        NSNumber *iconType = [FavoriteController modelIsFavorite:model] ? @(1) : @(2);
        [self.modeArray addObject: [[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"FAVORITES", @"text":@"Add to Favorites", @"icon":iconType, @"tag":@(DeviceMoreControllerTypeFavorites)}]];
    }
}

- (void)addNameEditPhotoSetting:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeKeyFob || model.deviceType == DeviceTypeCarePendant) {
        [self.modeArray addObject: [[NSMutableDictionary alloc] initWithDictionary:@{@"title": model.name, @"text":@"Edit Name, Photo & Assignment", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeRenameAndAssignment)}]];
    }
    else if (model.deviceType == DeviceTypeHalo) {
        [self.modeArray addObject: [[NSMutableDictionary alloc] initWithDictionary:@{@"title": model.name, @"text":@"Edit Name, Photo & Room", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeNameAndPhotoHalo)}]];
    }
    else {
        [self.modeArray addObject: [[NSMutableDictionary alloc] initWithDictionary:@{@"title": model.name, @"text":@"Edit Name & Photo", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeNameAndPhoto)}]];
    }
}

- (void)addMoreSetting:(DeviceModel *)model {
    if ([DeviceSettingPackage hasSetting:model] && [[DeviceSettingPackage generateDeviceSetting:model controlOwner:self] shouldDisplay]) {
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"SETTINGS", @"text":[NSString stringWithFormat:@"%@ Configurations", [model.name capitalizedString]], @"icon":@(0), @"tag":@(DeviceMoreControllerTypeSetting)}]];
    }
    
    if (model.deviceType == DeviceTypeContactSensor) {
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"SETTINGS", @"text":@"Is this contact sensor being used\nas a door or a window?", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeContactSetting)}]];
    } else if (model.deviceType == DeviceTypeTiltSensor) {
        BOOL isHorizontal = [DeviceController isCurrentTiltClosedPositionHorizontal: model];
        
        NSDictionary *tiltSensorConfig = @{@"title" : @"ORIENTATION",
                                           @"text" : @"Door is Open When...",
                                           @"sideValueBold": isHorizontal ? @"Horizontal" : @"Vertical",
                                           @"icon":@(0),
                                           @"tag":@(DeviceMoreControllerTypeTiltSetting)};
        
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:tiltSensorConfig]];
    }
    else if (model.deviceType == DeviceTypeButton) {
        NSString *productID = [DeviceCapability getProductIdFromModel:model];
        if (productID && ([productID isEqualToString:@"4fccbb"] || [productID isEqualToString:@"486390"] ||
                          [productID isEqualToString:@"bca135"] || [productID isEqualToString:@"bbf1cf"])) {
            [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"SETTINGS", @"text":[NSString stringWithFormat:@"%@ Configurations", [model.name capitalizedString]], @"icon":@(0), @"tag":@(DeviceMoreControllerTypeSetting)}]];
        }
    }
}

- (void)addGarageDoorSettings:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeGarageDoorController) {
        
        NSString *wifiNetwork = [WiFiCapability getSsidFromModel:self.deviceModel];
        wifiNetwork = (!wifiNetwork) ? @"" : wifiNetwork;
        [self.modeArray addObject:@{@"title" : @"WI-FI NETWORK",
                                    @"text" : @"If the device is connected to the incorrect wi-fi network, please update it on the device.",
                                    @"sideValue" : wifiNetwork,
                                    @"icon": @(0),
                                    @"hideAccessory" : @(1),
                                    @"tag":@(DeviceMoreControllerTypeNetworkConnection)}];
        
        if ([self connectedDevicesForGarageController:self.deviceModel].count != 0) {
            [self.modeArray addObject:@{@"title" : @"GARAGE DOORS",
                                        @"text" : @"Doors connected to this device.",
                                        @"icon":@(0),
                                        @"tag":@(DeviceMoreControllerTypeGarageDoors)}];       
        }
    }
}

- (void)addPetDoorSmartKeySettings:(DeviceModel *)model {
    if (model.deviceType == DeviceTypePetDoor) {
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"SMART KEYS", @"text":@"See Which Smart Keys Have Access", @"icon":@(0), @"tag":@(DeviceMoreControllerTypePetDoorSmartKeys)}]];
    }
}

- (void)addSomfyBlindsSettings:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeSomfyBlinds) {
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"SETTINGS", @"text":@"Blind Configuration", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeSomfyBlindsSetting)}]];
    }
}

- (void)addHaloSettings:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeHalo) {
        [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"Testing", @"text":@"Test your Halo Device", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeHaloTesting)}]];

        if ([model isHaloPlus]) {
            [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"Weather Alerts", @"text":@"Manage Weather & Emergency Alerts", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeHaloWeatherAlerts)}]];
            [self.modeArray addObject:[[NSMutableDictionary alloc] initWithDictionary:@{@"title": @"Weather Radio", @"text":@"Configure Your Weather Radio Station", @"icon":@(0), @"tag":@(DeviceMoreControllerTypeHaloWeatherRadio)}]];

        }
    }
}

- (void)addWifiSmartSwitchSettings:(DeviceModel *)model {
    if (model.deviceType == DeviceTypeSwitch) {
        if (model.hasWiFiCapability) {
            NSString *wifiNetwork = [WiFiCapability getSsidFromModel:self.deviceModel];
            wifiNetwork = (!wifiNetwork) ? @"" : wifiNetwork;
            [self.modeArray addObject:@{@"title" : @"WI-FI & NETWORK SETTINGS",
                                        @"text" : @"Manage your Network Settings",
                                        @"icon": @(0),
                                        @"hideAccessory" : @(0),
                                        @"tag":@(DeviceMoreControllerTypeNetworkConnection)}];

        }
    }
}

#pragma mark - Notification
- (void)favoriteChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.modeArray[0] setValue:[FavoriteController modelIsFavorite:self.deviceModel] ? @(1) : @(2) forKey:@"icon"];
        [self.tableView reloadData];
    });
}

- (void)nameChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self parseData];
        [self.tableView reloadData];
    });
}

- (void)contactUseHintChanged:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)deviceListChanged:(NSNotification *)note {
    if ([note.name isEqualToString:Constants.kModelAddedNotification]) {
        return;
    }
    // Only pop to DeviceListViewController if the current controller is the topViewController
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if ([topViewController isKindOfClass:[DeviceDetailsTabBarController class]]) {
        if ([DeviceManager instance].devices.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.deviceModel.address isEqualToString:((DeviceModel*)note.object).address]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - Can select

- (BOOL)canSelect:(DeviceModel *)deviceModel {
    // Not all device models are device models... some are hub models which do respond to isUpdatingFirmware.
    return ![deviceModel respondsToSelector:@selector(isUpdatingFirmware)] ||
        ![deviceModel isUpdatingFirmware];
}

#pragma mark - TabBar Delegate

- (void)deviceChanged:(DeviceModel *)deviceModel {
    self.deviceModel = deviceModel;
}

@end
