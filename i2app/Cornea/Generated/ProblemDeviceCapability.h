

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ProblemDeviceModel;







/** The date the problem device was added to the db */
extern NSString *const kAttrProblemDeviceCreated;

/** device id */
extern NSString *const kAttrProblemDeviceId;

/** specific model of the device */
extern NSString *const kAttrProblemDeviceDeviceModel;

/** manufacturer name of the device */
extern NSString *const kAttrProblemDeviceMfg;

/** generic type of the device */
extern NSString *const kAttrProblemDeviceDeviceType;


extern NSString *const kCmdProblemDeviceAddProblemDevices;

extern NSString *const kCmdProblemDeviceListProblemDevicesForTimeframe;




@interface ProblemDeviceCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getCreatedFromModel:(ProblemDeviceModel *)modelObj;


+ (NSString *)getIdFromModel:(ProblemDeviceModel *)modelObj;


+ (NSString *)getDeviceModelFromModel:(ProblemDeviceModel *)modelObj;


+ (NSString *)getMfgFromModel:(ProblemDeviceModel *)modelObj;


+ (NSString *)getDeviceTypeFromModel:(ProblemDeviceModel *)modelObj;





/** Add device(s) having a problem to the db. Normally taken care of by the end session call. */
+ (PMKPromise *) addProblemDevicesWithModels:(NSArray *)models onModel:(Model *)modelObj;



/** Lists problem devices within a time range across accounts and places */
+ (PMKPromise *) listProblemDevicesForTimeframeWithDeviceModel:(NSString *)deviceModel withMfg:(NSString *)mfg withDeviceType:(NSString *)deviceType withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withToken:(NSString *)token withLimit:(int)limit onModel:(Model *)modelObj;



@end
