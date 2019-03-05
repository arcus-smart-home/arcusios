

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "GlassCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrGlassBreak=@"glass:break";

NSString *const kAttrGlassBreakchanged=@"glass:breakchanged";



NSString *const kEnumGlassBreakSAFE = @"SAFE";
NSString *const kEnumGlassBreakDETECTED = @"DETECTED";


@implementation GlassCapability
+ (NSString *)namespace { return @"glass"; }
+ (NSString *)name { return @"Glass"; }

+ (NSString *)getBreakFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [GlassCapabilityLegacy getBreak:modelObj];
  
}


+ (NSDate *)getBreakchangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [GlassCapabilityLegacy getBreakchanged:modelObj];
  
}



@end
