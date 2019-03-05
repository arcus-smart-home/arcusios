

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current hue or for lack of a better word color. May also be used to set the hue. Range is 0-360 angular degrees. */
extern NSString *const kAttrColorHue;

/** The saturation or intensity of the hue. Lower values result in less intensity (more gray) and higher values result in a more intense hue (less gray). May also be used to set the saturation. */
extern NSString *const kAttrColorSaturation;





@interface ColorCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getHueFromModel:(DeviceModel *)modelObj;

+ (int)setHue:(int)hue onModel:(DeviceModel *)modelObj;


+ (int)getSaturationFromModel:(DeviceModel *)modelObj;

+ (int)setSaturation:(int)saturation onModel:(DeviceModel *)modelObj;





@end
