//
//  CareActivityFullscreenViewController.m
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
#import "CareActivityFullscreenViewController.h"
#import "CareActivityCollectionViewCell.h"
#import "CareDeviceFilterCollectionViewCell.h"
#import "CareActivityManager.h"
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "CareSubsystemController.h"
#import "SubsystemsController.h"
#import "NSDate+Convert.h"
#import "UIColor+Convert.h"
#import "DeviceCapability.h"


#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"

#import "ArcusLabel.h"

#import <i2app-Swift.h>

@interface CareActivityFullscreenViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UICollectionView *deviceCollectionView;
@property (nonatomic, weak) IBOutlet UICollectionView *activityCollectionView;

@property (nonatomic, assign) ActivityGraphStyleType filterStyle;

@end

@implementation CareActivityFullscreenViewController

@dynamic filteredDevices;

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBackgroundView];
    [self configureFullscreenButton];

    self.deviceCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.activityCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;

    CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.view.transform = transform;
    
    [self configureFilterStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self moveActivityCollectionViewScrollPositionToCurrent];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UI Configuration

- (void)configureBackgroundView {
    [super configureBackgroundView];
    
    UIImage *image = [ArcusSettingsHomeImageHelper fetchHomeImage:CorneaHolder.shared.settings.currentPlace.modelId];

    CGSize rotatedSize = CGSizeMake([UIScreen mainScreen].bounds.size.height,
                                    [UIScreen mainScreen].bounds.size.width);
    image = [image scaleImageToFillSize:rotatedSize];
    image = [image applyLightEffect];

    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    self.navigationController.view.backgroundColor = self.view.backgroundColor;
    [self.view setNeedsLayout];
    [self.navigationController.view setNeedsLayout];
}

- (void)configureFullscreenButton {
    [self.fullScreenButton setImage:[UIImage imageNamed:@"CareMinIcon"]
                           forState:UIControlStateNormal];
    [self.fullScreenButton setImage:[[UIImage imageNamed:@"CareMinIcon"] invertColor]
                           forState:UIControlStateHighlighted];
}

- (void)moveActivityCollectionViewScrollPositionToCurrent {
    [self moveCollectionViewToEndPosition:self.activityCollectionView
                                 endIndex:[self indexOfUnitForCurrentTime]];
}

- (BOOL)deviceFilterIsContactSensor:(NSString *)deviceAddress {
    BOOL isContact = NO;
    
    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];
    isContact = ([device deviceType] == DeviceTypeContactSensor);
    
    return isContact;
}

- (void)configureFilterStyle {
    if ([self.filteredDevices count] == 1) {
        if ([self deviceFilterIsContactSensor:self.filteredDevices[0]]) {
            self.filterStyle = ActivityGraphStyleTypeEdgeTransparent;
        } else {
            self.filterStyle = ActivityGraphStyleTypeSolid;
        }
    } else {
        self.filterStyle = ActivityGraphStyleTypeSolidNoContinuous;
    }
}

#pragma mark - IBActions

- (IBAction)fullscreenButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Reload Methods

- (void)reloadData {
    [super reloadData];
}

- (void)reloadUserInterface {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityCollectionView reloadData];
        [self.deviceCollectionView reloadData];
        [self moveActivityCollectionViewScrollPositionToCurrent];
    });
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    NSInteger numberOfItems;
    
    if (collectionView == self.deviceCollectionView) {
        numberOfItems = [self.careDevicesArray count];
    } else if (collectionView == self.activityCollectionView) {
        numberOfItems = [self.careActivityUnits count];
    }
    else {
        numberOfItems = 0;
    }
    
    return numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    
    if (collectionView == self.deviceCollectionView) {
        cell = [self careDeviceSelectionCollectionViewCellForItemAtIndexPath:indexPath];
    } else if (collectionView == self.activityCollectionView) {
        cell = [self careActivityCollectionViewCellForItemAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CareActivityCollectionViewCell *)careActivityCollectionViewCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActivityCell";
    
    CareActivityCollectionViewCell *cell = [self.activityCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                                  forIndexPath:indexPath];
    
    CareActivityUnit *activityUnit = self.careActivityUnits[indexPath.row];
    if (activityUnit) {
        NSString *time = [activityUnit.startDate formatDateTimeStamp];
        
        cell.titleLabel.attributedText = [cell attributeTimeString:time];
        
        cell.graphView.graphStyle = self.filterStyle;
        
        [cell configureActivityGraphView:(NSArray <ActivityGraphViewUnitProtocol> *)activityUnit.unitIntervals];
    }
    
    return cell;
}

- (CareDeviceFilterCollectionViewCell *)careDeviceSelectionCollectionViewCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DeviceCell";
    
    CareDeviceFilterCollectionViewCell *cell = [self.deviceCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                                    forIndexPath:indexPath];
    BOOL isSelected = NO;
    
    NSString *deviceAddress = self.careDevicesArray[indexPath.row];
    if (deviceAddress) {
        UIImage *deviceImage = nil;
        NSString *deviceTitleString = nil;
        
        // Summary cell
        if (indexPath.row == 0) {
            // If no filter selected, set Summary to selected
            isSelected = ([self.filteredDevices count] > 1);
            deviceTitleString = @"Summary";
            deviceImage = [UIImage imageNamed:@"CareSummaryIcon"];
            
        } else {
            if ([self.filteredDevices count] == 1) {
                isSelected = [self.filteredDevices containsObject:deviceAddress];
            }
            DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];
            if (device) {
                deviceTitleString = [device name];
                deviceImage = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                          atSize:[UIScreen mainScreen].bounds.size
                                                                       withScale:[UIScreen mainScreen].scale];
                if (!deviceImage) {
                    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                                           withDevTypeId:[device devTypeHintToImageName]
                                         withPlaceHolder:nil
                                                 isLarge:NO
                                            isBlackStyle:NO].then(^(UIImage *image) {
                        cell.deviceImage.image = image;
                    });
                }
            }
        }
        
        if (deviceImage) {
            cell.deviceImage.image = deviceImage;
        }
        
        if (deviceTitleString) {
            [cell.descriptionLabel setText:deviceTitleString];
        }
    }
    [cell setSelected:isSelected];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat edgeInsets = 0;
    if (collectionView == self.deviceCollectionView) {
        CGFloat cellsWidth = ([self.careDevicesArray count] * 75.0f);
        if (cellsWidth <= collectionView.frame.size.width) {
            edgeInsets = (collectionView.frame.size.width - ([self.careDevicesArray count] * 75.0f)) / 2;
        }
    }
    
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75.0f, collectionView.frame.size.height);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.deviceCollectionView) {
        // Filtering by device in fullscreen does not use multiple devices.
        // So the array is reset to a single device upon selection.
        self.filteredDevices = (indexPath.row > 0 ) ? @[self.careDevicesArray[indexPath.row]] : self.careDevicesArray;
        [self configureFilterStyle];
        
        [self reloadData];
    }
}

@end
