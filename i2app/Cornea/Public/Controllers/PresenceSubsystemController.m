//
//  PresenceSubsystemController.m
//  Pods
//
//  Created by Arcus Team on 11/10/15.
//
//

#import <i2app-Swift.h>
#import "PresenceSubsystemController.h"
#import "PresenceSubsystemCapability.h"



#import "PresenceCapability.h"

@interface PresenceSubsystemController ()

@end

@implementation PresenceSubsystemController


@synthesize subsystemModel;
@synthesize numberOfDevices;

@dynamic allDeviceIds;


@dynamic allPeopleAtHomeAddresses;
@dynamic allPeopleAwayAddresses;

@dynamic allDevicesAtHomeAddresses;
@dynamic allDevicesAwayAddresses;



- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}



- (NSArray *) allPeopleAtHomeAddresses {
    
    return [PresenceSubsystemCapability getPeopleAtHomeFromModel: self.subsystemModel];
}

- (NSArray *) allDevicesAtHomeAddresses {
    
    
    return [PresenceSubsystemCapability getDevicesAtHomeFromModel: self.subsystemModel];
}

- (NSArray *) allPeopleAwayAddresses {
    
    return [PresenceSubsystemCapability getPeopleAwayFromModel: self.subsystemModel];
}

- (NSArray *) allDevicesAwayAddresses {
    
    return [PresenceSubsystemCapability getDevicesAwayFromModel: self.subsystemModel];
}

- (NSArray *) allAddresses {
    
    return [PresenceSubsystemCapability getAllDevicesFromModel: self.subsystemModel];
}

- (NSArray *) allDeviceIds {
    NSMutableArray *devicesIds = [[NSMutableArray alloc] init];
    
    for (NSString *item in [self allAddresses]) {
        [devicesIds addObject:[item substringFromIndex:9]];
    }
    
    return devicesIds;
}

- (NSString*)findDeviceAssignedToPerson:(PersonModel*)person {
    for (NSString *modelAddress in [self allDeviceIds]) {
        NSString *deviceAddress = [NSString stringWithFormat:@"DRIV:dev:%@", modelAddress];
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];

        if ([[PresenceCapability getPersonFromModel:deviceModel] isEqualToString:person.address])
            return deviceModel.address;
    }

    return nil;
}

@end

