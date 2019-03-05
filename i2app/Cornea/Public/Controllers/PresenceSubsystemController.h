//
//  PresenceSubsystemController.h
//  Pods
//
//  Created by Arcus Team on 11/10/15.
//
//

#import <Foundation/Foundation.h>
#import "SubsystemsController.h"

@interface PresenceSubsystemController : NSObject <SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;


@property (nonatomic, assign, readonly) NSArray *allPeopleAtHomeAddresses;
@property (nonatomic, assign, readonly) NSArray *allPeopleAwayAddresses;

@property (nonatomic, assign, readonly) NSArray *allDevicesAtHomeAddresses;
@property (nonatomic, assign, readonly) NSArray *allDevicesAwayAddresses;

@property (nonatomic, assign, readonly) NSArray *allAddresses;
@property (nonatomic, assign, readonly) NSArray *allDeviceIds;

- (NSString*)findDeviceAssignedToPerson:(PersonModel*)person;

@end
