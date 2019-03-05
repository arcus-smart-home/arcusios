//
//  DeviceController.m
//  Pods
//
//  Created by Arcus Team on 5/14/15.
//
//

#import <i2app-Swift.h>
#import "DeviceController.h"
#import "PlaceCapability.h"
#import "AccountCapability.h"
#import "HubCapability.h"
#import <PromiseKit/PromiseKit.h>



#import "PersonController.h"
#import "Capability.h"
#import "ThermostatCapability.h"
#import "TemperatureCapability.h"
#import "ButtonCapability.h"
#import "IrrigationZoneCapability.h"
#import "WaterHeaterCapability.h"
#import "SubsystemsController.h"
#import "SchedulerService.h"
#import "DeviceConnectionCapability.h"
#import "DeviceAdvancedCapability.h"
#import "TiltCapability.h"
#import "AOSmithWaterHeaterControllerCapability.h"
#import "WaterHeaterCapability.h"
#import "SceneController.h"
#import "RulesController.h"
#import "FavoriteController.h"
#import "SpaceHeaterCapability.h"
#import "NestThermostatCapability.h"

#import <i2app-Swift.h>

@implementation DeviceController

NSString *const kDeviceListRefreshedNotification = @"DeviceListRefreshed";
NSString *const kHubListRefreshedNotification = @"HubListRefreshed";

NSString *const kZigbee = @"ZIGB";
NSString *const kZwave  = @"ZWAV";
NSString *const kIpcd   = @"IPCD";
NSString *const kCamera = @"SCOM";
NSString *const kHoneywell = @"HWLL";
NSString *const kNest = @"NEST";
NSString *const kHue = @"PHUE";
NSString *const kLutron = @"LUTR";
NSString *const kMock = @"MOCK";

NSString *const kTiltClosedOnUpright   = @"closedOnUpright";

// Retry 3 times each call
+ (PMKPromise *)retrieveHubAndDevices:(PlaceModel *)place {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (place) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                // Retrieve Hub
                [DeviceController getHubsForPlaceModel:place].catch(^(NSError *error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                        // retry
                        [DeviceController getHubsForPlaceModel:place].catch(^(NSError *error) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                // retry
                                [DeviceController getHubsForPlaceModel:place].catch(^(NSError *error) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                        // retry
                                        [DeviceController getHubsForPlaceModel:place].catch(^(NSError *error) {
                                            reject(error);
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
                
                // Retrieve Devices
                [DeviceController getDevicesForPlaceModel:place].catch(^(NSError *error) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                        // retry
                        [DeviceController getDevicesForPlaceModel:place].catch(^(NSError *error) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                // retry
                                [DeviceController getDevicesForPlaceModel:place].catch(^(NSError *error) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                        // retry
                                        [DeviceController getDevicesForPlaceModel:place].catch(^(NSError *error) {
                                            reject(error);
                                        });
                                    });
                                });
                            });
                        });
                    });
                });
            });
        }
    }];
}

+ (PMKPromise *)getHubsForPlaceModel:(PlaceModel *)placeModel {
    return [PlaceCapability getHubOnModel:placeModel].thenInBackground(^(PlaceGetHubResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            // DDLogWarn(@"PlaceGetHubResponse %@", [response get].description);
            fulfill([[response attributes] objectForKey:[HubCapability namespace]]);
            [[NSNotificationCenter defaultCenter] postNotificationName:kHubListRefreshedNotification object:[response attributes]];
        }];
    });
}

+ (PMKPromise *)getDevicesForPlaceModel:(PlaceModel *)place {
  return [PlaceCapability listDevicesOnModel:place].thenInBackground(^(PlaceListDevicesResponse *response) {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
      // DDLogWarn(@"PlaceListDevicesResponse %@", [response get].description);
      NSArray *devices = [response getDevices];
      // TODO: Verify not necessary
//      [[[CorneaHolder shared] modelCache] purgeDeletedModels:devices ofType:NSStringFromClass([DeviceModel class])];
      fulfill(devices);

      [SceneController getAllScenes:place.modelId].thenInBackground(^(NSArray *scenes) {
//        [[[CorneaHolder shared] modelCache] purgeDeletedModels:scenes ofType:NSStringFromClass([SceneModel class])];
      });

      [RulesController listRulesWithPlaceId:place.modelId];

      // Retrieve Subsystems
      [[SubsystemsController sharedInstance] retrieveSubsystemsForPlaceId:place.modelId]
      .thenInBackground(^(NSDictionary *subsystems) {
        if (subsystems != nil) {
          SubsystemModel *alarmSubsystem = SubsystemCache.sharedInstance.alarmSubsystem;
          if (alarmSubsystem) {
            if ([[SubsystemCapability getStateFromModel:alarmSubsystem] isEqualToString:kEnumSubsystemStateSUSPENDED]) {
              [SubsystemCapability activateOnModel:alarmSubsystem].thenInBackground(^(SubsystemActivateResponse *response) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlarmSubsystemUpdated"
                                                                    object:nil
                                                                  userInfo:nil];
              });
            }
          }
        }
      })
      .catch(^(NSError *error) {
        reject(error);
      });

      //Get Persons that have added to the place
      [PersonController listPersonsForPlaceModel:place].thenInBackground(^(NSArray *people) {
//        [[[CorneaHolder shared] modelCache] purgeDeletedModels:people.values ofType:NSStringFromClass([PersonModel class])];
      }).catch(^(NSError *error) {
        reject(error);
      });

      //Get list scheduler
      [SchedulerService listSchedulersWithPlaceId:place.modelId withIncludeWeekdays: NO].thenInBackground(^(SchedulerServiceListSchedulersResponse *response) {

        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *scheduler in [response getSchedulers]) {
          [models addObject:[[SchedulerModel alloc] initWithAttributes: scheduler]];
        }
        [[[CorneaHolder shared] modelCache] addModels:models];

      }).catch(^(NSError *error) {
        reject(error);
      });

      [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceListRefreshedNotification object:[response attributes]];
    }];
  });
}



#pragma mark - Temperature Conversion to Fahrenheit
+ (double)celsiusToFahrenheit:(double)celsius {
    return 9 / 5.0 * celsius + 32;
}

+ (double)fahrenheitToCelsius:(double)fahrenheit {
    return (fahrenheit - 32) * 5 / 9.0;
}

#pragma mark - Space Heater
+ (NSInteger)getSpaceHeaterSetpointForModel:(DeviceModel*) deviceModel {
    if ([deviceModel getAttribute:kAttrSpaceHeaterSetpoint] == nil ) {
        return NSNotFound;
    }
    
    double celsius = [SpaceHeaterCapability getSetpointFromModel:deviceModel];
    return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getSpaceHeaterMaxSetpointForModel:(DeviceModel*) deviceModel {
    if ([deviceModel getAttribute:kAttrSpaceHeaterMaxsetpoint] == nil ) {
        return NSNotFound;
    }
    
    double celsius = [SpaceHeaterCapability getMaxsetpointFromModel:deviceModel];
    return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getSpaceHeaterMinSetpointForModel:(DeviceModel*) deviceModel {
    if ([deviceModel getAttribute:kAttrSpaceHeaterMinsetpoint] == nil ) {
        return NSNotFound;
    }
    
    double celsius = [SpaceHeaterCapability getMinsetpointFromModel:deviceModel];
    return lround([self celsiusToFahrenheit:celsius]);
}

+ (PMKPromise*)setSpaceHeaterSetpointForModel:(double) tempInF onModel:(DeviceModel*) deviceModel {
    double celsius = [self fahrenheitToCelsius:tempInF];
    [SpaceHeaterCapability setSetpoint:celsius onModel:deviceModel];
    return [deviceModel commit];
}

#pragma mark - Device Advanced
+ (NSDictionary *)getDeviceErrors:(DeviceModel *)device {
    return [DeviceAdvancedCapability getErrorsFromModel:device];
}


#pragma mark - Thermostat
+ (NSArray *)availableModesForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrThermostatSupportedmodes] == nil ) {
    if (device.deviceType == DeviceTypeThermostatNest) {
      return @[
               kEnumThermostatHvacmodeHEAT,
               kEnumThermostatHvacmodeCOOL,
               kEnumThermostatHvacmodeAUTO,
               kEnumThermostatHvacmodeECO,
               kEnumThermostatHvacmodeOFF
               ];
    } else {
      return @[
               kEnumThermostatHvacmodeHEAT,
               kEnumThermostatHvacmodeCOOL,
               kEnumThermostatHvacmodeAUTO,
               kEnumThermostatHvacmodeOFF
               ];
    }
  }

  return [ThermostatCapability getSupportedmodesFromModel:device];
}

+ (NSInteger)getTemperatureForModel:(DeviceModel *)device {
    if ([device getAttribute:kAttrTemperatureTemperature] == nil ) {
        return NSNotFound;
    }
    
    double celsius = [TemperatureCapability getTemperatureFromModel:device];
    return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getThermostatCoolSetPointForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrThermostatCoolsetpoint] == nil ) {
    return NSNotFound;
  }

  double celsius = [ThermostatCapability getCoolsetpointFromModel:device];
  return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getSetpointSeparationForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrThermostatSetpointseparation] == nil ) {
    return 3;
  }

  double celsius = [ThermostatCapability getSetpointseparationFromModel:device];
  double fahrenheit = lround([self celsiusToFahrenheit:celsius]);
  return fahrenheit - 32; // Adjust for a delta value
}

+ (NSInteger)getMinSetpointForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrThermostatMinsetpoint] == nil ) {
    return 45;
  }

  double celsius = [ThermostatCapability getMinsetpointFromModel:device];
  return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getMaxSetpointForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrThermostatMaxsetpoint] == nil ) {
    return 95;
  }

  double celsius = [ThermostatCapability getMaxsetpointFromModel:device];
  return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getThermostatHeatSetPointForModel:(DeviceModel *)device {
    if ([device getAttribute:kAttrThermostatHeatsetpoint] == nil ) {
        return NSNotFound;
    }
    
    double celsius = [ThermostatCapability getHeatsetpointFromModel:device];
    return lround([self celsiusToFahrenheit:celsius]);
}

+ (PMKPromise *)setThermostatCoolSetPoint:(double)fahrenheit onModel:(DeviceModel *)device {
    fahrenheit = [self fahrenheitToCelsius:fahrenheit];
    [ThermostatCapability setCoolsetpoint:fahrenheit onModel:device];
    return [device commit];
}

+ (PMKPromise *)setThermostatHeatSetPoint:(double)fahrenheit onModel:(DeviceModel *)device {
    fahrenheit = [self fahrenheitToCelsius:fahrenheit];
    [ThermostatCapability setHeatsetpoint:fahrenheit onModel:device];
    return [device commit];
}

+ (PMKPromise *)setThermostatSetPoints:(double)coolPoint heatPoint:(double)heatPoint onModel:(DeviceModel *)device {
    heatPoint = [self fahrenheitToCelsius:heatPoint];
    [ThermostatCapability setHeatsetpoint:heatPoint onModel:device];
    coolPoint = [self fahrenheitToCelsius:coolPoint];
    [ThermostatCapability setCoolsetpoint:coolPoint onModel:device];
    
    return [device commit];
}

#pragma mark - Thermostat

+ (NSString *)getNestRoomNameForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrNestThermostatRoomname] == nil ) {
    return @"";
  }

  return [NestThermostatCapability getRoomnameFromModel:device];
}

+ (NSInteger)getNestLockedTempMinForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrNestThermostatLockedtempmin] == nil ) {
    return NSNotFound;
  }

  double celsius = [NestThermostatCapability getLockedtempminFromModel:device];
  return lround([self celsiusToFahrenheit:celsius]);
}

+ (NSInteger)getNestLockedTempMaxForModel:(DeviceModel *)device {
  if ([device getAttribute:kAttrNestThermostatLockedtempmax] == nil ) {
    return NSNotFound;
  }

  double celsius = [NestThermostatCapability getLockedtempmaxFromModel:device];
  return lround([self celsiusToFahrenheit:celsius]);
}

+ (BOOL)getNestLocked:(DeviceModel *)device {
  if ([device getAttribute:kAttrNestThermostatLocked] == nil ) {
    return false;
  }

  return [NestThermostatCapability getLockedFromModel:device];
}

#pragma mark - Get/Set state for Multi-instance capabilities
// Get button state for Key Fob
+ (NSString *)getFobButtonState:(DeviceModel *)device forButtonInstance:(NSString *)instance {
    NSString *key = [NSString stringWithFormat:@"%@:%@", kAttrButtonState, instance];
    NSString *state = [device get][key];
    return state;
}

// Set button state for Key Fob
+ (PMKPromise *)setFobButtonState:(DeviceModel *)device forButtonInstance:(NSString *)instance state:(BOOL)pressed {
  return [device removeTags:@{[NSString stringWithFormat:@"%@:%@", kAttrButtonState, instance] : pressed ? kEnumButtonStatePRESSED : kEnumButtonStateRELEASED}].thenInBackground(^(ClientEvent *event) {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
      fulfill(event);
    }];
  });
}

// Get Irrigation state for an Irrigation Parameter
+ (NSString *)getIrrigationParameterState:(DeviceModel *)device
                             forParameter:(NSString *)param
                          forZoneInstance:(NSString *)instance {
    NSString *key = [NSString stringWithFormat:@"%@:%@", param, instance];
    
    return [NSString stringWithFormat:@"%@", [device get][key]];
}

// Set Irrigation state for an Irrigation Parameter
+ (PMKPromise *)setIrrigationParameterState:(DeviceModel *)device
                               forParameter:(NSString *)param
                            forZoneInstance:(NSString *)instance
                                      state:(NSString *)state {
  return [device removeTags:@{[NSString stringWithFormat:@"%@:%@", param, instance] : state}].thenInBackground(^(ClientEvent *event) {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
      fulfill(event);
    }];
  });
}

#pragma mark - Connectivity type
+ (BOOL)isZigbeeDevice:(DeviceModel *)device {
    return [[DeviceAdvancedCapability getProtocolFromModel:device] caseInsensitiveCompare:kZigbee] == NSOrderedSame;
}

+ (BOOL)isZwaveDevice:(DeviceModel *)device {
    return [[DeviceAdvancedCapability getProtocolFromModel:device] caseInsensitiveCompare:kZwave] == NSOrderedSame;
}

+ (DeviceConnectivityType)getDeviceConnectivityType:(DeviceModel *)device {
    if (![[device caps] containsObject:[DeviceAdvancedCapability namespace]]) {
        // the device is of unknown type
        return DeviceConnectivityTypeOther;
    }

    NSString *protocol = [[DeviceAdvancedCapability getProtocolFromModel:device] uppercaseString];
    if ([protocol isEqualToString:kZwave]) {
        return DeviceConnectivityTypeZwave;
    }
    else if ([protocol isEqualToString:kZigbee] ||
             [protocol isEqualToString:kIpcd] ||
             [protocol isEqualToString:kCamera] ||
             [protocol isEqualToString:kHue] ||
             [protocol isEqualToString:kLutron] ||
             [protocol isEqualToString:kMock]) {
        return DeviceConnectivityTypeZigbee;
    }
    else if ([protocol isEqualToString:kNest]) {
      return DeviceConnectivityTypeNest;
    }
    else if ([protocol isEqualToString:kHoneywell]) {
        return DeviceConnectivityTypeHoneywell;
    }
    return DeviceConnectivityTypeOther;
}

#pragma mark - Tilt position
+ (BOOL)isCurrentTiltClosedPositionHorizontal:(DeviceModel *)device {
    return ([device.tags containsObject:kTiltClosedOnUpright]);
}

+(PMKPromise *)setTiltClosedPosition:(BOOL)isHorizontal onModel:(DeviceModel *)device {
    if (isHorizontal ) {
        return [DeviceController setTiltClosedPositionHorizontalOnModel:device];
    }
    
    return [DeviceController setTiltClosedPositionVerticalOnModel:device];
}

// TitSensors for garage door
+(PMKPromise *)setTiltClosedPositionHorizontalOnModel:(DeviceModel *)device {
    if ([device.tags containsObject:kTiltClosedOnUpright]) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(device);
        }];
    }
    
    return [FavoriteController addTag:kTiltClosedOnUpright onModel:device];
}

//TitSensor for jewery
+(PMKPromise *)setTiltClosedPositionVerticalOnModel:(DeviceModel *)device {
    if ([device.tags containsObject:kTiltClosedOnUpright]) {
        return [FavoriteController removeTag:kTiltClosedOnUpright onModel:device];
    }
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        fulfill(device);
    }];
}

#pragma mark - Water Heater
+ (NSArray *)getWaterHeaterErrors:(DeviceModel *)device {
    return [AOSmithWaterHeaterControllerCapability getErrorsFromModel:device].allValues;
}

+ (NSArray *)getWaterHeaterModes {
    return @[kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD, kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART];
}

+ (NSString *)getWaterHeaterControlMode:(DeviceModel *)device {
    return [AOSmithWaterHeaterControllerCapability getControlmodeFromModel:device];
}

+ (void)setWaterHeaterControlMode:(DeviceModel *)device controlMode:(NSString *)controlMode {
    [AOSmithWaterHeaterControllerCapability setControlmode:controlMode onModel:device];
}

+ (NSInteger)getWaterHeaterMaxSetPoint:(DeviceModel *)device {
    return lround([self celsiusToFahrenheit:[WaterHeaterCapability getMaxsetpointFromModel:device]]);
}


// Returned in Fahrenheit
+ (NSInteger)getWaterHeaterSetPoint:(DeviceModel *)device {
    return lround([self celsiusToFahrenheit:[WaterHeaterCapability getSetpointFromModel:device]]);
}

// Input temperature is in Fahrenheit
+ (PMKPromise *)setWaterHeaterSetPoint:(DeviceModel *)device setPoint:(double)tempInFahrenheit {
    [WaterHeaterCapability setSetpoint:[self fahrenheitToCelsius:tempInFahrenheit] onModel:device];
    
    return [device commit].thenInBackground(^ {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(device);
        }];
    });
}

@end
