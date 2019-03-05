//
//  DevicePairingManager.h
//  i2app
//
//  Created by Arcus Team on 7/10/15.
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


extern NSString *const kUpdateUINotification;
extern NSString *const kUpdateUIDeviceAddedNotification;

typedef enum {
    PairingFlowTypeAddHub,
    PairingFlowTypeAddOneDevice,
    PairingFlowTypeAddMultipleFoundDevices,
    PairingFlowTypeAddPetDoorSmartKeys
} PairingFlowType;



@class DevicePairingWizard;


@interface DevicePairingManager : NSObject

+ (DevicePairingManager *)sharedInstance;

- (void)resetAllPairingStates;

@property (nonatomic, strong) NSMutableArray *justPairedDevices;
@property (nonatomic, strong, readonly) NSMutableArray *updatedPairedDevices;

// The device that is being updated
@property (nonatomic, weak) DeviceModel *currentDevice;

@property (atomic, assign) PairingFlowType pairingFlowType;
@property (atomic, strong) DevicePairingWizard *pairingWizard;
@property (nonatomic, assign) BOOL isPostPostPairing;
@property (nonatomic, assign) BOOL ignoreDeviceAdded;
@property (nonatomic, strong) NSArray* prePairingActiveAlerts;

- (void)initializePairingProcess;
- (PMKPromise *)startHubPairing:(BOOL)restarted;

- (BOOL)isInPairingMode;

- (void)pairingProcessDone;
- (void)stopHubPairing;
- (void)stopPairingProcessAndNotifications;

- (void)changeLabels:(UILabel *)lookingLabel deviceCountLabel:(UILabel *)deviceCountLabel inView:(UIView *)view;

- (BOOL)isDeviceUpdated:(DeviceModel *)deviceModel;
- (void)renameDevice:(NSString *)deviceName forDeviceModel:(DeviceModel *)deviceModel completeBlock:(void (^)(void))compleBlock;
- (void)renameDevice:(NSString *)deviceName forDeviceModel:(DeviceModel *)deviceModel;
- (BOOL)areAllDevicesUpdated;
- (BOOL)wasZWaveDevicePaired;
- (NSArray *) alertsActivatedDuringPairing;

- (void)stopSubscribingToNofitications;
- (void)subscribeToDeviceAddedNotification;
- (void)stopSubscribingToDeviceAddedNotification;

- (void)customizeDevice:(id)sender;

- (BOOL)hasHoneywellThermostatsPaired;
- (BOOL)hasC2CPairingFlow;

- (void)markAsUpdated:(DeviceModel *)device;
- (void)markAllDevicesUpdated;

- (void)clearUpdatedPairedDevices;

@end
