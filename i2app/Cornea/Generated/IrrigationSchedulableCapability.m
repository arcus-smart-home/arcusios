

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "IrrigationSchedulableCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrIrrigationSchedulableRefreshSchedule=@"irrsched:refreshSchedule";


NSString *const kCmdIrrigationSchedulableEnableSchedule=@"irrsched:EnableSchedule";

NSString *const kCmdIrrigationSchedulableDisableSchedule=@"irrsched:DisableSchedule";

NSString *const kCmdIrrigationSchedulableClearEvenOddSchedule=@"irrsched:ClearEvenOddSchedule";

NSString *const kCmdIrrigationSchedulableSetEvenOddSchedule=@"irrsched:SetEvenOddSchedule";

NSString *const kCmdIrrigationSchedulableClearIntervalSchedule=@"irrsched:ClearIntervalSchedule";

NSString *const kCmdIrrigationSchedulableSetIntervalSchedule=@"irrsched:SetIntervalSchedule";

NSString *const kCmdIrrigationSchedulableSetIntervalStart=@"irrsched:SetIntervalStart";

NSString *const kCmdIrrigationSchedulableClearWeeklySchedule=@"irrsched:ClearWeeklySchedule";

NSString *const kCmdIrrigationSchedulableSetWeeklySchedule=@"irrsched:SetWeeklySchedule";


NSString *const kEvtIrrigationSchedulableScheduleEnabled=@"irrsched:ScheduleEnabled";

NSString *const kEvtIrrigationSchedulableScheduleApplied=@"irrsched:ScheduleApplied";

NSString *const kEvtIrrigationSchedulableScheduleCleared=@"irrsched:ScheduleCleared";

NSString *const kEvtIrrigationSchedulableScheduleFailed=@"irrsched:ScheduleFailed";

NSString *const kEvtIrrigationSchedulableScheduleClearFailed=@"irrsched:ScheduleClearFailed";

NSString *const kEvtIrrigationSchedulableSetIntervalStartSucceeded=@"irrsched:SetIntervalStartSucceeded";

NSString *const kEvtIrrigationSchedulableSetIntervalStartFailed=@"irrsched:SetIntervalStartFailed";



@implementation IrrigationSchedulableCapability
+ (NSString *)namespace { return @"irrsched"; }
+ (NSString *)name { return @"IrrigationSchedulable"; }

+ (BOOL)getRefreshScheduleFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[IrrigationSchedulableCapabilityLegacy getRefreshSchedule:modelObj] boolValue];
  
}

+ (BOOL)setRefreshSchedule:(BOOL)refreshSchedule onModel:(DeviceModel *)modelObj {
  [IrrigationSchedulableCapabilityLegacy setRefreshSchedule:refreshSchedule model:modelObj];
  
  return [[IrrigationSchedulableCapabilityLegacy getRefreshSchedule:modelObj] boolValue];
  
}




+ (PMKPromise *) enableScheduleOnModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy enableSchedule:modelObj ];
}


+ (PMKPromise *) disableScheduleWithDuration:(int)duration onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy disableSchedule:modelObj duration:duration];

}


+ (PMKPromise *) clearEvenOddScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy clearEvenOddSchedule:modelObj zone:zone opId:opId];

}


+ (PMKPromise *) setEvenOddScheduleWithZone:(NSString *)zone withEven:(BOOL)even withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy setEvenOddSchedule:modelObj zone:zone even:even transitions:transitions opId:opId];

}


+ (PMKPromise *) clearIntervalScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy clearIntervalSchedule:modelObj zone:zone opId:opId];

}


+ (PMKPromise *) setIntervalScheduleWithZone:(NSString *)zone withDays:(int)days withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy setIntervalSchedule:modelObj zone:zone days:days transitions:transitions opId:opId];

}


+ (PMKPromise *) setIntervalStartWithZone:(NSString *)zone withStartDate:(double)startDate withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy setIntervalStart:modelObj zone:zone startDate:startDate opId:opId];

}


+ (PMKPromise *) clearWeeklyScheduleWithZone:(NSString *)zone withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy clearWeeklySchedule:modelObj zone:zone opId:opId];

}


+ (PMKPromise *) setWeeklyScheduleWithZone:(NSString *)zone withDays:(NSArray *)days withTransitions:(NSArray *)transitions withOpId:(NSString *)opId onModel:(DeviceModel *)modelObj {
  return [IrrigationSchedulableCapabilityLegacy setWeeklySchedule:modelObj zone:zone days:days transitions:transitions opId:opId];

}

@end
