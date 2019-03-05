//
//  ZoneSettingViewController.m
//  i2app
//
//  Created by Arcus Team on 3/4/16.
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
#import "ZoneSettingViewController.h"
#import "LawnNGardenSubsystemController.h"
#import "ScheduleController.h"
#import "OrderedDictionary.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "IrrigationZoneModel.h"
#import "PopupSelectionIrrigationView.h"
#import "NSDate+Convert.h"
#import "IrrigationScheduledEventModel.h"
#import "LawnNGardenScheduleController.h"
#import "UIImage+ImageEffects.h"
#import "IrrigationControllerCapability.h"

#pragma mark - ZoneSettingCell
@interface ZoneSettingCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *zoneImage;
@property (weak, nonatomic) IBOutlet UILabel *zoneNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoneDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@property (nonatomic, strong) IrrigationZoneModel *zone;

- (void)setTitleWithZone:(IrrigationZoneModel *)zone withImage:(UIImage *)image;
- (void)triggerSelection;

@end

@implementation ZoneSettingCell

- (void)setTitleWithZone:(IrrigationZoneModel *)zone withImage:(UIImage *)image {
    _zone = zone;
    
    if (ScheduleController.scheduleController.updatedEventModel.isNewModel) {
        [self.checkButton setImage:[UIImage imageNamed:@"RoleCheckedIcon"] forState:UIControlStateSelected];
        [self.checkButton setImage:[UIImage imageNamed:@"RoleUncheckButton"] forState:UIControlStateNormal];
        _checkButton.selected = _zone.selected;
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chevron"]];
        _zoneImage.image = [image invertColor];
        [_zoneNameLabel styleSet:zone.name andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
        [self.zoneDetailLabel styleSet:[NSString stringWithFormat:@"Zone %@", [zone.zoneValue substringFromIndex:1]] andButtonType:FontDataType_MediumItalic_14_BlackAlpha upperCase:NO];
        [self.durationLabel styleSet:[NSString stringWithFormat:@"%d Min", self.zone.defaultDuration] andButtonType:FontDataType_Medium_14_Black];
    }
    else {
        [self.checkButton setImage:[UIImage imageNamed:@"CheckmarkDetail"] forState:UIControlStateSelected];
        [self.checkButton setImage:[UIImage imageNamed:@"UncheckmarkDetail"] forState:UIControlStateNormal];
        [_checkButton setSelected:_zone.selected];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChevronWhite"]];

        _zoneImage.image = image;
        [_zoneNameLabel styleSet:zone.name andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
        [self.zoneDetailLabel styleSet:[NSString stringWithFormat:@"Zone %@", [zone.zoneValue substringFromIndex:1]] andButtonType:FontDataType_MediumItalic_14_WhiteAlpha upperCase:NO];
        [self.durationLabel styleSet:[NSString stringWithFormat:@"%d Min", self.zone.defaultDuration] andButtonType:FontDataType_Medium_14_White];
    }
}

- (void)triggerSelection {
    _zone.selected = !_zone.selected;
    _checkButton.selected = _zone.selected;
}

- (IBAction)pressedSelect:(id)sender {
    [self triggerSelection];
}

- (void)layoutSubviews {
    if (self.isEditing) {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = 0;
        cellFrame.size.width = self.superview.frame.size.width;
        [self setFrame:cellFrame];
    }
    else {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = -50;
        cellFrame.size.width = self.superview.frame.size.width + 50;
        [self setFrame:cellFrame];
    }
    [super layoutSubviews];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: YES];
    
    // Need to replace the default image of the table view cell reorder image
    if (ScheduleController.scheduleController.updatedEventModel.isNewModel && editing) {
        for (UIView *view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView *subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed:@"ReorderTableCellImage"];
                    }
                }
            }
        }
    }   
}

@end


#pragma mark - ZoneSettingViewController
@interface ZoneSettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (nonatomic, strong) PopupSelectionWindow *popupWindow;

@property (strong, nonatomic) NSMutableArray *allZones;
@property (weak, nonatomic) NSMutableArray *selectedZones;

@end

@implementation ZoneSettingViewController {
    UIImage         *_zoneImage;
    
    IrrigationZoneModel     *_selectedZone;
}

@dynamic selectedZones;

+ (ZoneSettingViewController *) create {
    return [[UIStoryboard storyboardWithName:@"Scheduler" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    
    [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(editZones:)];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    if (ScheduleController.scheduleController.updatedEventModel.isNewModel) {
        [self addOverlay:NO];
        [self.screenTitle styleSet:NSLocalizedString(@"Tap Edit to select the zones and watering duration for this event", nil) andFontData:[FontData createFontData:FontTypeDemiBold size:18 blackColor:YES]];
        [self.subTitle styleSet:NSLocalizedString(@"To water the same zone multiple times a day, you'll need to create additional events.", nil) andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:YES]];
    }
    else {
        [self addOverlay:YES];

        [self.screenTitle styleSet:NSLocalizedString(@"Tap Edit to select the zones and watering duration for this event", nil) andFontData:[FontData createFontData:FontTypeDemiBold size:18 blackColor:NO]];
        [self.subTitle styleSet:NSLocalizedString(@"To water the same zone multiple times a day, you'll need to create additional events.", nil) andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO]];
    }

    _allZones = ((IrrigationScheduledEventModel *)ScheduleController.scheduleController.updatedEventModel).allZones.mutableCopy;
    DeviceModel *device = (DeviceModel *)ScheduleController.scheduleController.schedulingModel;
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
        _zoneImage = image;
        
        [self.tableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    ((IrrigationScheduledEventModel *)ScheduleController.scheduleController.updatedEventModel).allZones = _allZones;
}

#pragma mark - Dynamic Properites
- (NSArray *)selectedZones {
    return ((IrrigationScheduledEventModel *)ScheduleController.scheduleController.updatedEventModel).selectedZones;
}

- (void)editZones:(UIButton *)sender {
    if (_tableView.isEditing) {
        [_tableView setEditing:NO animated: YES];
        [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(editZones:)];
        
        ((IrrigationScheduledEventModel *)ScheduleController.scheduleController.updatedEventModel).allZones = _allZones;
        [self.tableView reloadData];
    }
    else {
        [_tableView setEditing:YES animated:YES];
        [self navBarWithTitle:[NSLocalizedString(@"Settings", nil) uppercaseString] andRightButtonText:@"Done" withSelector:@selector(editZones:)];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.isEditing) {
        return _allZones.count;
    }
    return self.selectedZones.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZoneSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (tableView.isEditing) {
        [cell setTitleWithZone:_allZones[indexPath.row] withImage:_zoneImage];
    }
    else {
        [cell setTitleWithZone:self.selectedZones[indexPath.row] withImage:_zoneImage];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.isEditing) {
        ZoneSettingCell *cell = (ZoneSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell triggerSelection];
    }
    else {
        _selectedZone = ((ZoneSettingCell *)[tableView cellForRowAtIndexPath:indexPath]).zone;
        
        PopupSelectionIrrigationView *picker = [PopupSelectionIrrigationView create:@"DURATION" list:nil];
        picker.selectedDurationKey = @(_selectedZone.defaultDuration).stringValue;
        [self popup:picker complete:@selector(onDefaultDurationSelection:) withOwner:self];
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector withOwner:(id)owner {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:owner
                                 closeSelector:selector];
}

- (void)onDefaultDurationSelection:(NSDictionary *)selectedValue {
    _selectedZone.defaultDuration = [selectedValue[@"time"] intValue];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // find the index of the destZone
    IrrigationZoneModel *destZone = ((ZoneSettingCell *)[tableView cellForRowAtIndexPath:destinationIndexPath]).zone;
    int newIndex = (int)[_allZones indexOfObject:destZone];
    
    IrrigationZoneModel *sourceZone = _allZones[sourceIndexPath.row];
    if (sourceZone) {
        [_allZones removeObject:sourceZone];
        [_allZones insertObject:sourceZone atIndex:newIndex];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Hide";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - Popup view handling
- (void)popup:(PopupSelectionBaseContainer *)container completeBlock:(void (^)(id selectedValue))closeBlock  {
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    _popupWindow = [PopupSelectionWindow popupWithBlock:self.view
                                                subview:container
                                                  owner:self
                                             closeBlock:closeBlock];
}


@end



