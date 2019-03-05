

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class PlaceModel;



@class HubModel;























@class HubModel;



/** Platform-owned globally unique identifier for the account owning the place */
extern NSString *const kAttrPlaceAccount;

/** Indicates the population name this place belongs to. If not specified, the general population will be assumed */
extern NSString *const kAttrPlacePopulation;

/** The name of the place */
extern NSString *const kAttrPlaceName;

/** The state of the place */
extern NSString *const kAttrPlaceState;

/** First part of the street address */
extern NSString *const kAttrPlaceStreetAddress1;

/** Second part of the street address */
extern NSString *const kAttrPlaceStreetAddress2;

/** The city */
extern NSString *const kAttrPlaceCity;

/** The state or province */
extern NSString *const kAttrPlaceStateProv;

/** The zip code */
extern NSString *const kAttrPlaceZipCode;

/** Extended zip +4 digits */
extern NSString *const kAttrPlaceZipPlus4;

/** System assigned timezone identifier */
extern NSString *const kAttrPlaceTzId;

/** Timezone as Alaska, Atlantic, Central, Eastern, Hawaii, Mountain, None, Pacific, Samoa, UTC+10, UTC+11, UTC+12, UTC+9, valid only for US addresses */
extern NSString *const kAttrPlaceTzName;

/** Timezone hour offset from UTC [-9, -4, -6, -5, -10, -7, 0, -8, -11, 10, 11, 12, 9], valid only for US addresses */
extern NSString *const kAttrPlaceTzOffset;

/** True if timezone uses daylight savings time, false otherwise */
extern NSString *const kAttrPlaceTzUsesDST;

/** The country */
extern NSString *const kAttrPlaceCountry;

/** True if address is US address and passed USPS address validation */
extern NSString *const kAttrPlaceAddrValidated;

/** Address type according to address validation service [F=firm (best), G=general (held at local post office), H=high-rise (contains apartment no.), P=PO box, R=rural route, S=street (addr only matched to valid range of house numbers on street), blank (invalid)] */
extern NSString *const kAttrPlaceAddrType;

/** Zip code type [Unique, Military, POBox, Standard] */
extern NSString *const kAttrPlaceAddrZipType;

/** Approximate latitude of address (averaged over zipcode) */
extern NSString *const kAttrPlaceAddrLatitude;

/** Approximate longitude of address (averaged over zipcode) */
extern NSString *const kAttrPlaceAddrLongitude;

/** Precision of address lat,long [Unknown, None, Zip5, Zip6, Zip7, Zip8, Zip9] */
extern NSString *const kAttrPlaceAddrGeoPrecision;

/** USPS Residential Delivery Indicatory for address [Residential, Commercial, Unknown] */
extern NSString *const kAttrPlaceAddrRDI;

/** County name */
extern NSString *const kAttrPlaceAddrCounty;

/** 5 digit FIPS code as 2 digit FIPS and 3 digit county code */
extern NSString *const kAttrPlaceAddrCountyFIPS;

/** Date of last change to the service level at this place */
extern NSString *const kAttrPlaceLastServiceLevelChange;

/** Platform-owned service level at this place */
extern NSString *const kAttrPlaceServiceLevel;

/** Platform-owned set of service addons subscribed to at this place */
extern NSString *const kAttrPlaceServiceAddons;

/** Date of creation of the place. */
extern NSString *const kAttrPlaceCreated;

/** Last time that the place was modified. */
extern NSString *const kAttrPlaceModified;


extern NSString *const kCmdPlaceListDevices;

extern NSString *const kCmdPlaceGetHub;

extern NSString *const kCmdPlaceStartAddingDevices;

extern NSString *const kCmdPlaceStopAddingDevices;

extern NSString *const kCmdPlaceRegisterHub;

extern NSString *const kCmdPlaceAddPerson;

extern NSString *const kCmdPlaceListPersons;

extern NSString *const kCmdPlaceListPersonsWithAccess;

extern NSString *const kCmdPlaceListDashboardEntries;

extern NSString *const kCmdPlaceListHistoryEntries;

extern NSString *const kCmdPlaceDelete;

extern NSString *const kCmdPlaceCreateInvitation;

extern NSString *const kCmdPlaceSendInvitation;

extern NSString *const kCmdPlacePendingInvitations;

extern NSString *const kCmdPlaceCancelInvitation;

extern NSString *const kCmdPlaceUpdateAddress;

extern NSString *const kCmdPlaceRegisterHubV2;


extern NSString *const kEnumPlaceServiceLevelBASIC;
extern NSString *const kEnumPlaceServiceLevelPREMIUM;
extern NSString *const kEnumPlaceServiceLevelPREMIUM_FREE;
extern NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON;
extern NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON_FREE;
extern NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON_MYARCUS_DISCOUNT;


@interface PlaceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getAccountFromModel:(PlaceModel *)modelObj;


+ (NSString *)getPopulationFromModel:(PlaceModel *)modelObj;


+ (NSString *)getNameFromModel:(PlaceModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSString *)getStateFromModel:(PlaceModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(Model *)modelObj;


+ (NSString *)getStreetAddress1FromModel:(PlaceModel *)modelObj;

+ (NSString *)setStreetAddress1:(NSString *)streetAddress1 onModel:(Model *)modelObj;


+ (NSString *)getStreetAddress2FromModel:(PlaceModel *)modelObj;

+ (NSString *)setStreetAddress2:(NSString *)streetAddress2 onModel:(Model *)modelObj;


+ (NSString *)getCityFromModel:(PlaceModel *)modelObj;

+ (NSString *)setCity:(NSString *)city onModel:(Model *)modelObj;


+ (NSString *)getStateProvFromModel:(PlaceModel *)modelObj;

+ (NSString *)setStateProv:(NSString *)stateProv onModel:(Model *)modelObj;


+ (NSString *)getZipCodeFromModel:(PlaceModel *)modelObj;

+ (NSString *)setZipCode:(NSString *)zipCode onModel:(Model *)modelObj;


+ (NSString *)getZipPlus4FromModel:(PlaceModel *)modelObj;

+ (NSString *)setZipPlus4:(NSString *)zipPlus4 onModel:(Model *)modelObj;


+ (NSString *)getTzIdFromModel:(PlaceModel *)modelObj;

+ (NSString *)setTzId:(NSString *)tzId onModel:(Model *)modelObj;


+ (NSString *)getTzNameFromModel:(PlaceModel *)modelObj;

+ (NSString *)setTzName:(NSString *)tzName onModel:(Model *)modelObj;


+ (double)getTzOffsetFromModel:(PlaceModel *)modelObj;

+ (double)setTzOffset:(double)tzOffset onModel:(Model *)modelObj;


+ (BOOL)getTzUsesDSTFromModel:(PlaceModel *)modelObj;

+ (BOOL)setTzUsesDST:(BOOL)tzUsesDST onModel:(Model *)modelObj;


+ (NSString *)getCountryFromModel:(PlaceModel *)modelObj;

+ (NSString *)setCountry:(NSString *)country onModel:(Model *)modelObj;


+ (BOOL)getAddrValidatedFromModel:(PlaceModel *)modelObj;

+ (BOOL)setAddrValidated:(BOOL)addrValidated onModel:(Model *)modelObj;


+ (NSString *)getAddrTypeFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrType:(NSString *)addrType onModel:(Model *)modelObj;


+ (NSString *)getAddrZipTypeFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrZipType:(NSString *)addrZipType onModel:(Model *)modelObj;


+ (double)getAddrLatitudeFromModel:(PlaceModel *)modelObj;

+ (double)setAddrLatitude:(double)addrLatitude onModel:(Model *)modelObj;


+ (double)getAddrLongitudeFromModel:(PlaceModel *)modelObj;

+ (double)setAddrLongitude:(double)addrLongitude onModel:(Model *)modelObj;


+ (NSString *)getAddrGeoPrecisionFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrGeoPrecision:(NSString *)addrGeoPrecision onModel:(Model *)modelObj;


+ (NSString *)getAddrRDIFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrRDI:(NSString *)addrRDI onModel:(Model *)modelObj;


+ (NSString *)getAddrCountyFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrCounty:(NSString *)addrCounty onModel:(Model *)modelObj;


+ (NSString *)getAddrCountyFIPSFromModel:(PlaceModel *)modelObj;

+ (NSString *)setAddrCountyFIPS:(NSString *)addrCountyFIPS onModel:(Model *)modelObj;


+ (NSDate *)getLastServiceLevelChangeFromModel:(PlaceModel *)modelObj;


+ (NSString *)getServiceLevelFromModel:(PlaceModel *)modelObj;


+ (NSArray *)getServiceAddonsFromModel:(PlaceModel *)modelObj;


+ (NSDate *)getCreatedFromModel:(PlaceModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(PlaceModel *)modelObj;





/** Lists all devices associated with this place */
+ (PMKPromise *) listDevicesOnModel:(Model *)modelObj;



/** Retrieves the object representing the hub at this place or null if the place has no hub */
+ (PMKPromise *) getHubOnModel:(Model *)modelObj;



/** Prepares this location to have devices added (paired) any devices added during this time will emit the device added event */
+ (PMKPromise *) startAddingDevicesWithTime:(long)time onModel:(Model *)modelObj;



/** Cleans up anything enabled into the home for having devices added (paired) */
+ (PMKPromise *) stopAddingDevicesOnModel:(Model *)modelObj;



/** Registered a hub at this place.  At some point later the HubAddedEvent will be posted */
+ (PMKPromise *) registerHubWithHubId:(NSString *)hubId onModel:(Model *)modelObj;



/** Add a new person with permissions to this place. */
+ (PMKPromise *) addPersonWithPerson:(id)person withPassword:(NSString *)password onModel:(Model *)modelObj;



/** The list of persons who have access to this place. */
+ (PMKPromise *) listPersonsOnModel:(Model *)modelObj;



/** The list of persons who have access to this place plus their role */
+ (PMKPromise *) listPersonsWithAccessOnModel:(Model *)modelObj;



/** Returns a list of the high-importance history log entries associated with this place */
+ (PMKPromise *) listDashboardEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this place */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(Model *)modelObj;



/** Remove the place and any associated entities. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Creates an invitation for the user */
+ (PMKPromise *) createInvitationWithFirstName:(NSString *)firstName withLastName:(NSString *)lastName withEmail:(NSString *)email withRelationship:(NSString *)relationship onModel:(Model *)modelObj;



/** Sends the given invitation */
+ (PMKPromise *) sendInvitationWithInvitation:(id)invitation onModel:(Model *)modelObj;



/** Lists all pending invitations for the place */
+ (PMKPromise *) pendingInvitationsOnModel:(Model *)modelObj;



/** Cancels and deletes an invitation */
+ (PMKPromise *) cancelInvitationWithCode:(NSString *)code onModel:(Model *)modelObj;



/** Updates the current place&#x27;s address if it is changed and potentially other third-party systems.  The address is optional and if not specified will use the address of the current place. */
+ (PMKPromise *) updateAddressWithStreetAddress:(id)streetAddress onModel:(Model *)modelObj;



/** This attempts to register the addressed place with the given hub.  This call will not succeed until the hub is (1) online and (2) above the minimum firmware version.  At that point the call is idempotent, so may be safely retried. */
+ (PMKPromise *) registerHubV2WithHubId:(NSString *)hubId onModel:(Model *)modelObj;



@end
