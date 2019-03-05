

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AlertCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAlertState=@"alert:state";

NSString *const kAttrAlertMaxAlertSecs=@"alert:maxAlertSecs";

NSString *const kAttrAlertDefaultMaxAlertSecs=@"alert:defaultMaxAlertSecs";

NSString *const kAttrAlertLastAlertTime=@"alert:lastAlertTime";



NSString *const kEnumAlertStateQUIET = @"QUIET";
NSString *const kEnumAlertStateALERTING = @"ALERTING";


@implementation AlertCapability
+ (NSString *)namespace { return @"alert"; }
+ (NSString *)name { return @"Alert"; }

+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlertCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(DeviceModel *)modelObj {
  [AlertCapabilityLegacy setState:state model:modelObj];
  
  return [AlertCapabilityLegacy getState:modelObj];
  
}


+ (int)getMaxAlertSecsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlertCapabilityLegacy getMaxAlertSecs:modelObj] intValue];
  
}

+ (int)setMaxAlertSecs:(int)maxAlertSecs onModel:(DeviceModel *)modelObj {
  [AlertCapabilityLegacy setMaxAlertSecs:maxAlertSecs model:modelObj];
  
  return [[AlertCapabilityLegacy getMaxAlertSecs:modelObj] intValue];
  
}


+ (int)getDefaultMaxAlertSecsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AlertCapabilityLegacy getDefaultMaxAlertSecs:modelObj] intValue];
  
}


+ (NSDate *)getLastAlertTimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AlertCapabilityLegacy getLastAlertTime:modelObj];
  
}



@end
