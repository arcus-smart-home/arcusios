//
//  SceneDeviceOptions.m
//  i2app
//
//  Created by Arcus Team on 12/24/15.
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
#import "SceneDeviceOptions.h"
#import "ClimateSubSystemController.h"
#import "CommonCheckableCell.h"
#import "CommonTitleWithSwitchCell.h"
#import "CommonTitleValueonRightCell.h"
#import "CommonTitleWithSubtitleCell.h"
#import "SceneManager.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionNumberView.h"
#import "SceneController.h"
#import "ThermostatCapability.h"
#import "DeviceController.h"



@interface SceneAlarmDeviceOptions()

@property (nonatomic, strong) SceneActionSelector *currectSelector;

@end

NSString *const kCoolSetPoint = @"coolSetPoint";
NSString *const kHeatSetPoint = @"heatSetPoint";

@implementation SceneAlarmDeviceOptions {
    NSMutableArray<SimpleTableCell *> *_list;
}

+ (SceneAlarmDeviceOptions *)create:(SceneActionSelector *)selector {
    SceneAlarmDeviceOptions *option = [[SceneAlarmDeviceOptions alloc] init];
    // There is only one selector in Security Alarm Scenes
    option.currectSelector = selector;
    return option;
}

- (NSString *) getTitle {
    return NSLocalizedString(@"Security Alarm", nil);
}
- (NSString *) getHeaderText {
    return NSLocalizedString(@"What should the Security Alarm do when this Scene runs?", nil);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    if (_list) {
        return _list;
    }
    
    // Use "title" attribute for the title of the cell
    // Only the "NOT PARTICIPATE" needs to be hardcoded
    NSDictionary *context = [[SceneManager sharedInstance].currentScene getSelectorContext:self.currectSelector.selectorId];
    SceneActionSelectorAttributeValue *selectorValues = (SceneActionSelectorAttributeValue *)((SceneActionSelectorAttribute *)self.currectSelector.attributes[0]).value;
    int selectedIndex;
    if (context) {
        NSString *valueStr = context[self.currectSelector.attributes[0].name];
        
        if ([valueStr isEqualToString:@"ON"]) {
            selectedIndex = 0;
        }
        else if ([valueStr isEqualToString:@"PARTIAL"]) {
            selectedIndex = 1;
        }
        else if ([valueStr isEqualToString:@"OFF"]) {
            selectedIndex = 2;
        }
        else {
            selectedIndex = -1;
        }
    }
    else {
        selectedIndex = -1;
    }
    // Get the available values
    _list = [[NSMutableArray alloc] init];
    NSString *title;
    {
        CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
        [cell setTitle:@"NOT PARTICIPATE" withSubtitle:@"This Scene will not change the state of the Security Alarm when it runs." isBlack:newStyle];
        
        [_list addObject:[SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onPressNotParticipate:)]];
        [cell setSelectedBox:selectedIndex == -1];
    } {
        CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
        title = [[selectorValues getTitleForIndex:0] uppercaseString];
        [cell setTitle:title isBlack:newStyle];
        [_list addObject:[SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onPressOn:)]];
        [cell setSelectedBox:selectedIndex == 0];
    } {
        CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
        title = [[selectorValues getTitleForIndex:1] uppercaseString];
        [cell setTitle:title isBlack:newStyle];
        [_list addObject:[SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onPressPartial:)]];
        [cell setSelectedBox:selectedIndex == 1];
    } {
        CommonCheckableCell *cell = [CommonCheckableCell create:tableView];
        title = [[selectorValues getTitleForIndex:2] uppercaseString];
        [cell setTitle:title isBlack:newStyle];
        [_list addObject:[SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onPressOff:)]];
        [cell setSelectedBox:selectedIndex == 2];
    }
    
    return _list;
}

- (void)unselectAllCheck {
    for (SimpleTableCell *cell in _list) {
        [(CommonCheckableCell *)cell.tableCell setSelectedBox:NO];
    }
}

- (void)onPressNotParticipate:(SimpleTableCell *)cell {
    [self unselectAllCheck];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [self.ownerController createGif];
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:@"" forIndex:NSNotFound].thenInBackground(^ {
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [(CommonCheckableCell *)cell.tableCell setSelectedBox:YES];
                [super refresh];
            }).finally(^{
                [self.ownerController hideGif];
            });
        }).catch(^{
            [self.ownerController hideGif];
        });
    });
}

- (void)onPressOn:(SimpleTableCell *)cell {
    [self.ownerController createGif];
    [self unselectAllCheck];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        SceneActionSelectorAttributeValue *values = ((SceneActionSelectorAttribute *)_currectSelector.attributes[0]).value;
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:[values getConfigurableValueForIndex:0] forIndex:NSNotFound].thenInBackground(^ {
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [(CommonCheckableCell *)cell.tableCell setSelectedBox:YES];
                [super refresh];
            }).finally(^{
                [self.ownerController hideGif];
            });
        }).catch(^{
            [self.ownerController hideGif];
        });
    });
}

- (void)onPressPartial:(SimpleTableCell *)cell {
    [self.ownerController createGif];
    [self unselectAllCheck];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        SceneActionSelectorAttributeValue *values = ((SceneActionSelectorAttribute *)_currectSelector.attributes[0]).value;
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:[values getConfigurableValueForIndex:1] forIndex:NSNotFound].thenInBackground(^ {
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [(CommonCheckableCell *)cell.tableCell setSelectedBox:YES];
                [super refresh];
            }).finally(^{
                [self.ownerController hideGif];
            });
        }).catch(^{
            [self.ownerController hideGif];
        });
    });
}

- (void)onPressOff:(SimpleTableCell *)cell {
    [self.ownerController createGif];
    [self unselectAllCheck];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        SceneActionSelectorAttributeValue *values = ((SceneActionSelectorAttribute *)_currectSelector.attributes[0]).value;
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:[values getConfigurableValueForIndex:2] forIndex:NSNotFound].thenInBackground(^ {
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [(CommonCheckableCell *)cell.tableCell setSelectedBox:YES];
                [super refresh];
            }).finally(^{
                [self.ownerController hideGif];
            });
        }).catch(^{
            [self.ownerController hideGif];
        });
    });
}
#pragma clang diagnostic pop

- (void)initializeView {
    
}

@end

@interface SceneThermostatDeviceOptions()

@property (nonatomic, strong) SceneActionSelector *currectSelector;

@end


@implementation SceneThermostatDeviceOptions {
    SimpleTableCell *_scheduleCell;
    SimpleTableCell *_modeCell;
    SimpleTableCell *_heatCell;
    SimpleTableCell *_coolCell;
    
    ThermostatMode _currentMode;

    int     _coolSetPoint;
    int     _heatSetPoint;
}

+ (SceneThermostatDeviceOptions *)create:(SceneActionSelector *)selector {
    SceneThermostatDeviceOptions *option = [[SceneThermostatDeviceOptions alloc] init];
    option.currectSelector = selector;
    return option;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentMode = ThermostatModeNone;

        _coolSetPoint = kThermostatDefaultCoolTemperature;
        _heatSetPoint = kThermostatDefaultHeatTemperature;
    }
    return self;
}

- (void)initializeData {
    NSDictionary *context = [[SceneManager sharedInstance].currentScene getSelectorContext:self.currectSelector.selectorId];
    if (context.count > 0) {
        context = context.allValues[0];
    }
    NSNumber *enable = [self getEnableValueWithContext:context][@"scheduleEnabled"];
    
    if (!context || ![context isKindOfClass:[NSDictionary class]] || ![context objectForKey:@"mode"] || [enable isEqualToNumber:@(1)]) {
        _currentMode = ThermostatModeNone;
    }
    else {
        _currentMode = [self stringToMode:context[@"mode"]];
    }
}

- (NSDictionary *)getEnableValueWithContext:(NSDictionary*)context {
    NSDictionary *inputContext = context;
    NSDictionary *enableContext;
    
    if ([context[@"scheduleEnabled"] isKindOfClass:[NSNumber class]]) {
        return context;
    }
    
    while(true) {
        enableContext = inputContext[@"scheduleEnabled"];
        
        if ([enableContext[@"scheduleEnabled"] isKindOfClass:[NSNumber class]]) {
            break;
        }
        
        inputContext = enableContext;
    }

    return enableContext;
}

- (NSString *) getTitle {
    return @"Thermostat";
}

- (NSString *) getHeaderText {
    return nil;
}

- (NSString *)toTemparatureString:(NSNumber *)temp {
    int tempInFarah = (int)lround([DeviceController celsiusToFahrenheit:temp.doubleValue]);
    return [NSString stringWithFormat:@"%d°", tempInFarah];
}

- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {

  NSDictionary *context = [[SceneManager sharedInstance].currentScene getSelectorContext:self.currectSelector.selectorId];
  DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.currectSelector.selectorId];

  if (context.count > 0) {
    context = context.allValues[0];
  }

  if (!_scheduleCell) {
    CommonTitleWithSwitchCell *cell = [CommonTitleWithSwitchCell create:tableView];
    [cell setTitle:@"FOLLOW SCHEDULE" subtitle:@"Turn the schedule OFF if you want to manually set a constant temperature" selected:YES isBlack:newStyle];

    _scheduleCell = [SimpleTableCell create:cell withOwner:self andPressSelector:@selector(onPressSchedule:)];

    NSNumber *enabled = [self getEnableValueWithContext:context][@"scheduleEnabled"];
    [((CommonTitleWithSwitchCell *)_scheduleCell.tableCell) setSwitchSelected:(enabled && enabled.boolValue)];

    NSString *modeText = context[@"mode"];

    if ((_currentMode == ThermostatModeAuto) && device.deviceType == DeviceTypeThermostatNest) {
      modeText = NSLocalizedString(@"HEAT ● COOL", @"");
    }

    _modeCell = [SimpleTableCell create:[CommonTitleValueonRightCell create:tableView]
                              withOwner:self
                       andPressSelector:@selector(onPressMode:)];
    [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE"
                                                         sideValue:modeText
                                                           isBlack:newStyle];

    _coolCell = [SimpleTableCell create:[CommonTitleWithSubtitleCell create:tableView]
                              withOwner:self
                       andPressSelector:@selector(onPressTemp:)];
    _coolCell.dataObject = kEnumThermostatHvacmodeCOOL;

    _heatCell = [SimpleTableCell create:[CommonTitleWithSubtitleCell create:tableView]
                              withOwner:self
                       andPressSelector:@selector(onPressTemp:)];
    _heatCell.dataObject = kEnumThermostatHvacmodeHEAT;
  }

  switch (_currentMode) {
    case ThermostatModeNone:
      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[];
      } else {
        return @[_scheduleCell];
      }

    case ThermostatModeAuto: {
      NSString *modeText = context[@"mode"];

      if (device.deviceType == DeviceTypeThermostatNest) {
        modeText = NSLocalizedString(@"HEAT ● COOL", @"");
      }

      [((CommonTitleWithSubtitleCell *)_coolCell.tableCell) setTitle:@"COOL TO" subtitle:@"Choose the target cooling setpoint" side:[self toTemparatureString:context[kCoolSetPoint]] isBlack:newStyle];
      [((CommonTitleWithSubtitleCell *)_heatCell.tableCell) setTitle:@"HEAT TO" subtitle:@"Choose the target heating setpoint" side:[self toTemparatureString:context[kHeatSetPoint]] isBlack:newStyle];
      [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE" sideValue:modeText isBlack:newStyle];

      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[_modeCell, _coolCell, _heatCell];
      } else {
        return @[_scheduleCell, _modeCell, _coolCell, _heatCell];
      }
    }
    case ThermostatModeCool:
      [((CommonTitleWithSubtitleCell *)_coolCell.tableCell) setTitle:@"TEMPERATURE" subtitle:@"" side:[self toTemparatureString:context[kCoolSetPoint]] isBlack:newStyle];
      [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE" sideValue:@"Cool" isBlack:newStyle];


      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[_modeCell, _coolCell];
      } else {
        return @[_scheduleCell, _modeCell, _coolCell];
      }

    case ThermostatModeHeat:
      [((CommonTitleWithSubtitleCell *)_heatCell.tableCell) setTitle:@"TEMPERATURE" subtitle:@"" side:[self toTemparatureString:context[kHeatSetPoint]] isBlack:newStyle];
      [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE" sideValue:@"Heat" isBlack:newStyle];

      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[_modeCell, _heatCell];
      } else {
        return @[_scheduleCell, _modeCell, _heatCell];
      }

    case ThermostatModeOff:
      [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE" sideValue:@"Off" isBlack:newStyle];

      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[_modeCell];
      } else {
        return @[_scheduleCell, _modeCell];
      }

    case ThermostatModeEco:
      [((CommonTitleValueonRightCell *)_modeCell.tableCell) setTitle:@"MODE" sideValue:@"Eco" isBlack:newStyle];

      if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
        return @[_modeCell];
      } else {
        return @[_scheduleCell, _modeCell];
      }

    default:
      break;
  }
  return @[];
}

- (void)onPressSchedule:(SimpleTableCell *)cell {
    BOOL enabled = !((CommonTitleWithSwitchCell *)cell.tableCell).switchSelected;
    [((CommonTitleWithSwitchCell *)cell.tableCell) setSwitchSelected:enabled];
    
    // TODO: maybe the mode is not auto...
    _currentMode = enabled ? ThermostatModeNone : ThermostatModeAuto;
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSDictionary *dict = @{ @"scheduleEnabled" : @(enabled), @"mode" : @"AUTO", kCoolSetPoint : @([DeviceController fahrenheitToCelsius:_coolSetPoint]), kHeatSetPoint: @([DeviceController fahrenheitToCelsius:_heatSetPoint]) };
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:dict forIndex:NSNotFound].thenInBackground(^ {
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [super refresh];
            });
        });
    });
}

- (void)onPressMode:(SimpleTableCell *)cell {

  NSMutableArray *buttons = [NSMutableArray new];
  DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.currectSelector.selectorId];
  NSArray *modes = [DeviceController availableModesForModel:device];

  // Ensure order of options
  if ([self isMode: kEnumThermostatHvacmodeHEAT inModes: modes]) {
    [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"HEAT", @"") event:@selector(choseMode:) obj:@(ThermostatModeHeat)]];
  }
  if ([self isMode: kEnumThermostatHvacmodeCOOL inModes: modes]) {
    [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"COOL", @"") event:@selector(choseMode:) obj:@(ThermostatModeCool)]];
  }
  if ([self isMode: kEnumThermostatHvacmodeAUTO inModes: modes]) {
    NSString *modeText = NSLocalizedString(@"AUTO", @"");
    if (device.deviceType == DeviceTypeThermostatNest) {
      modeText = NSLocalizedString(@"HEAT ● COOL", @"");
    }
    [buttons addObject:[PopupSelectionButtonModel create:modeText event:@selector(choseMode:) obj:@(ThermostatModeAuto)]];
  }
  if ([self isMode: kEnumThermostatHvacmodeECO inModes: modes]) {
    [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"ECO", @"") event:@selector(choseMode:) obj:@(ThermostatModeEco)]];
  }
  if ([self isMode: kEnumThermostatHvacmodeOFF inModes: modes]) {
    [buttons addObject:[PopupSelectionButtonModel create:NSLocalizedString(@"OFF", @"") event:@selector(choseMode:) obj:@(ThermostatModeOff)]];
  }

  PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Choose A Mode", nil) buttons:buttons];
  buttonView.owner = self;
  [self popup:buttonView complete:nil];
}

- (BOOL)isMode:(NSString *)mode inModes: (NSArray *)modes {
  for (NSString *currentMode in modes) {
    if ([currentMode isEqualToString:mode]) {
      return YES;
    }
  }

  return NO;
}

- (void)choseMode:(id)obj {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSDictionary *context = [[SceneManager sharedInstance].currentScene getSelectorContext:self.currectSelector.selectorId];

        if (context.count > 0) {
            context = context.allValues[0];
        }
        NSNumber *coolSetPoint = context[kCoolSetPoint];
        NSNumber *heatSetPoint = context[kHeatSetPoint];
        if (!coolSetPoint) {
            coolSetPoint = @([DeviceController fahrenheitToCelsius:_coolSetPoint]);
        }
        if (!heatSetPoint) {
            heatSetPoint = @([DeviceController fahrenheitToCelsius:_heatSetPoint]);
        }

        _currentMode = [obj intValue];
        if (_currentMode == ThermostatModeAuto) {
            if (coolSetPoint.intValue - heatSetPoint.intValue < 3) {
                _coolSetPoint = kThermostatDefaultCoolTemperature;
                _heatSetPoint = kThermostatDefaultHeatTemperature;
                coolSetPoint = @([DeviceController fahrenheitToCelsius:_coolSetPoint]);
                heatSetPoint = @([DeviceController fahrenheitToCelsius:_heatSetPoint]);
            }
        }
        NSString *mode = [self modeToString:_currentMode];
        
        NSDictionary *params = @{ @"scheduleEnabled" : @(NO), @"mode" : mode, kCoolSetPoint : coolSetPoint, kHeatSetPoint: heatSetPoint };
        [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:params forIndex:NSNotFound].thenInBackground(^{
            [[SceneManager sharedInstance].currentScene refresh].then(^(NSObject *obj) {
                [super refresh];
            });
        });
    });
}

- (NSString *)modeToString:(ThermostatMode)mode {
  switch (mode) {
    case ThermostatModeAuto:
      return kEnumThermostatHvacmodeAUTO;

    case ThermostatModeCool:
      return kEnumThermostatHvacmodeCOOL;

    case ThermostatModeHeat:
      return kEnumThermostatHvacmodeHEAT;

    case ThermostatModeOff:
      return kEnumThermostatHvacmodeOFF;
    case ThermostatModeEco:
      return kEnumThermostatHvacmodeECO;

    default:
      break;
  }
  return @"";
}

- (ThermostatMode)stringToMode:(NSString *)mode {
    if ([mode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
        return ThermostatModeAuto;
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
        return ThermostatModeHeat;
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeCOOL]) {
        return ThermostatModeCool;
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeOFF]) {
        return ThermostatModeOff;
    }
    else if ([mode isEqualToString:kEnumThermostatHvacmodeECO]) {
      return ThermostatModeEco;
    }
    return ThermostatModeNone;
}

- (void)onPressTemp:(SimpleTableCell *)cell {
  PopupSelectionBaseContainer *selection;

  NSDictionary *context = [[SceneManager sharedInstance].currentScene getSelectorContext:self.currectSelector.selectorId];
  if (context.count > 0) {
    context = context.allValues[0];
  }
  NSNumber *coolSetPointNum = context[kCoolSetPoint];
  NSNumber *heatSetPointNum = context[kHeatSetPoint];
  if (!coolSetPointNum) {
    coolSetPointNum = @([DeviceController fahrenheitToCelsius:_coolSetPoint]);
  }
  if (!heatSetPointNum) {
    heatSetPointNum = @([DeviceController fahrenheitToCelsius:_heatSetPoint]);
  }
  int heatSetPoint = (int)lround([DeviceController celsiusToFahrenheit:((NSNumber *)heatSetPointNum).doubleValue]);
  int coolSetPoint = (int)lround([DeviceController celsiusToFahrenheit:((NSNumber *)coolSetPointNum).doubleValue]);

  DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:self.currectSelector.selectorId];

  int minSetpoint = (int)[DeviceController getMinSetpointForModel: device];
  int maxSetpoint = (int)[DeviceController getMaxSetpointForModel: device];
  int separation = (int)[DeviceController getSetpointSeparationForModel:device];

  if (_currentMode == ThermostatModeAuto) {
    if ([((NSString *)cell.dataObject) isEqualToString: @"COOL"]) {
      selection = [PopupSelectionNumberView create:@"TEMPERATURE" withMinNumber:(heatSetPoint + separation) maxNumber:maxSetpoint withSign:@"°F"];
      [selection setCurrentKey:@(coolSetPoint)];
    }
    else if ([((NSString *)cell.dataObject) isEqualToString: @"HEAT"]) {
      selection = [PopupSelectionNumberView create:@"TEMPERATURE" withMinNumber:minSetpoint maxNumber:(coolSetPoint - separation) withSign:@"°F"];
      [selection setCurrentKey:@(heatSetPoint)];
    }
  }
  else {
    selection = [PopupSelectionNumberView create:@"TEMPERATURE" withMinNumber:minSetpoint maxNumber:maxSetpoint withSign:@"°F"];

    if ([((NSString *)cell.dataObject) isEqualToString: @"COOL"]) {
      [selection setCurrentKey:@(coolSetPoint)];
    }
    else if ([((NSString *)cell.dataObject) isEqualToString: @"HEAT"]) {
      [selection setCurrentKey:@(heatSetPoint)];
    }
  }
  selection.dataObject = cell;
  [self popup:selection complete:@selector(choseTemp:withCell:)];
}

- (void)choseTemp:(NSNumber *)value withCell:(SimpleTableCell *)cell {
    double tempInCelsius = [DeviceController fahrenheitToCelsius:value.doubleValue];
    NSDictionary *params;
    if (_currentMode != ThermostatModeAuto) {
        if (_currentMode == ThermostatModeCool) {
            params = @{ @"scheduleEnabled": @(NO), @"mode": [self modeToString:_currentMode], kCoolSetPoint : @(tempInCelsius) };
        }
        else if (_currentMode == ThermostatModeHeat) {
            params = @{ @"scheduleEnabled": @(NO), @"mode": [self modeToString:_currentMode], kHeatSetPoint : @(tempInCelsius) };
        }
    }
    else if (_currentMode == ThermostatModeAuto) {
        // Calculate the difference between set points: it should not be less
        // than 3 degrees fahrenheit in Auto mode
        if ([((NSString *)cell.dataObject) isEqualToString:kEnumThermostatHvacmodeHEAT]) {
            // The Heatpoint is being modified
            float coolSetPoint = ((CommonTitleWithSubtitleCell *)_coolCell.tableCell).sideValueString.intValue;
            float heatSetPoint = value.intValue;
            
            if (heatSetPoint + 3 > coolSetPoint) {
                coolSetPoint = heatSetPoint + 3;
            }
            params = @{ @"scheduleEnabled": @(NO), @"mode": [self modeToString:_currentMode], kCoolSetPoint : @([DeviceController fahrenheitToCelsius:coolSetPoint]), kHeatSetPoint : @([DeviceController fahrenheitToCelsius:heatSetPoint]) };
        }
        else if ([((NSString *)cell.dataObject) isEqualToString:kEnumThermostatHvacmodeCOOL]) {
            // The Coolpoint is being modified
            float coolSetPoint =  value.intValue;
            float heatSetPoint = ((CommonTitleWithSubtitleCell *)_heatCell.tableCell).sideValueString.intValue;
            
            if (coolSetPoint - 3 < heatSetPoint) {
                heatSetPoint = coolSetPoint - 3;
            }
            params = @{ @"scheduleEnabled": @(NO), @"mode": [self modeToString:_currentMode], kCoolSetPoint : @([DeviceController fahrenheitToCelsius:coolSetPoint]), kHeatSetPoint : @([DeviceController fahrenheitToCelsius:heatSetPoint]) };
        }
    }
    else {
        params = nil;
    }
    
    if (params) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [[SceneManager sharedInstance].currentScene saveSelectorValue:self.currectSelector newValue:params forIndex:NSNotFound].thenInBackground(^ {
                [[SceneManager sharedInstance].currentScene refresh].then(^ {
                    [super refresh];
                });
            });
        });
    }
}

@end


