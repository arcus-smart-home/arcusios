//
//  SpringsBlindsViewController.m
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
#import "SpringsBlindsViewController.h"
#import "DeviceDetailsShade.h"
#import "ShadeCapability.h"
#import "DevicePowerCapability.h"

#define kShadeThrottlePeriod 0
#define kShadeQuiescentSeconds 30.0

@interface SpringsBlindsViewController ()

@property (nonatomic, assign, readonly) DeviceDetailsShade *deviceOpDetails;

@property (nonatomic, strong) DevicePercentageAttributeControl *percentageControl;
@property (nonatomic, strong) DevicePercentageAttributeControl *batteryControl;

@end

@implementation SpringsBlindsViewController

@dynamic deviceOpDetails;

- (DeviceDetailsShade *)deviceOpDetails {
  return (DeviceDetailsShade *)super.deviceOpDetails;
}

- (void)viewDidLoad {
  [self setShouldUpdateBrightness:NO];
  [super viewDidLoad];

  [super setOffLabels:NSLocalizedString(@"shut", nil)
           andOnLabel:NSLocalizedString(@"open", nil)];
  [super setThrottlePeriod:kShadeThrottlePeriod
             andQuiescence:kShadeQuiescentSeconds];

  self.percentageControl = [DevicePercentageAttributeControl createWithPercentage:82
                                                                            title:NSLocalizedString(@"open", nil)];
  self.batteryControl = [DevicePercentageAttributeControl createWithBatteryPercentage:0];

  [self.attributesView loadControl:self.percentageControl
                          control2:self.batteryControl];
}


- (void)loadDeviceAbilities {
  self.deviceAbilities = AdjusterDeviceAbilityAttributesView;
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {

  NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];

  [self.batteryControl setPercentage:batteryState];

  int shadeLevel = [ShadeCapability getLevelFromModel:self.deviceModel];

  NSString *shadeState = [ShadeCapability getShadestateFromModel:self.deviceModel];

  [self setAdjusterValue:shadeLevel];

  if (shadeLevel <= 25) {
    [self.percentageControl setText:NSLocalizedString(@"OFF", nil)];
  } else {
    if ([shadeState isEqualToString:kEnumShadeShadestateOK]) {
      [self.percentageControl setText:NSLocalizedString(@"OPEN", nil)];
    }
    if ([shadeState isEqualToString:kEnumShadeShadestateOBSTRUCTION]) {
      [self.percentageControl setText:NSLocalizedString(@"OBSTRUCTION", nil)];
    }
  }
}


#pragma mark - adjtster control for override
// for update value to platform
- (BOOL)submitChangedValue:(int)value becauseOf:(ValueChangeCause)reason{
  if (reason == ValueChangeCauseStoppedSliding) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [ShadeCapability setLevel:value onModel:self.deviceModel];
      [self.deviceModel commit];
    });
  }
    
  return !self.currentlySliding;
}

// for update UI change
- (void)adjusterValueChanged:(int)percentageValue {
  [self.percentageControl setPercentage:percentageValue];

}

- (void)handleTap:(id)sender {
  DDLogWarn(@"Tap %d",[self getAdjusterValue]);
}
@end
