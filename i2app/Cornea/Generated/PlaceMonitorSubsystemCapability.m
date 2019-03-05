

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PlaceMonitorSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPlaceMonitorSubsystemUpdatedDevices=@"subplacemonitor:updatedDevices";

NSString *const kAttrPlaceMonitorSubsystemDefaultRulesDevices=@"subplacemonitor:defaultRulesDevices";

NSString *const kAttrPlaceMonitorSubsystemOfflineNotificationSent=@"subplacemonitor:offlineNotificationSent";

NSString *const kAttrPlaceMonitorSubsystemLowBatteryNotificationSent=@"subplacemonitor:lowBatteryNotificationSent";

NSString *const kAttrPlaceMonitorSubsystemPairingState=@"subplacemonitor:pairingState";

NSString *const kAttrPlaceMonitorSubsystemSmartHomeAlerts=@"subplacemonitor:smartHomeAlerts";


NSString *const kCmdPlaceMonitorSubsystemRenderAlerts=@"subplacemonitor:RenderAlerts";


NSString *const kEvtPlaceMonitorSubsystemHubOffline=@"subplacemonitor:HubOffline";

NSString *const kEvtPlaceMonitorSubsystemHubOnline=@"subplacemonitor:HubOnline";

NSString *const kEvtPlaceMonitorSubsystemDeviceOffline=@"subplacemonitor:DeviceOffline";

NSString *const kEvtPlaceMonitorSubsystemDeviceOnline=@"subplacemonitor:DeviceOnline";

NSString *const kEnumPlaceMonitorSubsystemPairingStatePAIRING = @"PAIRING";
NSString *const kEnumPlaceMonitorSubsystemPairingStateUNPAIRING = @"UNPAIRING";
NSString *const kEnumPlaceMonitorSubsystemPairingStateIDLE = @"IDLE";
NSString *const kEnumPlaceMonitorSubsystemPairingStatePARTIAL = @"PARTIAL";


@implementation PlaceMonitorSubsystemCapability
+ (NSString *)namespace { return @"subplacemonitor"; }
+ (NSString *)name { return @"PlaceMonitorSubsystem"; }

+ (NSArray *)getUpdatedDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getUpdatedDevices:modelObj];
  
}


+ (NSArray *)getDefaultRulesDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getDefaultRulesDevices:modelObj];
  
}


+ (NSDictionary *)getOfflineNotificationSentFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getOfflineNotificationSent:modelObj];
  
}


+ (NSDictionary *)getLowBatteryNotificationSentFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getLowBatteryNotificationSent:modelObj];
  
}


+ (NSString *)getPairingStateFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getPairingState:modelObj];
  
}


+ (NSArray *)getSmartHomeAlertsFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceMonitorSubsystemCapabilityLegacy getSmartHomeAlerts:modelObj];
  
}




+ (PMKPromise *) renderAlertsOnModel:(SubsystemModel *)modelObj {
  return [PlaceMonitorSubsystemCapabilityLegacy renderAlerts:modelObj ];
}

@end
