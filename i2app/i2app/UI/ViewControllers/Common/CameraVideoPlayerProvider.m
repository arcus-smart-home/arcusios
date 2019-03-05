//
//  CameraVideoPlayerProvider.m
//  i2app
//
//  Created by Arcus Team on 3/30/16.
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
#import "CameraVideoPlayerProvider.h"

#import "NSDate+Convert.h"
#import "SubsystemsController.h"
#import "CameraSubsystemController.h"

#import "VideoService.h"
#import "RecordingCapability.h"

#import <i2app-Swift.h>
#import "ApplicationSecureRequestDelegate.h"

#define kGetStreamUrlTimeout 25

@interface CameraVideoPlayerProvider ()

@property (nonatomic, weak) id <CameraVideoPlayerProviderDelegate> delegate;
@property (nonatomic, strong) NSTimer *retryStartVideoTimer;
@property (nonatomic, strong) NSURL *currentVideoUrl;
@property (nonatomic, strong) NSString *currentVideoId;
@property (nonatomic, assign) NSInteger retryCounter;

@end

@implementation CameraVideoPlayerProvider

#pragma mark - Initialization

- (instancetype)initWithDelegate:(id <CameraVideoPlayerProviderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Data I/O

- (void)fetchVideoStreamWithUrl:(NSURL *)url {
    ApplicationSecureRequestDelegate *delegate = [ApplicationSecureRequestDelegate new];
  
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:delegate
                                                     delegateQueue:nil];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if(httpResponse.statusCode == 200) {
            [self stopRetryTimer];
            if ([self.delegate respondsToSelector:@selector(cameraVideoPlayerProvider:
                                                            didReceiveStreamUrl:)]) {
                [self.delegate cameraVideoPlayerProvider:self
                                     didReceiveStreamUrl:self.currentVideoUrl];
            }
        } else {
            DDLogError(@"CameraVideoPlayerProvider:fetchVideoStreamWithUrl:\n%@", httpResponse.description);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startRetryTimer];
            });
        }
    }];
    
    [task resume];
}

#pragma mark - Video Recording/Playing
- (void)startRecordingWithDeviceAddress:(NSString *)deviceAddress
                             completion:(void (^)(NSError *error))completion {
        [self startVideoWithAddress:deviceAddress
                        isStreaming:NO
           stopVideoWhenDoneViewing:NO
                           duration:0
                         completion:completion];
}


- (void)startStreamingWithDeviceAddress:(NSString *)deviceAddress
               stopVideoWhenDoneViewing:(BOOL)stopVideoWhenDoneViewing
                             completion:(void (^)(NSError *error))completion {
    [self startVideoWithAddress:deviceAddress
                    isStreaming:YES
       stopVideoWhenDoneViewing:stopVideoWhenDoneViewing
                       duration:0
                     completion:completion];
}

- (void)startVideoWithAddress:(NSString *)deviceAddress
                  isStreaming:(BOOL)isSteaming
     stopVideoWhenDoneViewing:(BOOL)stopVideoWhenDoneViewing
                     duration:(NSInteger)duration
                   completion:(void (^)(NSError *error))completion {
    self.stopVideoWhenDoneViewing = stopVideoWhenDoneViewing;
    if(deviceAddress &&
       [[CorneaHolder shared] settings].currentPlace.modelId &&
       [[CorneaHolder shared] settings].currentAccount.modelId) {
        
        DDLogDebug(@"Sending request start recording with streaming %@ for camera address %@", (isSteaming ? @"YES" : @"NO"), deviceAddress);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [VideoService startRecordingWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId
                                      withAccountId:[[CorneaHolder shared] settings].currentAccount.modelId
                                  withCameraAddress:deviceAddress
                                         withStream:isSteaming
                                       withDuration:(int)duration].then(^(VideoServiceStartRecordingResponse *response) {
                
                self.currentVideoUrl = [NSURL URLWithString:response.getHls];
                self.currentVideoId = [self streamIdWithStreamURL:self.currentVideoUrl];
                
                DDLogDebug(@"Got stream url %@", self.currentVideoUrl.absoluteString);
                
                self.retryCounter = 0;
                [self startRetryTimer];
            });
        });
    } else if (completion) {
        completion([NSError errorWithDomain:@"Arcus"
                                       code:999
                                   userInfo:@{NSLocalizedDescriptionKey : @"Non-premium user attempting to record",
                                              @"isNotConfigured" : @(YES)}]);
    }
}

- (void)stopVideo {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self stopRetryTimer];
        if (self.currentVideoId) {
            [VideoService stopRecordingWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId
                                   withRecordingId:_currentVideoId];
        }
    });
}

- (NSString *)streamIdWithStreamURL:(NSURL *)hlsUrl {
    NSString *stringId = nil;
    
    NSArray *components = hlsUrl.pathComponents;
    if (components.count >=3 ) {
        stringId = [components objectAtIndex:2];
    }
    return stringId;
}

#pragma mark - Retry Timer

- (void)startRetryTimer {
    self.retryStartVideoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(attemptRetry:)
                                                               userInfo:nil
                                                                repeats:NO];
}

- (void)attemptRetry:(id)sender {
    if (self.retryCounter < kGetStreamUrlTimeout) {
        DDLogInfo(@"Retry pulling url at %i times", (int)self.retryCounter);
        
        [self fetchVideoStreamWithUrl:self.currentVideoUrl];
        
        self.retryCounter++;
    } else {
        DDLogInfo(@"Stop retry pulling url because  %i times", (int)self.retryCounter);
        
        [self stopRetryTimer];
        
        if ([self.delegate respondsToSelector:@selector(cameraVideoPlayerProvider:
                                                        didFailtToReceiveStreamUrl:)]) {
            [self.delegate cameraVideoPlayerProvider:self
                          didFailtToReceiveStreamUrl:nil];
        }
    }
}

- (void)stopRetryTimer {
    [self.retryStartVideoTimer invalidate];
    self.retryStartVideoTimer = nil;
}

@end
