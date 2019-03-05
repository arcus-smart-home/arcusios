

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;





/** The addresses and version of all the devices that have OTA firmware upgrades requests issued. */
extern NSString *const kAttrPlaceMonitorSubsystemUpdatedDevices;

/** The addresses of all the devices that have default rules and schedules . */
extern NSString *const kAttrPlaceMonitorSubsystemDefaultRulesDevices;

/** The addresses of all the devices that have offline notifications sent . */
extern NSString *const kAttrPlaceMonitorSubsystemOfflineNotificationSent;

/** The addresses of all the devices that have a low battery notification sent. */
extern NSString *const kAttrPlaceMonitorSubsystemLowBatteryNotificationSent;

/** Pairing state of the place. */
extern NSString *const kAttrPlaceMonitorSubsystemPairingState;

/** The list of current smart home alerts. */
extern NSString *const kAttrPlaceMonitorSubsystemSmartHomeAlerts;


extern NSString *const kCmdPlaceMonitorSubsystemRenderAlerts;


extern NSString *const kEvtPlaceMonitorSubsystemHubOffline;

extern NSString *const kEvtPlaceMonitorSubsystemHubOnline;

extern NSString *const kEvtPlaceMonitorSubsystemDeviceOffline;

extern NSString *const kEvtPlaceMonitorSubsystemDeviceOnline;

extern NSString *const kEnumPlaceMonitorSubsystemPairingStatePAIRING;
extern NSString *const kEnumPlaceMonitorSubsystemPairingStateUNPAIRING;
extern NSString *const kEnumPlaceMonitorSubsystemPairingStateIDLE;
extern NSString *const kEnumPlaceMonitorSubsystemPairingStatePARTIAL;


@interface PlaceMonitorSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getUpdatedDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getDefaultRulesDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getOfflineNotificationSentFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getLowBatteryNotificationSentFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getPairingStateFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getSmartHomeAlertsFromModel:(SubsystemModel *)modelObj;





/** Renders all alerts */
+ (PMKPromise *) renderAlertsOnModel:(Model *)modelObj;



@end
