//
//  KeyfobPairingViewController.m
//  i2app
//
//  Created by Arcus Team on 2/12/16.
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
#import "KeyfobPairingViewController.h"
#import "CommonCheckableImageCell.h"
#import "SimpleTableViewController.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"



#import "PersonController.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"

@interface KeyfobPairingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSMutableArray <Model *> *models;

@end

@implementation KeyfobPairingViewController {
    int     _selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeData];
    
    [self navBarWithBackButtonAndTitle:self.models[0].name];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundColorToLastNavigateColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];

    if ([DevicePairingManager sharedInstance].currentDevice.deviceType == DeviceTypeKeyFob) {
        [self.titleLabel styleSet:@"Who is going to use this Key Fob?" andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:YES space:NO]];
    }
    else {
        [self.titleLabel styleSet:@"Who is going to use this Pendant?" andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:YES space:NO]];
    }
    [self.subtitleLabel styleSet:@"Key fob assignement text" andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:YES space:NO alpha:YES]];
    [self.nextButton styleSet:@"Next" andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)initializeData {
    self.models = [NSMutableArray new];
    
    [self.models addObject:[DevicePairingManager sharedInstance].currentDevice];
    [self.models addObjectsFromArray:[[[CorneaHolder shared] modelCache] fetchModels:[PersonCapability namespace]]];
    
    if (self.models.count == 1) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSArray *persons) {
                
                [self.models addObjectsFromArray:persons];
            });
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_selectedIndex < self.models.count && _selectedIndex > -1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
        CommonCheckableImageCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (tableCell) {
            [tableCell setCheck:YES styleBlack:YES];
        }
    }
}
#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
    Model *model = self.models[indexPath.row];
    
    [cell setCheck:NO styleBlack:YES];
    [cell setOnClickEvent:@selector(onCheckEnable:withModel:) owner:self withObj:model];
    [cell displayArrow:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SimpleTableCell *tableCell = [SimpleTableCell create:cell withOwner:self andPressSelector:nil];
    [tableCell setDataObject:model];
    
    if ([model isKindOfClass:[PersonModel class]]) {
        PersonModel *person = (PersonModel *)model;
        [cell setIcon:nil withTitle:person.fullName.uppercaseString subtitle:person.getSubtitle andSide:nil withBlackFont:YES];

        UIImage *cachedImage = ((PersonModel *)model).image;
        if (cachedImage) {
            cachedImage = [cachedImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(30, 30)];
            cachedImage = [cachedImage roundCornerImageWithsize:CGSizeMake(30, 30)];
        }
        UIImage *image = cachedImage != nil ? cachedImage : [[UIImage imageNamed:@"userIcon"] invertColor];
        if (image) {
            [cell setIcon:image];
        }
    }
    else {
        [cell setIcon:nil withTitle:model.name.uppercaseString subtitle:@"Unassigned" andSide:nil withBlackFont:YES];

        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:(DeviceModel *)model] withDevTypeId:[((DeviceModel *)model) devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:YES].then(^(UIImage *image) {
            if (image) {
                [cell setIcon:image];
            }
        });
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onCheckEnable:(CommonCheckableImageCell *)cell withModel:(Model *)model {
    for (int row = 0; row < [self.tableView numberOfRowsInSection:0]; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        CommonCheckableImageCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (tableCell == cell) {
            _selectedIndex = row;
        }
        [tableCell setCheck:NO styleBlack:YES];
    }
    [cell setCheck:![cell getChecked] styleBlack:YES];
}

- (IBAction)onClickNext:(id)sender {
    if (_selectedIndex == 0) {
        [self unassignButton];
    }
    else {
        [self completeSelection:(PersonModel *)self.models[_selectedIndex]];
    }
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}


- (void)unassignButton {
    [self createGif];
    [[DevicePairingManager sharedInstance].currentDevice unassignPerson:^{
        [self.tableView reloadData];
        [self hideGif];
    } failedBlock:^{
        [self hideGif];
        [self displayGenericErrorMessage];
    }];
}

- (void)completeSelection:(PersonModel *)value {
    if (value) {
        [self createGif];
        [[DevicePairingManager sharedInstance].currentDevice assignPerson:value completeBlock:^{
            [self.tableView reloadData];
            [self hideGif];
        } failedBlock:^{
            [self hideGif];
            [self displayGenericErrorMessage];
        }];
    }
}

@end
