//
//  CameraVideoPlayerProvider.h
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

#import <Foundation/Foundation.h>

@class CameraVideoPlayerProvider;

@protocol CameraVideoPlayerProviderDelegate <NSObject>
@required

- (void)cameraVideoPlayerProvider:(CameraVideoPlayerProvider *)provider
              didReceiveStreamUrl:(NSURL *)streamUrl;
- (void)cameraVideoPlayerProvider:(CameraVideoPlayerProvider *)provider
       didFailtToReceiveStreamUrl:(NSError *)error;

@end

@interface CameraVideoPlayerProvider : NSObject

- (instancetype)initWithDelegate:(id <CameraVideoPlayerProviderDelegate>)delegate;

@property (atomic, assign) BOOL stopVideoWhenDoneViewing;

- (void)startRecordingWithDeviceAddress:(NSString *)deviceAddress
                         completion:(void (^)(NSError *error))completion;
- (void)startStreamingWithDeviceAddress:(NSString *)deviceAddress
           stopVideoWhenDoneViewing:(BOOL)stopVideoWhenDoneViewing
                         completion:(void (^)(NSError *error))completion;
- (void)stopVideo;

@end

