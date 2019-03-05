

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SceneTemplateCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrSceneTemplateAdded=@"scenetmpl:added";

NSString *const kAttrSceneTemplateModified=@"scenetmpl:modified";

NSString *const kAttrSceneTemplateName=@"scenetmpl:name";

NSString *const kAttrSceneTemplateDescription=@"scenetmpl:description";

NSString *const kAttrSceneTemplateCustom=@"scenetmpl:custom";

NSString *const kAttrSceneTemplateAvailable=@"scenetmpl:available";


NSString *const kCmdSceneTemplateCreate=@"scenetmpl:Create";

NSString *const kCmdSceneTemplateResolveActions=@"scenetmpl:ResolveActions";




@implementation SceneTemplateCapability
+ (NSString *)namespace { return @"scenetmpl"; }
+ (NSString *)name { return @"SceneTemplate"; }

+ (NSDate *)getAddedFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneTemplateCapabilityLegacy getAdded:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneTemplateCapabilityLegacy getModified:modelObj];
  
}


+ (NSString *)getNameFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneTemplateCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getDescriptionFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [SceneTemplateCapabilityLegacy getDescription:modelObj];
  
}


+ (BOOL)getCustomFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SceneTemplateCapabilityLegacy getCustom:modelObj] boolValue];
  
}


+ (BOOL)getAvailableFromModel:(SceneTemplateModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[SceneTemplateCapabilityLegacy getAvailable:modelObj] boolValue];
  
}




+ (PMKPromise *) createWithPlaceId:(NSString *)placeId withName:(NSString *)name withActions:(NSArray *)actions onModel:(SceneTemplateModel *)modelObj {
  return [SceneTemplateCapabilityLegacy create:modelObj placeId:placeId name:name actions:actions];

}


+ (PMKPromise *) resolveActionsWithPlaceId:(NSString *)placeId onModel:(SceneTemplateModel *)modelObj {
  return [SceneTemplateCapabilityLegacy resolveActions:modelObj placeId:placeId];

}

@end
