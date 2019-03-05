

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProMonitoringSettingsCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrProMonitoringSettingsNotifyWhenAvailable=@"promon:notifyWhenAvailable";

NSString *const kAttrProMonitoringSettingsTrial=@"promon:trial";

NSString *const kAttrProMonitoringSettingsActivatedOn=@"promon:activatedOn";

NSString *const kAttrProMonitoringSettingsSupportedAlerts=@"promon:supportedAlerts";

NSString *const kAttrProMonitoringSettingsMonitoredAlerts=@"promon:monitoredAlerts";

NSString *const kAttrProMonitoringSettingsAddressVerification=@"promon:addressVerification";

NSString *const kAttrProMonitoringSettingsPermitRequired=@"promon:permitRequired";

NSString *const kAttrProMonitoringSettingsPermitNumber=@"promon:permitNumber";

NSString *const kAttrProMonitoringSettingsAdults=@"promon:adults";

NSString *const kAttrProMonitoringSettingsChildren=@"promon:children";

NSString *const kAttrProMonitoringSettingsPets=@"promon:pets";

NSString *const kAttrProMonitoringSettingsDirections=@"promon:directions";

NSString *const kAttrProMonitoringSettingsGateCode=@"promon:gateCode";

NSString *const kAttrProMonitoringSettingsInstructions=@"promon:instructions";

NSString *const kAttrProMonitoringSettingsTestCallStatus=@"promon:testCallStatus";

NSString *const kAttrProMonitoringSettingsTestCallTime=@"promon:testCallTime";

NSString *const kAttrProMonitoringSettingsTestCallMessage=@"promon:testCallMessage";

NSString *const kAttrProMonitoringSettingsExternalId=@"promon:externalId";

NSString *const kAttrProMonitoringSettingsCertUrl=@"promon:certUrl";


NSString *const kCmdProMonitoringSettingsCheckAvailability=@"promon:CheckAvailability";

NSString *const kCmdProMonitoringSettingsJoinTrial=@"promon:JoinTrial";

NSString *const kCmdProMonitoringSettingsValidateAddress=@"promon:ValidateAddress";

NSString *const kCmdProMonitoringSettingsUpdateAddress=@"promon:UpdateAddress";

NSString *const kCmdProMonitoringSettingsListDepartments=@"promon:ListDepartments";

NSString *const kCmdProMonitoringSettingsCheckSensors=@"promon:CheckSensors";

NSString *const kCmdProMonitoringSettingsActivate=@"promon:Activate";

NSString *const kCmdProMonitoringSettingsTestCall=@"promon:TestCall";

NSString *const kCmdProMonitoringSettingsReset=@"promon:Reset";


NSString *const kEnumProMonitoringSettingsAddressVerificationUNVERIFIED = @"UNVERIFIED";
NSString *const kEnumProMonitoringSettingsAddressVerificationRESIDENTIAL = @"RESIDENTIAL";
NSString *const kEnumProMonitoringSettingsTestCallStatusIDLE = @"IDLE";
NSString *const kEnumProMonitoringSettingsTestCallStatusWAITING = @"WAITING";
NSString *const kEnumProMonitoringSettingsTestCallStatusSUCCEEDED = @"SUCCEEDED";
NSString *const kEnumProMonitoringSettingsTestCallStatusFAILED = @"FAILED";


@implementation ProMonitoringSettingsCapability
+ (NSString *)namespace { return @"promon"; }
+ (NSString *)name { return @"ProMonitoringSettings"; }

+ (BOOL)getNotifyWhenAvailableFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getNotifyWhenAvailable:modelObj] boolValue];
  
}

+ (BOOL)setNotifyWhenAvailable:(BOOL)notifyWhenAvailable onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setNotifyWhenAvailable:notifyWhenAvailable model:modelObj];
  
  return [[ProMonitoringSettingsCapabilityLegacy getNotifyWhenAvailable:modelObj] boolValue];
  
}


+ (BOOL)getTrialFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getTrial:modelObj] boolValue];
  
}


+ (NSDate *)getActivatedOnFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getActivatedOn:modelObj];
  
}


+ (NSArray *)getSupportedAlertsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getSupportedAlerts:modelObj];
  
}


+ (NSArray *)getMonitoredAlertsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getMonitoredAlerts:modelObj];
  
}


+ (NSString *)getAddressVerificationFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getAddressVerification:modelObj];
  
}


+ (BOOL)getPermitRequiredFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getPermitRequired:modelObj] boolValue];
  
}


+ (NSString *)getPermitNumberFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getPermitNumber:modelObj];
  
}

+ (NSString *)setPermitNumber:(NSString *)permitNumber onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setPermitNumber:permitNumber model:modelObj];
  
  return [ProMonitoringSettingsCapabilityLegacy getPermitNumber:modelObj];
  
}


+ (int)getAdultsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getAdults:modelObj] intValue];
  
}

+ (int)setAdults:(int)adults onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setAdults:adults model:modelObj];
  
  return [[ProMonitoringSettingsCapabilityLegacy getAdults:modelObj] intValue];
  
}


+ (int)getChildrenFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getChildren:modelObj] intValue];
  
}

+ (int)setChildren:(int)children onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setChildren:children model:modelObj];
  
  return [[ProMonitoringSettingsCapabilityLegacy getChildren:modelObj] intValue];
  
}


+ (int)getPetsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProMonitoringSettingsCapabilityLegacy getPets:modelObj] intValue];
  
}

+ (int)setPets:(int)pets onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setPets:pets model:modelObj];
  
  return [[ProMonitoringSettingsCapabilityLegacy getPets:modelObj] intValue];
  
}


+ (NSString *)getDirectionsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getDirections:modelObj];
  
}

+ (NSString *)setDirections:(NSString *)directions onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setDirections:directions model:modelObj];
  
  return [ProMonitoringSettingsCapabilityLegacy getDirections:modelObj];
  
}


+ (NSString *)getGateCodeFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getGateCode:modelObj];
  
}

+ (NSString *)setGateCode:(NSString *)gateCode onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setGateCode:gateCode model:modelObj];
  
  return [ProMonitoringSettingsCapabilityLegacy getGateCode:modelObj];
  
}


+ (NSString *)getInstructionsFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getInstructions:modelObj];
  
}

+ (NSString *)setInstructions:(NSString *)instructions onModel:(ProMonitoringSettingsModel *)modelObj {
  [ProMonitoringSettingsCapabilityLegacy setInstructions:instructions model:modelObj];
  
  return [ProMonitoringSettingsCapabilityLegacy getInstructions:modelObj];
  
}


+ (NSString *)getTestCallStatusFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getTestCallStatus:modelObj];
  
}


+ (NSDate *)getTestCallTimeFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getTestCallTime:modelObj];
  
}


+ (NSString *)getTestCallMessageFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getTestCallMessage:modelObj];
  
}


+ (NSString *)getExternalIdFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getExternalId:modelObj];
  
}


+ (NSString *)getCertUrlFromModel:(ProMonitoringSettingsModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProMonitoringSettingsCapabilityLegacy getCertUrl:modelObj];
  
}




+ (PMKPromise *) checkAvailabilityOnModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy checkAvailability:modelObj ];
}


+ (PMKPromise *) joinTrialWithCode:(NSString *)code onModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy joinTrial:modelObj code:code];

}


+ (PMKPromise *) validateAddressWithStreetAddress:(id)streetAddress onModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy validateAddress:modelObj streetAddress:streetAddress];

}


+ (PMKPromise *) updateAddressWithStreetAddress:(id)streetAddress withResidential:(BOOL)residential onModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy updateAddress:modelObj streetAddress:streetAddress residential:residential];

}


+ (PMKPromise *) listDepartmentsOnModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy listDepartments:modelObj ];
}


+ (PMKPromise *) checkSensorsOnModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy checkSensors:modelObj ];
}


+ (PMKPromise *) activateWithTestCall:(BOOL)testCall onModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy activate:modelObj testCall:testCall];

}


+ (PMKPromise *) testCallOnModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy testCall:modelObj ];
}


+ (PMKPromise *) resetOnModel:(ProMonitoringSettingsModel *)modelObj {
  return [ProMonitoringSettingsCapabilityLegacy reset:modelObj ];
}

@end
