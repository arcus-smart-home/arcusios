

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PresenceSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPresenceSubsystemOccupied=@"subspres:occupied";

NSString *const kAttrPresenceSubsystemOccupiedConf=@"subspres:occupiedConf";

NSString *const kAttrPresenceSubsystemPeopleAtHome=@"subspres:peopleAtHome";

NSString *const kAttrPresenceSubsystemPeopleAway=@"subspres:peopleAway";

NSString *const kAttrPresenceSubsystemDevicesAtHome=@"subspres:devicesAtHome";

NSString *const kAttrPresenceSubsystemDevicesAway=@"subspres:devicesAway";

NSString *const kAttrPresenceSubsystemAllDevices=@"subspres:allDevices";


NSString *const kCmdPresenceSubsystemGetPresenceAnalysis=@"subspres:GetPresenceAnalysis";


NSString *const kEvtPresenceSubsystemArrived=@"subspres:Arrived";

NSString *const kEvtPresenceSubsystemDeparted=@"subspres:Departed";

NSString *const kEvtPresenceSubsystemPersonArrived=@"subspres:PersonArrived";

NSString *const kEvtPresenceSubsystemPersonDeparted=@"subspres:PersonDeparted";

NSString *const kEvtPresenceSubsystemDeviceArrived=@"subspres:DeviceArrived";

NSString *const kEvtPresenceSubsystemDeviceDeparted=@"subspres:DeviceDeparted";

NSString *const kEvtPresenceSubsystemDeviceAssignedToPerson=@"subspres:DeviceAssignedToPerson";

NSString *const kEvtPresenceSubsystemDeviceUnassignedFromPerson=@"subspres:DeviceUnassignedFromPerson";

NSString *const kEvtPresenceSubsystemPlaceOccupied=@"subspres:PlaceOccupied";

NSString *const kEvtPresenceSubsystemPlaceUnoccupied=@"subspres:PlaceUnoccupied";



@implementation PresenceSubsystemCapability
+ (NSString *)namespace { return @"subspres"; }
+ (NSString *)name { return @"PresenceSubsystem"; }

+ (BOOL)getOccupiedFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PresenceSubsystemCapabilityLegacy getOccupied:modelObj] boolValue];
  
}


+ (id)getOccupiedConfFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getOccupiedConf:modelObj];
  
}


+ (NSArray *)getPeopleAtHomeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getPeopleAtHome:modelObj];
  
}


+ (NSArray *)getPeopleAwayFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getPeopleAway:modelObj];
  
}


+ (NSArray *)getDevicesAtHomeFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getDevicesAtHome:modelObj];
  
}


+ (NSArray *)getDevicesAwayFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getDevicesAway:modelObj];
  
}


+ (NSArray *)getAllDevicesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PresenceSubsystemCapabilityLegacy getAllDevices:modelObj];
  
}




+ (PMKPromise *) getPresenceAnalysisOnModel:(SubsystemModel *)modelObj {
  return [PresenceSubsystemCapabilityLegacy getPresenceAnalysis:modelObj ];
}

@end
