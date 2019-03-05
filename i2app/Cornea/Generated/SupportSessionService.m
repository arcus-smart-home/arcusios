

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SupportSessionService.h"
#import <i2app-Swift.h>

@implementation SupportSessionService
+ (NSString *)name { return @"SupportSessionService"; }
+ (NSString *)address { return @"SERV:suppcustsession:"; }


+ (PMKPromise *) listAllActiveSessionsWithLimit:(int)limit withToken:(NSString *)token {
  return [SupportSessionServiceLegacy listAllActiveSessions:limit token:token];

}

@end
