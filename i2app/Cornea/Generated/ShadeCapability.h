

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The percentage that the shades are open (raised/lowered). May also be used to set how closed (lowered) or open (raised) the shade is where 100% is fully open and 0% is fully closed. For devices that only support being set fully Open (Raised) or Closed (Lowered), use 0% for Closed (Lowered) and 100% for Open (Raised). */
extern NSString *const kAttrShadeLevel;

/** Reflects the current state of the shade.  Obstruction implying that something is preventing the opening or closing of the shade. */
extern NSString *const kAttrShadeShadestate;

/** UTC time of last level change. */
extern NSString *const kAttrShadeLevelchanged;


extern NSString *const kCmdShadeGoToOpen;

extern NSString *const kCmdShadeGoToClosed;

extern NSString *const kCmdShadeGoToFavorite;


extern NSString *const kEnumShadeShadestateOK;
extern NSString *const kEnumShadeShadestateOBSTRUCTION;


@interface ShadeCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getLevelFromModel:(DeviceModel *)modelObj;

+ (int)setLevel:(int)level onModel:(DeviceModel *)modelObj;


+ (NSString *)getShadestateFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getLevelchangedFromModel:(DeviceModel *)modelObj;





/** Move the shade to a pre-programmed OPEN position. */
+ (PMKPromise *) goToOpenOnModel:(Model *)modelObj;



/** Move the shade to a pre-programmed CLOSED position. */
+ (PMKPromise *) goToClosedOnModel:(Model *)modelObj;



/** Move the shade to a pre-programmed FAVORITE position. */
+ (PMKPromise *) goToFavoriteOnModel:(Model *)modelObj;



@end
