

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** Reflects the current state of the vent.  Obstruction implying that something is preventing the opening or closing of the vent. */
extern NSString *const kAttrVentVentstate;

/** Reflects the current level of openness, as a percentage. */
extern NSString *const kAttrVentLevel;

/** Air pressure in duct. */
extern NSString *const kAttrVentAirpressure;



extern NSString *const kEnumVentVentstateOK;
extern NSString *const kEnumVentVentstateOBSTRUCTION;


@interface VentCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getVentstateFromModel:(DeviceModel *)modelObj;


+ (int)getLevelFromModel:(DeviceModel *)modelObj;

+ (int)setLevel:(int)level onModel:(DeviceModel *)modelObj;


+ (double)getAirpressureFromModel:(DeviceModel *)modelObj;





@end
