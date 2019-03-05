//
//  ViewPlayerLogger.m
//  i2app
//
//  Created by Arcus Team on 8/11/17.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

#import <i2app-Swift.h>
#import "VideoPlayerLogger.h"
#import "SessionService.h"

@interface VideoPlayerLogger ()

@end

NSString *const kkNoResponse = @"no response";
NSString *const kkMediaFileNotReceived = @"media file not received";
NSString *const kkPlayListFileNotRecieved = @"playlist file not received";
NSString *const kkRestartingTooFar = @"restarting too far ahead";
NSString *const kkPlaylistUnchanged = @"playlist file unchanged";
NSString *const kkSegmentExceedsBandwidth = @"segment exceeds specified bandwidth";
NSString *const kkRequestedRange = @"requested range not satisfiable";

@implementation VideoPlayerLogger

+ (void) postLogs:(AVPlayerItemAccessLog *)logs errorLog:(AVPlayerItemErrorLog *)errLogs {

  if(logs != nil) {
    NSMutableString *accessSummary = [[NSMutableString alloc] initWithString:@"["];
    NSArray *accessEvents = logs.events;
    int idx = 0;
    int size = (int)logs.events.count;
    for(AVPlayerItemAccessLogEvent *evt in accessEvents) {
      [accessSummary appendFormat:@"{bytesTransferred=%lld, mediaRequests=%ld, startup=%f, watched=%f, dropped=%ld, stalls=%ld, overdue=%ld, brStdDev=%f, brIndicated=%f, brObserved=%f}",
       evt.numberOfBytesTransferred, (long)evt.numberOfMediaRequests, evt.startupTime, evt.durationWatched, (long)evt.numberOfDroppedVideoFrames,
       (long)evt.numberOfStalls, (long)evt.downloadOverdue, evt.observedBitrateStandardDeviation, evt.indicatedBitrate, evt.observedBitrate];
      if(idx < size - 1) {
        [accessSummary appendString:@", "];
      }
    }
    [accessSummary appendString:@"]"];
    DDLogDebug(@"access log summary: %@", accessSummary);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [SessionService logWithCategory:@"ios-video" withCode:@"access" withMessage:accessSummary];
    });
  }

  if(errLogs != nil) {
    unsigned int noResponseCount = 0;
    unsigned int mediaFileNotReceivedCount = 0;
    unsigned int playlistFileNotRecievedCount = 0;
    unsigned int restartingTooFarCount = 0;
    unsigned int playlistUnchangedCount = 0;
    unsigned int segmentExceedsBandwidthCount = 0;
    unsigned int requestedRangeCount = 0;

    NSMutableString *errs = [[NSMutableString alloc] init];

    NSArray *errorEvents = errLogs.events;
    for(AVPlayerItemErrorLogEvent *evt in errorEvents) {
      if([evt.errorComment rangeOfString:kkNoResponse options:NSCaseInsensitiveSearch].location != NSNotFound) {
        noResponseCount++;
      }
      else if([evt.errorComment rangeOfString:kkMediaFileNotReceived options:NSCaseInsensitiveSearch].location != NSNotFound) {
        mediaFileNotReceivedCount++;
      }
      else if([evt.errorComment rangeOfString:kkPlayListFileNotRecieved options:NSCaseInsensitiveSearch].location != NSNotFound) {
        playlistFileNotRecievedCount++;
      }
      else if([evt.errorComment rangeOfString:kkRestartingTooFar options:NSCaseInsensitiveSearch].location != NSNotFound) {
        restartingTooFarCount++;
      }
      else if([evt.errorComment rangeOfString:kkPlaylistUnchanged options:NSCaseInsensitiveSearch].location != NSNotFound) {
        playlistUnchangedCount++;
      }
      else if([evt.errorComment rangeOfString:kkSegmentExceedsBandwidth options:NSCaseInsensitiveSearch].location != NSNotFound) {
        segmentExceedsBandwidthCount++;
      }
      else if([evt.errorComment rangeOfString:kkRequestedRange options: NSCaseInsensitiveSearch].location != NSNotFound) {
        requestedRangeCount++;
      }
      else {
        [errs appendFormat:@"%@, ", evt.errorComment];
      }
    }
    [errs appendFormat:@"noResponse: %u, mediaFileNotRecieved: %u, playlistFileNotReceived: %u, restartingTooFarAhead: %u, playlistUnchanged: %u, segmentExceedsBandwidth: %u, requestedRangeNotSatisfiable=%u",
     noResponseCount, mediaFileNotReceivedCount, playlistFileNotRecievedCount, restartingTooFarCount, playlistUnchangedCount, segmentExceedsBandwidthCount, requestedRangeCount];

    DDLogDebug(@"error log summary: %@", errs);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [SessionService logWithCategory:@"ios-video" withCode:@"errors" withMessage:errs];
    });
  }
}

@end
