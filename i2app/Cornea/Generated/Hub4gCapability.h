

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;







/** True if a 4G dongle is installed on the hub */
extern NSString *const kAttrHub4gPresent;

/** True if the installed 4G dongle has a sim card present */
extern NSString *const kAttrHub4gSimPresent;

/** True if the installed 4G sim card has been provisioned */
extern NSString *const kAttrHub4gSimProvisioned;

/** True if the installed 4G sim card has been marked invalid */
extern NSString *const kAttrHub4gSimDisabled;

/** Date when 4G sim card was disabled, if any */
extern NSString *const kAttrHub4gSimDisabledDate;

/** Current state of 4g connection */
extern NSString *const kAttrHub4gConnectionState;

/** String description of the 4G dongle vendor */
extern NSString *const kAttrHub4gVendor;

/** String description of the 4G dongle model */
extern NSString *const kAttrHub4gModel;

/** Serial number of 4G dongle */
extern NSString *const kAttrHub4gSerialNumber;

/** IMEI of 4G dongle */
extern NSString *const kAttrHub4gImei;

/** IMSI of 4G dongle */
extern NSString *const kAttrHub4gImsi;

/** ICCID of 4G dongle */
extern NSString *const kAttrHub4gIccid;

/** Phone number of 4G dongle */
extern NSString *const kAttrHub4gPhoneNumber;

/** Network connection mode */
extern NSString *const kAttrHub4gMode;

/** Signal strength in bars */
extern NSString *const kAttrHub4gSignalBars;

/** Vendor specific connection status code */
extern NSString *const kAttrHub4gConnectionStatus;


extern NSString *const kCmdHub4gGetInfo;

extern NSString *const kCmdHub4gResetStatistics;

extern NSString *const kCmdHub4gGetStatistics;


extern NSString *const kEnumHub4gConnectionStateCONNECTING;
extern NSString *const kEnumHub4gConnectionStateCONNECTED;
extern NSString *const kEnumHub4gConnectionStateDISCONNECTING;
extern NSString *const kEnumHub4gConnectionStateDISCONNECTED;


@interface Hub4gCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getPresentFromModel:(HubModel *)modelObj;


+ (BOOL)getSimPresentFromModel:(HubModel *)modelObj;


+ (BOOL)getSimProvisionedFromModel:(HubModel *)modelObj;


+ (BOOL)getSimDisabledFromModel:(HubModel *)modelObj;


+ (NSDate *)getSimDisabledDateFromModel:(HubModel *)modelObj;


+ (NSString *)getConnectionStateFromModel:(HubModel *)modelObj;


+ (NSString *)getVendorFromModel:(HubModel *)modelObj;


+ (NSString *)getModelFromModel:(HubModel *)modelObj;


+ (NSString *)getSerialNumberFromModel:(HubModel *)modelObj;


+ (NSString *)getImeiFromModel:(HubModel *)modelObj;


+ (NSString *)getImsiFromModel:(HubModel *)modelObj;


+ (NSString *)getIccidFromModel:(HubModel *)modelObj;


+ (NSString *)getPhoneNumberFromModel:(HubModel *)modelObj;


+ (NSString *)getModeFromModel:(HubModel *)modelObj;


+ (int)getSignalBarsFromModel:(HubModel *)modelObj;


+ (NSString *)getConnectionStatusFromModel:(HubModel *)modelObj;





/** Get 4G dongle information */
+ (PMKPromise *) getInfoOnModel:(Model *)modelObj;



/** Reset 4g connection statistics */
+ (PMKPromise *) resetStatisticsOnModel:(Model *)modelObj;



/** Get 4g connection statistics */
+ (PMKPromise *) getStatisticsOnModel:(Model *)modelObj;



@end
