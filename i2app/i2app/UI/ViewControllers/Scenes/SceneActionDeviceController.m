//
//  SceneActionDeviceController.m
//  i2app
//
//  Created by Arcus Team on 11/2/15.
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
#import "SceneActionDeviceController.h"
#import "CommonCheckableImageCell.h"
#import "PopupSelectionDeviceView.h"
#import "PopupSelectionNumberView.h"
#import "PopupSelectionListView.h"
#import "SceneManager.h"
#import "DeviceCapability.h"
#import "SceneController.h"
#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "ImagePaths.h"
#import "SimpleTableViewController.h"
#import "SceneDeviceOptions.h"

#import "SceneCapability.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"
#import "DeviceController.h"
#import "ThermostatCapability.h"
#import "DeviceController.h"

#define SEPARATOR_LEFT_INSET 75.0f

@interface SceneActionDeviceController()

@property (weak, nonatomic) IBOutlet UIView *headerTabView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
@property (weak, nonatomic) IBOutlet UIView *headerSeparator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (nonatomic) BOOL isEditing;
@property (nonatomic, strong) NSArray *firstGroupList;
@property (nonatomic, strong) NSArray *secondGroupList;

@property (strong, nonatomic) PopupSelectionDeviceView *deviceView;

@property (nonatomic, assign) NSArray *currentSelectorsList;
@end



@implementation SceneActionDeviceController {
    PopupSelectionWindow    *_popupWindow;
    BOOL                    _hasTabs;
    BOOL                    _inFirstList;
    NSArray                 *_tabLabels;
    
    SceneActionSelector     *_currentPickerSelector;
}

@dynamic currentSelectorsList;

+ (SceneActionDeviceController *)create {
    return [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _inFirstList = YES;
    _firstGroupList = [[NSArray alloc] init];
    _secondGroupList = [[NSArray alloc] init];
    
    [self navBarWithTitle:[NSLocalizedString([SceneManager sharedInstance].currentAction.name, nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(toggleEditState:)];
    [self addBackButtonItemAsLeftButtonItem];
    [self oneTimeUIConfig];
    
    [self reloadData];
    
    _hasTabs = _tabLabels.count > 0;
    [self switchTab:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionsChanged:) name:[Model attributeChangedNotification:kAttrSceneActions] object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view layoutIfNeeded];
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)oneTimeUIConfig {
    BOOL isNewScene = [SceneManager sharedInstance].isNewScene;
    
    [self setBackgroundColorToDashboardColor];
    self.heightConstraint.constant = [self hasTabs] ? 45 : 0;
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    self.tableView.separatorColor = isNewScene ? [FontColors getCreationSeparatorColor] : [FontColors getStandardSeparatorColor];
    [self addOverlay:!isNewScene];
    [self.addButton styleSet:@"Add Devices" andButtonType:[SceneManager sharedInstance].isNewScene ? FontDataTypeButtonDark : FontDataTypeButtonLight upperCase:YES];
}

#pragma mark - action capability
- (NSArray *)currentSelectorsList {
    return _inFirstList ? self.firstGroupList : self.secondGroupList;
}

- (void)removeSelectorAtIndex:(int)index {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.currentSelectorsList];
    [array removeObjectAtIndex:index];
    
    if (_inFirstList) {
        self.firstGroupList = array.copy;
    }
    else {
        self.secondGroupList = array.copy;
    }
}

- (BOOL)hasTabs {
    return _hasTabs;
}

- (NSString *)getHeaderText:(BOOL)first {
    switch ([SceneManager sharedInstance].currentAction.type) {
        case SceneActionTypeSecurity:
            return NSLocalizedString(@"What should the Security Alarm do when this Scene runs?", nil);
            break;
            
        case SceneActionTypeLight:
            return first ? NSLocalizedString(@"Which lights and switches do you want to turn on when this Scene runs?", nil) : NSLocalizedString(@"Which lights and switches do you want to turn off when this Scene runs?", nil);
            break;
            
        case SceneActionTypeCamera:
            return NSLocalizedString(@"Which cameras do you want to record when this scene runs?", nil);
            break;
            
        case SceneActionTypeThermostat:
            return [NSString stringWithFormat:NSLocalizedString(@"What will the thermostat(s)\ndo when this Scene runs?", nil), first ? NSLocalizedString(@"on", nil) : NSLocalizedString(@"off", nil)];
            break;
            
        case SceneActionTypeLock:
            return first ? NSLocalizedString(@"Which doors do you want to lock?", nil) : NSLocalizedString(@"Which doors do you want to unlock?", nil);
            break;
            
        case SceneActionTypeGarage:
            return first ? NSLocalizedString(@"Which garage doors do you want to open?", nil) : NSLocalizedString(@"Which garage doors do you want to close?", nil);
            break;
            
        case SceneActionTypeVent:
            return first ? NSLocalizedString(@"Which vents do you want to open?", nil) : NSLocalizedString(@"Which vents do you want to close?", nil);
            break;
            
        case SceneActionTypeFan:
            return first ? NSLocalizedString(@"Which fans do you want to turn on?", nil) : NSLocalizedString(@"Which fans do you want to turn off?", nil);
            break;
            
        case SceneActionTypeBlinds:
            return first ? NSLocalizedString(@"Which blinds do you want to open?", nil) : NSLocalizedString(@"Which blinds do you want to close?", nil);
            break;
            
        case SceneActionTypeWaterheater:
            return NSLocalizedString(@"What should the water heater do when this Scene runs?", nil);
            break;
            
        case SceneActionTypeSpaceHeater:
            return NSLocalizedString(@"Which space heaters do you want to turn on when this Scene runs?", nil);
            break;
            
        case SceneActionTypeValve:
            return first ? NSLocalizedString(@"Which water shut-off valve do you want to open when this Scene runs?", nil) : NSLocalizedString(@"Which water shut-off valve do you want to close when this Scene runs?", nil);
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)getTabText:(BOOL)first {
    
    return first ? NSLocalizedString(_tabLabels[0], nil) : NSLocalizedString(_tabLabels[1], nil);
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentSelectorsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SceneActionSelector *selector = self.currentSelectorsList[indexPath.row];
  DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:selector.selectorId];

  NSString *valueStr;
  NSObject *selectorValue = [[SceneManager sharedInstance].currentScene getSelectorValue:self.currentSelectorsList[indexPath.row] atIndex:_inFirstList ? 0 : 1];
  if (selectorValue) {
    if ([selectorValue isKindOfClass:[NSNumber class]]) {
      valueStr = ((NSNumber *)selectorValue).stringValue;
    }
    else if ([selectorValue isKindOfClass:[NSString class]]) {
      valueStr = (NSString *)selectorValue;
    }
  }
  else {
    valueStr = @"";
  }

  ArcusImageTitleDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

  if (device.deviceType == DeviceTypeThermostat ||
      device.deviceType == DeviceTypeThermostatNest ||
      device.deviceType == DeviceTypeThermostatHoneywellC2C ||
      [valueStr length] != 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellSubtitle"];
  }

  cell.accessoryImage.hidden = ![selector isConfigurable:_inFirstList ? 0 : 1];
  cell.titleLabel.text = selector.deviceName;
  cell.descriptionLabel.text = valueStr;

  if (device.deviceType == DeviceTypeThermostat || device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
    NSDictionary *context = [[[SceneManager sharedInstance] currentScene] getSelectorContext:selector.selectorId];
    NSDictionary *thermostatInfo = [context objectForKey:@"thermostat"];
    // Check for following schedule
    if ([thermostatInfo objectForKey:@"scheduleEnabled"] && [[thermostatInfo objectForKey:@"scheduleEnabled"] boolValue] == YES) {
      cell.descriptionLabel.text = NSLocalizedString(@"Follow Schedule", "");
    } else {
      NSString *mode = [thermostatInfo objectForKey:@"mode"];
      NSInteger heat = [DeviceController celsiusToFahrenheit: [[thermostatInfo objectForKey:@"heatSetPoint"] doubleValue]];
      NSInteger cool = [DeviceController celsiusToFahrenheit: [[thermostatInfo objectForKey:@"coolSetPoint"] doubleValue] ];

      if ([mode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
        NSString *modeText = NSLocalizedString(@"Heat", @"");
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %li°", modeText, (long)heat];
      } else if ([mode isEqualToString:kEnumThermostatHvacmodeCOOL]){
        NSString *modeText = NSLocalizedString(@"Cool", @"");
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %li°", modeText, (long)cool];
      } else if ([mode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
        NSString *modeText = NSLocalizedString(@"Auto", @"");
        if (device.deviceType == DeviceTypeThermostatNest) {
          modeText = NSLocalizedString(@"Heat-Cool", @"");
        }
        cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %li° - %li°", modeText, (long)heat, (long)cool];
      } else if ([mode isEqualToString:kEnumThermostatHvacmodeECO]) {
        NSString *modeText = NSLocalizedString(@"ECO", @"");
        cell.descriptionLabel.text = modeText;
      } else if ([mode isEqualToString:kEnumThermostatHvacmodeOFF]) {
        NSString *modeText = NSLocalizedString(@"Off", @"");
        cell.descriptionLabel.text = modeText;
      }
    }
  } else if (device.deviceType == DeviceTypeCamera) {
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ seconds", cell.descriptionLabel.text];
  } else if (device.deviceType == DeviceTypeVent && [cell.descriptionLabel.text length] > 0) {
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@%% Open", cell.descriptionLabel.text];
  } else if (device.deviceType == DeviceTypeLightBulb && [valueStr length] > 0) {
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@%% Brightness", cell.descriptionLabel.text];
  }

  UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:device.modelId atSize:[UIScreen mainScreen].bounds.size withScale:[UIScreen mainScreen].scale];
  if (image) {
    cell.detailImage.image = image;
  }
  else {
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:[SceneManager sharedInstance].isNewScene].then(^(UIImage *image) {
      cell.detailImage.image = image;
    });
  }

  BOOL isNewScene = [SceneManager sharedInstance].isNewScene;
  if (!isNewScene) {
    cell.accessoryImage.image = [UIImage imageNamed:@"ChevronWhite"];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusImageTitleDescriptionTableViewCell *theCell = (ArcusImageTitleDescriptionTableViewCell *)cell;
    theCell.backgroundColor = [UIColor clearColor];
    
    BOOL isNewScene = [SceneManager sharedInstance].isNewScene;
    UIColor *titleColor = isNewScene ? [FontColors getCreationHeaderTextColor] : [FontColors getStandardHeaderTextColor];
    UIColor *descriptionColor = isNewScene ? [FontColors getCreationSubheaderTextColor] : [FontColors getStandardSubheaderTextColor];
    theCell.titleLabel.textColor = titleColor;
    theCell.descriptionLabel.textColor = descriptionColor;
    
    CGFloat tableViewWidth = tableView.bounds.size.width;
    if (indexPath.row == self.currentSelectorsList.count - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, tableViewWidth/2, 0, tableViewWidth/2);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, SEPARATOR_LEFT_INSET, 0, 0);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.currentSelectorsList[indexPath.row] isConfigurable:_inFirstList ? 0 : 1]) {
        return indexPath;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentPickerSelector = self.currentSelectorsList[indexPath.row];
    id<SimpleTableDelegate> delegate = nil;
    
    switch ([SceneManager sharedInstance].currentAction.type) {
        case SceneActionTypeSecurity:
            delegate = [SceneAlarmDeviceOptions create:_currentPickerSelector];
            break;
            
        case SceneActionTypeThermostat:
            delegate = [SceneThermostatDeviceOptions create:_currentPickerSelector];
            break;
            
        default:
            break;
    }
    
    if (delegate) {
        // Present the options for the given selected scene device

        SimpleTableViewController *vc = [SimpleTableViewController createWithNewStyle:[SceneManager sharedInstance].isNewScene andDelegate:delegate];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        SceneActionSelectorAttribute *attribValue = _currentPickerSelector.attributes[0];
        if ([attribValue.attributeValues[0][1][0][@"type"] isEqualToString: @"PERCENT"]) {
            [self popupPickerPercentageDeviceWithName:attribValue.attributeValues[0][1][0][@"name"] withSelectorIndex:(int)indexPath.row];
            return;
        }
        else if ([attribValue.attributeValues[0][1][0][@"type"] isEqualToString:@"LIST"]) {
            [self popupPickerListWithName:attribValue.attributeValues[0][1][0][@"name"] withList:attribValue.attributeValues[0][1][0][@"value"] withSelectorIndex:(int)indexPath.row];
            return;
        }
        else if ([attribValue.attributeValues[0][1][0][@"type"] isEqualToString:@"TEMPERATURE"]) {
            int minF = [DeviceController celsiusToFahrenheit:[attribValue.attributeValues[0][1][0][@"min"] intValue]];
            int maxF = [DeviceController celsiusToFahrenheit:[attribValue.attributeValues[0][1][0][@"max"] intValue]];
            int step = [attribValue.attributeValues[0][1][0][@"step"] intValue];
            NSString* currentString = [[SceneManager sharedInstance].currentScene getSelectorValue:self.currentSelectorsList[indexPath.row] atIndex:_inFirstList ? 0 : 1];
            NSString* currentF = [currentString substringToIndex:[currentString length] - 1];
            
            PopupSelectionBaseContainer *container = [PopupSelectionNumberView create:attribValue.attributeValues[0][1][0][@"name"] withMinNumber:minF maxNumber:maxF stepNumber:step withSign:@"°"];
            [container setCurrentKey:[NSNumber numberWithInt:[currentF intValue]]];
            [self popup:container complete:@selector(pickedTemperature:)];
            return;
        }
        
        PopupSelectionBaseContainer *container = [PopupSelectionNumberView create:attribValue.name withMinNumber:attribValue.min.floatValue maxNumber:attribValue.max.floatValue stepNumber:attribValue.step.floatValue withSign:attribValue.unit];
        id selectedValue = [[SceneManager sharedInstance].currentScene getSelectorValue:self.currentSelectorsList[indexPath.row] atIndex:_inFirstList ? 0 : 1];
        [container setCurrentKey:selectedValue];
        [self popup:container complete:@selector(pickedValue:)];
    }
}

- (void)popupPickerPercentageDeviceWithName:(NSString *)name withSelectorIndex:(int)selectorIndex {
    PopupSelectionNumberView *popupView = [PopupSelectionNumberView create:name withMinNumber:10 maxNumber:100 stepNumber:10 withSign:@"\%"];
    id selectedValue = [[SceneManager sharedInstance].currentScene getSelectorValue:self.currentSelectorsList[selectorIndex] atIndex:_inFirstList ? 0 : 1];
    [popupView setCurrentKey:selectedValue];
    
    [self popup:popupView complete:@selector(pickedValue:)];
}

- (void)popupPickerListWithName:(NSString *)name withList:(NSArray *)valuesList withSelectorIndex:(int)selectorIndex {
    NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:valuesList.count];
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:valuesList.count];
    for (int i = 0; i < valuesList.count; i++) {
        [titles addObject:((NSArray *)valuesList[i])[0]];
        [values addObject:((NSArray *)valuesList[i])[1]];
    }
    PopupSelectionBaseContainer *container = [PopupSelectionListView create:name withTitlesList:titles withValuesList:values];
    
    id selectedKey = [[SceneManager sharedInstance].currentScene getSelectorValue:self.currentSelectorsList[selectorIndex] atIndex:_inFirstList ? 0 : 1];
    [container setCurrentKeyFuzzily:[selectedKey uppercaseString]];

    [self popup:container complete:@selector(pickedValue:)];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *deviceList = [NSMutableArray arrayWithArray:self.currentSelectorsList];
        SceneActionSelector *selectorToRemove = self.currentSelectorsList[indexPath.row];
        [deviceList removeObject:selectorToRemove];
        
        NSMutableArray *selectorDefaults = [[NSMutableArray alloc] init];
        for (SceneActionSelector *selectorAddress in self.currentSelectorsList) {
            SceneActionSelectorDefault *selectorDefault = [[SceneActionSelectorDefault alloc] init];
            selectorDefault.address = selectorAddress.selectorId;
            selectorDefault.initialParam = nil;
            selectorDefault.initialValue = nil;
            
            [selectorDefaults addObject:selectorDefault];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [[SceneManager sharedInstance].currentScene saveSelectorList:selectorDefaults unselectedSelectors:@[selectorToRemove.selectorId] withIndex:_inFirstList ? 0 : 1].thenInBackground(^ {
                [[SceneManager sharedInstance].currentScene refresh].then(^ {
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                    
                    [self removeSelectorAtIndex:(int)indexPath.row];
                    [tableView endUpdates];
                    
                    if (self.currentSelectorsList.count == 0) {
                        self.isEditing = NO;
                        [self checkEditState];
                    }
                });
            });
        });
    }
}

#pragma mark - onClick Actions
- (void)pickedValue:(id)value {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance].currentScene saveSelectorValue:_currentPickerSelector newValue:value forIndex:_inFirstList ? 0 : 1];
    });
}

- (void)pickedTemperature:(id)value {
    double tempC = [DeviceController fahrenheitToCelsius:[value doubleValue]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance].currentScene saveSelectorValue:_currentPickerSelector newValue:[NSNumber numberWithDouble:tempC] forIndex:_inFirstList ? 0 : 1];
    });
}

- (void)checkEditState {
    if (self.currentSelectorsList.count <= 0) {
        [self hideRightButton];
        if (self.isEditing) {
            [_tableView setEditing:NO  animated:YES];
        }
    }
    else {
        if (self.isEditing) {
            [_tableView setEditing:YES animated: YES];
            [self navBarWithTitle:[NSLocalizedString([SceneManager sharedInstance].currentAction.name, nil) uppercaseString] andRightButtonText:@"Done" withSelector:@selector(toggleEditState:)];
        }
        else {
            [_tableView setEditing:NO animated: YES];
            [self navBarWithTitle:[NSLocalizedString([SceneManager sharedInstance].currentAction.name, nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(toggleEditState:)];
        }
    }
}
- (void)toggleEditState:(id)sender {
    if (self.isEditing || (!self.isEditing && self.currentSelectorsList.count > 0)) {
        self.isEditing = !self.isEditing;
        [self checkEditState];
    }
}

- (IBAction)onClickLeftTab:(id)sender {
    [self switchTab:YES];
}

- (IBAction)onClickRightTab:(id)sender {
    [self switchTab:NO];
}

- (IBAction)onClickAdd:(id)sender {
    NSArray <DeviceSelectModel *> *list = [DeviceSelectModel convertDevices:[SceneManager sharedInstance].currentAction.devicesFromSelectors withSelectedDevices:nil];
    NSArray <SceneActionSelector *> *selectors = self.currentSelectorsList;
    NSMutableDictionary *listDict = [NSMutableDictionary dictionary];
    NSMutableArray *sortedList = [NSMutableArray array];
    
    for (DeviceSelectModel *model in list) {
        NSString *key = [[[model deviceModel] name] stringByAppendingString:[[model deviceModel] address]];
        [listDict setObject:model forKey:key];
    }
    
    NSArray *keys = [[listDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *key in keys) {
        DeviceSelectModel *model = [listDict objectForKey:key];
        [sortedList addObject:model];
    }
    
    for (DeviceSelectModel *model in sortedList) {
        for (SceneActionSelector *item in selectors) {
            if ([model.deviceModel.address isEqualToString:item.selectorId]) {
                model.selected = YES;
                break;
            }
        }
    }
    
    self.deviceView = [[PopupSelectionDeviceView create:NSLocalizedString(@"Choose Devices", nil) deviceSelectModels:sortedList] setMultipleSelect:YES];
    [self popup:_deviceView complete:@selector(completeChooseDevice:)];
}

- (void)completeChooseDevice:(NSArray<DeviceModel *>*)devices {
  SceneModel *currentScene = [SceneManager sharedInstance].currentScene;
  if (currentScene) {
    NSMutableArray<NSString *> *addressList = [NSMutableArray new];
    for (DeviceModel *item in devices) {
      [addressList addObject:item.address];
    }

    // Figure out which selectors have just been unchecked
    NSMutableArray <NSString *>*unselectedAddressList = [NSMutableArray new];
    NSArray *oldList = _inFirstList ? _firstGroupList : _secondGroupList;
    for (SceneActionSelector *selector in oldList) {
      if (![addressList containsObject:selector.selectorId]) {
        [unselectedAddressList addObject:selector.selectorId];
      }
    }

    NSMutableArray *selectorDefaults = [[NSMutableArray alloc] init];

    for (DeviceModel *device in devices) {
      SceneActionSelectorDefault *selectorDefault = [[SceneActionSelectorDefault alloc] init];
      selectorDefault.address = [device address];

      if ([SceneManager sharedInstance].currentAction.type == SceneActionTypeThermostat) {

        selectorDefault.initialParam = @"scheduleEnabled";
        selectorDefault.initialValue = [NSNumber numberWithBool:YES];

        if ( [self isAddress:device.address inOldList:oldList]) {
          continue;
        } else if (device.deviceType == DeviceTypeThermostatNest || device.deviceType == DeviceTypeThermostatHoneywellC2C) {
          NSString *mode = [ThermostatCapability getHvacmodeFromModel:device];
          NSInteger heat = [DeviceController getThermostatHeatSetPointForModel:device];
          NSInteger cool = [DeviceController getThermostatCoolSetPointForModel:device];

          if ([mode isEqualToString:kEnumThermostatHvacmodeHEAT]) {
            selectorDefault.attributes =  @{
                                            @"scheduleEnabled" : @(false),
                                            @"mode" : mode,
                                            @"heatSetPoint": @([DeviceController fahrenheitToCelsius:heat])
                                            };
          } else if ([mode isEqualToString:kEnumThermostatHvacmodeCOOL]){
            selectorDefault.attributes =  @{
                                            @"scheduleEnabled" : @(false),
                                            @"mode" : mode,
                                            @"coolSetPoint" : @([DeviceController fahrenheitToCelsius:cool])
                                            };
          } else if ([mode isEqualToString:kEnumThermostatHvacmodeAUTO]) {
            selectorDefault.attributes =  @{
                                            @"scheduleEnabled" : @(false),
                                            @"mode" : mode,
                                            @"coolSetPoint" : @([DeviceController fahrenheitToCelsius:cool]),
                                            @"heatSetPoint": @([DeviceController fahrenheitToCelsius:heat])
                                            };
          } else if ([mode isEqualToString:kEnumThermostatHvacmodeECO]) {
            selectorDefault.attributes =  @{
                                            @"scheduleEnabled" : @(false),
                                            @"mode" : mode
                                            };
          } else if ([mode isEqualToString:kEnumThermostatHvacmodeOFF]) {
            selectorDefault.attributes =  @{
                                            @"scheduleEnabled" : @(false),
                                            @"mode" : mode
                                            };
          }
        }
      }
      else if (([SceneManager sharedInstance].currentAction.type == SceneActionTypeLight ||
                [SceneManager sharedInstance].currentAction.type == SceneActionTypeVent) &&
               _inFirstList) {

        // Dimmers and vents need a default open/brighness value...
        if ([device isDimmer] || [device isVent]) {
          // We need to make sure that for dimmers and vents for open/on, the value is set to 100%
          selectorDefault.initialParam = nil;
          selectorDefault.initialValue = [NSNumber numberWithInt:100];
        }

        // ... but switch devices will choke on this value.
        else {
          selectorDefault.initialParam = nil;
          selectorDefault.initialValue = nil;
        }
      }
      else if ([SceneManager sharedInstance].currentAction.type == SceneActionTypeFan) {
        // TODO: replace "3" with the value for "HIGH"
        selectorDefault.initialParam = nil;
        selectorDefault.initialValue = [NSNumber numberWithInt:3];
      }
      else if ([SceneManager sharedInstance].currentAction.type == SceneActionTypeCamera) {
        // Avoid default value overriding the current value
        if ([self isAddress:device.address inOldList:oldList]) {
          continue;
        }
        
        selectorDefault.initialParam = nil;
        selectorDefault.initialValue = [NSNumber numberWithInt:60];
      }
      else if ([SceneManager sharedInstance].currentAction.type == SceneActionTypeSpaceHeater) {
        selectorDefault.initialParam = @"setpoint";
        selectorDefault.initialValue = [NSNumber numberWithDouble:24];      // ~75 degrees F
      }
      else {
        selectorDefault.initialParam = nil;
        selectorDefault.initialValue = nil;
      }

      [selectorDefaults addObject:selectorDefault];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [currentScene saveSelectorList:selectorDefaults unselectedSelectors:unselectedAddressList withIndex:_inFirstList ? 0 : 1].thenInBackground(^ {
        [[SceneManager sharedInstance].currentScene refresh].then(^ {
          [self reloadData];
          [self.tableView reloadData];
        });
      });
    });
  }
}

- (BOOL)isAddress: (NSString *)address inOldList: (NSArray *)oldList {
  for (SceneActionSelector *selector in oldList) {
    if ([selector.selectorId isEqualToString:address]) {
      return true;
    }
  }

  return false;
}

#pragma mark - helping methods
- (void)reloadData {
    // Build All the groups
    NSArray *firstGroup;
    NSArray *secondGroup;

    _tabLabels = [[SceneManager sharedInstance].currentAction buildGroupLabelsAndSelectors:[SceneManager sharedInstance].currentScene firstGroup:&firstGroup secondGroup:&secondGroup];

    if([firstGroup count] > 0) {
        NSMutableArray *sortedFirstGroup = [NSMutableArray array];
        NSMutableDictionary *selectorDict = [NSMutableDictionary dictionary];
        
        for (SceneActionSelector *selector in firstGroup) {
            NSString *key = [[selector deviceName] stringByAppendingString:[selector selectorId]];
            [selectorDict setObject:selector forKey:key];
        }
        
        NSArray *keys = [[selectorDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *key in keys) {
            SceneActionSelector *selector = [selectorDict objectForKey:key];
            [sortedFirstGroup addObject:selector];
        }
        
        firstGroup = [sortedFirstGroup copy];
    }
    
    if([secondGroup count] > 0) {
        NSMutableArray *sortedSecondGroup = [NSMutableArray array];
        NSMutableDictionary *selectorDict = [NSMutableDictionary dictionary];
        
        for (SceneActionSelector *selector in secondGroup) {
            NSString *key = [[selector deviceName] stringByAppendingString:[selector selectorId]];
            [selectorDict setObject:selector forKey:key];
        }
        
        NSArray *keys = [[selectorDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *key in keys) {
            SceneActionSelector *selector = [selectorDict objectForKey:key];
            [sortedSecondGroup addObject:selector];
        }
        
        secondGroup = [sortedSecondGroup copy];
    }
    
    self.firstGroupList = firstGroup;
    self.secondGroupList = secondGroup;
    
    [self checkEditState];
    [self showOrHideTableViewHeaderSeparator];
}

- (void)switchTab:(BOOL)toFirst {
    _inFirstList = toFirst;
    
    if ([self hasTabs]) {
        [self setTab:_inFirstList];
        self.headerTabView.hidden = NO;
        self.heightConstraint.constant = 44;
    }
    else {
        self.headerTabView.hidden = YES;
        self.heightConstraint.constant = 0;
    }
    
    [self setHeadText:_inFirstList];
    
    [self.view layoutIfNeeded];
    [self.tableView reloadData];
}

- (void)setTab:(BOOL)toLeft {
    BOOL leftIsBlack = [SceneManager sharedInstance].isNewScene && !toLeft;
    BOOL rightIsBlack = [SceneManager sharedInstance].isNewScene && toLeft;
    
    [self.leftButton styleSet:[self getTabText:YES] andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor: leftIsBlack space:YES] upperCase:YES];
    [self.leftButton setAlpha:toLeft ? 1.0 : 0.6];
    
    [self.rightButton styleSet:[self getTabText:NO] andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor: rightIsBlack space:YES] upperCase:YES];
    [self.rightButton setAlpha:!toLeft ? 1.0 : 0.6];
}

- (void)setHeadText:(BOOL)onLeft {
    NSString *headerText = [self getHeaderText:onLeft];
    
    if (headerText && headerText.length > 0) {
        [self.headerViewLabel styleSet:headerText andFontData:[FontData createFontData:FontTypeDemiBold size:18 blackColor:[SceneManager sharedInstance].isNewScene]];
        [self.tableView setTableHeaderView:self.headerView];
    }
    else {
        [self.headerViewLabel setText:@""];
        [self.tableView setTableHeaderView:[UIView new]];
    }
    
    self.headerSeparator.backgroundColor = [SceneManager sharedInstance].isNewScene ? [FontColors getCreationSeparatorColor] : [FontColors getStandardSeparatorColor];
}

- (void)showOrHideTableViewHeaderSeparator {
    self.headerSeparator.hidden = self.currentSelectorsList.count == 0;
}


- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow];
}

#pragma mark - handle notificaitons
- (void)actionsChanged:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView  reloadData];
    });
}

@end
