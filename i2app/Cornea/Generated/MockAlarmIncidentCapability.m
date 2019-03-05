

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "MockAlarmIncidentCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdMockAlarmIncidentContacted=@"incidentmock:Contacted";

NSString *const kCmdMockAlarmIncidentDispatchCancelled=@"incidentmock:DispatchCancelled";

NSString *const kCmdMockAlarmIncidentDispatchAccepted=@"incidentmock:DispatchAccepted";

NSString *const kCmdMockAlarmIncidentDispatchRefused=@"incidentmock:DispatchRefused";




@implementation MockAlarmIncidentCapability
+ (NSString *)namespace { return @"incidentmock"; }
+ (NSString *)name { return @"MockAlarmIncident"; }



+ (PMKPromise *) contactedWithPerson:(NSString *)person onModel:(AlarmIncidentModel *)modelObj {
  return [MockAlarmIncidentCapabilityLegacy contacted:modelObj person:person];

}


+ (PMKPromise *) dispatchCancelledWithPerson:(NSString *)person onModel:(AlarmIncidentModel *)modelObj {
  return [MockAlarmIncidentCapabilityLegacy dispatchCancelled:modelObj person:person];

}


+ (PMKPromise *) dispatchAcceptedWithAuthority:(NSString *)authority onModel:(AlarmIncidentModel *)modelObj {
  return [MockAlarmIncidentCapabilityLegacy dispatchAccepted:modelObj authority:authority];

}


+ (PMKPromise *) dispatchRefusedWithAuthority:(NSString *)authority onModel:(AlarmIncidentModel *)modelObj {
  return [MockAlarmIncidentCapabilityLegacy dispatchRefused:modelObj authority:authority];

}

@end
