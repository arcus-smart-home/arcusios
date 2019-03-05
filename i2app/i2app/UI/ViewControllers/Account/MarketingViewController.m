//
//  MarketingViewController.m
//  i2app
//
//  Created by Arcus Team on 8/13/15.
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
#import "MarketingViewController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "UIImage+ImageEffects.h"

#import "PersonCapability.h"

#define MO_TITLE @"MarketingOptionTitle"
#define MO_DESCRIPTION @"MarketingOptionDescription"

@interface MarketingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *marketingTableView;
@property (nonatomic, strong) NSArray *optionsArray;
@property (nonatomic, assign) BOOL offersAndPromotionsEnabled;

@end

@implementation MarketingViewController {
    NSMutableArray *markingData;
}

@dynamic offersAndPromotionsEnabled;

#pragma mark - View LifeCycle
+ (MarketingViewController *)create {
    MarketingViewController *viewController = [[UIStoryboard storyboardWithName:@"AccountSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MarketingViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.marketingTableView.backgroundColor = [UIColor clearColor];
    self.marketingTableView.backgroundView = nil;
    self.marketingTableView.estimatedRowHeight = 70;
    self.marketingTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self setBackgroundColorToParentColor];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    
    self.marketingTableView.scrollEnabled = NO;
}

#pragma mark - Setters & Getters

- (NSArray *)optionsArray {
    if (!_optionsArray) {
        _optionsArray = @[@{MO_TITLE : NSLocalizedString(@"Offers & Promotions", @""),
                            MO_DESCRIPTION : NSLocalizedString(@"Send me information about new products as well as coupons and in-store specials.", @"")}];
//        _optionsArray = @[@{MO_TITLE : NSLocalizedString(@"Offers & Promotions", @""),
//                            MO_DESCRIPTION : NSLocalizedString(@"Send me information about new products as well as coupons and in-store specials.", @"")},
//                          @{MO_TITLE : NSLocalizedString(@"Monthly Summary", @""),
//                            MO_DESCRIPTION : NSLocalizedString(@"Send me information about new products as well as coupons and in-store specials.", @"")}];
    }
    return _optionsArray;
}

- (BOOL)offersAndPromotionsEnabled {
    return ([[PersonCapability getConsentOffersPromotionsFromModel:CorneaHolder.shared.settings.currentPerson] compare:[NSDate dateWithTimeIntervalSince1970:0]] != NSOrderedSame);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.optionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MarketingOptionsCell";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    }
    
    cell.managesSelectionState = NO;
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *optionInfo = self.optionsArray[indexPath.row];
    
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:[optionInfo[MO_TITLE] uppercaseString] attributes:[FontData getFont:FontDataTypeSettingsText]];
    [cell.titleLabel setAttributedText:titleText];
    
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:optionInfo[MO_DESCRIPTION] attributes:[FontData getFont:FontDataTypeSlidingMenuSubtitle]];
    [cell.descriptionLabel setAttributedText:descText];
    
    cell.selectionImage.image = cell.selectionImage.image.invertColor;
    cell.selectionImage.highlightedImage = cell.selectionImage.highlightedImage.invertColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryImage.hidden = YES;

    [cell.selectionImage setHighlighted:self.offersAndPromotionsEnabled];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusSelectOptionTableViewCell *cell = (ArcusSelectOptionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell.selectionImage setHighlighted:!cell.selectionImage.highlighted];
    }

    switch (indexPath.row) {
        case 0:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                PersonModel *currentPerson = [[[CorneaHolder shared] settings] currentPerson];

                if (cell.selectionImage.highlighted) {
                    // PersonCapability is incorrectly dividing the timestamp by 1000 instead of multiplying by 1000. Bypassing the capability in this case.
                    NSNumber *currentTimeStemp = @([[NSDate date] timeIntervalSince1970] * 1000);

                    [PersonCapability setConsentOffersPromotions:[currentTimeStemp doubleValue]
                                                         onModel:currentPerson];
                } else {
                    [PersonCapability setConsentOffersPromotions:0 onModel:currentPerson];
                }
                [CorneaHolder.shared.settings.currentPerson commit];
            });
        }
            break;
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end






