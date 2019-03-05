//
//  SantaMotionViewController.m
//  i2app
//
//  Created by Arcus Team on 11/3/15.
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
#import "SantaMotionViewController.h"

#import "SantaTakePhotoViewController.h"
#import "CommonCheckableImageCell.h"
#import "SantaTracker.h"
#import "DeviceManager.h"
#import "DeviceCapability.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "ArcusSelectOptionTableViewCell.h"

@interface SantaMotionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *savedButton;

@property (nonatomic, strong) NSMutableArray *devices;
@property (nonatomic) BOOL createModel;

@end

@implementation SantaMotionViewController {
    __weak IBOutlet NSLayoutConstraint *tableViewConstraint;
}

+ (SantaMotionViewController *)create:(BOOL)createModel {
    SantaMotionViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.createModel = createModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Santa Tracker™"];
    [self.tableView setBackgroundView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.createModel) {
        [self.savedButton styleSet:@"Next" andButtonType:FontDataTypeButtonLight upperCase:YES];
    }
    else {
        [self.savedButton setHidden:YES];
        tableViewConstraint.constant = 0;
    }
    
    [self.titleLabel styleSet:@"While Santa is inside, what motion sensors will he likely move through?" andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO]];
    [self loadData];
}

- (void)loadData {
    self.devices = [[DeviceManager instance] filterDevices:DeviceTypeMotionSensor].mutableCopy;
  
    [self.devices insertObject:@{@"icon":@"santa_tree", @"title":@"Christmas tree sensor", @"subtitle":@"Santa Sensor" } atIndex:0];
    [self.devices insertObject:@{@"icon":@"santa_cookie", @"title":@"Milk & Cookies Sensor", @"subtitle":@"Santa Sensor" } atIndex:1];
    [self.devices insertObject:@{@"icon":@"santa_stocking", @"title":@"Christmas stocking sensor", @"subtitle":@"Santa Sensor" } atIndex:2];
    
    [self.tableView reloadData];
}

- (IBAction)onClickSave:(id)sender {
    if (self.createModel) {
        if ([[SantaTracker shareInstance] getSantaMotionSensors] && [[SantaTracker shareInstance] getSantaMotionSensors].count > 0) {
            [[SantaTracker shareInstance] save];
            [self.navigationController pushViewController:[SantaTakePhotoViewController create:self.createModel] animated:YES];
        }
        else {
            [[SantaTracker shareInstance] saveSantaMotionSensors:@[self.devices[0][@"title"], self.devices[1][@"title"],self.devices[2][@"title"] ]];
            [self.tableView reloadData];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SelectionCell";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifier];
    }
    cell.managesSelectionState = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryImage.image = [UIImage imageNamed:@"RuleBlackChevron"].invertColor;
    cell.selectionImage.highlightedImage = [UIImage imageNamed:@"RoleUncheckButton"].invertColor;
    
    DeviceModel *model = self.devices[indexPath.row];
    
    if ([model isKindOfClass:[DeviceModel class]]) {
        cell.titleLabel.attributedText = [FontData getString:[model.name uppercaseString]
                                                    withFont:FontDataTypeDeviceKeyfobSettingSchedueTitle];
        cell.descriptionLabel.attributedText = [FontData getString:NSLocalizedString(@"Motion Sensor", nil)
                                                          withFont:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace];
        
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        if (image) {
            image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
            image = [image roundCornerImageWithsize:CGSizeMake(45, 45)];
            
            cell.detailImage.image = image;
        }
        else {
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model] withDevTypeId:[(DeviceModel *)model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
                
                cell.detailImage.image = image;
            });
        }
        
        if ([[SantaTracker shareInstance] matchSantaMotionSensors:model.modelId]) {
            cell.selectionImage.image = [UIImage imageNamed:@"RoleCheckedIcon"].invertColor;
        }
        else {
            cell.selectionImage.image = [UIImage imageNamed:@"RoleUncheckButton"].invertColor;
        }
    }
    else {
        NSDictionary *dic = self.devices[indexPath.row];
        
        cell.titleLabel.attributedText = [FontData getString:[dic[@"title"] uppercaseString]
                                                    withFont:FontDataTypeDeviceKeyfobSettingSchedueTitle];
        cell.descriptionLabel.attributedText = [FontData getString:dic[@"subtitle"]
                                                          withFont:FontDataType_MediumItalic_14_WhiteAlpha_NoSpace];
        
        cell.detailImage.image = [UIImage imageNamed:dic[@"icon"]];
        
        if ([[SantaTracker shareInstance] matchSantaMotionSensors:dic[@"title"]]) {
            cell.selectionImage.image = [UIImage imageNamed:@"RoleCheckedIcon"].invertColor;
        }
        else {
            cell.selectionImage.image = [UIImage imageNamed:@"RoleUncheckButton"].invertColor;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *selected = [[NSMutableArray alloc] initWithArray:[[SantaTracker shareInstance] getSantaMotionSensors]];
    
    DeviceModel *model = self.devices[indexPath.row];
    NSString *tag = @"";
    if ([model isKindOfClass:[DeviceModel class]]) {
        tag = model.modelId;
    }
    else {
        tag = ((NSDictionary *)model)[@"title"];
    }
    
    if ([[SantaTracker shareInstance] matchSantaMotionSensors:tag]) {
        [selected removeObject:tag];
    }
    else {
        [selected addObject:tag];
    }
    
    [[SantaTracker shareInstance] saveSantaMotionSensors:selected];
    
    [tableView reloadData];
}



@end
