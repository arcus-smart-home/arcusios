//
//  SceneDeviceListViewController.m
//  i2app
//
//  Created by Arcus Team on 10/27/15.
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
#import "SceneDeviceListViewController.h"
#import "DeviceManager.h"
#import "CommonCheckableImageCell.h"
#import "SceneManager.h"
#import "DeviceCapability.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"

@interface SceneDeviceListViewController ()  <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, assign) BOOL isEditing;

@end

@implementation SceneDeviceListViewController {
    NSArray     *_devices;
}

+ (SceneDeviceListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithTitle:[NSLocalizedString(@"Choose a scene", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(toggleEditState:)];
    [self addBackButtonItemAsLeftButtonItem];
    [self setBackgroundColorToLastNavigateColor];
    
    if ([SceneManager sharedInstance].isNewScene) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        [self.headerTitle setTextColor:[UIColor blackColor]];
        [self.subtitleLabel setTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]];
    }
    else {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [self.headerTitle setTextColor:[UIColor whiteColor]];
        [self.subtitleLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]];
    }
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    
    [self loadData];
}

- (void)loadData {
    _devices = [[NSMutableArray alloc] init];
    _devices = [DeviceManager instance].devices;
    
    [self.tableView reloadData];
}

- (void)toggleEditState:(id)sender {
    if (self.isEditing ||
        (!self.isEditing && _devices.count > 0)) {
        self.isEditing = !self.isEditing;
        [self navBarWithTitle:[NSLocalizedString(@"scene", nil) uppercaseString] andRightButtonText:(self.isEditing ? NSLocalizedString(@"DONE", @"") : NSLocalizedString(@"EDIT", @"")) withSelector:@selector(toggleEditState:)];
        
        [self.tableView reloadData];
    }
}


#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
    
    DeviceModel *model = ((DeviceModel *)_devices[indexPath.row]);
    
    if ([SceneManager sharedInstance].isNewScene) {
        [cell setIcon:nil withBlackTitle:model.name subtitle:@"" andSide:@"-"];
    }
    else {
        [cell setIcon:nil withWhiteTitle:model.name subtitle:@"" andSide:@"-"];
    }
    
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    if (image) {
        image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
        image = [image roundCornerImageWithsize:CGSizeMake(45, 45)];
        
        [cell setIcon:image];
    }
    else {
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model] withDevTypeId:[(DeviceModel *)model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:[SceneManager sharedInstance].isNewScene].then(^(UIImage *image) {
            
            [cell setIcon:image];
        });
    }
    
    if (self.editing) {
        [cell setCheck:NO styleBlack:[SceneManager sharedInstance].isNewScene];
        [cell displayArrow:NO];
    }
    else {
        [cell hideCheckbox];
        [cell displayArrow:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isEditing) {
        CommonCheckableImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setCheck:![cell getChecked] styleBlack:[SceneManager sharedInstance].isNewScene];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
