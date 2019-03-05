//
//  DeviceProductCatalog.h
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(unsigned int, PairingStepType) {
    PairingStepBase      = 0,
    PairingStepInput,
    PairingStepNameAndPhoto,
    PairingStepPromo,
    PairingStepHubCompletion,
    PairingStepConnectHub,
    PairingStepEnterHubId,
    PairingStepSearchingForHub,
    PairingStepSearch,
    PairingStepHubSearch,
    PairingStepAssignPersonToKeyfob,
    PairingStepAssignPersonToCarePendant,
    PairingStepAssignKeyFobButton,
    PairingStepSettingButton,
    PairingStepContactSensor,
    PairingStepVent,
    PairingStepTilt,
    PairingStepFavorite,
    PairingStepHWTotalConnect,
    PairingStepHWTotalConnectDeviceList,
    PairingStepWaterHeaterReminder,
    PairingStepWaterHeaterTemperature,
    PairingStepLNGZoneList,
    PairingStepLNGZoneDetails,
    PairingStepHubSuccess,
    PairingStepPostPairInstructions,
    PairingStepAlexaSetup,
    PairingStepGoogleHomeAssistantSetup,
    PairingStepPendantTestCoverage,
    PairingStepPetDoorSearchForSmartKey,
    PairingStepPetDoorAddSmartKey,
    PairingStepWifiSmartPlugWifiSettings,
    PairingStepWifiSmartPlugExternalSettings,
    PairingStepWifiSmartPlugChooseSchedule,
    PairingStepWifiSmartPlugSuccess,
    PairingStepHaloPickRoomName,
    PairingStepHaloPickCounty,
    PairingStepHaloPickWeatherRadio,
    PairingStepHaloInstallationInstructions,
    PairingStepHaloTest,
    PairingStepManageDevice,
    PairingStepNyceHinge,
    PairingStepZWaveHealRecommended,
    PairingStepNewProMonAlarmActivated,
    PairingStepNestConnect,
    PairingStepLutronCasetaSmartBridge,
    PairingStepDefaultSchedule
};

@interface DeviceProductCatalog : NSObject

- (instancetype)initWithJson:(NSDictionary *)json;

@property (nonatomic, readonly) NSString *productId;

@property (nonatomic, readonly) NSString *arcusProductId;

@property (nonatomic, readonly) NSString *productName;

@property (nonatomic, readonly) NSString *protoFamily;

@property (nonatomic, readonly) NSString *productScreen;

@property (nonatomic, readonly) NSArray *categories;

@property (nonatomic, readonly) NSString *brand;

@property (nonatomic, readonly) NSString *image;

@property (nonatomic, readonly) NSArray *pairingSteps;

@property (nonatomic, readonly) NSString *keywords;

@property (nonatomic, readonly) NSString *videoURL;

@property (nonatomic, readonly) NSString *vendorId;

@property (nonatomic, readonly) NSString *devRequired;

#pragma mark - Getting steps properies methods
- (NSString *)getTextFromPairingSteps:(NSInteger)stepNumber;
- (NSString *)getSecondaryTextFromPairingSteps:(NSInteger)stepNumber;
- (NSString *)targetForDevicePairingStep:(NSInteger)stepIndex;
- (NSArray *)devicePairingStepInputs:(NSInteger)stepIndex;
- (PairingStepType)getPairingTypeFromPairingSteps:(NSInteger)stepNumber;

@end
