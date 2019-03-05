//
//  DeviceModel+Extension.h
//  i2app
//
//  Created by Arcus Team on 6/11/15.
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

typedef NS_ENUM(NSInteger, DeviceType) {
  DeviceTypeNone          = 0,
  DeviceTypeAccessory,
  DeviceTypeAlarm,
  DeviceTypeButton,
  DeviceTypeCamera,
  DeviceTypeCarePendant,
  DeviceTypePetDoor,
  DeviceTypeContactSensor,
  DeviceTypeDimmer,
  DeviceTypeFanSwitch,
  DeviceTypeGarageDoor,
  DeviceTypeGarageDoorController,
  DeviceTypeGlassBreak,
  DeviceTypeHub,
  DeviceTypeIrrigation,
  DeviceTypeKeyFob,
  DeviceTypeKeyPad,
  DeviceTypeLocks,
  DeviceTypeLightBulb,
  DeviceTypeMotionSensor,
  DeviceTypePendantSensor,
  DeviceTypeSmokeDetector,
  DeviceTypeSiren,
  DeviceTypeSwitch,
  DeviceTypeThermostat,
  DeviceTypeTiltSensor,
  DeviceTypeVent,
  DeviceTypeWaterHeater,
  DeviceTypeWaterLeak,
  DeviceTypeWaterSoftener,
  DeviceTypeWaterValve,
  DeviceTypeAddFavorite,
  DeviceTypeThermostatHoneywellC2C,
  DeviceTypeSomfyBlinds,
  DeviceTypeSomfyBlindsController,
  DeviceTypeAlexa,
  DeviceTypeGoogleHomeAssistant,
  DeviceTypeWifiSwitch,
  DeviceTypeSpaceHeater,
  DeviceTypeHalo,
  DeviceTypeShade,
  DeviceTypeThermostatNest,
  DeviceTypeHueBridge,
  DeviceTypeHueFallback,
  DeviceTypeLutronCasetaSmartBridge
};

// !!!!: If DeviceType enum got update, update type of string too :!!!! //
#define DeviceTypeToString(enum) [@[@"DeviceNone", @"DeviceAccessory", @"DeviceAlarm", @"DeviceButton", @"DeviceCamera", @"DeviceCarePendant", @"DevicePetDoor", @"DeviceContactSensor", @"DeviceDimmer", @"DeviceFanSwitch", @"DeviceGarageDoor", @"DeviceGarageDoorController", @"DeviceGlassBreak", @"DeviceHub", @"DeviceIrrigation", @"DeviceKeyFob", @"DeviceKeyPad", @"DeviceLocks", @"DeviceLightBulb", @"DeviceMotionSensor", @"DevicePendantSensor", @"DeviceSmokeDetector", @"DeviceSiren", @"DeviceSwitch", @"DeviceThermostat", @"DeviceTiltSensor", @"DeviceVent", @"DeviceWaterHeater", @"DeviceWaterLeak", @"DeviceWaterSoftener", @"DeviceWaterValve", @"DeviceAddFavorite", @"DeviceThermostatHoneywell", @"DeviceSomfyBlinds", @"DeviceSomfyBlindsController", @"DeviceTypeAlexa", @"DeviceTypeGoogleHomeAssistant", @"DeviceTypeWifiSwitch", @"DeviceTypeSpaceHeater", @"DeviceTypeHalo", @"DeviceTypeShade", @"DeviceThermostatNest", @"DeviceTypeHueBridge", @"DeviceTypeHueFallback", @"DeviceTypeLutronCasetaSmartBridge"] objectAtIndex:enum]
#define DeviceTypeToDeviceModel(enum) [@[@"DeviceDetailsEmpty", @"DeviceDetailsAccessory", @"DeviceDetailsAlarm", @"DeviceDetailsButton", @"DeviceDetailsCamera", @"DeviceDetailsCarePendant", @"DeviceDetailsPetDoor", @"DeviceDetailsContactSensor", @"DeviceDetailsDimmer", @"DeviceDetailsFanSwitch", @"DeviceDetailsGarageDoor", @"DeviceDetailGarageDoorController", @"DeviceDetailsGlassBreak", @"DeviceDetailsHub", @"DeviceDetailsIrrigation", @"DeviceDetailsKeyFob", @"DeviceDetailsKeyPad", @"DeviceDetailsLock", @"DeviceDetailsDimmer", @"DeviceDetailsMotionSensor", @"DeviceDetailsPendantSensor", @"DeviceDetailsSmokeDetector", @"DeviceDetailsSiren", @"DeviceDetailsSwitch", @"DeviceDetailsThermostat", @"DeviceDetailsTiltSensor", @"DeviceDetailsVent", @"DeviceDetailsWaterHeater", @"DeviceDetailsWaterLeak", @"DeviceDetailsWaterSoftener", @"DeviceDetailsWaterValve", @"DeviceDetailsAddFavorite", @"DeviceDetailsThermostatHoneywell", @"DeviceDetailsSomfyBlinds", @"DeviceDetailsSomfyBlindsController", @"DeviceDetailsEmpty", @"DeviceDetailsEmpty", @"DeviceDetailsSwitch", @"DeviceDetailsDuraflame", @"DeviceDetailsHalo", @"DeviceDetailsShade", @"DeviceDetailsThermostatNest", @"DeviceDetailsHueFallback", @"DeviceDetailsHueBridge", @"DeviceDetailsLutronCasetaSmartBridge"] objectAtIndex:enum]


typedef enum {
  ButtonTypeCircle    = 0,
  ButtonTypeDiamond,
  ButtonTypeHexagon,
  ButtonTypeSquare,
  ButtonTypeHome,
  ButtonTypeAway,
  ButtonTypeNone,
  ButtonTypeA,
  ButtonTypeB
} ButtonType;

#define ButtonTypeName @[@"circle", @"diamond", @"hexagon", @"square", @"home", @"away", @"none", @"a", @"b"]
#define KeyfobV3ImageMap @{@"b":@"b_v3", @"a":@"a_v3", @"away":@"away_v3", @"home":@"home_v3"}
#define ButtonTypeToString(enum) [ButtonTypeName objectAtIndex:enum]
#define stringToButtonType(str) (ButtonType)[ButtonTypeName indexOfObject:str]
