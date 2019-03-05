

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PersonService.h"
#import <i2app-Swift.h>

@implementation PersonService
+ (NSString *)name { return @"PersonService"; }
+ (NSString *)address { return @"SERV:person:"; }


+ (PMKPromise *) sendPasswordResetWithEmail:(NSString *)email withMethod:(NSString *)method {
  return [PersonServiceLegacy sendPasswordReset:email method:method];

}


+ (PMKPromise *) resetPasswordWithEmail:(NSString *)email withToken:(NSString *)token withPassword:(NSString *)password {
  return [PersonServiceLegacy resetPassword:email token:token password:password];

}


+ (PMKPromise *) changePasswordWithCurrentPassword:(NSString *)currentPassword withNewPassword:(NSString *)newPassword withEmailAddress:(NSString *)emailAddress {
  return [PersonServiceLegacy changePassword:currentPassword newPassword:newPassword emailAddress:emailAddress];

}

@end
