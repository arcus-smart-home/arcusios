

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
extern NSString *const kAttrSomfy1Mode;

/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
extern NSString *const kAttrSomfy1Reversed;



extern NSString *const kEnumSomfy1ModeSHADE;
extern NSString *const kEnumSomfy1ModeBLIND;
extern NSString *const kEnumSomfy1ReversedNORMAL;
extern NSString *const kEnumSomfy1ReversedREVERSED;


@interface Somfy1Capability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getModeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setMode:(NSString *)mode onModel:(DeviceModel *)modelObj;


+ (NSString *)getReversedFromModel:(DeviceModel *)modelObj;

+ (NSString *)setReversed:(NSString *)reversed onModel:(DeviceModel *)modelObj;





@end
