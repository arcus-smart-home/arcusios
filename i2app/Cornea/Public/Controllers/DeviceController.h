//
//  DeviceController.h
//  Pods
//
//  Created by Arcus Team on 5/14/15.
//
//

#import <Foundation/Foundation.h>




@class PMKPromise;


extern NSString *const kDeviceListRefreshedNotification;
extern NSString *const kHubListRefreshedNotification;

typedef NS_ENUM(unsigned int, DeviceConnectivityType) {
    DeviceConnectivityTypeOther,
    DeviceConnectivityTypeZigbee,
    DeviceConnectivityTypeZwave,
    DeviceConnectivityTypeHoneywell,
    DeviceConnectivityTypeNest
};


@interface DeviceController : NSObject

+ (PMKPromise *)retrieveHubAndDevices:(PlaceModel *)place;

+ (PMKPromise *)getHubsForPlaceModel:(PlaceModel *)placeModel;
+ (PMKPromise *)getDevicesForPlaceModel:(PlaceModel *)place;

+ (NSString *)getPlatformUrl;
// retrieve the base url without the port#
+ (NSString *)getBaseUrl;

#pragma mark - Temperature Conversion to Fahrenheit
+ (double)celsiusToFahrenheit:(double)celsius;
+ (double)fahrenheitToCelsius:(double)fahrenheit;

#pragma mark - Space Heater Temperature Conversion to Fahrenheit
+ (NSInteger)getSpaceHeaterSetpointForModel:(DeviceModel*) deviceModel;
+ (NSInteger)getSpaceHeaterMinSetpointForModel:(DeviceModel*) deviceModel;
+ (NSInteger)getSpaceHeaterMaxSetpointForModel:(DeviceModel*) deviceModel;
+ (PMKPromise*)setSpaceHeaterSetpointForModel:(double) tempInF onModel:(DeviceModel*) deviceModel;

#pragma mark - Device Advanced
+ (NSDictionary *)getDeviceErrors:(DeviceModel *)device;

#pragma mark - Thermostat 
+ (NSInteger)getTemperatureForModel:(DeviceModel *)device;
+ (NSInteger)getThermostatCoolSetPointForModel:(DeviceModel *)device;
+ (NSInteger)getThermostatHeatSetPointForModel:(DeviceModel *)device;
+ (NSInteger)getMinSetpointForModel:(DeviceModel *)device;
+ (NSInteger)getMaxSetpointForModel:(DeviceModel *)device;
+ (NSInteger)getSetpointSeparationForModel:(DeviceModel *)device;
+ (PMKPromise *)setThermostatCoolSetPoint:(double)fahrenheit onModel:(DeviceModel *)device;
+ (PMKPromise *)setThermostatHeatSetPoint:(double)fahrenheit onModel:(DeviceModel *)device;
+ (PMKPromise *)setThermostatSetPoints:(double)coolPoint heatPoint:(double)heatPoint onModel:(DeviceModel *)device;

#pragma mark - Thermostat Nest
+ (NSString *)getNestRoomNameForModel:(DeviceModel *)device;
+ (NSInteger)getNestLockedTempMinForModel:(DeviceModel *)device;
+ (NSInteger)getNestLockedTempMaxForModel:(DeviceModel *)device;
+ (BOOL)getNestLocked:(DeviceModel *)device;

#pragma mark - Get/Set state for Multi-instance capabilities
+ (NSArray *)availableModesForModel:(DeviceModel *)device;
+ (NSString *)getFobButtonState:(DeviceModel *)device forButtonInstance:(NSString *)instance;
+ (PMKPromise *)setFobButtonState:(DeviceModel *)device forButtonInstance:(NSString *)instance state:(BOOL)pressed;

+ (NSString *)getIrrigationParameterState:(DeviceModel *)device
                             forParameter:(NSString *)param
                          forZoneInstance:(NSString *)instance;
+ (PMKPromise *)setIrrigationParameterState:(DeviceModel *)device
                               forParameter:(NSString *)param
                            forZoneInstance:(NSString *)instance
                                      state:(NSString *)state;

#pragma mark - Connectivity type
+ (BOOL)isZigbeeDevice:(DeviceModel *)device;
+ (BOOL)isZwaveDevice:(DeviceModel *)device;
+ (DeviceConnectivityType)getDeviceConnectivityType:(DeviceModel *)device;

#pragma mark - Tilt position
+ (BOOL)isCurrentTiltClosedPositionHorizontal:(DeviceModel *)device;
+ (PMKPromise *)setTiltClosedPosition:(BOOL)isHorizontal onModel:(DeviceModel *)device;

#pragma mark - Water Heater
+ (NSArray *)getWaterHeaterErrors:(DeviceModel *)device;
+ (NSArray *)getWaterHeaterModes;
+ (NSString *)getWaterHeaterControlMode:(DeviceModel *)device;
+ (void)setWaterHeaterControlMode:(DeviceModel *)device controlMode:(NSString *)controlMode;
+ (NSInteger)getWaterHeaterMaxSetPoint:(DeviceModel *)device;
+ (NSInteger)getWaterHeaterSetPoint:(DeviceModel *)device;
+ (PMKPromise *)setWaterHeaterSetPoint:(DeviceModel *)device setPoint:(double)tempInFahrenheit;

@end
