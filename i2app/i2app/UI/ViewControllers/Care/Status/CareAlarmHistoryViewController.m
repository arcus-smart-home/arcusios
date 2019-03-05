//
//  CareAlarmHistoryViewController.m
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
#import "CareAlarmHistoryViewController.h"
#import "AlarmHistoryCell.h"
#import "AlarmConfiguration.h"
#import "ArcusTwoLabelTableViewSectionHeader.h"

#import "SubsystemCapability.h"
#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SafetySubsystemAlertController.h"

#import "CareSubsystemController.h"
#import "CareSubsystemCapability.h"

#import "UIImage+ImageEffects.h"
#import "NSDate+Convert.h"



#import "OrderedDictionary.h"
#import <PureLayout/PureLayout.h>

#import <i2app-Swift.h>

#define ALARM_HISTORY_PAGE_SIZE 25
#define ESTIMATED_ROW_HEIGHT 70

@interface CareAlarmHistoryViewController ()
@property(strong, nonatomic) OrderedDictionary *historyList;
@property(strong, nonatomic) NSDate *lastDateLoaded;
@property(strong, nonatomic) NSString *nextLogEntryToken;

@end

@implementation CareAlarmHistoryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.alarmType = AlarmTypeCare;
    _historyList = [[OrderedDictionary alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArcusTwoLabelTableViewSectionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"sectionHeader"];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Care Alarm History", nil)];

    [self loadHistoryWithToken:@""];

}

#pragma mark - History methods

- (void)loadHistoryData {
    // Overriding parent class metho as to not fetch incorrectly on initialization.
}

- (void)loadHistoryWithToken:(NSString *)token {
    [_historyList setObject:@[] forKey:@"Loading..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[[SubsystemsController sharedInstance] careController] careAlarmHistoryWithLimit:ALARM_HISTORY_PAGE_SIZE withToken:token].thenInBackground(^(SubsystemListHistoryEntriesResponse *response) {
            if ([_historyList objectForKey:@"Loading..."]) {
                [_historyList removeObjectForKey:@"Loading..."];
            }
            if ([_historyList objectForKey:@"No items found."]) {
                [_historyList removeObjectForKey:@"No items found."];
            }
            
            NSDictionary *responseDict = (NSDictionary *)response;
            [self addWithResults:[responseDict objectForKey:@"results"]];
            
            self.nextLogEntryToken = [responseDict objectForKey:@"nextToken"];
            if ([[NSNull null] isEqual:self.nextLogEntryToken]) {
                self.nextLogEntryToken = nil;
            }
            
            if (_historyList.count == 0) {
                [_historyList setObject:@[] forKey:@"No items found."];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableView] reloadData];
            });
        }).catch(^{
            [_historyList setObject:@[] forKey:@"No items found."];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self tableView] reloadData];
            });
        });
    });
}

#pragma mark - Filter history

- (void)addWithResults:(NSArray *)results {
    NSDate *serviceLevelCutOff  = nil;
    
    serviceLevelCutOff = [[NSDate dateWithTimeIntervalSinceNow:-((60 * 60 * 24) * 14)] toPlaceTime];
    
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
    [covertedModel setObject:[eventTime formatTimeStamp] forKey:@"time"];
    [covertedModel setObject:[eventTime formatDateStamp] forKey:@"date"];
    [covertedModel setObject:[model getAttribute:@"shortMessage"] forKey:@"name"];
    [covertedModel setObject:[model getAttribute:@"subjectName"] forKey:@"subtitle"];
    
    Model *eventModel = [[[CorneaHolder shared] modelCache] fetchModel:[model getAttribute:@"subjectAddress"]];
    [covertedModel setObject:eventModel forKey:@"eventModel"];
    
    return covertedModel;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _historyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_historyList keyAtIndex:section];
    NSInteger count = ((NSArray *)[_historyList objectForKey:key]).count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *key = [_historyList keyAtIndex:indexPath.section];
    NSDictionary *dic = [_historyList objectForKey:key][indexPath.row];
    
    cell.timeLabel.text = dic[@"time"];
    cell.titleLabel.text = dic[@"name"];
    cell.subtitleLabel.text = dic[@"subtitle"];
    cell.iconImage.image = [[UIImage imageNamed:@"care"] invertColor];
    cell.iconImage.tintColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *key = [_historyList keyAtIndex:indexPath.section];
    NSInteger count = ((NSArray *)[_historyList objectForKey:key]).count;
    
    if (self.nextLogEntryToken && indexPath.row == count - 1) {
        NSString *tokenToUse = self.nextLogEntryToken;
        self.nextLogEntryToken = nil;
        [self loadHistoryWithToken:tokenToUse];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header;
    
    if (_historyList.count > 0) {
        NSString *key = [_historyList keyAtIndex:section];
        NSArray *history = [_historyList objectForKey:key];
        
        if (history && [history count] > 0) {
            NSDictionary *dic = [_historyList objectForKey:key][0];
            NSString *time = dic[@"time"];
            NSString *date = nil;
            
            date = (section == 0)? key : dic[@"date"];
            
            ArcusTwoLabelTableViewSectionHeader *sectionHeader = (ArcusTwoLabelTableViewSectionHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"sectionHeader"];
            [sectionHeader.mainTextLabel setText:date];
            [sectionHeader.accessoryTextLabel setText:time];
            sectionHeader.backingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
            sectionHeader.hasBlurEffect = YES;
            
            header = sectionHeader;
        } else {
            header = [UIView new];
        }
    } else {
        header = [UIView new];
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ESTIMATED_ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
