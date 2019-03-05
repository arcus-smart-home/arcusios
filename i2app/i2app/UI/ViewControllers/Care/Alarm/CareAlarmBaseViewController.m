//
//  CareAlarmBaseViewController.m
//  i2app
//
//  Created by Arcus Team on 2/1/16.
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
#import "CareAlarmBaseViewController.h"
#import "CareAlarmBaseViewControllerCell.h"
#import "CareAlarmViewController.h"
#import "CareAlarmTabBarViewController.h"

#import "DeviceAttributeGroupView.h"
#import "DeviceButtonGroupView.h"
#import "DeviceAttributeGroupView.h"
#import "PopupSelectionBaseContainer.h"
#import "SubsystemsController.h"

#import <PureLayout/PureLayout.h>
#import "DevicesAlarmRingView.h"

#import "SDWebImageManager.h"
#import "ImagePaths.h"
#import "UIImage+ImageEffects.h"

#import "ImageDownloader.h"
#import "DeviceCapability.h"

@interface CareAlarmBaseViewController ()

@property (weak, nonatomic) IBOutlet UIView *alarmMainView;
@property (weak, nonatomic) IBOutlet DevicesAlarmRingView *deviceRingSegment;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attributeTopConstraint;

@property (weak, nonatomic) IBOutlet UIView *AlarmView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmDeviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceEvent;

@property (strong, nonatomic) UILabel *mainRingLabel;
@property (strong, nonatomic) UILabel *titleRingLabel;

@end

@implementation CareAlarmBaseViewController {
    //__weak IBOutlet NSLayoutConstraint *buttonsAreaConstraint;
    //__weak IBOutlet NSLayoutConstraint *attributeAreaConstraint;
    PopupSelectionWindow *_popupWindow;
    CareAlarmViewController *_alarmingController;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)]];
    
    [self.alarmMainView setBackgroundColor:[UIColor clearColor]];
    _deviceRingSegment.clipsToBounds = YES;
    _deviceRingSegment.layer.masksToBounds = YES;
    /*
    _mainRingLabel = [[UILabel alloc] initForAutoLayout];
    [_alarmMainView addSubview:_mainRingLabel];
    [_mainRingLabel autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:_deviceRingSegment withOffset:18];
    [_mainRingLabel autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:_deviceRingSegment];
    
    _titleRingLabel = [[UILabel alloc] initForAutoLayout];
    [_titleRingLabel setNumberOfLines:0];
    [_titleRingLabel setTextAlignment:NSTextAlignmentCenter];
    [_alarmMainView addSubview:_titleRingLabel];
    [_titleRingLabel autoConstrainAttribute:ALAttributeVertical toAttribute:ALAttributeVertical ofView:_deviceRingSegment];
    [_titleRingLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_mainRingLabel ];
    [_titleRingLabel autoSetDimension:ALDimensionWidth toSize:100];
    [self.alarmDeviceIcon setImage:[UIImage new]];
    */
    [self setRingTextWithTitle:@"Devices"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Create method

+ (CareAlarmBaseViewController *)createWithStoryboard:(NSString *)storyboard withOwner:(CareAlarmTabBarViewController *)owner {
    CareAlarmBaseViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.owner = vc;

    return vc;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CareAlarmBaseViewControllerCell *cell = (CareAlarmBaseViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"logoTextCell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - assist function

- (void)activeAlarmWithName:(NSString *)name event:(NSString *)event icon:(UIImage *)icon borderColor:(UIColor *)color {
    self.isAlarming = YES;
    AlarmType type = AlarmControllerNameToEnum(NSStringFromClass([self class]));
    
    _alarmingController = [CareAlarmViewController createWithOwner:self alarmType:type name:name event:event icon:icon borderColor:color];
    _alarmingController.view.tag = 10;
    [self.owner.view addSubview:_alarmingController.view];
    
    [_alarmingController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.owner.view];
    [_alarmingController.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.owner.view];
    [_alarmingController.view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.owner.view];
    [_alarmingController.view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.owner.view];
    
    _alarmingController.view.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        _alarmingController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)deactivateAlarm {
    [self.deviceRingSegment setAlpha:0.0f];
    [self.mainRingLabel setAlpha:0.0f];
    [self.titleRingLabel setAlpha:0.0f];
    [self.deviceRingSegment setHidden:NO];
    [self.mainRingLabel setHidden:NO];
    [self.titleRingLabel setHidden:NO];
    [self removeButtons];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.AlarmView setAlpha:0.0f];
        [self.deviceRingSegment setAlpha:1.0f];
        [self.mainRingLabel setAlpha:1.0f];
        [self.titleRingLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [self.AlarmView setHidden:YES];
        
    }];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCATransitionFade];
    [self.navigationController.view.layer addAnimation:transition forKey:@"fadeAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
}

- (void)setIconByDevice:(DeviceModel *)device withImage:(NSString *)imageName {
    [self.alarmDeviceIcon setImage:[[UIImage imageNamed:imageName] invertColor]];
    
    if (device && [device isKindOfClass:[DeviceModel class]]) {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
            if (image) {
                [self.alarmDeviceIcon setImage:image];
            }
        });
    }
}

#pragma mark - RingText methods

- (void)setRingTextWithTitle:(NSString *)title {
    int numberOfAllDevices = [self.delegate numberOfDevices];
    int numberOfOfflineDevices = [self.delegate numberOfOfflineDevices];
    int numberOfOnlineDevices = [self.delegate numberOfOnlineDevices];
    
    [self setRingTitle:NSLocalizedString(title, nil)];
    if (numberOfOfflineDevices == 0) {
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfAllDevices]];
    }
    else {
        [self setRingText:[NSString stringWithFormat:@"%d", numberOfOnlineDevices] withSuperscript:[NSString stringWithFormat:@"/%d", numberOfAllDevices]];
    }
}

- (void)setRingText:(NSString *)text {
    [_mainRingLabel styleSet:text andButtonType:FontDataType_UltraLight_60_White];
}

- (void)setRingText:(NSString *)text withSuperscript:(NSString *)script {
    [_mainRingLabel setAttributedText:[FontData getString:text andString2:script withCombineFont:FontDataCombineTypeAlarmText]];
}

- (void)setRingTitle:(NSString *)title {
    [_titleRingLabel setAttributedText: [[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:[FontData getFontWithSize:13 bold:NO kerning:2.0f color:[UIColor whiteColor]]]];
}

#pragma mark - Ring Segment methods

- (void)loadRingSigmentsWithModel:(NSArray *)segmentModels {
    self.deviceRingSegment.segmentModels = segmentModels;
    [self.deviceRingSegment setNeedsDisplay];
}

#pragma mark - Popup methods

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

#pragma mark - Button methods

- (void)removeButtons {
    /*
    if (_attributeTopConstraint.constant != 10.0f) {
        _attributeTopConstraint.constant = 10.0f;
        CGRect frame = self.alarmMainView.frame;
        frame.size.height = 340;
        [self.alarmMainView setFrame:frame];
        [self.alarmMainView layoutIfNeeded];
        [self.tableView setTableHeaderView:self.alarmMainView];
    }
     */
    
    [self.buttonsView loadControl:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button {
    [self loadButton:button button2:nil button3:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2 {
    [self loadButton:button button2:button2 button3:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2 button3:(DeviceButtonBaseControl *)button3 {
    /*
    if (_attributeTopConstraint.constant != 90.0) {
        _attributeTopConstraint.constant = 90.0;
        CGRect frame = self.alarmMainView.frame;
        frame.size.height = 400;
        [self.alarmMainView setFrame:frame];
        [self.view layoutIfNeeded];
        [self.tableView setTableHeaderView:self.alarmMainView];
    }
     */
    
    [self.buttonsView loadControl:button control2:button2 control3:button3];
}

@end
