

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the tilt sensor. */
extern NSString *const kAttrTiltTiltstate;

/** UTC date time of last tilt state change */
extern NSString *const kAttrTiltTiltstatechanged;



extern NSString *const kEnumTiltTiltstateFLAT;
extern NSString *const kEnumTiltTiltstateUPRIGHT;


@interface TiltCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTiltstateFromModel:(DeviceModel *)modelObj;

+ (NSString *)setTiltstate:(NSString *)tiltstate onModel:(DeviceModel *)modelObj;


+ (NSDate *)getTiltstatechangedFromModel:(DeviceModel *)modelObj;





@end
