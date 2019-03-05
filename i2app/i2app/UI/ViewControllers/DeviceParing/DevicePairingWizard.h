//
//  DevicePairingWizard.h
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

#import <Foundation/Foundation.h>
#import "DeviceProductCatalog+Extension.h"
#import "DeviceModel+Extension.h"
#import "DevicePairingManager.h"
#import "PairingStep.h"

@class PairingStep;
@class BasePairingViewController;
@class DeviceProductCatalog;

@interface DevicePairingWizard : NSObject

+ (BOOL)isAppUpgradeNeeded:(DeviceProductCatalog *)productCatalog;

+ (UIViewController *)createHubPairingSteps:(BOOL)animated;

+ (void)runSinglePairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                 deviceType:(DeviceType)deviceType;
+ (void)runLutronCustomPairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                       deviceType:(DeviceType)deviceType;
+ (void)runNestCustomPairingWizardWithModelData:(DeviceProductCatalog *)deviceProductCatalog
                                     deviceType:(DeviceType)deviceType;
+ (void)runMultiplePairingFlowWithDeviceModel:(DeviceModel *)deviceModel andDeviceType:(DeviceType)deviceType;
+ (void)runPostPostPairingWizard:(id)sender;

+ (UIViewController *)createPetDoorSmartKeyPairingSteps:(DeviceModel *)deviceModel;

+ (NSArray *)getDevTypeForExtraSteps;

@property (atomic) DeviceType deviceType;
@property (strong, nonatomic) NSString *videoURL;
@property (readonly, assign, nonatomic) NSString *videoID;
@property (nonatomic, readonly) NSMutableDictionary *parameters;

- (UIViewController *)createNextStepObject:(BOOL)animated;
- (void)skipNextPairingStep;

- (BOOL)backToPreviousPage;

- (PairingStep *)currentStep;

- (void)addPairingStep:(PairingStep *)step;

- (void)addOrReplacePairingStep:(PairingStep *)step;

- (BOOL)isStepOfTypeExecuted:(PairingStepType)stepType;

@end
