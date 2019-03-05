//
//  PersonController.m
//  Pods
//
//  Created by Arcus Team on 9/25/15.
//
//

#import <i2app-Swift.h>
#import "PersonController.h"
#import "PersonCapability.h"


#import "PlaceCapability.h"

@implementation PersonController

NSString *const kPromoteToAccountReturnPlaceKey = @"place";
NSString *const kPromoteToAccountReturnAccountKey = @"account";


#pragma mark - List People

+ (PMKPromise *)listPersonsForPlaceModel:(PlaceModel *)placeModel {
    return [PlaceCapability listPersonsOnModel:placeModel].thenInBackground(^(PlaceListPersonsResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([[[CorneaHolder shared] modelCache] fetchModels:[PersonCapability namespace]]);
        }];
    });
}

#pragma mark - Full Access Invitation

+ (void)invitePerson:(NSString *)firstName
            lastName:(NSString *)lastName
               email:(NSString *)emailAddress
        relationship:(NSString *)relationship
            greeting:(NSString *)greeting
             toPlace:(PlaceModel *)placeModel
          completion:(void (^)(BOOL inviteSent, NSError *error))completion {
    [PlaceCapability createInvitationWithFirstName:firstName
                                      withLastName:lastName
                                         withEmail:emailAddress
                                  withRelationship:relationship
                                           onModel:placeModel].thenInBackground(^(PlaceCreateInvitationResponse *response) {
        NSMutableDictionary *invitation = [NSMutableDictionary dictionaryWithDictionary:[response getInvitation]];
        if (greeting) {
            [invitation setObject:greeting forKey:@"personalizedGreeting"];
        }

        [PlaceCapability sendInvitationWithInvitation:invitation
                                              onModel:placeModel].then(^(PlaceSendInvitationResponse *response) {
            if (completion) {
                completion(YES, nil);
            }
        }).catch(^(NSError *error) {
            if (completion) {
                completion(NO, error);
            }
        });
    }).catch(^(NSError *error) {
        if (completion) {
            completion(NO, error);
        }
    });
}

#pragma mark - Add Person Limited Access

+ (PMKPromise *)addPerson:(PersonModel *)personModel
             withPassWord:(NSString *)password
                  toPlace:(PlaceModel *)placeModel {
    return [PlaceCapability addPersonWithPerson:personModel
                                    withPassword:password
                                        onModel:placeModel].thenInBackground(^(PlaceAddPersonResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([response getNewPerson]);
        }];
    });
}

+ (void)addPerson:(PersonModel *)personModel
     withPassword:(NSString *)password
          toPlace:(PlaceModel *)placeModel
       completion:(void (^)(NSString *newPersonAddress, NSError *error))completion {
    
    [PersonController addPerson:personModel
                   withPassWord:password
                        toPlace:placeModel].then(^(NSString *newPersonAddress) {
        if (completion) {
            completion(newPersonAddress, nil);
        }
    }).catch(^(NSError *error){
        if (completion) {
            completion(nil, error);
        }
    });
}

#pragma mark - Remove Person

+ (PMKPromise *)deletePerson:(PersonModel *)personModel {
    return [PersonCapability deleteOnModel:personModel].thenInBackground(^(PersonDeleteResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([[[CorneaHolder shared] modelCache] fetchModels:[PersonCapability namespace]]);
        }];
    });
}

+ (PMKPromise *)deletePersonLogin:(PersonModel *)personModel {
    return [PersonCapability deleteLoginOnModel:personModel];
}

#pragma mark - Remove Person's Access to Place

+ (PMKPromise *)removeAccessOfPerson:(PersonModel *)personModel fromPlaceId:(NSString *)placeId {
    return [PersonCapability removeFromPlaceWithPlaceId:placeId onModel:personModel];
}

#pragma mark - Set Pin

+ (PMKPromise *)updatePin:(NSString *)newPin onPlaceModel:(PlaceModel *)placeModel onModel:(PersonModel *)personModel {
    return [PersonCapability changePinV2WithPlace:placeModel.address withPin:newPin onModel:personModel];
}

+ (void)setPin:(NSString *)pinCode
       placeId:(NSString *)placeId
   personModel:(PersonModel *)personModel
    completion:(void (^)(BOOL success, NSError *error))completion {
    
    [PersonCapability changePinV2WithPlace:placeId
                                   withPin:pinCode
                                   onModel:personModel].then(^(PersonChangePinV2Response *response) {
        if (completion) {
            completion([response attributes][@"success"], nil);
        }
    }).catch(^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    });
}

+ (PMKPromise *)getMobileDevicesList:(PersonModel *)person {

    return [PersonCapability listMobileDevicesOnModel:person].thenInBackground(^(PersonListMobileDevicesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            // Convert response to NSArray deviceList
            NSArray *deviceDicts = [response getMobileDevices];
            NSMutableArray *devices = [[NSMutableArray alloc] initWithCapacity:deviceDicts.count];
            for (NSDictionary *dict in deviceDicts) {
                MobileDeviceModel *deviceModel = [[MobileDeviceModel alloc] initWithAttributes:dict];
                [devices addObject:deviceModel];
            }
            fulfill(devices.copy);
        }];
    });
}

+ (void)deleteMobileDevice:(PersonModel *)person withIndex:(int)index
                completion:(void (^)(BOOL success, NSError *error))completion {
    [PersonCapability removeMobileDeviceWithDeviceIndex:index onModel:person].thenInBackground(^(PersonRemoveMobileDeviceResponse *response) {
        completion(response.attributes.count == 0, nil);
    }).catch(^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    });
}

#pragma mark - Promote to account

+ (PMKPromise *)promoteToAccountWithPlace:(PlaceModel *)place onPerson:(PersonModel *)person {
    return [PersonCapability promoteToAccountWithPlace:place onModel:person].thenInBackground(^(PersonPromoteToAccountResponse *response){
        NSDictionary *placeAndAccountDict = @{kPromoteToAccountReturnPlaceKey : [response getPlace], kPromoteToAccountReturnAccountKey : [response getAccount]};
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(placeAndAccountDict);
        }];
    });
}

@end
