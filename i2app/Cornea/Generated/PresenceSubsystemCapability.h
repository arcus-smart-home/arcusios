

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;





/** Estimate as to whether the home is occupied */
extern NSString *const kAttrPresenceSubsystemOccupied;

/** Confidence in occupied estimate */
extern NSString *const kAttrPresenceSubsystemOccupiedConf;

/** Set of the addresses of people who are in this place */
extern NSString *const kAttrPresenceSubsystemPeopleAtHome;

/** Set of address of people that are away from this place */
extern NSString *const kAttrPresenceSubsystemPeopleAway;

/** Set of addresses of presence capable devices not associated with people in this place */
extern NSString *const kAttrPresenceSubsystemDevicesAtHome;

/** Set of addresses of presence capable devices not associated with people that are away from this place */
extern NSString *const kAttrPresenceSubsystemDevicesAway;

/** Set of addresses of all presence capable devices */
extern NSString *const kAttrPresenceSubsystemAllDevices;


extern NSString *const kCmdPresenceSubsystemGetPresenceAnalysis;


extern NSString *const kEvtPresenceSubsystemArrived;

extern NSString *const kEvtPresenceSubsystemDeparted;

extern NSString *const kEvtPresenceSubsystemPersonArrived;

extern NSString *const kEvtPresenceSubsystemPersonDeparted;

extern NSString *const kEvtPresenceSubsystemDeviceArrived;

extern NSString *const kEvtPresenceSubsystemDeviceDeparted;

extern NSString *const kEvtPresenceSubsystemDeviceAssignedToPerson;

extern NSString *const kEvtPresenceSubsystemDeviceUnassignedFromPerson;

extern NSString *const kEvtPresenceSubsystemPlaceOccupied;

extern NSString *const kEvtPresenceSubsystemPlaceUnoccupied;



@interface PresenceSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getOccupiedFromModel:(SubsystemModel *)modelObj;


+ (id)getOccupiedConfFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPeopleAtHomeFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getPeopleAwayFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getDevicesAtHomeFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getDevicesAwayFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getAllDevicesFromModel:(SubsystemModel *)modelObj;





/** Presence analysis describes, for each person, whether the subsystem thinks the person is at home or not and how it came to that conclusion. */
+ (PMKPromise *) getPresenceAnalysisOnModel:(Model *)modelObj;



@end
