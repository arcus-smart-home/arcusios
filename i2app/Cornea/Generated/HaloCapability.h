

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;





/** Current state of Halo device. */
extern NSString *const kAttrHaloDevicestate;

/** Current status of Hush process. */
extern NSString *const kAttrHaloHushstatus;

/** This is the room type description for the location of the Halo device, which can be read out in an alert. */
extern NSString *const kAttrHaloRoom;

/** Mapping of halo:room enum keys to human readable room names supported by this device */
extern NSString *const kAttrHaloRoomNames;

/** Response code from remote test of the halo test feature. */
extern NSString *const kAttrHaloRemotetestresult;

/** State of the Arcus system, as transmited to Halo to be indicated to the user through lights and sound. */
extern NSString *const kAttrHaloHaloalertstate;


extern NSString *const kCmdHaloStartHush;

extern NSString *const kCmdHaloSendHush;

extern NSString *const kCmdHaloCancelHush;

extern NSString *const kCmdHaloStartTest;


extern NSString *const kEnumHaloDevicestateSAFE;
extern NSString *const kEnumHaloDevicestateWEATHER;
extern NSString *const kEnumHaloDevicestateSMOKE;
extern NSString *const kEnumHaloDevicestateCO;
extern NSString *const kEnumHaloDevicestatePRE_SMOKE;
extern NSString *const kEnumHaloDevicestateEOL;
extern NSString *const kEnumHaloDevicestateLOW_BATTERY;
extern NSString *const kEnumHaloDevicestateVERY_LOW_BATTERY;
extern NSString *const kEnumHaloDevicestateFAILED_BATTERY;
extern NSString *const kEnumHaloHushstatusSUCCESS;
extern NSString *const kEnumHaloHushstatusTIMEOUT;
extern NSString *const kEnumHaloHushstatusREADY;
extern NSString *const kEnumHaloHushstatusDISABLED;
extern NSString *const kEnumHaloRoomNONE;
extern NSString *const kEnumHaloRoomBASEMENT;
extern NSString *const kEnumHaloRoomBEDROOM;
extern NSString *const kEnumHaloRoomDEN;
extern NSString *const kEnumHaloRoomDINING_ROOM;
extern NSString *const kEnumHaloRoomDOWNSTAIRS;
extern NSString *const kEnumHaloRoomENTRYWAY;
extern NSString *const kEnumHaloRoomFAMILY_ROOM;
extern NSString *const kEnumHaloRoomGAME_ROOM;
extern NSString *const kEnumHaloRoomGUEST_BEDROOM;
extern NSString *const kEnumHaloRoomHALLWAY;
extern NSString *const kEnumHaloRoomKIDS_BEDROOM;
extern NSString *const kEnumHaloRoomLIVING_ROOM;
extern NSString *const kEnumHaloRoomMASTER_BEDROOM;
extern NSString *const kEnumHaloRoomOFFICE;
extern NSString *const kEnumHaloRoomSTUDY;
extern NSString *const kEnumHaloRoomUPSTAIRS;
extern NSString *const kEnumHaloRoomWORKOUT_ROOM;
extern NSString *const kEnumHaloRemotetestresultSUCCESS;
extern NSString *const kEnumHaloRemotetestresultFAIL_ION_SENSOR;
extern NSString *const kEnumHaloRemotetestresultFAIL_PHOTO_SENSOR;
extern NSString *const kEnumHaloRemotetestresultFAIL_CO_SENSOR;
extern NSString *const kEnumHaloRemotetestresultFAIL_TEMP_SENSOR;
extern NSString *const kEnumHaloRemotetestresultFAIL_WEATHER_RADIO;
extern NSString *const kEnumHaloRemotetestresultFAIL_OTHER;
extern NSString *const kEnumHaloHaloalertstateQUIET;
extern NSString *const kEnumHaloHaloalertstateINTRUDER;
extern NSString *const kEnumHaloHaloalertstatePANIC;
extern NSString *const kEnumHaloHaloalertstateWATER;
extern NSString *const kEnumHaloHaloalertstateSMOKE;
extern NSString *const kEnumHaloHaloalertstateCO;
extern NSString *const kEnumHaloHaloalertstateCARE;
extern NSString *const kEnumHaloHaloalertstateALERTING_GENERIC;


@interface HaloCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getDevicestateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getHushstatusFromModel:(DeviceModel *)modelObj;


+ (NSString *)getRoomFromModel:(DeviceModel *)modelObj;

+ (NSString *)setRoom:(NSString *)room onModel:(DeviceModel *)modelObj;


+ (NSDictionary *)getRoomNamesFromModel:(DeviceModel *)modelObj;


+ (NSString *)getRemotetestresultFromModel:(DeviceModel *)modelObj;


+ (NSString *)getHaloalertstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setHaloalertstate:(NSString *)haloalertstate onModel:(DeviceModel *)modelObj;





/** Start a new hush process (assumes device is in pre-alert state). */
+ (PMKPromise *) startHushOnModel:(Model *)modelObj;



/** Send when user says Halo is flashing a particular color. */
+ (PMKPromise *) sendHushWithColor:(NSString *)color onModel:(Model *)modelObj;



/** Cancel out of current hush process. */
+ (PMKPromise *) cancelHushOnModel:(Model *)modelObj;



/** Run test cycle on the Halo. Should be moved to some generic capability. */
+ (PMKPromise *) startTestOnModel:(Model *)modelObj;



@end
