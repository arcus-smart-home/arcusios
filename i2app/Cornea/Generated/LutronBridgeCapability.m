

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LutronBridgeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLutronBridgeOperatingmode=@"lutronbridge:operatingmode";

NSString *const kAttrLutronBridgeSerialnumber=@"lutronbridge:serialnumber";



NSString *const kEnumLutronBridgeOperatingmodeSTARTUP = @"STARTUP";
NSString *const kEnumLutronBridgeOperatingmodeNORMAL = @"NORMAL";
NSString *const kEnumLutronBridgeOperatingmodeASSOCIATION = @"ASSOCIATION";
NSString *const kEnumLutronBridgeOperatingmodeERROR = @"ERROR";


@implementation LutronBridgeCapability
+ (NSString *)namespace { return @"lutronbridge"; }
+ (NSString *)name { return @"LutronBridge"; }

+ (NSString *)getOperatingmodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LutronBridgeCapabilityLegacy getOperatingmode:modelObj];
  
}


+ (NSString *)getSerialnumberFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LutronBridgeCapabilityLegacy getSerialnumber:modelObj];
  
}



@end
