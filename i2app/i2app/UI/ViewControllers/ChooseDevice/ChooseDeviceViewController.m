//
//  ChooseDeviceViewController.m
//  i2app
//
//  Created by Arcus Team on 5/7/15.
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
#import "ChooseDeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "DeviceBrandTableViewCell.h"
#import "SearchDeviceViewController.h"
#import "DeviceListViewController.h"
#import "ProductCatalogController.h"
#import "NSArray+GroupBy.h"
#import "OrderedDictionary.h"
#import "DeviceController.h"
#import "HubCapability.h"
#import "PromiseKit/Promise.h"
#import "UIImageView+WebCache.h"
#import "FoundDevicesViewController.h"
#import "AddDeviceViewController.h"
#import "ImagePaths.h"
#import "DevicePairingManager.h"
#import "UIImage+ScaleSize.h"
#import "ProductCapability.h"
#import <i2app-Swift.h>

NSString *const kInPairingModeStr = @"In pairing mode";
NSString *const kStoppedPairingModeStr = @"Stoped pairing mode";

@interface ChooseDeviceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) OrderedDictionary *categoriesDictionary;
@property (nonatomic, strong) OrderedDictionary *brandsDictionary;

@property (nonatomic, strong) OrderedDictionary *currentGroupsDictionary;

@property (weak, nonatomic) IBOutlet UILabel *pairingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookingLabel;

@property (nonatomic, assign) BOOL filterHubRequiredDevices;
@property (nonatomic, strong) NSArray *hublessDevices;

@property (nonatomic, weak) IBOutlet UIImageView *hubImage;


- (void)categoryPressed:(id)sender;
- (void)brandPressed:(id)sender;

- (void)switchToGroup:(GroupByType)groupType;

@end

@implementation ChooseDeviceViewController {
    GroupByType     _selectedGroupType;
    UIButton        *_catButton;
    UIButton        *_brandButton;
    NSArray         *_sortedKeys;
    BOOL            _isCategory;
}


+ (ChooseDeviceViewController *)create {
    return [[UIStoryboard storyboardWithName:@"ChooseDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

+ (ChooseDeviceViewController *)create:(BOOL)filterHubBasedDevices {
    ChooseDeviceViewController *chooseDeviceViewController = [ChooseDeviceViewController create];
    chooseDeviceViewController.filterHubRequiredDevices = filterHubBasedDevices;

    return chooseDeviceViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Add a Device", nil) rightButtonImageName:@"SearchButton" rightButtonSelector:@selector(search:)];
    
    // Sometimes, this view controller is created over Dashboard, and will not have the parent background color
    [self setBackgroundColorToDashboardColor];
  
    // Special case: No dashbaord background color available
    if (CGColorEqualToColor(self.navigationController.view.backgroundColor.CGColor, [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f].CGColor)) {
        self.navigationController.view.backgroundColor = nil;
    }
  
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    self.topBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    
    self.tableView.separatorColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    _brandButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 110, 15, 100, 20)];
    [_brandButton addTarget:self action:@selector(brandPressed:) forControlEvents:UIControlEventTouchUpInside];
    _catButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 10, 15, 100, 20)];
    [_catButton addTarget:self action:@selector(categoryPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabels:) name:kUpdateUIDeviceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForWifiOnly:) name:@"ShowWifiBasedDevices" object:nil];
    
    _selectedGroupType = GroupByTypeByBrand;
    [self buttonSelectedWithIndex:_selectedGroupType];

    // Pre-cache categories to prevent delay when user clicks category "tab"
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [ProductCatalogController getCategoriesOnModel].then(^(NSDictionary *attributes) {
            _categoriesDictionary = attributes[@"counts"];
        });
    });
                   
    [[DevicePairingManager sharedInstance] initializePairingProcess];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[DevicePairingManager sharedInstance] startHubPairing:NO].then(^ {
            [self changeLabels:self];
        });
    });
}

- (void)fetchHublessDevices:(void (^ __nullable)(void))completion; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [ProductCatalogController getProductModels].then(^(NSArray *productModels) {
            NSMutableArray *hublessProducts = [[NSMutableArray alloc] init];
            for (ProductModel *product in productModels) {
                if (!product.hubRequired) {
                    [hublessProducts addObject:product];
                }
            }
            self.hublessDevices = hublessProducts;
            if (completion) {
                completion();
            }
        });
    });
}

- (void)refreshForWifiOnly:(NSNotification *)notification {
    self.filterHubRequiredDevices = YES;
    self.categoriesDictionary = nil;
    self.brandsDictionary = nil;

    _selectedGroupType = GroupByTypeByBrand;
    [self buttonSelectedWithIndex:_selectedGroupType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        // Stop Pairing Mode
        [[DevicePairingManager sharedInstance] stopHubPairing];
        [[DevicePairingManager sharedInstance] pairingProcessDone];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Stop Pairing Mode
    [[DevicePairingManager sharedInstance] stopHubPairing];
    [[DevicePairingManager sharedInstance] pairingProcessDone];
}


- (void)switchToGroup:(GroupByType)groupType {
    if (groupType == GroupByTypeByCategory) {
        _isCategory = YES;

        NSDictionary *categories = nil;
        if (self.filterHubRequiredDevices) {
            categories = [self filterCategoriesForHublessProducts:self.categoriesDictionary];
        } else {
            categories = self.categoriesDictionary;
        }

        NSArray *keys = [categories allKeys];
        keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        OrderedDictionary *groupsDictionary = [[OrderedDictionary alloc] initWithCapacity:keys.count];
        for (NSString *key in keys) {
            [groupsDictionary setObject:categories[key] forKey:key];
        }
        
        _currentGroupsDictionary = groupsDictionary;
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    else {
        _isCategory = NO;

        if (self.filterHubRequiredDevices) {
            NSDictionary *brands = [self filterBrandsForHublessProducts:self.brandsDictionary];
            NSArray *keys = [brands allKeys];
            keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

            OrderedDictionary *groupsDictionary = [[OrderedDictionary alloc] initWithCapacity:keys.count];
            for (NSString *key in keys) {
                [groupsDictionary setObject:brands[key] forKey:key];
            }
            _currentGroupsDictionary = groupsDictionary;
        } else {
            _currentGroupsDictionary = self.brandsDictionary;
        }

        _sortedKeys = [self.currentGroupsDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *a,  NSString *b) {
            
            if ([a containsString:@"Arcus"] && [b containsString:@"Arcus"] ) {
                return NSOrderedSame;
            }
            
            if ([a containsString:@"Arcus"]) {
                return NSOrderedAscending;
            }
            if ([b containsString:@"Arcus"]) {
                return NSOrderedDescending;
            }
            
            return [a caseInsensitiveCompare:b];
        }];
        
        self.tableView.rowHeight = 67.0f;
    }
    
    [self.tableView reloadData];
    [self switchButtonBackground];
}

- (NSDictionary *)filterCategoriesForHublessProducts:(NSDictionary *)categories {
    NSMutableDictionary *mutableFilteredCategories = [[NSMutableDictionary alloc] init];
    for (ProductModel *product in self.hublessDevices) {
        for (NSString *category in product.categories) {
            if ([categories.allKeys containsObject:category]) {
                if ([mutableFilteredCategories.allKeys containsObject:category]) {
                    NSNumber *existingCount = [mutableFilteredCategories objectForKey:category];
                    existingCount = @([existingCount intValue] + 1);
                    [mutableFilteredCategories setObject:existingCount forKey:category];
                } else {
                    [mutableFilteredCategories setObject:@(1) forKey:category];
                }
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:mutableFilteredCategories];
}

- (NSDictionary *)filterBrandsForHublessProducts:(NSDictionary *)brands {
    NSMutableDictionary *mutableFilteredBrands = [[NSMutableDictionary alloc] init];
    for (ProductModel *product in self.hublessDevices) {
        if (![ProductCapability getCanBrowseFromModel:product]) {
            continue;
        }
        if ([brands.allKeys containsObject:product.vendorName]) {
            if ([mutableFilteredBrands.allKeys containsObject:product.vendorName]) {
                NSNumber *existingCount = [mutableFilteredBrands objectForKey:product.vendorName];
                existingCount = @([existingCount intValue] + 1);
                [mutableFilteredBrands setObject:existingCount forKey:product.vendorName];
            } else {
                [mutableFilteredBrands setObject:@(1) forKey:product.vendorName];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:mutableFilteredBrands];
}

- (void)switchButtonBackground {
    if (_isCategory == YES) {
        [_catButton setAttributedTitle:[FontData getString:[@"category" uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
        [_brandButton setAttributedTitle:[FontData getString:[@"Brand" uppercaseString] withFont:FontDataTypeChooseUnselected] forState:UIControlStateNormal];
    }
    else {
        [_catButton setAttributedTitle:[FontData getString:[@"category" uppercaseString] withFont:FontDataTypeChooseUnselected] forState:UIControlStateNormal];
        [_brandButton setAttributedTitle:[FontData getString:[@"Brand" uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
    }
}

- (void)buttonSelectedWithIndex:(GroupByType) groupType {
    if (groupType == GroupByTypeByCategory) {
        if (self.categoriesDictionary.count > 0) {
            [self switchToGroup:groupType];
        }
        else {
            // Categories
            if (_categoriesDictionary.count == 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [ProductCatalogController getCategoriesOnModel].then(^(NSDictionary *attributes) {
                        _categoriesDictionary = attributes[@"counts"];
                        if (self.filterHubRequiredDevices) {
                            if (!self.hublessDevices) {
                                [self fetchHublessDevices:^ {
                                    [self switchToGroup:groupType];
                                }];
                            } else {
                                [self switchToGroup:groupType];
                            }
                        } else {
                            [self switchToGroup:groupType];
                        }
                    }).catch(^(NSError *error) {
                        [self displayGenericErrorMessageWithMessage:[NSString stringWithFormat:@"getCategoriesOnModel: %@", error.localizedDescription]];
                    });
                });
            }
            else {
                [self switchToGroup:groupType];
            }
        }
    }
    
    if (groupType == GroupByTypeByBrand) {
        if (self.brandsDictionary.count > 0) {
            [self switchToGroup:groupType];
        }
        else {
            // Brands
            if (_brandsDictionary.count == 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    [ProductCatalogController getBrandsOnModel].then(^(NSDictionary *attributes) {
                        _brandsDictionary = attributes[@"counts"];
                        if (self.filterHubRequiredDevices) {
                            if (!self.hublessDevices) {
                                [self fetchHublessDevices:^ {
                                    [self switchToGroup:groupType];
                                }];
                            } else {
                                [self switchToGroup:groupType];
                            }
                        } else {
                            [self switchToGroup:groupType];
                        }
                    }).catch(^(NSError *error) {
                        [self displayGenericErrorMessageWithMessage:[NSString stringWithFormat:@"getBrandsOnModel: %@", error.localizedDescription]];
                    });
                });
            }
            else {
                [self switchToGroup:groupType];
            }
        }
    }
}

- (NSDictionary *)imageArrayToDictionary:(NSArray *)imagesArray {
    NSMutableDictionary *imagesDict = [[NSMutableDictionary alloc] initWithCapacity:imagesArray.count];
    
    for (NSDictionary *dict in imagesArray) {
        [imagesDict setObject:dict[@"image"] forKey:dict[@"name"]];
    }
    return imagesDict.copy;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentGroupsDictionary.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = [UIColor clearColor];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 44, tableView.frame.size.width, 1 / UIScreen.mainScreen.scale)];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [headerView addSubview:line];
    
    [headerView addSubview:_brandButton];
    [headerView addSubview:_catButton];
    
    self.tableView.tableHeaderView = headerView;
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellIdentifier = _isCategory ? @"cell" : @"brandCell";
    UITableViewCell *cell;
    
    
    if (_isCategory) {
        DeviceTableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!deviceCell) {
            deviceCell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [deviceCell setBackgroundColor:[UIColor clearColor]];
        
        NSString *key = self.currentGroupsDictionary.allKeys[indexPath.row];
        [deviceCell.mainTextLabel styleSet:key andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
        int deviceCount = (int)((NSNumber *)self.currentGroupsDictionary[key]).integerValue;
        deviceCell.secondaryTextLabel.attributedText = [FontData getString:deviceCount > 1 ? [NSString stringWithFormat:@"%zd devices", deviceCount] : @"1 device" withFont:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
        deviceCell.backgroundColor = [UIColor clearColor];
        
        NSString *imageName = [[[key stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"&" withString:@""] lowercaseString];
        NSLog(@"%@", imageName);
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            deviceCell.deviceImage.image = image;
        }
        
        cell = deviceCell;
    }
    else {
        DeviceBrandTableViewCell *brandCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if (!brandCell) {
            brandCell = [[DeviceBrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSString *key = _sortedKeys[indexPath.row];
        
        int deviceCount = (int)((NSNumber *)self.currentGroupsDictionary[key]).integerValue;
        brandCell.countLabel.attributedText = [FontData getString:deviceCount > 1 ? [NSString stringWithFormat:@"%zd devices", deviceCount] : @"1 device" withFont:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
        brandCell.backgroundColor = [UIColor clearColor];
        
        [brandCell.mainTextLabel styleSet:key andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES]];
        
        brandCell.brandImage.image = [UIImage imageNamed:@"CheckmarkEmptyIcon"];
        
        NSString *urlString = [[ImagePaths getSmallBrandImage:key] stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSURL *url = [NSURL URLWithString:urlString];
        
        // DDLogError(@"URLSTRING: %@", urlString);
        
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:url]) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[SDWebImageManager sharedManager] cacheKeyForURL:url]];
            if (image) {
                CGSize imageSize = image.size;
                UIGraphicsBeginImageContext(imageSize);
                [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [brandCell.brandImage setImage:newImage];
            }
        }
        else {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {                    
                    CGSize imageSize = image.size;
                    UIGraphicsBeginImageContext(imageSize);
                    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
                    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    [brandCell.brandImage setImage:newImage];
                }
            }];
        }
        
        cell = brandCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ShowDevices" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowDevices"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if ([segue.destinationViewController isKindOfClass:[AddDeviceViewController class]]) {
            ((AddDeviceViewController *)segue.destinationViewController).groupByType = _selectedGroupType;
            ((AddDeviceViewController *)segue.destinationViewController).groupName = _isCategory ? self.currentGroupsDictionary.allKeys[indexPath.row] : _sortedKeys[indexPath.row];
            if (self.filterHubRequiredDevices) {
                ((AddDeviceViewController *)segue.destinationViewController).hublessDevices = self.hublessDevices;
            }
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)back:(NSObject *)sender {
  NSArray *viewControllers = self.navigationController.viewControllers;
  if (viewControllers.count > 2) {
    UIViewController *previous = viewControllers[viewControllers.count - 2];
    if ([previous isKindOfClass:[HubPairingSuccessViewController class]]) {
      [self.navigationController popToRootViewControllerAnimated:true];
      return;
    }
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)close:(id)sender {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers[0] isKindOfClass:[DashboardTwoViewController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if (viewControllers.count == 2 && [viewControllers[1] isKindOfClass:[DeviceListViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
    }
}

- (void)search:(id)sender {
    SearchDeviceViewController *vc = [SearchDeviceViewController create];
    vc.hublessDevices = self.hublessDevices;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)categoryPressed:(id)sender {
    _selectedGroupType = GroupByTypeByCategory;
    [self buttonSelectedWithIndex:_selectedGroupType];
}

- (void)brandPressed:(id)sender {
    _selectedGroupType = GroupByTypeByBrand;
    [self buttonSelectedWithIndex:_selectedGroupType];
}

- (IBAction)foundDevicesPressed:(id)sender {
    if ([self.lookingLabel.text isEqualToString:NSLocalizedString(@"Looking...", nil)]) {
        return;
    }
    
    [[DevicePairingManager sharedInstance] stopHubPairing];
    [self.navigationController pushViewController:[FoundDevicesViewController create] animated:YES];
}

- (void)changeLabels:(NSObject *)sender {
    [[DevicePairingManager sharedInstance] changeLabels:_lookingLabel deviceCountLabel:_pairingModeLabel inView:self.view];
}

@end
