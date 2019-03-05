//
//  SafetySubsystemAlertController.m
//  Pods
//
//  Created by Arcus Team on 8/19/15.
//
//

#import <i2app-Swift.h>
#import "SafetySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemCapability.h"
#import "SmokeCapability.h"
#import "CarbonMonoxideCapability.h"
#import "DeviceConnectionCapability.h"

#import "DeviceCapability.h"
#import "NSDate+Convert.h"

@interface SafetySubsystemAlertController () <AlarmSubsystemProtocol>

- (SafetyAlarmState)convertStateToEnum:(NSString *)state;

@end

NSString *const kWater = @"WATER";
NSString *const kNone = @"NONE";

@implementation SafetySubsystemAlertController

@synthesize subsystemModel;

@dynamic numberOfDevices;
@dynamic numberOfOfflineDevices;
@dynamic numberOfOnlineDevices;
@dynamic isCallTreeEnabled;
@dynamic callTree;

@dynamic allDeviceIds;
@dynamic onlineDeviceIds;
@dynamic offlineDeviceIds;

@dynamic hasCOSensors;
@dynamic hasSmokeSensors;
@dynamic hasWaterSensors;
@dynamic numberOfValidStates;

@dynamic waterState;
@dynamic coState;
@dynamic smokeState;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self  = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

#pragma mark - AlarmSubsystemProtocol
- (int)numberOfDevices {
    NSArray *devices = [SafetySubsystemCapability getTotalDevicesFromModel:self.subsystemModel];
    if ((devices != nil) && ([devices count] > 0)) {
        return (int)devices.count;
    } else {
        return 0;
    }
}

- (int)numberOfOfflineDevices {
    return (self.numberOfDevices - self.numberOfOnlineDevices);
}

- (int)numberOfOnlineDevices {
    return (int)[SafetySubsystemCapability getActiveDevicesFromModel:self.subsystemModel].count;
}

- (NSArray *)allDeviceIds {
    return [SafetySubsystemCapability getTotalDevicesFromModel:self.subsystemModel];
}

- (NSArray *)onlineDeviceIds {
    return [SafetySubsystemCapability getActiveDevicesFromModel:self.subsystemModel];
}

- (NSArray *)offlineDeviceIds {
    NSMutableArray *offlineDevices = [NSMutableArray array];
    
    for (NSString *deviceId in [self allDeviceIds]) {
        if (![self isOnlineDeviceId:deviceId]) {
            [offlineDevices addObject:deviceId];
        }
    }
    
    return offlineDevices;
}

- (NSArray *)getTriggeredDeviceIdsFromSubsystem:(NSArray *)devicesData {
    if (devicesData.count > 0) {
        // Extract the device Ids
        NSMutableArray *deviceIds = [[NSMutableArray alloc] initWithCapacity:devicesData.count];
        for (NSDictionary *dict in devicesData) {
            NSString *deviceId = dict[@"device"];
            deviceId = [Model modelIdForAddress:deviceId];
            [deviceIds addObject:deviceId];
        }
        return deviceIds.copy;
    }
    return nil;
}

- (NSArray *)triggerDeviceIds {
    NSArray *resultIds = nil;
    NSArray *triggerDevices = [self triggerDevices];
    if ([triggerDevices count] == 0) {
        triggerDevices = [self getPendingClear];
    }
    
    if ([triggerDevices count] > 0) {
        resultIds = [self getTriggeredDeviceIdsFromSubsystem:triggerDevices];
    }
    
    return resultIds;
}

- (NSArray *)triggerDevices {
    return [SafetySubsystemCapability getTriggersFromModel:self.subsystemModel];
}

- (DeviceModel *)getFirstTriggeredDevice {
    DeviceModel *result = nil;

    NSArray *triggerDeviceIds = [[SubsystemsController sharedInstance].safetyController triggerDeviceIds];
    
    if ([triggerDeviceIds count] > 0) {
        NSString *address = [DeviceModel addressForId:triggerDeviceIds[0]];
        result = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    }
    
    return result;
}

- (NSArray *)getPendingClear {
    return [SafetySubsystemCapability getPendingClearFromModel:self.subsystemModel];
}

- (NSString *)reasonForTriggeredDeviceWithId:(NSString *)deviceId {
    NSArray *triggeredDevices = [SafetySubsystemCapability getTriggersFromModel:self.subsystemModel];

    if (triggeredDevices!= nil && triggeredDevices.count > 0) {
        // Extract the reason for that device
        for (NSDictionary *dict in triggeredDevices) {
            NSString *modelId = dict[@"device"];
            modelId = [Model modelIdForAddress:modelId];
            if ([modelId isEqualToString:deviceId]) {
                return dict[@"type"];
            }
        }
    }
    return @"";
}

- (BOOL)isOnlineDeviceId:(NSString *)aDeviceId {
    for (NSString *deviceId in [self onlineDeviceIds]) {
        if ([deviceId isEqualToString:aDeviceId]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isCallTreeEnabled {
    return [SafetySubsystemCapability getCallTreeEnabledFromModel:self.subsystemModel];
}

- (NSArray *)callTree {
    return [SafetySubsystemCapability getCallTreeFromModel:self.subsystemModel];
}


- (void)saveNewCallTree:(NSArray *)newCallTree {
    [SafetySubsystemCapability setCallTree:newCallTree onModel:self.subsystemModel];
    [self.subsystemModel  commit];
}

- (NSString *)lastAlertCause {
    return [SafetySubsystemCapability getLastAlertCauseFromModel:self.subsystemModel];
}

- (BOOL)isAlarmTriggered {
    return [[self alarmState] isEqualToString:kEnumSafetySubsystemAlarmALERT];
}

- (BOOL)getSilent {
    return [SafetySubsystemCapability getSilentAlarmFromModel:self.subsystemModel];
}

- (void)setSilent:(BOOL)silent {
    [SafetySubsystemCapability setSilentAlarm:silent onModel:self.subsystemModel];
    [self.subsystemModel commit];
}

- (BOOL)hasWaterShutOffVales {
    return [[SafetySubsystemCapability getWaterShutoffValvesFromModel:self.subsystemModel] count] > 0;
}

- (BOOL)getWaterShutOff {
    return [SafetySubsystemCapability getWaterShutOffFromModel:self.subsystemModel];
}

- (void)setWaterShutOff:(BOOL)waterShutOff {
    [SafetySubsystemCapability setWaterShutOff:waterShutOff onModel:self.subsystemModel];
    [self.subsystemModel commit];
}

- (NSDate *)lastAlertTime {
    return [SafetySubsystemCapability getLastAlertTimeFromModel:self.subsystemModel];
}

- (PMKPromise *)clear {
    return [SafetySubsystemCapability clearOnModel:self.subsystemModel];
}

#pragma mark - Dynamic Properties
- (SafetyAlarmState)hasCOSensors {
    NSString *state = ((NSDictionary *)[SafetySubsystemCapability getSensorStateFromModel:self.subsystemModel])[[CarbonMonoxideCapability namespace].uppercaseString];
    return [self convertStateToEnum:state];
}

- (SafetyAlarmState)hasSmokeSensors {
    NSString *state = ((NSDictionary *)[SafetySubsystemCapability getSensorStateFromModel:self.subsystemModel])[[SmokeCapability namespace].uppercaseString];
    return [self convertStateToEnum:state];
}

- (SafetyAlarmState)hasWaterSensors {
    NSString *state = ((NSDictionary *)[SafetySubsystemCapability getSensorStateFromModel:self.subsystemModel])[kWater];
    return [self convertStateToEnum:state];
}

- (SafetyAlarmState)convertStateToEnum:(NSString *)state {
    SafetyAlarmState alarmState = SafetyAlarmStateNone;
    
    if ([state isEqualToString:@"NONE"]) {
        alarmState = SafetyAlarmStateNone;
    } else if ([state isEqualToString:@"SAFE"]) {
        alarmState = SafetyAlarmStateSafe;
    } else if ([state isEqualToString:@"OFFLINE"]) {
        alarmState = SafetyAlarmStateOffline;
    } else if ([state isEqualToString:@"DETECTED"]) {
        alarmState = SafetyAlarmStateDetected;
    }
    
    return alarmState;
}

- (int)numberOfValidStates {
    int validStates = 0;
    for (NSString *state in ((NSDictionary *)[SafetySubsystemCapability getSensorStateFromModel:self.subsystemModel]).allValues) {
        if (![state isEqualToString:kNone]) {
            validStates++;
        }
    }
    return validStates;
}

- (NSString *)waterState {
    return [self stateForSensorState:kWater];
}

- (NSString *)coState {
    return [self stateForSensorState:[CarbonMonoxideCapability namespace].uppercaseString];
}

- (NSString *)smokeState {
    return [self stateForSensorState:[SmokeCapability namespace].uppercaseString];
}

- (NSString *)stateForSensorState:(NSString *)sensorState {
    return ((NSDictionary *)[SafetySubsystemCapability getSensorStateFromModel:self.subsystemModel])[sensorState];
}

- (NSString *)alarmState {
    return [SafetySubsystemCapability getAlarmFromModel:self.subsystemModel];
}
- (int)numberOfOfflineCOSensors {
    int result = 0;
    NSArray *offlineDevices =  [self offlineDeviceIds];
    for (NSString *deviceAdress in offlineDevices) {
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAdress];
        NSString *deviceHint =[DeviceCapability getDevtypehintFromModel:deviceModel];
        if ([deviceHint isEqualToString:@"co"] || [deviceHint isEqualToString:@"smoke/co" ]) {
            result += 1;
        }
    }
    return result;
}

- (int)numberOfOfflineSmokeSensors {
    int result = 0;
    NSArray *offlineDevices =  [self offlineDeviceIds];
    
    for (NSString *deviceAdress in offlineDevices) {
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAdress];
        NSString *deviceHint =[DeviceCapability getDevtypehintFromModel:deviceModel];
        if ([deviceHint isEqualToString:@"smoke"] || [deviceHint isEqualToString:@"smoke/co" ]) {
            result += 1;
        }
    }
    return result;
}

- (int)numberOfOfflineWaterLeakSensor {
    int result = 0;
    NSArray *offlineDevices =  [self offlineDeviceIds];
    
    for (NSString *deviceAdress in offlineDevices) {
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAdress];
        NSString *deviceHint =[DeviceCapability getDevtypehintFromModel:deviceModel];
        if ([deviceHint isEqualToString:@"water leak"]) {
            result += 1;
        }
    }
    return result;
}

- (NSString *)lastTriggeredString {
    NSString *lastTriggered = @"No Alarms Triggered";
    
    NSDate *lastTriggeredDate = [SafetySubsystemCapability getLastAlertTimeFromModel:self.subsystemModel];
    if ([lastTriggeredDate compare:[NSDate dateWithTimeIntervalSince1970:0]] != NSOrderedSame) {
        if ([lastTriggeredDate isSameDayWith:[NSDate date]]) {
            lastTriggered = [NSString stringWithFormat:@"Last Alarm: Today %@", [lastTriggeredDate formatDateTimeStamp]];
        } else {
            lastTriggered = [NSString stringWithFormat:@"Last Alarm: %@", [lastTriggeredDate formatFullDate]];
        }
    }
    
    return lastTriggered;
}

- (NSString *)currentAlarmState {
    return [SafetySubsystemCapability getAlarmFromModel:self.subsystemModel];;
}

@end
