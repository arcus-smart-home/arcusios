//
//  AlarmHistoryViewController.m
//  i2app
//
//  Created by Arcus Team on 8/26/15.
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
#import "AlarmHistoryViewController.h"
#import "AlarmHistoryCell.h"
#import "OrderedDictionary.h"
#import <PureLayout/PureLayout.h>
#import "NSDate+Convert.h"
#import "SubsystemCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"

#import "AKFileManager.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "ImagePaths.h"



const int kAlarmhistoryPageSize = 40;

@interface AlarmHistoryViewController ()

@end

@implementation AlarmHistoryViewController {
    OrderedDictionary   *_historyList;
    __block NSString    *_nextLogEntryToken;
    __block NSDate      *_lastDateLoaded;
}

+ (AlarmHistoryViewController *)create:(AlarmType)type
                        withStoryboard:(NSString *)storyboard {
    AlarmHistoryViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.alarmType = type;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _historyList = [[OrderedDictionary alloc] init];
}

#pragma mark - filter history
- (void)addWithResults:(NSArray *)results {
    NSDate *serviceLevelCutOff  = nil;
    
    if (![CorneaHolder.shared.settings isPremiumAccount]) {
        serviceLevelCutOff = [NSDate dateWithTimeIntervalSinceNow:-(60 * 60 * 24)];
        serviceLevelCutOff = [serviceLevelCutOff toPlaceTime];
    }
    
    
    for (NSDictionary *result in results) {
        
        Model *model = [[Model alloc] initWithAttributes:result];
        
        NSDictionary *dic = [self convertHistoryModel:model];
        NSDate *eventTime = dic[@"eventTime"];
        if (serviceLevelCutOff && [eventTime compare:serviceLevelCutOff] == NSOrderedAscending) {
            continue;
        }
        
        NSMutableArray *group = [_historyList valueForKey:[eventTime formatDateByDay]];
        
        if (group == nil) {
            group = [NSMutableArray array];
        }
        _lastDateLoaded = eventTime;
        [group addObject:dic];
        
        [_historyList setObject:group forKey:[eventTime formatDateByDay]];
    }
}

- (NSDictionary *)convertHistoryModel:(Model *)model {
    NSMutableDictionary *covertedModel = [[NSMutableDictionary alloc] init];
    
    NSNumber *timeStamp = (NSNumber *)[model getAttribute:@"timestamp"];
    NSDate *eventTime = [NSDate dateWithTimeIntervalSince1970:(timeStamp.doubleValue / 1000)];
    
    [covertedModel setObject:eventTime forKey:@"eventTime"];
    [covertedModel setObject:[eventTime formatDateTimeStamp] forKey:@"time"];
    [covertedModel setObject:[model getAttribute:@"longMessage"] forKey:@"name"];
    [covertedModel setObject:[model getAttribute:@"subjectName"] forKey:@"subtitle"];
    
    Model *eventModel = [[[CorneaHolder shared] modelCache] fetchModel:[model getAttribute:@"subjectAddress"]];
    [covertedModel setObject:eventModel forKey:@"eventModel"];
    
    return covertedModel;
}

#pragma mark - view controller functions
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Alarm History", nil)];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    _tableView.allowsSelection = NO;
    
    [self loadHistoryData];
}

- (void)loadHistoryData {
    SubsystemModel *model = _alarmType == AlarmTypeSafety ? [SubsystemsController sharedInstance].safetyController.subsystemModel : [SubsystemsController sharedInstance].securityController.subsystemModel;
    
    [_historyList setObject:@[] forKey:@"Loading..."];
    // Call from sub system
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        [SubsystemsController getSubsystemHistory:model withToken:@"" entriesLimit:50 includeIncidents:NO].thenInBackground(^(SubsystemListHistoryEntriesResponse *response) {
            if ([_historyList objectForKey:@"Loading..."]) {
                [_historyList removeObjectForKey:@"Loading..."];
            }
            if ([_historyList objectForKey:@"No items found."]) {
                [_historyList removeObjectForKey:@"No items found."];
            }
            
            [self addWithResults:[response getResults]];
            _nextLogEntryToken = response.getNextToken;
            
            if (_historyList.count == 0) {
                [_historyList setObject:@[] forKey:@"No items found."];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }).catch(^{
            [_historyList setObject:@[] forKey:@"No items found."];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    });
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _historyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_historyList keyAtIndex:section];
    return ((NSArray *)[_historyList objectForKey:key]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSString *key = [_historyList keyAtIndex:indexPath.section];
    NSDictionary *dic = [_historyList objectForKey:key][indexPath.row];

    [cell setTime:dic[@"time"] alarmType:dic[@"name"] event:((NSString *)dic[@"subtitle"]).uppercaseString eventModel:nil];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    NSString *key = [_historyList keyAtIndex:section];
    
    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [label styleSet:key andButtonType:FontDataType_DemiBold_14_White_NoSpace];
    
    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
