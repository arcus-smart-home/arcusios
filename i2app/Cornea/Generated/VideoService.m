

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "VideoService.h"
#import <i2app-Swift.h>

@implementation VideoService
+ (NSString *)name { return @"VideoService"; }
+ (NSString *)address { return @"SERV:video:"; }


+ (PMKPromise *) listRecordingsWithPlaceId:(NSString *)placeId withAll:(BOOL)all withType:(NSString *)type {
  return [VideoServiceLegacy listRecordings:placeId all:all type:type];

}


+ (PMKPromise *) pageRecordingsWithPlaceId:(NSString *)placeId withLimit:(int)limit withToken:(NSString *)token withAll:(BOOL)all withInprogress:(BOOL)inprogress withType:(NSString *)type withLatest:(double)latest withEarliest:(double)earliest withCameras:(NSArray *)cameras withTags:(NSArray *)tags {
  return [VideoServiceLegacy pageRecordings:placeId limit:limit token:token all:all inprogress:inprogress type:type latest:latest earliest:earliest cameras:cameras tags:tags];

}


+ (PMKPromise *) startRecordingWithPlaceId:(NSString *)placeId withAccountId:(NSString *)accountId withCameraAddress:(NSString *)cameraAddress withStream:(BOOL)stream withDuration:(int)duration {
  return [VideoServiceLegacy startRecording:placeId accountId:accountId cameraAddress:cameraAddress stream:stream duration:duration];

}


+ (PMKPromise *) stopRecordingWithPlaceId:(NSString *)placeId withRecordingId:(NSString *)recordingId {
  return [VideoServiceLegacy stopRecording:placeId recordingId:recordingId];

}


+ (PMKPromise *) getQuotaWithPlaceId:(NSString *)placeId {
  return [VideoServiceLegacy getQuota:placeId];

}


+ (PMKPromise *) getFavoriteQuotaWithPlaceId:(NSString *)placeId {
  return [VideoServiceLegacy getFavoriteQuota:placeId];

}


+ (PMKPromise *) deleteAllWithPlaceId:(NSString *)placeId withIncludeFavorites:(BOOL)includeFavorites {
  return [VideoServiceLegacy deleteAll:placeId includeFavorites:includeFavorites];

}

@end
