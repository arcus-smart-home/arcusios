

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Current door state, and if written, desired door state. */
extern NSString *const kAttrMotorizedDoorDoorstate;

/** % open. 0 is closed, 100 is open.  Some doors do support reporting what level they are currently at, and some support a requested door level to leave a garage door at partial open. */
extern NSString *const kAttrMotorizedDoorDoorlevel;

/** UTC date time of last doorstate change */
extern NSString *const kAttrMotorizedDoorDoorstatechanged;



extern NSString *const kEnumMotorizedDoorDoorstateCLOSED;
extern NSString *const kEnumMotorizedDoorDoorstateCLOSING;
extern NSString *const kEnumMotorizedDoorDoorstateOBSTRUCTION;
extern NSString *const kEnumMotorizedDoorDoorstateOPENING;
extern NSString *const kEnumMotorizedDoorDoorstateOPEN;


@interface MotorizedDoorCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getDoorstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setDoorstate:(NSString *)doorstate onModel:(DeviceModel *)modelObj;


+ (int)getDoorlevelFromModel:(DeviceModel *)modelObj;

+ (int)setDoorlevel:(int)doorlevel onModel:(DeviceModel *)modelObj;


+ (NSDate *)getDoorstatechangedFromModel:(DeviceModel *)modelObj;





@end
