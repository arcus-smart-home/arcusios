

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface SessionService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Sets the place that this session is associated with, the session will begin receiving broadcasts for the requested place */
+ (PMKPromise *) setActivePlaceWithPlaceId:(NSString *)placeId;



/** Logs an event to the server */
+ (PMKPromise *) logWithCategory:(NSString *)category withCode:(NSString *)code withMessage:(NSString *)message;



/** Persists a UI analytics tag on the server */
+ (PMKPromise *) tagWithName:(NSString *)name withContext:(NSDictionary *)context;



/** Lists the available places for the currently logged in user */
+ (PMKPromise *) listAvailablePlaces;



/** Returns the preferences for the currently logged in user at their active place or empty if no preferences have been set or active place has not been set */
+ (PMKPromise *) getPreferences;



/** Sets the one or more preferences for the currently logged in user at their active place.  If a key is defined in their preferences but not specified here, it will not be cleared by this set. */
+ (PMKPromise *) setPreferencesWithPrefs:(id)prefs;



/** Resets the preference with the given key for the currently logged in user at their active place.  This will remove the preference and return this preference to default. */
+ (PMKPromise *) resetPreferenceWithPrefKey:(NSString *)prefKey;



/** Lock the device by removing the mobile device record and logout the current session. */
+ (PMKPromise *) lockDeviceWithDeviceIdentifier:(NSString *)deviceIdentifier withReason:(NSString *)reason;



@end
