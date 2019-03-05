

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the valve. Obstruction implying that something is preventing the opening or closing of the valve. May also be used to set the state of the valve. */
extern NSString *const kAttrValveValvestate;

/** UTC date time of last valve state change */
extern NSString *const kAttrValveValvestatechanged;



extern NSString *const kEnumValveValvestateCLOSED;
extern NSString *const kEnumValveValvestateOPEN;
extern NSString *const kEnumValveValvestateOPENING;
extern NSString *const kEnumValveValvestateCLOSING;
extern NSString *const kEnumValveValvestateOBSTRUCTION;


@interface ValveCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getValvestateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setValvestate:(NSString *)valvestate onModel:(DeviceModel *)modelObj;


+ (NSDate *)getValvestatechangedFromModel:(DeviceModel *)modelObj;





@end
