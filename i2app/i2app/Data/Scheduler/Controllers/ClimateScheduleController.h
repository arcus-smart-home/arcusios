//
//  ClimateScheduleController.h
//  Pods
//
//  Created by Arcus Team on 9/17/15.
//
//

#import "ScheduleController.h"

@class PMKPromise;

@interface ClimateScheduleController : ScheduleController

+ (PMKPromise *)saveWeeklyScheduleWithDeviceAddress:(NSString *)deviceAddress
                                               mode:(NSString *)mode
                                               days:(NSArray *)days
                                               time:(NSString *)time
                                        attritbutes:(NSDictionary *)attributes;

+ (PMKPromise *)updateWeeklyScheduleWithDeviceAddress:(NSString *)deviceAddress
                                                 mode:(NSString *)mode
                                                 days:(NSArray *)days
                                                 time:(NSString *)time
                                            commandId:(NSString *)commandId
                                          attritbutes:(NSDictionary *)attributes;

@end
