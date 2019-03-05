//
//  AdjusterOperationController.m
//  i2app
//
//  Created by Arcus Team on 7/24/15.
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
#import "AdjusterOperationController.h"
#import <PureLayout/PureLayout.h>
#import <i2app-Swift.h>

#define kCommitIntervalInSecond 1.0
#define kMinBrightness 0
#define kMaxBrightness 100
#define kDefaultBrightness 60
#define kDefaultSecondsPerUpdate 1.0
#define kDefaultQuiescenceSec 12.0      // Some devices (like Osram bulbs) may take 10 secs to reach target brightness

@interface AdjusterOperationController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attributeViewConstraint;
@property (strong, nonatomic) EFCircularSlider *circularSlider;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dimmerView;
@property (weak, nonatomic) IBOutlet UIView *tapOff;

@property (nonatomic, assign, readwrite) BOOL currentlySliding;
@property (nonatomic, assign) BOOL updateBrightness;
@property (strong, nonatomic) ThrottledExecutor* throttle;

@end

@implementation AdjusterOperationController

+ (DeviceOperationBaseController *)create {
    AdjusterOperationController *vc = (AdjusterOperationController *)[super createWithIdentifier:@"AdjusterOperationController"];
    vc.updateBrightness = true;
    return vc;
}

- (void)loadDeviceAbilities {
    _deviceAbilities = AdjusterDeviceAbilityAttributesView | AdjusterDeviceAbilityButtonsView;
}

- (void)setShouldUpdateBrightness:(BOOL)status {
    _updateBrightness = status;
    if (self.circularSlider) {
        [self.circularSlider setShouldUpdateBrightness:status];
    }
}

- (void)setOffLabels:(NSString *)offLabel andOnLabel:(NSString *)onLabel {
    [self.offLabel setAttributedText:[FontData getString:offLabel withFont:FontDataTypeDeviceDimmerOn]];
    [self.onLabel setAttributedText:[FontData getString:onLabel withFont:FontDataTypeDeviceDimmerOn]];
}

- (void) setThrottlePeriod:(NSTimeInterval) period andQuiescence:(NSTimeInterval) quiesence {
    self.throttle = [[ThrottledExecutor alloc] initWithThrottlePeriodSec:period quiescencePeriodSec:quiesence];
}

- (int)getAdjusterValue {
    return (int)self.circularSlider.currentValue;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDeviceAbilities];
    self.currentlySliding = NO;
    self.throttle = [[ThrottledExecutor alloc] initWithThrottlePeriodSec:kDefaultSecondsPerUpdate quiescencePeriodSec:kDefaultQuiescenceSec];
    
    [_attributesView setHidden:!(_deviceAbilities & AdjusterDeviceAbilityAttributesView)];
    [_buttonsView setHidden:!(_deviceAbilities & AdjusterDeviceAbilityButtonsView)];
    
    if ((_deviceAbilities & AdjusterDeviceAbilityButtonsView) && (_deviceAbilities & AdjusterDeviceAbilityAttributesView)) {
        if (IS_IPHONE_5) {
            _buttonViewConstraint.constant = 40;
            _attributeViewConstraint.constant = 140;
            _buttonsView.transform = CGAffineTransformMakeScale(0.8, 0.8);
            _attributesView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }
        else {
            _buttonViewConstraint.constant = 50;
            _attributeViewConstraint.constant = 115;
        }
    }
    else {
        _attributeViewConstraint.constant = 50;
        _buttonViewConstraint.constant = 40;
    }
    
    if (IS_IPHONE_5) {
        _attributeViewConstraint.constant /= 2;
    }
    
    [self.view layoutIfNeeded];

    
    self.deviceLogo.layer.borderWidth = 0.0;
    [self setOffLabels:@"" andOnLabel:@""];
    
    CGRect sliderFrame = CGRectMake(self.dimmerView.frame.origin.x-161.5-20, self.dimmerView.frame.origin.y-10-20, self.dimmerView.frame.size.width-10+40, self.dimmerView.frame.size.height-10+40);
    
    self.circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    self.circularSlider.heightPadding = 10.0f;
    self.circularSlider.widthPadding = 10.0f;
    self.circularSlider.backgroundColor = [UIColor clearColor];
    self.circularSlider.snapToLabels = YES;
    self.circularSlider.lineWidth = 30;
    self.circularSlider.delegate = self;
    [self.circularSlider setShouldUpdateBrightness:_updateBrightness];
    
    self.circularSlider.handleColor = [UIColor whiteColor];
    [self.circularSlider setUnfilledColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    [self.circularSlider setFilledColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
    [self.circularSlider setLabelDisplacement:30.0f];
    [self.view insertSubview:self.circularSlider belowSubview:self.tapOff];
    [self.circularSlider autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.circularSlider autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.deviceLogo withOffset:-36.0f];
    
    self.tapOff.backgroundColor = [UIColor clearColor];
    self.tapOff.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.tapOff addGestureRecognizer:tgr];
}

- (void)submitCurrentValue:(ValueChangeCause)cause {
    if ((int)self.circularSlider.currentValue > kMaxBrightness) {
        [self submitChangedValue:kMaxBrightness becauseOf:cause];
    } else {
        [self submitChangedValue:(int)self.circularSlider.currentValue becauseOf:cause];
    }
}

- (void)setAdjusterValue:(int)percent {

    // Don't let view (i.e., platform update) change slider value until the user has stopped interacting with the control
    [_throttle executeAfterQuiescence:^{

        __block int percentage = percent;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (percentage > kMaxBrightness) {
                percentage = kMaxBrightness;
            }
        
            if (percentage < kMinBrightness) {
                percentage = kMinBrightness;
            }
        
            [self.circularSlider setValueInPercentage:percentage];
            [self adjusterValueChanged:percentage];
        });
    }];
}

#pragma mark - adjtster control for override
- (BOOL)submitChangedValue:(int)value {
    [NSException raise:NSInternalInconsistencyException format:@"Override in derived class"];

    return YES;
}

- (void)handleTap:(id)sender {
    [self submitCurrentValue:ValueChangeCauseTapped];
}

- (void)adjusterValueChanged:(int)percentageValue {
    
}

#pragma mark - EFCircleSliderDelegate

- (void)startSliding {
    self.currentlySliding = YES;
 }

- (void)endSliding {
    self.currentlySliding = NO;

    [_throttle execute:^{
        [self submitCurrentValue:ValueChangeCauseStoppedSliding];
    }];
}

- (void)isSliding {
    self.currentlySliding = YES;
    
    // Throttle will assure submission occurs no more frequently than throttle period
    [_throttle execute:^{
        [self submitCurrentValue:ValueChangeCauseSliding];
    }];
}

#pragma mark - Circular Slider Color

- (void)setSliderBarColor:(UIColor*)color {
    [self.circularSlider setFilledColor:[color colorWithAlphaComponent:0.4]];
}

@end
