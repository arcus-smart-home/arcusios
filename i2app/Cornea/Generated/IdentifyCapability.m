

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IdentifyCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdIdentifyIdentify=@"ident:Identify";




@implementation IdentifyCapability
+ (NSString *)namespace { return @"ident"; }
+ (NSString *)name { return @"Identify"; }



+ (PMKPromise *) identifyOnModel:(DeviceModel *)modelObj {
  return [IdentifyCapabilityLegacy identify:modelObj ];
}

@end
