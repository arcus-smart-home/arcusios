

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ValveCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrValveValvestate=@"valv:valvestate";

NSString *const kAttrValveValvestatechanged=@"valv:valvestatechanged";



NSString *const kEnumValveValvestateCLOSED = @"CLOSED";
NSString *const kEnumValveValvestateOPEN = @"OPEN";
NSString *const kEnumValveValvestateOPENING = @"OPENING";
NSString *const kEnumValveValvestateCLOSING = @"CLOSING";
NSString *const kEnumValveValvestateOBSTRUCTION = @"OBSTRUCTION";


@implementation ValveCapability
+ (NSString *)namespace { return @"valv"; }
+ (NSString *)name { return @"Valve"; }

+ (NSString *)getValvestateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ValveCapabilityLegacy getValvestate:modelObj];
  
}

+ (NSString *)setValvestate:(NSString *)valvestate onModel:(DeviceModel *)modelObj {
  [ValveCapabilityLegacy setValvestate:valvestate model:modelObj];
  
  return [ValveCapabilityLegacy getValvestate:modelObj];
  
}


+ (NSDate *)getValvestatechangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ValveCapabilityLegacy getValvestatechanged:modelObj];
  
}



@end
