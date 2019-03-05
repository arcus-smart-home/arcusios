

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Recharge status of the water softener:  READY (providing soft water), RECHARGING (actively regenerating), RECHARGE_SCHEDULED (recharge required and will be done at rechargeStartTime) */
extern NSString *const kAttrWaterSoftenerRechargeStatus;

/** Current salt level from 0 (empty) to maxSaltLevel */
extern NSString *const kAttrWaterSoftenerCurrentSaltLevel;

/** Max salt level for this softener */
extern NSString *const kAttrWaterSoftenerMaxSaltLevel;

/** true indicates currentSaltLevel should be accurate - false indicates currentSaltLevel should be ignored */
extern NSString *const kAttrWaterSoftenerSaltLevelEnabled;

/** When regeneration is needed, hour of the day when it should be scheduled (e.g. 14 = 2:00 PM). Does not guarantee that regeneration will occur daily. */
extern NSString *const kAttrWaterSoftenerRechargeStartTime;

/** The number of minutes left before the softener completes its recharge cycle. */
extern NSString *const kAttrWaterSoftenerRechargeTimeRemaining;

/** The number of consecutive days the softener has been powered on */
extern NSString *const kAttrWaterSoftenerDaysPoweredUp;

/** The total number of recharge cycles the softener has performed since being added to the network */
extern NSString *const kAttrWaterSoftenerTotalRecharges;


extern NSString *const kCmdWaterSoftenerRechargeNow;


extern NSString *const kEnumWaterSoftenerRechargeStatusREADY;
extern NSString *const kEnumWaterSoftenerRechargeStatusRECHARGING;
extern NSString *const kEnumWaterSoftenerRechargeStatusRECHARGE_SCHEDULED;


@interface WaterSoftenerCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getRechargeStatusFromModel:(DeviceModel *)modelObj;


+ (int)getCurrentSaltLevelFromModel:(DeviceModel *)modelObj;


+ (int)getMaxSaltLevelFromModel:(DeviceModel *)modelObj;


+ (BOOL)getSaltLevelEnabledFromModel:(DeviceModel *)modelObj;


+ (int)getRechargeStartTimeFromModel:(DeviceModel *)modelObj;

+ (int)setRechargeStartTime:(int)rechargeStartTime onModel:(DeviceModel *)modelObj;


+ (int)getRechargeTimeRemainingFromModel:(DeviceModel *)modelObj;


+ (int)getDaysPoweredUpFromModel:(DeviceModel *)modelObj;


+ (int)getTotalRechargesFromModel:(DeviceModel *)modelObj;





/** Forces a recharge on the water softener. */
+ (PMKPromise *) rechargeNowOnModel:(Model *)modelObj;



@end
