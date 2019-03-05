

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** If enabled the heater will reduce power consumption to save energy. */
extern NSString *const kAttrTwinStarEcomode;



extern NSString *const kEnumTwinStarEcomodeENABLED;
extern NSString *const kEnumTwinStarEcomodeDISABLED;


@interface TwinStarCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getEcomodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setEcomode:(NSString *)ecomode onModel:(DeviceModel *)modelObj;





@end
