

#import <Foundation/Foundation.h>
#import "ClientEvent.h"
#import "ClientRequest.h"

@class PMKPromise;

@interface VideoService : NSObject
+ (NSString *)name;
+ (NSString *)address;



/** Lists all recordings available for a given place. */
+ (PMKPromise *) listRecordingsWithPlaceId:(NSString *)placeId withAll:(BOOL)all withType:(NSString *)type;



/** Lists paged recordings available for a given place. */
+ (PMKPromise *) pageRecordingsWithPlaceId:(NSString *)placeId withLimit:(int)limit withToken:(NSString *)token withAll:(BOOL)all withInprogress:(BOOL)inprogress withType:(NSString *)type withLatest:(double)latest withEarliest:(double)earliest withCameras:(NSArray *)cameras withTags:(NSArray *)tags;



/** Starts a video recording or live streaming session. */
+ (PMKPromise *) startRecordingWithPlaceId:(NSString *)placeId withAccountId:(NSString *)accountId withCameraAddress:(NSString *)cameraAddress withStream:(BOOL)stream withDuration:(int)duration;



/** Stops a video recording or live streaming session. */
+ (PMKPromise *) stopRecordingWithPlaceId:(NSString *)placeId withRecordingId:(NSString *)recordingId;



/** Gets the video storage quota for a place. */
+ (PMKPromise *) getQuotaWithPlaceId:(NSString *)placeId;



/** Gets the video favorite video quota for a place. */
+ (PMKPromise *) getFavoriteQuotaWithPlaceId:(NSString *)placeId;



/** Delete all recordings for the given place. */
+ (PMKPromise *) deleteAllWithPlaceId:(NSString *)placeId withIncludeFavorites:(BOOL)includeFavorites;



@end
