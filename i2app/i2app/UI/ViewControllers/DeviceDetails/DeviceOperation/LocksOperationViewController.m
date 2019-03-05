//
//  LocksOperationViewController.m
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
#import "LocksOperationViewController.h"
#import "DoorLockCapability.h"
#import "DevicePowerCapability.h"
#import "PromiseKit/Promise.h"
#import "DeviceAttributeGroupView.h"
#import "DeviceDetailsLock.h"
#import "DeviceAdvancedCapability.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>

@interface LocksOperationViewController ()

@property (nonatomic, assign, readonly) DeviceDetailsLock *deviceOpDetails;
@property (atomic, assign) NSInteger errorBannerTag;

@end

@implementation LocksOperationViewController {
    
    BOOL  _animationIsRunning;
    BOOL  _rubberBandAnimationIsExpanded;
    
    UIView *_circle;
    
    DevicePercentageAttributeControl *_percentageControl;
    DeviceButtonBaseControl *_lockButton;
    DeviceButtonBaseControl *_buzzButton;
}

@dynamic deviceOpDetails;

#pragma mark - life cycle
- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityEventLabel | GeneralDeviceAbilityAttributesView | GeneralDeviceAbilityButtonsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animationIsRunning = NO;
    _lockButton = [[DeviceButtonBaseControl alloc] init];
    if (self.deviceOpDetails.hasBuzzInCapability) {
        _buzzButton = [[DeviceButtonBaseControl alloc] init];
        
        [self.buttonsView loadControl:_lockButton control2:_buzzButton];
    }
    else {
        [self.buttonsView loadControl:_lockButton];
    }
    
    [self.deviceOpDetails loadData:self.deviceLogo leftButton:_lockButton withRightButton:_buzzButton];
    
    _percentageControl = [DevicePercentageAttributeControl createWithBatteryPercentage:82];
    [self.attributesView loadControl:_percentageControl];

    if (IS_IPHONE_5) {
        self.eventToTopConstraint.constant = 25;
    }
}

#pragma mark - Dynamic Properties
- (DeviceDetailsLock *)deviceOpDetails {
    return (DeviceDetailsLock *)super.deviceOpDetails;
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
  if (self.isCenterMode) {
    [self.deviceOpDetails updateDeviceState:attributes initialUpdate:isInitial];
  }

  NSString *lockstate = [DoorLockCapability getLockstateFromModel:self.deviceModel];
  if ([lockstate isEqualToString:kEnumDoorLockLockstateLOCKED] || [lockstate isEqualToString:kEnumDoorLockLockstateLOCKING]) {
    [self startRubberBandContractAnimation];
  } else {
    [self startRubberBandExpandAnimation];
  }

  [self updateLockButtonState:lockstate];
  [self updateBuzzInButtonState:lockstate];

  NSInteger batteryState = [DevicePowerCapability getBatteryFromModel:self.deviceModel];
  [_percentageControl setPercentage:batteryState];

  NSDate *eventTime;
  NSString *eventText;
  self.eventLabel.hidden = ![DeviceDetailsLock getLastEvent:self.deviceModel eventText:&eventText eventTime:&eventTime];

  if (!self.eventLabel.hidden) {
    [self.eventLabel setTitle:eventText andTime:eventTime];
  }
  [self updateErrorBanner];
}

- (void) updateLockButtonState:(NSString *) lockstate {
    BOOL isLocked = [lockstate isEqualToString:kEnumDoorLockLockstateLOCKED] || [lockstate isEqualToString:kEnumDoorLockLockstateLOCKING];
    BOOL isJammed = [self.deviceModel isJammed];
    BOOL isChanging = !isJammed &&
      ([lockstate isEqualToString:kEnumDoorLockLockstateLOCKING] ||
       [lockstate isEqualToString:kEnumDoorLockLockstateUNLOCKING]);
    NSString *lockButtonText = isLocked ? NSLocalizedString(@"UNLOCK", nil) : NSLocalizedString(@"LOCK", nil);
    if (isJammed) {
      lockButtonText = NSLocalizedString(@"UNLOCK", nil);
    }
    [_lockButton setLabelText:lockButtonText];
    [_lockButton setUserInteractionEnabled:!isChanging];
    [_lockButton setAlpha:isChanging ? 0.6f : 1.0f];
}

- (void) updateBuzzInButtonState:(NSString *) lockstate {
  BOOL isLocked = [lockstate isEqualToString:kEnumDoorLockLockstateLOCKED];
  [_buzzButton setAlpha:isLocked ? 1.0f : 0.6f];
  [_buzzButton setUserInteractionEnabled:isLocked];
}

- (void)updateErrorBanner {
  if ([self.deviceModel isJammed]) {
    [self dismissErrorBanner];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      if(![self.deviceModel isJammed]){
        [self dismissErrorBanner];
        return;
      }
      self.errorBannerTag = [self popupLinkAlert:NSLocalizedString(@"Door lock is jammed", nil)
                                            type:AlertBarTypeYellowWarning
                                       sceneType:AlertBarSceneInDevice
                                       grayScale:NO
                                        linkText:NSLocalizedString(@"Get Support", nil)
                                        selector:@selector(getSupportPressed)
                                    displayArrow:YES];
    });
  } else {
    [self dismissErrorBanner];
  }
}

- (void)getSupportPressed {
  NSString *deviceTypeHint = [DeviceCapability getDevtypehintFromModel:self.deviceModel];
  NSURL *productSupportUrl = [NSURL productSupportUrlWithDeviceType:deviceTypeHint
                                                          productId:self.deviceModel.productId
                                                          devadvErr:@"warn_jam"];
  [[UIApplication sharedApplication] openURL:productSupportUrl];
}

- (void) dismissErrorBanner {
  if (self.errorBannerTag != NSNotFound) {
    [self closePopupAlert];
    self.errorBannerTag = NSNotFound;
  }
}

@end





