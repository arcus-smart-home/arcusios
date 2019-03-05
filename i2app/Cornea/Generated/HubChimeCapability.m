

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubChimeCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdHubChimeChime=@"hubchime:chime";




@implementation HubChimeCapability
+ (NSString *)namespace { return @"hubchime"; }
+ (NSString *)name { return @"HubChime"; }



+ (PMKPromise *) chimeOnModel:(HubModel *)modelObj {
  return [HubChimeCapabilityLegacy chime:modelObj ];
}

@end
