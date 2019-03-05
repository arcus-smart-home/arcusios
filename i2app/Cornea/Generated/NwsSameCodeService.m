

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "NwsSameCodeService.h"
#import <i2app-Swift.h>

@implementation NwsSameCodeService
+ (NSString *)name { return @"NwsSameCodeService"; }
+ (NSString *)address { return @"SERV:nwssamecode:"; }


+ (PMKPromise *) listSameCountiesWithStateCode:(NSString *)stateCode {
  return [NwsSameCodeServiceLegacy listSameCounties:stateCode];

}


+ (PMKPromise *) listSameStates {
  return [NwsSameCodeServiceLegacy listSameStates];
}


+ (PMKPromise *) getSameCodeWithStateCode:(NSString *)stateCode withCounty:(NSString *)county {
  return [NwsSameCodeServiceLegacy getSameCode:stateCode county:county];

}

@end
