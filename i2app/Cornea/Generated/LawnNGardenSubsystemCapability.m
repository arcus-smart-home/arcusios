

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LawnNGardenSubsystemCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLawnNGardenSubsystemControllers=@"sublawnngarden:controllers";

NSString *const kAttrLawnNGardenSubsystemScheduleStatus=@"sublawnngarden:scheduleStatus";

NSString *const kAttrLawnNGardenSubsystemOddSchedules=@"sublawnngarden:oddSchedules";

NSString *const kAttrLawnNGardenSubsystemEvenSchedules=@"sublawnngarden:evenSchedules";

NSString *const kAttrLawnNGardenSubsystemWeeklySchedules=@"sublawnngarden:weeklySchedules";

NSString *const kAttrLawnNGardenSubsystemIntervalSchedules=@"sublawnngarden:intervalSchedules";

NSString *const kAttrLawnNGardenSubsystemNextEvent=@"sublawnngarden:nextEvent";

NSString *const kAttrLawnNGardenSubsystemZonesWatering=@"sublawnngarden:zonesWatering";


NSString *const kCmdLawnNGardenSubsystemStopWatering=@"sublawnngarden:StopWatering";

NSString *const kCmdLawnNGardenSubsystemSwitchScheduleMode=@"sublawnngarden:SwitchScheduleMode";

NSString *const kCmdLawnNGardenSubsystemEnableScheduling=@"sublawnngarden:EnableScheduling";

NSString *const kCmdLawnNGardenSubsystemDisableScheduling=@"sublawnngarden:DisableScheduling";

NSString *const kCmdLawnNGardenSubsystemSkip=@"sublawnngarden:Skip";

NSString *const kCmdLawnNGardenSubsystemCancelSkip=@"sublawnngarden:CancelSkip";

NSString *const kCmdLawnNGardenSubsystemConfigureIntervalSchedule=@"sublawnngarden:ConfigureIntervalSchedule";

NSString *const kCmdLawnNGardenSubsystemCreateWeeklyEvent=@"sublawnngarden:CreateWeeklyEvent";

NSString *const kCmdLawnNGardenSubsystemUpdateWeeklyEvent=@"sublawnngarden:UpdateWeeklyEvent";

NSString *const kCmdLawnNGardenSubsystemRemoveWeeklyEvent=@"sublawnngarden:RemoveWeeklyEvent";

NSString *const kCmdLawnNGardenSubsystemCreateScheduleEvent=@"sublawnngarden:CreateScheduleEvent";

NSString *const kCmdLawnNGardenSubsystemUpdateScheduleEvent=@"sublawnngarden:UpdateScheduleEvent";

NSString *const kCmdLawnNGardenSubsystemRemoveScheduleEvent=@"sublawnngarden:RemoveScheduleEvent";

NSString *const kCmdLawnNGardenSubsystemSyncSchedule=@"sublawnngarden:SyncSchedule";

NSString *const kCmdLawnNGardenSubsystemSyncScheduleEvent=@"sublawnngarden:SyncScheduleEvent";


NSString *const kEvtLawnNGardenSubsystemStartWatering=@"sublawnngarden:StartWatering";

NSString *const kEvtLawnNGardenSubsystemStopWatering=@"sublawnngarden:StopWatering";

NSString *const kEvtLawnNGardenSubsystemSkipWatering=@"sublawnngarden:SkipWatering";

NSString *const kEvtLawnNGardenSubsystemUpdateSchedule=@"sublawnngarden:UpdateSchedule";

NSString *const kEvtLawnNGardenSubsystemApplyScheduleToDevice=@"sublawnngarden:ApplyScheduleToDevice";

NSString *const kEvtLawnNGardenSubsystemApplyScheduleToDeviceFailed=@"sublawnngarden:ApplyScheduleToDeviceFailed";



@implementation LawnNGardenSubsystemCapability
+ (NSString *)namespace { return @"sublawnngarden"; }
+ (NSString *)name { return @"LawnNGardenSubsystem"; }

+ (NSArray *)getControllersFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getControllers:modelObj];
  
}


+ (NSDictionary *)getScheduleStatusFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getScheduleStatus:modelObj];
  
}


+ (NSDictionary *)getOddSchedulesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getOddSchedules:modelObj];
  
}


+ (NSDictionary *)getEvenSchedulesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getEvenSchedules:modelObj];
  
}


+ (NSDictionary *)getWeeklySchedulesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getWeeklySchedules:modelObj];
  
}


+ (NSDictionary *)getIntervalSchedulesFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getIntervalSchedules:modelObj];
  
}


+ (id)getNextEventFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getNextEvent:modelObj];
  
}


+ (NSDictionary *)getZonesWateringFromModel:(SubsystemModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LawnNGardenSubsystemCapabilityLegacy getZonesWatering:modelObj];
  
}




+ (PMKPromise *) stopWateringWithController:(NSString *)controller withCurrentOnly:(BOOL)currentOnly onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy stopWatering:modelObj controller:controller currentOnly:currentOnly];

}


+ (PMKPromise *) switchScheduleModeWithController:(NSString *)controller withMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy switchScheduleMode:modelObj controller:controller mode:mode];

}


+ (PMKPromise *) enableSchedulingWithController:(NSString *)controller onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy enableScheduling:modelObj controller:controller];

}


+ (PMKPromise *) disableSchedulingWithController:(NSString *)controller onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy disableScheduling:modelObj controller:controller];

}


+ (PMKPromise *) skipWithController:(NSString *)controller withHours:(int)hours onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy skip:modelObj controller:controller hours:hours];

}


+ (PMKPromise *) cancelSkipWithController:(NSString *)controller onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy cancelSkip:modelObj controller:controller];

}


+ (PMKPromise *) configureIntervalScheduleWithController:(NSString *)controller withStartTime:(double)startTime withDays:(int)days onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy configureIntervalSchedule:modelObj controller:controller startTime:startTime days:days];

}


+ (PMKPromise *) createWeeklyEventWithController:(NSString *)controller withDays:(NSArray *)days withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy createWeeklyEvent:modelObj controller:controller days:days timeOfDay:timeOfDay zoneDurations:zoneDurations];

}


+ (PMKPromise *) updateWeeklyEventWithController:(NSString *)controller withEventId:(NSString *)eventId withDays:(NSArray *)days withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations withDay:(NSString *)day onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy updateWeeklyEvent:modelObj controller:controller eventId:eventId days:days timeOfDay:timeOfDay zoneDurations:zoneDurations day:day];

}


+ (PMKPromise *) removeWeeklyEventWithController:(NSString *)controller withEventId:(NSString *)eventId withDay:(NSString *)day onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy removeWeeklyEvent:modelObj controller:controller eventId:eventId day:day];

}


+ (PMKPromise *) createScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy createScheduleEvent:modelObj controller:controller mode:mode timeOfDay:timeOfDay zoneDurations:zoneDurations];

}


+ (PMKPromise *) updateScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId withTimeOfDay:(NSString *)timeOfDay withZoneDurations:(NSArray *)zoneDurations onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy updateScheduleEvent:modelObj controller:controller mode:mode eventId:eventId timeOfDay:timeOfDay zoneDurations:zoneDurations];

}


+ (PMKPromise *) removeScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy removeScheduleEvent:modelObj controller:controller mode:mode eventId:eventId];

}


+ (PMKPromise *) syncScheduleWithController:(NSString *)controller withMode:(NSString *)mode onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy syncSchedule:modelObj controller:controller mode:mode];

}


+ (PMKPromise *) syncScheduleEventWithController:(NSString *)controller withMode:(NSString *)mode withEventId:(NSString *)eventId onModel:(SubsystemModel *)modelObj {
  return [LawnNGardenSubsystemCapabilityLegacy syncScheduleEvent:modelObj controller:controller mode:mode eventId:eventId];

}

@end
