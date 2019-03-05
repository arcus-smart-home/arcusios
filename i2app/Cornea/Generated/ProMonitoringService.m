

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProMonitoringService.h"
#import <i2app-Swift.h>

@implementation ProMonitoringService
+ (NSString *)name { return @"ProMonitoringService"; }
+ (NSString *)address { return @"SERV:promon:"; }


+ (PMKPromise *) getSettingsWithPlace:(NSString *)place {
  return [ProMonitoringServiceLegacy getSettings:place];

}


+ (PMKPromise *) getMetaData {
  return [ProMonitoringServiceLegacy getMetaData];
}


+ (PMKPromise *) checkAvailabilityWithZipcode:(NSString *)zipcode withState:(NSString *)state {
  return [ProMonitoringServiceLegacy checkAvailability:zipcode state:state];

}

@end
