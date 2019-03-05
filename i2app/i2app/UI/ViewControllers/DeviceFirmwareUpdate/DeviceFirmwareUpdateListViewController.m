//
//  DeviceFirmwareUpdateListViewController.m
//  i2app
//
//  Created by Arcus Team on 10/12/15.
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
#import "DeviceFirmwareUpdateListViewController.h"
#import "DeviceFirmwareUpdateTableViewCell.h"
#import "AKFileManager.h"
#import "DeviceManager.h"
#import "DeviceOtaCapability.h"
#import "DeviceCapability.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "ImagePaths.h"
#import "AKFileManager.h"


#import "DeviceOtaCapability.h"

@interface DeviceFirmwareUpdateListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *headerPrimaryLabel;
@property (nonatomic, strong) IBOutlet UILabel *headerSecondaryLabel;
@property (nonatomic, strong) IBOutlet UITableView *firmwareUpdateTableView;

@property (nonatomic, strong) NSArray *firmwareUpdatesArray;
@property (nonatomic, strong) NSMutableArray *progressValueArray;
@property (nonatomic, assign) BOOL firstLoad;

@end

@implementation DeviceFirmwareUpdateListViewController

#pragma mark - View LifeCycle

+ (DeviceFirmwareUpdateListViewController *)create {
    DeviceFirmwareUpdateListViewController *viewController = [[UIStoryboard storyboardWithName:@"DeviceFirmwareUpdate" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceFirmwareUpdateListViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavigationBar];
    [self configureBackground];
    [self configureHeaderLabels];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOTAStatusNotificationReceived:)
                                                 name:[Model attributeChangedNotification:kAttrDeviceOtaStatus]
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOTAProgressNotificationReceived:)
                                                 name:[DeviceModel updateModelNotificationName]
                                               object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI Configuration

- (void)configureNavigationBar {
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
}

- (void)configureBackground {
    self.firmwareUpdateTableView.backgroundColor = [UIColor clearColor];
    self.firmwareUpdateTableView.backgroundView = nil;
    self.firmwareUpdateTableView.separatorColor = [UIColor clearColor];
    
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayLightLevel];
}

- (void)configureHeaderLabels {
    // Set Primary Label
    NSString *headerPrimaryString = NSLocalizedString(@"Downloading", nil);
    NSAttributedString *headerPrimaryText = [[NSAttributedString alloc] initWithString:headerPrimaryString.uppercaseString
                                                                            attributes:[FontData getBlackFontWithSize:18.0f
                                                                                                                 bold:NO
                                                                                                              kerning:0.0f]];
    [self.headerPrimaryLabel setAttributedText:headerPrimaryText];
    
    // Set Secondary Label
    NSString *headerSecondaryString = NSLocalizedString(@"Your device(s) are downloading \nthe most up-to-date firmware, and will be ready to \nuse in 5-15 mins depending on \nthe device type.", nil);
    NSAttributedString *headerSecondaryText = [[NSAttributedString alloc] initWithString:headerSecondaryString
                                                                              attributes:[FontData getBlackFontWithSize:13.0f
                                                                                                                   bold:NO
                                                                                                                kerning:0.0f]];
    [self.headerSecondaryLabel setAttributedText:headerSecondaryText];
}

#pragma mark - Getters & Setters

- (NSArray *)firmwareUpdatesArray {
    if (!_firmwareUpdatesArray) {
        _firmwareUpdatesArray = [[DeviceManager instance] devicesUndergoingFirmwareUpdate];
    }
    return _firmwareUpdatesArray;
}

#pragma mark - Change Event Notification Handling
- (void)deviceOTAStatusNotificationReceived:(NSNotification *)notification {
    NSString *address = [DeviceModel addressForId:[notification.userInfo[@"Model"] modelId]];
    DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    
    if (deviceModel == nil) {
        return;
    }
    
    NSInteger index = [self.firmwareUpdatesArray indexOfObjectIdenticalTo:deviceModel];
    
    if (index != NSNotFound) {
        [self processUpdateFirmwareResultForDeviceAtIndex:index notification:notification];
    }
    else {
        [self processAddUpdateFirmwareDevice:deviceModel notification:notification];
    }
    
}

- (void)processUpdateFirmwareResultForDeviceAtIndex:(NSInteger)index notification:(NSNotification *)notification {
    if ([notification.object[kAttrDeviceOtaStatus] isEqualToString:kEnumDeviceOtaStatusCOMPLETED]) {
        [self didFinishUpradeForDeviceIndex:index withResult:YES];
    }
    else if ([notification.object[kAttrDeviceOtaStatus] isEqualToString:kEnumDeviceOtaStatusFAILED]) {
        [self didFinishUpradeForDeviceIndex:index withResult:NO];
    }
}

- (void)processAddUpdateFirmwareDevice:(DeviceModel *)deviceModel notification:(NSNotification *)notification {
    if ([notification.object[kAttrDeviceOtaStatus] isEqualToString:kEnumDeviceOtaStatusINPROGRESS]) {
        NSMutableArray *mutableFirmwareUpdatesArray = [NSMutableArray arrayWithArray:self.firmwareUpdatesArray];
        [mutableFirmwareUpdatesArray addObject:deviceModel];
        
        self.firmwareUpdatesArray = mutableFirmwareUpdatesArray;
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.firmwareUpdateTableView reloadData];
        });
    }
    
}

- (void)didFinishUpradeForDeviceIndex:(NSInteger) index withResult:(BOOL)result  {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self firmwareUpdateForIndex:index didFinishSuccessfully:result];
    });
}

- (void)deviceOTAProgressNotificationReceived:(NSNotification *)notification {
    //updateModelNotificationName
    if (notification == nil) {
        return;
    }
    // Find Device Progressing
    DeviceModel *deviceModel = notification.object;
    
    if (deviceModel == nil) {
        return;
    }
    
    NSInteger index = [self.firmwareUpdatesArray indexOfObjectIdenticalTo:deviceModel];
    
    if (index != NSNotFound) {
        // Check Status
        if ([[DeviceOtaCapability getStatusFromModel:deviceModel] isEqualToString:kEnumDeviceOtaStatusINPROGRESS]) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self firmwareUpdateForIndex:index updateProgress:[DeviceOtaCapability getProgressPercentFromModel:deviceModel]];
            });
        }
        else if ([[DeviceOtaCapability getStatusFromModel:deviceModel] isEqualToString:kEnumDeviceOtaStatusCOMPLETED]) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self firmwareUpdateForIndex:index updateProgress:1];
            });

        }
    }
}

- (void)updateFirmwareUpdatesArray:(NSInteger)index {
    if (index >= 0 && index < [self.firmwareUpdatesArray count]) {
        NSMutableArray *mutableFirmwareUpdatesArray = [NSMutableArray arrayWithArray:self.firmwareUpdatesArray];
        [mutableFirmwareUpdatesArray removeObjectAtIndex:index];
        
        self.firmwareUpdatesArray = mutableFirmwareUpdatesArray;
    }
}

#pragma mark - Update Status Handling

- (void)firmwareUpdateForIndex:(NSInteger)index updateProgress:(float)progress {
    DeviceFirmwareUpdateTableViewCell *cell = (DeviceFirmwareUpdateTableViewCell*)[self.firmwareUpdateTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (cell) {
        [cell.updateProgressBar setProgress:progress];
        [cell.updateProgressBar setNeedsDisplay];
    }
}

- (void)firmwareUpdateForIndex:(NSInteger)index didFinishSuccessfully:(BOOL)success {
    if (success) {
        DeviceFirmwareUpdateTableViewCell *cell = (DeviceFirmwareUpdateTableViewCell*)[self.firmwareUpdateTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (cell) {
            // Progress to 1.0
            [cell.updateProgressBar setProgress:1.0f];
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 // Animate Check Mark
                                 cell.accessoryImage.alpha = 1.0f;
                             }
                             completion:^ (BOOL finished) {
                                // [self.progressValueArray removeObjectAtIndex:index];
                                [self updateFirmwareUpdatesArray:index];
                                 // Fade Cell Out.
                                 [self.firmwareUpdateTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                 
                                 if ([self.firmwareUpdatesArray count] == 0) {
                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                 }
                             }];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.firmwareUpdatesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FirmwareUpdateCell";
    
    DeviceFirmwareUpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[DeviceFirmwareUpdateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:CellIdentifier];
    }
    
    DeviceModel *device = self.firmwareUpdatesArray[indexPath.row];
    
    [self configureCellImage:cell forDevice:device];
    [self configurePrimaryLabelCell:cell forDevice:device];
    [self configureSubTitleLabelCell:cell forDevice:device];
    [self configureProcessBarCell:cell indexPath:indexPath];

    return cell;
}

#pragma mark - configure cell 

- (void)configureCellImage:(DeviceFirmwareUpdateTableViewCell *)cell forDevice:(DeviceModel *)device {
    // Set Image
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    
    if (!image) {
        NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                cell.detailImage.image = image;
            }
        }];
    }
    else {
        NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
        [cell.detailImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"PlaceholderWhite"].invertColor completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.detailImage.layer.borderWidth = 0.0f;
            image = [image invertColor];
            [cell.detailImage setImage:image];
        }];
    }

}

- (void)configureProcessBarCell:(DeviceFirmwareUpdateTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    DeviceModel *device = (DeviceModel *) self.firmwareUpdatesArray[indexPath.row];
    if ([[DeviceOtaCapability getStatusFromModel:device] isEqualToString:kEnumDeviceOtaStatusINPROGRESS]) {
        [cell.updateProgressBar setProgress:[DeviceOtaCapability getProgressPercentFromModel:device]];
        cell.accessoryImage.alpha = 0.0f;
    }
    else {
        cell.accessoryImage.alpha = 1.0f;
    }
}

- (void)configurePrimaryLabelCell:(DeviceFirmwareUpdateTableViewCell *)cell forDevice:(DeviceModel *)device {
    
    NSString *title = [device name];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:title.uppercaseString
                                                                    attributes:[FontData getBlackFontWithSize:12.0f
                                                                                                         bold:NO
                                                                                                      kerning:2.0f]];
    [cell.titleLabel setAttributedText:titleText];
}

- (void)configureSubTitleLabelCell:(DeviceFirmwareUpdateTableViewCell *)cell forDevice:(DeviceModel *)device {
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]
                                                                 size:14.0
                                                              kerning:0.0];
    
    NSString *description = [DeviceCapability getVendorFromModel:device];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    

}

@end
