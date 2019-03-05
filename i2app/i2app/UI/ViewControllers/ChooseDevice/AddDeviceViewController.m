//
//  AddDeviceViewController.m
//  i2app
//
//  Created by Arcus Team on 5/8/15.
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
#import "AddDeviceViewController.h"
#import "DeviceTableViewCell.h"
#import "DevicePairingWizard.h"
#import "ProductCatalogController.h"
#import "DeviceProductCatalog.h"
#import "FoundDevicesViewController.h"
#import "DevicePairingManager.h"
#import "ImageDownloader.h"
#import "DeviceProductCatalog.h"


#import "UIImageView+WebCache.h"
#import "PopupSelectionButtonsView.h"
#import "ProductCapability.h"
#import "DeviceManager.h"

#import <i2app-Swift.h>

@interface AddDeviceViewController () <UITableViewDataSource, UITableViewDelegate, HubRequiredModalDelegate> {
  DeviceProductCatalog *_catalog;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *pairingModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookingLabel;
@property (nonatomic, weak) IBOutlet UIImageView *hubImage;

@property (nonatomic, strong, readonly) NSArray *devicesArray;

@end

@implementation AddDeviceViewController {
  PopupSelectionWindow  *_popupWindow;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self navBarWithBackButtonAndTitle:self.groupName];

  [self setBackgroundColorToParentColor];

  self.tableView.estimatedRowHeight = 100;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.separatorColor = [UIColor blackColor];
  self.tableView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
  [self.tableView setTableFooterView:[[UIView alloc] init]];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabels:) name:kUpdateUIDeviceAddedNotification object:nil];

  // set up the initial state of pairingModeLabel and lookingLabel
  [self changeLabels:self];

  if (self.groupByType == GroupByTypeByCategory) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
      [ProductCatalogController getProductsByCategoryWithCategory:self.groupName].then(^(NSArray *products) {
        if (self.hublessDevices != nil) {
          NSMutableArray *mutableProducts = [[NSMutableArray alloc] init];
          for (DeviceProductCatalog *product in products) {
            for (ProductModel *hublessProduct in self.hublessDevices) {
              if ([product.productId isEqualToString:hublessProduct.modelId]) {
                [mutableProducts addObject:product];
                break;
              }
            }
          }
          _devicesArray = [NSArray arrayWithArray:mutableProducts];
        } else {
          _devicesArray = products;
        }

        // Sort them based on the Product name in the following order:
        // 1. All Arcus products in alphabetical order
        // 2. The rest of the product in alphabetical order

        // TODO: when an attribute in DeviceProductCatalog that tells if a product is 1st or
        // 2nd gen becomes available, we should switch to using this order of products
        // 1. Second Generation Arcus products in alphabetical order
        // 2. First Generation Arcus products in alphabetical order
        // 3. Other Arcus products in alphabetical order
        // 4. The rest of the product in alphabetical order

        NSArray *deviceArray = [_devicesArray sortedArrayUsingComparator:^NSComparisonResult(DeviceProductCatalog *a,  DeviceProductCatalog *b) {

          if ([a.brand containsString:@"Arcus"] && [b.brand containsString:@"Arcus"] ) {
            return [a.productName caseInsensitiveCompare:b.productName];
          }

          if ([a.brand containsString:@"Arcus"]) {
            return NSOrderedAscending;
          }
          if ([b.brand containsString:@"Arcus"]) {
            return NSOrderedDescending;
          }

          return [a.productName caseInsensitiveCompare:b.productName];
        }];
        _devicesArray = deviceArray.copy;

        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
      }).catch(^(NSError *error) {
        [self displayErrorMessage:error.localizedDescription withTitle:@"getProductsByCategoryWithCategory Error"];
      });
    });
  }
  else {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
      [ProductCatalogController getProductsByBrandWithBrand:self.groupName].then(^(NSArray *products) {
        if (self.hublessDevices != nil) {
          NSMutableArray *mutableProducts = [[NSMutableArray alloc] init];
          for (DeviceProductCatalog *product in products) {
            for (ProductModel *hublessProduct in self.hublessDevices) {
              if ([product.productId isEqualToString:hublessProduct.modelId]) {
                [mutableProducts addObject:product];
                break;
              }
            }
          }
          _devicesArray = [NSArray arrayWithArray:mutableProducts];
        } else {
          _devicesArray = products;
        }

        if ([self.groupName isEqualToString:@"Arcus"]){
          _devicesArray = [ArcusNameSorter sortedArcusDevices:_devicesArray];
        } else {
          _devicesArray = [ArcusNameSorter sortedDevices:_devicesArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
      }).catch(^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self displayErrorMessage:error.localizedDescription withTitle:@"getProductsByBrandWithBrand Error"];
        });
      });
    });
  }

  // Update the labels
  [self changeLabels:self];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (![[DevicePairingManager sharedInstance] isInPairingMode]) {
    // Somehow we got out of pairing mode. Lets re-enter pairing mode.
    // Typically this is because someone turned off pairing mode but the
    // user navigated backwards and landed on a device selection screen
    // instead of the category selection screen.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
      [[DevicePairingManager sharedInstance] startHubPairing:NO].then(^ {
        [self changeLabels:self];
      });
    });
  }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.devicesArray.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"cell";
  DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

  //Setting cell background color to clear to override controller settings for cell making white background on iPad:
  [cell setBackgroundColor:[UIColor clearColor]];

  DeviceProductCatalog *device = self.devicesArray[indexPath.row];

  [cell.mainTextLabel styleSet:device.productName andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];

  cell.secondaryTextLabel.attributedText = [FontData getString:device.brand withFont:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
  cell.disclosureImage.image = [UIImage imageNamed:@"AddButton"];

  [ImageDownloader downloadDeviceImage:device.productId withDevTypeId:device.productScreen withPlaceHolder:@"CategoryIconPlaceholder" isLarge:NO isBlackStyle:YES].then(^(UIImage * image) {
    cell.deviceImage.image = image;
  });

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  DeviceProductCatalog *product = self.devicesArray[indexPath.row];
  DDLogWarn(@"%@", product);

  if ([product isKindOfClass:[DeviceProductCatalog class]]) {
    // Check the min required version
    if ([DevicePairingWizard isAppUpgradeNeeded:product]) {
      PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:@""
                                                                                subtitle:NSLocalizedString(@"Min App Version Required", nil)
                                                                                  button:[PopupSelectionButtonModel
                                                                                          createUnfilledStyle:NSLocalizedString(@"UPDATE APP", nil)
                                                                                          event:@selector(updateApp)],
                                               nil];
      buttonView.owner = self;
      [self popup:buttonView complete:nil];
      return;
    }

    // Check if product requires another product to be present
    if (product.devRequired.length > 0) {

      bool hasRequiredDevice = NO;

      for (DeviceModel *deviceModel in DeviceManager.instance.devices) {
        if ([[deviceModel productId] isEqualToString: product.devRequired]) {
          hasRequiredDevice = true;
          break;
        }
      }

      if (!hasRequiredDevice) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
          [ProductCatalogController getProductWithId: product.devRequired].thenInBackground(^(ProductModel *productRequired) {

            [self showDeviceRequiredPopupWithProductName: [ProductCapability getShortNameFromModel:productRequired]
                                                   brand: [ProductCapability getVendorFromModel:productRequired]];
          });
        });

        return;
      }
    }

    BOOL beginPairing = YES;
    if ([product.brand isEqualToString:@"Somfy"] &&
        [product.productName isEqualToString:@"Blinds & Shades"]) {
      beginPairing = [self isSomfyControllerPaired:product];
    }

    if (beginPairing) {
      HubModel *currentHub = [[CorneaHolder shared] settings].currentHub;
      if (product.hubRequired && !currentHub) {
        HubRequiredModalViewController *hubRequiredVC = [HubRequiredModalViewController create:self];
        [self.navigationController presentViewController:hubRequiredVC animated:YES completion:^{}];
      } else {
        [DevicePairingWizard runSinglePairingWizardWithModelData:product
                                                      deviceType:[DeviceModel deviceTypeFromHint:product.productScreen
                                                                                        andOther:[NSArray new]
                                                                                           other:product.productId]];
      }
    } else {
      [self displayErrorMessage:NSLocalizedString(@"A blinds controller must be \npaired before pairing individual blinds.", nil)
                      withTitle:[NSLocalizedString(@"Blinds Controller Required", nil) uppercaseString]];
    }
  }
}

- (void)showDeviceRequiredPopupWithProductName: (NSString *)productName brand: (NSString *)brand {
  dispatch_async(dispatch_get_main_queue(), ^{

    NSString *title = [[NSString stringWithFormat: @"%@ %@ REQUIRED", brand, productName] uppercaseString];
    NSString *subText = [NSString stringWithFormat: @"A %@ %@ must be paired before pairing this device.", brand, productName];

    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle: title
                                                                              subtitle:subText
                                                                                button:nil];

    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:buttonView
                                         owner:self
                                 closeSelector:nil
                                         style:PopupWindowStyleCautionWindow
                                    closeBlock:^(id obj) { }];
  });
}

- (void)closeHueRequiredPopup {

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
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrlInAppStore]];
}

- (BOOL)isSomfyControllerPaired:(DeviceProductCatalog *)product {
  BOOL isPaired = NO;

  for (DeviceModel *device in [[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]]) {
    if ([device.type isEqualToString:@"dev"]) {
      if ([[device.deviceTypeName lowercaseString] isEqualToString:@"somfyv1bridge"]) {
        isPaired = YES;
        break;
      }
    }
  }

  return isPaired;
}

- (IBAction)foundDevicesPressed:(id)sender {
  if ([self.lookingLabel.text isEqualToString:NSLocalizedString(@"Looking...", nil)]) {
    return;
  }
  FoundDevicesViewController *vc = [FoundDevicesViewController create];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeLabels:(NSObject *)sender {
  [[DevicePairingManager sharedInstance] changeLabels:_lookingLabel deviceCountLabel:_pairingModeLabel inView:self.view];
}

#pragma mark - HubRequiredModalDelegate

- (void)showWifiBasedDevices {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWifiBasedDevices"
                                                      object:nil];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
