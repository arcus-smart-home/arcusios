

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the smoke detector (safe,detected). */
extern NSString *const kAttrSmokeSmoke;

/** UTC date time of last smoke change */
extern NSString *const kAttrSmokeSmokechanged;



extern NSString *const kEnumSmokeSmokeSAFE;
extern NSString *const kEnumSmokeSmokeDETECTED;


@interface SmokeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getSmokeFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getSmokechangedFromModel:(DeviceModel *)modelObj;





@end
