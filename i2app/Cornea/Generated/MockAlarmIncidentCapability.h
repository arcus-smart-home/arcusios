

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class AlarmIncidentModel;




extern NSString *const kCmdMockAlarmIncidentContacted;

extern NSString *const kCmdMockAlarmIncidentDispatchCancelled;

extern NSString *const kCmdMockAlarmIncidentDispatchAccepted;

extern NSString *const kCmdMockAlarmIncidentDispatchRefused;




@interface MockAlarmIncidentCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Adds the history entry for contacting a person.  If no person is specified the person issuing the call will be used. */
+ (PMKPromise *) contactedWithPerson:(NSString *)person onModel:(Model *)modelObj;



/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to CANCELLED and the alertState to COMPLETE.  Also creates the appropriate history entries.             If no person is specified the person issuing the call will be used. */
+ (PMKPromise *) dispatchCancelledWithPerson:(NSString *)person onModel:(Model *)modelObj;



/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.             If the alertState is CANCELLING it should be changed to COMPLETE. */
+ (PMKPromise *) dispatchAcceptedWithAuthority:(NSString *)authority onModel:(Model *)modelObj;



/** Throws an error if the current incidentState is not alertState: ALERT or alertState: CANCELLING.           Sets the monitoringState to DISPATCHED and creates the appropriate history entries.           If the alertState is CANCELLING it should be changed to COMPLETE. */
+ (PMKPromise *) dispatchRefusedWithAuthority:(NSString *)authority onModel:(Model *)modelObj;



@end
