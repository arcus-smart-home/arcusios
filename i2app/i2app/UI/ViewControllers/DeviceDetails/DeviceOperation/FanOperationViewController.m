//
//  FanOperationViewController.m
//  i2app
//
//  Created by Arcus Team on 6/6/15.
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
#import "FanOperationViewController.h"
#import "UIImage+ScaleSize.h"
#import "DeviceControlViewController.h"
#import "FanCapability.h"
#import "DeviceNotificationLabel.h"
#import "UIViewController+AlertBar.h"
#import "SwitchCapability.h"


@interface FanOperationViewController ()

@property (weak, nonatomic) IBOutlet DeviceNotificationLabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stepLineBackgroup;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *medLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiLabel;
@property (weak, nonatomic) IBOutlet UIButton *fanControlButton;
@property (weak, nonatomic) IBOutlet UIButton *fanButton;

@end


@implementation FanOperationViewController {
    CGFloat _lowFanPosX;
    CGFloat _hiFanPosX;
    CGFloat _fanStepLength;
    
    __weak IBOutlet NSLayoutConstraint *_fanIconHightConstrain;
    NSString *_deviceState;
    
    NSInteger _currectSpeed;
    NSInteger _maxStep;
    id _fanSettingLock;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _maxStep = 3;
    _fanSettingLock = [[NSObject alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fanStepsLine setMaximumStep:_maxStep];
    [self.stepLineBackgroup setImage:[[UIImage imageNamed:@"DeviceFanSteps"] setAlpha:0.2f]];
    
    [self.offLabel setAttributedText:[FontData getString:[NSLocalizedString(@"off", nil) uppercaseString] withFont:FontDataTypeDeviceLabels]];
    [self.lowLabel setAttributedText:[FontData getString:[NSLocalizedString(@"low", nil) uppercaseString] withFont:FontDataTypeDeviceLabels]];
    [self.medLabel setAttributedText:[FontData getString:[NSLocalizedString(@"med", nil) uppercaseString] withFont:FontDataTypeDeviceLabels]];
    [self.hiLabel setAttributedText:[FontData getString:[NSLocalizedString(@"hi", nil) uppercaseString] withFont:FontDataTypeDeviceLabels]];
    
    [self.fanStepsLine setImage:[UIImage imageNamed:@"DeviceFanSteps"]];
    [self.fanStepsLine setFanController:self];
    
    // Don't allow clicks on the spinning fan.
    self.fanButton.userInteractionEnabled = NO;
    
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
    panRecognizer.cancelsTouchesInView = YES;
    [self.fanControlButton addGestureRecognizer:panRecognizer];
    
    _lowFanPosX = self.deviceController.edgeWidth + self.fanStepsLine.bounds.origin.x;
    _hiFanPosX = self.deviceController.edgeWidth + self.fanStepsLine.bounds.origin.x + self.fanStepsLine.bounds.size.width;
    _fanStepLength = (self.fanStepsLine.bounds.size.width / _maxStep);
    if (IS_IPHONE_5) {
        _fanIconHightConstrain.constant /= 2;
        _lowFanPosX -= 20;
    }
    int step = [FanCapability getSpeedFromModel:self.deviceModel];
    [self setFanAnimationSpeed:step];
}

- (void)setMaximumSpeed: (NSInteger)value {
    if (_maxStep == value) return;
    
    _maxStep = value;
    [self.fanStepsLine setMaximumStep:_maxStep];
    _fanStepLength = (self.fanStepsLine.bounds.size.width / _maxStep);
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];
    CGFloat x = button.center.x + translation.x;
    
    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled ||
        recognizer.state == UIGestureRecognizerStateFailed) {
        CGFloat value = x - _lowFanPosX;
        int step = nearbyint(value / _fanStepLength);
        [self selectStep:step];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (x < _lowFanPosX) {
            x = _lowFanPosX;
        }
        else if (x > _hiFanPosX) {
            x = _hiFanPosX;
        }
        
        button.center = CGPointMake(x, button.center.y);
        [recognizer setTranslation:CGPointZero inView:button];
        
        if (IS_IPHONE_5) {
            [self.fanStepsLine setProcess:(int)(x - self.deviceController.edgeWidth + 20)];
        }
        else {
            [self.fanStepsLine setProcess:(int)(x - self.deviceController.edgeWidth)];
        }
    }
}

- (void)setFanAnimationSpeed:(int)speed {
    [self.fanButton.layer removeAnimationForKey:@"rotationAnimation"];
    
    if (speed > 0) {
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * ((_maxStep /3) * speed)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INFINITY;
        
        [self.fanButton.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)displayFanStep:(int)step {
    if (step > _maxStep) {
        DDLogWarn(@"Fan speed cannot greater then maximum.");
        return;
    }
    
    _currectSpeed = step;
    
    CGFloat _pointx = step * _fanStepLength + self.deviceController.edgeWidth + self.fanStepsLine.bounds.origin.x;
    if (IS_IPHONE_5) {
        _pointx -= 16;
    }
    
    if (step <= _maxStep / 2) {
        self.fanControlButton.center = CGPointMake(_pointx, self.fanControlButton.center.y);
    }
    else if (step == 2) {
        self.fanControlButton.center = CGPointMake(_pointx - 5, self.fanControlButton.center.y);
    }
    else {
        self.fanControlButton.center = CGPointMake(_pointx - 7, self.fanControlButton.center.y);
    }
    [self.fanStepsLine setStep:step];
    
}

- (void)selectStep:(int)step {
    @synchronized (_fanSettingLock) {
        [self displayFanStep:step];
        [self setFanSpeed:step];
    }
}

#pragma mark - Send Change State
- (void)setFanSpeed:(int)step {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if (step == 0) {
            [FanCapability setSpeed:0
                            onModel:self.deviceModel];
            [SwitchCapability setState:kEnumSwitchStateOFF
                               onModel:self.deviceModel];
        } else {
            [SwitchCapability setState:kEnumSwitchStateON
                               onModel:self.deviceModel];
            [FanCapability setSpeed:(int)step
                            onModel:self.deviceModel];
        }
        [self.deviceModel commit];
    });
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    NSString *fanState = [SwitchCapability getStateFromModel:self.deviceModel];
    [self setMaximumSpeed:[FanCapability getMaxSpeedFromModel:self.deviceModel]];
    
    int step;
    if ([fanState isEqualToString:kEnumSwitchStateOFF]) {
        step = 0;
    }
    else {
        step = [FanCapability getSpeedFromModel:self.deviceModel];
    }

    [self setFanAnimationSpeed:step];
    [self displayFanStep:step];
    [self.view layoutIfNeeded];
}

@end




