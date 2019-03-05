//
//  ClimateSubSystemController.h
//  Pods
//
//  Created by Arcus Team on 9/15/15.
//
//

#import <Foundation/Foundation.h>
#import "SubsystemsController.h"

#define kThermostatMaxTemperature 95
#define kThermostatMinTemperature 45
#define kThermostatDefaultCoolTemperature 78
#define kThermostatDefaultHeatTemperature 68
#define kThermostatDefaultTempDifference 3


@interface ClimateSubSystemController : NSObject <SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (NSArray *)temperatureDeviceIds;
- (NSString *)primaryTempDeviceId;
- (void)setPrimaryTempDeviceAddress:(NSString *)deviceAddress;
- (BOOL)isThermostatAddress:(NSString *)deviceAddress;

- (NSArray *)thermostatDeviceIds;
- (NSString *)primaryThermoDeviceId;
- (PMKPromise *)setPrimaryThermoDeviceAddress:(NSString *)deviceAddress;

- (NSArray *)humidDeviceIds;
- (NSString *)primaryHumidityDeviceId;
- (PMKPromise *)setPrimaryHumidDeviceAddress:(NSString *)deviceAddress;

- (double)temperature;
- (double)humidity;

- (NSArray *)closedVentIds;
- (NSArray *)activeFanIds;
- (NSArray *)activeSpaceHeaters;

- (NSArray *)schedulingDeviceIds;

- (BOOL)isScheduleEnabledForThermostatWithAddress:(NSString *)deviceAddress;

- (PMKPromise *)enableScheduleForThermostatWithAddress:(NSString *)deviceAddress enable:(BOOL)enable;

@end
