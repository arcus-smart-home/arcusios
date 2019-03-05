//
//  DeviceDetailsShade.m
//  i2app
//
//  Created by Arcus Team on 3/20/17.
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
#import "DeviceDetailsShade.h"
#import "DeviceButtonBaseControl.h"
#import "DeviceDetailsBase.h"
#import "UIView+Animation.h"
#import "ServiceControlCell.h"
#import "ShadeCapability.h"

#define kCommitIntervalInSecond 1.0
#define kTimeoutInSecond 4.0

#define kShadeMinValue   0
#define kShadeMaxValue   100

#define kShadeOffDefaultValue 25

@interface DeviceDetailsBase ()

- (void)animateRubberBandExpand:(UIView *)ringLogo;
- (void)animateRubberBandContract:(UIView *)ringLogo;

@end

@interface DeviceDetailsShade()

@end

@implementation DeviceDetailsShade {
  NSTimer                         *_sendCommandTimer;
  NSTimer                         *_cancelSendCommandTimer;
  NSTimer                         *_updateValueTimer;
  __block int                     _shadeLevel;

  CAShapeLayer                    *_backgoundCircleLayer;
  CAShapeLayer                    *_foregoundCircleLayer;
}

- (void)loadData {
  self.delegate = (id<DeviceDetailsVentDelegate>)self.controlCell;
  [self loadDataDetails];

  int level = [ShadeCapability getLevelFromModel:self.deviceModel];

  if (level < kShadeOffDefaultValue) {
    if (level <= 0) {
      [self.controlCell setSubtitle:NSLocalizedString(@"Off", nil)];
    } else {
      [self.controlCell setSubtitle:[NSString stringWithFormat:@"%d%% Off", level]];
    }
  } else {
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%d%% Open", level]];
  }
}

- (void)loadDataDetails {
  [self.controlCell.leftButton setImageStyle:[UIImage imageNamed:@"deviceThermostatMinusButton"] withSelector:@selector(onVentClickLeft:) owner:self];
  [self.controlCell.rightButton setImageStyle:[UIImage imageNamed:@"deviceThermostatPlusButton"] withSelector:@selector(onVentClickRight:) owner:self];

  _shadeLevel = [ShadeCapability getLevelFromModel:self.deviceModel];

  if (!_backgoundCircleLayer) {
    _backgoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    [self.controlCell.centerIcon.layer addSublayer:_backgoundCircleLayer];
  }
  if (!_foregoundCircleLayer) {
    _foregoundCircleLayer = [self.controlCell.centerIcon createCircleFrame:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]];
    [self.controlCell.centerIcon.layer addSublayer:_foregoundCircleLayer];
  }

  _foregoundCircleLayer.strokeEnd = 0.0f;
  int level = [ShadeCapability getLevelFromModel:self.deviceModel];
  [self updateDimmerUI:level];
}

- (void)onVentClickLeft:(UIButton *)sender {

  int subtractValue = (_shadeLevel % 10 != 0)? 10 - (_shadeLevel % 10 ) : 10;
  int settingOpenness = (_shadeLevel - 10) < 0 ? 0 : (_shadeLevel - subtractValue);
  _shadeLevel = settingOpenness;
  [self stopCancelSendCommandTimer];
  [self stopUpdateValueTimer];
  [self startSendCommandTimer];
  [self updateDimmerUI:_shadeLevel];

  if ([self.delegate respondsToSelector:@selector(updateVentOpenness:)]) {
    [self.delegate deviceDetails:self updateShadeLevel:_shadeLevel];
  }
}

- (void)onVentClickRight:(UIButton *)sender {
  int addValue = (_shadeLevel % 10 != 0)? 10 - (_shadeLevel % 10 ) : 10;
  int settingOpenness = (_shadeLevel + 10) > 100 ? 100 :(_shadeLevel + addValue);
  _shadeLevel = settingOpenness;
  [self stopCancelSendCommandTimer];
  [self stopUpdateValueTimer];
  [self startSendCommandTimer];
  [self updateDimmerUI:_shadeLevel];
  if ([self.delegate respondsToSelector:@selector(updateVentOpenness:)]) {
    [self.delegate deviceDetails:self updateShadeLevel:_shadeLevel];
  }
}

- (void)updateVentOpenness:(int)value {
  if (value < kShadeOffDefaultValue) {
    if (value <= 0) {
      [self.controlCell setSubtitle:NSLocalizedString(@"Off", nil)];
    } else {
      [self.controlCell setSubtitle:[NSString stringWithFormat:@"%d%% Off",value]];
    }
  } else {
    [self.controlCell setSubtitle:[NSString stringWithFormat:@"%d%% Open", value]];
  }
}

#pragma mark - silder
- (void)updateDimmerUI:(int)percentage {
  CGFloat currentPercent = aDimmerCirclePoint(percentage / 100.0f);

  CABasicAnimation *stroke = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  stroke.fromValue = @(_foregoundCircleLayer.strokeEnd);
  stroke.toValue = @(currentPercent);
  stroke.duration = 0.5f;
  [_foregoundCircleLayer addAnimation:stroke forKey:nil];

  _foregoundCircleLayer.strokeEnd = currentPercent;
}

#pragma mark - Timers
- (void)startSendCommandTimer {
  [self stopSendCommandTimer];

  _sendCommandTimer = [NSTimer scheduledTimerWithTimeInterval:kCommitIntervalInSecond
                                                       target: self
                                                     selector: @selector(handleSendCommandTimer)
                                                     userInfo: nil
                                                      repeats: YES];

}

- (void)stopSendCommandTimer {
  [_sendCommandTimer invalidate];
  _sendCommandTimer = nil;
}

- (void)startCancelSendCommandTimer {
  if ([_cancelSendCommandTimer isValid]) {
    return;
  }
  _cancelSendCommandTimer = [NSTimer scheduledTimerWithTimeInterval:kCommitIntervalInSecond
                                                             target: self
                                                           selector: @selector(handleCancelTimer)
                                                           userInfo: nil
                                                            repeats: YES];

}

- (void)stopCancelSendCommandTimer {
  [_cancelSendCommandTimer invalidate];
  _cancelSendCommandTimer = nil;
}

- (void)startUpdateValueTimer {
  [self stopUpdateValueTimer];
  _updateValueTimer = [NSTimer scheduledTimerWithTimeInterval:kTimeoutInSecond
                                                       target: self
                                                     selector: @selector(handleUpdateValueTimer)
                                                     userInfo: nil
                                                      repeats: NO];

}

- (void)stopUpdateValueTimer {
  [_updateValueTimer invalidate];
  _updateValueTimer = nil;

}

#pragma mark - timer handlers

- (void)handleSendCommandTimer {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    [ShadeCapability setLevel:_shadeLevel onModel:self.deviceModel];
    [self.deviceModel commit];

    dispatch_async(dispatch_get_main_queue(), ^{
      [self startCancelSendCommandTimer];
      [self startUpdateValueTimer];
    });
  });
}

- (void)handleCancelTimer {
  [self stopSendCommandTimer];
  [self stopCancelSendCommandTimer];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self updateCurrentValue];
  });
}

- (void)updateCurrentValue {
  if (![_sendCommandTimer isValid] & ![_updateValueTimer isValid]) {
    [self handleUpdateValueTimer];
  }
}

- (void)handleUpdateValueTimer {
  int level = [ShadeCapability getLevelFromModel:self.deviceModel];
  [self updateDimmerUI:level];

  if ([self.delegate respondsToSelector:@selector(updateVentOpenness:)]) {
    [self.delegate deviceDetails:self updateShadeLevel:level];
  }
}

@end
