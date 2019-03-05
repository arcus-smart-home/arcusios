

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PlaceService.h"
#import <i2app-Swift.h>

@implementation PlaceService
+ (NSString *)name { return @"PlaceService"; }
+ (NSString *)address { return @"SERV:place:"; }


+ (PMKPromise *) listTimezones {
  return [PlaceServiceLegacy listTimezones];
}


+ (PMKPromise *) validateAddressWithPlaceId:(NSString *)placeId withStreetAddress:(id)streetAddress {
  return [PlaceServiceLegacy validateAddress:placeId streetAddress:streetAddress];

}

@end
