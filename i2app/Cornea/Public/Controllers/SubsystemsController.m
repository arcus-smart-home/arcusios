//
//  SubsystemsController.m
//  Pods
//
//  Created by Arcus Team on 8/18/15.
//
//

#import <i2app-Swift.h>
#import "SubsystemsController.h"
#import "SubsystemService.h"
#import <PromiseKit/PromiseKit.h>
#import "SubsystemCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SafetySubsystemAlertController.h"
#import "ClimateSubSystemController.h"
#import "DoorsNLocksSubsystemController.h"
#import "SafetySubsystemCapability.h"
#import "SecuritySubsystemCapability.h"
#import "ClimateSubsystemCapability.h"
#import "DoorsNLocksSubsystemCapability.h"
#import "CameraSubsystemController.h"
#import "CamerasSubsystemCapability.h"
#import "PresenceSubsystemCapability.h"
#import "PresenceSubsystemController.h"
#import "LightsNSwitchesSubsystemController.h"
#import "LightsNSwitchesSubsystemCapability.h"
#import "WaterSubsystemController.h"
#import "WaterSubsystemCapability.h"
#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"
#import "LawnNGardenSubsystemController.h"
#import "LawnNGardenSubsystemCapability.h"
#import "CellBackupSubsystemCapability.h"
#import "WeatherSubsystemCapability.h"

#import <i2app-Swift.h>


NSString *const kSubsystemInitializedNotification = @"SubsystemInitialized";
NSString *const kSubsystemUpdatedNotification = @"SubsystemUpdated";
NSString *const kSubsystemUpdatedIdentifierKey = @"subystemId";

@interface SubsystemsController ()

@end


@implementation SubsystemsController

@dynamic isAlarmTriggered;

#pragma mark - Singleton
+ (instancetype)sharedInstance {
    static SubsystemsController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SubsystemsController alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Life Cycle
- (void)clearCurrentUserStates {
  _safetyController = nil;
  _securityController = nil;
  _climateController = nil;
  _doorsNLocksController = nil;
  _camerasController = nil;
  _presenceController = nil;
  _lightsNSwitchesController = nil;
  _waterController = nil;
  _careController = nil;
  _lawnNGardenController = nil;
  _cellBackupSubsystemController = nil;
  _weatherSubsystemController = nil;

  // Temporary to provide compatibility with Swift Subsystem handling.
  [SubsystemCache.sharedInstance clearSubsystems];
}

// TODO: !!!!!!!!!!!!!
// when any new subsystems are added, we need to add clearing their state in
// - (void)clearCurrentUserStates above
- (PMKPromise *)retrieveSubsystemsForPlaceId:(NSString *)placeId {
  return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
    [SubsystemService listSubsystemsWithPlaceId:placeId].thenInBackground(^(SubsystemServiceListSubsystemsResponse *response) {

      // Temporary to provide compatibility with Swift Subsystem handling.
      [SubsystemCache.sharedInstance process:response];

      for (NSDictionary *subSystem in [response getSubsystems]) {
        NSString *name = subSystem[kAttrSubsystemName];
        if ([name isEqualToString:[SafetySubsystemCapability name]]) {
          _safetyController = [[SafetySubsystemAlertController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[SecuritySubsystemCapability name]]) {
          _securityController = [[SecuritySubsystemAlertController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[ClimateSubsystemCapability name]]) {
          _climateController = [[ClimateSubSystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[DoorsNLocksSubsystemCapability name]]) {
          _doorsNLocksController = [[DoorsNLocksSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[CamerasSubsystemCapability name]]) {
          _camerasController = [[CameraSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[PresenceSubsystemCapability name]]) {
          _presenceController = [[PresenceSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[LightsNSwitchesSubsystemCapability name]]) {
          _lightsNSwitchesController = [[LightsNSwitchesSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[WaterSubsystemCapability name]]) {
          _waterController = [[WaterSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[CareSubsystemCapability name]]) {
          _careController = [[CareSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[LawnNGardenSubsystemCapability name]]) {
          _lawnNGardenController = [[LawnNGardenSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[CellBackupSubsystemCapability name]]) {
          _cellBackupSubsystemController = [[CellBackupSubsystemController alloc] initWithAttributes:subSystem];
        }
        else if ([name isEqualToString:[WeatherSubsystemCapability name]]) {
          _weatherSubsystemController = [[WeatherSubsystemController alloc] initWithAttributes:subSystem];
        }
      }

      [[NSNotificationCenter defaultCenter] postNotificationName:kSubsystemInitializedNotification object:nil userInfo:nil];

      fulfill([response getSubsystems]);
    }).catch(^(NSError *error) {
      reject(error);
    });
  }];
}

#pragma mark - Dynamic Properties
- (BOOL)isAlarmTriggered {
    return (self.securityController.isAlarmTriggered || self.safetyController.isAlarmTriggered|| self.careController.isAlarmTriggered);
}

- (void)addOrUpdateSubsystemWithModel:(SubsystemModel *)model andSource:(NSString *)source {
    // Source has this format SERV:subsecurity:a9c04eb6-7f4e-49e1-a432-28a044a681e4
    NSArray *components = [source componentsSeparatedByString:@":"];
    if ([components count] != 3) {
        return;
    }
    
    NSString *sourceType = [components objectAtIndex:1];
    NSString *subsystemId = [components objectAtIndex:2];

    id <SubsystemProtocol> subsystem = [self subsystemControllerForSourceType:sourceType];

    if (subsystem != nil) {
        [self updateSubSystemController:subsystem
                             attributes:[model get]
                            subSystemId:subsystemId];
    } else {
      // Temporary to provide compatibility with Swift Subsystem handling.
      [SubsystemCache.sharedInstance addOrUpdateSubsystemWithModel:model
                                                              andSource:source];
    }
  
    NSDictionary *userInfo = @{kSubsystemUpdatedIdentifierKey: subsystemId};

    [[NSNotificationCenter defaultCenter] postNotificationName:kSubsystemUpdatedNotification object:nil userInfo:userInfo];
}

- (id <SubsystemProtocol>)subsystemControllerForSourceType:(NSString *)sourceType {
    id <SubsystemProtocol> subsystem = nil;
    if ([sourceType isEqualToString:[SecuritySubsystemCapability namespace]]) {
        subsystem = _securityController;
    } else if ([sourceType isEqualToString:[SafetySubsystemCapability namespace]]) {
        subsystem = _safetyController;
    } else if ([sourceType isEqualToString:[DoorsNLocksSubsystemCapability namespace]]) {
        subsystem = _doorsNLocksController;
    } else if ([sourceType isEqualToString:[ClimateSubsystemCapability namespace]]) {
        subsystem = _climateController;
    } else if ([sourceType isEqualToString:[CamerasSubsystemCapability namespace]]) {
        subsystem = _camerasController;
    } else if ([sourceType isEqualToString:[PresenceSubsystemCapability namespace]]) {
        subsystem = _presenceController;
    } else if ([sourceType isEqualToString:[LightsNSwitchesSubsystemCapability namespace]]) {
        subsystem = _lightsNSwitchesController;
    } else if ([sourceType isEqualToString:[WaterSubsystemCapability namespace]]) {
        subsystem = _waterController;
    } else if ([sourceType isEqualToString:[CareSubsystemCapability namespace]]) {
        subsystem = _careController;
    } else if ([sourceType isEqualToString:[LawnNGardenSubsystemCapability namespace]]) {
        subsystem = _lawnNGardenController;
    } else if ([sourceType isEqualToString:[CellBackupSubsystemCapability namespace]]) {
        subsystem = _cellBackupSubsystemController;
    } else if ([sourceType isEqualToString:[WeatherSubsystemCapability namespace]]) {
        subsystem = _weatherSubsystemController;
    }

    return subsystem;
}

- (void)updateSubSystemController:(id<SubsystemProtocol>) subsystemController
                       attributes:(NSDictionary *)attributes
                      subSystemId:(NSString *)subSystemId {
    
    if (![subsystemController.subsystemModel.modelId containsString:subSystemId]) {
        return;
    }
    //Notificaiton was implemented inside setAttributes method
    NSString *address = subsystemController.subsystemModel.address;
    [subsystemController.subsystemModel modelUpdated:attributes];
}

#pragma mark - Subsystem History
+ (PMKPromise *)getSubsystemHistory:(SubsystemModel *)modelObj withToken:(NSString *)token entriesLimit:(int)limit includeIncidents:(BOOL)includeIncidents {
    return [SubsystemCapability listHistoryEntriesWithLimit:limit
                                           withToken:token
                                withIncludeIncidents:includeIncidents
                                             onModel:modelObj];
}

@end
