
//
//  ClimateSubSystemController.m
//  Pods
//
//  Created by Arcus Team on 9/15/15.
//
//

#import <i2app-Swift.h>
#import "ClimateSubSystemController.h"
#import "ClimateSubsystemCapability.h"
#import "SubsystemsController.h"



@implementation ClimateSubSystemController

@synthesize subsystemModel;

@dynamic allDeviceIds;
@dynamic numberOfDevices;


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self  = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

- (NSArray *)allDeviceIds {
    NSArray *thermostatDevices = [self getModelSourcesFromSourcesSortedAlphabetically:[ClimateSubsystemCapability getThermostatsFromModel:self.subsystemModel]];
    NSArray *fanAndVentDevices = [self getModelSourcesFromSourcesSortedAlphabetically:[self fanAndVentDevices]];
    
    NSMutableArray *allDevices = thermostatDevices.mutableCopy;
    [allDevices addObjectsFromArray:fanAndVentDevices];
    
    return allDevices.copy;
}

// Get an array of model Ids sorted alphabetically based on the Model Name
- (NSArray *)getModelSourcesFromSourcesSortedAlphabetically:(NSArray *)sources {

  NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:sources.count];
  for (NSString *source in sources) {
    Model *model = [[[CorneaHolder shared] modelCache] fetchModel:source];
    if (model) {
      [models addObject:model];
    }
  }

  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [models sortUsingDescriptors:@[sort]];

  NSMutableArray *sortedModelIds = [[NSMutableArray alloc] initWithCapacity:models.count];

  for (Model *model in models) {
    [sortedModelIds addObject:model.modelId];
  }
  return sortedModelIds.copy;
}

- (int)numberOfDevices {
    return (int)[ClimateSubsystemCapability getControlDevicesFromModel:self.subsystemModel].count;
}

- (NSArray *)temperatureDeviceIds {
    NSMutableArray *tempDeviceIds = [self thermostatDeviceIds].mutableCopy;
    
    NSMutableSet *tempSet = [NSMutableSet setWithArray:[ClimateSubsystemCapability getTemperatureDevicesFromModel:self.subsystemModel]];
    NSSet *thermoSet = [NSSet setWithArray:tempDeviceIds];
    [tempSet minusSet:thermoSet];
    [tempDeviceIds addObjectsFromArray:tempSet.allObjects];
    
    return tempDeviceIds;
}
- (NSString *)primaryTempDeviceId {
    return [ClimateSubsystemCapability getPrimaryTemperatureDeviceFromModel:self.subsystemModel];
}

- (void)setPrimaryTempDeviceAddress:(NSString *)deviceAddress {
        [ClimateSubsystemCapability setPrimaryTemperatureDevice:deviceAddress onModel:self.subsystemModel];
        [self.subsystemModel commit];
}

- (BOOL)isThermostatAddress:(NSString *)deviceAddress {
    for (NSString *theDeviceAddress in [self thermostatDeviceIds]) {
        if ([theDeviceAddress isEqualToString:deviceAddress]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)thermostatDeviceIds {
    return [ClimateSubsystemCapability getThermostatsFromModel:self.subsystemModel];
}

- (NSString *)primaryThermoDeviceId {
    return [ClimateSubsystemCapability getPrimaryThermostatFromModel:self.subsystemModel];
}

- (PMKPromise *)setPrimaryThermoDeviceAddress:(NSString *)deviceAddress {
    [ClimateSubsystemCapability setPrimaryThermostat:deviceAddress onModel:self.subsystemModel];
    return [self.subsystemModel commit];
}

- (NSArray *)humidDeviceIds {
    return [ClimateSubsystemCapability getHumidityDevicesFromModel:self.subsystemModel];
}

- (NSString *)primaryHumidityDeviceId {
    return [ClimateSubsystemCapability getPrimaryHumidityDeviceFromModel:self.subsystemModel];
}

- (PMKPromise *)setPrimaryHumidDeviceAddress:(NSString *)deviceAddress {
    [ClimateSubsystemCapability setPrimaryHumidityDevice:deviceAddress onModel:self.subsystemModel];
    return [self.subsystemModel commit];
}

- (double)temperature {
    return [ClimateSubsystemCapability getTemperatureFromModel:self.subsystemModel];
}

- (double)humidity {
    if (![self.subsystemModel getAttribute:kAttrClimateSubsystemHumidity] ||
        [self.subsystemModel getAttribute:kAttrClimateSubsystemHumidity] == [NSNull null]) {
        return 0;
    }
    return [ClimateSubsystemCapability getHumidityFromModel:self.subsystemModel];
}

- (NSArray *)closedVentIds {
    return [ClimateSubsystemCapability getClosedVentsFromModel:self.subsystemModel];
}

- (NSArray *)activeFanIds {
    return [ClimateSubsystemCapability getActiveFansFromModel:self.subsystemModel];
}

- (NSArray *)activeSpaceHeaters {
    return [ClimateSubsystemCapability getActiveHeatersFromModel:self.subsystemModel];
}

- (NSArray *)schedulingDeviceIds {
    NSMutableArray *deviceAddresses = [[NSMutableArray alloc] init];
    [deviceAddresses addObjectsFromArray:[ClimateSubsystemCapability getThermostatsFromModel:self.subsystemModel]];
    [deviceAddresses addObjectsFromArray:[self fanAndVentDevices]];
    
    NSMutableArray *deviceIds = [[NSMutableArray alloc] initWithCapacity:deviceAddresses.count];
    for (NSString *deviceAddress in deviceAddresses) {
        NSString *deviceId = [DeviceModel modelIdForAddress:deviceAddress];
        [deviceIds addObject:deviceId];
    }
    return deviceIds;
}

- (NSArray *)fanAndVentDevices {
    NSMutableSet *allDevicesSet = [NSMutableSet setWithArray: [ClimateSubsystemCapability getControlDevicesFromModel:self.subsystemModel]];
    NSSet *thermostatSet = [NSSet setWithArray:[ClimateSubsystemCapability getThermostatsFromModel:self.subsystemModel]];
    [allDevicesSet minusSet:thermostatSet];
    
    return allDevicesSet.allObjects;
}

- (BOOL)isScheduleEnabledForThermostatWithAddress:(NSString *)deviceAddress {
    NSDictionary *thermostatSchedule  = [ClimateSubsystemCapability getThermostatSchedulesFromModel:self.subsystemModel];
    NSDictionary *attributes = [thermostatSchedule objectForKey:deviceAddress];
    
    NSNumber *enabled = [attributes objectForKey:@"enabled"];
    if (!enabled || ![enabled isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    return enabled.boolValue;
}

- (PMKPromise *)enableScheduleForThermostatWithAddress:(NSString *)deviceAddress enable:(BOOL)enable {
    if (enable) {
        return [ClimateSubsystemCapability enableSchedulerWithThermostat:deviceAddress onModel:self.subsystemModel];
    }
    else {
        return [ClimateSubsystemCapability disableSchedulerWithThermostat:deviceAddress onModel:self.subsystemModel];
    }
}

@end
