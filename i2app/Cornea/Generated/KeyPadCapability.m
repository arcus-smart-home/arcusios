

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "KeyPadCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrKeyPadAlarmState=@"keypad:alarmState";

NSString *const kAttrKeyPadAlarmMode=@"keypad:alarmMode";

NSString *const kAttrKeyPadAlarmSounder=@"keypad:alarmSounder";

NSString *const kAttrKeyPadEnabledSounds=@"keypad:enabledSounds";


NSString *const kCmdKeyPadBeginArming=@"keypad:BeginArming";

NSString *const kCmdKeyPadArmed=@"keypad:Armed";

NSString *const kCmdKeyPadDisarmed=@"keypad:Disarmed";

NSString *const kCmdKeyPadSoaking=@"keypad:Soaking";

NSString *const kCmdKeyPadAlerting=@"keypad:Alerting";

NSString *const kCmdKeyPadChime=@"keypad:Chime";

NSString *const kCmdKeyPadArmingUnavailable=@"keypad:ArmingUnavailable";


NSString *const kEvtKeyPadArmPressed=@"keypad:ArmPressed";

NSString *const kEvtKeyPadDisarmPressed=@"keypad:DisarmPressed";

NSString *const kEvtKeyPadPanicPressed=@"keypad:PanicPressed";

NSString *const kEvtKeyPadInvalidPinEntered=@"keypad:InvalidPinEntered";

NSString *const kEnumKeyPadAlarmStateDISARMED = @"DISARMED";
NSString *const kEnumKeyPadAlarmStateARMED = @"ARMED";
NSString *const kEnumKeyPadAlarmStateARMING = @"ARMING";
NSString *const kEnumKeyPadAlarmStateALERTING = @"ALERTING";
NSString *const kEnumKeyPadAlarmStateSOAKING = @"SOAKING";
NSString *const kEnumKeyPadAlarmModeON = @"ON";
NSString *const kEnumKeyPadAlarmModePARTIAL = @"PARTIAL";
NSString *const kEnumKeyPadAlarmModeOFF = @"OFF";
NSString *const kEnumKeyPadAlarmSounderON = @"ON";
NSString *const kEnumKeyPadAlarmSounderOFF = @"OFF";


@implementation KeyPadCapability
+ (NSString *)namespace { return @"keypad"; }
+ (NSString *)name { return @"KeyPad"; }

+ (NSString *)getAlarmStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [KeyPadCapabilityLegacy getAlarmState:modelObj];
  
}

+ (NSString *)setAlarmState:(NSString *)alarmState onModel:(DeviceModel *)modelObj {
  [KeyPadCapabilityLegacy setAlarmState:alarmState model:modelObj];
  
  return [KeyPadCapabilityLegacy getAlarmState:modelObj];
  
}


+ (NSString *)getAlarmModeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [KeyPadCapabilityLegacy getAlarmMode:modelObj];
  
}

+ (NSString *)setAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj {
  [KeyPadCapabilityLegacy setAlarmMode:alarmMode model:modelObj];
  
  return [KeyPadCapabilityLegacy getAlarmMode:modelObj];
  
}


+ (NSString *)getAlarmSounderFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [KeyPadCapabilityLegacy getAlarmSounder:modelObj];
  
}

+ (NSString *)setAlarmSounder:(NSString *)alarmSounder onModel:(DeviceModel *)modelObj {
  [KeyPadCapabilityLegacy setAlarmSounder:alarmSounder model:modelObj];
  
  return [KeyPadCapabilityLegacy getAlarmSounder:modelObj];
  
}


+ (NSArray *)getEnabledSoundsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [KeyPadCapabilityLegacy getEnabledSounds:modelObj];
  
}

+ (NSArray *)setEnabledSounds:(NSArray *)enabledSounds onModel:(DeviceModel *)modelObj {
  [KeyPadCapabilityLegacy setEnabledSounds:enabledSounds model:modelObj];
  
  return [KeyPadCapabilityLegacy getEnabledSounds:modelObj];
  
}




+ (PMKPromise *) beginArmingWithDelayInS:(int)delayInS withAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy beginArming:modelObj delayInS:delayInS alarmMode:alarmMode];

}


+ (PMKPromise *) armedWithAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy armed:modelObj alarmMode:alarmMode];

}


+ (PMKPromise *) disarmedOnModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy disarmed:modelObj ];
}


+ (PMKPromise *) soakingWithDurationInS:(int)durationInS withAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy soaking:modelObj durationInS:durationInS alarmMode:alarmMode];

}


+ (PMKPromise *) alertingWithAlarmMode:(NSString *)alarmMode onModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy alerting:modelObj alarmMode:alarmMode];

}


+ (PMKPromise *) chimeOnModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy chime:modelObj ];
}


+ (PMKPromise *) armingUnavailableOnModel:(DeviceModel *)modelObj {
  return [KeyPadCapabilityLegacy armingUnavailable:modelObj ];
}

@end
