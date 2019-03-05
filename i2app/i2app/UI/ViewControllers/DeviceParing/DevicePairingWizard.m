//
//  DevicePairingWizard.m
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
//
//  Wizard class that receives a data structure from Cornia that contains the
//  the steps for pairing of a specific device or hub.
//  These steps will be used to create a template UIViewController of certain type
//
//  This class implements the Factory design pattern
//

#import <i2app-Swift.h>
#import "DeviceCapability.h"
#import "Capability.h"
#import "DeviceController.h"
#import "ProductCatalogController.h"
#import "ProductCapability.h"
#import "HoneywellC2CViewController.h"
#import "DevicePairingWizard.h"
#import "BaseDeviceStepViewController.h"
#import "DeviceTextfieldViewController.h"
#import "SearchHubViewController.h"
#import "SearchDeviceParingViewController.h"
#import "HubSuccessViewController.h"
#import "NSString+Formatting.h"
#import "ImagePaths.h"
#import "ContactCapability.h"
#import "KeyfobPairingViewController.h"
#import "SmartButtonSelectionController.h"
#import "PairedHubAlreadyForActionViewController.h"
#import "ContactSensorPairingSelectionViewController.h"
#import "PairingFavoriteViewController.h"
#import "VentExtraStepViewController.h"
#import "TiltSensorPairingStepViewController.h"
#import "PairingStep.h"
#import "DevicePairingFormEntryViewController.h"
#import "PairingExtraFinalStepViewController.h"
#import "FoundDevicesViewController.h"
#import "SmartFobPairingSelectionController.h"
#import "SmartFobPairingSelectionDetailController.h"
#import "WaterHeaterTemperatureViewController.h"
#import "WaterHeaterReminderViewController.h"
#import "LawnNGardenPairingZoneListViewController.h"
#import "LawnNGardenPairingZoneDetailsViewController.h"
#import "IrrigationControllerCapability.h"
#import "DevicePostPairingInstructionsViewController.h"
#import "DeviceRenameAssignmentController.h"
#import <i2app-Swift.h>
#import "DeviceRenamePetSmartKeyViewController.h"
#import "SmartPetTokenPairingViewController.h"

@interface DevicePairingWizard ()

@property (assign, atomic) NSInteger currentStepIndex;
@property (strong, nonatomic) NSMutableArray *pairingSteps;
@property (weak, nonatomic, readonly) DeviceModel *deviceModel;

@end


@implementation DevicePairingWizard

NSString *const kNyceHingeProductId = @"76e484";
NSString *const kHaloProductId = @"784506";

@dynamic videoID;
@dynamic deviceModel;


/// Check to see if the App Version is greater than the min app version required
+ (BOOL)isAppUpgradeNeeded:(DeviceProductCatalog *)productCatalog {
    BOOL upgradeNeeded = NO;

  NSString *address = [ProductModel addressForId:productCatalog.productId];
    ProductModel *productModel = (ProductModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    if (productModel != nil) {
        NSString *minAppVersionRequired = [ProductCapability getMinAppVersionFromModel:productModel];
        // Check min app version is not an attribute of the product catalog
        if (![minAppVersionRequired isEqual:[NSNull null]] && minAppVersionRequired.length != 0) {
            NSArray *minAppVersionRequiredArray = [minAppVersionRequired componentsSeparatedByString:@"."];
            NSArray *currentAppVersionArray = [[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];

            return [DevicePairingWizard isVersion:currentAppVersionArray olderThanVersion:minAppVersionRequiredArray];
        }
    }

    return upgradeNeeded;
}

+ (BOOL) isVersion:(NSArray*)version olderThanVersion:(NSArray*)minVersion {
    int versionMajor = [version count] >= 1 ? [version[0] intValue] : 0;
    int versionMinor = [version count] >= 2 ? [version[1] intValue] : 0;
    int versionMaint = [version count] >= 3 ? [version[2] intValue] : 0;
    
    int minMajor = [minVersion count] >= 1 ? [minVersion[0] intValue] : 0;
    int minMinor = [minVersion count] >= 2 ? [minVersion[1] intValue] : 0;
    int minMaint = [minVersion count] >= 3 ? [minVersion[2] intValue] : 0;
    
    return  (minMajor > versionMajor) ||
            (minMajor == versionMajor && minMinor > versionMinor) ||
            (minMajor == versionMajor && minMinor == versionMinor && minMaint > versionMaint);
}

+ (UIViewController *)createHubPairingSteps:(BOOL)animated {
    
    [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddHub;
    
    PairingStep *hubStep1 = [[PairingStep alloc] init];
    hubStep1.stepType = PairingStepBase;
    hubStep1.stepIndex = 0;
    hubStep1.title = @"Add a Hub";
    hubStep1.imageUrl = @"HubStep1";
    hubStep1.mainStep = @"Remove the battery cover, insert the included backup batteries, then reattach the cover.";
    hubStep1.secondStep = @"These directions must be\nfollowed sequentially.";
    
    PairingStep *hubStep2 = [[PairingStep alloc] init];
    hubStep2.stepType = PairingStepBase;
    hubStep2.stepIndex = 1;
    hubStep2.title = @"Add a Hub";
    hubStep2.imageUrl = @"HubStep2";
    hubStep2.mainStep = @"Plug one end of the supplied ethernet cable into your router.";
    hubStep2.secondStep = @"These directions must be\nfollowed sequentially.";
    
    PairingStep *hubStep3 = [[PairingStep alloc] init];
    hubStep3.stepType = PairingStepBase;
    hubStep3.stepIndex = 2;
    hubStep3.title = @"Add a Hub";
    hubStep3.imageUrl = @"HubStep3";
    hubStep3.mainStep = @"Plug the other end\ninto the Hub.";
    hubStep3.secondStep = @"These directions must be\nfollowed sequentially.";
    
    PairingStep *hubStep4 = [[PairingStep alloc] init];
    hubStep4.stepType = PairingStepBase;
    hubStep4.stepIndex = 3;
    hubStep4.title = @"Add a Hub";
    hubStep4.imageUrl = @"HubStep4";
    hubStep4.mainStep = @"Insert the supplied power\ncable into the Hub.";
    hubStep4.secondStep = @"These directions must be\nfollowed sequentially.";
    
    PairingStep *hubStep5 = [[PairingStep alloc] init];
    hubStep5.stepType = PairingStepBase;
    hubStep5.stepIndex = 4;
    hubStep5.title = @"Add a Hub";
    hubStep5.imageUrl = @"HubStep5";
    hubStep5.mainStep = @"Plug the power cable\ninto a power outlet.";
    hubStep5.secondStep = @"These directions must be\nfollowed sequentially.";
    
    PairingStep *hubStepEnterId = [[PairingStep alloc] init];
    hubStepEnterId.stepType = PairingStepEnterHubId;
    hubStepEnterId.stepIndex = 5;
    hubStepEnterId.title = @"Add a Hub";
    hubStepEnterId.imageUrl = @"HubStep6";
    hubStepEnterId.mainStep = @"Enter the Hub ID found at the bottom of the Hub.";
    hubStepEnterId.secondStep = @"ABC-1234";
    
    PairingStep *hubStepSearch = [[PairingStep alloc] init];
    hubStepSearch.stepType = PairingStepHubSearch;
    
    PairingStep *hubStepNameAndPhoto = [[PairingStep alloc] init];
    hubStepNameAndPhoto.stepType = PairingStepNameAndPhoto;
    hubStepNameAndPhoto.stepIndex = 6;
    hubStepNameAndPhoto.title = @"Add a Hub";
    hubStepNameAndPhoto.imageUrl = @"HubStep7";
    hubStepNameAndPhoto.mainStep = @"Name your hub\nand add a photo if you like.";
    hubStepNameAndPhoto.secondStep = @"Hub Name";
    
    PairingStep *hubStepSuccess = [[PairingStep alloc] init];
    hubStepSuccess.stepType = PairingStepHubSuccess;
    
    NSArray *pairingSteps = @[hubStep1,
                              hubStep2,
                              hubStep3,
                              hubStep4,
                              hubStep5,
                              hubStepEnterId,
                              hubStepSearch,
                              hubStepNameAndPhoto,
                              hubStepSuccess];
    
    [DevicePairingManager sharedInstance].pairingWizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                                                                           withDeviceType:DeviceTypeHub
                                                                                            withVideoLink:[[NSURL VideoHubPairing] absoluteString]];
    
    UIViewController *vc = [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:animated];
    [vc setBackgroundColorToDashboardColor];
    [vc addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    return vc;
}

+ (void)runPostPostPairingWizard:(id)sender {
    if ([DevicePairingManager sharedInstance].isPostPostPairing) {
       [DevicePairingManager sharedInstance].isPostPostPairing = NO;
       [[sender navigationController] popToRootViewControllerAnimated:YES];
      return;
    } else {
      [DevicePairingManager sharedInstance].isPostPostPairing = YES;
    }
    
    NSMutableArray *postPostSteps = [[NSMutableArray alloc] init];

    [DevicePairingWizard addNewProMonAlarmActivatedStep:postPostSteps];
    [DevicePairingWizard addZWaveHealRecommendedPairingStep:postPostSteps];

    DevicePairingWizard *wizard = [[DevicePairingWizard alloc] initWithDeviceData:postPostSteps
                                              withDeviceType:DeviceTypeNone
                                               withVideoLink:nil];

    [DevicePairingManager sharedInstance].pairingWizard = wizard;

    if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
        [[DevicePairingManager sharedInstance] resetAllPairingStates];
        [[sender navigationController] popToRootViewControllerAnimated:YES];
    }
  
}

+ (void)runLutronCustomPairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                       deviceType:(DeviceType)deviceType {
  [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddOneDevice;
  NSMutableArray *pairingSteps = [[NSMutableArray alloc] init];
  DevicePairingWizard *wizard;

  [self addLutronCasetaSmartBridgeStepsWithPairingSteps:pairingSteps];

  [self addNewProMonAlarmActivatedStep:pairingSteps];
  [self addZWaveHealRecommendedPairingStep:pairingSteps];

  wizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                            withDeviceType:deviceType
                                             withVideoLink:deviceProductCatalog ? deviceProductCatalog.videoURL : nil];

  [DevicePairingManager sharedInstance].pairingWizard = wizard;
  if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
    [[DevicePairingManager sharedInstance] resetAllPairingStates];
    [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
  }
}

+ (void)runNestCustomPairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                     deviceType:(DeviceType)deviceType {
  [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddOneDevice;
  NSMutableArray *pairingSteps = [[NSMutableArray alloc] init];
  DevicePairingWizard *wizard;
  
  [self addNestStepsWithPairingSteps:pairingSteps];
  
  [self addNewProMonAlarmActivatedStep:pairingSteps];
  [self addZWaveHealRecommendedPairingStep:pairingSteps];
  
  wizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                            withDeviceType:deviceType
                                             withVideoLink:deviceProductCatalog ? deviceProductCatalog.videoURL : nil];
  
  [DevicePairingManager sharedInstance].pairingWizard = wizard;
  if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
    [[DevicePairingManager sharedInstance] resetAllPairingStates];
    [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
  }
}

+ (void)runSinglePairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                 deviceType:(DeviceType)deviceType {
    
    [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddOneDevice;
    NSMutableArray *pairingSteps = [[NSMutableArray alloc] init];
    DevicePairingWizard *wizard;
    
    // Normal pairing flow
    for (int i = 0; i < deviceProductCatalog.pairingSteps.count; i++) {
        
        PairingStep *pairingStep = [[PairingStep alloc] init];
        pairingStep.stepType = [deviceProductCatalog getPairingTypeFromPairingSteps:i];
        pairingStep.stepIndex = i;
        pairingStep.title = [deviceProductCatalog productName];
        pairingStep.imageUrl = [deviceProductCatalog getImageURLFromPairingSteps:i + 1];
        pairingStep.mainStep = [deviceProductCatalog getTextFromPairingSteps:i];
        pairingStep.secondStep = [deviceProductCatalog getSecondaryTextFromPairingSteps:i];
        pairingStep.target = [deviceProductCatalog targetForDevicePairingStep:i];
        pairingStep.productCatalog = deviceProductCatalog;
        
        if (pairingStep.stepType == PairingStepInput) {
            pairingStep.inputsArray = [deviceProductCatalog devicePairingStepInputs:i];
        }
        
        [pairingSteps addObject:pairingStep];
    }
    
    if (deviceType == DeviceTypeThermostatHoneywellC2C) {
        [self addHoneywellC2CStepsWithPairingSteps:pairingSteps];

        [self addFavoritePairingStep:pairingSteps];
    } else if (deviceType == DeviceTypeThermostatNest) {

        [self addNestStepsWithPairingSteps:pairingSteps];

    } else if (deviceType == DeviceTypeLutronCasetaSmartBridge ||
               [@[@"d8ceb2", @"7b2892", @"3420b0", @"0f1b61", @"e44e37"]
                containsObject:deviceProductCatalog.productId]) {

      [self addLutronCasetaSmartBridgeStepsWithPairingSteps:pairingSteps];

    } else if (deviceType == DeviceTypeWaterHeater) {
        // the WaterHeater last step from the catalog needs to include the error message
        // that needs to be displayed if the water heater is not found
        PairingStep *lastStep = pairingSteps.lastObject;
        lastStep.errorMessage = NSLocalizedString(@"Water heater pairing error", nil);
        [self addSearchStepWithProtoFamily:deviceProductCatalog.protoFamily
                                      name:deviceProductCatalog.productName
                           andPairingSteps:pairingSteps];
        
        [self addWaterHeaterCustomPairingStepsWithPairingSteps:pairingSteps];
    } else if (deviceType == DeviceTypeIrrigation) {
        [self addSearchStepWithProtoFamily:deviceProductCatalog.protoFamily
                                      name:deviceProductCatalog.productName
                           andPairingSteps:pairingSteps];
      
        [self addFavoritePairingStep:pairingSteps];
        [self addLNGCustomPairingStepsWithPairingSteps:pairingSteps];
    } else if (deviceType == DeviceTypeAlexa) {
        [self replaceAlexaPairingSteps:pairingSteps];
    } else if (deviceType == DeviceTypeGoogleHomeAssistant) {
      [self replaceGoogleHomeAssistantPairingSteps:pairingSteps];
    } else if (deviceType == DeviceTypeWifiSwitch) {
        [self wifiSmartPlugPairingSteps:pairingSteps
                         productCatalog:deviceProductCatalog];
    } else {
        [self addSearchStepWithProtoFamily:deviceProductCatalog.protoFamily
                                      name:deviceProductCatalog.productName
                           andPairingSteps:pairingSteps];

        if (deviceType == DeviceTypeHalo) {
            if ([deviceProductCatalog.arcusProductId isEqualToString:kHaloProductId]) {
                [self addHaloCustomPairingSteps:pairingSteps];
            }
            else {
                [self addHaloPlusCustomPairingSteps:pairingSteps];
            }
        }
        else if (deviceType == DeviceTypeContactSensor) {
            if ([deviceProductCatalog.productId isEqualToString:kNyceHingeProductId]) {
                [self addNyceHingePairingStep:deviceType
                              andPairingSteps:pairingSteps];
            }
        }
      
        [self addIPCDStepsWithProtoFamily:deviceProductCatalog.protoFamily
                                     name:deviceProductCatalog.productName
                          andPairingSteps:pairingSteps];

        [self addExtraStepsWithDeviceType:deviceType
                          andPairingSteps:pairingSteps];

        [self addFavoritePairingStep:pairingSteps];

        if (deviceType == DeviceTypeWifiSwitch) {
          [self addWifiSmartSwitchPairingSuccessStep:pairingSteps];
        } else {
          [self addPairingSuccessStep:pairingSteps];
        }
    }

    [self addNewProMonAlarmActivatedStep:pairingSteps];
    [self addZWaveHealRecommendedPairingStep:pairingSteps];

    wizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                              withDeviceType:deviceType
                                               withVideoLink:deviceProductCatalog ? deviceProductCatalog.videoURL : nil];

    [DevicePairingManager sharedInstance].pairingWizard = wizard;
    if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
        [[DevicePairingManager sharedInstance] resetAllPairingStates];
      [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    }
}

+ (void)addSearchStepWithProtoFamily:(NSString *)protoFamily
                                name:(NSString *)name
                     andPairingSteps:(NSMutableArray *)pairingSteps {
    if (![protoFamily isEqualToString:@"IPCD"]) {
        PairingStep *searchStep = [[PairingStep alloc] init];
        searchStep.stepType = PairingStepSearch;
        searchStep.stepIndex = 0;
        searchStep.title = name;
        
        [pairingSteps addObject:searchStep];
    }
}

+ (void)addIPCDStepsWithProtoFamily:(NSString *)protoFamily
                               name:(NSString *)name
                    andPairingSteps:(NSMutableArray *)pairingSteps {
    if ([protoFamily isEqualToString:@"IPCD"]) {
        [self addRenameDevicePairingStepWithPairingSteps:pairingSteps andTitle:name];
        
        PairingStep *devicePromoStep = [[PairingStep alloc] init];
        devicePromoStep.stepType = PairingStepPromo;
        [pairingSteps addObject:devicePromoStep];
    }
}

+ (void)wifiSmartPlugPairingSteps:(NSMutableArray *)pairingSteps productCatalog:(DeviceProductCatalog *)catalog {
    [[DevicePairingManager sharedInstance] stopHubPairing];

    PairingStep *wifiStep = [[PairingStep alloc] init];
    wifiStep.stepType = PairingStepWifiSmartPlugWifiSettings;
    wifiStep.stepIndex = 2;
    [pairingSteps addObject:wifiStep];

    PairingStep *settingsStep = [[PairingStep alloc] init];
    settingsStep.stepType = PairingStepWifiSmartPlugExternalSettings;
    settingsStep.target = @"BRDG::IPCD";
    settingsStep.stepIndex = 3;
    settingsStep.productCatalog = catalog;
    [pairingSteps addObject:settingsStep];

    PairingStep *nameStep = [[PairingStep alloc] init];
    nameStep.stepType = PairingStepNameAndPhoto;
    nameStep.productCatalog = catalog;
    [pairingSteps addObject:nameStep];

    PairingStep *schedulerStep = [[PairingStep alloc] init];
    schedulerStep.stepType = PairingStepWifiSmartPlugChooseSchedule;
    [pairingSteps addObject:schedulerStep];

    [self addFavoritePairingStep:pairingSteps];
    
    PairingStep *controlInfoStep = [[PairingStep alloc] init];
    controlInfoStep.stepType = PairingStepWifiSmartPlugSuccess;
    [pairingSteps addObject:controlInfoStep];
}

+ (void)addHoneywellC2CStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
    // Adding Login step
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHWTotalConnect;
    [pairingSteps addObject:pairingStep];
    
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHWTotalConnectDeviceList;
    pairingStep.title = @"Honeywell Thermostat";
    [pairingSteps addObject:pairingStep];
    
    [self addHoneywellC2CLastPairingStepsWithPairingSteps:pairingSteps];
}

+ (void)addHoneywellC2CLastPairingStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
    [self addRenameDevicePairingStepWithPairingSteps:pairingSteps
                                            andTitle:@""];
    
    // Adding Final Instructions step
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepManageDevice;
    [pairingSteps addObject:pairingStep];
}

+ (void)addNestStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
  // Adding Login step
  PairingStep *pairingStep = [PairingStep new];
  pairingStep.stepType = PairingStepNestConnect;
  [pairingSteps addObject:pairingStep];
}

+ (void)addLutronCasetaSmartBridgeStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
  // Adding Lutron Login step
  PairingStep *pairingStep = [PairingStep new];
  pairingStep.stepType = PairingStepLutronCasetaSmartBridge;
  [pairingSteps addObject:pairingStep];
}


+ (void)addWaterHeaterCustomPairingStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
    // Adding Reminder step
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepWaterHeaterReminder;
    [pairingSteps addObject:pairingStep];
    
    // Adding Temperature step
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepWaterHeaterTemperature;
    [pairingSteps addObject:pairingStep];
    
    // Adding Final Instructions step
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepManageDevice;
    [pairingSteps addObject:pairingStep];
}

+ (void)addLNGCustomPairingStepsWithPairingSteps:(NSMutableArray *)pairingSteps {
    // Adding Irrigations Zones list
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepLNGZoneList;
    [pairingSteps addObject:pairingStep];

    // Adding Irrigations Zones Details
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepLNGZoneDetails;
    [pairingSteps addObject:pairingStep];
    
    // Adding Final Instructions step
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepManageDevice;
    [pairingSteps addObject:pairingStep];
}

+ (void)addHaloCustomPairingSteps:(NSMutableArray *)pairingSteps {
    // Adding Room name selection view controller
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloPickRoomName;
    [pairingSteps addObject:pairingStep];

    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloTest;
    pairingStep.title = @"TEST";
    [pairingSteps addObject:pairingStep];
  
    // Adding Final Instructions step
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepManageDevice;
    [pairingSteps addObject:pairingStep];
}

+ (void)addHaloPlusCustomPairingSteps:(NSMutableArray *)pairingSteps {
    // Adding Room name selection view controller
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloPickRoomName;
    [pairingSteps addObject:pairingStep];

    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloPickCounty;
    pairingStep.title = @"CHOOSE YOUR COUNTY";
    [pairingSteps addObject:pairingStep];

    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloPickWeatherRadio;
    pairingStep.title = @"WEATHER RADIO";
    [pairingSteps addObject:pairingStep];

    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepHaloTest;
    pairingStep.title = @"TEST";
    [pairingSteps addObject:pairingStep];
  
    // Adding Final Instructions step
    pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepManageDevice;
    [pairingSteps addObject:pairingStep];
}

+ (void)replaceAlexaPairingSteps:(NSMutableArray *)pairingSteps {
    // Since we're setting up the alexa pairing steps, we need to stop the pairing
    [[DevicePairingManager sharedInstance] stopHubPairing];

    PairingStep *thirdStep = [PairingStep new];
    thirdStep.stepType = PairingStepAlexaSetup;
    [pairingSteps addObject:thirdStep];
}

+ (void)replaceGoogleHomeAssistantPairingSteps:(NSMutableArray *)pairingSteps {
  [[DevicePairingManager sharedInstance] stopHubPairing];
  
  PairingStep *thirdStep = [PairingStep new];
  thirdStep.stepType = PairingStepGoogleHomeAssistantSetup;
  [pairingSteps addObject:thirdStep];
}

+ (void)runMultiplePairingFlowWithDeviceModel:(DeviceModel *)deviceModel
                                andDeviceType:(DeviceType)deviceType {
    
    [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddMultipleFoundDevices;
    
    
    NSMutableArray *pairingSteps = [[NSMutableArray alloc] init];
    DevicePairingWizard *wizard;
    
    if (deviceType == DeviceTypeThermostatHoneywellC2C) {
        [self addHoneywellC2CLastPairingStepsWithPairingSteps:pairingSteps];

        [self addFavoritePairingStep:pairingSteps];

        [self addPairingSuccessStep:pairingSteps];
    } else if (deviceType == DeviceTypeIrrigation) {
        // Multiple pairing flow
        [self addRenameDevicePairingStepWithPairingSteps:pairingSteps
                                                andTitle:deviceModel.name];
      
        [self addFavoritePairingStep:pairingSteps];
        [self addLNGCustomPairingStepsWithPairingSteps:pairingSteps];
        
    } else if (deviceType == DeviceTypeWifiSwitch) {

    } else {
        if (deviceType != DeviceTypeCarePendant) {
            // Multiple pairing flow
            [self addRenameDevicePairingStepWithPairingSteps:pairingSteps
                                                    andTitle:deviceModel.name];
        }

        if (deviceType == DeviceTypeThermostatNest) {
          PairingStep *pairingStepLast = [PairingStep new];
          pairingStepLast.stepType = PairingStepManageDevice;
          [pairingSteps addObject:pairingStepLast];
        }

        if (deviceType == DeviceTypeHalo) {
            if (![deviceModel isHaloPlus]) {
                [self addHaloCustomPairingSteps:pairingSteps];
            }
            else {
                [self addHaloPlusCustomPairingSteps:pairingSteps];
            }
        }
        else if (deviceType == DeviceTypeContactSensor) {
            if ([[DeviceCapability getProductIdFromModel:deviceModel] isEqualToString:kNyceHingeProductId]) {
                [self addNyceHingePairingStep:deviceType
                              andPairingSteps:pairingSteps];
            }
        }
        [self addExtraStepsWithDeviceType:deviceType
                          andPairingSteps:pairingSteps];
        
        [self addFavoritePairingStep:pairingSteps];
      
        [self addPairingSuccessStep:pairingSteps];
    }

    wizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                              withDeviceType:deviceType
                                               withVideoLink:nil];
    [DevicePairingManager sharedInstance].currentDevice = deviceModel;
    
    [DevicePairingManager sharedInstance].pairingWizard = wizard;
    UIViewController *vc = [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
    if (!vc) {
        if ([[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES] == nil) {
            [[DevicePairingManager sharedInstance] resetAllPairingStates];
          [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
            return;
        }
    }

    NSString *productID = [DeviceCapability getProductIdFromModel:deviceModel];
    if (productID.length > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [ProductCatalogController getProductWithId:productID].then(^(ProductModel *product) {
                wizard.videoURL = [ProductCapability getPairVideoUrlFromModel:product];
                if ([vc respondsToSelector:@selector(refreshVideo)]) {
                    [vc performSelector:@selector(refreshVideo)];
                }
            });
        });
    }
}

+ (UIViewController *)createPetDoorSmartKeyPairingSteps:(DeviceModel *)deviceModel {
    [DevicePairingManager sharedInstance].pairingFlowType = PairingFlowTypeAddPetDoorSmartKeys;

    PairingStep *smartKey1 = [[PairingStep alloc] init];
    smartKey1.stepType = PairingStepBase;
    smartKey1.stepIndex = 0;
    smartKey1.title = @"Smart Key";
    smartKey1.imageUrl = @"PetDoorSmartKey_pair1";
    smartKey1.mainStep = @"Insert the battery in the SmartKey.";
    smartKey1.secondStep = @"";

    PairingStep *smartKey2 = [[PairingStep alloc] init];
    smartKey2.stepType = PairingStepPetDoorSearchForSmartKey;
    smartKey2.stepIndex = 1;
    smartKey2.title = @"Smart Key";
    smartKey2.imageUrl = @"PetDoorSmartKey_pair2";
    smartKey2.mainStep = @"Press and hold the LEARN button on the\nPet Door until the green light begins to\nflash, then release the button.";
    smartKey2.secondStep = @"Hold the SmartKey directly below the\ngreen light until the light stops flashing.";

    PairingStep *smartKey3 = [PairingStep new];
    smartKey3.stepType = PairingStepPetDoorAddSmartKey;

    NSArray *pairingSteps = @[smartKey1,
                              smartKey2,
                              smartKey3];

    [DevicePairingManager sharedInstance].pairingWizard = [[DevicePairingWizard alloc] initWithDeviceData:pairingSteps
                                                                                           withDeviceType:DeviceTypeNone
                                                                                            withVideoLink:@""];
    [DevicePairingManager sharedInstance].currentDevice = deviceModel;

    UIViewController *vc = [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
    [vc setBackgroundColorToDashboardColor];
    [vc addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    return vc;
}

+ (NSArray *)getDevTypeForExtraSteps {
    return  @[@(DeviceTypeButton),
              @(DeviceTypeKeyFob),
              @(DeviceTypeCarePendant),
              @(DeviceTypeContactSensor),
              @(DeviceTypeVent),
              @(DeviceTypeTiltSensor),
              @(DeviceTypeSomfyBlinds),
              @(DeviceTypePetDoor),
              @(DeviceTypeThermostat),
              @(DeviceTypeWaterHeater)];
}

+ (void)addExtraStepsWithDeviceType:(DeviceType)deviceType
                    andPairingSteps:(NSMutableArray *)pairingSteps {
    //add extra steps.
    NSArray *extraSteps = [self getDevTypeForExtraSteps];
    
    for (int i = 0; i < extraSteps.count; i++) {
        if ([@(deviceType) isEqual:[extraSteps objectAtIndex:i]]) {
            PairingStep *pairingStep = [[PairingStep alloc] init];
            
            int type = (int)deviceType;
            switch (type) {
                case DeviceTypeButton:
                    pairingStep.stepType = PairingStepSettingButton;
                    break;
                    
                case DeviceTypeKeyFob:
                    pairingStep.stepType = PairingStepAssignPersonToKeyfob;
                    [pairingSteps addObject:pairingStep];
                    pairingStep = [[PairingStep alloc] init];
                    pairingStep.stepType = PairingStepAssignKeyFobButton;
                    break;

                case DeviceTypeCarePendant:
                    pairingStep.stepType = PairingStepAssignPersonToCarePendant;
                    [pairingSteps addObject:pairingStep];
                    pairingStep = [[PairingStep alloc] init];
                    pairingStep.stepType = PairingStepPendantTestCoverage;
                    [pairingSteps addObject:pairingStep];
                    pairingStep = [[PairingStep alloc] init];
                    pairingStep.stepType = PairingStepPromo;
                    break;
                    
                case DeviceTypeContactSensor:
                    pairingStep.stepType = PairingStepContactSensor;
                    break;
                    
                case DeviceTypeVent:
                    pairingStep.stepType = PairingStepVent;
                    break;
                    
                case DeviceTypeTiltSensor:
                    pairingStep.stepType = PairingStepTilt;
                    break;

                case DeviceTypeWaterHeater:
                case DeviceTypeThermostat:
                    pairingStep.stepType = PairingStepManageDevice;
                    [pairingSteps addObject:pairingStep];
                    pairingStep = [[PairingStep alloc] init];
                    pairingStep.stepType = PairingStepDefaultSchedule;
                    break;
                
                case DeviceTypeSomfyBlinds:
                    pairingStep.stepType = PairingStepPostPairInstructions;
                    pairingStep.title = NSLocalizedString(@"Somfy Roller Blinds", nil);
                    pairingStep.instructionTitle = NSLocalizedString(@"Create a Favorite Position", nil);
                    pairingStep.instructionText = NSLocalizedString(@"Somfy Blinds Instructions", nil);
                    break;

                case DeviceTypePetDoor:
                    pairingStep.stepType = PairingStepManageDevice;
                    break;

                default:
                    pairingStep = nil;
                    break;
            }
            if (pairingStep) {
                if (type != DeviceTypeSomfyBlinds)
                    pairingStep.title = DeviceTypeToString(type);
                
                [pairingSteps addObject:pairingStep];
            }
        }
    }
}

+ (void)addNewProMonAlarmActivatedStep:(NSMutableArray *) pairingSteps {
    
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepNewProMonAlarmActivated;
    pairingStep.title = NSLocalizedString(@"PROFESSIONAL MONITORING", nil);
    
    [pairingSteps addObject:pairingStep];
}

+ (void)addZWaveHealRecommendedPairingStep:(NSMutableArray *) pairingSteps {

    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepZWaveHealRecommended;
    
    [pairingSteps addObject:pairingStep];
}

+ (void)addRenameDevicePairingStepWithPairingSteps:(NSMutableArray *)pairingSteps
                                          andTitle:(NSString *)title {
    // Adding Rename device step
    PairingStep *pairingStep = [PairingStep new];
    pairingStep.stepType = PairingStepNameAndPhoto;
    pairingStep.title = title;
    pairingStep.mainStep = NSLocalizedString(@"Name your device\nand add a photo if you like.", nil);
    pairingStep.secondStepPlaceholder = NSLocalizedString(@"Device Name", nil);
    
    [pairingSteps addObject:pairingStep];
}

+ (void)addFavoritePairingStep:(NSMutableArray *)pairingSteps {
    PairingStep *pairingStep = [[PairingStep alloc] init];
    pairingStep.stepType = PairingStepFavorite;

    [pairingSteps addObject:pairingStep];
}

+ (void)addPairingSuccessStep:(NSMutableArray *)pairingSteps {
    PairingStep *pairingStep = [[PairingStep alloc] init];
    pairingStep.stepType = PairingStepPromo;
    [pairingSteps addObject:pairingStep];
}

+ (void)addWifiSmartSwitchPairingSuccessStep:(NSMutableArray *)pairingSteps {
  PairingStep *pairingStep = [[PairingStep alloc] init];
  pairingStep.stepType = PairingStepWifiSmartPlugSuccess;
  [pairingSteps addObject:pairingStep];
}

+ (void)addNyceHingePairingStep:(DeviceType)deviceType
                 andPairingSteps:(NSMutableArray *)pairingSteps {
    if (deviceType == DeviceTypeContactSensor) {
        PairingStep *pairingStep = [[PairingStep alloc] init];
        pairingStep.stepType = PairingStepNyceHinge;
        pairingStep.title = @"NYCE HINGE SENSOR";
        [pairingSteps addObject:pairingStep];
    }
}

- (PairingStep *)currentStep {
    PairingStep *currentStep = nil;
    
    if (self.currentStepIndex < 0 || self.currentStepIndex > self.pairingSteps.count - 1) {
        currentStep = [[PairingStep alloc] init];
        currentStep.stepType = PairingStepBase;
    } else {
        currentStep = self.pairingSteps[self.currentStepIndex];
    }
    
    return currentStep;
}

- (void)addPairingStep:(PairingStep *)step {
    [self.pairingSteps addObject:step];
}

// Add a new step or replace the next step
- (void)addOrReplacePairingStep:(PairingStep *)step {
    if (self.pairingSteps.count > self.currentStepIndex + 1) {
        [self.pairingSteps replaceObjectAtIndex:self.currentStepIndex + 1 withObject:step];
    } else {
        [self addPairingStep:step];
    }
}

- (NSString *)videoID {
    return (!self.videoURL) ? @"" : [self.videoURL componentsSeparatedByString:@"/"].lastObject;
}

- (DeviceModel *)deviceModel {
    return [DevicePairingManager sharedInstance].currentDevice;
}

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Always use initWithViewController to initialize this class"];
    }
    return self;
}

- (instancetype)initWithDeviceData:(NSArray *)pairingStepsArray
                    withDeviceType:(DeviceType)deviceType
                     withVideoLink:(NSString *)videoURL {
    if (self = [super init]) {
        self.deviceType = deviceType;
        self.videoURL = videoURL;
        
        self.pairingSteps = [NSMutableArray arrayWithArray:pairingStepsArray];
        self.currentStepIndex = -1;
        _parameters = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.pairingSteps.description];
}

#pragma mark - Factory
- (UIViewController *)createNextStepObject:(BOOL)animated {
    self.currentStepIndex++;
    
    if (self.currentStepIndex >= self.pairingSteps.count) {
        return nil;
    }
    PairingStep *nextStep = self.pairingSteps[self.currentStepIndex];
    
    PairingStepType templateType = nextStep.stepType;
    
    UIViewController *nextViewController = nil;
    
    switch (templateType) {
        case PairingStepBase:
            nextViewController = [BaseDeviceStepViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepInput:
            nextViewController = [DevicePairingFormEntryViewController createWithDeviceStep:nextStep];
            break;
        case PairingStepPromo:
            nextViewController = [PairedHubAlreadyForActionViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepEnterHubId:
            nextViewController = [DeviceTextfieldViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepNameAndPhoto:
            nextViewController = self.deviceModel ? [DeviceTextfieldViewController createWithDeviceModel:self.deviceModel] : [DeviceTextfieldViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepSearch:
            nextViewController = [SearchDeviceParingViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepHubSearch:
            nextViewController = [SearchHubViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepHubSuccess:
            nextViewController = [HubSuccessViewController create];
            break;
            
        case PairingStepAssignPersonToKeyfob:
            nextViewController = [KeyfobPairingViewController createWithDeviceStep:nextStep];
            break;

        case PairingStepAssignKeyFobButton:
            nextViewController = [SmartFobPairingSelectionController createWithDeviceStep:nextStep device:self.deviceModel];
            break;

        case PairingStepAssignPersonToCarePendant:
            nextViewController = [DeviceRenameAssignmentController createWithDeviceStep:nextStep device:self.deviceModel];
            break;

        case PairingStepPendantTestCoverage:
            nextViewController = [PendantCoverageInfoViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;

        case PairingStepSettingButton:
            nextViewController = [SmartButtonSelectionController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
            
        case PairingStepContactSensor:
            nextViewController = [ContactSensorPairingSelectionViewController createWithDeviceStep:nextStep withDeviceModel:self.deviceModel];
            break;
            
        case PairingStepFavorite:
            nextViewController = [PairingFavoriteViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
            
        case PairingStepVent:
            nextViewController = [VentExtraStepViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepTilt:
            nextViewController = [TiltSensorPairingStepViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;

        case PairingStepHWTotalConnect:
            nextViewController = [HoneywellC2CViewController new];
            ((HoneywellC2CViewController *)nextViewController).isPairingMode = YES;
            break;
            
        case PairingStepHWTotalConnectDeviceList:
            if ([DevicePairingManager sharedInstance].justPairedDevices.count > 1) {
                // Multipairing flow
                nextViewController = [FoundDevicesViewController createWithDeviceStep:nextStep];
            }
            else {
                // Single device pairing flow
                [self createNextStepObject:YES];
            }
            break;

      case PairingStepNestConnect: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NestPairing" bundle:nil];
            nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"NestC2CViewController"];
            break;
      }

      case PairingStepLutronCasetaSmartBridge: {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LutronPairing" bundle:nil];
            nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"LutronBridgeC2CViewController"];
            break;
      }


        case PairingStepWaterHeaterReminder:
            nextViewController = [WaterHeaterReminderViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepWaterHeaterTemperature:
            nextViewController = [WaterHeaterTemperatureViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepLNGZoneList: {
            LawnNGardenPairingZoneListViewController *vc = [LawnNGardenPairingZoneListViewController create];
            vc.deviceModel = [DevicePairingManager sharedInstance].currentDevice;
            nextViewController = vc; }
            break;
        
        case PairingStepLNGZoneDetails:
            nextViewController = [LawnNGardenPairingZoneDetailsViewController createWithDeviceStep:nextStep];
            break;
            
        case PairingStepPostPairInstructions:
            nextViewController = [DevicePostPairingInstructionsViewController createWithDeviceStep:nextStep];
            break;

        case PairingStepAlexaSetup:
            nextViewController = [AlexaSetupPairingViewController createWithDeviceStep:nextStep];
            break;
        
        case PairingStepGoogleHomeAssistantSetup:
          nextViewController = [GoogleHomeSetupPairingViewController createWithDeviceStep:nextStep];
            break;

        case PairingStepPetDoorSearchForSmartKey:
            nextViewController = [SmartPetTokenPairingViewController createWithDeviceModel:self.deviceModel];
            break;

        case PairingStepPetDoorAddSmartKey:
            nextViewController = [DeviceRenamePetSmartKeyViewController createWithDeviceStep:nextStep withDeviceModel:self.deviceModel];
            break;
        case PairingStepWifiSmartPlugWifiSettings:
            nextViewController = [WSSPairingNetworkSettingsViewController create:nextStep];
            break;
        case PairingStepWifiSmartPlugExternalSettings:
            nextViewController = [WSSPairingExternalSettingsViewController create:nextStep];
            break;
        case PairingStepWifiSmartPlugChooseSchedule:
            nextViewController = [WSSChooseScheduleViewController create:nextStep];
            break;
        case PairingStepWifiSmartPlugSuccess:
            nextViewController = [WSSPairingSuccessViewController create];
            break;
        case PairingStepManageDevice:
            nextViewController = [PairingExtraFinalStepViewController createWithDeviceStep:nextStep withDeviceModel:self.deviceModel];
            break;
        case PairingStepHaloPickRoomName:
            nextViewController = [HaloPairingPickRoomViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
        case PairingStepHaloTest:
            nextViewController = [HaloPairingTestViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
        case PairingStepHaloPickCounty:
            nextViewController = [HaloPlusPickCountyViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
        case PairingStepHaloPickWeatherRadio:
            nextViewController = [HaloPlusPickWeatherStationViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
        case PairingStepZWaveHealRecommended:
        if ([[DevicePairingManager sharedInstance] wasZWaveDevicePaired] &&
            [ZWaveToolsViewController isZWaveRebuildSupported] &&
            [[DevicePairingManager sharedInstance] areAllDevicesUpdated]) {
                nextViewController = [ZWaveHealRecommendedViewController create];
            }
            break;
        case PairingStepNyceHinge:
            nextViewController = [NyceHingePostPairViewController createWithDeviceStep:nextStep device:self.deviceModel];
            break;
        case PairingStepNewProMonAlarmActivated:
            if ([[DevicePairingManager sharedInstance] alertsActivatedDuringPairing].count > 0) {
                nextViewController = [ProMonNewAlarmActivatedViewController createWithDeviceStep:nextStep];
            }
            break;
        case PairingStepDefaultSchedule:
            nextViewController = [DefaultSchedulePairingStepViewController createWithDeviceStep:nextStep];
        break;
    }
    
    if (nextViewController) {
        SWRevealViewController *root = (SWRevealViewController*)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
        UINavigationController *navController = (UINavigationController *)root.frontViewController;
        [navController pushViewController:nextViewController animated:animated];
        return nextViewController;
    }
    
    // Continue advancing until we reach the end of the list or find a non-null VC
    else {
        return [self createNextStepObject:animated];
    }
    
}

- (void)skipNextPairingStep {
    self.currentStepIndex++;
}

- (BOOL)backToPreviousPage {
    if (self.currentStepIndex >= 0) {
        self.currentStepIndex--;
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isStepOfTypeExecuted:(PairingStepType)stepType {
    for (int i = 0; i < self.currentStepIndex; i++) {
        PairingStep *step = self.pairingSteps[i];
        if (step.stepType == stepType) {
            return YES;
        }
    }
    return NO;
}
@end
