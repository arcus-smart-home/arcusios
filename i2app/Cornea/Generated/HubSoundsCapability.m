

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubSoundsCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubSoundsPlaying=@"hubsounds:playing";

NSString *const kAttrHubSoundsSource=@"hubsounds:source";


NSString *const kCmdHubSoundsPlayTone=@"hubsounds:PlayTone";

NSString *const kCmdHubSoundsQuiet=@"hubsounds:Quiet";




@implementation HubSoundsCapability
+ (NSString *)namespace { return @"hubsounds"; }
+ (NSString *)name { return @"HubSounds"; }

+ (BOOL)getPlayingFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubSoundsCapabilityLegacy getPlaying:modelObj] boolValue];
  
}


+ (NSString *)getSourceFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubSoundsCapabilityLegacy getSource:modelObj];
  
}




+ (PMKPromise *) playToneWithTone:(NSString *)tone withDurationSec:(int)durationSec onModel:(HubModel *)modelObj {
  return [HubSoundsCapabilityLegacy playTone:modelObj tone:tone durationSec:durationSec];

}


+ (PMKPromise *) quietOnModel:(HubModel *)modelObj {
  return [HubSoundsCapabilityLegacy quiet:modelObj ];
}

@end
