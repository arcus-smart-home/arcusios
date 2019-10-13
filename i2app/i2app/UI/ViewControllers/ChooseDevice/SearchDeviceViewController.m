//
//  SearchDeviceViewController.m
//  i2app
//
//  Created by Arcus Team on 5/11/15.
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
#import "SearchDeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "DevicePairingWizard.h"
#import "DeviceProductCatalog+Extension.h"
#import "ProductCatalogController.h"
#import "UIViewController+AlertBar.h"
#import "ImagePaths.h"
#import "UIImageView+WebCache.h"
#import "ImageDownloader.h"
#import "DeviceCapability.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "PopupSelectionButtonsView.h"
#import <i2app-Swift.h>

@interface SearchDeviceViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, HubRequiredModalDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (nonatomic, strong) NSArray *searchResultArray;
@property (weak, nonatomic) IBOutlet UIView *searchBackView;
@property (nonatomic, weak) IBOutlet UIImageView *hubImage;

@end

@implementation SearchDeviceViewController {
    PopupSelectionWindow  *_popupWindow;
}

#pragma mark - Life Cycle

+ (SearchDeviceViewController *)create {
    return [[UIStoryboard storyboardWithName:@"ChooseDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SearchDeviceViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Search for a Device", nil) uppercaseString]];
    [self setBackgroundColorToParentColor];

    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110;

    self.searchBackView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    self.searchBar.delegate = self;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    // Set the placeholder text color to black
    [self.searchBar setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // Set the text color to black
    self.searchBar.textColor = [UIColor blackColor];
    [self.searchBar setNeedsLayout];
    
    // Set textField attributes
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                                 NSKernAttributeName: @(2.0f)};
    self.searchBar.attributedText = [[NSAttributedString alloc] initWithString:[self.searchBar.text uppercaseString] attributes:attributes];
    self.searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[@"Search" uppercaseString]attributes:attributes];
    [self.searchBar addTarget:self action:@selector(textFieldEdited:event:) forControlEvents:UIControlEventEditingDidEnd];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchBar removeTarget:self
                             action:@selector(textFieldEdited:event:)
                   forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - textField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldEdited:(UITextField*)textfield event:(UIEvent*)event {
    NSString *stringTitle = nil;
    stringTitle = textfield.text;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(updateSearchResultsForSearchString:) withObject:stringTitle afterDelay:0.3f];
}
#pragma mark - Search

- (void)updateSearchResultsForSearchString:(NSString *)searchString {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [ProductCatalogController findProductsWithSearch:searchString].thenInBackground(^(NSArray *products) {
            
            // Create the DeviceProductCatalog objects
            NSMutableArray *mutProducts = [[NSMutableArray alloc] initWithCapacity:products.count];
            for (NSDictionary *deviceDict in products) {
                DeviceProductCatalog *device = [[DeviceProductCatalog alloc] initWithJson:deviceDict];

                if (self.hublessDevices != nil) {
                    for (ProductModel *hublessProduct in self.hublessDevices) {
                        if (device.productId == hublessProduct.modelId) {
                            [mutProducts addObject:device];
                            break;
                        }
                    }
                } else {
                    [mutProducts addObject:device];
                }
            }

            self.searchResultArray = mutProducts.copy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }).catch(^(NSError *error) {
            [self popupAlert:NSLocalizedString(@"Could not be found", nil)  type:AlertBarTypeWarning sceneType:AlertBarSceneInDevice withDuration:1.0];
            self.searchResultArray = @[];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";

    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:CellIdentifier];
    }
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    DeviceProductCatalog *device = self.searchResultArray[indexPath.row];

    cell.titleLabel.text = [device productName];
    cell.descriptionLabel.text = [device brand];

    __block NSString *urlString = [ImagePaths getSmallProductImageFromProductId:device.productId];
    [cell.detailImage sd_setImageWithURL:[NSURL URLWithString:urlString]
                               completed:^(UIImage *image,
                                           NSError *error,
                                           SDImageCacheType cacheType,
                                           NSURL *imageURL) {
        [cell.detailImage setBounds:CGRectMake(cell.detailImage.bounds.origin.x,
                                               cell.detailImage.bounds.origin.y,
                                               image.size.width,
                                               image.size.height)];
        
        if (!cell.imageView.image) {
            if (!cell.detailImage.image) {
                // if there is no product image, we should get the generic category image
                urlString = [device getSmallProductImageFromDevTypeHint];
                DDLogWarn(@"%@", urlString);
                
                [cell.detailImage sd_setImageWithURL:[NSURL URLWithString:urlString]
                                    placeholderImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]
                                           completed:^(UIImage *image,
                                                       NSError *error,
                                                       SDImageCacheType cacheType,
                                                       NSURL *imageURL) {
                    [cell.detailImage setBounds:CGRectMake(cell.detailImage.bounds.origin.x,
                                                           cell.detailImage.bounds.origin.y,
                                                           image.size.width,
                                                           image.size.height)];
                }];
            }
        }
    }];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceProductCatalog *deviceProdCatalog = self.searchResultArray[indexPath.row];
    DDLogWarn(@"%@", deviceProdCatalog);
    if ([deviceProdCatalog isKindOfClass:[DeviceProductCatalog class]]) {
        // Check the min required version
        if ([DevicePairingWizard isAppUpgradeNeeded:deviceProdCatalog]) {
            PopupSelectionButtonModel *buttonModel = [PopupSelectionButtonModel createUnfilledStyle:NSLocalizedString(@"UPDATE APP", nil)
                                                                                              event:@selector(updateApp)];
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:@""
                                                                                      subtitle:NSLocalizedString(@"Min App Version Required", nil)
                                                                                        button:buttonModel, nil];
            buttonView.owner = self;
            [self popup:buttonView
               complete:nil];
        } else {
            DeviceProductCatalog *deviceDict = self.searchResultArray[indexPath.row];
            DDLogWarn(@"%@", deviceDict);
            if ([deviceDict isKindOfClass:[DeviceProductCatalog class]]) {
                if (deviceProdCatalog.hubRequired && ![[CorneaHolder shared] settings].currentHub) {
                    HubRequiredModalViewController *hubRequiredVC = [HubRequiredModalViewController create:self];
                    [self.navigationController presentViewController:hubRequiredVC animated:YES completion:^{}];
                } else {
                    DeviceType type = [DeviceModel deviceTypeFromHint:deviceDict.productScreen
                                                             andOther:@[]
                                                                other:deviceDict.productId];
                    [DevicePairingWizard runSinglePairingWizardWithModelData:deviceDict
                                                                  deviceType:type];
                }
            }
        }
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow
                                    closeBlock:^(id obj) {
                                      [[ApplicationRoutingService defaultService] showDashboardWithAnimated:YES popToRoot:YES completion:nil];
                                    }];
}

- (void)updateApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrlInAppStore] options:@{} completionHandler:nil];
}

#pragma mark - HubRequiredModalDelegate

- (void)showWifiBasedDevices {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWifiBasedDevices"
                                                        object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
