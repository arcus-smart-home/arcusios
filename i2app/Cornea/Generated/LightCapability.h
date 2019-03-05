

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current color mode of the light (or Normal for non-color devices). */
extern NSString *const kAttrLightColormode;



extern NSString *const kEnumLightColormodeNORMAL;
extern NSString *const kEnumLightColormodeCOLOR;
extern NSString *const kEnumLightColormodeCOLORTEMP;


@interface LightCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getColormodeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setColormode:(NSString *)colormode onModel:(DeviceModel *)modelObj;





@end
