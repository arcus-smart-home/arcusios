

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HaloCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHaloDevicestate=@"halo:devicestate";

NSString *const kAttrHaloHushstatus=@"halo:hushstatus";

NSString *const kAttrHaloRoom=@"halo:room";

NSString *const kAttrHaloRoomNames=@"halo:roomNames";

NSString *const kAttrHaloRemotetestresult=@"halo:remotetestresult";

NSString *const kAttrHaloHaloalertstate=@"halo:haloalertstate";


NSString *const kCmdHaloStartHush=@"halo:StartHush";

NSString *const kCmdHaloSendHush=@"halo:SendHush";

NSString *const kCmdHaloCancelHush=@"halo:CancelHush";

NSString *const kCmdHaloStartTest=@"halo:StartTest";


NSString *const kEnumHaloDevicestateSAFE = @"SAFE";
NSString *const kEnumHaloDevicestateWEATHER = @"WEATHER";
NSString *const kEnumHaloDevicestateSMOKE = @"SMOKE";
NSString *const kEnumHaloDevicestateCO = @"CO";
NSString *const kEnumHaloDevicestatePRE_SMOKE = @"PRE_SMOKE";
NSString *const kEnumHaloDevicestateEOL = @"EOL";
NSString *const kEnumHaloDevicestateLOW_BATTERY = @"LOW_BATTERY";
NSString *const kEnumHaloDevicestateVERY_LOW_BATTERY = @"VERY_LOW_BATTERY";
NSString *const kEnumHaloDevicestateFAILED_BATTERY = @"FAILED_BATTERY";
NSString *const kEnumHaloHushstatusSUCCESS = @"SUCCESS";
NSString *const kEnumHaloHushstatusTIMEOUT = @"TIMEOUT";
NSString *const kEnumHaloHushstatusREADY = @"READY";
NSString *const kEnumHaloHushstatusDISABLED = @"DISABLED";
NSString *const kEnumHaloRoomNONE = @"NONE";
NSString *const kEnumHaloRoomBASEMENT = @"BASEMENT";
NSString *const kEnumHaloRoomBEDROOM = @"BEDROOM";
NSString *const kEnumHaloRoomDEN = @"DEN";
NSString *const kEnumHaloRoomDINING_ROOM = @"DINING_ROOM";
NSString *const kEnumHaloRoomDOWNSTAIRS = @"DOWNSTAIRS";
NSString *const kEnumHaloRoomENTRYWAY = @"ENTRYWAY";
NSString *const kEnumHaloRoomFAMILY_ROOM = @"FAMILY_ROOM";
NSString *const kEnumHaloRoomGAME_ROOM = @"GAME_ROOM";
NSString *const kEnumHaloRoomGUEST_BEDROOM = @"GUEST_BEDROOM";
NSString *const kEnumHaloRoomHALLWAY = @"HALLWAY";
NSString *const kEnumHaloRoomKIDS_BEDROOM = @"KIDS_BEDROOM";
NSString *const kEnumHaloRoomLIVING_ROOM = @"LIVING_ROOM";
NSString *const kEnumHaloRoomMASTER_BEDROOM = @"MASTER_BEDROOM";
NSString *const kEnumHaloRoomOFFICE = @"OFFICE";
NSString *const kEnumHaloRoomSTUDY = @"STUDY";
NSString *const kEnumHaloRoomUPSTAIRS = @"UPSTAIRS";
NSString *const kEnumHaloRoomWORKOUT_ROOM = @"WORKOUT_ROOM";
NSString *const kEnumHaloRemotetestresultSUCCESS = @"SUCCESS";
NSString *const kEnumHaloRemotetestresultFAIL_ION_SENSOR = @"FAIL_ION_SENSOR";
NSString *const kEnumHaloRemotetestresultFAIL_PHOTO_SENSOR = @"FAIL_PHOTO_SENSOR";
NSString *const kEnumHaloRemotetestresultFAIL_CO_SENSOR = @"FAIL_CO_SENSOR";
NSString *const kEnumHaloRemotetestresultFAIL_TEMP_SENSOR = @"FAIL_TEMP_SENSOR";
NSString *const kEnumHaloRemotetestresultFAIL_WEATHER_RADIO = @"FAIL_WEATHER_RADIO";
NSString *const kEnumHaloRemotetestresultFAIL_OTHER = @"FAIL_OTHER";
NSString *const kEnumHaloHaloalertstateQUIET = @"QUIET";
NSString *const kEnumHaloHaloalertstateINTRUDER = @"INTRUDER";
NSString *const kEnumHaloHaloalertstatePANIC = @"PANIC";
NSString *const kEnumHaloHaloalertstateWATER = @"WATER";
NSString *const kEnumHaloHaloalertstateSMOKE = @"SMOKE";
NSString *const kEnumHaloHaloalertstateCO = @"CO";
NSString *const kEnumHaloHaloalertstateCARE = @"CARE";
NSString *const kEnumHaloHaloalertstateALERTING_GENERIC = @"ALERTING_GENERIC";


@implementation HaloCapability
+ (NSString *)namespace { return @"halo"; }
+ (NSString *)name { return @"Halo"; }

+ (NSString *)getDevicestateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getDevicestate:modelObj];
  
}


+ (NSString *)getHushstatusFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getHushstatus:modelObj];
  
}


+ (NSString *)getRoomFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getRoom:modelObj];
  
}

+ (NSString *)setRoom:(NSString *)room onModel:(DeviceModel *)modelObj {
  [HaloCapabilityLegacy setRoom:room model:modelObj];
  
  return [HaloCapabilityLegacy getRoom:modelObj];
  
}


+ (NSDictionary *)getRoomNamesFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getRoomNames:modelObj];
  
}


+ (NSString *)getRemotetestresultFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getRemotetestresult:modelObj];
  
}


+ (NSString *)getHaloalertstateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HaloCapabilityLegacy getHaloalertstate:modelObj];
  
}

+ (NSString *)setHaloalertstate:(NSString *)haloalertstate onModel:(DeviceModel *)modelObj {
  [HaloCapabilityLegacy setHaloalertstate:haloalertstate model:modelObj];
  
  return [HaloCapabilityLegacy getHaloalertstate:modelObj];
  
}




+ (PMKPromise *) startHushOnModel:(DeviceModel *)modelObj {
  return [HaloCapabilityLegacy startHush:modelObj ];
}


+ (PMKPromise *) sendHushWithColor:(NSString *)color onModel:(DeviceModel *)modelObj {
  return [HaloCapabilityLegacy sendHush:modelObj color:color];

}


+ (PMKPromise *) cancelHushOnModel:(DeviceModel *)modelObj {
  return [HaloCapabilityLegacy cancelHush:modelObj ];
}


+ (PMKPromise *) startTestOnModel:(DeviceModel *)modelObj {
  return [HaloCapabilityLegacy startTest:modelObj ];
}

@end
