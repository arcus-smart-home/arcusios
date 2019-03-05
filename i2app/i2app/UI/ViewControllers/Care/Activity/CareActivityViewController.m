//
//  CareActivityViewController.m
//  i2app
//
//  Created by Arcus Team on 1/21/16.
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
#import "CareActivityViewController.h"
#import "ArcusModalSelectionViewController.h"
#import "ArcusModalSelectionModel.h"
#import "CareActivityFullscreenViewController.h"
#import "CareActivityCollectionViewCell.h"
#import "CareActivityTableViewCell.h"
#import "ArcusTableViewSectionHeader.h"
#import "CareActivityManager.h"
#import "CareActivitySection.h"
#import "CareActivityUnit.h"
#import "CareActivityInterval.h"
#import "CareActivityEventInfo.h"
#import "CareSubsystemController.h"
#import "NSDate+Convert.h"
#import "DeviceCapability.h"


#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"

@interface CareActivityViewController () <UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, ArcusModalSelectionDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *activityCollectionView;
@property (nonatomic, weak) IBOutlet UITableView *activityTableView;
@property (nonatomic, weak) IBOutlet ArcusTableViewSectionHeader *tableHeaderView;

@property (nonatomic, strong) NSArray <CareActivityEventInfo *> *careActivityEvents;

@end

@implementation CareActivityViewController

NSString *const kCareActivityImageCachePrefix = @"CareActivityVC:";

#pragma mark - View LifeCycle

+ (CareActivityViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Care" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([CareActivityViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    [self fetchActivityListData:(^(BOOL refresh){
        if (refresh) {
            [self reloadUserInterface];
        }
    })];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureTableViewHeader];
    [self configureDateButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isMovingToParentViewController) {
        [self moveActivityCollectionViewScrollPositionToCurrent];
    }
}

#pragma mark - UI Configuration

- (void)configureBackgroundView {
    [super configureBackgroundView];
    
    self.activityTableView.backgroundColor = [UIColor clearColor];
    self.activityTableView.backgroundView = nil;
}

- (void)configureTableViewHeader {
    NSInteger filteredCount = [self.filteredDevices count];
    NSInteger maxDeviceCount = [self.careDevicesArray count] - 1; // Need to account for select all entry.
    
    NSString *title = [NSString stringWithFormat:@"%i of %i Devices", (int)filteredCount, (int)maxDeviceCount];
    
    NSDictionary *fontDictionary = [FontData getFontWithSize:14.0f
                                                        bold:YES
                                                     kerning:0.0f
                                                       color:[UIColor whiteColor]];
    
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:fontDictionary];
    
    self.tableHeaderView.titleLabel.attributedText = titleAttributedString;
    
    NSAttributedString *descAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Filter", @"")
                                                                               attributes:fontDictionary];
    
    self.tableHeaderView.descriptionLabel.attributedText = descAttributedString;
}

- (void)moveActivityCollectionViewScrollPositionToCurrent {
    [self moveCollectionViewToEndPosition:self.activityCollectionView
                                 endIndex:[self indexOfUnitForCurrentTime]];
}

#pragma mark - Getters & Setters

- (NSArray *)careActivityEvents {
        // Band-aid for ITWO-5147
    NSMutableArray <CareActivityEventInfo *> *mutableEventInfo = [[NSMutableArray alloc] init];
    
    for (CareActivityEventInfo *event in self.careActivitySection.activityEvents) {
        if ([[event.eventDate toDay] compare:[self.dateFilter toDay]] == NSOrderedSame ) {
            [mutableEventInfo addObject:event];
        }
    }
    return _careActivityEvents = (NSArray <CareActivityEventInfo *> *)[NSArray arrayWithArray:mutableEventInfo];
}

- (void)setFilteredDevicesWithIndexArray:(NSArray *)selectedIndexes {
    NSMutableArray *mutableFilterDevices = [[NSMutableArray alloc] init];
    
    for (ArcusModalSelectionModel *selectionModel in selectedIndexes) {
        if (selectionModel.deviceAddress) {
            if ([self.careDevicesArray containsObject:selectionModel.deviceAddress]) {
                [mutableFilterDevices addObject:selectionModel.deviceAddress];
            }
        }
    }
    
    self.filteredDevices = [NSArray arrayWithArray:mutableFilterDevices];
}

#pragma mark - Data I/O

- (void)fetchActivityListData:(void (^)(BOOL reload))completion {
    [super fetchActivityListData:(^(BOOL reload) {
        [self fetchActivityListDetails:^(BOOL listReload) {
            if (completion) {
                completion(reload);
            }
        }];
    })];
}

- (void)fetchActivityListDetails:(void (^)(BOOL listReload))completion {
    if (![self.careActivitySection.detailsToken isKindOfClass:[NSNull class]]) {
        NSDate *tokenDate = [NSDate dateFromTimeUuid:self.careActivitySection.detailsToken];
        if ([tokenDate compare:self.careActivitySection.startDate] != NSOrderedAscending) {
            [self.activityManager fetchActivityDetailForSection:self.careActivitySection
                                                     completion:^(CareActivitySection *section, NSArray *evnts) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             self.careActivitySection = section;
                                                             if (completion) {
                                                                 completion(YES);
                                                             }
                                                         });
                                                     }];
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } else {
        if (completion) {
            completion(YES);
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.careActivityUnits count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    CareActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                                     forIndexPath:indexPath];

    CareActivityUnit *activityUnit = self.careActivityUnits[indexPath.row];
    
    if (activityUnit) {
        NSString *time = [activityUnit.startDate formatDateTimeStamp];
        
        cell.titleLabel.attributedText = [cell attributeTimeString:time];
        
        cell.graphView.graphStyle = ActivityGraphUnitTypeSolid;
        [cell configureActivityGraphView:(NSArray <ActivityGraphViewUnitProtocol> *)activityUnit.unitIntervals];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.careActivityEvents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    CareActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[CareActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    CareActivityEventInfo *activityEvent = self.careActivityEvents[indexPath.row];
    
    NSString *time = [activityEvent.eventDate formatDateTimeStamp];
    NSString *title = activityEvent.eventTitle;
    NSString *description = activityEvent.eventDescriptionLong;
    
    NSDictionary *timeFontDictionary = [FontData getFontWithSize:12.0f
                                                            bold:NO
                                                         kerning:0.0f
                                                           color:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
    NSAttributedString *timeAttributedString = nil;
    if(time == nil) {
        time = @"error retrieving time";
        DDLogInfo(@"error retrieving activityEvent.eventDate: %@", activityEvent.eventDate);
    }
    
    timeAttributedString = [[NSAttributedString alloc] initWithString:time
                                                           attributes:timeFontDictionary];
    cell.timeLabel.attributedText = timeAttributedString;
    
    NSDictionary *titleFontDictionary = [FontData getFontWithSize:14.0f
                                                             bold:YES
                                                          kerning:2.0f
                                                            color:[UIColor whiteColor]];
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:[title
                                                                                            uppercaseString]
                                                                                attributes:titleFontDictionary];
    cell.titleLabel.attributedText = titleAttributedString;
    
    NSDictionary *descFontDictionary = [FontData getItalicFontWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]
                                                                   size:14.0f
                                                                kerning:0.0f];
    NSAttributedString *descAttributedString = [[NSAttributedString alloc] initWithString:description
                                                                               attributes:descFontDictionary];
    
    cell.descriptionLabel.attributedText = descAttributedString;
    
    DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:activityEvent.deviceAddress];
    if (device) {
        UIImage *userCustomDeviceImage = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                                    atSize:[UIScreen mainScreen].bounds.size
                                                                                 withScale:[UIScreen mainScreen].scale];
        
        UIImage *cachedDefaultDeviceImage = nil;
        NSString *cachedDefaultImageHash = [kCareActivityImageCachePrefix stringByAppendingString:device.modelId];

        if (userCustomDeviceImage) {
            cell.deviceImageView.image = userCustomDeviceImage;
        } else  if ((cachedDefaultDeviceImage = [[AKFileManager defaultManager] cachedImageForHash:cachedDefaultImageHash
                                                                                           atSize:[UIScreen mainScreen].bounds.size
                                                                                        withScale:[UIScreen mainScreen].scale])) {
            cell.deviceImageView.image = cachedDefaultDeviceImage;
        } else {
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                                   withDevTypeId:[device devTypeHintToImageName]
                                 withPlaceHolder:nil
                                         isLarge:NO
                                    isBlackStyle:NO].then(^(UIImage *image) {
                cell.deviceImageView.image = image;
                [[AKFileManager defaultManager] cacheImage:image forHash:cachedDefaultImageHash];
            });
        }
    }
    cell.deviceImageView.layer.cornerRadius = cell.deviceImageView.bounds.size.width/2;

    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.careActivityEvents count] - 1) {
        [self fetchActivityListDetails:(^(BOOL refresh) {
            if (refresh && indexPath.row < [self.careActivitySection.activityEvents count] - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                });
            }
        })];
    }
}

#pragma mark - ArcusModalSelection Convienence Methods

- (NSArray *)deviceFilterSelectionArray {
    NSMutableArray *mutableSelectionInfo = [[NSMutableArray alloc] init];
    
    BOOL setSelectAll = YES;
    ArcusModalSelectionModel *selectAllModel;
    
    for (NSString *deviceAddress in self.careDevicesArray) {
        ArcusModalSelectionModel *selectionModel;
        
        if ([deviceAddress isEqualToString:@"Summary"]) {
            selectionModel = [[ArcusModalSelectionModel alloc] init];
            selectionModel.title = @"ALL DEVICES";
            selectionModel.itemDescription = @"All Care Devices";
            selectionModel.image = [[UIImage imageNamed:@"DevicesIcon"] invertColor];;
            selectionModel.isSelectAll = YES;
            
            selectAllModel = selectionModel;
        } else {
            DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:deviceAddress];
            if (device) {
                selectionModel = [ArcusModalSelectionModel selectionModelForDevice:device];
            }
            selectionModel.isSelected = [self.filteredDevices containsObject:deviceAddress];
            
            // If any single device is not selected, then we do not need to set the select all isSelected.
            if (!selectionModel.isSelected) {
                setSelectAll = NO;
            }
            
            if (selectionModel) {
                [mutableSelectionInfo addObject:selectionModel];
            }
        }
    }
    
    mutableSelectionInfo = [NSMutableArray arrayWithArray:[mutableSelectionInfo sortedArrayUsingComparator:^(ArcusModalSelectionModel *a, ArcusModalSelectionModel *b) {
        return [a.title caseInsensitiveCompare:b.title];
    }]];
    if (selectAllModel) {
        selectAllModel.isSelected = setSelectAll;
        [mutableSelectionInfo insertObject:selectAllModel atIndex:0];
    }
    return [NSArray arrayWithArray:mutableSelectionInfo];
}

- (void)reloadData {
    [super reloadData];
}


- (void)reloadUserInterface {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityCollectionView reloadData];
        [self moveActivityCollectionViewScrollPositionToCurrent];
        
        [self.activityTableView reloadData];
        
        if ([self.activityTableView numberOfRowsInSection:0] > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                        inSection:0];
            [self.activityTableView scrollToRowAtIndexPath:indexPath
                                          atScrollPosition:UITableViewScrollPositionTop
                                                  animated:NO];
        }
    });
}

#pragma mark - ArcusModalSelectionDelegate

- (void)modalSelectionController:(UIViewController *)selectionController
    didDismissWithSelectedModels:(NSArray<ArcusModalSelectionModel *> *)selectedIndexes {
    
    [self setFilteredDevicesWithIndexArray:selectedIndexes];
    [self updateCareDevices:self.filteredDevices];
    [self reloadData];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ActivityFilterMenuSegue"]) {
        ArcusModalSelectionViewController *filterSelectionViewController = (ArcusModalSelectionViewController *)segue.destinationViewController;
        filterSelectionViewController.delegate = self;
        filterSelectionViewController.allowMultipleSelection = YES;
        filterSelectionViewController.selectionArray = [self deviceFilterSelectionArray];
    } else if ([segue.identifier isEqualToString:@"ActivityFullscreenModalSegue"]) {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        CareActivityFullscreenViewController *activityFullscreenViewController = (CareActivityFullscreenViewController *)navigationController.topViewController;
        activityFullscreenViewController.dateFilter = self.dateFilter;
        activityFullscreenViewController.activityManager = self.activityManager;
        activityFullscreenViewController.activityManager.delegate = activityFullscreenViewController;
        [activityFullscreenViewController fetchActivityListData:(^(BOOL refresh){
            if (refresh) {
                [activityFullscreenViewController reloadUserInterface];
            }
        })];
    }
}

@end
