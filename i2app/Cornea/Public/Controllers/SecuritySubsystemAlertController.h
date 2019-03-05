//
//  SecuritySubsystemAlertController.h
//  Pods
//
//  Created by Arcus Team on 8/19/15.
//
//

#import <Foundation/Foundation.h>
#import "OrderedDictionary.h"
#import "SubsystemsController.h"

@class PMKPromise;

@interface SecuritySubsystemAlertController : NSObject <AlarmSubsystemProtocol>

extern NSString *const kErrorSecurityTriggeredDevicesBlockingArming;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, assign, readonly) NSString *securityAlarmDevicesStatus;
@property (nonatomic, assign, readonly) NSString *partialSecurityAlarmDevicesStatus;
@property (nonatomic, assign, readonly) NSString *alarmHistoryStatus;
@property (nonatomic, assign, readonly) NSString *securityState;
@property (nonatomic, assign, readonly) NSString *stateString;
@property (nonatomic, assign, readonly) NSString *mode;

@property (nonatomic, assign, readonly) int numberOfOpenDevices;
@property (nonatomic, assign, readonly) int numberOfArmedDevices;
@property (nonatomic, assign, readonly) int numberOfReadyDevices;
@property (nonatomic, assign, readonly) int numberOfByPassedDevices;
@property (nonatomic, assign, readonly) int numberOfOnMotionSensors;
@property (nonatomic, assign, readonly) int numberOfPartialMotionSensors;

@property (nonatomic, assign, readonly) NSArray *openDevices;
@property (nonatomic, assign, readonly) NSArray *modeONDevices;
@property (nonatomic, assign, readonly) NSArray *modePARTIALDevices;


@property (nonatomic, assign, readonly) BOOL isCallTreeEnabled;
@property (nonatomic, assign, readonly) NSArray *callTree;

@property (nonatomic, assign, readonly) NSDate *lastAlertTime;

- (PMKPromise *)armModeOn;
- (PMKPromise *)armPartial;
- (PMKPromise *)disArm;

- (PMKPromise *)armByPassedModeOn;
- (PMKPromise *)armByPassedModePartial;

- (PMKPromise *)armByPassedPartial;

- (BOOL)isOfflineDeviceId:(NSString *)deviceId;
- (BOOL)isOnModeDevice:(DeviceModel *)adevice;
- (BOOL)isPartialModeDevice:(DeviceModel *)adevice;

- (int)getEntranceDelaySecForModeOn;
- (void)setEntranceDelaySecForModeOn:(int)delayInSec;

- (int)getEntranceDelaySecForModePartial;
- (void)setEntranceDelaySecForModePartial:(int)delayInSec;

- (int)getExitDelaySecForModeOn;
- (void)setExitDelaySecForModeOn:(int)delayInSec;

- (int)getExitDelaySecForModePartial;
- (void)setExitDelaySecForModePartial:(int)delayInSec;

- (NSString *)lastAlertCause;
- (OrderedDictionary *)getLastAlertTriggerWithDate;
- (Model *)getFirstTriggerDevice;
- (NSArray *)getLastAlertTrigger;
- (NSArray *)getCurrentAlertTriggers;
- (NSArray *)triggerDeviceIds;

- (void)setModeONDevices:(NSArray *)modeONDevices;
- (void)setModePARTIALDevices:(NSArray *)modePARTIALDevices;

- (int)alarmSensitivityDeviceCount;
- (void)setAlarmSensitivityDeviceCount:(int)numberOfDevices;

- (int)alarmSensitivityOnDeviceCount;
- (int)alarmSensitivityPartialDeviceCount;
- (void)setAlarmSensitivityOnMode:(int)numberOfDevices;
- (void)setAlarmSensitivityPartialMode:(int)numberOfDevices;

- (BOOL)getSoundsEnabled;
- (void)setSoundsEnabled:(BOOL)soundsEnabled;

- (NSArray *)offlineDevicesModeON;
- (NSArray *)offlineDevicesModePARTIAL;

- (NSArray *)openDevicesModeON;
- (NSArray *)openDevicesModePARTIAL;

- (NSDate *)lastDisarmedTime;
- (NSDate *)lastArmedTime;

- (int)numberOfDevicesForMode;

- (int)totalNumberOfSegments;
- (int)numberOfRedSegments;
- (int)numberOfGreySegments;
- (int)numberOfWhiteSegments;

- (void)lastTriggeredString:(void (^)(NSString *lastTriggered))completeBlock;

@end
