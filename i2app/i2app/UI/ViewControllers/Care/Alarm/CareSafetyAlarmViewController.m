//
//  CareSafetyAlarmViewController.m
//  i2app
//
//  Created by Arcus Team on 2/2/16.
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
#import "CareSafetyAlarmViewController.h"
#import "CareAlarmBaseViewControllerCell.h"

#import "SubsystemsController.h"
#import "SafetySubsystemCapability.h"
#import "SafetySubsystemAlertController.h"


#import "SegmentModelsBuilder.h"


#import <i2app-Swift.h>

@interface CareSafetyAlarmViewController ()

@end

@implementation CareSafetyAlarmViewController {
    DeviceTextAttributeControl *_smokeStateControl;
    DeviceTextAttributeControl *_waterStateControl;
    DeviceTextAttributeControl *_coStateControl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:@"Care Safety Alarm"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Tag Service - Safety:
    [ArcusAnalytics tag:AnalyticsTags.CareAlarm attributes:@{}];
    
    _smokeStateControl = [DeviceTextAttributeControl create:@"SMOKE" withValue:@""];
    _coStateControl = [DeviceTextAttributeControl create:@"CO" withValue:@""];
    _waterStateControl = [DeviceTextAttributeControl create:@"WATER LEAK" withValue:@""];

    [self safetyStateChanged:nil];
    
    [self.attributesView loadControl:_smokeStateControl control2:_coStateControl control3:_waterStateControl];
    [self removeButtons];
    
    [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(safetyStateChanged:) name: [Model attributeChangedNotification:kAttrSafetySubsystemAlarm] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberOfDevicesChanged:) name: [Model attributeChangedNotification:kAttrSafetySubsystemTotalDevices] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberOfDevicesChanged:) name: [Model attributeChangedNotification:kAttrSafetySubsystemActiveDevices] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTreeEnabled] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTreeEnabled] object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - StringWithState methods

- (NSString *)smokeSateStringWithState:(NSString *)state {
    int numberOfOfflineSmokeSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineSmokeSensors];
    if (numberOfOfflineSmokeSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineSmokeSensor];
    }
    return [self convertStateToUIState:state];
}

- (NSString *)coSateStringWithState:(NSString *)state {
    int numberOfOfflineCoSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineCOSensors];
    if (numberOfOfflineCoSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineCoSensor];
    }
    return [self convertStateToUIState:state];
}

- (NSString *)waterLeakSateStringWithState:(NSString *)state {
    int numberOfOfflineWaterLeakSensor = [[SubsystemsController sharedInstance].safetyController numberOfOfflineWaterLeakSensor];
    if (numberOfOfflineWaterLeakSensor > 0) {
        return [NSString stringWithFormat:@"%d OFFLINE", numberOfOfflineWaterLeakSensor];
    }
    
    return [self convertStateToUIState:state];
}

#pragma mark - State conversions

- (NSString *)convertStateToUIState:(NSString *)state {
    if ([state isEqualToString:@"NONE"]) {
        return NSLocalizedString(@"NONE", nil);
    }
    else if ([state isEqualToString:@"DETECTED"]) {
        if ([[[SubsystemsController sharedInstance].safetyController alarmState] isEqualToString:@"CLEARING"]) {
            return NSLocalizedString(@"CLEARING", nil);
        }
        return NSLocalizedString(@"DETECTED", nil);
    }
    
    else if ([state isEqualToString:@"SAFE"]) {
        return NSLocalizedString(@"NO", nil);
    }
    return state;
}

#pragma mark - AlarmState checks

- (void)checkAlarmStateForEvent:(NSString *)event withImage:(NSString *)imageName {
    NSString *alarmState = [[SubsystemsController sharedInstance].safetyController alarmState];
    
    if ([alarmState isEqualToString:kEnumSafetySubsystemAlarmALERT]) {
        DeviceModel *device = [self getFirstTriggerDevice];
        
        //TODO last Alert Cause is nil for some reason
        // NSString *reason = [[SubsystemsController sharedInstance].safetyController lastAlertCause];
        
        NSString *reason = [self reason];
        NSDate *date = [[SubsystemsController sharedInstance].safetyController lastAlertTime];
        DeviceTimeAttributeControl *timeControl = [DeviceTimeAttributeControl createWithDate:date withState: reason];
        
        [self.attributesView loadControl:timeControl];
        [self activeAlarmWithName:[device name] event:event icon:nil borderColor:purpleAlertColor];
        [self setIconByDevice:device withImage:imageName];
    }
    else {
        [self deactivateAlarm];
    }
}

#pragma mark - Alarm Utility methods

- (void)deactivateAlarm {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        if ([SubsystemsController sharedInstance].safetyController == nil) {
            return;
        }
        
        [[SubsystemsController sharedInstance].safetyController clear].then(^{
            [super deactivateAlarm];
        });
    });
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CareAlarmBaseViewControllerCell *cell = (CareAlarmBaseViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"logoTextCell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SafetySubsystemAlertController *safetyController = [SubsystemsController sharedInstance].safetyController;
    if (indexPath.row == 0) {
        NSString *subtitle;
        if (safetyController.numberOfOfflineDevices > 0 && safetyController.numberOfOnlineDevices > 0) {
            subtitle = [NSString stringWithFormat:@"%d %@, %d %@", [SubsystemsController sharedInstance].safetyController.numberOfOfflineDevices, NSLocalizedString(@"Offline", nil), [SubsystemsController sharedInstance].safetyController.numberOfOnlineDevices, NSLocalizedString(@"Online", nil)];
        }
        else if (safetyController.numberOfOfflineDevices > 0) {
            subtitle = [NSString stringWithFormat:@"%d %@", [SubsystemsController sharedInstance].safetyController.numberOfOfflineDevices, NSLocalizedString(@"Offline", nil)];
        }
        else if (safetyController.numberOfOnlineDevices > 0) {
            subtitle = [NSString stringWithFormat:@"%d %@", [SubsystemsController sharedInstance].safetyController.numberOfOnlineDevices, NSLocalizedString(@"Devices", nil)];
        }
        [cell setTitle:[NSLocalizedString(@"SAFETY ALARM DEVICES", nil) capitalizedString] subtitle:subtitle];
        
        [cell setLogo:[UIImage imageNamed:@"Alarm"]];
    }
    else if (indexPath.row == 1) {
        [cell setTitle:[NSLocalizedString(@"ALARM HISTORY", nil) capitalizedString] subtitle:@""];
        [cell setLogo:[UIImage imageNamed:@"alartHisotry"]];
    }
    else if (indexPath.row == 2) {
        [self setupCellForNotificationList:&cell];
    }
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[AlarmDeviceListViewController create:AlarmDeviceTypeSafety] animated:YES];
    }
    else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[AlarmHistoryViewController create:AlarmTypeSafety] animated:YES];
    }
    else if (indexPath.row == 2) {
        [self.navigationController pushViewController:[AlarmNotificationViewController create:AlarmTypeSafety] animated:YES];
    }
}
*/
#pragma mark - Notifications

- (void)safetyStateChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        SafetySubsystemAlertController *safetyController = [SubsystemsController sharedInstance].safetyController;
        
        NSString *state = [safetyController smokeState];
        [self.attributesView loadControl:_smokeStateControl control2:_coStateControl control3:_waterStateControl];
        [_smokeStateControl setValueText:[self smokeSateStringWithState:state]];
        
        state = [safetyController coState];
        [_coStateControl  setValueText:[self coSateStringWithState:state]];
        
        state = [safetyController waterState];
        [_waterStateControl  setValueText:[self waterLeakSateStringWithState:state]];
        
        [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
        
        [self checkAlarmStateForEvent:@"ALARM" withImage:@"icon_unfilled_safetyAndPanicAlarm"];
    } );
}

- (void)numberOfDevicesChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [super setRingTextWithTitle:@"Devices"];
        [self loadRingSigmentsWithModel:[SegmentModelsBuilder ringSegMentsSafetyDevices]];
    } );
}

- (void)notificationListChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    });
}

- (void)setupCellForNotificationList:(CareAlarmBaseViewControllerCell **)cell {
    BOOL isCallTreeEnabled = [[SubsystemsController sharedInstance].safetyController isCallTreeEnabled];
    NSMutableArray *personImages = [NSMutableArray array];
    
    if (isCallTreeEnabled &&
        [SubsystemsController sharedInstance].safetyController.callTree.count > 0) {
        
        for (NSDictionary *personDict in [SubsystemsController sharedInstance].safetyController.callTree) {
            if (((NSNumber *)[personDict objectForKey:@"enabled"]).boolValue == NO ) {
                continue;
            }
            
            NSString *personAdress = [personDict objectForKey:@"person" ];
            UIImage *image = [(PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:personAdress] image];
            
            if (image == nil) {
                image = [UIImage imageNamed:@"userIcon"];
            }
            
            [personImages addObject:image];
        }
    }
    if (personImages.count > 0) {
        [*cell setLogos:personImages];
    }
    else {
        PersonModel *person = [[[CorneaHolder shared] settings] currentPerson];
        UIImage *image = [person image];
        if (image == nil) {
            image = [UIImage imageNamed:@"userIcon"];
        }
        
        [*cell setTitle:[NSLocalizedString(@"ALARM NOTIFICATION LIST", nil) capitalizedString] subtitle:NSLocalizedString(@"Learn How to Alert Others", nil)];
        [*cell setLogo:image];
    }
}

#pragma mark - Triggered device methods

- (DeviceModel *)getFirstTriggerDevice {
    NSArray *triggerDeviceIds = [[SubsystemsController sharedInstance].safetyController triggerDeviceIds];
    
    if (triggerDeviceIds.count > 0) {
        NSDictionary *deviceDict = [triggerDeviceIds objectAtIndex:0];
        NSString *deviceAddress = [deviceDict objectForKey:@"device"];
        return (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];
    }
    
    return nil;
}

- (NSString *)reason {
    NSArray *triggerDeviceIds = [[SubsystemsController sharedInstance].safetyController triggerDeviceIds];
    
    if (triggerDeviceIds.count > 0) {
        NSDictionary *deviceDict = [triggerDeviceIds objectAtIndex:0];
        return  [NSString stringWithFormat:@"%@ DETECTED",[deviceDict objectForKey:@"type"]];
    }
    
    return @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
