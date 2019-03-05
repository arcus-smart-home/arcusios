//
//  SubsystemsController.h
//  Pods
//
//  Created by Arcus Team on 8/18/15.
//
//

#import <Foundation/Foundation.h>


extern NSString *const kSubsystemInitializedNotification;
extern NSString *const kSubsystemUpdatedNotification;

@class PMKPromise;
@class SecuritySubsystemAlertController;
@class SafetySubsystemAlertController;
@class SubsystemModel;
@class ClimateSubSystemController;
@class DoorsNLocksSubsystemController;
@class CameraSubsystemController;
@class PresenceSubsystemController;
@class LightsNSwitchesSubsystemController;
@class WaterSubsystemController;
@class CareSubsystemController;
@class LawnNGardenSubsystemController;
@class CellBackupSubsystemController;
@class WeatherSubsystemController;

@protocol SubsystemProtocol <NSObject>

@required
@property (nonatomic, strong, readonly) SubsystemModel *subsystemModel;
@property (nonatomic, assign, readonly) int numberOfDevices;

@property (nonatomic, assign, readonly) NSArray *allDeviceIds;

@end


@protocol AlarmSubsystemProtocol <NSObject, SubsystemProtocol>
@optional

@property (nonatomic, assign, readonly) int numberOfOfflineDevices;
@property (nonatomic, assign, readonly) int numberOfOnlineDevices;

@property (nonatomic, assign, readonly) NSArray *onlineDeviceIds;
@property (nonatomic, assign, readonly) NSArray *offlineDeviceIds;

@property (nonatomic, assign, readonly) BOOL isCallTreeEnabled;
@property (nonatomic, assign, readonly) NSArray *callTree;
@property (nonatomic, assign, readonly) BOOL isAlarmTriggered;

- (void)saveNewCallTree:(NSArray *)newCallTree;

- (BOOL)getSilent;
- (void)setSilent:(BOOL)silent;

- (NSDictionary *) getCurrentTriggered;
- (BOOL)hasWaterShutOffVales;
- (BOOL)getWaterShutOff;
- (void)setWaterShutOff:(BOOL)waterShutOff;

@end



@interface SubsystemsController : NSObject

+ (instancetype)sharedInstance;

- (void)clearCurrentUserStates;

@property (nonatomic, strong, readonly) SafetySubsystemAlertController *safetyController;
@property (nonatomic, strong, readonly) SecuritySubsystemAlertController *securityController;
@property (nonatomic, strong, readonly) ClimateSubSystemController *climateController;
@property (nonatomic, strong, readonly) DoorsNLocksSubsystemController *doorsNLocksController;
@property (nonatomic, strong, readonly) CameraSubsystemController *camerasController;
@property (nonatomic, strong, readonly) PresenceSubsystemController *presenceController;
@property (nonatomic, strong, readonly) LightsNSwitchesSubsystemController *lightsNSwitchesController;
@property (nonatomic, strong, readonly) WaterSubsystemController *waterController;
@property (nonatomic, strong, readonly) CareSubsystemController *careController;
@property (nonatomic, strong, readonly) LawnNGardenSubsystemController *lawnNGardenController;
@property (nonatomic, strong, readonly) CellBackupSubsystemController *cellBackupSubsystemController;
@property (nonatomic, strong, readonly) WeatherSubsystemController *weatherSubsystemController;

@property (atomic, assign, readonly) BOOL isAlarmTriggered;

- (PMKPromise *)retrieveSubsystemsForPlaceId:(NSString *)placeId;
- (void)addOrUpdateSubsystemWithModel:(SubsystemModel *)attributes andSource:(NSString *)source;

#pragma mark - Subsystem History
+ (PMKPromise *)getSubsystemHistory:(SubsystemModel *)modelObj withToken:(NSString *)token entriesLimit:(int)limit includeIncidents:(BOOL)includeIncidents;

@end
