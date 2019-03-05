

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the glass break sensor. */
extern NSString *const kAttrGlassBreak;

/** UTC date time of last break change */
extern NSString *const kAttrGlassBreakchanged;



extern NSString *const kEnumGlassBreakSAFE;
extern NSString *const kEnumGlassBreakDETECTED;


@interface GlassCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getBreakFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getBreakchangedFromModel:(DeviceModel *)modelObj;





@end
