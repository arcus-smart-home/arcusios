//
//  ClimateScheduleController.m
//  Pods
//
//  Created by Arcus Team on 9/17/15.
//
//

#import <i2app-Swift.h>
#import "ClimateScheduleController.h"
#import "SchedulerService.h"
#import "Capability.h"

#import <PromiseKit/PromiseKit.h>
#import "SubsystemsController.h"
#import "CommonCheckableImageCell.h"
#import "ClimateSubSystemController.h"
#import "WeeklyScheduleViewController.h"
#import "ScheduleController.h"
#import "ThermostatScheduledEventModel.h"
#import "VentScheduledEventModel.h"
#import "FanScheduledEventModel.h"
#import "ThermostatSchedulerViewController.h"
#import "ThermostatCapability.h"
#import "ScheduleCapability.h"
#import "SchedulerCapability.h"
#import "SchedulableCapability.h"
#import "DeviceController.h"
#import "DeviceCapability.h"
#import "VentCapability.h"

#import "SchedulerService.h"

NSString *const kClimateSchedule = @"CLIMATE";


@interface ClimateScheduleController ()

@end


@implementation ClimateScheduleController

+ (PMKPromise *)saveWeeklyScheduleWithDeviceAddress:(NSString *)deviceAddress
                                               mode:(NSString *)mode
                                               days:(NSArray *)days
                                               time:(NSString *)time
                                        attritbutes:(NSDictionary *)attributes {
  #warning - ArcusClient Upgrade:  Investigate missing mode and offsetMinutes
  return [SchedulerService scheduleWeeklyCommandWithTarget:deviceAddress
                                              withSchedule:mode
                                                  withDays:days
                                                  withMode:nil // Seems like this should not be nil, but we do not have param for it.
                                                  withTime:time
                                         withOffsetMinutes:0 // Seems like this should not be zero, but we do not have param for it.
                                           withMessageType:kCmdSetAttributes
                                            withAttributes:attributes];
}

+ (PMKPromise *)updateWeeklyScheduleWithDeviceAddress:(NSString *)deviceAddress
                                                 mode:(NSString *)mode
                                                 days:(NSArray *)days
                                                 time:(NSString *)time
                                            commandId:(NSString *)commandId
                                          attritbutes:(NSDictionary *)attributes {
  #warning - ArcusClient Upgrade:  Investigate missing mode, offsetMinutes, and type
  return [SchedulerService updateWeeklyCommandWithTarget:deviceAddress
                                            withSchedule:mode
                                           withCommandId:commandId
                                                withDays:days
                                                withMode:nil // Seems like this should not be nil, but we do not have param for it.
                                                withTime:time
                                       withOffsetMinutes:0 // Seems like this should not be 0, but we do not have param for it.
                                         withMessageType:nil // Seems like this should not be nil, but we do not have param for it.
                                          withAttributes:attributes];
}

#pragma mark - dynamic properties
+ (ClimateScheduleController *)scheduleController {
    return (ClimateScheduleController *)ScheduleController.scheduleController;
}

- (NSString *)scheduleName {
    return @"Climate";
}

- (DeviceModel *)schedulingModel {
    return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:super.schedulingModelAddress];
}

#pragma mark - WeeklyScheduleViewController Overriden Methods
- (void)initializeData {
    self.modelsIds = [[SubsystemsController sharedInstance].climateController schedulingDeviceIds].mutableCopy;
}

- (void)onClickCell:(SimpleTableCell *)cell {
  DeviceModel *device = (DeviceModel *)cell.dataObject;
  self.schedulingModelAddress = device.address;

  if ([device isC2CDevice]) {
    NSString *subtitle = @"";

    if (device.deviceType == DeviceTypeThermostatNest) {
      subtitle = NSLocalizedString(@"Download the Nest app to\nmanage the schedule.", nil);
    } else {
      subtitle = NSLocalizedString(@"The Honeywell Wi-Fi Enabled Thermostat does\nnot allow scheduling from the Arcus app.", nil);
    }

    DDLogInfo(@"ClimateScheduleController:onClickCell:success");
    [[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil] popupErrorWindow:NSLocalizedString(@"Scheduling Unavailable", nil).uppercaseString subtitle:subtitle];
  }

  else if (device.deviceType == DeviceTypeThermostat) {
    [[self getOwner].navigationController pushViewController:[ThermostatSchedulerViewController create:device] animated:YES];
  }
  else if (device.deviceType == DeviceTypeSpaceHeater) {
    [[self getOwner].navigationController pushViewController:[WeeklyScheduleViewController create] animated:YES];
  }
  else {
    [super onClickCell:cell];
  }
}

- (void)onCheckEnable:(CommonCheckableImageCell *)cell withModel:(DeviceModel *)device {
    if (![[SubsystemsController sharedInstance].climateController isThermostatAddress:device.address]) {
        [super onCheckEnable:cell withModel:device];
        return;
    }
    
    if (![cell getChecked] && ![self hasScheduledEventsForModelWithAddress:device.address] && [ClimateScheduleController isModelPlatformSchedulable:device]) {
        [super onCheckEnable:cell withModel:device];
        return;
    }

    //Thermostat case
    [cell setCheck:![cell getChecked] styleBlack:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[SubsystemsController sharedInstance].climateController enableScheduleForThermostatWithAddress:device.address enable:[cell getChecked]].then(^{
            DDLogInfo(@"success");
        }).catch(^(NSError *error) {
            [[ApplicationRoutingService.defaultService displayingViewControllerInViewController:nil] displayGenericErrorMessage];
        });
    });
}

+ (BOOL)isModelPlatformSchedulable:(DeviceModel*) model {
  return ![[Capability capabilitiesForModel:model] containsObject: [SchedulableCapability namespace]]       ||
  [[SchedulableCapability getTypeFromModel:model] isEqualToString:kEnumSchedulableTypeSUPPORTED_DRIVER] ||
  [[SchedulableCapability getTypeFromModel:model] isEqualToString:kEnumSchedulableTypeSUPPORTED_CLOUD];
}

+ (BOOL)nextEventForModel:(DeviceModel *)deviceModel eventTime:(NSDate **)nextEventTime eventValue:(NSString **)nextEventValue {
    SchedulerModel *schedulerModel = [ScheduleController getSchedulerForModelWithAddress:deviceModel.address];
    if (!schedulerModel) {
        // schedule model doesn't exist
        *nextEventTime = nil;
        *nextEventValue = @"";
        return NO;
    }
    // Check if schedule is not enabled for the model
    if (![ScheduleController.scheduleController isScheduleEnabledForModel:deviceModel]) {
        // scheduler is disabled
        *nextEventTime = nil;
        *nextEventValue = @"";
        return NO;
    }
    NSString *fireSchedule = [SchedulerCapability getNextFireScheduleFromModel:schedulerModel];
    NSString *fireCommand = [schedulerModel getAttribute:[NSString stringWithFormat:@"%@:%@", kAttrScheduleNextFireCommand, fireSchedule]];
    
    if (![fireCommand isEqual:[NSNull null]] && fireCommand.length > 0) {
        NSDictionary *attributes = [SchedulerCapability getCommandsFromModel:schedulerModel][fireCommand];
        attributes = attributes[@"attributes"];
        if (attributes.count > 0) {
            if ([fireSchedule isEqualToString:kEnumThermostatHvacmodeHEAT]) {
                double temp = ((NSNumber *)attributes[kAttrThermostatHeatsetpoint]).doubleValue;
                temp = [DeviceController celsiusToFahrenheit:temp];
                *nextEventValue = [NSString stringWithFormat:@"%d°", (int)lround(temp)];

                *nextEventTime = [self nextEventTime:deviceModel];
                return YES;
            }
            else if ([fireSchedule isEqualToString:kEnumThermostatHvacmodeCOOL]) {
                double temp = ((NSNumber *)attributes[kAttrThermostatCoolsetpoint]).doubleValue;
                temp = [DeviceController celsiusToFahrenheit:temp];
                *nextEventValue = [NSString stringWithFormat:@"%d°", (int)lround(temp)];
                
                *nextEventTime = [self nextEventTime:deviceModel];
                return YES;
            }
            else if ([fireSchedule isEqualToString:kEnumThermostatHvacmodeAUTO]) {
                double coolTemp = ((NSNumber *)attributes[kAttrThermostatCoolsetpoint]).doubleValue;
                double heatTemp = ((NSNumber *)attributes[kAttrThermostatHeatsetpoint]).doubleValue;
                coolTemp = [DeviceController celsiusToFahrenheit:coolTemp];
                heatTemp = [DeviceController celsiusToFahrenheit:heatTemp];
                *nextEventValue = [NSString stringWithFormat:@"%d° - %d°", (int)lround(heatTemp), (int)lround(coolTemp)];
                
                *nextEventTime = [self nextEventTime:deviceModel];
                return YES;
            }
         }
    }
    // schedule model doesn't exist
    *nextEventTime = nil;
    *nextEventValue = @"";
    return NO;
}

+ (NSDate *)nextEventTime:(DeviceModel *)deviceModel {
    SchedulerModel *schedulerModel = [self getSchedulerForModelWithAddress:deviceModel.address];
    
    if (![schedulerModel getAttribute:kAttrSchedulerNextFireTime] || ([[schedulerModel getAttribute:kAttrSchedulerNextFireTime] isEqual:[NSNull null]])) {
        return nil;
    }
    
    return [SchedulerCapability getNextFireTimeFromModel:schedulerModel];
}

#pragma mark - ScheduledEventModel
- (ScheduledEventModel *)getNewEventModel {
    if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeThermostat) {
        return [[ThermostatScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeFanSwitch) {
        return [[FanScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeVent) {
        return [[VentScheduledEventModel alloc] init];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeSpaceHeater) {
        NSInteger minSetpointF = [DeviceController getSpaceHeaterMinSetpointForModel: ((DeviceModel *)self.schedulingModel)];
        NSInteger maxSetpointF = [DeviceController getSpaceHeaterMaxSetpointForModel: ((DeviceModel *)self.schedulingModel)];
        return [[SpaceHeaterScheduledEventModel alloc] initWithMinSetpointF:minSetpointF maxSetpointF:maxSetpointF];
    }
    return nil;
}

- (ScheduledEventModel *)createNewEventItem:(ScheduleRepeatType)eventDay withDelegate:(UIViewController<ScheduledEventModelDelegate> *)delegate {
    ScheduledEventModel *eventModel;
    if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeThermostat) {
        eventModel = [[ThermostatScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate inMode:self.scheduleMode];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeFanSwitch) {
        eventModel = [[FanScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeVent) {
        eventModel = [[VentScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate];
    }
    else if (((DeviceModel *)self.schedulingModel).deviceType == DeviceTypeSpaceHeater) {
        NSInteger minSetpointF = [DeviceController getSpaceHeaterMinSetpointForModel: ((DeviceModel *)self.schedulingModel)];
        NSInteger maxSetpointF = [DeviceController getSpaceHeaterMaxSetpointForModel: ((DeviceModel *)self.schedulingModel)];
        eventModel = [[SpaceHeaterScheduledEventModel alloc] initWithEventDay:eventDay withDelegate:delegate minSetpointF: minSetpointF maxSetpointF: maxSetpointF];
    }
    
    [eventModel preload];
    
    return eventModel;
}

#pragma mark - Schedule Type
- (NSString *)getScheduleType {
    DeviceModel *device = (DeviceModel *)self.schedulingModel;
    if (device.deviceType == DeviceTypeThermostat ||
        device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return [ClimateScheduleController scheduleModeToString:super.scheduleMode];
    }

    return kClimateSchedule;
}

+ (NSString *)scheduleModeToString:(int)mode {
    switch (mode) {
        case ThermostatHeatMode:
            return kEnumThermostatHvacmodeHEAT;
            
        case ThermostatCoolMode:
            return kEnumThermostatHvacmodeCOOL;
            
        case ThermostatAutoMode:
            return kEnumThermostatHvacmodeAUTO;
            
        case ThermostatOffMode:
            return kEnumThermostatHvacmodeOFF;
            
        default:
            return @"";
    }
}

+ (int)scheduleStringToMode:(NSString *)mode {
    return ThermostatModeStringToType(mode);
}

#pragma mark - Schedule Enable
- (BOOL)isScheduleEnabledForModel:(Model *)model {
    //Thermostat case
    if ([[SubsystemsController sharedInstance].climateController isThermostatAddress:model.address]) {
        return [[SubsystemsController sharedInstance].climateController isScheduleEnabledForThermostatWithAddress:model.address];
    }

    return [super isScheduleEnabledForModel:model];
}

- (NSArray *)loadEventForSelectedDay:(ScheduleRepeatType)selectedDay {
    NSArray *allEvents = [super loadEventForSelectedDay:selectedDay];
    if (super.scheduleMode == -1) {
        // For Fans and Vents
        return allEvents;
    }
    
    NSMutableArray *eventsForMode = [[NSMutableArray alloc] initWithCapacity:allEvents.count];
    
    for (ScheduledEventModel *item in allEvents) {
        NSString *scheduleMode = [ClimateScheduleController scheduleModeToString:super.scheduleMode];
        if ([item.originalCommand[@"scheduleId"] isEqualToString:scheduleMode]) {
            [eventsForMode addObject:item];
        }
    }
    return eventsForMode;
}

- (BOOL)hasEventsForSelectedDay:(ScheduleRepeatType)selectedDay {
    if (super.scheduleMode == -1) {
        // For Fans and Vents
        return [super hasEventsForSelectedDay:selectedDay];
    }
    
    NSArray *allEventModels = [self loadScheduledEvents];
    
    NSString *scheduleMode = [ClimateScheduleController scheduleModeToString:super.scheduleMode];
    for (ScheduledEventModel *item in allEventModels) {
        if (item.eventDay & selectedDay && [item.originalCommand[@"scheduleId"] isEqualToString:scheduleMode]) {
            return YES;
        }
    }
    return NO;
}

@end
