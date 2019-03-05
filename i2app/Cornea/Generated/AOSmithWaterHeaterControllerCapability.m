

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AOSmithWaterHeaterControllerCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrAOSmithWaterHeaterControllerUpdaterate=@"aosmithwaterheatercontroller:updaterate";

NSString *const kAttrAOSmithWaterHeaterControllerUnits=@"aosmithwaterheatercontroller:units";

NSString *const kAttrAOSmithWaterHeaterControllerControlmode=@"aosmithwaterheatercontroller:controlmode";

NSString *const kAttrAOSmithWaterHeaterControllerLeakdetect=@"aosmithwaterheatercontroller:leakdetect";

NSString *const kAttrAOSmithWaterHeaterControllerLeak=@"aosmithwaterheatercontroller:leak";

NSString *const kAttrAOSmithWaterHeaterControllerGridenabled=@"aosmithwaterheatercontroller:gridenabled";

NSString *const kAttrAOSmithWaterHeaterControllerDryfire=@"aosmithwaterheatercontroller:dryfire";

NSString *const kAttrAOSmithWaterHeaterControllerElementfail=@"aosmithwaterheatercontroller:elementfail";

NSString *const kAttrAOSmithWaterHeaterControllerTanksensorfail=@"aosmithwaterheatercontroller:tanksensorfail";

NSString *const kAttrAOSmithWaterHeaterControllerEcoerror=@"aosmithwaterheatercontroller:ecoerror";

NSString *const kAttrAOSmithWaterHeaterControllerMasterdispfail=@"aosmithwaterheatercontroller:masterdispfail";

NSString *const kAttrAOSmithWaterHeaterControllerErrors=@"aosmithwaterheatercontroller:errors";

NSString *const kAttrAOSmithWaterHeaterControllerModelnumber=@"aosmithwaterheatercontroller:modelnumber";

NSString *const kAttrAOSmithWaterHeaterControllerSerialnumber=@"aosmithwaterheatercontroller:serialnumber";



NSString *const kEnumAOSmithWaterHeaterControllerUnitsC = @"C";
NSString *const kEnumAOSmithWaterHeaterControllerUnitsF = @"F";
NSString *const kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD = @"STANDARD";
NSString *const kEnumAOSmithWaterHeaterControllerControlmodeVACATION = @"VACATION";
NSString *const kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART = @"ENERGY_SMART";
NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectDISABLED = @"DISABLED";
NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectENABLED = @"ENABLED";
NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectNOTDETECTED = @"NOTDETECTED";
NSString *const kEnumAOSmithWaterHeaterControllerLeakNONE = @"NONE";
NSString *const kEnumAOSmithWaterHeaterControllerLeakDETECTED = @"DETECTED";
NSString *const kEnumAOSmithWaterHeaterControllerLeakUNPLUGGED = @"UNPLUGGED";
NSString *const kEnumAOSmithWaterHeaterControllerLeakERROR = @"ERROR";
NSString *const kEnumAOSmithWaterHeaterControllerElementfailNONE = @"NONE";
NSString *const kEnumAOSmithWaterHeaterControllerElementfailUPPER = @"UPPER";
NSString *const kEnumAOSmithWaterHeaterControllerElementfailLOWER = @"LOWER";
NSString *const kEnumAOSmithWaterHeaterControllerElementfailUPPER_LOWER = @"UPPER_LOWER";
NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailNONE = @"NONE";
NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailUPPER = @"UPPER";
NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailLOWER = @"LOWER";
NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailUPPER_LOWER = @"UPPER_LOWER";
NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailNONE = @"NONE";
NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailMASTER = @"MASTER";
NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailDISPLAY = @"DISPLAY";


@implementation AOSmithWaterHeaterControllerCapability
+ (NSString *)namespace { return @"aosmithwaterheatercontroller"; }
+ (NSString *)name { return @"AOSmithWaterHeaterController"; }

+ (int)getUpdaterateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AOSmithWaterHeaterControllerCapabilityLegacy getUpdaterate:modelObj] intValue];
  
}

+ (int)setUpdaterate:(int)updaterate onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setUpdaterate:updaterate model:modelObj];
  
  return [[AOSmithWaterHeaterControllerCapabilityLegacy getUpdaterate:modelObj] intValue];
  
}


+ (NSString *)getUnitsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getUnits:modelObj];
  
}

+ (NSString *)setUnits:(NSString *)units onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setUnits:units model:modelObj];
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getUnits:modelObj];
  
}


+ (NSString *)getControlmodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getControlmode:modelObj];
  
}

+ (NSString *)setControlmode:(NSString *)controlmode onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setControlmode:controlmode model:modelObj];
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getControlmode:modelObj];
  
}


+ (NSString *)getLeakdetectFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getLeakdetect:modelObj];
  
}

+ (NSString *)setLeakdetect:(NSString *)leakdetect onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setLeakdetect:leakdetect model:modelObj];
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getLeakdetect:modelObj];
  
}


+ (NSString *)getLeakFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getLeak:modelObj];
  
}


+ (BOOL)getGridenabledFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AOSmithWaterHeaterControllerCapabilityLegacy getGridenabled:modelObj] boolValue];
  
}


+ (BOOL)getDryfireFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AOSmithWaterHeaterControllerCapabilityLegacy getDryfire:modelObj] boolValue];
  
}


+ (NSString *)getElementfailFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getElementfail:modelObj];
  
}


+ (NSString *)getTanksensorfailFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getTanksensorfail:modelObj];
  
}


+ (BOOL)getEcoerrorFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[AOSmithWaterHeaterControllerCapabilityLegacy getEcoerror:modelObj] boolValue];
  
}


+ (NSString *)getMasterdispfailFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getMasterdispfail:modelObj];
  
}


+ (NSDictionary *)getErrorsFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getErrors:modelObj];
  
}


+ (NSString *)getModelnumberFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getModelnumber:modelObj];
  
}

+ (NSString *)setModelnumber:(NSString *)modelnumber onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setModelnumber:modelnumber model:modelObj];
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getModelnumber:modelObj];
  
}


+ (NSString *)getSerialnumberFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getSerialnumber:modelObj];
  
}

+ (NSString *)setSerialnumber:(NSString *)serialnumber onModel:(DeviceModel *)modelObj {
  [AOSmithWaterHeaterControllerCapabilityLegacy setSerialnumber:serialnumber model:modelObj];
  
  return [AOSmithWaterHeaterControllerCapabilityLegacy getSerialnumber:modelObj];
  
}



@end
