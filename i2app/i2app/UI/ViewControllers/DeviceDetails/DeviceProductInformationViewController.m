//
//  DeviceProductInformationViewController.m
//  i2app
//
//  Created by Arcus Team on 6/2/15.
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
#import "DeviceProductInformationViewController.h"
#import "NSDictionary+GetByOrder.h"
#import "NSDate+Convert.h"

#import "DeviceCapability.h"
#import "ProductCatalogController.h"
#import "ProductCapability.h"
#import "HubCapability.h"
#import "PlaceCapability.h"
#import "DeviceAdvancedCapability.h"
#import "HubNetworkCapability.h"
#import "HubAdvancedCapability.h"
#import "HubConnectionCapability.h"
#import "HueBridgeCapability.h"
#import "DeviceController.h"
#import "LutronBridgeCapability.h"
#import "SwannBatteryCameraCapability.h"
#import "WifiCapability.h"


#pragma mark - DeviceProductInformationTableViewCell
@interface DeviceProductInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueTextLabel;

- (void)setTitle:(NSString *)title Value:(NSString *)value;

@end

@interface DeviceProductInformationTextTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation DeviceProductInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title Value:(NSString *)value {
    [self.titleTextLabel styleSet:title andButtonType:FontDataType_DemiBold_12_WhiteAlpha upperCase:YES];
    [self.valueTextLabel styleSet:value andButtonType:FontDataType_DemiBold_14_White_Italic_NoSpace];
}

@end

#pragma mark - DeviceProductInformationViewController
@interface DeviceProductInformationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *productInformationArray;

@property (weak, nonatomic) IBOutlet UILabel *deviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *deviceSubtitle;

@property (weak, nonatomic) IBOutlet UIView  *footerSeperator;
@property (weak, nonatomic) IBOutlet UILabel *footerTitle;
@property (weak, nonatomic) IBOutlet UILabel *footerSubtitle;

@end

@implementation DeviceProductInformationViewController

#pragma mark - Life Cycle
+ (DeviceProductInformationViewController *)createWithDevice:(DeviceModel*)deviceModel {
    DeviceProductInformationViewController *vc =[[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceProductInformationViewController class])];
    vc.deviceModel = deviceModel;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"PRODUCT INFORMATION", nil);
    for (UILabel *label in self.view.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label setText:@""];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self navBarWithBackButtonAndTitle:self.title];
    [self addBackButtonItemAsLeftButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productInformationArray.count;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentKey = (NSString *)[self.productInformationArray[indexPath.row] getKeyBy:0];
    
    if ([currentKey isEqualToString:@"space"]) {
        return [tableView dequeueReusableCellWithIdentifier:@"spaceCell"];
    } else if ([currentKey isEqualToString:@"textCell"]) {
      DeviceProductInformationTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
      cell.textLabel.text = [self.productInformationArray[indexPath.row] getValueBy:0];

      return cell;
    }
    else {
        DeviceProductInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell setTitle:[currentKey uppercaseString] Value:[self.productInformationArray[indexPath.row] getValueBy:0]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentKey = (NSString *)[self.productInformationArray[indexPath.row] getKeyBy:0];

  if ([currentKey isEqualToString:@"space"]) {
    return 75;
  } else if ([currentKey isEqualToString:@"textCell"]) {
    return 75;
  } else {
    return 25;
  }
}

- (void)loadData {
    if ([self.deviceModel isKindOfClass:[HubModel class]]) {
        [self loadProductInformationForHub: (HubModel *)self.deviceModel];
        return;
    }
    
    NSString *productId = [DeviceCapability getProductIdFromModel:self.deviceModel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceTitle styleSet:[self.deviceModel name]  andButtonType:FontDataType_DemiBold_12_WhiteAlpha upperCase:YES];
        if (productId.length == 0) {
            self.deviceSubtitle.text = @"";
            
            self.productInformationArray = [self emptyProductInfo];
            [self.tableView reloadData];
        }
    });
    
    if (productId.length > 0) {
        [ProductCatalogController getProductWithId:productId].then (^(ProductModel *productModel) {
            [self.deviceSubtitle styleSet:[ProductCapability getNameFromModel:productModel] andButtonType:FontDataType_DemiBold_14_White_Italic_NoSpace];
            
            self.productInformationArray = [self productInformationWithModel: productModel];
            [self.tableView reloadData];
            
        }).catch(^(NSError *error) {
            self.productInformationArray = [self emptyProductInfo];
            [self.tableView reloadData];
        });
    }

    if (self.deviceModel.deviceType == DeviceTypeThermostatHoneywellC2C) {
        [self.footerSeperator setHidden:NO];
        [self.footerTitle styleSet:NSLocalizedString(@"AUTO MODE", nil)  andButtonType:FontDataType_DemiBold_12_WhiteAlpha upperCase:YES];
        [self.footerSubtitle styleSet:NSLocalizedString(@"To use Auto mode on your thermostat, Honeywell requires you to first enable the Auto mode setting on the device. Check the Honeywell owner’s manual for details.", nil) andButtonType:FontDataType_DemiBold_14_White_Italic_NoSpace];
    }
}

- (void)loadProductInformationForHub:(HubModel *)hubModel {
    PlaceModel *placeModel = [[[CorneaHolder shared] settings] currentPlace];

    [self.deviceTitle styleSet:[PlaceCapability getNameFromModel:placeModel]  andButtonType:FontDataType_DemiBold_12_WhiteAlpha upperCase:YES];
    [self.deviceSubtitle styleSet:[hubModel name] andButtonType:FontDataType_DemiBold_14_White_Italic_NoSpace];
    
    self.productInformationArray = [self hubProductInfo: hubModel];
    [self.tableView reloadData];
}

- (NSArray *)productInformationWithModel:(ProductModel *)productModel {
  if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
    //WORKS


    NSMutableArray *informationList = [[NSMutableArray alloc] init];
    
    if (self.deviceModel.deviceType == DeviceTypeThermostatNest) {
      [informationList addObject:@{NSLocalizedString(@"Brand", nil): @"Nest"}];
    } else {
      NSString *vendor = [ProductCapability getVendorFromModel:productModel];
      if (vendor.length > 0) {
        [informationList addObject:@{NSLocalizedString(@"Brand", nil): vendor}];
      }
    }

    NSString *itemNo = [ProductCapability getArcusProductIdFromModel:productModel];
    if (itemNo && itemNo.length > 0) {
      [informationList addObject:@{NSLocalizedString(@"Lowe's item no", nil): itemNo}];
    }

    NSString *modelNo = [ProductCapability getArcusModelIdFromModel:productModel];
    if (modelNo && modelNo.length > 0) {
      [informationList addObject:@{NSLocalizedString(@"Model no", nil): modelNo}];
    }

    if ([[productModel productShortName] isEqualToString:@"Security Camera"]) {
      NSString *serialNo = [SwannBatteryCameraCapability getSnFromModel:self.deviceModel];
      if (serialNo == nil || serialNo.length == 0) {
        serialNo = @"N/A";
      }

      [informationList addObject:@{NSLocalizedString(@"Serial no", nil): serialNo}];
    }

    NSString *worksStr = @"-";
    if ([[[ProductCapability getCertFromModel:productModel] lowercaseString] isEqualToString:@"works"]) {
      worksStr = @"Works with Arcus";
    }
    [informationList addObject:@{NSLocalizedString(@"certification", nil): worksStr}];

    [informationList addObject:@{NSLocalizedString(@"Last paired", nil): [[DeviceAdvancedCapability getAddedFromModel:self.deviceModel] lastChangedTime]}];

    [informationList addObject:@{NSLocalizedString(@"space", nil): @""}];

    [informationList addObject:@{NSLocalizedString(@"Wireless", nil): [ProductCapability getProtoFamilyFromModel:productModel]}];

    if (self.deviceModel.deviceType == DeviceTypeHueBridge) {
      NSString *firmware = [HueBridgeCapability getSwversionFromModel: self.deviceModel];
      NSString *ipAddress = [HueBridgeCapability getIpaddressFromModel: self.deviceModel];

      [informationList addObject:@{NSLocalizedString(@"space", nil): @""}];

      [informationList addObject:@{NSLocalizedString(@"FIRMWARE", nil): firmware}];

      [informationList addObject:@{NSLocalizedString(@"IP ADDRESS", nil): ipAddress}];
    } else if ([[productModel productShortName] isEqualToString:@"Security Camera"]) {
      NSString *firmware = [DeviceOtaCapability getCurrentVersionFromModel: self.deviceModel];
      [informationList addObject:@{NSLocalizedString(@"FIRMWARE", nil): firmware}];
    }

    if (self.deviceModel.deviceType == DeviceTypeThermostatNest) {
      NSString *roomName = [DeviceController getNestRoomNameForModel:self.deviceModel];

      [informationList addObject:@{NSLocalizedString(@"space", nil): @""}];

      NSString *text = @"Manage these settings on your Nest thermostat or in the Nest app.";
      [informationList addObject:@{@"textCell": text}];

      [informationList addObject:@{NSLocalizedString(@"ROOM", nil): roomName}];

      if ([DeviceController getNestLocked:self.deviceModel]) {
        int low = (int) [DeviceController getNestLockedTempMinForModel:self.deviceModel];
        int high = (int) [DeviceController getNestLockedTempMaxForModel:self.deviceModel];
        NSString *text = [NSString stringWithFormat:@"On (%i° - %i°)", low, high];

        [informationList addObject:@{NSLocalizedString(@"TEMP. LOCK", nil): text}];
      } else {
        [informationList addObject:@{NSLocalizedString(@"TEMP. LOCK", nil): @"OFF"}];
      }
    }
    if (self.deviceModel.deviceType == DeviceTypeLutronCasetaSmartBridge) {
      [informationList addObject:@{NSLocalizedString(@"space", nil): @""}];

      NSString *operatingMode = [LutronBridgeCapability getOperatingmodeFromModel:self.deviceModel];
      [informationList addObject:@{NSLocalizedString(@"OPERATING MODE", nil): operatingMode}];

      NSString *serialNumber = [LutronBridgeCapability getSerialnumberFromModel:self.deviceModel];
      [informationList addObject:@{NSLocalizedString(@"SERIAL NUMBER", nil): serialNumber}];
    }

    if ([[productModel productShortName] isEqualToString:@"Security Camera"]) {
      [informationList addObject:@{NSLocalizedString(@"space", nil): @""}];

      NSString *macAddress = [WiFiCapability getBssidFromModel:self.deviceModel];
      [informationList addObject:@{NSLocalizedString(@"Mac Address", nil): macAddress}];
    }

    return informationList;
  }
  return @[];
}

- (NSArray *)hubProductInfo:(HubModel *)hubModel {
    float since = [HubNetworkCapability getUptimeFromModel:hubModel];
    NSString *sinceStr = [[[NSDate date] dateByAddingTimeInterval:since * -1] formatDate:@"MMM dd,yyyy hh:mm a"];
    
    return @[
            @{NSLocalizedString(@"Manufacturer", nil): [HubCapability getVendorFromModel:hubModel]},
            @{NSLocalizedString(@"Model No.", nil): [HubCapability getModelFromModel:hubModel]},
            @{NSLocalizedString(@"Hub ID", nil): [self hubIdString]},
            @{NSLocalizedString(@"Last Contact", nil): sinceStr},
          ];
}

- (NSArray *)emptyProductInfo{
    return
    @[
      @{NSLocalizedString(@"Manufacturer", nil): @""},
      @{NSLocalizedString(@"Lowe's item no", nil): @""},
      @{NSLocalizedString(@"Model no", nil): @""},
      @{NSLocalizedString(@"certification", nil): @""},
      @{NSLocalizedString(@"Last paired", nil): [[DeviceAdvancedCapability getAddedFromModel:self.deviceModel] lastChangedTime]},
      @{NSLocalizedString(@"space", nil): @""},
      @{NSLocalizedString(@"Wireless", nil): @""},
      @{NSLocalizedString(@"Firmware", nil): @""}];
}

- (NSString *)hubIdString {
    HubModel *hubModel = [[CorneaHolder shared] settings].currentHub;
    if (hubModel != nil) {
        return [HubCapability getIdFromModel:hubModel];
    }
    
    return @"";
}

@end

