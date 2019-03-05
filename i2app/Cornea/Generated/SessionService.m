

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SessionService.h"
#import <i2app-Swift.h>

@implementation SessionService
+ (NSString *)name { return @"SessionService"; }
+ (NSString *)address { return @"SERV:sess:"; }


+ (PMKPromise *) setActivePlaceWithPlaceId:(NSString *)placeId {
  return [SessionServiceLegacy setActivePlace:placeId];

}


+ (PMKPromise *) logWithCategory:(NSString *)category withCode:(NSString *)code withMessage:(NSString *)message {
  return [SessionServiceLegacy log:category code:code message:message];

}


+ (PMKPromise *) tagWithName:(NSString *)name withContext:(NSDictionary *)context {
  return [SessionServiceLegacy tag:name context:context];

}


+ (PMKPromise *) listAvailablePlaces {
  return [SessionServiceLegacy listAvailablePlaces];
}


+ (PMKPromise *) getPreferences {
  return [SessionServiceLegacy getPreferences];
}


+ (PMKPromise *) setPreferencesWithPrefs:(id)prefs {
  return [SessionServiceLegacy setPreferences:prefs];

}


+ (PMKPromise *) resetPreferenceWithPrefKey:(NSString *)prefKey {
  return [SessionServiceLegacy resetPreference:prefKey];

}


+ (PMKPromise *) lockDeviceWithDeviceIdentifier:(NSString *)deviceIdentifier withReason:(NSString *)reason {
  return [SessionServiceLegacy lockDevice:deviceIdentifier reason:reason];

}

@end
