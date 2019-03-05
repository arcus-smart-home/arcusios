//
//  CameraOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
@import  AVKit;
@import AVFoundation;

#import "CameraOperationViewController.h"
#import "CameraVideoPlayerProvider.h"
#import "UIViewController+AlertBar.h"

#import "DeviceDetailsTabBarController.h"
#import "DeviceControlViewController.h"
#import "CameraCapability.h"
#import "SwannBatteryCameraCapability.h"
#import "WifiCapability.h"
#import "VideoService.h"
#import "PlaceCapability.h"
#import "SessionService.h"
#import "UIView+Subviews.h"
#import <i2app-Swift.h>

#define kRetryTimeInSeconds 1
#define kRetryTimeoutInSeconds 25

NSString *const kNoResponse = @"no response";
NSString *const kMediaFileNotReceived = @"media file not received";
NSString *const kPlayListFileNotRecieved = @"playlist file not received";
NSString *const kRestartingTooFar = @"restarting too far ahead";
NSString *const kPlaylistUnchanged = @"playlist file unchanged";
NSString *const kSegmentExceedsBandwidth = @"segment exceeds specified bandwidth";
NSString *const kRequestedRange = @"requested range not satisfiable";

@interface CameraOperationViewController ()<CameraVideoPlayerProviderDelegate, CellularBackupCallback>

@property (nonatomic, retain) CellularBackupPresenter *cellularPresenter;
@property (nonatomic, strong) CameraVideoPlayerProvider *cameraPlayerProvider;
@property (nonatomic) SwannCameraKeepAwakePresenter *swannCameraKeepAwakePresenter;

@end

@implementation CameraOperationViewController {
    DeviceButtonBaseControl     *_liveButton;
    DeviceButtonBaseControl     *_recordButton;
    DeviceButtonBaseControl     *_playButton;
    DevicePercentageAttributeControl *_batteryPercentage;
    DeviceTextIconAttributeControl *_signalStrength;

    AVPlayerViewController      *_playerViewController;
    AVQueuePlayer               *_player;

    PopupSelectionWindow        *_popupWindow;
    
    BOOL        _isStreaming;
    BOOL        _isRecording;
    
    NSInteger   _loadingTag;
}

#pragma mark - life cycle
- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView | GeneralDeviceAbilityEventLabel;
}

- (void)dealloc {}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.deviceModel.isSwannCamera) {
        [self configureSwannCamera];
    } else {
        [self configureSercommCamera];
    }

    self.cameraPlayerProvider = [[CameraVideoPlayerProvider alloc] initWithDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.deviceController.tabBarController hideGif];
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];
  
    if (self.deviceModel.isSwannCamera) {
        self.swannCameraKeepAwakePresenter =
            [[SwannCameraKeepAwakePresenter alloc] initWithCameraAddress:self.deviceModel.address];
        [self.swannCameraKeepAwakePresenter startKeepAwake];
    }

    self.cellularPresenter = [[CellularBackupPresenter alloc] initWithCallback:self
                                                           subsystemController:[SubsystemsController sharedInstance]
                                                            notificationCenter:[NSNotificationCenter defaultCenter]];
}

- (void)deviceWillDisappear:(BOOL)animated {
    [super deviceWillDisappear:animated];

    [self.swannCameraKeepAwakePresenter stopKeepAwake];
    self.swannCameraKeepAwakePresenter = nil;
    self.cellularPresenter = nil;
}

#pragma mark - Config Methods

- (void)configureSwannCamera {
    _playButton = [DeviceButtonBaseControl create:[UIImage imageNamed:@"play_stream_white_61x61"]
                                             name:@"" withSelector:@selector(pressedLiveButton:)
                                            owner:self];


    [self.buttonsView loadControl:_playButton];

    _batteryPercentage = [DevicePercentageAttributeControl createWithBatteryPercentage:[[self.deviceModel batteryLevel] floatValue]];

    UIImage *signalImage = [WifiScanItemHolder imageForSignalStrength:[WiFiCapability getRssiFromModel: self.deviceModel]];
    _signalStrength = [DeviceTextIconAttributeControl create:@"Signal"
                                                   withValue:@""
                                                     andIcon:signalImage];

    [self.attributesView loadControl:_batteryPercentage control2:_signalStrength];
}

- (void)configureSercommCamera {
    [self.eventLabel setTitle:NSLocalizedString(@"1080 P", nil) andContent:NSLocalizedString(@"30 PFS", nil)];

    _liveButton = [DeviceButtonBaseControl create: [UIImage imageNamed:@"play_stream_white_61x61"]
                                            name: @""
                                    withSelector: @selector(pressedLiveButton:)
                                           owner: self];

    _recordButton = [DeviceButtonBaseControl create: [UIImage imageNamed:@"rec_white_61x61"]
                                              name: @""
                                      withSelector: @selector(pressedRecordButton:)
                                             owner: self];

    [self.buttonsView loadControl:_liveButton control2:_recordButton];
}

#pragma mark -

- (void)pressedLiveButton:(UIButton *)button {
    [self setLive:!_isStreaming];
}

- (void)pressedRecordButton:(UIButton *)button {
    [self setRecord:!_isRecording];
}

- (void)centerMode {
    [super centerMode];
}

#pragma mark - button event
- (void)setLive:(BOOL)isStreaming {
    if (_isStreaming == isStreaming) {
        return;
    }
    _isStreaming = isStreaming;
    if (_isStreaming) {
        [self disableLiveButton];
        [self disableRecordButton];
    }
    else {
        [self enableRecordButton];
        [self enableLiveButton];
    }
    
    [self streamVideo:self.deviceModel stopVideoWhenDoneViewing:YES];
}

- (void)setRecord:(BOOL)state {
    if (_isRecording == state) {
        return;
    }
    
    _isRecording = state;
    if (_isRecording) {
        [self disableRecordButton];
        [self disableLiveButton];
    }
    else {
        [self enableRecordButton];
        [self enableLiveButton];
    }
    
    [self recordVideo:self.deviceModel];
}

- (void)stopLoading {
    _isRecording = NO;
    _isStreaming = NO;
    [self cancelPlaying];
    [self resetPlayer];

    [self enableLiveButton];
    [self enableRecordButton];
    [self.deviceController.tabBarController hideGif];
}

- (void)resetPlayer {
  
    [self closePopupAlertWithTag:_loadingTag];
    [self removePlayerObservers];
    _player = nil;
    _playerViewController = nil;
    
}

#pragma mark - platform update
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
  if (!self.deviceModel.isSwannCamera) {
    NSString *resolution = [CameraCapability getResolutionFromModel:self.deviceModel];
    int frameRate = [CameraCapability getFramerateFromModel:self.deviceModel];

    [self.eventLabel setTitle:resolution andContent:[NSString stringWithFormat:@"%d FPS", frameRate]];
  }
}

#pragma mark - Stream Video
- (void)startStreamWithUrl:(NSURL *)url {
    
    DDLogInfo(@"Launching the player with url %@", url.absoluteString);
    
    _playerViewController = [[AVPlayerViewController alloc] init];
    _playerViewController.delegate = self;

    _player = [AVQueuePlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
    [self addPlayerObservers];
    _playerViewController.player = _player;
}

#pragma mark- AVPlayerViewControllerDelegate

- (void)didEnd {
    @try {
        [self removePlayerObservers];
    } @catch (NSException *exception) {
        DDLogError(@"CameraOperationViewController:didEnd %@", exception.description);
    }
    [self cancelPlaying];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            DDLogInfo(@"Player status is ready");
            [self.deviceController presentViewController:_playerViewController animated:YES completion:nil];
            [_player play];
        }
        else if (_player.status == AVPlayerStatusFailed) {
            DDLogInfo(@"Player status is failed");
            
            [self enableLiveButton];
            [self enableRecordButton];
        }
    }

    if (_player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        DDLogInfo(@"PLAYER ITEM  status is READY");
    }
    else if (_playerViewController.player.currentItem.status == AVPlayerItemStatusFailed) {
        DDLogInfo(@"PLAYER ITEM  status is FAILED");
    }
    else if (_playerViewController.player.currentItem.status == AVPlayerItemStatusUnknown) {
        DDLogInfo(@"PLAYER ITEM  status is UNKNOWN");
    }
}

#pragma mark - buttons

- (void)disableRecordButton {
    [_recordButton.button setAlpha:0.4f];
    _recordButton.button.userInteractionEnabled  = NO;
}

- (void)enableRecordButton {
    [_recordButton.button setAlpha:1.0f];
    _recordButton.button.userInteractionEnabled  = YES;
}

- (void)disableLiveButton {
    [_liveButton.button setAlpha:0.4f];
    _liveButton.button.userInteractionEnabled  = NO;
}

- (void)enableLiveButton {
    [_liveButton.button setAlpha:1.0f];
    _liveButton.button.userInteractionEnabled  = YES;
}

#pragma mark - firmware update 
- (void)stopFirmwareUpdate {
    [self enableLiveButton];
    [self enableRecordButton];
}

- (void)startFirmwareUpdate {
    [self stopLoading];
    [self disableLiveButton];
    [self disableRecordButton];
}

#pragma mark - Video Play Methods
- (void)streamVideo:(DeviceModel*)deviceModel stopVideoWhenDoneViewing:(BOOL)stopVideoWhenDoneViewing {
    [self showLoadingIndication];
    [self.cameraPlayerProvider startStreamingWithDeviceAddress:deviceModel.address
                                      stopVideoWhenDoneViewing:stopVideoWhenDoneViewing
                                                    completion:^ (NSError *error) {
                                                        if (error.userInfo[@"isNotConfigured"]) {
                                                            [self displayGenericErrorMessageWithError:error];
                                                        }
                                                    }];
}

- (void)recordVideo:(DeviceModel *)deviceModel {
    [self showLoadingIndication];
    [self.cameraPlayerProvider startRecordingWithDeviceAddress:deviceModel.address
                                                    completion:^ (NSError *error) {
                                                        if (error.userInfo[@"isNotConfigured"]) {
                                                            [self displayGenericErrorMessageWithError:error];
                                                        }
                                                    }];
}

- (void)cancelPlaying {
    [self hideLoadingIndication];
    _loadingTag = NSNotFound;
    if (self.cameraPlayerProvider.stopVideoWhenDoneViewing) {
        [self.cameraPlayerProvider stopVideo];
    }

    @try {
        [self removePlayerObservers];
    } @catch (NSException *exception) {
        DDLogError(@"cancelPlaying error:%@", exception.description);
    }
    _player = nil;
    _playerViewController = nil;
}

#pragma mark - CameraVideoPlayerProviderDelegate
- (void)cameraVideoPlayerProvider:(CameraVideoPlayerProvider *)provider
              didReceiveStreamUrl:(NSURL *)streamUrl {
    if (streamUrl) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                if (_player && _player.currentItem) {
                    [self removePlayerObservers];
                }
            } @catch (NSException *exception) {
                DDLogError(@"cameraVideoPlayerProvider error:%@", exception.description);
            }

            DDLogInfo(@"Launching the player with url %@", streamUrl.absoluteString);
            _playerViewController = [[AVPlayerViewController alloc] init];
            _playerViewController.delegate = self;

            _player = [AVQueuePlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:streamUrl]];
            [self addPlayerObservers];
            _playerViewController.player = _player;
        });
    }
}

- (void)cameraVideoPlayerProvider:(CameraVideoPlayerProvider *)provider
       didFailtToReceiveStreamUrl:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoadingIndication];
        [self displayGenericErrorMessageWithError:error];
    });
}

#pragma mark - Loading Indication
- (void)showLoadingIndication {
    _loadingTag = (int)[self popupAlert:@"Loading..."
                                   type:AlertBarTypeCamera
                               canClose:YES
                              sceneType:AlertBarSceneInDevice];

    [self.deviceController.tabBarController createGif];
}

- (void)hideLoadingIndication {
    if (_loadingTag != NSNotFound) {
        [self closePopupAlertWithTag:_loadingTag];
        [self hideGif];
    }
}


#pragma mark - CellularBackupCallback
- (void)showOnCellularBackup {
    [self disableView];

    [self showCellularOfflineAlertBar];
}

- (void)showOnBroadband {
    [self enableView];

    if (![self.deviceModel isDeviceOffline]) {
      [self closePopupAlert];
    }
}

- (void)disableView {
    for (UIView *view in [self.view allSubviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 0.4f;
            view.userInteractionEnabled = NO;
        }
    }
}

- (void)enableView {
    for (UIView *view in [self.view allSubviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 1.f;
            view.userInteractionEnabled = YES;
        }
    }

}

- (NSInteger)showCellularOfflineAlertBar {
    return [self popupLinkAlert:NSLocalizedString(@"Streaming and recording of live video is disabled on Backup Cellular.", nil)
                           type:AlertBarTypeAlertNoImage
                      sceneType:AlertBarSceneInDevice
                      grayScale:YES
                       linkText:nil
                       selector:nil
                   displayArrow:NO];
}



- (void)addPlayerObservers {
    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
    [_player addObserver:self forKeyPath:@"currentItem.status" options:0 context:nil];
}

- (void)removePlayerObservers {
    [_player removeObserver:self forKeyPath:@"status"];
    [_player removeObserver:self forKeyPath:@"currentItem.status"];
}

@end
