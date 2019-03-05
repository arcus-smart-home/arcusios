

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "EasCodeService.h"
#import <i2app-Swift.h>

@implementation EasCodeService
+ (NSString *)name { return @"EasCodeService"; }
+ (NSString *)address { return @"SERV:eascode:"; }


+ (PMKPromise *) listEasCodes {
  return [EasCodeServiceLegacy listEasCodes];
}

@end
