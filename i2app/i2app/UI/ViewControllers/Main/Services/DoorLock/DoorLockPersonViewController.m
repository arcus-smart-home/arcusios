//
//  DoorLockPersonViewController.m
//  i2app
//
//  Created by Arcus Team on 9/14/15.
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
#import "DoorLockPersonViewController.h"
#import "PersonCallTreeViewController.h"

#import "DoorLockCapability.h"
#import "DoorsNLocksSubsystemController.h"


#import "DoorsNLocksSubsystemCapability.h"

@interface DoorLockPersonViewController () <PersonCallTreeDataDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic) PersonCallTreeViewController *personController;
#pragma clang diagnostic pop

@property (strong, nonatomic) DeviceModel *deviceModel;

@end

@implementation DoorLockPersonViewController {
    BOOL _lockIsPending;
}

+ (DoorLockPersonViewController *)createWithDeviceModel:(DeviceModel *)deviceModel {
    DoorLockPersonViewController *controller = [[DoorLockPersonViewController alloc] init];
    controller.deviceModel = deviceModel;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _personController = [PersonCallTreeViewController createWithTitle:_deviceModel.name toOwner:self maxNumberOfEnabledPeople:[DoorLockCapability getNumPinsSupportedFromModel:_deviceModel]];
#pragma clang diagnostic pop
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorzationUpdate:) name:[Model attributeChangedNotification:kAttrDoorsNLocksSubsystemAuthorizationByLock] object:nil];
}

- (void)authorzationUpdate:(NSNotification *)notification {
    if (notification.object && [notification.object isKindOfClass:[NSDictionary class]] && [(NSDictionary*)notification.object objectForKey:kAttrDoorsNLocksSubsystemAuthorizationByLock]) {
        
        NSDictionary *deviceStatus = [(NSDictionary*)notification.object objectForKey:kAttrDoorsNLocksSubsystemAuthorizationByLock];
        if ([deviceStatus objectForKey:_deviceModel.address]) {
            
            BOOL _tempPendingStatus = NO;
            
            for (NSDictionary *item in [deviceStatus objectForKey:_deviceModel.address]) {
                if ([[item objectForKey:@"state"] isEqualToString:@"PENDING"]) {
                    _tempPendingStatus = YES;
                }
            }
            
            _lockIsPending = _tempPendingStatus;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_lockIsPending) {
                    [self hideGif];
                }
                [_personController reloadData:NO];
            });
        }
    }
}

#pragma mark - Person call tree delegate
- (BOOL)getEnableCallTree {
    return YES;
}

- (NSString *)getEnabledTitleText {
    return NSLocalizedString(@"The People listed below have access to this door via their PIN Code.", nil);
}

- (NSString *)getEnabledSubtitleText {
    return NSLocalizedString(@"Add people by tapping the + sign on the dashboard, then tap People.", nil);
}

- (NSString *)getDisabledTitleText {
    return NSLocalizedString(@"Disabled", nil);
}

- (NSString *)getDisabledSubtitleText {
    return @"-";
}

- (NSString *)getFootText {
    return NSLocalizedString(@"Don't see the person you're looking for?\nGo to Settings > Places & People and\ngive a PIN code to the person you want\nto have access, then return to this page.", nil);
}

- (void) saveCallTree:(NSArray *)callTree {
    [self popupMessageWindow:@"ACCESS UPDATES PENDING" subtitle:@"lock is pending to edit mode"];
    
    NSMutableArray *persons = [NSMutableArray array];
    NSMutableArray *orderList = [NSMutableArray array];

    for (PersonCallTreeModel *personData in callTree) {
        NSString *state = personData.checked ? @"AUTHORIZE":@"DEAUTHORIZE";
        [persons addObject:@{@"person": ((PersonModel*)personData.attachedObj).address, @"operation":state}];
        [orderList addObject:((PersonModel*)personData.attachedObj).address];
    }
    
    _lockIsPending = YES;
    
    [[SubsystemsController sharedInstance].doorsNLocksController saveAuthorization:persons device:self.deviceModel complete:^{
        [self saveOrder:orderList];
        [_personController reloadData:NO];
    }];
}

- (void)saveOrder:(NSArray*)orderCallTree {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:orderCallTree];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:@"doorNLockAccressOrderedArray"];
    [userDefaults synchronize];
}
- (NSArray *)getSavedOrder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:@"doorNLockAccressOrderedArray"];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return [NSArray new];
}

- (NSArray *)callTreeData {
    // TODO: Get call tree data
    NSMutableArray *personData = [[NSMutableArray alloc] init];

    NSDictionary *authorizedPersonsByLock = [[SubsystemsController sharedInstance].doorsNLocksController authorizationByLockPersons];
    NSArray *personAddresses = [authorizedPersonsByLock objectForKey:self.deviceModel.address];
    
    _lockIsPending = NO;
    
    for (NSDictionary *personDict in personAddresses) {
        PersonModel *personModel = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:[personDict objectForKey:@"person"]];

        // Error Catch for ITWO-6433
        // An address should have a model
        if (personModel == nil) {
            continue;
        }
        
        UIImage *cachedImage = [personModel image];
        UIImage *image = cachedImage != nil? cachedImage : [UIImage imageNamed:@"userIcon"];
        
        if ([[personDict objectForKey:@"state"] isEqualToString:@"AUTHORIZED"]) {
            [personData addObject:[PersonCallTreeModel createWith:personModel.fullName checked:YES withImage:image andAttachedObj:personModel]];
        }
        else {
            if ([[personDict objectForKey:@"state"] isEqualToString:@"PENDING"]) {
                _lockIsPending = YES;
            }
            [personData addObject:[PersonCallTreeModel createWith:personModel.fullName checked:NO withImage:image andAttachedObj:personModel]];
        }
    }
    
    NSArray *savedOrder = [self getSavedOrder];
    NSMutableArray *orderedPersonData = [[NSMutableArray alloc] init];
    
    for (NSString *item in savedOrder) {
        for (PersonCallTreeModel* callTreeModel in personData) {
            if ([((PersonModel*)callTreeModel.attachedObj).address isEqualToString:item]) {
                [orderedPersonData addObject:callTreeModel];
                [personData removeObject:callTreeModel];
                break;
            }
        }
    }
    
    [orderedPersonData addObjectsFromArray:personData];
    
    return orderedPersonData;
}

- (BOOL)verifyEditAvaliable {
    if (_lockIsPending) {
        [self popupMessageWindow:@"ACCESS UPDATES PENDING" subtitle:@"lock is pending to edit mode"];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)verifyDoneAvaliable {
    if (_lockIsPending) {
        [self popupMessageWindow:@"ACCESS UPDATES PENDING" subtitle:@"lock is pending to done mode"];
        return NO;
    }
    else {
        return YES;
    }
}

@end
