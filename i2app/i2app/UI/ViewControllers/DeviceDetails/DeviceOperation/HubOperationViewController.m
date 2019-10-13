//
//  HubOperationViewController.m
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
@import Cornea;
#import "HubOperationViewController.h"
#import "DeviceTextAttributeControl.h"
#import "DeviceTextIconAttributeControl.h"
#import "UIViewController+AlertBar.h"
#import "HubCapability.h"
#import "HubNetworkCapability.h"
#import "HubPowerCapability.h"

@interface HubOperationViewController () <CellularBackupCallback, BannerPresenterCallback>

@property (nonatomic, strong) IBOutlet UIImageView *cellularImageView;
@property (nonatomic, strong) CellularBackupPresenter *cellularBackupPresenter;
@property (nonatomic, strong) BannerPresenter *bannerPresenter;

@end

typedef NS_ENUM(NSInteger, HubBannerType) {
    Offline = 1,
    Battery,
    LteActivateDevice,
    LteUpdatePlan,
    LteConfigureDevice
};

@implementation HubOperationViewController {
    DeviceTextAttributeControl *connectControl;
    DeviceTextIconAttributeControl *powerControl1;
    DeviceTextWithUnitAttributeControl *powerControl2;
    DeviceTextIconAttributeControl *powerControl;
}

+ (DeviceOperationBaseController *)createWithDeviceId:(NSString *)deviceId {
    DeviceOperationBaseController *controller = [[UIStoryboard storyboardWithName:@"DeviceOperation" bundle:nil] instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];

    NSString *address = [HubModel addressForId:deviceId];
    controller.deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];

    return controller;
}

- (void)loadDeviceAbilities {
    self.deviceAbilities = GeneralDeviceAbilityButtonsView | GeneralDeviceAbilityAttributesView;
}

- (void)setDeviceLogo {
  [self.deviceLogo setClipsToBounds:NO];
  self.deviceLogo.layer.cornerRadius = self.deviceLogo.bounds.size.width / 2.0f;
  self.deviceLogo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
  self.deviceLogo.layer.borderWidth = 5.0f;

  if (![self isHub]) {
    // In this case something has gone wrong but we could fail gracefully
    [super setDeviceLogo];
    return;
  }
  HubModel *hub = (HubModel *)self.deviceModel;
  NSString *productId = nil;
  NSString *hubModel = [HubCapability getModelFromModel:hub];
  if ([hubModel isEqualToString:@"IH300"]){
    productId = @"dee001";
  }
  if (![self updateDeviceLogo] && !self.deviceLogo.image) {
    [ImageDownloader downloadDeviceImage:productId
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


- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshDevice];

    connectControl = [DeviceTextAttributeControl create:NSLocalizedString(@"connect", nil) withValue:@"-"];
    powerControl1 = [DeviceTextIconAttributeControl create:NSLocalizedString(@"power", nil) withValue:@"-" andIcon:[UIImage imageNamed:@"HubPower"]];
    [self.attributesView loadControl:connectControl control2:powerControl1];

}

- (void)deviceWillAppear:(BOOL)animated {
    [super deviceWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubChangedNotification:)
                                                 name: [Model attributeChangedNotification:kAttrHubState]
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubChangedNotification:)
                                                 name: [Model attributeChangedNotification:kAttrHubPowerSource]
                                               object:nil];
  
    [self setUpViews:nil];
}

- (void)deviceWillDisappear:(BOOL)animated {
    [super deviceWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.bannerPresenter = nil;
    self.cellularBackupPresenter = nil;
}

- (void)deviceDidAppear:(BOOL)animated {
    [super deviceDidAppear:animated];

    self.bannerPresenter = [[BannerPresenter alloc] initWithCallback:self];

    self.cellularBackupPresenter = [[CellularBackupPresenter alloc] initWithCallback:self
                                                                 subsystemController:[SubsystemsController sharedInstance]
                                                                  notificationCenter:[NSNotificationCenter defaultCenter]];
}

- (void)refreshDevice {
  if (self.deviceModel) {
    HubModel *model = (HubModel *)self.deviceModel;

    [model refresh].then(^(id obj) {
      [self setUpViews:nil];
    });
  }
  [self.navigationController popToRootViewControllerAnimated:false];
}

- (void)setUpViews:(HubModel *)incHub {
    if (incHub != nil) {
        self.deviceModel = (DeviceModel *)incHub;// proof OOP isn't the best
    }
    HubModel *hub = (HubModel *)self.deviceModel;
    if (![self isHub]) {
        return;
    }
    NSString *attribute = [HubNetworkCapability getTypeFromModel:hub];
    if (attribute.length > 0) {
        if ([attribute isEqualToString: kEnumHubNetworkTypeETH]) {
            connectControl = [DeviceTextAttributeControl create:NSLocalizedString(@"connect", nil) withValue:@"BROADBAND"];
        }
        else if ([attribute isEqualToString: kEnumHubNetworkType3G]) {
            connectControl = [DeviceTextAttributeControl create:NSLocalizedString(@"connect", nil) withValue:@"CELLULAR"];
        }
        else {
            connectControl = [DeviceTextAttributeControl create:NSLocalizedString(@"connect", nil) withValue:attribute];
        }
    }
    else {
        connectControl = [DeviceTextAttributeControl create:NSLocalizedString(@"connect", nil) withValue:@"-"];
    }


    if (![hub isRunningOnBattery]) {
        powerControl1 = [DeviceTextIconAttributeControl create:NSLocalizedString(@"power", nil) withValue:@"AC" andIcon:[UIImage imageNamed:@"HubPower"]];
        [self.attributesView loadControl:connectControl control2:powerControl1];
    }
    else {
        int batteryLevel = [HubPowerCapability getBatteryFromModel:hub];
        NSString *batteryString = [NSString stringWithFormat:@"%d", batteryLevel];
        powerControl2 = [DeviceTextWithUnitAttributeControl create:NSLocalizedString(@"Battery", nil) withValue:batteryString andUnit:@"%"];
        [self.attributesView loadControl:connectControl control2:powerControl2];
    }
}

#pragma mark - Update State
- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
}

- (void)hubChangedNotification:(NSNotification *)note {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf) {
            [self checkHubStates];
        }
    });
}

// Main Thread Only Function
- (void)checkHubStates {
    if (![self isHub]) {
        return;
    }
    HubModel *hub = (HubModel *)self.deviceModel;
    if ([hub isDown] &&
        ![self.bannerPresenter containsBanner:AlertBarTypeNoConnection]) {
        Banner *banner = [[Banner alloc] init];
        banner.title = NSLocalizedString(@"No Connection", nil);
        banner.subtitle = @"Get Support";
        banner.alertType = AlertBarTypeNoConnection;
        banner.sceneType = AlertBarSceneInDevice;
        banner.priority = Offline;
        banner.bannerType = Offline;
        banner.action = @"didTapNoConnectionAlertBar";
        [self.bannerPresenter addBanner:banner];
    }
    else if ([hub isRunningOnBattery] &&
         ![self.bannerPresenter containsBanner:AlertBarTypeLowBattery]) {
        Banner *banner = [[Banner alloc] init];
        banner.title = NSLocalizedString(@"Running on Battery", comment: @"");
        banner.alertType = AlertBarTypeLowBattery;
        banner.sceneType = AlertBarSceneInDevice;
        banner.subtitle = @"";
        banner.priority = Battery;
        banner.bannerType = Battery;
        banner.action = nil;
        [self.bannerPresenter addBanner:banner];
    }
    else {
        [self.bannerPresenter removeBanner:AlertBarTypeLowBattery];
        [self.bannerPresenter removeBanner:AlertBarTypeNoConnection];
    }
    [self setUpViews:nil];
}

- (BOOL)isHub {
    return [self.deviceModel isKindOfClass:[HubModel class]];
}

#pragma mark - No connection alert bar
- (void)didTapNoConnectionAlertBar {
    [[UIApplication sharedApplication] openURL: NSURL.SupportHub options:@{} completionHandler:nil];
}

#pragma mark - Cellular Backup Callback

- (void)showOnBroadband {
    // Remove Cell Image
    self.cellularImageView.hidden = YES;
}

- (void)showOnCellularBackup {
    // Show Cell Image
    self.cellularImageView.hidden = NO;
}

- (void)showNeedsServicePlan {
    // Remove Cell Image
    self.cellularImageView.hidden = YES;

    // Show Banner
    if (![self.bannerPresenter containsBanner:LteActivateDevice]) {
        Banner *banner = [[Banner alloc] init];
        banner.title = NSLocalizedString(@"Your Backup Cellular service has been suspended. Please call the Arcus Support Team", nil);
        banner.subtitle = @"1-0";
        banner.alertType = AlertBarTypeClickableWarning;
        banner.sceneType = AlertBarSceneInDashboard;
        banner.priority = LteActivateDevice;
        banner.bannerType = LteActivateDevice;
        banner.action = @"callSupport";

        [self.bannerPresenter addBanner:banner];
    }
}

- (void)showNeedsConfiguration {
    // Remove Cell Image
    self.cellularImageView.hidden = YES;

    // Show Banner
    if (![self.bannerPresenter containsBanner:LteConfigureDevice]) {
        Banner *banner = [[Banner alloc] init];
        banner.title = NSLocalizedString(@"Cellular device configuration required. Please call the Arcus Support Team", nil);
        banner.subtitle = @"1-0";
        banner.alertType = AlertBarTypeClickableWarning;
        banner.sceneType = AlertBarSceneInDashboard;
        banner.priority = LteConfigureDevice;
        banner.bannerType = LteConfigureDevice;
        banner.action = @"callSupport";

        [self.bannerPresenter addBanner:banner];
    }
}

- (void)showNeedsActivation {
    // Remove Cell Image
    self.cellularImageView.hidden = YES;

    // Show Banner
    if (![self.bannerPresenter containsBanner:LteUpdatePlan]) {
        Banner *banner = [[Banner alloc] init];
        banner.title = NSLocalizedString(@"Update your service plan to include Backup Cellular", nil);
        banner.alertType = AlertBarTypeWarning;
        banner.sceneType = AlertBarSceneInDashboard;
        banner.priority = LteUpdatePlan;
        banner.bannerType = LteUpdatePlan;

        [self.bannerPresenter addBanner:banner];
    }
}

- (void)removeCellularBackupBanner {
    if ([self.bannerPresenter containsBanner:LteActivateDevice]) {
        [self.bannerPresenter removeBanner:LteActivateDevice];

    }

    if ([self.bannerPresenter containsBanner:LteUpdatePlan]) {
        [self.bannerPresenter removeBanner:LteUpdatePlan];

    }

    if ([self.bannerPresenter containsBanner:LteConfigureDevice]) {
        [self.bannerPresenter removeBanner:LteConfigureDevice];
    }
}

- (void)callSupport {
    NSString *phNo = @"+18554694747";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];

    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

#pragma mark - Banner Presenter

- (void)showBanner:(Banner *)banner {
    NSInteger tag = -1;

    switch (banner.bannerType) {
        case Offline: {
            tag = [self popupLinkAlert:banner.title
                                  type:banner.alertType
                             sceneType:banner.sceneType
                             grayScale:YES
                              linkText:banner.subtitle
                              selector:NSSelectorFromString(banner.action)
                          displayArrow:YES];

            banner.tag = tag;

            break;
        }
        case Battery: {
            tag = [self popupAlert:banner.title
                              type:banner.alertType
                          canClose:YES
                         sceneType:banner.sceneType];

            banner.tag = tag;

            break;
        }
        case LteConfigureDevice:
        case LteActivateDevice: {
            tag = [self popupAlert:banner.title
                              type:banner.alertType
                          canClose:NO
                         sceneType:banner.sceneType
                      bottomButton:banner.subtitle
                          selector:NSSelectorFromString(banner.action)];

            banner.tag = tag;

            break;
        }
        case LteUpdatePlan: {
            tag = [self popupLinkAlert:banner.title
                                  type:banner.alertType
                             sceneType:banner.sceneType
                              linkText:banner.subtitle
                              selector:NSSelectorFromString(banner.action)];

            banner.tag = tag;
            
            break;
        }
    }
}

- (void)removeBanner:(NSInteger)tag {
    [self closePopupAlertWithTag:tag];
}

- (void)removeAllBanners {
    [self closePopupAlert:NO];
}

@end
