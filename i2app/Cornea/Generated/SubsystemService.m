

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SubsystemService.h"
#import <i2app-Swift.h>

@implementation SubsystemService
+ (NSString *)name { return @"SubsystemService"; }
+ (NSString *)address { return @"SERV:subs:"; }


+ (PMKPromise *) listSubsystemsWithPlaceId:(NSString *)placeId {
  return [SubsystemServiceLegacy listSubsystems:placeId];

}


+ (PMKPromise *) reload {
  return [SubsystemServiceLegacy reload];
}

@end
