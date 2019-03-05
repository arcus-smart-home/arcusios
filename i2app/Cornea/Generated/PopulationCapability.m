

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PopulationCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPopulationName=@"population:name";

NSString *const kAttrPopulationDescription=@"population:description";

NSString *const kAttrPopulationIsDefault=@"population:isDefault";


NSString *const kCmdPopulationGetPopulations=@"population:GetPopulations";




@implementation PopulationCapability
+ (NSString *)namespace { return @"population"; }
+ (NSString *)name { return @"Population"; }

+ (NSString *)getNameFromModel:(PopulationModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PopulationCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getDescriptionFromModel:(PopulationModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PopulationCapabilityLegacy getDescription:modelObj];
  
}


+ (BOOL)getIsDefaultFromModel:(PopulationModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PopulationCapabilityLegacy getIsDefault:modelObj] boolValue];
  
}




+ (PMKPromise *) getPopulationsOnModel:(PopulationModel *)modelObj {
  return [PopulationCapabilityLegacy getPopulations:modelObj ];
}

@end
