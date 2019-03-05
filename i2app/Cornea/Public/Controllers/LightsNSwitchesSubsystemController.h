//
//  LightsNSwitchesSubsystemController.h
//  Pods
//
//  Created by Arcus Team on 12/2/15.
//
//

#import <Foundation/Foundation.h>
#import "SubsystemsController.h"

@interface LightsNSwitchesSubsystemController : NSObject <SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (atomic, readonly) int numberOfOnDevices;
@property (atomic, readonly) int numberOfOnDimmers;
@property (atomic, readonly) int numberOfOnLights;
@property (atomic, readonly) int numberOfOnSwitches;

@property (nonatomic, weak, readonly) NSArray *allDimmersAddresses;
@property (nonatomic, weak, readonly) NSArray *allLightsAddresses;
@property (nonatomic, weak, readonly) NSArray *allSwitchesAddresses;

- (void)switchOrderFrom:(NSInteger)oldPosition to:(NSInteger)newPosition;

@end
