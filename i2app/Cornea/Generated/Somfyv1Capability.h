

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The user has to set the type of device (Blinds or Shade) they have to generate the proper UI. Defaults to SHADE. */
extern NSString *const kAttrSomfyv1Type;

/** The user may need to reverse the shade motor direction if wiring is reversed. Defaults to NORMAL. */
extern NSString *const kAttrSomfyv1Reversed;

/** The channel of the Blinds or Shade on the Bridge. */
extern NSString *const kAttrSomfyv1Channel;

/** The current state (position) of the Blinds or Shade reported by the bridge. */
extern NSString *const kAttrSomfyv1Currentstate;

/** UTC time of last state (OPEN/CLOSED/FAVORITE) change. */
extern NSString *const kAttrSomfyv1Statechanged;


extern NSString *const kCmdSomfyv1GoToOpen;

extern NSString *const kCmdSomfyv1GoToClosed;

extern NSString *const kCmdSomfyv1GoToFavorite;


extern NSString *const kEnumSomfyv1TypeSHADE;
extern NSString *const kEnumSomfyv1TypeBLIND;
extern NSString *const kEnumSomfyv1ReversedNORMAL;
extern NSString *const kEnumSomfyv1ReversedREVERSED;
extern NSString *const kEnumSomfyv1CurrentstateOPEN;
extern NSString *const kEnumSomfyv1CurrentstateCLOSED;


@interface Somfyv1Capability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTypeFromModel:(DeviceModel *)modelObj;

+ (NSString *)setType:(NSString *)type onModel:(DeviceModel *)modelObj;


+ (NSString *)getReversedFromModel:(DeviceModel *)modelObj;

+ (NSString *)setReversed:(NSString *)reversed onModel:(DeviceModel *)modelObj;


+ (int)getChannelFromModel:(DeviceModel *)modelObj;


+ (NSString *)getCurrentstateFromModel:(DeviceModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(DeviceModel *)modelObj;





/** Move the Blinds or Shade to a pre-programmed OPEN position. */
+ (PMKPromise *) goToOpenOnModel:(Model *)modelObj;



/** Move the Blinds or Shade to a pre-programmed CLOSED position. */
+ (PMKPromise *) goToClosedOnModel:(Model *)modelObj;



/** Move the Blinds or Shade to a pre-programmed FAVORITE position. */
+ (PMKPromise *) goToFavoriteOnModel:(Model *)modelObj;



@end
