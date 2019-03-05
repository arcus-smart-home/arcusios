

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SupportSearchService.h"
#import <i2app-Swift.h>

@implementation SupportSearchService
+ (NSString *)name { return @"SupportSearchService"; }
+ (NSString *)address { return @"SERV:supportsearch:"; }


+ (PMKPromise *) supportMainSearchWithCritera:(NSString *)critera withFrom:(id)from withSize:(id)size {
  return [SupportSearchServiceLegacy supportMainSearch:critera from:from size:size];

}

@end
