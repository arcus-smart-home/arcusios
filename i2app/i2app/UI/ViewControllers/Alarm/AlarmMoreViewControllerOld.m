//
//  AlarmMoreViewController.m
//  i2app
//
//  Created by Arcus Team on 8/19/15.
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
#import "AlarmMoreViewControllerOld.h"
#import "AlarmMorePackage.h"
#import "AlarmDeviceListViewController.h"


#import "PopupSelectionWindow.h"
#import "PopupSelectionBaseContainer.h"

#import "SecuritySubsystemAlertController.h"
#import "SubsystemsController.h"
#import "SecurityAlarmModeCapability.h"
#import <i2app-Swift.h>

@interface AlarmBaseMorePackage()

@property (weak, nonatomic) AlarmMoreViewControllerOld *owner;

- (void)popup:(PopupSelectionBaseContainer *)container;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector;

@end

@interface AlarmMoreViewControllerOld ()

@property (strong, nonatomic) NSArray *units;
@property (readonly, strong, nonatomic) PopupSelectionWindow *popupWindow;
@property (strong, nonatomic) AlarmBaseMorePackage *currentPackage;

@end

@implementation AlarmMoreViewControllerOld {
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet NSLayoutConstraint *tableViewTopConstraint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _units = [[NSArray alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self navBarWithBackButtonAndTitle:self.title ? self.title : @""];
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self setBackgroundColorToLastNavigateColor];
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        tableViewTopConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }
    
    if ([self.currentPackage isKindOfClass:[AlarmSecurityGracePeriodMorePackge class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gracePeriodChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeEntranceDelaySec]] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gracePeriodChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeEntranceDelaySec]] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gracePeriodChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeExitDelaySec]] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gracePeriodChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeExitDelaySec]] object:nil];
    }
    else if ([self.currentPackage isKindOfClass:[AlarmSecurityMorePackage class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmSensitivityChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:PARTIAL",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]] object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alarmSensitivityChanged:) name: [Model attributeChangedNotification:[NSString stringWithFormat:@"%@:ON",kAttrSecurityAlarmModeAlarmSensitivityDeviceCount]] object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (AlarmMoreViewControllerOld *)create:(AlarmType)type withStoryboard:(NSString *)storyboard {
    AlarmMoreViewControllerOld *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    Class packageClass = NSClassFromString([NSString stringWithFormat:@"Alarm%@MorePackage",AlarmTypeToString(type)]);
    
    if (packageClass) {
        AlarmBaseMorePackage *package = (AlarmBaseMorePackage *)[[packageClass alloc] init];
        [vc setUnits:[package getUnits]];
        NSString *title = [package getTitle];
        if (title && title.length > 0) {
            vc.title = title;
        }
        vc.currentPackage = package;
        package.owner = vc;
    }
    
    return vc;
}

+ (AlarmMoreViewControllerOld *)createWithPackage:(AlarmBaseMorePackage *)package withStoryboard:(NSString *)storyboard {
    AlarmMoreViewControllerOld *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    if (package) {
        [vc setUnits:[package getUnits]];
        NSString *title = [package getTitle];
        if (title && title.length > 0) {
            vc.title = title;
        }
        vc.currentPackage = package;
        package.owner = vc;
    }
    
    return vc;
}

- (void)refreshPackage {
    
}

- (AlarmMoreViewBaseCell *)getCell:(NSInteger)row {
    AlarmMoreViewBaseCell *cell;
    
    AlarmMoreUnitModel *model = [_units objectAtIndex:row];
    model.owner = self;
    switch (model.unitType) {
        case AlarmUnitLabelType:
            cell = [_tableView dequeueReusableCellWithIdentifier:@"labelCell"];
            break;
        case AlarmUnitSwitchType:
            cell = [_tableView dequeueReusableCellWithIdentifier:@"switchCell"];
            break;
        default:
            break;
    }
    [cell setModel:model];
    
    return cell;
}

#pragma mark - popup window
- (void)popup:(PopupSelectionBaseContainer *)container {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    _popupWindow = [PopupSelectionWindow popup:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container];
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    _popupWindow = [PopupSelectionWindow popup:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWithBlock:(PopupSelectionBaseContainer *)container completeBlock:(void (^)(id selectedValue))closeBlock  {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    _popupWindow = [PopupSelectionWindow popupWithBlock:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                       subview:container
                                         owner:self
                                  closeBlock:closeBlock];
}

- (void)popupWithBlockSetCurrentValue:(PopupSelectionBaseContainer *)container currentValue:(id)currentValue completeBlock:(void (^)(id selectedValue))closeBlock  {
    
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    [container setCurrentKey:currentValue];
    _popupWindow = [PopupSelectionWindow popupWithBlock:((AppDelegate *)[UIApplication sharedApplication].delegate).window
                                                subview:container
                                                  owner:self
                                             closeBlock:closeBlock];
}

- (void)closePopup {
    [_popupWindow close];
}

- (void)completedDelay:(id)selectValue {
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _units.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmMoreViewBaseCell *cell = [self getCell:indexPath.row];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma notification

- (void)gracePeriodChanged:(NSNotification *)notification {
    self.currentPackage = [[AlarmSecurityGracePeriodMorePackge alloc] init];
    _units = self.currentPackage.getUnits;
    self.currentPackage.owner = self;
   
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
}

- (void)alarmSensitivityChanged:(NSNotification *)notification {
    self.currentPackage = [[AlarmSecurityMorePackage alloc] init];
    _units = self.currentPackage.getUnits;
    self.currentPackage.owner = self;
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });
}

@end

@implementation AlarmMoreUnitModel

#pragma mark - create functions
+ (AlarmMoreUnitModel *)createLabelModel: (NSString *)title subtitle:(NSString *)subtitle pressedEvent:(alarmUnitEvent)event {
    AlarmMoreUnitModel *model = [[AlarmMoreUnitModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.pressedEvent = event;
    model.unitType = AlarmUnitLabelType;
    return model;
}

+ (AlarmMoreUnitModel *)createLabelModel: (NSString *)title subtitle:(NSString *)subtitle sideValue:(NSString *)value pressedEvent:(alarmUnitEvent)event  {
    AlarmMoreUnitModel *model = [[AlarmMoreUnitModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.pressedEvent = event;
    model.sideValue = value;
    model.unitType = AlarmUnitLabelType;
    return model;
}

+ (AlarmMoreUnitModel *)createSwitchModel: (NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected switchEvent:(alarmUnitEvent)event {
    AlarmMoreUnitModel *model = [[AlarmMoreUnitModel alloc] init];
    model.title = title;
    model.subtitle = subtitle;
    model.updateEvent = event;
    model.enable = selected;
    model.unitType = AlarmUnitSwitchType;
    return model;
}

@end


@implementation AlarmMoreViewBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(AlarmMoreUnitModel *)model {
    _model = model;
    
    [_titleLabel styleSet:model.title andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    [_subtitleLabel styleSet:model.subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
    
    [_subtitleLabel sizeToFit];
    _cellHeight = _subtitleLabel.frame.size.height + 48;
}

- (IBAction)onClickBackgroup:(id)sender {
    if(_model) {
        if (_model.pressedEvent) {
            _model.pressedEvent(_model);
        }
    } else {
        DDLogInfo(@"_model is nil");
    }
}

@end


@implementation AlarmMoreViewLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(AlarmMoreUnitModel *)model {
    [super setModel:model];
    
    if (model.sideValue && model.sideValue.length > 0) {
        [self.numberLabel styleSet:model.sideValue andButtonType:FontDataType_Medium_12_White];
    }
    else {
        [self.numberLabel setText:@""];
    }
}

@end


@implementation AlarmMoreViewSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setModel:(AlarmMoreUnitModel *)model {
    [super setModel:model];
    [_switchButton setSelected:self.model.enable];
    //[_switchButton setEnabled:!self.model.disabled];
}

- (IBAction)onClickSwitch:(id)sender {
    self.model.enable = !self.model.enable;
    if (!self.model.disabled) {
        [_switchButton setSelected:self.model.enable];
    }
    if (self.model.updateEvent) {
        self.model.updateEvent(self.model);
    }
}

@end





