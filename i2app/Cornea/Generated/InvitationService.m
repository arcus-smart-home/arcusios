

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "InvitationService.h"
#import <i2app-Swift.h>

@implementation InvitationService
+ (NSString *)name { return @"InvitationService"; }
+ (NSString *)address { return @"SERV:invite:"; }


+ (PMKPromise *) getInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail {
  return [InvitationServiceLegacy getInvitation:code inviteeEmail:inviteeEmail];

}


+ (PMKPromise *) acceptInvitationCreateLoginWithPerson:(id)person withPassword:(NSString *)password withCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail {
  return [InvitationServiceLegacy acceptInvitationCreateLogin:person password:password code:code inviteeEmail:inviteeEmail];

}

@end
