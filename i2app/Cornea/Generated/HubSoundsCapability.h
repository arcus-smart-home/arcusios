

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Is the hub playing a sounds? */
extern NSString *const kAttrHubSoundsPlaying;

/** Source of the sounds being played.  File from URL or pre-programmed tone name */
extern NSString *const kAttrHubSoundsSource;


extern NSString *const kCmdHubSoundsPlayTone;

extern NSString *const kCmdHubSoundsQuiet;




@interface HubSoundsCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getPlayingFromModel:(HubModel *)modelObj;


+ (NSString *)getSourceFromModel:(HubModel *)modelObj;





/** Causes the hub to play the chime sound. */
+ (PMKPromise *) playToneWithTone:(NSString *)tone withDurationSec:(int)durationSec onModel:(Model *)modelObj;



/** Stop playing any sound. */
+ (PMKPromise *) quietOnModel:(Model *)modelObj;



@end
