//
//  SecuritySubsystemAlertController.m
//  Pods
//
//  Created by Arcus Team on 8/19/15.
//
//

#import <i2app-Swift.h>
#import "SecuritySubsystemAlertController.h"
#import "SecuritySubsystemCapability.h"
#import "SubsystemsController.h"
#import "SecurityAlarmModeCapability.h"
#import <PromiseKit/PromiseKit.h>

#import "NSDate+Convert.h"
#import "SubsystemCapability.h"

NSString *const kArmPartialMode = @"PARTIAL";
NSString *const kArmAllMode = @"ArmAll";

@interface SecuritySubsystemAlertController ()

@end


@implementation SecuritySubsystemAlertController

NSString *const kErrorSecurityTriggeredDevicesBlockingArming = @"TriggeredDevices";

@synthesize subsystemModel;

@dynamic numberOfDevices;
@dynamic numberOfOfflineDevices;
@dynamic numberOfOnlineDevices;

@dynamic allDeviceIds;
@dynamic onlineDeviceIds;
@dynamic offlineDeviceIds;

@dynamic numberOfOpenDevices;
@dynamic numberOfArmedDevices;
@dynamic isCallTreeEnabled;
@dynamic callTree;
@dynamic securityAlarmDevicesStatus;
@dynamic partialSecurityAlarmDevicesStatus;
@dynamic alarmHistoryStatus;
@dynamic securityState;
@dynamic stateString;



@dynamic lastAlertTime;

@dynamic mode;

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

- (int)numberOfDevicesForMode {
    if ([[self mode] isEqualToString:@"ON"]) {
        return (int)[self modeONDevices].count;
    }
    else if ([[self mode] isEqualToString:@"PARTIAL"]) {
        return (int)[self modePARTIALDevices].count;
    }
    return  [self numberOfDevices];
}

- (int)numberOfDevices {
    return (int)[SecuritySubsystemCapability getSecurityDevicesFromModel:self.subsystemModel].count;
}

- (int)numberOfPartialDevies {
    return (int)[SecuritySubsystemCapability getSecurityDevicesFromModel:self.subsystemModel].count;
}

- (int)numberOfOfflineDevices {
    return (int)[self offlineDeviceIds].count;
}



- (int)numberOfReadyDevices {
    return (int)[SecuritySubsystemCapability getReadyDevicesFromModel:self.subsystemModel].count;
}

- (int)numberOfByPassedDevices {
    return (int)[SecuritySubsystemCapability getBypassedDevicesFromModel:self.subsystemModel].count;
}

-(int)numberOfOnMotionSensors {
    return [[[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeMotionSensorCount]] intValue];
}

-(int)numberOfPartialMotionSensors {
    return [[[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeMotionSensorCount]] intValue];
}

- (NSArray *)openDevices {
    
    if ([[self mode] isEqualToString:@"ON"]) {
        return [self openDevicesModeON];
    }
    else if ([[self mode] isEqualToString:@"PARTIAL"]) {
        return  [self openDevicesModePARTIAL];
    }
    return  [self triggerDeviceIds];
}

- (int)numberOfOnlineDevices {
    return (int)[SecuritySubsystemCapability getReadyDevicesFromModel:self.subsystemModel].count;
}

- (NSArray *)allDeviceIds {
    return [SecuritySubsystemCapability getSecurityDevicesFromModel:self.subsystemModel];
}

- (NSArray *)onlineDeviceIds {
    return [SecuritySubsystemCapability getReadyDevicesFromModel:self.subsystemModel];
}

- (NSArray *)offlineDeviceIds {
    return [SecuritySubsystemCapability getOfflineDevicesFromModel:self.subsystemModel];
}

- (NSArray *)modeONDevices {
    return [[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeDevices]];
}

- (NSArray *)modePARTIALDevices {
    return [[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeDevices]];
}

- (BOOL)isOnModeDevice:(DeviceModel *)adevice {
    for (NSString *deviceId in [self modeONDevices]) {
        if ([deviceId containsString: [adevice modelId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)byPassedDevices {
    return [SecuritySubsystemCapability getBypassedDevicesFromModel:self.subsystemModel];
}

- (BOOL)isPartialModeDevice:(DeviceModel *)adevice {
    for (NSString *deviceId  in [self modePARTIALDevices]) {
        if ([deviceId containsString: [adevice modelId]]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)triggerDeviceIds {
    return [SecuritySubsystemCapability getTriggeredDevicesFromModel:self.subsystemModel];
}

- (NSDictionary *) getCurrentTriggered {
    NSDictionary *triggered = [SecuritySubsystemCapability getCurrentAlertTriggersFromModel:self.subsystemModel];
    return triggered;
}

- (void)saveNewCallTree:(NSArray *)newCallTree {
    [SecuritySubsystemCapability setCallTree:newCallTree onModel:self.subsystemModel];
    [self.subsystemModel  commit];
}

- (int)getEntranceDelaySecForModeOn {
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeEntranceDelaySec]] intValue];
}

- (void)setEntranceDelaySecForModeOn:(int)delayInSec {
  [self.subsystemModel set:@{[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeEntranceDelaySec]: @(delayInSec)}];
    [self.subsystemModel commit];
}

- (int)getEntranceDelaySecForModePartial {
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeEntranceDelaySec]] intValue];
    
}

- (void)setEntranceDelaySecForModePartial:(int)delayInSec {
  [self.subsystemModel set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeEntranceDelaySec] :@(delayInSec)}];
    [self.subsystemModel commit];
    
}

- (int)getExitDelaySecForModeOn {
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeExitDelaySec]] intValue];
}

- (void)setExitDelaySecForModeOn:(int)delayInSec {
  [self.subsystemModel set:@{[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeExitDelaySec]: @(delayInSec)}];
    [self.subsystemModel commit];
}

- (int)getExitDelaySecForModePartial {
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeExitDelaySec]] intValue];
}

- (void)setExitDelaySecForModePartial:(int)delayInSec {
  [self.subsystemModel set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeExitDelaySec]: @(delayInSec)}];
    [self.subsystemModel commit];
}

- (NSString *)lastAlertCause {
    return [SecuritySubsystemCapability getLastAlertCauseFromModel:self.subsystemModel];
}

- (OrderedDictionary *)getLastAlertTriggerWithDate {
    NSDictionary *originalDic = [SecuritySubsystemCapability getLastAlertTriggersFromModel:self.subsystemModel];
    OrderedDictionary *orderedDic = [[OrderedDictionary alloc] initWithCapacity:originalDic.count];

    if (originalDic.count > 0) {
        for (NSString *device in originalDic.allKeys) {
            NSNumber *tiggeredTime = [originalDic objectForKey:device];
            NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:(tiggeredTime.doubleValue / 1000)];

            Model *model = [[[CorneaHolder shared] modelCache] fetchModel:device];
            if (model) {
                if ([model isKindOfClass:[DeviceModel class]]) {
                    [orderedDic setObject:model forKey:eventTime];
                }
                else if ([model isKindOfClass:[RuleModel class]]) {
                    NSString *address = [((RuleModel *)model) getDeviceAddress];
                    if (address) {
                        DeviceModel *model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
                        if (model && [model isKindOfClass:[DeviceModel class]]) {
                            [orderedDic setObject:model forKey:eventTime];
                        }
                    }
                }
            }
        }
    }
    else {
        // This is a panic alert by "Security Device"
        [orderedDic setObject:@"Security Device" forKey:[self lastAlertTime]];
    }
    
    return orderedDic;
}

- (Model *)getFirstTriggerDevice {
    NSArray *triggerDeviceIds = [[SubsystemsController sharedInstance].securityController getLastAlertTrigger];

    if (triggerDeviceIds.count == 0 ) {
        return nil;
    }
    return [[[CorneaHolder shared] modelCache] fetchModel:[triggerDeviceIds objectAtIndex:0]];
}

- (NSArray *)getLastAlertTrigger {
    NSDictionary *originalDic = [SecuritySubsystemCapability getLastAlertTriggersFromModel:self.subsystemModel];
    NSArray *values = [originalDic.allValues sortedArrayUsingComparator:^NSComparisonResult(NSNumber *_Nonnull obj1, NSNumber *_Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *orderedDevices = [[NSMutableArray alloc] initWithCapacity:originalDic.count];
    
    for (NSNumber *number in values) {
        for (NSString *key in originalDic) {
            if ([[originalDic objectForKey:key] isEqual:number]) {
                [orderedDevices addObject:key];
                break;
            }
        }
    }
    
    return orderedDevices;
}

- (NSArray *)getCurrentAlertTriggers {
    NSArray *result = nil;
    NSDictionary *currentTriggers = [SecuritySubsystemCapability getCurrentAlertTriggersFromModel:self.subsystemModel];
    NSArray *values = [currentTriggers.allValues sortedArrayUsingComparator:^NSComparisonResult(NSNumber *_Nonnull obj1, NSNumber *_Nonnull obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *orderedDevices = [[NSMutableArray alloc] init];
    
    for (NSNumber *number in values) {
        for (NSString *key in currentTriggers) {
            if ([currentTriggers[key] isEqual:number]) {
                [orderedDevices addObject:key];
                break;
            }
        }
    }
    
    if ([orderedDevices count] > 0) {
        result = orderedDevices;
    }
    
    return result;
}

- (void)setModeONDevices:(NSArray *)modeONDevices {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeDevices]: modeONDevices}];
    [self.subsystemModel commit];
}

- (void)setModePARTIALDevices:(NSArray *)modePARTIALDevices {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeDevices]: modePARTIALDevices}];
    [self.subsystemModel commit];
}

- (int)alarmSensitivityDeviceCount {
    return ((NSNumber *)[[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]]).intValue;
}

- (int)alarmSensitivityOnDeviceCount {
  return ((NSNumber *)[[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]]).intValue;
}

- (int)alarmSensitivityPartialDeviceCount {
  return ((NSNumber *)[[self subsystemModel] getAttribute:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]]).intValue;
}

- (void)setAlarmSensitivityDeviceCount:(int)numberOfDevices {

  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:ON", kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]: @(numberOfDevices)}];
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]: @(numberOfDevices)}];
  [self.subsystemModel commit];
}

- (void)setAlarmSensitivityOnMode:(int)numberOfDevices {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:ON", kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]: @(numberOfDevices)}];
  [self.subsystemModel commit];
}

- (void)setAlarmSensitivityPartialMode:(int)numberOfDevices {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]: @(numberOfDevices)}];
  [self.subsystemModel commit];
}

- (BOOL)getSoundsEnabled {
    //TODO we have 2 mode but for Ted suggestion for now this attribute for 2 modes is alway the same
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeSoundsEnabled]] boolValue];
}

- (void)setSoundsEnabled:(BOOL)soundsEnabled {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeSoundsEnabled]: @(soundsEnabled)}];
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeSoundsEnabled]: @(soundsEnabled)}];
  [self.subsystemModel commit];
}

- (BOOL)getSilent {
    //TODO we have 2 mode but for Ted suggestion for now this attribute for 2 modes is alway the same
    return [[self.subsystemModel getAttribute:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeSilent]] boolValue];
}

- (void)setSilent:(BOOL)silent {
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeSilent]: @(silent)}];
  [[self subsystemModel] set:@{[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeSilent]: @(silent)}];
  [self.subsystemModel commit];
}

- (NSDate *)lastDisarmedTime {
    return [SecuritySubsystemCapability getLastDisarmedTimeFromModel:self.subsystemModel];
}

- (NSDate *)lastArmedTime{
    return [SecuritySubsystemCapability getLastArmedTimeFromModel:self.subsystemModel];
}

#pragma mark - Dynamic Properties
- (NSString *)securityAlarmDevicesStatus {
    NSString *status = [self statusWithNumberOfflineDevice:[self numberOfOfflineDevicesModeON]
                                      numberOfOpendeDevice:[self numberOfOpenDevicesModeON]];
    if (status.length > 0) {
        return status;
    }
    
    return [NSString stringWithFormat:@"%d %@",(int)[self modeONDevices].count, NSLocalizedString(@"Devices", nil)];
}

- (NSString *)partialSecurityAlarmDevicesStatus {
    NSString *status = [self statusWithNumberOfflineDevice:[self numberOfOfflineDevicesModePARTIAL]
                                      numberOfOpendeDevice:[self numberOfOpenDevicesModePARTIAL]];
    if (status.length > 0) {
        return status;
    }
    
    return [NSString stringWithFormat:@"%d %@",(int)[self modePARTIALDevices].count, NSLocalizedString(@"Devices", nil)];
}

- (NSString *)statusWithNumberOfflineDevice:(int)numOffline numberOfOpendeDevice:(int)numOpen {
    
    if (numOffline == 0 && numOpen == 0 ) {
        return @"";
    }
    
    if (numOffline == 0 ){
        return [NSString stringWithFormat:@"%d %@", numOpen, NSLocalizedString(@"Open", nil)];
    }
    
    if (numOpen == 0 ) {
        return [NSString stringWithFormat:@"%d %@", numOffline, NSLocalizedString(@"Offline", nil)];
    }
    
    return [NSString stringWithFormat:@"%d %@, %d %@", numOffline, NSLocalizedString(@"Offline", nil), numOpen, NSLocalizedString(@"Open", nil)];
}

- (NSString *)alarmHistoryStatus {
    return  @"";
}

- (NSString *)securityState {
    return [SecuritySubsystemCapability getAlarmStateFromModel: self.subsystemModel];
    
}

- (NSString *)stateString {
    NSString *state = [SecuritySubsystemCapability getAlarmStateFromModel:self.subsystemModel];
    
    return state;
}

- (NSString *)mode {
    return [SecuritySubsystemCapability getAlarmModeFromModel:self.subsystemModel];
}

- (int)numberOfOpenDevices {
    return (int)[[self openDevices] count];
}

- (int)numberOfArmedDevices {
    return (int)[SecuritySubsystemCapability getArmedDevicesFromModel:self.subsystemModel].count;
}

- (BOOL)isCallTreeEnabled {
    return [SecuritySubsystemCapability getCallTreeEnabledFromModel:self.subsystemModel];
}

- (NSArray *)callTree {
    return [SecuritySubsystemCapability getCallTreeFromModel:self.subsystemModel];
}

- (NSDate *)lastAlertTime {
    if (self.subsystemModel &&
        ![[self.subsystemModel getAttribute:kAttrSecuritySubsystemLastAlertTime] isKindOfClass:[NSNull class]]) {
        return [SecuritySubsystemCapability getLastAlertTimeFromModel:self.subsystemModel];
    }
    return [NSDate dateWithTimeIntervalSince1970:0];
}

- (BOOL)isOnlineDeviceId:(NSString *)aDeviceId {
    for (NSString *deviceId in [self onlineDeviceIds]) {
        if ([deviceId isEqualToString: aDeviceId]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isPartialDeviceId:(NSString *)aDeviceId {
    for (NSString *deviceId in [self byPassedDevices]) {
        if ([deviceId isEqualToString: aDeviceId]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isAlarmTriggered {
    return [[self stateString] isEqualToString:kEnumSecuritySubsystemAlarmStateALERT] ||
    [[self stateString] isEqualToString:kEnumSecuritySubsystemAlarmStateSOAKING];
}

- (BOOL)isOfflineDeviceId:(NSString *)deviceId {
    for (NSString *offlineDeviceId in [self offlineDeviceIds]) {
        if ([offlineDeviceId containsString: deviceId]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Communications with Platform
- (PMKPromise *)armModeOn {
    return [SecuritySubsystemCapability armWithMode:kEnumSecuritySubsystemAlarmModeON onModel:self.subsystemModel];
}

- (PMKPromise *)armPartial {
    return [SecuritySubsystemCapability armWithMode:kArmPartialMode onModel:self.subsystemModel];
}

- (PMKPromise *)disArm {
    return [SecuritySubsystemCapability disarmOnModel:self.subsystemModel];
}

- (PMKPromise *)armByPassedModeOn {
    return [SecuritySubsystemCapability armBypassedWithMode:@"ON" onModel:self.subsystemModel];
}

- (PMKPromise *)armByPassedModePartial {
    return [SecuritySubsystemCapability armBypassedWithMode:@"PARTIAL" onModel:self.subsystemModel];
}

- (PMKPromise *)armByPassedPartial {
    return [SecuritySubsystemCapability armBypassedWithMode:kArmPartialMode onModel:self.subsystemModel];
}

#pragma mark - Number of devices for mode


- (int)numberOfOfflineDevicesModeON {
    return (int)[self offlineDevicesModeON].count;
}

- (int)numberOfOfflineDevicesModePARTIAL{
    return (int)[self offlineDevicesModePARTIAL].count;
}

- (NSArray *)offlineDevicesModeON {
    NSMutableSet *offlineDevices = [NSMutableSet setWithArray:[self offlineDeviceIds]];
    NSSet *modeOnDevices = [NSSet setWithArray:[self modeONDevices]];
    [offlineDevices intersectSet:modeOnDevices];
    
    return [offlineDevices allObjects];
}

- (NSArray *)offlineDevicesModePARTIAL {
    NSMutableSet *offlineDevices = [NSMutableSet setWithArray:[self offlineDeviceIds]];
    NSSet *modeOnDevices = [NSSet setWithArray:[self modePARTIALDevices]];
    [offlineDevices intersectSet:modeOnDevices];
    
    return [offlineDevices allObjects];
}

- (NSArray *)openDevicesModeON {
    NSMutableSet *triggerDevices = [NSMutableSet setWithArray:[self triggerDeviceIds]];
    NSSet *modeOnDevices = [NSSet setWithArray:[self modeONDevices]];
    [triggerDevices intersectSet:modeOnDevices];
    
    return [triggerDevices allObjects];
}

- (int)numberOfOpenDevicesModeON {
    return (int)[[self openDevicesModeON] count];
}

- (NSArray *)openDevicesModePARTIAL {
    NSMutableSet *triggerDevices = [NSMutableSet setWithArray:[self triggerDeviceIds]];
    NSSet *modeOnDevices = [NSSet setWithArray:[self modePARTIALDevices]];
    [triggerDevices intersectSet:modeOnDevices];
    return [triggerDevices allObjects];
}

- (int)numberOfOpenDevicesModePARTIAL{
    return (int)[[self openDevicesModePARTIAL] count];
}

#pragma mark ring segments
- (int)totalNumberOfSegments {
    return ([self numberOfArmedDevices] + [self numberOfByPassedDevices]);
}

- (int)numberOfRedSegments {
    NSMutableSet *offlineSet = [NSMutableSet setWithArray:[self offlineDeviceIds]];
    NSArray *armedDevices = [SecuritySubsystemCapability getArmedDevicesFromModel:self.subsystemModel];
    NSSet *armedSet = [NSSet  setWithArray:armedDevices];
    [offlineSet intersectSet:armedSet];
    return (int)[offlineSet allObjects].count;
}

- (int)numberOfGreySegments {
    return [self numberOfByPassedDevices];
}

- (int)numberOfWhiteSegments {
    NSArray *armedDevices = [SecuritySubsystemCapability getArmedDevicesFromModel:self.subsystemModel];
    
    int count = 0;
    
    if ([self.mode isEqualToString:@"ON"]) {
        
        count = (int)(armedDevices.count - (int)[self offlineDevicesModeON].count);
    } else if ([self.mode isEqualToString:@"PARTIAL"]) {
        count = (int)(armedDevices.count - (int)[self offlineDevicesModePARTIAL].count);
    }
    
    return count;
}

- (void)lastTriggeredString:(void (^)(NSString *lastTriggered))completeBlock {
    __block NSString *lastTriggered = @"No Alarms Triggered";

    if (!self.subsystemModel) {
        completeBlock(lastTriggered);
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SubsystemsController getSubsystemHistory:self.subsystemModel withToken:@"" entriesLimit:1 includeIncidents:YES].thenInBackground(^(SubsystemListHistoryEntriesResponse *response) {
            NSArray *results = [response getResults];
            if (results.count > 0) {
                Model *model = [[Model alloc] initWithAttributes:results[0]];
                NSNumber *timeStamp = (NSNumber *)[model getAttribute:@"timestamp"];
                NSDate *lastTriggeredDate = [NSDate dateWithTimeIntervalSince1970:(timeStamp.doubleValue / 1000)];
                if ([lastTriggeredDate compare:[NSDate dateWithTimeIntervalSince1970:0]] != NSOrderedSame) {
                    if ([lastTriggeredDate isSameDayWith:[NSDate date]]) {
                        lastTriggered = [NSString stringWithFormat:@"Today %@", [lastTriggeredDate formatDateTimeStamp]];
                    } else {
                        lastTriggered = [NSString stringWithFormat:@"%@", [lastTriggeredDate formatFullDate]];
                    }
                }
            }
            completeBlock(lastTriggered);
        });
    });
}

@end
