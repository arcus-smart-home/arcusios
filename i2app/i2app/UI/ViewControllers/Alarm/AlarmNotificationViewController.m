//
//  AlarmNotificationViewController.m
//  i2app
//
//  Created by Arcus Team on 8/25/15.
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
#import "AlarmNotificationViewController.h"
#import "AKFileManager.h"


#import "PersonCallTreeViewController.h"



#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"
#import "SecuritySubsystemAlertController.h"
#import "SecuritySubsystemCapability.h"
#import "SecurityAlarmModeCapability.h"
#import "SafetySubsystemCapability.h"
#import "PlaceCapability.h"

@interface AlarmNotificationViewController () <PersonCallTreeDataDelegate>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (strong, nonatomic) PersonCallTreeViewController *personController;
#pragma clang diagnostic pop
@property (assign, nonatomic) AlarmType type;

@end

@implementation AlarmNotificationViewController

+ (AlarmNotificationViewController *)create:(AlarmType)type withStoryboard:(NSString *)storyboard {
    AlarmNotificationViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.type = type;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Alarm notification list", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _personController = [PersonCallTreeViewController createWithTitle:self.title toOwner:self maxNumberOfEnabledPeople:INT_MAX];
#pragma clang diagnostic pop
    
    [self registerNotifications];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)registerNotifications {
    if (self.type == AlarmTypeSafety) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTree] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSafetySubsystemCallTreeEnabled] object:nil];
        
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemCallTree] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationListChanged:) name:[Model attributeChangedNotification:kAttrSecuritySubsystemCallTreeEnabled] object:nil];
    }
}

- (void)notificationListChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.personController loadNav];
        [self.personController reloadData:YES];
    });
}


#pragma mark - Person call tree delegate
- (BOOL)getEnableCallTree {
    BOOL isEnabled = NO;
    
    if (self.type == AlarmTypeSafety) {
        isEnabled = [[SubsystemsController sharedInstance].safetyController isCallTreeEnabled];
    }
    else {
        isEnabled = [[SubsystemsController sharedInstance].securityController isCallTreeEnabled];
    }
    
    return isEnabled;
}

- (NSString *)getEnabledTitleText {
    if (self.type == AlarmTypeSafety) {
        return NSLocalizedString(@"A triggered Safety Alarm will simultaneously notify the people below.", nil);
    }
    else {
        return NSLocalizedString(@"A triggered Security Alarm will notify the people below.", nil);
    }
}

- (NSString *)getEnabledSubtitleText {
    return NSLocalizedString(@"Please verbally inform all parties to add 1-0 to their phone's contact list so they know Arcus is calling.", nil);
}

- (NSString *)getDisabledTitleText {
    return NSLocalizedString(@"Please add 1-0 to your phone's contact list", nil);
}

- (NSString *)getDisabledSubtitleText {
    return NSLocalizedString(@"", nil);
}

- (NSString *)getFootText {
    return NSLocalizedString(@"Don't see the person you're looking for? Go to Settings > People and add a phone number or an email address for the person you want to notify, then return to this page.", nil);
}

- (void)saveCallTree:(NSArray *)callTree {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *saveArray = [[NSMutableArray alloc] initWithCapacity:callTree.count];
        NSMutableArray *orderList = [NSMutableArray array];
        
        for (PersonCallTreeModel *model in callTree) {
            NSString *personAddress = [model.attachedObj objectForKey:@"person" ];
            
            NSDictionary *newPerson = @{@"person":personAddress, @"enabled":@([model checked])};
            [saveArray addObject:newPerson];
            
            [orderList addObject:personAddress];
        }
        
        if (self.type == AlarmTypeSafety) {
            [[SubsystemsController sharedInstance].safetyController saveNewCallTree:saveArray];
        }
        
        else {
            [[SubsystemsController sharedInstance].securityController saveNewCallTree:saveArray];
        }
        
        [self saveOrder:orderList forKey:[self orderListKey]];
    });
}

- (NSArray *)callTreeData {
    NSMutableArray *personData = [[NSMutableArray alloc] init];
    
    if (![self getEnableCallTree]) {
        NSString *ownerAddress =  [[[[CorneaHolder shared] settings] currentPerson] address];
        PersonModel *person = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:ownerAddress];
        
        UIImage *image = [self getImageForPerson:person];
        [personData addObject:[PersonCallTreeModel createWith:person.fullName checked:YES withImage:image]];
    }
    else {
        NSArray *callTreeArray;
        if (self.type == AlarmTypeSafety) {
            callTreeArray = [[SubsystemsController sharedInstance].safetyController callTree];
        }
        else {
            callTreeArray = [[SubsystemsController sharedInstance].securityController callTree];
        }
        
        for (NSDictionary *item in callTreeArray) {
            PersonModel *person = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:[item objectForKey:@"person"]];
            UIImage *cachedImage = [person image];
            UIImage *image = cachedImage != nil? cachedImage : [UIImage imageNamed:@"userIcon"];
            BOOL isNeedToDisplay = ((NSNumber *)[item objectForKey:@"enabled"]).boolValue;
            [personData addObject:[PersonCallTreeModel createWith:person.fullName checked:isNeedToDisplay withImage:image andAttachedObj:item]];
        }
    }

    return personData;
}

- (NSArray *)sortCallTreeData:(NSArray *)callTreeData {
    NSMutableArray *mutableData = [callTreeData mutableCopy];

    NSArray *savedOrder = [self getSavedOrder];
    NSMutableArray *orderedPersonData = [[NSMutableArray alloc] init];

    for (NSString *item in savedOrder) {
        for (PersonCallTreeModel *callTreeModel in mutableData) {
            NSString *personAddress = [callTreeModel.attachedObj objectForKey:@"person"];

            if ([personAddress isEqualToString:item]) {
                [orderedPersonData addObject:callTreeModel];
                [mutableData removeObject:callTreeModel];
                break;
            }
        }
    }

    [orderedPersonData addObjectsFromArray:mutableData];

    return orderedPersonData;
}

- (void)saveOrder:(NSArray *)orderedCallTreeData {

    NSMutableArray *orderList = [NSMutableArray array];

    for (PersonCallTreeModel *model in orderedCallTreeData) {
        NSString *personAddress = [model.attachedObj objectForKey:@"person"];

        if (personAddress.length > 0) {
            [orderList addObject:personAddress];
        }
    }

    [self saveOrder:orderList forKey:[self orderListKey]];
}

- (UIImage *)getImageForPerson:(PersonModel *)personModel {
    UIImage *cachedImage = [personModel image];
    UIImage *image = cachedImage != nil? cachedImage : [UIImage imageNamed:@"userIcon"];
    
    return image;
}

#pragma mark - save order of tree

- (void)saveOrder:(NSArray*)orderCallTree forKey:(NSString *)orderKey {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:orderCallTree];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:[self orderListKey]];
    [userDefaults synchronize];
}


- (NSArray *)getSavedOrder {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:[self orderListKey]];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    return [NSArray new];
}

- (NSString *)orderListKey {
    if (self.type == AlarmTypeSafety) {
        return @"SafetyAccessOrderedArray";
    }
    
    return @"SecurityAccessOrderedArray";
}

@end



