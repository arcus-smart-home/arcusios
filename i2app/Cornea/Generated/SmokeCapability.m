

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SmokeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSmokeSmoke=@"smoke:smoke";

NSString *const kAttrSmokeSmokechanged=@"smoke:smokechanged";



NSString *const kEnumSmokeSmokeSAFE = @"SAFE";
NSString *const kEnumSmokeSmokeDETECTED = @"DETECTED";


@implementation SmokeCapability
+ (NSString *)namespace { return @"smoke"; }
+ (NSString *)name { return @"Smoke"; }

+ (NSString *)getSmokeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SmokeCapabilityLegacy getSmoke:modelObj];
  
}


+ (NSDate *)getSmokechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SmokeCapabilityLegacy getSmokechanged:modelObj];
  
}



@end
