

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "SceneService.h"
#import <i2app-Swift.h>

@implementation SceneService
+ (NSString *)name { return @"SceneService"; }
+ (NSString *)address { return @"SERV:scene:"; }


+ (PMKPromise *) listScenesWithPlaceId:(NSString *)placeId {
  return [SceneServiceLegacy listScenes:placeId];

}


+ (PMKPromise *) listSceneTemplatesWithPlaceId:(NSString *)placeId {
  return [SceneServiceLegacy listSceneTemplates:placeId];

}

@end
