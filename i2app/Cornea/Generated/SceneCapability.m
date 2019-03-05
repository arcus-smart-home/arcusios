

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SceneCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSceneName=@"scene:name";

NSString *const kAttrSceneCreated=@"scene:created";

NSString *const kAttrSceneModified=@"scene:modified";

NSString *const kAttrSceneTemplate=@"scene:template";

NSString *const kAttrSceneEnabled=@"scene:enabled";

NSString *const kAttrSceneNotification=@"scene:notification";

NSString *const kAttrSceneScheduler=@"scene:scheduler";

NSString *const kAttrSceneFiring=@"scene:firing";

NSString *const kAttrSceneActions=@"scene:actions";

NSString *const kAttrSceneLastFireTime=@"scene:lastFireTime";

NSString *const kAttrSceneLastFireStatus=@"scene:lastFireStatus";


NSString *const kCmdSceneFire=@"scene:Fire";

NSString *const kCmdSceneDelete=@"scene:Delete";


NSString *const kEnumSceneLastFireStatusNOTRUN = @"NOTRUN";
NSString *const kEnumSceneLastFireStatusSUCCESS = @"SUCCESS";
NSString *const kEnumSceneLastFireStatusFAILURE = @"FAILURE";
NSString *const kEnumSceneLastFireStatusPARTIAL = @"PARTIAL";


@implementation SceneCapability
+ (NSString *)namespace { return @"scene"; }
+ (NSString *)name { return @"Scene"; }

+ (NSString *)getNameFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(SceneModel *)modelObj {
  [SceneCapabilityLegacy setName:name model:modelObj];
  
  return [SceneCapabilityLegacy getName:modelObj];
  
}


+ (NSDate *)getCreatedFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getModified:modelObj];
  
}


+ (NSString *)getTemplateFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getTemplate:modelObj];
  
}


+ (BOOL)getEnabledFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SceneCapabilityLegacy getEnabled:modelObj] boolValue];
  
}


+ (BOOL)getNotificationFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SceneCapabilityLegacy getNotification:modelObj] boolValue];
  
}

+ (BOOL)setNotification:(BOOL)notification onModel:(SceneModel *)modelObj {
  [SceneCapabilityLegacy setNotification:notification model:modelObj];
  
  return [[SceneCapabilityLegacy getNotification:modelObj] boolValue];
  
}


+ (NSString *)getSchedulerFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getScheduler:modelObj];
  
}


+ (BOOL)getFiringFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SceneCapabilityLegacy getFiring:modelObj] boolValue];
  
}


+ (NSArray *)getActionsFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getActions:modelObj];
  
}

+ (NSArray *)setActions:(NSArray *)actions onModel:(SceneModel *)modelObj {
  [SceneCapabilityLegacy setActions:actions model:modelObj];
  
  return [SceneCapabilityLegacy getActions:modelObj];
  
}


+ (NSDate *)getLastFireTimeFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getLastFireTime:modelObj];
  
}


+ (NSString *)getLastFireStatusFromModel:(SceneModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneCapabilityLegacy getLastFireStatus:modelObj];
  
}




+ (PMKPromise *) fireOnModel:(SceneModel *)modelObj {
  return [SceneCapabilityLegacy fire:modelObj ];
}


+ (PMKPromise *) deleteOnModel:(SceneModel *)modelObj {
  return [SceneCapabilityLegacy delete:modelObj ];
}

@end
