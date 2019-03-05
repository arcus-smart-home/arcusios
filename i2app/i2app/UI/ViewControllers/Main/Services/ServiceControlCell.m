//
//  ServiceControlCell.m
//  i2app
//
//  Created by Arcus Team on 9/2/15.
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
#import "ServiceControlCell.h"
#import "DeviceDetailsLock.h"
#import "DeviceDetailsGarageDoor.h"
#import "DeviceDetailsContactSensor.h"
#import "DeviceDetailsVent.h"
#import "DeviceDetailsThermostat.h"
#import "DeviceDetailsTabBarController.h"
#import "DeviceDetailsSwitch.h"
#import "DeviceDetailsDimmer.h"
#import "DeviceDetailsHalo.h"
#import "DeviceDetailsWaterHeater.h"
#import "DeviceDetailsWaterShut.h"
#import "DeviceDetailsWaterSoftener.h"
#import "DeviceDetailsPetDoor.h"
#import "ImageDownloader.h"
#import "PopupSelectionWindow.h"
#import "DeviceCapability.h"
#import "SwitchCapability.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "VentCapability.h"
#import "UIView+Overlay.h"
#import "NSDate+Convert.h"
#import "DeviceButtonBaseControl.h"
#import "PopupSelectionNumberView.h"
#import "DeviceDetailsThermostatHoneywell.h"
#import "LightCapability.h"
#import "SimpleTableViewController.h"
#import "DeviceDetailsFanSwitch.h"
#import "PopupSelectionButtonsView.h"
#import "UIViewController+AlertBar.h"
#import <i2app-Swift.h>


@interface ServiceControlCell ()

@end


@implementation ServiceControlCell

@dynamic deviceId;

+ (ServiceControlCell *)createCell:(DeviceModel *)deviceModel owner:(UIViewController *)owner {
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"ServiceControlCell" owner:self options:nil];
    ServiceControlCell *cell = [xibViews objectAtIndex:0];
    cell.deviceModel = deviceModel;
    switch (cell.deviceModel.deviceType) {
        case DeviceTypeContactSensor:
            cell.deviceDataModel = [[DeviceDetailsContactSensor alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeLightBulb:
        case DeviceTypeDimmer:
            cell.deviceDataModel = [[DeviceDetailsDimmer alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeSwitch:
            cell.deviceDataModel = [[DeviceDetailsSwitch alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;
            
        case DeviceTypeFanSwitch:
            cell.deviceDataModel = [[DeviceDetailsFanSwitch alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypePetDoor:
            cell.deviceDataModel = [[DeviceDetailsPetDoor alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeGarageDoor:
            cell.deviceDataModel = [[DeviceDetailsGarageDoor alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeHalo:
            cell.deviceDataModel = [[DeviceDetailsHalo alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeLocks:
            cell.deviceDataModel = [[DeviceDetailsLock alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeThermostat:
            cell.deviceDataModel = [[DeviceDetailsThermostat alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeThermostatHoneywellC2C:
            cell.deviceDataModel = [[DeviceDetailsThermostatHoneywell alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeThermostatNest:
            cell.deviceDataModel = [[DeviceDetailsThermostatNest alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeVent:
            cell.deviceDataModel = [[DeviceDetailsVent alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeWaterHeater:
            cell.deviceDataModel = [[DeviceDetailsWaterHeater alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeWaterSoftener:
            cell.deviceDataModel = [[DeviceDetailsWaterSoftener alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeWaterValve:
            cell.deviceDataModel = [[DeviceDetailsWaterShut alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        case DeviceTypeSpaceHeater:
            cell.deviceDataModel = [[DeviceDetailsSpaceHeater alloc] initWithDeviceId:cell.deviceModel.modelId];
            break;

        // TODO: FIX ME!
//        case DeviceTypeLutronCasetaSmartBridge:
//            cell.deviceDataModel = [[DeviceDetailsLutronCasetaSmartBridge alloc] initWithDeviceId:cell.deviceModel.modelId];
//            break;

        default:
            break;
    }
    [cell.deviceDataModel loadDelegate:cell];

    cell.parentController = owner;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell layoutIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:cell selector:@selector(getDeviceStateChangedNotification:) name:deviceModel.modelChangedNotification object:nil];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setAllLabelToEmpty];

    [self setBackgroundColor:[UIColor clearColor]];
    [self.contentView setBackgroundColor:[UIColor clearColor]];

    [self.centerDivider setHidden:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getDeviceStateChangedNotification:(NSNotification *)note {

    if (![[(Model *)([note.userInfo objectForKey:@"Model"]) modelId] isEqualToString: self.deviceModel.modelId]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
    [self.deviceDataModel updateDeviceState:note.object initialUpdate:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.editing) {
        [self.arrowIcon setHidden:YES];
    }
    else {
        [self.arrowIcon setHidden:NO];
    }
}

#pragma mark - Load Data
- (void)loadData {
    [self setTitle:self.deviceModel.name];
    [self loadDeviceImageFromPlatform];

    [self.deviceDataModel loadData];

    if ((self.leftButton && self.leftButton.button.imageView.image) || (self.rightButton && self.rightButton.button.imageView.image)) {
        self.titleSizeConstraint.constant = 150;
        self.subtitleSizeConstraint.constant = 150;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    else {
        self.titleSizeConstraint.constant = 280;
        self.subtitleSizeConstraint.constant = 280;
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }

    if ([self.deviceModel isDisabledDevice]) {
        if (!self.isInOfflineMode) {
            [self.deviceDataModel loadOfflineMode];
            self.isInOfflineMode = YES;
        }
    }
    else {
        if (self.isInOfflineMode) {
            [self.deviceDataModel loadOnlineMode];
            self.isInOfflineMode = NO;
        }
    }
}

/**
 * This method isn't exactly the most performant and should be removed when we remove iOS 8 & 9
 * support, snippet found from SO: https://stackoverflow.com/a/11342977/283460 and modified to add 
 * support for nil
 */
- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
  if (image1 == nil || image2 == nil) {
    return NO;
  }
  
  NSData *data1 = UIImagePNGRepresentation(image1);
  NSData *data2 = UIImagePNGRepresentation(image2);
  if (data1.length != data2.length) {
    return NO;
  }
  return [data1 isEqual:data2];
}

- (void)loadDeviceImageFromPlatform {

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *placeholder = [UIImage imageNamed:@"PlaceholderWhite"];
      UIImage *centerIconImage = self.centerIcon.image;
      if (![self image:centerIconImage isEqualTo:placeholder]) {
        return;
      }
    
      [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:self.deviceModel] withDevTypeId:[self.deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {

        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground) {
          return;
        }

        [self.centerIcon setImage:image];
      });
    });
  });
}

- (void)colorConfigButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(bottomButtonPressed:serviceControlCell:)]) {
            [self.delegate bottomButtonPressed:sender serviceControlCell:self];
        }
    }
}

#pragma mark - Load Views
- (void)disableLefRightButtons:(BOOL)disable {
    [self.leftButton setDisable:disable];
    [self.rightButton setDisable:disable];
}

#pragma mark - Button Action - Left Clicks
- (IBAction)onClickBackgroup:(id)sender {
    if (self.editing) {
        return;
    }

    UIViewController *vc = [DeviceDetailsTabBarController createWithModel:self.deviceModel];
    [self.parentController.navigationController pushViewController:vc animated:YES];
}

- (void)onGarageDoorClickLeft:(UIButton *)sender {
}

#pragma mark - Button Action - Right Clicks

- (void)onGarageDoorClickRight:(UIButton *)sender {
}

#pragma mark - helping function
- (void)setTempInCenter:(int)temp temp2:(int)temp2{
    [self.centerLabel styleSet:[NSString stringWithFormat:@"%d°\r\n%d°", temp, temp2]
                 andButtonType:FontDataType_Medium_14_White_NoSpace];
    [self.centerDivider setHidden:NO];
}

- (void)setTempInCenter:(int)temp {
    [self setCenterText:[NSString stringWithFormat:@"%d°", temp]];
}

- (void)setCenterText:(NSString *)text {
    [self.centerLabel styleSet:text andButtonType:FontDataType_Medium_18_White_NoSpace];
    [self.centerDivider setHidden:YES];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel styleSet:title andButtonType:FontDataType_DemiBold_12_White upperCase:YES];
    self.titleLabel.numberOfLines = 1;
}

- (void)setSubtitle:(NSString *)subtitle {
    [self.subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_12_WhiteAlpha_NoSpace];
    if (subtitle.length > 0) {
        self.titleLabel.numberOfLines = 1;
    }
}

- (void)setBottomButtonText:(NSString *)text {
    if (text && text.length > 0) {
        [self.centerLogoTopConstaint setConstant:15];
        [self.bottomButton styleSet:[NSString stringWithFormat:@" %@ ",text] andButtonType:FontDataType_DemiBold_12_White upperCase:YES];
        self.bottomButton.layer.cornerRadius = 4.0f;
        self.bottomButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.bottomButton.layer.borderWidth = 1.0f;
    }
    else {
        [self.centerLogoTopConstaint setConstant:35];
        [self.bottomButton setTitle:@" " forState:UIControlStateNormal];
        self.bottomButton.layer.borderWidth = 0.0f;
    }
}

- (void)setButtonSelector:(SEL)selector toOwner:(id)owner {
    [self.bottomButton addTarget:owner action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)popup:(PopupSelectionBaseContainer *)container {
    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:container];

    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        ((SimpleTableViewController *)self.parentController).popupWindow = self.popupWindow;
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:container
                                             owner:self
                                     closeSelector:selector];

    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        ((SimpleTableViewController *)self.parentController).popupWindow = self.popupWindow;
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:container
                                             owner:owner
                                     closeSelector:selector];

    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        ((SimpleTableViewController *)self.parentController).popupWindow = self.popupWindow;
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner inRootViewControllerWindow:(BOOL)inRootVC {
    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:container
                                             owner:owner
                                     closeSelector:selector
                        inRootViewControllerWindow:inRootVC];

    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        ((SimpleTableViewController *)self.parentController).popupWindow = self.popupWindow;
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner style:(PopupWindowStyle)style {
    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:container
                                             owner:owner
                                     closeSelector:selector
                                             style:style];
    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        ((SimpleTableViewController *)self.parentController).popupWindow = self.popupWindow;
    }
}

- (void)closePopup {
    [self.popupWindow close];
    self.popupWindow = nil;

    if ([self.parentController isKindOfClass:[SimpleTableViewController class]]) {
        [((SimpleTableViewController *)self.parentController) closePopupAlert];
    }
}

- (void)popupFullScreen:(UIViewController *)popupController {
    self.popupController = popupController;
    [self.parentController presentViewController:popupController animated:YES completion:^{

    }];
}

- (void)displayOfflineScreen:(BOOL)display {
    if (display) {
        [self displayOfflineOverlay:display];
        [self setSubtitle:@"Offline"];
    } else {
        [self displayOfflineOverlay:display];
    }
}

- (void)displayGreyOverlay:(BOOL)display {
    if (display && ![self hasOverlay]) {
        [super addGrayOverlayWithTapSelector:@selector(onClickBackgroup:)
                                   andTarget:self
                                    andIndex:-1];
    } else if (!display) {
        [self removeOverlay];
    }
}

- (void)displayOfflineOverlay:(BOOL)display {
    if (display) {
        [self addOfflineOverlayForDevice:self.deviceModel withBackgroundTapSelector:@selector(onClickBackgroup:) andTarget:self];
    }
    else {
        [self removeOverlay];
    }
}

- (void)displayDeviceNameErrorOverlay:(BOOL)display withError:(NSString*)errorMessage {
    if (display) {
        [self addDeviceNameErrorOverlay:self.deviceModel.name
                              withError:errorMessage
                           withSelector:@selector(onClickBackgroup:)
                               andCloud:[self.deviceModel isC2CDevice]];
    }
    else {
        [self removeOverlay];
    }
}

- (void)displayBottomBannerWithColor:(buttomAlertColor)color
                              vendor:(NSString *)vendor
                            sideText:(NSString *)sideText
                            sideIcon:(UIImage *)sideIcon {
    UIColor *backgoundColor = nil;

    switch (color) {
        case bottomAlertInPink:
            backgoundColor = pinkAlertColor;
            break;
        case bottomAlertInGray:
            backgoundColor = grayAlertColor;
            break;
        default:
            break;
    }

    [self bringSubviewToFront:self.bottomBanner];
    [self.bottomBanner setHidden:NO];
    [self.bottomBanner setBackgroundColor:backgoundColor];

    if ([[self.bottomBanner gestureRecognizers] count] <= 0) {
        UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBackgroup:)];
        [self.bottomBanner addGestureRecognizer:singleTap];
    }

    NSString *urlString = [ImagePaths getSmallBrandImage:vendor];

    [self.brandIcon sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (image) {
            [self.brandIcon setImage:[image invertColor]];
            self.bottomIconWidthConstraint.constant = image.size.width * (20.0f / image.size.height);
        }
        else {
            self.bottomIconWidthConstraint.constant = 40;
        }
    }];

    if (sideText && sideText.length > 0) {
        [self.sideLabel styleSet:sideText andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO]];
        [self.sideLabel sizeToFit];
        [self.bottomIconCenterConstraint setConstant:(self.sideLabel.frame.size.width / 2.0f) + 5.0f];
    } else {
        [self.sideLabel setText:@""];
        [self.bottomIconCenterConstraint setConstant:0.0f];
    }

    if (sideIcon) {
        [self.sideIcon setImage:sideIcon];
        [self.sideIcon setHidden:NO];
    } else {
        [self.sideIcon setHidden:YES];
    }
}

- (void)displayBottomBannerWithColor:(buttomAlertColor)color
                          middleText:(NSString *)middleText
                            sideIcon:(UIImage *)sideIcon {
  UIColor *backgoundColor = nil;

  switch (color) {
    case bottomAlertInPink:
      backgoundColor = pinkAlertColor;
      break;
    case bottomAlertInGray:
      backgoundColor = grayAlertColor;
      break;
    default:
      break;
  }

  [self bringSubviewToFront:self.bottomBanner];
  [self.bottomBanner setHidden:NO];
  [self.bottomBanner setBackgroundColor:backgoundColor];

  if ([[self.bottomBanner gestureRecognizers] count] <= 0) {
    UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBackgroup:)];
    [self.bottomBanner addGestureRecognizer:singleTap];
  }

  UILabel *middleLabel = [UILabel new];
  [middleLabel styleSet:middleText
            andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO]];
  middleLabel.textAlignment = NSTextAlignmentCenter;
  middleLabel.numberOfLines = 0;
  [middleLabel sizeToFit];
  middleLabel.center = CGPointMake(self.bottomBanner.bounds.size.width/2,
                                   self.bottomBanner.bounds.size.height/2);

  UIView *overlay = [UIView new];
  overlay.frame = CGRectMake(0, 0, 300, 100);
  overlay.backgroundColor = UIColor.blackColor;
  overlay.alpha = 0.4;

  [self.bottomBanner addSubview:overlay];
  [self.bottomBanner addSubview:middleLabel];

  if (sideIcon) {
    [self.sideIcon setImage:sideIcon];
    [self.sideIcon setHidden:NO];
  } else {
    [self.sideIcon setHidden:YES];
  }
}

- (void)hideBottomBanner {
    [self.bottomBanner setHidden:YES];
}

#pragma mark - Honeywell Specific Alerts

- (void)displayAutoModeAlertForHoneywell {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"AUTO MODE", nil)
                                                                              subtitle:NSLocalizedString(@"To use Auto mode on your thermostat, Honeywell requires you to first enable the Auto mode setting on the device. Check the Honeywell owner's manual for details.", nil)
                                                                                button:nil, nil];
    buttonView.owner = self;

    self.popupWindow = [PopupSelectionWindow popup:self.parentController.view
                                           subview:buttonView
                                             owner:self
                                     closeSelector:@selector(closeAutoAlert:)
                                             style:PopupWindowStyleCautionWindow];
}

- (void)closeAutoAlert:(id)obj {
    [self.popupWindow closePopupAlert];
}

- (void)setupDeviceError:(NSString*)errorMessage {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.hidden = YES;
    self.arrowIcon.hidden = YES;
    [self displayDeviceNameErrorOverlay:YES withError:errorMessage];
}

- (void)teardownDeviceError {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.titleLabel.hidden = NO;
    self.arrowIcon.hidden = NO;
    self.subtitleLabel.hidden = NO;
    [self displayDeviceNameErrorOverlay:NO withError:@""];
}

- (void)setupDeviceWarning:(NSString *)warningMessage {
  self.leftButton.hidden = YES;
  self.rightButton.hidden = YES;
  self.titleLabel.hidden = YES;
  self.arrowIcon.hidden = YES;
  self.subtitleLabel.hidden = YES;
  [self addWarningTitle:self.deviceModel.name
    withWarningSubtitle:warningMessage
           withSelector:@selector(onClickBackgroup:)];
}

- (void)teardownDeviceWarning{
  self.leftButton.hidden = NO;
  self.rightButton.hidden = NO;
  self.titleLabel.hidden = NO;
  self.arrowIcon.hidden = NO;
  [self removeOverlay];
}

//TODO: Add With Cloud to this section for Lutron

#pragma mark - Pink banner style offline mode

- (void)setupPinkBannerOfflineModeView {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.hidden = YES;
    self.arrowIcon.hidden = YES;
    self.subtitleLabel.hidden = YES;
    [self displayOfflineOverlay:YES];
}

- (void)tearDownPinkBannerOfflineModeView {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.titleLabel.hidden = NO;
    self.arrowIcon.hidden = NO;
    self.subtitleLabel.hidden = NO;
    [self displayOfflineOverlay:NO];
}

@end
