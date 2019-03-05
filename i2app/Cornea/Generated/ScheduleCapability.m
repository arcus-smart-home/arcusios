

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ScheduleCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrScheduleGroup=@"sched:group";

NSString *const kAttrScheduleEnabled=@"sched:enabled";

NSString *const kAttrScheduleNextFireTime=@"sched:nextFireTime";

NSString *const kAttrScheduleNextFireCommand=@"sched:nextFireCommand";

NSString *const kAttrScheduleLastFireTime=@"sched:lastFireTime";

NSString *const kAttrScheduleLastFireCommand=@"sched:lastFireCommand";

NSString *const kAttrScheduleLastFireMessageType=@"sched:lastFireMessageType";

NSString *const kAttrScheduleLastFireAttributes=@"sched:lastFireAttributes";


NSString *const kCmdScheduleDelete=@"sched:Delete";

NSString *const kCmdScheduleDeleteCommand=@"sched:DeleteCommand";




@implementation ScheduleCapability
+ (NSString *)namespace { return @"sched"; }
+ (NSString *)name { return @"Schedule"; }

+ (NSString *)getGroupFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getGroup:modelObj];
  
}


+ (BOOL)getEnabledFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ScheduleCapabilityLegacy getEnabled:modelObj] boolValue];
  
}

+ (BOOL)setEnabled:(BOOL)enabled onModel:(ScheduleModel *)modelObj {
  [ScheduleCapabilityLegacy setEnabled:enabled model:modelObj];
  
  return [[ScheduleCapabilityLegacy getEnabled:modelObj] boolValue];
  
}


+ (NSDate *)getNextFireTimeFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getNextFireTime:modelObj];
  
}


+ (NSString *)getNextFireCommandFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getNextFireCommand:modelObj];
  
}


+ (NSDate *)getLastFireTimeFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getLastFireTime:modelObj];
  
}


+ (NSString *)getLastFireCommandFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getLastFireCommand:modelObj];
  
}


+ (NSString *)getLastFireMessageTypeFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getLastFireMessageType:modelObj];
  
}


+ (NSDictionary *)getLastFireAttributesFromModel:(ScheduleModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ScheduleCapabilityLegacy getLastFireAttributes:modelObj];
  
}




+ (PMKPromise *) deleteOnModel:(ScheduleModel *)modelObj {
  return [ScheduleCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) deleteCommandWithCommandId:(NSString *)commandId onModel:(ScheduleModel *)modelObj {
  return [ScheduleCapabilityLegacy deleteCommand:modelObj commandId:commandId];

}

@end
