

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the state of the indicator on the device.  ON means the indicator is currently active, OFF means the indicators is inactive, and DISABLED means the indicator has been disabled. */
extern NSString *const kAttrIndicatorIndicator;

/** Allows the indicator to be enabled or disabled.  Not all devices will support this attribute. */
extern NSString *const kAttrIndicatorEnabled;

/** Indicates whether or not the enabled attribute is supported. */
extern NSString *const kAttrIndicatorEnableSupported;

/** Indicates whether operation of the indicator should be inverted, if supported by the device. For example, turn indicator OFF when switch is ON, etc. */
extern NSString *const kAttrIndicatorInverted;



extern NSString *const kEnumIndicatorIndicatorON;
extern NSString *const kEnumIndicatorIndicatorOFF;
extern NSString *const kEnumIndicatorIndicatorDISABLED;


@interface IndicatorCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getIndicatorFromModel:(DeviceModel *)modelObj;


+ (BOOL)getEnabledFromModel:(DeviceModel *)modelObj;

+ (BOOL)setEnabled:(BOOL)enabled onModel:(DeviceModel *)modelObj;


+ (BOOL)getEnableSupportedFromModel:(DeviceModel *)modelObj;


+ (BOOL)getInvertedFromModel:(DeviceModel *)modelObj;

+ (BOOL)setInverted:(BOOL)inverted onModel:(DeviceModel *)modelObj;





@end
