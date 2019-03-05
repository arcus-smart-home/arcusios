

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ShadeCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrShadeLevel=@"shade:level";

NSString *const kAttrShadeShadestate=@"shade:shadestate";

NSString *const kAttrShadeLevelchanged=@"shade:levelchanged";


NSString *const kCmdShadeGoToOpen=@"shade:GoToOpen";

NSString *const kCmdShadeGoToClosed=@"shade:GoToClosed";

NSString *const kCmdShadeGoToFavorite=@"shade:GoToFavorite";


NSString *const kEnumShadeShadestateOK = @"OK";
NSString *const kEnumShadeShadestateOBSTRUCTION = @"OBSTRUCTION";


@implementation ShadeCapability
+ (NSString *)namespace { return @"shade"; }
+ (NSString *)name { return @"Shade"; }

+ (int)getLevelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ShadeCapabilityLegacy getLevel:modelObj] intValue];
  
}

+ (int)setLevel:(int)level onModel:(DeviceModel *)modelObj {
  [ShadeCapabilityLegacy setLevel:level model:modelObj];
  
  return [[ShadeCapabilityLegacy getLevel:modelObj] intValue];
  
}


+ (NSString *)getShadestateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ShadeCapabilityLegacy getShadestate:modelObj];
  
}


+ (NSDate *)getLevelchangedFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ShadeCapabilityLegacy getLevelchanged:modelObj];
  
}




+ (PMKPromise *) goToOpenOnModel:(DeviceModel *)modelObj {
  return [ShadeCapabilityLegacy goToOpen:modelObj ];
}


+ (PMKPromise *) goToClosedOnModel:(DeviceModel *)modelObj {
  return [ShadeCapabilityLegacy goToClosed:modelObj ];
}


+ (PMKPromise *) goToFavoriteOnModel:(DeviceModel *)modelObj {
  return [ShadeCapabilityLegacy goToFavorite:modelObj ];
}

@end
