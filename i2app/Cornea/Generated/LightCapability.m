

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "LightCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrLightColormode=@"light:colormode";



NSString *const kEnumLightColormodeNORMAL = @"NORMAL";
NSString *const kEnumLightColormodeCOLOR = @"COLOR";
NSString *const kEnumLightColormodeCOLORTEMP = @"COLORTEMP";


@implementation LightCapability
+ (NSString *)namespace { return @"light"; }
+ (NSString *)name { return @"Light"; }

+ (NSString *)getColormodeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [LightCapabilityLegacy getColormode:modelObj];
  
}

+ (NSString *)setColormode:(NSString *)colormode onModel:(DeviceModel *)modelObj {
  [LightCapabilityLegacy setColormode:colormode model:modelObj];
  
  return [LightCapabilityLegacy getColormode:modelObj];
  
}



@end
