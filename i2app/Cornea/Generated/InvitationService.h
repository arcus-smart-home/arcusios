

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface InvitationService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Finds an invitation by its code and invitee email */
+ (PMKPromise *) getInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail;



/** Creates a new person/login and associates them with the place from the invitation */
+ (PMKPromise *) acceptInvitationCreateLoginWithPerson:(id)person withPassword:(NSString *)password withCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail;



@end
