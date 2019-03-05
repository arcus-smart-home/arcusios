

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PersonCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPersonFirstName=@"person:firstName";

NSString *const kAttrPersonLastName=@"person:lastName";

NSString *const kAttrPersonEmail=@"person:email";

NSString *const kAttrPersonEmailVerified=@"person:emailVerified";

NSString *const kAttrPersonMobileNumber=@"person:mobileNumber";

NSString *const kAttrPersonMobileNotificationEndpoints=@"person:mobileNotificationEndpoints";

NSString *const kAttrPersonCurrPlace=@"person:currPlace";

NSString *const kAttrPersonCurrPlaceMethod=@"person:currPlaceMethod";

NSString *const kAttrPersonCurrLocation=@"person:currLocation";

NSString *const kAttrPersonCurrLocationTime=@"person:currLocationTime";

NSString *const kAttrPersonCurrLocationMethod=@"person:currLocationMethod";

NSString *const kAttrPersonConsentOffersPromotions=@"person:consentOffersPromotions";

NSString *const kAttrPersonConsentStatement=@"person:consentStatement";

NSString *const kAttrPersonHasPin=@"person:hasPin";

NSString *const kAttrPersonPlacesWithPin=@"person:placesWithPin";

NSString *const kAttrPersonHasLogin=@"person:hasLogin";

NSString *const kAttrPersonSecurityAnswerCount=@"person:securityAnswerCount";


NSString *const kCmdPersonSetSecurityAnswers=@"person:SetSecurityAnswers";

NSString *const kCmdPersonGetSecurityAnswers=@"person:GetSecurityAnswers";

NSString *const kCmdPersonAddMobileDevice=@"person:AddMobileDevice";

NSString *const kCmdPersonRemoveMobileDevice=@"person:RemoveMobileDevice";

NSString *const kCmdPersonListMobileDevices=@"person:ListMobileDevices";

NSString *const kCmdPersonListHistoryEntries=@"person:ListHistoryEntries";

NSString *const kCmdPersonDelete=@"person:Delete";

NSString *const kCmdPersonRemoveFromPlace=@"person:RemoveFromPlace";

NSString *const kCmdPersonChangePin=@"person:ChangePin";

NSString *const kCmdPersonChangePinV2=@"person:ChangePinV2";

NSString *const kCmdPersonVerifyPin=@"person:VerifyPin";

NSString *const kCmdPersonAcceptInvitation=@"person:AcceptInvitation";

NSString *const kCmdPersonRejectInvitation=@"person:RejectInvitation";

NSString *const kCmdPersonPendingInvitations=@"person:PendingInvitations";

NSString *const kCmdPersonPromoteToAccount=@"person:PromoteToAccount";

NSString *const kCmdPersonDeleteLogin=@"person:DeleteLogin";

NSString *const kCmdPersonListAvailablePlaces=@"person:ListAvailablePlaces";

NSString *const kCmdPersonAcceptPolicy=@"person:AcceptPolicy";

NSString *const kCmdPersonRejectPolicy=@"person:RejectPolicy";

NSString *const kCmdPersonSendVerificationEmail=@"person:SendVerificationEmail";

NSString *const kCmdPersonVerifyEmail=@"person:VerifyEmail";


NSString *const kEvtPersonPinChangedEvent=@"person:PinChangedEvent";

NSString *const kEvtPersonInvitationPending=@"person:InvitationPending";

NSString *const kEvtPersonAuthorizationRemoved=@"person:AuthorizationRemoved";



@implementation PersonCapability
+ (NSString *)namespace { return @"person"; }
+ (NSString *)name { return @"Person"; }

+ (NSString *)getFirstNameFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getFirstName:modelObj];
  
}

+ (NSString *)setFirstName:(NSString *)firstName onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setFirstName:firstName model:modelObj];
  
  return [PersonCapabilityLegacy getFirstName:modelObj];
  
}


+ (NSString *)getLastNameFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getLastName:modelObj];
  
}

+ (NSString *)setLastName:(NSString *)lastName onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setLastName:lastName model:modelObj];
  
  return [PersonCapabilityLegacy getLastName:modelObj];
  
}


+ (NSString *)getEmailFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getEmail:modelObj];
  
}

+ (NSString *)setEmail:(NSString *)email onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setEmail:email model:modelObj];
  
  return [PersonCapabilityLegacy getEmail:modelObj];
  
}


+ (BOOL)getEmailVerifiedFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PersonCapabilityLegacy getEmailVerified:modelObj] boolValue];
  
}


+ (NSString *)getMobileNumberFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getMobileNumber:modelObj];
  
}

+ (NSString *)setMobileNumber:(NSString *)mobileNumber onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setMobileNumber:mobileNumber model:modelObj];
  
  return [PersonCapabilityLegacy getMobileNumber:modelObj];
  
}


+ (NSArray *)getMobileNotificationEndpointsFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getMobileNotificationEndpoints:modelObj];
  
}

+ (NSArray *)setMobileNotificationEndpoints:(NSArray *)mobileNotificationEndpoints onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setMobileNotificationEndpoints:mobileNotificationEndpoints model:modelObj];
  
  return [PersonCapabilityLegacy getMobileNotificationEndpoints:modelObj];
  
}


+ (NSString *)getCurrPlaceFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getCurrPlace:modelObj];
  
}

+ (NSString *)setCurrPlace:(NSString *)currPlace onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setCurrPlace:currPlace model:modelObj];
  
  return [PersonCapabilityLegacy getCurrPlace:modelObj];
  
}


+ (NSString *)getCurrPlaceMethodFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getCurrPlaceMethod:modelObj];
  
}

+ (NSString *)setCurrPlaceMethod:(NSString *)currPlaceMethod onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setCurrPlaceMethod:currPlaceMethod model:modelObj];
  
  return [PersonCapabilityLegacy getCurrPlaceMethod:modelObj];
  
}


+ (NSString *)getCurrLocationFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getCurrLocation:modelObj];
  
}

+ (NSString *)setCurrLocation:(NSString *)currLocation onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setCurrLocation:currLocation model:modelObj];
  
  return [PersonCapabilityLegacy getCurrLocation:modelObj];
  
}


+ (NSDate *)getCurrLocationTimeFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getCurrLocationTime:modelObj];
  
}

+ (NSDate *)setCurrLocationTime:(double)currLocationTime onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setCurrLocationTime:currLocationTime model:modelObj];
  
  return [PersonCapabilityLegacy getCurrLocationTime:modelObj];
  
}


+ (NSString *)getCurrLocationMethodFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getCurrLocationMethod:modelObj];
  
}

+ (NSString *)setCurrLocationMethod:(NSString *)currLocationMethod onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setCurrLocationMethod:currLocationMethod model:modelObj];
  
  return [PersonCapabilityLegacy getCurrLocationMethod:modelObj];
  
}


+ (NSDate *)getConsentOffersPromotionsFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getConsentOffersPromotions:modelObj];
  
}

+ (NSDate *)setConsentOffersPromotions:(double)consentOffersPromotions onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setConsentOffersPromotions:consentOffersPromotions model:modelObj];
  
  return [PersonCapabilityLegacy getConsentOffersPromotions:modelObj];
  
}


+ (NSDate *)getConsentStatementFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getConsentStatement:modelObj];
  
}

+ (NSDate *)setConsentStatement:(double)consentStatement onModel:(PersonModel *)modelObj {
  [PersonCapabilityLegacy setConsentStatement:consentStatement model:modelObj];
  
  return [PersonCapabilityLegacy getConsentStatement:modelObj];
  
}


+ (BOOL)getHasPinFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PersonCapabilityLegacy getHasPin:modelObj] boolValue];
  
}


+ (NSArray *)getPlacesWithPinFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PersonCapabilityLegacy getPlacesWithPin:modelObj];
  
}


+ (BOOL)getHasLoginFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PersonCapabilityLegacy getHasLogin:modelObj] boolValue];
  
}


+ (int)getSecurityAnswerCountFromModel:(PersonModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PersonCapabilityLegacy getSecurityAnswerCount:modelObj] intValue];
  
}




+ (PMKPromise *) setSecurityAnswersWithSecurityQuestion1:(NSString *)securityQuestion1 withSecurityAnswer1:(NSString *)securityAnswer1 withSecurityQuestion2:(NSString *)securityQuestion2 withSecurityAnswer2:(NSString *)securityAnswer2 withSecurityQuestion3:(NSString *)securityQuestion3 withSecurityAnswer3:(NSString *)securityAnswer3 onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy setSecurityAnswers:modelObj securityQuestion1:securityQuestion1 securityAnswer1:securityAnswer1 securityQuestion2:securityQuestion2 securityAnswer2:securityAnswer2 securityQuestion3:securityQuestion3 securityAnswer3:securityAnswer3];

}


+ (PMKPromise *) getSecurityAnswersOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy getSecurityAnswers:modelObj ];
}


+ (PMKPromise *) addMobileDeviceWithName:(NSString *)name withAppVersion:(NSString *)appVersion withOsType:(NSString *)osType withOsVersion:(NSString *)osVersion withFormFactor:(NSString *)formFactor withPhoneNumber:(NSString *)phoneNumber withDeviceIdentifier:(NSString *)deviceIdentifier withDeviceModel:(NSString *)deviceModel withDeviceVendor:(NSString *)deviceVendor withResolution:(NSString *)resolution withNotificationToken:(NSString *)notificationToken withLastLatitude:(double)lastLatitude withLastLongitude:(double)lastLongitude onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy addMobileDevice:modelObj name:name appVersion:appVersion osType:osType osVersion:osVersion formFactor:formFactor phoneNumber:phoneNumber deviceIdentifier:deviceIdentifier deviceModel:deviceModel deviceVendor:deviceVendor resolution:resolution notificationToken:notificationToken lastLatitude:lastLatitude lastLongitude:lastLongitude];

}


+ (PMKPromise *) removeMobileDeviceWithDeviceIndex:(int)deviceIndex onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy removeMobileDevice:modelObj deviceIndex:deviceIndex];

}


+ (PMKPromise *) listMobileDevicesOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy listMobileDevices:modelObj ];
}


+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token];

}


+ (PMKPromise *) deleteOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) removeFromPlaceWithPlaceId:(NSString *)placeId onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy removeFromPlace:modelObj placeId:placeId];

}


+ (PMKPromise *) changePinWithCurrentPin:(NSString *)currentPin withNewPin:(NSString *)newPin onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy changePin:modelObj currentPin:currentPin newPin:newPin];

}


+ (PMKPromise *) changePinV2WithPlace:(NSString *)place withPin:(NSString *)pin onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy changePinV2:modelObj place:place pin:pin];

}


+ (PMKPromise *) verifyPinWithPlace:(NSString *)place withPin:(NSString *)pin onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy verifyPin:modelObj place:place pin:pin];

}


+ (PMKPromise *) acceptInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy acceptInvitation:modelObj code:code inviteeEmail:inviteeEmail];

}


+ (PMKPromise *) rejectInvitationWithCode:(NSString *)code withInviteeEmail:(NSString *)inviteeEmail withReason:(NSString *)reason onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy rejectInvitation:modelObj code:code inviteeEmail:inviteeEmail reason:reason];

}


+ (PMKPromise *) pendingInvitationsOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy pendingInvitations:modelObj ];
}


+ (PMKPromise *) promoteToAccountWithPlace:(id)place onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy promoteToAccount:modelObj place:place];

}


+ (PMKPromise *) deleteLoginOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy deleteLogin:modelObj ];
}


+ (PMKPromise *) listAvailablePlacesOnModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy listAvailablePlaces:modelObj ];
}


+ (PMKPromise *) acceptPolicyWithType:(NSString *)type onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy acceptPolicy:modelObj type:type];

}


+ (PMKPromise *) rejectPolicyWithType:(NSString *)type onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy rejectPolicy:modelObj type:type];

}


+ (PMKPromise *) sendVerificationEmailWithSource:(NSString *)source onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy sendVerificationEmail:modelObj source:source];

}


+ (PMKPromise *) verifyEmailWithToken:(NSString *)token onModel:(PersonModel *)modelObj {
  return [PersonCapabilityLegacy verifyEmail:modelObj token:token];

}

@end
