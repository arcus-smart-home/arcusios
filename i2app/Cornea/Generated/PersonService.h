

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface PersonService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Requests the platform to generate a password reset token and notify the user */
+ (PMKPromise *) sendPasswordResetWithEmail:(NSString *)email withMethod:(NSString *)method;



/** Resets the users password */
+ (PMKPromise *) resetPasswordWithEmail:(NSString *)email withToken:(NSString *)token withPassword:(NSString *)password;



/** Changes the password for the given person */
+ (PMKPromise *) changePasswordWithCurrentPassword:(NSString *)currentPassword withNewPassword:(NSString *)newPassword withEmailAddress:(NSString *)emailAddress;



@end
