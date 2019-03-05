//
//  DeviceControlViewController.m
//  i2app
//
//  Created by Arcus Team on 5/30/15.
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
#import "DeviceControlViewController.h"
#import "DeviceDetailsTabBarController.h"
#import "UIColor+Convert.h"
#import <PureLayout/PureLayout.h>
#import "DeviceManager.h"
#import "DeviceOperationBaseController.h"
#import "EFCircularSlider.h"
#import "Capability.h"

#import "UIViewController+AlertBar.h"
#import "ImagePaths.h"
#import "UnknownDeviceViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "DeviceController.h"

#import "DeviceOtaCapability.h"
#import "DeviceFirmwareUpdateListViewController.h"
#import "DeviceAdvancedCapability.h"
#import "UIView+Subviews.h"
#import "GeneralDeviceOperationController.h"

@interface DeviceControlViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSString *currentDeviceId;

@property (nonatomic, strong, readonly) DeviceOperationBaseController *centerDevice;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomArea;
@property (weak, nonatomic) IBOutlet UILabel *footerLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *footerLogo;
@property (weak, nonatomic) IBOutlet UIImageView *c2cLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerIconCenterConstraint;
@property (weak, nonatomic) IBOutlet UILabel *footerUncertifiedLabel;

@property (readwrite, nonatomic) CGFloat edgeWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *venderLogoWidth;

- (void)addCenterDevice:(DeviceOperationBaseController *)deviceController;
- (void)addLeftDevice:(DeviceOperationBaseController *)deviceController;
- (void)addRightDevice:(DeviceOperationBaseController *)deviceController;

- (void)fetchVendorImage:(UIImageView *)vendorImageView baseViewController:(DeviceOperationBaseController *)baseController;

@end

@implementation DeviceControlViewController {
    DeviceOperationBaseController *_leftDevice;
    DeviceOperationBaseController *_rightDevice;
    
    NSLayoutConstraint *_leftPosition;
    NSLayoutConstraint *_centerPosition;
    NSLayoutConstraint *_rightPosition;
    
    CGFloat _centerWidth;
    BOOL _animationRunning;
    
    NSMutableDictionary *_popupViews;
}

const CGFloat DCDisplayPercentage = 0.86f;
const CGFloat DCEdgeOverViewPercentage = 1.5f;
const CGFloat DCAnimationTime = .5f;

static UIImageView *_arcusImageView;

@dynamic deviceModel;

#pragma mark - Life Cycle
+ (DeviceControlViewController *)createWithTabBarController:(DeviceDetailsTabBarController *)tabBar andDeviceModel:(DeviceModel *)device {
    DeviceControlViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceControlViewController class])];
    vc.tabBarController = tabBar;
    vc.currentDeviceId = device.modelId;
    return vc;
}

+ (void)initialize {
    _arcusImageView = [[UIImageView alloc] init];
    [_arcusImageView sd_setImageWithURL:[NSURL URLWithString:[ImagePaths getSmallBrandImage:@"arcus"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [_arcusImageView setImage:[image invertColor]];
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Device", nil);
}

- (void)dealloc {
    [[DeviceManager instance] removeAllControllers];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeftRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    [self.view setBackgroundColorWithColor:self.parentViewController.view.backgroundColor];
    
    [self.footerLogo setImage:nil];
    
    _centerWidth = (self.view.frame.size.width / 35) * 25;
    _animationRunning = NO;
    self.enableSwipe = YES;
    
    self.edgeWidth = (self.view.frame.size.width - _centerWidth) / 2.0f;
    
    [self loadControllers];
    
    [self subscribeToNotifications];
}

- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListChanged:) name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceListChanged:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDeviceList:) name:kDeviceListRefreshedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSubscribeRemoveAddNofitication:) name:Constants.kAllUserStatesClearedNotification object:nil];
}

- (void)popupWindow:(NSString *)key view:(UIView *)view {
    if (!_popupViews) {
        _popupViews = [[NSMutableDictionary alloc] init];
    }
    
    NSDictionary *viewData = [_popupViews objectForKey:key];
    
    NSLayoutConstraint* layout;
    if (!viewData) {
        [self.view addSubview:view];
        layout = [view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [view autoSetDimension:ALDimensionHeight toSize:view.bounds.size.height];
        
        layout.constant = -view.bounds.size.height;
        [_popupViews setValue:@{@"view":view,@"layout":layout} forKey:key];
    }
    else {
        layout = [viewData objectForKey:@"layout"];
    }
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.5f animations:^{
        layout.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeWindow:(NSString *)key {
    if (!_popupViews) _popupViews = [[NSMutableDictionary alloc] init];
    
    NSDictionary *viewData = [_popupViews objectForKey:key];
    if (viewData) {
        NSLayoutConstraint *layout = [viewData objectForKey:@"layout"];
        UIView *view = [viewData objectForKey:@"view"];
        
        [UIView animateWithDuration:.5f animations:^{
            layout.constant = -view.bounds.size.height;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            [_popupViews removeObjectForKey:key];
        }];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self displayDevices];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self closePopupAlert];
    [super viewWillDisappear:animated];
    
    for (UIView *item in self.contentView.subviews) {
        if ([item isKindOfClass:[UIView class]]) {
            [item removeFromSuperview];
        }
    }
}

#pragma mark - Dynamic properties
- (DeviceModel *)deviceModel {
  // See if the current device is the hub
  DeviceModel *hubModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[HubModel addressForId:_currentDeviceId]];
  if (hubModel) {
      return hubModel;
  }

  return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:[DeviceModel addressForId:_currentDeviceId]];
}

#pragma m ¥ark - load and init methods
- (void)loadControllers {
    NSArray *devices = [DeviceManager instance].devices;
    
    for (DeviceModel *item in devices) {
        Class class = item.viewControllerClass;
        if (!item.operationController)  {
            if (class && [class respondsToSelector:@selector(createWithDeviceId:)]) {
                GeneralDeviceOperationController *operationController = [class performSelector:@selector(createWithDeviceId:) withObject:item.modelId];
                operationController.deviceController = self;
                item.operationController = operationController;
            }
            else if (class && [class respondsToSelector:@selector(create)]) {
                DeviceOperationBaseController *operationController = [class performSelector:@selector(create)];
                operationController.deviceController = self;
                 item.operationController = operationController;
            }
            else {
                UnknownDeviceViewController *operationController = [UnknownDeviceViewController performSelector:@selector(create)];
                operationController.deviceController = self;
                item.operationController = operationController;
            }
        }
    }
}

- (void)refreshDeviceList:(NSNotification *)note {
    BOOL reloadViewControllers = NO;
    if (![_centerDevice.deviceModel.modelId isEqualToString:_currentDeviceId]) {
        reloadViewControllers = YES;
    }
    
    if (reloadViewControllers) {
        [self loadControllers];
        [self deviceListChanged:note];
    }
    self.enableSwipe = YES;
    
    [self subscribeToNotifications];
}

- (void)deviceListChanged:(NSNotification *)note {
    if ([note.name isEqualToString:Constants.kModelAddedNotification]) {
        return;
    }
    if ([DeviceManager instance].devices.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.deviceModel.operationController) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                [self loadControllers];
                
                [self displayDevices];
                [self.tabBarController navBarWithBackButtonAndTitle:self.deviceModel.name];
            }
        });
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)stopSubscribeRemoveAddNofitication:(NSNotification *)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDeviceList:) name:kDeviceListRefreshedNotification object:nil];
    
    self.enableSwipe = NO;
}

- (void)displayDevices {
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    [self.view layoutIfNeeded];
    
    [self.contentView setAlpha:0.0f];
    
    DeviceModel *currentDevice = self.deviceModel;
    _centerDevice = currentDevice.operationController;
    if (!_centerDevice) {
        [self loadControllers];
        _centerDevice = currentDevice.operationController;
        if (!_centerDevice) {
            return;
        }
    }
    [self addCenterDevice:_centerDevice];
    
    NSArray *devices = [DeviceManager instance].devices;
    DeviceModel *preDevice = [self getPreviousDevice:devices beforeDevice:currentDevice];
    if (preDevice) {
        _leftDevice = preDevice.operationController;
    }
    else {
        _leftDevice = nil;
    }
    
    _rightDevice = [self getNextDevice:devices afterDevice:currentDevice].operationController;
    
    if (_centerDevice == _leftDevice && _centerDevice == _rightDevice) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:DCAnimationTime animations:^{
            [self.contentView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [_centerDevice deviceDidAppear:YES];
        }];
    }
    else if (_leftDevice == _rightDevice || !_leftDevice) {
        
        _leftDevice = nil;
        _leftPosition = nil;
        [self addRightDevice:_rightDevice];
        
        [UIView animateWithDuration:DCAnimationTime animations:^{
            _rightPosition.constant = _centerWidth * DCDisplayPercentage;
            [self.view layoutIfNeeded];
            [self.contentView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [_centerDevice deviceDidAppear:YES];
        }];
    }
    else {
        [self addLeftDevice:_leftDevice];
        [self addRightDevice:_rightDevice];
        
        [UIView animateWithDuration:DCAnimationTime animations:^{
            _leftPosition.constant = _centerWidth * -DCDisplayPercentage;
            _rightPosition.constant = _centerWidth * DCDisplayPercentage;
            [self.view layoutIfNeeded];
            [self.contentView setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [_centerDevice deviceDidAppear:YES];
        }];
    }
}

- (void)addCenterDevice:(DeviceOperationBaseController *)deviceController {
    if (!deviceController) {
        return;
    }
    [_centerDevice deviceWillAppear:YES];
    
    _centerDevice = deviceController;
    [self.contentView addSubview:_centerDevice.view];
    [_centerDevice.view autoPinToTopLayoutGuideOfViewController:self withInset:0.0f];
    [_centerDevice.view autoPinToBottomLayoutGuideOfViewController:self withInset:0.0f];
    [_centerDevice.view autoSetDimension:ALDimensionWidth toSize:_centerWidth];
    _centerPosition = [_centerDevice.view autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_centerDevice centerMode];
    
    [self fetchVendorImage:self.footerLogo baseViewController:_centerDevice];
}

- (void)addLeftDevice:(DeviceOperationBaseController *)deviceController {
    _leftDevice = deviceController;
    if (_centerDevice) {
        [self.contentView insertSubview:_leftDevice.view belowSubview:_centerDevice.view];
    }
    else {
        [self.contentView addSubview:_leftDevice.view];
    }
    [_leftDevice.view autoPinToTopLayoutGuideOfViewController:self withInset:0.0f];
    [_leftDevice.view autoPinToBottomLayoutGuideOfViewController:self withInset:0.0f];
    [_leftDevice.view autoSetDimension:ALDimensionWidth toSize:_centerWidth];
    _leftPosition = [_leftDevice.view autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_leftDevice edgeMode:@selector(swipeRight)];
}

- (void)addRightDevice:(DeviceOperationBaseController *)deviceController {
    _rightDevice = deviceController;
    if (_centerDevice) {
        [self.contentView insertSubview:_rightDevice.view belowSubview:_centerDevice.view];
    }
    else {
        [self.contentView addSubview:_rightDevice.view];
    }
    [_rightDevice.view autoPinToTopLayoutGuideOfViewController:self withInset:0.0f];
    [_rightDevice.view autoPinToBottomLayoutGuideOfViewController:self withInset:0.0f];
    [_rightDevice.view autoSetDimension:ALDimensionWidth toSize:_centerWidth];
    _rightPosition = [_rightDevice.view autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [_rightDevice edgeMode:@selector(swipeLeft)];
}

#pragma mark - swipe recognizer
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (self.enableSwipe && gestureRecognizer.state == UIGestureRecognizerStateRecognized && gestureRecognizer.view == self.view) {
        [self swipeRight];
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (self.enableSwipe && gestureRecognizer.state == UIGestureRecognizerStateRecognized && gestureRecognizer.view == self.view) {
        [self swipeLeft];
    }
}

#pragma mark - swipe animation
- (void)swipeRight {
    if (_animationRunning || !_leftDevice) {
        return;
    }
    
    _animationRunning = YES;
    NSArray *devices = [DeviceManager instance].devices;
    DeviceModel *handler = [self goToPreviousDevice:devices];
    
    [self.tabBarController navBarWithBackButtonAndTitle: handler.name];
    
    DeviceOperationBaseController *_overRightDevice = _rightDevice;
    NSLayoutConstraint *_overRightPosition = _rightPosition;
    
    _rightDevice = _centerDevice;
    _rightPosition = _centerPosition;
    
    _centerDevice = _leftDevice;
    _centerPosition = _leftPosition;
    
    if ([DeviceManager instance].devices.count == 2) {
        _leftDevice = nil;
        _leftPosition = nil;
    }
    if ([DeviceManager instance].devices.count == 3) {
        [_overRightDevice.view removeFromSuperview];
        [self addLeftDevice:_overRightDevice];
    }
    else if ([DeviceManager instance].devices.count > 3) {
        DeviceModel *device = [self getPreviousDevice:devices beforeDevice:handler];
        if (device) {
            [self checkForController:device];
            [self addLeftDevice:device.operationController];
        }
    }
    
    _leftPosition.constant = _centerWidth * -DCEdgeOverViewPercentage;
    
    [self.contentView bringSubviewToFront:_centerDevice.view];
    [self.view layoutIfNeeded];
    
    [_centerDevice deviceWillAppear:YES];
    [_rightDevice deviceWillDisappear:YES];
    
    self.venderLogoWidth.constant = 40;
    [UIView animateWithDuration:DCAnimationTime animations:^{
        _overRightPosition.constant = _centerWidth * DCEdgeOverViewPercentage;
        
        if (_rightDevice) {
            _rightPosition.constant = _centerWidth * DCDisplayPercentage;
            [_rightDevice edgeMode:@selector(swipeLeft)];
        }
        _centerPosition.constant = 0;
        [_centerDevice centerMode];
        
        if (_leftDevice) {
            _leftPosition.constant = _centerWidth * -DCDisplayPercentage;
            [_leftDevice edgeMode:@selector(swipeRight)];
        }
        
        [self fetchVendorImage:self.footerLogo baseViewController:_centerDevice];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if ([DeviceManager instance].devices.count > 3) {
            [_overRightDevice.view removeFromSuperview];
        }
        
        [_centerDevice deviceDidAppear:YES];
        [_rightDevice deviceDidDisappear:YES];
        _animationRunning = NO;
    }];
}

- (void)swipeLeft {
    if (_animationRunning || [DeviceManager instance].devices.count == 1 || !_rightDevice) {
        return;
    }
    _animationRunning = YES;
    
    NSArray *devices = [DeviceManager instance].devices;
    DeviceModel *device = [self goToNextDevice:devices];
    [self.tabBarController navBarWithBackButtonAndTitle: device.name];
    
    DeviceOperationBaseController *_overLeftDevice = _leftDevice;
    NSLayoutConstraint *_overLeftPosition = _leftPosition;
    
    _leftDevice = _centerDevice;
    _leftPosition = _centerPosition;
    
    _centerDevice = _rightDevice;
    _centerPosition = _rightPosition;
    
    if ([DeviceManager instance].devices.count == 2) {
        _rightDevice = nil;
        _rightPosition = nil;
    }
    else if (devices.count == 3) {
        [_overLeftDevice.view removeFromSuperview];
        [self addRightDevice:_overLeftDevice];
    }
    else {
        DeviceModel *newRightDevice = [self getNextDevice:devices afterDevice:(DeviceModel *)device];
        [self checkForController:newRightDevice];
        [self addRightDevice:newRightDevice.operationController];
    }
    
    _rightPosition.constant = _centerWidth * DCEdgeOverViewPercentage;
    
    [self.contentView bringSubviewToFront:_centerDevice.view];
    
    [self.view layoutIfNeeded];
    
    [_centerDevice deviceWillAppear:YES];
    [_leftDevice deviceWillDisappear:YES];
    
    self.venderLogoWidth.constant = 40;
    [UIView animateWithDuration:DCAnimationTime animations:^{
        _overLeftPosition.constant = _centerWidth * -DCEdgeOverViewPercentage;
        
        if (_leftDevice) {
            _leftPosition.constant = _centerWidth * -DCDisplayPercentage;
            [_leftDevice edgeMode:@selector(swipeRight)];
        }
        _centerPosition.constant = 0;
        [_centerDevice centerMode];
        
        if (_rightDevice) {
            _rightPosition.constant = _centerWidth * DCDisplayPercentage;
            [_rightDevice edgeMode:@selector(swipeLeft)];
        }
        
        [self fetchVendorImage:self.footerLogo baseViewController:_centerDevice];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([DeviceManager instance].devices.count > 3) {
            [_overLeftDevice.view removeFromSuperview];
        }
        
        [_centerDevice deviceDidAppear:YES];
        [_leftDevice deviceDidDisappear:YES];
        _animationRunning = NO;
    }];
}

- (void)checkForController:(DeviceModel *)item {
    if (!item.operationController)  {
        Class class = item.viewControllerClass;
        if ([class respondsToSelector:@selector(createWithDeviceId:)]) {
            DeviceOperationBaseController *operationController = [class performSelector:@selector(createWithDeviceId:) withObject:item.modelId];
            operationController.deviceController = self;
            item.operationController = operationController;
        } else if ([class respondsToSelector:@selector(create)]) {
            DeviceOperationBaseController *operationController = [class performSelector:@selector(create)];
            operationController.deviceController = self;
            // operationController.deviceId = item.modelId;
            item.operationController = operationController;
        }
        else {
            UnknownDeviceViewController *operationController = [UnknownDeviceViewController performSelector:@selector(create)];
            operationController.deviceController = self;
            // operationController.deviceId = item.modelId;
            item.operationController = operationController;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[EFCircularSlider class]]) {
        // prevent recognizing touches on the slider
        return NO;
    }
    return YES;
}

#pragma mark - Vendor image
- (void)fetchVendorImage:(UIImageView *)vendorImageView baseViewController:(DeviceOperationBaseController *)baseController {
  /// Get the productID of the deviceModel and determine if the product is certified
  NSString *productID = [DeviceCapability getProductIdFromModel:baseController.deviceModel];
  
  if (productID.length > 0) {
    [ProductCatalogController getProductWithId:productID].then (^(ProductModel *productModel) {
      // If the product is not certified, make the uncertified label visible and hide the logo image view
      if ([[ProductCapability getCertFromModel:productModel] isEqualToString:kEnumProductCertNONE]) {
        _footerUncertifiedLabel.hidden = NO;
        _footerLogo.hidden = YES;
        return;
      } else {
        _footerUncertifiedLabel.hidden = YES;
        _footerLogo.hidden = NO;
      }
    }).catch(^(NSError *error) {
      // If there is an error, log the error and allow the arcus placeholder logo to load
      DDLogError(@"Product certification status unavailable");
    });
  }
  
  if (baseController.vendorImage) {
    [_footerLogo setImage:baseController.vendorImage];
    self.venderLogoWidth.constant = baseController.vendorImage.size.width * (20.0f / baseController.vendorImage.size.height);
  } else {
    NSString *urlString = [ImagePaths getDeviceBrandImage:baseController.deviceModel];
    [self.footerLogo sd_setImageWithURL:[NSURL URLWithString:urlString]
                       placeholderImage:_arcusImageView.image
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                if (image) {
                                  // Use default color for nest
                                  if (self.deviceModel.deviceType != DeviceTypeThermostatNest) {
                                    image = [image invertColor];
                                  }

                                  [_footerLogo setImage:image];
                                  self.venderLogoWidth.constant = image.size.width * (20.0f / image.size.height);
                                  baseController.vendorImage = image;
                                }
                                else {
                                  self.venderLogoWidth.constant = 40;
                                }
                              }];
  }
  _c2cLogo.hidden = !([_centerDevice.deviceModel respondsToSelector:@selector(isC2CDevice)] &&
                      [_centerDevice.deviceModel isC2CDevice]);
}

#pragma mark - footer style control
- (void)setFooterColor:(UIColor*)color {
    [self.bottomArea setBackgroundColor:color];
}
- (void)setFooterColorToClean {
    [self.bottomArea setBackgroundColor:[UIColor clearColor]];
}

- (void)setFooterLeftText:(NSString *)leftText {
    if (leftText && leftText.length > 0) {
        [self.footerLeftLabel styleSet:leftText andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO]];
        [self.footerLeftLabel sizeToFit];
        [self.footerIconCenterConstraint setConstant:(self.footerLeftLabel.frame.size.width / 2.0f) + 5.0f];
        self.footerLeftLabel.center = CGPointMake(self.footerLeftLabel.center.x, 23);
    } else {
        [self.footerLeftLabel setText:@""];
        [self.footerIconCenterConstraint setConstant:0.0f];
    }
}

#pragma mark - Change Current Device
- (DeviceModel *)goToNextDevice:(NSArray *)devices {
    DeviceModel *currentDevice = self.deviceModel;
    
    if (devices.count == 0 || !currentDevice) {
        return nil;
    }
    
    NSInteger index = [devices indexOfObject:currentDevice];
    if (index < devices.count - 1) {
        index++;
    }
    else {
        index = 0;
    }
    
    if (index >= devices.count) {
        index = devices.count - 1;
    }
    
    DeviceModel *nextDevice = devices[index];
    if (nextDevice && nextDevice.modelId.length > 0) {
        _currentDeviceId = nextDevice.modelId;
        return nextDevice;
    }
    return nil;
}

- (DeviceModel *)goToPreviousDevice:(NSArray *)devices {
    DeviceModel *currentDevice = self.deviceModel;
    
    if (devices.count == 0 || !currentDevice) {
        return nil;
    }
    
    NSInteger index = [devices indexOfObject:currentDevice];
    if (index > 0) {
        index--;
    }
    else {
        index = devices.count - 1;
    }
    
    if (index >= devices.count) {
        index = devices.count - 1;
    }
    
    
    DeviceModel *previousDevice = devices[index];
    if (previousDevice && previousDevice.modelId.length > 0) {
        _currentDeviceId = previousDevice.modelId;
        return previousDevice;
    }
    return nil;
}


- (DeviceModel *)getNextDevice:(NSArray *)devices afterDevice:(DeviceModel *)device {
    if (devices.count == 0 || !device) {
        return nil;
    }
    
    NSInteger index = [devices indexOfObject:device];
    if (index < devices.count - 1) {
        index++;
    }
    else {
        index = 0;
    }
    
    if (index >= devices.count) {
        index = devices.count - 1;
    }
    
    return devices[index];
}

- (DeviceModel *)getPreviousDevice:(NSArray *)devices beforeDevice:(DeviceModel *)device {
    if (devices.count == 0 || !device) {
        return nil;
    }
    
    NSInteger index = [devices indexOfObject:device];
    if (index > 0) {
        index--;
    }
    else {
        index = devices.count - 1;
    }
    
    if (index >= devices.count) {
        index = devices.count - 1;
    }
    
    return devices[index];
}


@end
