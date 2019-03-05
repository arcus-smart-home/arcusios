

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;







/** A display name for the subsystem, generally not shown to end-users */
extern NSString *const kAttrSubsystemName;

/** The published version of the subsystem */
extern NSString *const kAttrSubsystemVersion;

/** A hash of the subsystem may be used to ensure the exact version that is being run */
extern NSString *const kAttrSubsystemHash;

/** The account associated with the this subsystem. */
extern NSString *const kAttrSubsystemAccount;

/** The place the subsystem is associated with, there may be only one instance of each subsystem per place. */
extern NSString *const kAttrSubsystemPlace;

/** Indicates whether the subsystem is available on the current place or not. When this is false it generally means there need to be more devices added to the place. */
extern NSString *const kAttrSubsystemAvailable;

/** Indicates the current state of a subsystem.  A SUSPENDED subsystem will not collect any new data or enable associated rules, but may still allow previously collected data to be viewed. */
extern NSString *const kAttrSubsystemState;


extern NSString *const kCmdSubsystemActivate;

extern NSString *const kCmdSubsystemSuspend;

extern NSString *const kCmdSubsystemDelete;

extern NSString *const kCmdSubsystemListHistoryEntries;


extern NSString *const kEnumSubsystemStateACTIVE;
extern NSString *const kEnumSubsystemStateSUSPENDED;


@interface SubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getNameFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getVersionFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getHashFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getAccountFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getPlaceFromModel:(SubsystemModel *)modelObj;


+ (BOOL)getAvailableFromModel:(SubsystemModel *)modelObj;


+ (NSString *)getStateFromModel:(SubsystemModel *)modelObj;





/** Puts the subsystem into an &#x27;active&#x27; state, this only applies to previously suspended subsystems, see Place#AddSubsystem(subsystemType: String) for adding new subsystems to a place. */
+ (PMKPromise *) activateOnModel:(Model *)modelObj;



/** Puts the subsystem into a &#x27;suspended&#x27; state. */
+ (PMKPromise *) suspendOnModel:(Model *)modelObj;



/** Removes the subsystem and all data from the associated place. */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



/** Returns a list of all the history log entries associated with this subsystem */
+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token withIncludeIncidents:(BOOL)includeIncidents onModel:(Model *)modelObj;



@end
