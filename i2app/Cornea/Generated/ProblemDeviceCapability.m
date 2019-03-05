

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProblemDeviceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrProblemDeviceCreated=@"suppprobdev:created";

NSString *const kAttrProblemDeviceId=@"suppprobdev:id";

NSString *const kAttrProblemDeviceDeviceModel=@"suppprobdev:deviceModel";

NSString *const kAttrProblemDeviceMfg=@"suppprobdev:mfg";

NSString *const kAttrProblemDeviceDeviceType=@"suppprobdev:deviceType";


NSString *const kCmdProblemDeviceAddProblemDevices=@"suppprobdev:AddProblemDevices";

NSString *const kCmdProblemDeviceListProblemDevicesForTimeframe=@"suppprobdev:ListProblemDevicesForTimeframe";




@implementation ProblemDeviceCapability
+ (NSString *)namespace { return @"suppprobdev"; }
+ (NSString *)name { return @"ProblemDevice"; }

+ (NSDate *)getCreatedFromModel:(ProblemDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProblemDeviceCapabilityLegacy getCreated:modelObj];
  
}


+ (NSString *)getIdFromModel:(ProblemDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProblemDeviceCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getDeviceModelFromModel:(ProblemDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProblemDeviceCapabilityLegacy getDeviceModel:modelObj];
  
}


+ (NSString *)getMfgFromModel:(ProblemDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProblemDeviceCapabilityLegacy getMfg:modelObj];
  
}


+ (NSString *)getDeviceTypeFromModel:(ProblemDeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProblemDeviceCapabilityLegacy getDeviceType:modelObj];
  
}




+ (PMKPromise *) addProblemDevicesWithModels:(NSArray *)models onModel:(ProblemDeviceModel *)modelObj {
  return [ProblemDeviceCapabilityLegacy addProblemDevices:modelObj models:models];

}


+ (PMKPromise *) listProblemDevicesForTimeframeWithDeviceModel:(NSString *)deviceModel withMfg:(NSString *)mfg withDeviceType:(NSString *)deviceType withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(ProblemDeviceModel *)modelObj {
  return [ProblemDeviceCapabilityLegacy listProblemDevicesForTimeframe:modelObj deviceModel:deviceModel mfg:mfg deviceType:deviceType startDate:startDate endDate:endDate token:token limit:limit];

}

@end
