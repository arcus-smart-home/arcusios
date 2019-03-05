//
//  AlarmingViewController.m
//  i2app
//
//  Created by Arcus Team on 1/29/16.
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
#import "AlarmingViewController.h"
#import "ArcusAlarmHistoryListCell.h"
#import "UIImage+ImageEffects.h"
#import "AlarmBaseViewController.h"
#import "OrderedDictionary.h"
#import <PureLayout/PureLayout.h>
#import "NSDate+Convert.h"
#import "UIImage+ImageEffects.h"
#import "SubsystemCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"

#import "AKFileManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "ImagePaths.h"

#import "AKFileManager.h"
#import "SDWebImageManager.h"
#import "ImagePaths.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "ArcusLabel.h"
#import "SecuritySubsystemCapability.h"
#import "PlaceCapability.h"
#import "HaloCapability.h"

@interface AlarmingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *cancelBarAreaView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *AlarmView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmDeviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceEvent;

@property (strong, nonatomic) UILabel *mainRingLabel;
@property (strong, nonatomic) UILabel *titleRingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallwaveLeftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *smallwaveRightIcon;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *event;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIColor *color;

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (strong, nonatomic) AlarmBaseViewController *owner;
@property (assign, nonatomic) AlarmType type;

@property (weak, nonatomic) IBOutlet ArcusLabel *placeNameLabel;
@property (weak, nonatomic) IBOutlet ArcusLabel *placeAddressLabel;

@end

@implementation AlarmingViewController {
    NSArray             *_triggersArray;
    OrderedDictionary   *_orderedTriggers;
    
    __block NSString    *_nextLogEntryToken;
    __block NSDate      *_lastDateLoaded;
}

+ (AlarmingViewController *)createWithOwner:(AlarmBaseViewController *)owner alarmType:(AlarmType)type name:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color  {
    AlarmingViewController *vc = [[UIStoryboard storyboardWithName:@"AlarmStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.name = name;
    vc.event = event;
    vc.icon = icon;
    vc.color = color;
    vc.owner = owner;
    vc.type = type;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _triggersArray = [[NSMutableArray alloc] init];
    _orderedTriggers = [[OrderedDictionary alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    [self loadData];
    [self loadDevices];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(triggeredDeviceUpdate)
                                                 name:[Model attributeChangedNotification:kAttrSecuritySubsystemTriggeredDevices]
                                               object:nil];
    
    self.placeNameLabel.text = [[CorneaHolder shared] settings].currentPlace.name;
    self.placeAddressLabel.text = [PlaceCapability getStreetAddress1FromModel:[[CorneaHolder shared] settings].currentPlace];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadData {
    _AlarmView.layer.cornerRadius = _AlarmView.frame.size.width / 2.0f;
    _AlarmView.layer.borderColor = _color.CGColor;
    _AlarmView.layer.borderWidth = 20.0f;
    _AlarmView.layer.shadowColor = _color.CGColor;
    _AlarmView.layer.masksToBounds = NO;
    _AlarmView.layer.shadowOffset = CGSizeMake(0, 0);
    _AlarmView.layer.shadowRadius = 15.0f;
    _AlarmView.layer.shadowOpacity = 1.0f;
    
    [_cancelLabel styleSet:@"Cancel" andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO]];
    
    [self.smallwaveLeftIcon setImage:[self.smallwaveLeftIcon.image invertColor]];
    [self.smallwaveRightIcon setImage:[self.smallwaveRightIcon.image invertColor]];
    
    if ([_event isEqualToString:@"panic"]) {
        [self.alarmDeviceName styleSet:_event
                           andFontData:[FontData createFontData:FontTypeDemiBold
                                                           size:12
                                                     blackColor:YES
                                                          space:YES]
                             upperCase:YES];
        [self.alarmDeviceEvent styleSet:@"alarm"
                            andFontData:[FontData createFontData:FontTypeDemiBold
                                                            size:11
                                                      blackColor:YES
                                                           space:YES]
                              upperCase:YES];
    } else {
        [self.alarmDeviceName styleSet:_name
                           andFontData:[FontData createFontData:FontTypeDemiBold
                                                           size:12
                                                     blackColor:YES
                                                          space:YES]
                             upperCase:YES];
        [self.alarmDeviceEvent styleSet:_event
                            andFontData:[FontData createFontData:FontTypeDemiBold
                                                            size:11
                                                      blackColor:YES
                                                           space:YES]
                              upperCase:YES];

    }

    [self.alarmDeviceName setNumberOfLines:2];
    self.alarmDeviceName.minimumScaleFactor = 0;
    self.alarmDeviceName.adjustsFontSizeToFitWidth = YES;

    if (_icon) {
        self.alarmDeviceIcon.image = _icon;
    }
    self.cancelBarAreaView.backgroundColor = [_color colorWithAlphaComponent:0.6];
}

- (void)loadDevices {
    switch (self.type) {
        case AlarmTypeSafety: {
            _triggersArray = [[[SubsystemsController sharedInstance] safetyController] triggerDevices];
            if ([_triggersArray count] == 0) {
                _triggersArray = [[[SubsystemsController sharedInstance] safetyController] getPendingClear];
            }
            break;
        }
        case AlarmTypeSecurity: {
            _orderedTriggers = [[[SubsystemsController sharedInstance] securityController] getLastAlertTriggerWithDate];
            [_orderedTriggers reverseObjects];
            break;
        }
        default:
            _orderedTriggers = [[OrderedDictionary alloc] init];
            break;
    }
    
    [self.tableView reloadData];
}

- (void)triggeredDeviceUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDevices];
    });
}

- (void)setDeviceIcon:(UIImage *)icon {
    self.alarmDeviceIcon.image = icon;
}

- (IBAction)onClickCancel:(id)sender {
    [self.owner deactivateAlarm];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.type == AlarmTypeSecurity) ? [_orderedTriggers count] : [_triggersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"cell";

    ArcusAlarmHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[ArcusAlarmHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIndentifier];
    }
    
    DeviceModel *model = nil;
    
    if (self.type == AlarmTypeSecurity) {
        NSDate *time = [_orderedTriggers keyAtIndex:indexPath.row];
        model = [_orderedTriggers objectForKey:time];
        NSString *timeStr = [time lastChangedTime];
        
        if ([model isKindOfClass:[DeviceModel class]]) {
            [cell setTime:timeStr
                     name:[model name]
                    event:[model deviceTypeName]
               eventModel:model];
        } else if ([model isKindOfClass:[NSString class]]) {
            // Show panic alert by "Security Device"
            [cell setTime:timeStr
                     name:(NSString *)model
                    event:@"Panic"
               eventModel:model];
        }
        else {
            [cell setTime:timeStr
                     name:[model name]
                    event:[model name]
               eventModel:model];
        }
    } else {
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:[_triggersArray[indexPath.row][@"time"] doubleValue] / 1000];
        model = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:_triggersArray[indexPath.row][@"device"]];
        NSString *timeStr = [time lastChangedTime];
        if ([model isKindOfClass:[DeviceModel class]]) {
            NSString *reason = [[SubsystemsController sharedInstance].safetyController reasonForTriggeredDeviceWithId:model.modelId];
            if (reason.length > 0) {
                if ([reason isEqualToString:kEnumHaloDevicestateCO]) {
                    reason = @"CO Detected";
                }
                else if ([reason isEqualToString:kEnumHaloDevicestateSMOKE]) {
                    reason = @"Smoke Detected";
                }
                else {
                    reason = [NSString stringWithFormat:@"%@ Detected", reason];
                }
            }

            [cell setTime:timeStr
                     name:[model name]
                    event:reason
               eventModel:model];
        } else {
            [cell setTime:timeStr
                     name:[model name]
                    event:[model name]
               eventModel:model];
        }
    }
    
    if ([model isKindOfClass:[Model class]]) {
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            cell.iconImage.borderedModeEnabled = YES;
            cell.iconImage.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
            cell.iconImage.borderWidth = 1.0f;
            cell.iconImage.image = image;
        } else {
            cell.iconImage.borderedModeEnabled = NO;
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:model] withDevTypeId:[model devTypeHintToImageName] withPlaceHolder:nil
                                         isLarge:NO
                                    isBlackStyle:YES].then(^(UIImage *image) {
                if (image) {
                    cell.iconImage.image = image;
                }
            });
            cell.iconImage.tintColor = [UIColor blackColor];
        }
    }
    else {
        cell.iconImage.image = [[UIImage imageNamed:@"icon_unfilled_safetyAndPanicAlarm"] invertColor];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
