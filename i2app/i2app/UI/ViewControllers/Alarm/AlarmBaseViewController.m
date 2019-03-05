 //
//  AlarmBaseViewController.m
//  i2app
//
//  Created by Arcus Team on 8/17/15.
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
#import "AlarmBaseViewController.h"
#import <PureLayout/PureLayout.h>
#import "DevicesAlarmRingView.h"

#import "SDWebImageManager.h"
#import "ImagePaths.h"
#import "UIImage+ImageEffects.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"

#import "AlarmTabBarViewController.h"
#import "AlarmingViewController.h"

#import <PureLayout/PureLayout.h>
#import "NSArray+GroupBy.h"

@interface AlarmBaseViewController ()

@property (weak, nonatomic) IBOutlet UIView *alarmMainView;
@property (weak, nonatomic) IBOutlet DevicesAlarmRingView *deviceRingSegment;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attributeTopConstraint;


@property (weak, nonatomic) IBOutlet UIView *AlarmView;
@property (weak, nonatomic) IBOutlet UIImageView *alarmDeviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceName;
@property (weak, nonatomic) IBOutlet UILabel *alarmDeviceEvent;



@property (strong, nonatomic) UILabel *mainRingLabel;
@property (strong, nonatomic) UILabel *titleRingLabel;


@end

@implementation AlarmBaseViewController {
    __weak IBOutlet NSLayoutConstraint *buttonsAreaConstraint;
    __weak IBOutlet NSLayoutConstraint *attributeAreaConstraint;
    PopupSelectionWindow *_popupWindow;
    AlarmingViewController *_alarmingController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.alarmMainView setBackgroundColor:[UIColor clearColor]];

    _deviceRingSegment.clipsToBounds = YES;
    _deviceRingSegment.layer.masksToBounds = YES;
    
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
    
    [self setRingTextWithTitle:@"Devices"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

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

+ (AlarmBaseViewController *)createWithStoryboard:(NSString *)storyboard withOwner:(AlarmTabBarViewController *)owner {
    AlarmBaseViewController *vc = [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.owner = owner;
    return vc;
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

- (void)loadRingSigmentsWithModel:(NSArray *)segmentModels {
    self.deviceRingSegment.segmentModels = segmentModels;
    [self.deviceRingSegment setNeedsDisplay];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmBaseViewControllerCell *cell = (AlarmBaseViewControllerCell *)[tableView dequeueReusableCellWithIdentifier:@"logoTextCell"];
    
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
    AlarmType type = (AlarmType)AlarmControllerNameToEnum(NSStringFromClass([self class]));
    
    _alarmingController = [AlarmingViewController createWithOwner:self alarmType:type name:name event:event icon:icon borderColor:color];
    _alarmingController.view.tag = 10;
    [self.owner.view addSubview:_alarmingController.view];
    
    if (self.owner) {
        [_alarmingController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.owner.view];
        [_alarmingController.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.owner.view];
        [_alarmingController.view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.owner.view];
        [_alarmingController.view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.owner.view];
    }
    _alarmingController.view.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        _alarmingController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setIconByDevice:(DeviceModel *)device withImage:(NSString *)imageName {
    [_alarmingController setDeviceIcon:[[UIImage imageNamed:imageName] invertColor]];
    
    if (device && [device isKindOfClass:[DeviceModel class]]) {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:YES].then(^(UIImage *image) {
            if (image && _alarmingController) {
                [_alarmingController setDeviceIcon:image];
            }
        });
    }
}

- (void)deactivateAlarm {
    self.isAlarming = NO;
    if (_alarmingController) {
        [UIView animateWithDuration:0.5 animations:^{
            _alarmingController.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[self.owner.view viewWithTag:10] removeFromSuperview];
            [_alarmingController.view removeFromSuperview];
            [_alarmingController removeFromParentViewController];
        }];
    }
    
}



- (void)removeButtons {
    if (_attributeTopConstraint.constant != 10.0f) {
        _attributeTopConstraint.constant = 10.0f;
        CGRect frame = self.alarmMainView.frame;
        frame.size.height = 340;
        [self.alarmMainView setFrame:frame];
        [self.alarmMainView layoutIfNeeded];
        [self.tableView setTableHeaderView:self.alarmMainView];
    }
    
    [self.buttonsView loadControl:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button {
    [self loadButton:button button2:nil button3:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2 {
    [self loadButton:button button2:button2 button3:nil];
}

- (void)loadButton:(DeviceButtonBaseControl *)button button2:(DeviceButtonBaseControl *)button2 button3:(DeviceButtonBaseControl *)button3 {
    if (_attributeTopConstraint.constant != 90.0) {
        _attributeTopConstraint.constant = 90.0;
        CGRect frame = self.alarmMainView.frame;
        frame.size.height = 400;
        [self.alarmMainView setFrame:frame];
        [self.view layoutIfNeeded];
        [self.tableView setTableHeaderView:self.alarmMainView];
    }
    
    [self.buttonsView loadControl:button control2:button2 control3:button3];
}


@end


@implementation AlarmBaseViewControllerCell {
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
    
    NSArray *_logoImages;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    if (title.length > 0) {
        [titleLabel styleSet:title andButtonType:FontDataType_DemiBold_13_White];
        titleLabel.hidden = NO;
    }
    if (subtitle.length > 0) {
        [subtitleLabel styleSet:subtitle andButtonType:FontDataType_MediumItalic_13_WhiteAlpha_NoSpace];
        titleLabel.hidden = NO;
    }
    else {
        subtitleLabel.text = @"";
    }
    
    if (_logoImages && _logoImages.count > 1) {
        titleLabel.hidden = YES;
        subtitleLabel.hidden = YES;
    }
}

- (void)setLogo:(UIImage *)logo {
    for (UIView *view in _iconScroller.subviews) {
        [view removeFromSuperview];
    }
    _logoImages = nil;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:logo];
    [_iconScroller addSubview:image];
    [image autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [image autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_iconScroller withOffset:1];
    [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconScroller];
    _iconScroller.contentSize = CGSizeMake(_logoImages.count * 50, 50);
    
    self.iconScroller.userInteractionEnabled = NO;
}

- (void)setLogos:(NSArray *)logos {
    for (UIView *view in _iconScroller.subviews) {
        [view removeFromSuperview];
    }
    _logoImages = logos;
    
    [titleLabel setHidden:YES];
    [subtitleLabel setHidden:YES];
    
    // Only display first 5
    UIImageView *lastItem = nil;
    for (int i=0; i<(_logoImages.count>5?5:_logoImages.count); i++) {
        UIImage *logo = _logoImages[i];
        UIImageView *image = [[UIImageView alloc] initWithImage:logo];
        image.layer.cornerRadius = 25.0f;
        image.layer.masksToBounds = YES;
        image.userInteractionEnabled = NO;
        [_iconScroller addSubview:image];
        [image autoSetDimensionsToSize:CGSizeMake(50, 50)];
        [image autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_iconScroller withOffset:1];
        if (lastItem) {
            [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lastItem withOffset:10.0f];
        }
        else {
            [image autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_iconScroller];
        }
        lastItem = image;
    }
    
    _iconScroller.contentSize = CGSizeMake(_logoImages.count * 60, 50);
    self.iconScroller.userInteractionEnabled = NO;
}


@end





