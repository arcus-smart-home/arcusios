//
//  SessionController.m
//  i2app
//
//  Created by Quayle, Nick - Nicholas on 5/5/16.
//  Copyright © 2016 Lowes Corporation. All rights reserved.
//

#import "SessionController.h"
#import "SessionService.h"
#import "IrisClient.h"
#import <i2app-Swift.h>
#import "PersonCapability.h"

@interface AccountController ()

+ (PMKPromise *)retrieveModelsWithSessionAttributes:(NSDictionary *)attributes;

@end

@interface IrisClient (WebSocket)

@property (atomic, readonly) BOOL webSocketIsOpen;

- (PMKPromise *)startWebSocket;
- (PMKPromise *)stopWebSocket;

- (BOOL)webSocketIsConnecting;

@end


@implementation SessionController

    static BOOL        _activePlaceIsSet;
    static NSDate      *_sessionStartTime;

    static NSObject    *_synchronizationObject;

+ (void)initialize {
    _synchronizationObject = [[NSObject alloc] init];
    _activePlaceIsSet = NO;
}

+ (PMKPromise *)setActivePlaceWithId:(NSString *)placeId {
    @synchronized (_synchronizationObject) {
        return [SessionService setActivePlaceWithPlaceId:placeId].thenInBackground(^(SetActivePlaceResponse *response) {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                DDLogWarn(@"SessionController: Session is opened; active place is set");
                _activePlaceIsSet = YES;

                _sessionStartTime = [NSDate date];
                SessionModel *session = [IrisClient sharedInstance].session;
                NSDictionary *attributes = @{  @"placeId" : [response getPlaceId],
                                               @"accountId" : session.accountId,
                                               @"personId" : session.personId };
                fulfill(attributes);
            }];
        });
    }
}

#pragma mark - Session State
+ (PMKPromise *)startSession {
    _activePlaceIsSet = NO;
    @synchronized(self) {
        return [[IrisClient sharedInstance] startWebSocket].thenInBackground(^(NSObject *response) {
            return [self setActivePlaceWithId:[IrisClient sharedInstance].session.placeId].thenInBackground(^(NSDictionary *attributes) {
                [AccountController retrieveModelsWithSessionAttributes:attributes];
                return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                    // Send the accountId, placeId and personId
                    fulfill(attributes);
                }];
            });
        });
    }
}

// Closes the web socket (if open), then clears the session state. This is the typical means for gracefully closing an Iris session
+ (PMKPromise *)endSession {
    @synchronized(self) {
        return [[IrisClient sharedInstance] stopWebSocket].thenInBackground(^ {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                [self sessionHasEnded];
                [[IrisClient sharedInstance] clearCurrentUserStates];
            }];
        });
    }
}

+ (void)sessionHasEnded {
    @synchronized (_synchronizationObject) {
        DDLogWarn(@"SessionController: sessionHasEnded");
        _activePlaceIsSet = NO;
    }
}

+ (BOOL)sessionIsOpen {
    return ([IrisClient sharedInstance].webSocketIsOpen && _activePlaceIsSet);
}

+ (BOOL)sessionCreationInProgress {
    return ([IrisClient sharedInstance].webSocketIsConnecting || ([IrisClient sharedInstance].webSocketIsOpen && !_activePlaceIsSet));
}

+ (NSDate *)sessionStartTime {
    return _sessionStartTime;
}


#pragma mark - Stateless calls
+ (PMKPromise *) listAvailablePlaces {
    return [SessionService listAvailablePlaces].thenInBackground(^(ListAvailablePlacesResponse *response) {
        NSArray<NSDictionary *> *placesAndRolesDicts = [response getPlaces];
        NSMutableArray<PlaceAndRoleModel *> *availablePlaces = [NSMutableArray arrayWithCapacity:placesAndRolesDicts.count];

        for (NSDictionary *dict in placesAndRolesDicts) {
            PlaceAndRoleModel *prModel = [[PlaceAndRoleModel alloc] initWithDict:dict];
            [availablePlaces addObject:prModel];
        }
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(availablePlaces);
        }];
    });
}

+ (BOOL)needsTermsAndConditionsConsent {
    if (![IrisClient sharedInstance].session.requiresTermsAndConditionsConsent &&
        ![IrisClient sharedInstance].session.requiresPrivacyPolicyConsent) {
        return NO;
    }
    if (![[UserSettings sharedInstance].currentPerson isAccountOwner]) {
        return NO;
    }
    return YES;
}

+ (void)acceptNewTermsAndConditions:(PersonModel *)person withBlock:(void(^)(void))completeBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *const privacyStr = @"PRIVACY";
        NSString *const termsStr = @"TERMS";
        if ([IrisClient sharedInstance].session.requiresTermsAndConditionsConsent &&
            [IrisClient sharedInstance].session.requiresPrivacyPolicyConsent) {
            [PersonCapability acceptPolicyWithType:termsStr onModel:person].thenInBackground(^{
                [PersonCapability acceptPolicyWithType:privacyStr onModel:person].thenInBackground(^{
                    if (completeBlock) {
                        completeBlock();
                    }
                    [IrisClient sharedInstance].session.requiresTermsAndConditionsConsent = NO;
                    [IrisClient sharedInstance].session.requiresPrivacyPolicyConsent = NO;
                });
            });
        }
        else if ([IrisClient sharedInstance].session.requiresTermsAndConditionsConsent) {
            [PersonCapability acceptPolicyWithType:termsStr onModel:person].thenInBackground(^{
                if (completeBlock) {
                    completeBlock();
                }
                [IrisClient sharedInstance].session.requiresTermsAndConditionsConsent = NO;
            });
        }
        else if ([IrisClient sharedInstance].session.requiresPrivacyPolicyConsent) {
            [PersonCapability acceptPolicyWithType:privacyStr onModel:person].thenInBackground(^{
                if (completeBlock) {
                    completeBlock();
                }
                [IrisClient sharedInstance].session.requiresPrivacyPolicyConsent = NO;
            });
        }
        else {
            if (completeBlock) {
                completeBlock();
            }
        }
    });
}
@end
