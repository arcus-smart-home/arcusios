//
//  DeviceSettingCellController.m
//  i2app
//
//  Created by Arcus Team on 8/7/15.
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
#import "DeviceSettingCellController.h"

#import "DeviceSettingCells.h"
#import "DeviceSettingModels.h"
#import "PopupMessageViewController.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionTextPickerView.h"
#import "CameraNetworkSettingsViewController.h"
#import "WifiCapability.h"
#import "CameraCapability.h"
#import "MotionCapability.h"
#import "PopupSelectionBaseContainer.h"
#import "PopupSelectionCheckedTextView.h"
#import "PopupSelectionCheckedTextCell.h"

#import "UIImage+ScaleSize.h"
#import "KeyFobRuleSettingButtonController.h"

#import "RulesController.h"

#import "DeviceCapability.h"
#import "RuleCapability.h"
#import "CameraCapability.h"

#import "NSString+Formatting.h"

#import <i2app-Swift.h>

#pragma mark - Function unit
@implementation DeviceSettingFunctionUnit {
    PopupSelectionWindow *_popupWindow;
    __block DeviceSettingFunctionUnit *_selfObj;
}

- (UITableViewCell *)getCell {
    UITableViewCell *cell = [super getCell];
    
    // Add backgroup clicked event
    if ([cell isKindOfClass:[DeviceSettingCell class]]) {
        [((DeviceSettingCell *)cell) setPressedBackgroupSelector:@selector(pressedBackgroup:)];
        [((DeviceSettingCell *)cell) refreshView];
    }
    return cell;
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    
}

#pragma mark - Popup window
- (void)popup:(PopupSelectionBaseContainer *)container {
    _popupWindow = [PopupSelectionWindow popup:self.controlOwner.view
                                       subview:container];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.controlOwner.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)closePopup {
    [_popupWindow close];
    [PopupMessageViewController closePopup];
}

- (void)popupErrorTitle:(NSString *)title withMessage:(NSString *)message {
    [_popupWindow close];
    [PopupMessageViewController popupErrorWindow:self.controlOwner.view
                                           title:title
                                         message:message];
}

- (void)loadData {
    [super loadData];
    
    _selfObj = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDeviceStateChangedNotification:) name:self.deviceModel.modelChangedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getDeviceStateChangedNotification:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_selfObj) {
            [_selfObj updateDeviceState:note.object initialUpdate:NO];
        }
    });
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
}

- (void)refreshView {
    UITableViewCell *cell = [self getCell];
    if ([cell isKindOfClass:[DeviceSettingCell class]]) {
        [((DeviceSettingCell *)cell) refreshView];
    }
}

@end

#pragma mark - Mid units
@implementation DeviceSettingGroupUnit

+ (DeviceSettingGroupUnit *)createWithTitle: (NSString *)title {
    DeviceSettingGroupUnit *unit = [[DeviceSettingGroupUnit alloc] init];
    [unit setTitle:title];
    return unit;
}

@end

@implementation DeviceSettingTextValueUnit

- (UITableViewCell *)generateCell {
    DeviceSettingTextSubtitleCell *cell = (DeviceSettingTextSubtitleCell *)[DeviceSettingTextSubtitleCell create:self];
    return cell;
}

- (void) setSubtitle: (NSString *)subtitle {
    [self setString:subtitle to:@"subtitle"];
}

- (void) setValue: (NSString *)value {
    [self setString:value to:@"value"];
}

- (void) setDisableArrow: (BOOL)value {
    [self setBoolean:value to:@"disableArrow"];
}

@end


@implementation DeviceSettingTextSwitchUnit

- (UITableViewCell *)generateCell {
    DeviceSettingTextSubtitleSwitchCell *cell = (DeviceSettingTextSubtitleSwitchCell *)[DeviceSettingTextSubtitleSwitchCell create:self];
    [cell setSwitchSelector:@selector(clickedSwitch:)];
    return cell;
}

- (void) setSubtitle: (NSString *)subtitle {
    [self setString:subtitle to:@"subtitle"];
}

- (void) setSwitchState: (BOOL)state {
    [self setBoolean:state to:@"switchState"];
}

- (void) clickedSwitch: (DeviceSettingTextSubtitleSwitchCell *)cell {
    [self updatedSwitchState:cell.switchButton.selected];
}
//@Override
- (void) updatedSwitchState: (BOOL)state {
    
}

@end

@implementation DeviceSettingLogoTitleUnit

- (UITableViewCell *)generateCell {
    DeviceSettingLogoTitleCell *cell = (DeviceSettingLogoTitleCell *)[DeviceSettingLogoTitleCell create:self];
    return cell;
}

- (void) setLogoImage: (UIImage *)image {
    [self setValue:image to:@"logoImage"];
}

- (void) setLogoImageUrl: (NSString *)url {
    [self setString:url to:@"logoImageUrl"];
}

- (void) setDisableArrow: (BOOL)value {
    [self setBoolean:value to:@"disableArrow"];
}

@end


#pragma mark - Final setting units


#pragma mark : Camera settings
@implementation DeviceSettingWifiNetworkUnit

- (void)loadData {
  [self setTitle:NSLocalizedString(@"wi-fi & network settings", nil)];
  [self setSubtitle:NSLocalizedString(@"Select your network and enter your \nnetwork password.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
  BLEDeviceNetworkSettingsViewController *networkSettingsViewController = [BLEDeviceNetworkSettingsViewController create];
  networkSettingsViewController.deviceModel = self.deviceModel;

  if (self.openSettings) {
    self.openSettings(networkSettingsViewController);
  }
}


@end

@implementation DeviceSettingCameraWifiNetworkUnit

- (void)loadData {
    [self setTitle:NSLocalizedString(@"wi-fi & network settings", nil)];
    [self setSubtitle:NSLocalizedString(@"Select your network and enter your \nnetwork password.", nil)];

    [self setValue:[self.deviceModel getAttribute:kAttrWiFiSsid]];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    CameraNetworkSettingsViewController *networkSettingsViewController = [CameraNetworkSettingsViewController create];
    networkSettingsViewController.cameraModel = self.deviceModel;
    networkSettingsViewController.saveSettingsCompletion = ^ (BOOL isWifi) {
        [self refreshView];
    };
    
    if (self.openSettings) {
        self.openSettings(networkSettingsViewController);
    }
}

@end

@implementation DeviceSettingBatteryCameraImageQualityUnit {
    __block DeviceSettingBatteryCameraImageQualityUnit *_selfObj;
}

- (void)loadData {
    [super loadData];
    NSString *resolution = [CameraCapability getResolutionFromModel:self.deviceModel];

    _selfObj = self;
    [self setTitle:NSLocalizedString(@"Battery Camera Image Quality", nil)];
    [self setSubtitle:NSLocalizedString(@"Battery Camera Resolution Explanation", nil)];
    [self setValue:resolution];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    NSArray *resolutions = [CameraCapability getResolutionssupportedFromModel:self.deviceModel];

    OrderedDictionary *values = [[OrderedDictionary alloc] initWithCapacity:resolutions.count];

    for (NSString *item in resolutions) {
        [values setObject:item forKey:item];
    }

    PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:@"Select Resolution" list:values];
    NSString *currectVal = [CameraCapability getResolutionFromModel:self.deviceModel];
    [popupSelection setCurrentKey:currectVal];

    [super popup:popupSelection complete:@selector(completedSelected:)];
}

- (NSArray *)popupModelsWithReSolutions:(NSArray *)resolutions {
    NSMutableArray *models = [NSMutableArray array];

    for (NSString *resolution in resolutions) {
        PopupSelectionButtonModel *model = [PopupSelectionButtonModel create:resolution event:@selector(completedSelected:) obj:resolution];

        [models addObject:model];
    }

    return models;
}

- (NSString *)cameraResolution {
    return [CameraCapability getResolutionFromModel:self.deviceModel];
}

- (void)completedSelected:(id)selectValue {
    if (selectValue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            if (_selfObj) {
                [CameraCapability setResolution:selectValue onModel:_selfObj.deviceModel];
                [_selfObj.deviceModel commit];
            }
        });
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([self hasResolutionValueChanged:[attributes allKeys]]) {
        NSString *newResolution = [attributes objectForKey:kAttrCameraResolution];
        [self setValue:newResolution];
        [self refreshView];
    }
}

- (BOOL)hasResolutionValueChanged:(NSArray *)keys {
    for (NSString *key in keys) {
        if ([key isEqualToString:kAttrCameraResolution]) {
            return YES;
        }
    }

    return NO;
}

@end

@implementation DeviceSettingCameraImageQualityUnit {
    __block DeviceSettingCameraImageQualityUnit *_selfObj;
}

- (void)loadData {
    [super loadData];
    NSString *resolution = [CameraCapability getResolutionFromModel:self.deviceModel];
    
    _selfObj = self;
    [self setTitle:NSLocalizedString(@"Image Quality", nil)];
    [self setSubtitle:NSLocalizedString(@"Resolution explanation", nil)];
    [self setValue:resolution];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    NSArray *resolutions = [CameraCapability getResolutionssupportedFromModel:self.deviceModel];
    
    OrderedDictionary *values = [[OrderedDictionary alloc] initWithCapacity:resolutions.count];
    
    for (NSString *item in resolutions) {
        [values setObject:item forKey:item];
    }
    
    PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:@"Select Resolution" list:values];
    NSString *currectVal = [CameraCapability getResolutionFromModel:self.deviceModel];
    [popupSelection setCurrentKey:currectVal];
    
    [super popup:popupSelection complete:@selector(completedSelected:)];
}

- (NSArray *)popupModelsWithReSolutions:(NSArray *)resolutions {
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSString *resolution in resolutions) {
        PopupSelectionButtonModel *model = [PopupSelectionButtonModel create:resolution event:@selector(completedSelected:) obj:resolution];

        [models addObject:model];
    }
    
    return models;
}

- (NSString *)cameraResolution {
    return [CameraCapability getResolutionFromModel:self.deviceModel];
}

- (void)completedSelected:(id)selectValue {
    if (selectValue) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            if (_selfObj) {
                [CameraCapability setResolution:selectValue onModel:_selfObj.deviceModel];
                [_selfObj.deviceModel commit];
            }
        });
    }
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    
    if ([self hasResolutionValueChanged:[attributes allKeys]]) {
        NSString *newResolution = [attributes objectForKey:kAttrCameraResolution];
        [self setValue:newResolution];
        [self refreshView];
    }
}

- (BOOL)hasResolutionValueChanged:(NSArray *)keys {
    
    for (NSString *key in keys) {
        if ([key isEqualToString:kAttrCameraResolution]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation DeviceSettingBatteryCameraMotionSensitivityUnit {
  PopupSelectionWindow *_popupWindow;
}

- (void)loadData {
  [super loadData];

  NSString *sensitivity = [MotionCapability getSensitivityFromModel:self.deviceModel];

  [self setTitle:NSLocalizedString(@"Motion Sensitivity", nil)];
  [self setSubtitle:NSLocalizedString(@"Sensitivity Explanation", nil)];
  [self setValue:[sensitivity stringWithSentenceCapitalization]];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
  NSArray *sensitivityArray = [MotionCapability getSensitivitiesSupportedFromModel:self.deviceModel];
  NSString *currentSensitivity = [MotionCapability getSensitivityFromModel:self.deviceModel];

  OrderedDictionary *values = [[OrderedDictionary alloc] initWithCapacity:sensitivityArray.count];

  for (NSString *sensitivity in sensitivityArray) {
    [values setObject:sensitivity forKey:[sensitivity stringWithSentenceCapitalization]];
  }

  PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:NSLocalizedString(@"Motion Sensitivity", nil) list:values];
  [popupSelection setCurrentKey:currentSensitivity];

  [super popup:popupSelection complete:@selector(completedSelected:)];
}

- (void)completedSelected:(id)selectValue {
  if (selectValue) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
      if ([[selectValue uppercaseString] isEqualToString:@"OFF"]) {
        [self promptForSensitivityOff];
      } else {
        [self adjustSensitivity:(NSString *)selectValue];
      }
    });
  }
}


- (void)adjustSensitivity:(NSString *)sensitivity {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    [MotionCapability setSensitivity:[sensitivity uppercaseString] onModel:self.deviceModel];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self updateDeviceState:self.deviceModel.changes initialUpdate:FALSE];
    });
    [self.deviceModel commit];
  });
}

- (void)promptForSensitivityOff {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *title = @"Are Your Sure?";
    NSString *subText = @"Turning the motion sensitivity to off will disable the camera from triggering or recording a Security/Care Alarm event.";

    PopupSelectionButtonModel *yesModel = [PopupSelectionButtonModel create:NSLocalizedString(@"YES", nil)
                                                                      event:@selector(setSensitivityOff)];
    PopupSelectionButtonModel *noModel = [PopupSelectionButtonModel create:NSLocalizedString(@"NO", nil)
                                                                     event:nil];

    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:title
                                                                              subtitle:subText
                                                                                button:yesModel, noModel, nil];
    buttonView.owner = self;

    _popupWindow = [PopupSelectionWindow popup:self.controlOwner.view
                                       subview:buttonView
                                         owner:self
                                 closeSelector:nil
                                         style:PopupWindowStyleCautionWindow];

  });
}

- (void)setSensitivityOff {
  [self adjustSensitivity:@"OFF"];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self closePopup];
  });

}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
  if ([self hasSensitivityValueChanged:[attributes allKeys]]) {
    NSString *sensitivity = [[attributes objectForKey:kAttrMotionSensitivity] stringWithSentenceCapitalization];
    [self setValue:sensitivity];
    [self refreshView];
  }
}

- (BOOL)hasSensitivityValueChanged:(NSArray *)keys {
  for (NSString *key in keys) {
    if ([key isEqualToString:kAttrMotionSensitivity]) {
      return YES;
    }
  }
  return NO;
}

@end

@implementation DeviceSettingCameraFrameRateUnit

- (void)loadData {
    [super loadData];

    int frameRate = [CameraCapability getFramerateFromModel:self.deviceModel];

    [self setTitle:NSLocalizedString(@"Frame Rate", nil)];
    [self setSubtitle:NSLocalizedString(@"Frame Rate explanation", nil)];
    [self setValue:[NSString stringWithFormat:@"%d FPS", frameRate]];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    int minFrameRate = [CameraCapability getMinframerateFromModel:self.deviceModel];
    int maxFrameRate = [CameraCapability getMaxframerateFromModel:self.deviceModel];
    
    int frameRate = minFrameRate;
    
    NSMutableArray *mutableFrameRates = [[NSMutableArray alloc] init];
    
    while (frameRate <= maxFrameRate) {
        [mutableFrameRates addObject:@(frameRate)];
        frameRate = (frameRate + 5) - ((frameRate + 5) % 5);
    }
    
    OrderedDictionary *values = [[OrderedDictionary alloc] initWithCapacity:mutableFrameRates.count];
    
    for (NSNumber *item in mutableFrameRates) {
        [values setObject:item forKey:[NSString stringWithFormat:@"%i Frames Per Second", [item intValue]].uppercaseString];
    }
    
    PopupSelectionTextPickerView *popupSelection = [PopupSelectionTextPickerView create:@"Select Frame Rate" list:values];
    int currectVal = [CameraCapability getFramerateFromModel:self.deviceModel];
    [popupSelection setCurrentKey:[NSString stringWithFormat:@"%d", currectVal]];
    
    [super popup:popupSelection complete:@selector(completedSelected:)];
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    if ([self hasFrameRateValueChanged:[attributes allKeys]]) {
        NSNumber *frameRate = [attributes objectForKey:kAttrCameraFramerate];
        [self setValue:[NSString stringWithFormat:@"%d FPS", frameRate.intValue]];
        [self refreshView];
    }
}

- (BOOL)hasFrameRateValueChanged:(NSArray *)keys {
    for (NSString *key in keys) {
        if ([key isEqualToString:kAttrCameraFramerate]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)popupModelsWithReSolutions:(NSArray *)resolutions {
    NSMutableArray *models = [NSMutableArray array];
    
    for (NSNumber *resolution in resolutions) {
        NSString *resString = [NSString stringWithFormat:@"%i Frames Per Second", [resolution intValue]].uppercaseString;
        
        PopupSelectionButtonModel *model = [PopupSelectionButtonModel create:resString event:@selector(completedSelected:) obj:resolution];
        
        [models addObject:model];
    }
    
    return models;
}

- (NSInteger)cameraFrameRate {
    return [CameraCapability getFramerateFromModel:self.deviceModel];
}

- (void)completedSelected:(NSNumber *)selectValue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [CameraCapability setFramerate:[selectValue intValue] onModel:self.deviceModel];
        [self.deviceModel commit];

    });
}

@end

@implementation DeviceSettingCameraInfraredLightUnit

- (void)loadData {
    [super loadData];

    [self setTitle:NSLocalizedString(@"Infrared light", nil)];
    [self setSubtitle:NSLocalizedString(@"Choose your preferred infrared light settings.", nil)];
    [self setValue:[NSString stringWithFormat:@"%@", [CameraCapability getIrLedModeFromModel:self.deviceModel]]];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    // 3 Selections
    NSString *value = [CameraCapability getIrLedModeFromModel:self.deviceModel];

    PopupSelectionCheckedItemModel *first = [PopupSelectionCheckedItemModel createWithTitle:NSLocalizedString(@"AUTO", nil) subtitle:NSLocalizedString(@"The camera will determine when infrared light is needed.", nil) selected:NO];
    [first setReturnObj:kEnumCameraIrLedModeAUTO];
    [first setSelected:[value isEqualToString: kEnumCameraIrLedModeAUTO]];

    PopupSelectionCheckedItemModel *second = [PopupSelectionCheckedItemModel createWithTitle:NSLocalizedString(@"ON", nil) subtitle:NSLocalizedString(@"The infrared light will always be on.", nil) selected:NO];
    [second setReturnObj:kEnumCameraIrLedModeON];
    [second setSelected:[value isEqualToString: kEnumCameraIrLedModeON]];

    PopupSelectionCheckedItemModel *third = [PopupSelectionCheckedItemModel createWithTitle:NSLocalizedString(@"OFF", nil) subtitle:NSLocalizedString(@"The infrared light will always be off.", nil) selected:NO];
    [third setReturnObj:kEnumCameraIrLedModeOFF];
    [third setSelected:[value isEqualToString: kEnumCameraIrLedModeOFF]];


    NSArray *items = @[first, second, third];

    PopupSelectionCheckedTextView *view = [PopupSelectionCheckedTextView create:NSLocalizedString(@"CHOOSE A SETTING", nil) subtitle:NSLocalizedString(@"Infrared light improves image quality in low-light situations, and will display clips in black and white", nil) items:items];


    [super popup:view complete:@selector(completedSelected:)];
}

- (void)completedSelected:(NSString *)selectedValue {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [CameraCapability setIrLedMode:selectedValue onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {

    if ([self hasIrValueChanged:[attributes allKeys]]) {
        NSString *value = [attributes objectForKey:kAttrCameraIrLedMode];
        [self setValue:value];
        [self refreshView];
    }
}

- (BOOL)hasIrValueChanged:(NSArray *)keys {

    for (NSString *key in keys) {
        if ([key isEqualToString:kAttrCameraIrLedMode]) {
            return YES;
        }
    }

    return NO;
}


@end

@implementation DeviceSettingCameraRotateCamera180Unit

- (void)loadData {
    [super loadData];
    
    [self setTitle:NSLocalizedString(@"Rotate camera 180º", nil)];
    [self setSubtitle:NSLocalizedString(@"If your picture is upside down, then tap the switch to rotate the orientation of the camera 180º. Typically used if the camera is mounted upside down.", nil)];
    [self setSwitchState:[self isRotationOn]];
}

- (void)updatedSwitchState:(BOOL)state {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [CameraCapability setFlip:state onModel:self.deviceModel];
        [CameraCapability setMirror:state onModel:self.deviceModel];
        [self.deviceModel commit];
    });
}

- (void)updateDeviceState:(NSDictionary *)attributes initialUpdate:(BOOL)isInitial {
    [self setSwitchState:[self isRotationOn]];
    [self refreshView];
}

- (BOOL)isRotationOn {
    return [CameraCapability getFlipFromModel:self.deviceModel] && [CameraCapability getMirrorFromModel:self.deviceModel];
}

@end

@implementation DeviceSettingCameraLocalStreamingUnit

- (void)loadData {
    [super loadData];

    [self setTitle:NSLocalizedString(@"Local Streaming", nil)];
    [self setSubtitle:NSLocalizedString(@"Obtain the URL of your camera's live stream to view in 3rd party applications.", nil)];
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    CameraLocalStreamingSettingsViewController *vc = [CameraLocalStreamingSettingsViewController create:self.deviceModel];

    if (self.openSettings) {
        self.openSettings(vc);
    }
}

@end

#pragma mark - 
#pragma mark : Fob settings
@implementation DeviceSettingKeyFobButton {
    ButtonType _type;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = (ButtonType)0;
        [self setTitle:ButtonTypeToString(0)];
        [self setLogoImage:[UIImage imageNamed:ButtonTypeToString(0)]];
    }
    return self;
}

- (instancetype)initWithButtonType:(ButtonType)type productId:(NSString *)name {
    self = [super init];
    if (self) {
        _type = type;
      if ([name isEqualToString:kGen3FourButtonFob] ){
        NSDictionary *map = @{@"b":@"b_v3", @"a":@"a_v3", @"away":@"away_v3", @"home":@"home_v3"};
        NSString *v3ImageName = map[ButtonTypeToString(type)];
        UIImage *keyfobv3image = [UIImage imageNamed:v3ImageName];
        [self setTitle:ButtonTypeToString(type)];
        [self setLogoImage:keyfobv3image];
      } else {
        [self setLogoImage:[UIImage imageNamed:ButtonTypeToString(type)]];
        [self setTitle:ButtonTypeToString(type)];
      }


    }
    return self;
}

- (void)pressedBackgroup:(DeviceSettingCell *)cell {
    KeyFobRuleSettingButtonController *vc = [KeyFobRuleSettingButtonController create:_type device:self.deviceModel];
    [vc setPopupOwner:self Style:YES];
    
    [self.controlOwner presentViewController:vc animated:YES completion:nil];
}

- (void)selected:(id)value {
    DDLogWarn(@"Select Rule %@",value);
}

@end
