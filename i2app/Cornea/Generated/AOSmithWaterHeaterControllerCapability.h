

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The rate in seconds of how often the water heater polls the platform. */
extern NSString *const kAttrAOSmithWaterHeaterControllerUpdaterate;

/** The display unit of the temperation. */
extern NSString *const kAttrAOSmithWaterHeaterControllerUnits;

/** This is the mode setting of the device, not whether or not it is actually heating the water at the moment. */
extern NSString *const kAttrAOSmithWaterHeaterControllerControlmode;

/** Enable or disable leak detection. Or report that no sensor is present and force to disabled. */
extern NSString *const kAttrAOSmithWaterHeaterControllerLeakdetect;

/** Water conductivity detected on probes. */
extern NSString *const kAttrAOSmithWaterHeaterControllerLeak;

/** This device was originally destined for utilities, so if the grid is controlling your device, it means you are responding to commands over Wifi. */
extern NSString *const kAttrAOSmithWaterHeaterControllerGridenabled;

/** Detects that a dry-fire condition was present */
extern NSString *const kAttrAOSmithWaterHeaterControllerDryfire;

/** Status of upper and lower elements */
extern NSString *const kAttrAOSmithWaterHeaterControllerElementfail;

/** Status of uppwer and lower temperature sensors. */
extern NSString *const kAttrAOSmithWaterHeaterControllerTanksensorfail;

/** Mechanical tank over temperature sensor. */
extern NSString *const kAttrAOSmithWaterHeaterControllerEcoerror;

/** Master (ET) and Display (ESM) self-test status */
extern NSString *const kAttrAOSmithWaterHeaterControllerMasterdispfail;

/** Contains a map of device error codes to verbose, user-friendly definitions. */
extern NSString *const kAttrAOSmithWaterHeaterControllerErrors;

/** Model number as recorded on the heater&#x27;s label  */
extern NSString *const kAttrAOSmithWaterHeaterControllerModelnumber;

/** Serial number as recorded on the heater&#x27;s label  */
extern NSString *const kAttrAOSmithWaterHeaterControllerSerialnumber;



extern NSString *const kEnumAOSmithWaterHeaterControllerUnitsC;
extern NSString *const kEnumAOSmithWaterHeaterControllerUnitsF;
extern NSString *const kEnumAOSmithWaterHeaterControllerControlmodeSTANDARD;
extern NSString *const kEnumAOSmithWaterHeaterControllerControlmodeVACATION;
extern NSString *const kEnumAOSmithWaterHeaterControllerControlmodeENERGY_SMART;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectDISABLED;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectENABLED;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakdetectNOTDETECTED;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakNONE;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakDETECTED;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakUNPLUGGED;
extern NSString *const kEnumAOSmithWaterHeaterControllerLeakERROR;
extern NSString *const kEnumAOSmithWaterHeaterControllerElementfailNONE;
extern NSString *const kEnumAOSmithWaterHeaterControllerElementfailUPPER;
extern NSString *const kEnumAOSmithWaterHeaterControllerElementfailLOWER;
extern NSString *const kEnumAOSmithWaterHeaterControllerElementfailUPPER_LOWER;
extern NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailNONE;
extern NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailUPPER;
extern NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailLOWER;
extern NSString *const kEnumAOSmithWaterHeaterControllerTanksensorfailUPPER_LOWER;
extern NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailNONE;
extern NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailMASTER;
extern NSString *const kEnumAOSmithWaterHeaterControllerMasterdispfailDISPLAY;


@interface AOSmithWaterHeaterControllerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getUpdaterateFromModel:(DeviceModel *)modelObj;

+ (int)setUpdaterate:(int)updaterate onModel:(DeviceModel *)modelObj;


+ (NSString *)getUnitsFromModel:(DeviceModel *)modelObj;

+ (NSString *)setUnits:(NSString *)units onModel:(DeviceModel *)modelObj;


+ (NSString *)getControlmodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setControlmode:(NSString *)controlmode onModel:(DeviceModel *)modelObj;


+ (NSString *)getLeakdetectFromModel:(DeviceModel *)modelObj;

+ (NSString *)setLeakdetect:(NSString *)leakdetect onModel:(DeviceModel *)modelObj;


+ (NSString *)getLeakFromModel:(DeviceModel *)modelObj;


+ (BOOL)getGridenabledFromModel:(DeviceModel *)modelObj;


+ (BOOL)getDryfireFromModel:(DeviceModel *)modelObj;


+ (NSString *)getElementfailFromModel:(DeviceModel *)modelObj;


+ (NSString *)getTanksensorfailFromModel:(DeviceModel *)modelObj;


+ (BOOL)getEcoerrorFromModel:(DeviceModel *)modelObj;


+ (NSString *)getMasterdispfailFromModel:(DeviceModel *)modelObj;


+ (NSDictionary *)getErrorsFromModel:(DeviceModel *)modelObj;


+ (NSString *)getModelnumberFromModel:(DeviceModel *)modelObj;

+ (NSString *)setModelnumber:(NSString *)modelnumber onModel:(DeviceModel *)modelObj;


+ (NSString *)getSerialnumberFromModel:(DeviceModel *)modelObj;

+ (NSString *)setSerialnumber:(NSString *)serialnumber onModel:(DeviceModel *)modelObj;





@end
