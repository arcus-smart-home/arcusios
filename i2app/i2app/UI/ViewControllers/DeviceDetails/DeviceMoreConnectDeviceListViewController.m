//
//  DeviceMoreConnectDeviceListViewController.m
//  i2app
//
//  Created by Arcus Team on 11/19/15.
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
#import "DeviceMoreConnectDeviceListViewController.h"
#import "ArcusImageTitleDescriptionTableViewCell.h"
#import "AKFileManager.h"
#import "ImagePaths.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "DeviceCapability.h"

@interface DeviceMoreConnectDeviceListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UIButton *headerButton;
@property (nonatomic, strong) IBOutlet UITableView *deviceTable;
@property (nonatomic, strong) IBOutletCollection(NSLayoutConstraint) NSArray *headerConstraints;

@end

@implementation DeviceMoreConnectDeviceListViewController

#pragma mark - View LifeCylce

+ (DeviceMoreConnectDeviceListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"DeviceDetails"
                                      bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureNavBar];
    [self configureBackground];

    // TEMP:  Disable header until we have a Buy Now Link.
//    if ([self.deviceList count] < 3) {
//        [self configureHeaderView];
//    }
//    else {
//        [self hideViewHeader];
//    }
    [self hideViewHeader];
}

#pragma mark - UI Configuration

- (void)configureNavBar {
    self.navigationItem.title = NSLocalizedString(@"Garage Doors", nil);
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
}

- (void)configureBackground {
    self.deviceTable.backgroundColor = [UIColor clearColor];
    self.deviceTable.backgroundView = nil;
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
}

- (void)configureHeaderView {
    
    NSString *headerString = NSLocalizedString(@"This device can control up to three garage \ndoors using Genie tilt sensors.", nil);
    NSAttributedString *headerText = [[NSAttributedString alloc] initWithString:headerString
                                                                     attributes:[FontData getWhiteFontWithSize:16.0f
                                                                                                          bold:YES
                                                                                                       kerning:0.0f]];
    [self.headerLabel setAttributedText:headerText];
    
    NSString *headerButtonString = NSLocalizedString(@"BUY MORE", nil);
    NSAttributedString *headerButtonText = [[NSAttributedString alloc] initWithString:headerButtonString
                                                                           attributes:[FontData getWhiteFontWithSize:12.0f
                                                                                                                bold:NO
                                                                                                             kerning:2.0f]];
    
    [self.headerButton setAttributedTitle:headerButtonText
                                 forState:UIControlStateNormal];
    
    self.headerButton.layer.cornerRadius = 4.0f;
    self.headerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerButton.layer.borderWidth = 1.0f;

}

- (void)hideViewHeader {
    self.headerLabel.text = nil;
    [self.headerLabel setHidden:YES];
    [self.headerButton setHidden:YES];
    for (NSLayoutConstraint *constraint in self.headerConstraints) {
        [constraint setConstant:0.0f];
    }
}

#pragma mark - IBActions

- (IBAction)headerButtonPressed:(id)sender {
    // Configure button press once we have a Buy Now url.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.deviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    ArcusImageTitleDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArcusImageTitleDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:CellIdentifier];
    }
    
    DeviceModel *device = self.deviceList[indexPath.row];
    
    cell.detailImage.image = [UIImage imageNamed:@"PlaceholderWhite"];
    
    // Set Image
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    
    if (!image) {
        NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                cell.detailImage.image = image.invertColor;
            }
        }];
    }
    else {
        NSString *urlString = [ImagePaths getSmallProductImageFromDevTypeHint:[device devTypeHintToImageName]];
        [cell.detailImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"PlaceholderWhite"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            cell.detailImage.layer.borderWidth = 0.0f;
            [cell.detailImage setImage:image.invertColor];
        }];
    }
    
    // Set Primary Label
    NSString *title = [device name];
    NSDictionary *attributes = [FontData getWhiteFontWithSize:12.0f
                                                         bold:NO
                                                      kerning:2.0f];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[title uppercaseString]
                                                                    attributes:attributes];
    [cell.titleLabel setAttributedText:titleText];
    
    // Set Seconday Label
    UIColor *textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:textColor
                                                                 size:14.0
                                                              kerning:0.0];
    
    NSString *description = [device type];
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    
    // Set Accessory Image
    cell.accessoryImage.alpha = 0.0f;
    
    return cell;
}

#pragma mark - UITableViewDelegate


@end
