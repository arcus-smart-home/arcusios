

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Reflects the current state of the button where pressed implies the user has pressed the button and released the opposite. Also used to set the state of the button. */
extern NSString *const kAttrHubButtonState;

/** How long has the button been in the given state */
extern NSString *const kAttrHubButtonDuration;

/** UTC date time of last state change */
extern NSString *const kAttrHubButtonStatechanged;



extern NSString *const kEnumHubButtonStateRELEASED;
extern NSString *const kEnumHubButtonStatePRESSED;
extern NSString *const kEnumHubButtonStateDOUBLE_PRESSED;


@interface HubButtonCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getStateFromModel:(HubModel *)modelObj;

+ (NSString *)setState:(NSString *)state onModel:(HubModel *)modelObj;


+ (int)getDurationFromModel:(HubModel *)modelObj;


+ (NSDate *)getStatechangedFromModel:(HubModel *)modelObj;





@end
