//
//  RuleScheduleViewController.m
//  i2app
//
//  Created by Arcus Team on 6/25/15.
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
#import "RuleScheduleViewController.h"
#import <PureLayout/PureLayout.h>
#import "RuleDetailModel.h"
#import "CustomHoursAMPMTimePicker.h"
#import "NSDate+Convert.h"

@interface RuleScheduleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) RuleDetailModel *model;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

- (IBAction)onClickCloseButton:(id)sender;

@end

@implementation RuleScheduleViewController {
    __weak IBOutlet NSLayoutConstraint *_timerViewButtomConstraint;
    CustomHoursAMPMTimePicker *_picker;
    BOOL _settingStartTime;
    RuleOccurModel *_currectOccur;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"occurs", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.title];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setBackgroundColorToLastNavigateColor];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    _picker = [[CustomHoursAMPMTimePicker alloc] init];
    [self.timerView addSubview:_picker];
    [_picker autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.timerView withOffset:111];
    [_picker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.timerView];
    [_picker autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.timerView];
    [_picker autoSetDimension:ALDimensionHeight toSize:260];
    _timerViewButtomConstraint.constant = -self.timerView.bounds.size.height;
    
    self.startButton.layer.cornerRadius = 4.0f;
    self.startButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.startButton.layer.borderWidth = 1.0f;
    
    self.endButton.layer.cornerRadius = 4.0f;
    self.endButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.endButton.layer.borderWidth = 0.0f;
    
    _settingStartTime = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_picker initialize];
}

#pragma mark - methods
- (IBAction)onClickCloseButton:(id)sender {
    [_picker valueChanged];
    if (_settingStartTime) {
        _currectOccur.startTime = _picker.date;
    }
    else {
        _currectOccur.endTime = _picker.date;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _timerViewButtomConstraint.constant = -self.timerView.bounds.size.height;
        [self.tableView reloadData];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)onClickStartButton:(id)sender {
    _settingStartTime = YES;
    self.startButton.layer.borderWidth = 1.0f;
    self.endButton.layer.borderWidth = 0.0f;
    
    [_picker valueChanged];
    _currectOccur.endTime = _picker.date;
    if (!_currectOccur.startTime) {
        [_picker showDate: [NSDate date2000Year]];
    }
    else {
        [_picker showDate:_currectOccur.startTime];
    }
}

- (IBAction)onClickEndButton:(id)sender {
    _settingStartTime = NO;
    self.startButton.layer.borderWidth = 0.0f;
    self.endButton.layer.borderWidth = 1.0f;
    
    [_picker valueChanged];
    _currectOccur.startTime = _picker.date;
    if (!_currectOccur.endTime) {
        [_picker showDate: [NSDate date2000Year]];
    }
    else {
        [_picker showDate:_currectOccur.endTime];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.occurs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RuleScheduleViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setModel:self.model.occurs[indexPath.row] controller:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RuleOccurModel *model = self.model.occurs[indexPath.row];
    _currectOccur = model;
    
    _settingStartTime = YES;
    self.startButton.layer.borderWidth = 1.0f;
    self.endButton.layer.borderWidth = 0.0f;
    
    if (!model.startTime) {
        [_picker showDate: [[NSDate dateWithTimeIntervalSince1970:0] toPlaceTime]];
    }
    else {
        [_picker showDate:model.startTime];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        _timerViewButtomConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


@end


@interface RuleScheduleViewControllerCell ()

@property (weak, nonatomic) RuleScheduleViewController *controller;
@property (weak, nonatomic) RuleOccurModel *model;

@end

@implementation RuleScheduleViewControllerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(RuleOccurModel *)model controller:(RuleScheduleViewController *)controller {
    self.model = model;
    self.controller = controller;
    
    [self.checkButton setSelected:model.selected];
    [self.dayLabel styleSet:[self.model getTypeString] andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    [self.valueLabel styleSet:[self.model getDateString] andButtonType:FontDataType_Medium_14_BlackAlpha_NoSpace];
}

- (IBAction)onClickCheck:(id)sender {
    [self.checkButton setSelected:!self.checkButton.selected];
    self.model.selected = self.checkButton.selected;
}

@end






