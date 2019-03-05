//
//  DeviceOperationBaseController.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "DeviceOperationBaseController.h"
#import "DeviceControlViewController.h"
#import "PopupMessageViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceFirmwareUpdateListViewController.h"

#import "DeviceConnectionCapability.h"
#import "DeviceManager.h"
#import "ImageDownloader.h"
#import <PureLayout/PureLayout.h>
#import "AKFileManager.h"
#import "UIView+Subviews.h"

#import "UIViewController+AlertBar.h"
#import "UIImageView+WebCache.h"
#import "UIView+Blur.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"

#import "DeviceDetailsEmpty.h"
#import "DeviceMoreViewController.h"

#import "CameraCapability.h"
#import "DeviceOtaCapability.h"

#import "PresenceCapability.h"
#import "DeviceCapability.h"
#import <i2app-Swift.h>

#define kPoorSignalLevelThreshold 0 // <- threshold set to 0 till platform is able to manage signal strength. Previously was set to 15.

const int kRubberBandNormalSize = 1.00;
const int kRubberBandExpandedSize = 1.15;
const int kRubberBandAnimationStep = .05;

const int kCircleLogoTag = 12332;

@interface DeviceOperationBaseController ()

@property (nonatomic) SEL onClickEvent;
@property (atomic) BOOL isCreatedDeviceDetail;

@end

@implementation DeviceOperationBaseController {
    BOOL        _animationIsRunning;
    BOOL        _inCenterMode;
    BOOL        _rubberBandExpanded;
    UIView      *_circle;
    
    CGRect          _borderRect;
    UIBezierPath    *_shadowPath;
    
    BOOL        _userLeavedThisScreen;
    BOOL        _inFirmwareUpdate;
    BOOL        _inPoorSignal;
    BOOL        _inOffline;
    NSInteger   _firmwareUpgradeTag;
}

typedef void(^animationBlock)(void);


#pragma mark - Controller life cycle
+ (DeviceOperationBaseController *)createWithDeviceId:(NSString*)deviceId {
    DeviceOperationBaseController *controller = [self create];
    controller.deviceId = deviceId;
    controller.deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[DeviceModel addressForId:deviceId]];
    return controller;
}

+ (DeviceOperationBaseController *)create {
    DeviceOperationBaseController *controller = [[UIStoryboard storyboardWithName:@"DeviceOperation" bundle:nil] instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return controller;
}

+ (DeviceOperationBaseController *)createWithIdentifier:(NSString *)nibName {
    return [[[self class] alloc] initWithNibName:nibName bundle:nil];
}

+ (DeviceOperationBaseController *)createWithIdentifier:(NSString *)nibName withDeviceID:(NSString *)deviceID {
    DeviceOperationBaseController *controller = [[[self class] alloc] initWithNibName:nibName bundle:nil];
    controller.deviceId = deviceID;
    controller.deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[DeviceModel addressForId:deviceID]];

    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _firmwareUpgradeTag = NSNotFound;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    _animationIsRunning = NO;
    _inCenterMode = NO;
    _userLeavedThisScreen = NO;
    [self setDisableAlert:NO];
    
    _animationState = DeviceOperationAnimationStateNothing;
    
    [self setDeviceLogo];
    
    if (IS_IPHONE_5) {
        [self.centerLogoLocation setConstant: 75];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6P) {
        [self.centerLogoLocation setConstant: 75];
    }
    
    [self createDeviceDetails];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _userLeavedThisScreen = NO;
    [self setDisableAlert:NO];

    if (_firmwareUpgradeTag > 0) {
        [self getPopupAlertWithTag:_firmwareUpgradeTag].hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _userLeavedThisScreen = NO;
    [self setDisableAlert:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setDisableAlert:YES];
    [self closePopupAlert];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _inOffline = NO;
    _userLeavedThisScreen = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (_firmwareUpgradeTag > 0) {
        [self getPopupAlertWithTag:_firmwareUpgradeTag].hidden = YES;
    }
}

- (void)createDeviceDetails {
    // This is the DeviceDetails factory
    if (!_isCreatedDeviceDetail) {
        _isCreatedDeviceDetail = YES;
        if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
            NSString *deviceOpDetailClassName = DeviceTypeToDeviceModel(self.deviceModel.deviceType);
            Class opDetailClass = NSClassFromString(deviceOpDetailClassName);
            if (!opDetailClass) {
                opDetailClass = [DeviceDetailsEmpty class];
            }
            _deviceOpDetails = [[opDetailClass alloc] initWithDeviceId:self.deviceId];
        }
        else if (![self.deviceModel isKindOfClass:[HubModel class]]) {
            DDLogInfo(@"createDeviceDetails: Class [%@] is supposed to be a DeviceModel.", [[self.deviceModel class] description]);
        }
    }
}

#pragma mark - Infinite loop events
- (void)onClick:(id)sender {
    if (self.deviceController && self.onClickEvent) {
        [self.deviceController performSelector:self.onClickEvent withObject:nil afterDelay:0.f];
    }
}

- (void)edgeMode:(SEL)onClick {
    self.onClickEvent = nil;
    self.onClickEvent = onClick;
    _inCenterMode = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (UIView *item in self.view.subviews) {
        if ([item isKindOfClass:[UIView class]] && item != self.deviceLogo) {
            [item setAlpha:0.0f];
        }
    }
    
    if (self.deviceLogo) {
        if (IS_IPHONE_5) {
            self.deviceLogo.layer.transform = CATransform3DMakeScale(.55, .55, 1);
        }
        else {
            self.deviceLogo.layer.transform = CATransform3DMakeScale(.65, .65, 1);
        }
    }
    
    [self closePopupAlert];
    
    _inFirmwareUpdate = NO;
    _firmwareUpgradeTag = NSNotFound;
    _inPoorSignal = NO;
    _inOffline = NO;
}

- (void)centerMode {
    self.onClickEvent = nil;
    _inCenterMode = YES;
    
    for (UIView *item in self.view.subviews) {
        if ([item isKindOfClass:[UIView class]] && item != self.deviceLogo) {
            [item setAlpha:1.0f];
        }
    }
    
    [self addNormalNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:[self deviceModel]];
    [self updateDeviceLogo];
    
    if (self.deviceLogo) {
        self.deviceLogo.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    }
}

- (void)parentSwipe:(BOOL)enable {
    [self.deviceController setEnableSwipe:enable];
}

#pragma mark - notification
- (void)addNormalNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceStateChangedNotification:) name:self.deviceModel.modelChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionSignalChangedNotification:) name:[Model attributeChangedNotification:kAttrDeviceConnectionSignal] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChangedNotification:) name:[Model attributeChangedNotification:kAttrDeviceConnectionState] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOTAStatusNotificationReceived:)
                                                 name:[Model attributeChangedNotification:kAttrDeviceOtaStatus]
                                               object:nil];
}

#pragma mark - Device view life cycle
- (void)deviceWillAppear:(BOOL)animated {
    [self setFooterToPink:NO];
    [self setFooterSideText:nil];
}

- (void)deviceDidAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{

        Model *_currentModel = (Model *)[[[CorneaHolder shared] modelCache] fetchModel:self.deviceModel.address];

        [self updateDeviceState:[_currentModel get] initialUpdate:YES];
        [self checkDeviceIsOfflineOrUpdating];
        [self checkFirmwareUpgrade];
        [self updateDeviceState:[_currentModel get] initialUpdate:NO];
    });
}

- (void)deviceWillDisappear:(BOOL)animated {
    
}

- (void)deviceDidDisappear:(BOOL)animated {
    _inOffline = NO;
}

#pragma mark - Update device image
- (BOOL)updateDeviceLogo {
    UIImage *logoImage = [[AKFileManager defaultManager] cachedImageForHash:self.deviceModel.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
    if (logoImage) {
        CGSize logoSize = self.deviceLogo.bounds.size;
        logoSize.height -= 9;
        logoSize.width -= 9;
        logoImage = [logoImage exactZoomScaleAndCutSizeInCenter:logoSize];
        logoImage = [logoImage roundCornerImageWithsize:logoSize];
        if ([self.deviceLogo isKindOfClass:[UIImageView class]]) {
            [self.deviceLogo setImage:logoImage];
        }
        return YES;
    }
    return NO;
}

- (void)setDeviceLogo {
  [self.deviceLogo setClipsToBounds:NO];
  self.deviceLogo.layer.cornerRadius = self.deviceLogo.bounds.size.width / 2.0f;
  self.deviceLogo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
  self.deviceLogo.layer.borderWidth = 5.0f;

  if (![self updateDeviceLogo] && !self.deviceLogo.image) {
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:self.deviceModel]
                           withDevTypeId:[self.deviceModel devTypeHintToImageName]
                         withPlaceHolder:nil
                                 isLarge:YES
                            isBlackStyle:NO]
    .then(^(UIImage *image) {
      image = [image roundCornerImageWithsize: CGSizeMake(180, 180)];
      self.deviceLogo.image = image;
    });
  }
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ must be overriden in derived class", NSStringFromSelector(_cmd)];
}

- (void)getDeviceStateChangedNotification:(NSNotification *)note {
  // Ensure that nest thermostats react to all changes
  if (self.deviceModel.deviceType == DeviceTypeThermostatNest) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateDeviceState:note.object initialUpdate:NO];
    });
    return;
  }

  if ([self.deviceId isEqualToString:((Model *)note.userInfo[Constants.kModel]).modelId]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateDeviceState:note.object initialUpdate:NO];
    });
  }
}

- (void)connectionSignalChangedNotification:(NSNotification *)note {
    if ([self isHub]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkPoorSignalWithDevice];
    });
}

- (void)connectionStateChangedNotification:(NSNotification *)note {
    if ([self isHub]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkDeviceIsOfflineOrUpdating];
    });
    
}

- (void)deviceOTAStatusNotificationReceived:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self checkFirmwareUpgrade];
    });
}

- (void)checkFirmwareUpgrade  {
    // Not all device models are device models... some are hub models which do respond to isUpdatingFirmware.
    if ([self.deviceModel respondsToSelector:@selector(isUpdatingFirmware)] && [self.deviceModel isUpdatingFirmware]) {
        if (!_inFirmwareUpdate) {
            _inFirmwareUpdate = YES;
            [self startFirmwareUpdate];
        }
    }
    else {
        if (_inFirmwareUpdate) {
            _inFirmwareUpdate = NO;
            [self stopFirmwareUpdate];
        }
    }
}

- (BOOL)inFirmwareUpdate {
    return _inFirmwareUpdate;
}


- (void)startFirmwareUpdate {
    [self startFirmwareUpdate:YES];
}

- (void)startFirmwareUpdate:(BOOL)grayScale {
    _firmwareUpgradeTag = [self popupLinkAlert:NSLocalizedString(@"Firmware Updating...", nil)
                                          type:AlertBarUpdateFirmware
                                     sceneType:AlertBarSceneInDevice
                                     grayScale:grayScale
                                      linkText:NSLocalizedString(@"Show All", nil)
                                      selector:@selector(showDeviceFirmwareUpdateList)
                                  displayArrow:YES];
}

- (void)stopFirmwareUpdate {
    [self closePopupAlert];
    _firmwareUpgradeTag = NSNotFound;
}

- (BOOL)isHub {
    return [self.deviceModel isKindOfClass:[HubModel class]];
}

- (BOOL)hasPresence:(DeviceModel *)deviceModel {
    return [deviceModel.caps containsObject:[PresenceCapability namespace]];
}

- (BOOL)isCenterMode {
    return _inCenterMode;
}

#pragma mark - Base animations
// Switch and Plug
- (void)startShiningAnimation {
    if (_animationState == DeviceOperationAnimationStateStartedShining) {
        return;
    }
    _animationState = DeviceOperationAnimationStateStartedShining;
    
    if (!_inCenterMode) {
        return;
    }
    [self.deviceLogo animateStartShining:^{
    } withBoarderWidth:20.0f];
}

// For Switch and Plug
- (void)stopShiningAnimation {
    if (_animationState == DeviceOperationAnimationStateStopedShining || !_inCenterMode) {
        return;
    }
    _animationState = DeviceOperationAnimationStateStopedShining;
    
    [self.deviceLogo animateStopShining:^{
    } withBoarderWidth:5.0f];
}

- (void)startRubberBandExpandAnimation {
    if (!_inCenterMode) {
        return;
    }
    
    [self.deviceLogo animateRubberBandExpand:^{
        self.deviceLogo.layer.borderWidth = 0.0f;
    }];
}

- (void)startRubberBandContractAnimation {
    if (!_inCenterMode) {
        return;
    }
    
    [self.deviceLogo animateRubberBandContract:^{
        self.deviceLogo.layer.borderWidth = 5.0f;
    }];
}

#pragma mark - Popup window
- (void)popup:(PopupSelectionBaseContainer *)container {
    _popupWindow = [PopupSelectionWindow popup:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)closePopup {
    [_popupWindow close];
    [PopupMessageViewController closePopup];
}

- (void)popupErrorTitle:(NSString *)title withMessage:(NSString *)message {
    [self closePopup];
    [PopupMessageViewController popupErrorWindow:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                           title:title
                                         message:message];
}

#pragma mark - Alert bar
- (NSInteger)showNoConnectionAlertBar {
    return [self popupLinkAlert:NSLocalizedString(@"No Connection", nil)
                           type:AlertBarTypeNoConnection
                      sceneType:AlertBarSceneInDevice
                      grayScale:YES
                       linkText:NSLocalizedString(@"Get Support", nil)
                       selector:@selector(didTapNoConnectionAlertBar)
                   displayArrow:YES];
 }

- (void)didTapNoConnectionAlertBar {
    [[UIApplication sharedApplication] openURL: NSURL.SupportDeviceTroubleshooting];
}

#pragma mark - Poor signal handling
- (BOOL)isPoorSignal:(DeviceModel *)device {
    return [DeviceConnectionCapability getSignalFromModel:device] < kPoorSignalLevelThreshold;
}

- (void)checkPoorSignalWithDevice {
    
    if ([self isPoorSignal:self.deviceModel]) {
        if (!_inPoorSignal) {
            [self popupAlert:NSLocalizedString(@"Poor Signal", nil) type: AlertBarTypePoorConnection canClose:YES sceneType:AlertBarSceneInDevice];
            _inPoorSignal = YES;
        }
    }
    else {
        if (_inPoorSignal) {
            _inPoorSignal = NO;
            [self closePopupAlert];
        }
    }
}

- (void)checkDeviceIsOfflineOrUpdating {
    if (!self.isCenterMode || _userLeavedThisScreen) {
        return;
    }

    DeviceModel *currentDevice = self.deviceModel;
    
    // If the hub is down, then all devices should show offline
    if ([[[CorneaHolder shared] settings].currentHub isDown] && !_inOffline) {
        _inOffline = YES;
        
        if ([self.deviceController.tabBarController.selectedViewController isKindOfClass: [DeviceMoreViewController class]]) {
            if (self.deviceController.tabBarController.selectedViewController.navigationController.presentationController != nil) {
                return;
            }
        }

        if (![currentDevice.getCapabilities containsObject:WiFiCapability.namespace]) {
            [self showDeviceOffline];
        } else {
            if ([currentDevice isDeviceOffline]) {
                _inOffline = YES;
                [self showDeviceOffline];
            } else if (![currentDevice isDeviceOffline]) {
                _inOffline = NO;
                [self showDeviceOnline];
            }
        }
        return;
    }
    if (![self hasPresence:currentDevice]) {
        if ([currentDevice isDeviceOffline] && !_inOffline) {
            _inOffline = YES;
            [self showDeviceOffline];
        }
        else if (![currentDevice isDeviceOffline] && _inOffline) {
            _inOffline = NO;
            [self showDeviceOnline];
        }
    }
    
    if ([self.deviceController.tabBarController.selectedViewController isKindOfClass: [DeviceMoreViewController class]]) {
        [self showDeviceOnline];
    }
}

- (void)showDeviceOffline {
    for (UIView *view in [self.view allSubviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 0.4f;
            view.userInteractionEnabled = NO;
        }
    }
    
    [self showNoConnectionAlertBar];
}

- (void)showDeviceOnline {
    for (UIView *view in [self.view allSubviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.alpha = 1.f;
            view.userInteractionEnabled = YES;
        }
    }
    
    [self closePopupAlert];
}

- (void)showDeviceFirmwareUpdateList {
    _inFirmwareUpdate = NO;
    [self.deviceController.navigationController pushViewController:[DeviceFirmwareUpdateListViewController create] animated:YES];
}

#pragma mark - footer style control
- (void)setFooterToPink:(BOOL)status {
    if (status) {
        [self.deviceController setFooterColor:pinkAlertColor];
    }
    else {
        [self.deviceController setFooterColorToClean];
    }
}
- (void)setFooterSideText:(NSString *)text {
    [self.deviceController setFooterLeftText:text];
}

#pragma - Colored Overlay

- (void)addColoredOverlay:(UIColor*)color {
    [self.deviceController.tabBarController addColoredOverlay:color withOpacity:0.2];
}

- (void)removeColoredOverlay {
    [self.deviceController.tabBarController addDarkOverlay:BackgroupOverlayLightLevel];
}


@end




