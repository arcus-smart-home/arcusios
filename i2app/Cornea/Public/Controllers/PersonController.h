//
//  PersonController.h
//  Pods
//
//  Created by Arcus Team on 9/25/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;



@interface PersonController : NSObject

extern NSString *const kPromoteToAccountReturnPlaceKey;
extern NSString *const kPromoteToAccountReturnAccountKey;

#pragma mark - List People

+ (PMKPromise *)listPersonsForPlaceModel:(PlaceModel *)placeModel;

#pragma mark - Full Access Invitation

+ (void)invitePerson:(NSString *)firstName
            lastName:(NSString *)lastName
               email:(NSString *)emailAddress
        relationship:(NSString *)relationship
            greeting:(NSString *)greeting
             toPlace:(PlaceModel *)placeModel
          completion:(void (^)(BOOL inviteSent, NSError *error))completion;

#pragma mark - Add Person Limited Access

+ (PMKPromise *)addPerson:(PersonModel *)personModel
             withPassWord:(NSString *)password
                  toPlace:(PlaceModel *)placeModel;

+ (void)addPerson:(PersonModel *)personModel
     withPassword:(NSString *)password
          toPlace:(PlaceModel *)placeModel
       completion:(void (^)(NSString *newPersonAddress, NSError *error))completion;

#pragma mark - Remove Person

+ (PMKPromise *)deletePerson:(PersonModel *)personModel;

+ (PMKPromise *)deletePersonLogin:(PersonModel *)personModel;

#pragma mark - Remove Person's Access to Place

+ (PMKPromise *)removeAccessOfPerson:(PersonModel *)personModel fromPlaceId:(NSString *)placeId;

#pragma mark - Set Pin

+ (PMKPromise *)updatePin:(NSString *)newPin onPlaceModel:(PlaceModel *)placeModel onModel:(PersonModel *)personModel;

+ (void)setPin:(NSString *)pinCode
       placeId:(NSString *)placeId
   personModel:(PersonModel *)personModel
    completion:(void (^)(BOOL success, NSError *error))completion;

+ (PMKPromise *)getMobileDevicesList:(PersonModel *)person;

+ (void)deleteMobileDevice:(PersonModel *)person withIndex:(int)index
                completion:(void (^)(BOOL success, NSError *error))completion;

#pragma mark - Promote to account

+ (PMKPromise *)promoteToAccountWithPlace:(PlaceModel *)place onPerson:(PersonModel *)person;

@end
