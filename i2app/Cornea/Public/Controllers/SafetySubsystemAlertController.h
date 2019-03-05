//
//  SafetySubsystemAlertController.h
//  Pods
//
//  Created by Arcus Team on 8/19/15.
//
//

#import <Foundation/Foundation.h>
#import "SubsystemsController.h"
#import "OrderedDictionary.h"

typedef enum {
    SafetyAlarmStateNone     = 0,
    SafetyAlarmStateSafe     = 1,
    SafetyAlarmStateOffline  = 2,
    SafetyAlarmStateDetected = 3
} SafetyAlarmState;


@class PMKPromise;


@interface SafetySubsystemAlertController : NSObject <AlarmSubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, readonly) SafetyAlarmState hasCOSensors;
@property (nonatomic, readonly) SafetyAlarmState hasSmokeSensors;
@property (nonatomic, readonly) SafetyAlarmState hasWaterSensors;
@property (nonatomic, readonly) int numberOfValidStates;

@property (nonatomic, weak, readonly) NSString *waterState;
@property (nonatomic, weak, readonly) NSString *coState;
@property (nonatomic, weak, readonly) NSString *smokeState;
@property (nonatomic, weak, readonly) NSString *alarmState;

- (NSString *)lastAlertCause;
- (NSArray *)triggerDeviceIds;
- (NSArray *)triggerDevices;
- (DeviceModel *)getFirstTriggeredDevice;
- (NSString *)reasonForTriggeredDeviceWithId:(NSString *)deviceId;
- (NSDate *)lastAlertTime;
- (PMKPromise *)clear;
- (NSString *)currentAlarmState;

- (int)numberOfOfflineCOSensors;
- (int)numberOfOfflineSmokeSensors;
- (int)numberOfOfflineWaterLeakSensor;

- (NSString *)lastTriggeredString;
- (NSArray *)getPendingClear;

@end
