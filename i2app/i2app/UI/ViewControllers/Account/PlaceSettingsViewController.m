//
//  PlaceSettingsViewController.m
//  i2app
//
//  Created by Arcus Team on 8/18/15.
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
#import "PlaceSettingsViewController.h"
#import "PlaceSettingsTableViewCell.h"

#import "ImagePicker.h"
#import "PlaceCapability.h"

#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "PopupSelectionTitleTableView.h"
#import "PopupSelectionTextPickerView.h"
#import <i2app-Swift.h>

@interface PlaceSettingsViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) IBOutlet UIImageView *photoBackground;
@property (nonatomic, strong) IBOutlet UIButton *photoButton;
@property (nonatomic, strong) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *placeAddressLabel;
@property (nonatomic, strong) IBOutlet UITableView *placeTableView;
@property (nonatomic, strong) NSArray *settingsTitles;
@property (nonatomic, strong) PlaceModel *currentPlace;

@end

@implementation PlaceSettingsViewController {
    PopupSelectionWindow    *_timeZonePopup;
    OrderedDictionary       *_timeZones;
}

#pragma mark - View LifeCycle

+ (PlaceSettingsViewController *)create {
    PlaceSettingsViewController *viewController = [[UIStoryboard storyboardWithName:@"PlaceSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PlaceSettingsViewController class])];
    return viewController;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeTableView.backgroundColor = [UIColor clearColor];
    self.placeTableView.backgroundView = nil;
    
    [self setBackgroundColorToDashboardColor];
    
    UIImage *placeImage = [ArcusSettingsHomeImageHelper fetchHomeImage:CorneaHolder.shared.settings.currentPlace.modelId];
    placeImage = [placeImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
    placeImage = [placeImage roundCornerImageWithsize:CGSizeMake(190, 190)];

    [self configurePersonButtonWithImage:placeImage];
    [self setDashboardBackgroundImage:placeImage
                         forImageView:self.photoButton.imageView];

    self.photoBackground.image = self.photoBackground.image.invertColor;
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    
    [self configurePlaceLabels];
    
    self.placeTableView.scrollEnabled = NO;
    
    NSString *placeModelUpdateNotification = [NSString stringWithFormat:@"Update%@Notification",[PlaceModel class]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeUpdated:) name:placeModelUpdateNotification object:nil];
}

#pragma mark - UI Configuration

- (void)configurePersonButtonWithImage:(UIImage *)image {
    if (image) {
        [self.photoButton setImage:image forState:UIControlStateNormal];
    }
}

- (void)configurePlaceLabels {
    NSString *nameString = [PlaceCapability getNameFromModel:self.currentPlace];
    if (nameString) {
        NSAttributedString *attributedNameString = [[NSAttributedString alloc] initWithString:nameString.uppercaseString
                                                                                   attributes:[FontData getFont:FontDataTypeSettingsText]];
        
        [self.placeNameLabel setAttributedText:attributedNameString];
    }
    
    NSString *addressString = [PlaceCapability getStreetAddress1FromModel:self.currentPlace];
    if (addressString) {
        NSAttributedString *attributedAddressString = [[NSAttributedString alloc] initWithString:addressString.uppercaseString
                                                                                      attributes:[FontData getFont:FontDataTypeSettingsSubText]];
        
        [self.placeAddressLabel setAttributedText:attributedAddressString];
    }
}

#pragma mark - Setters & Getters

- (NSArray *)settingsTitles {
    if (!_settingsTitles) {
        _settingsTitles = @[NSLocalizedString(@"Edit Address", @""),
                            NSLocalizedString(@"Time Zone", @"")];
    }
    return _settingsTitles;
}

- (PlaceModel *)currentPlace {
    return _currentPlace = CorneaHolder.shared.settings.currentPlace;
}

#pragma mark - IBActions

- (IBAction)photoButtonPressed:(id)sender {
    [[ImagePicker sharedInstance]
     presentImagePickerInViewController:self
     withImageId:self.currentPlace.modelId
     withCompletionBlock:^(UIImage *image) {
         if ([image isKindOfClass:[UIImage class]]) {
             [ImagePicker saveImage:image imageName:self.currentPlace.modelId];
             
             image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
             image = [image roundCornerImageWithsize:CGSizeMake(190, 190)];
             [self.photoButton setImage:image forState:UIControlStateNormal];
             
             [self setDashboardBackgroundImage:image forImageView:self.photoButton.imageView];
             
             if (self.navigationController && self.navigationController.viewControllers && self.navigationController.viewControllers.count >= 2) {
                 UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                 [controller setBackgroundColorToDashboardColor];
             }
         }
     }];
}


#pragma mark - Time zone selector
- (NSString *)getCurrentTimeZone {
    return [PlaceCapability getTzNameFromModel:[self currentPlace]];
}

- (void)selectTimeZone {
    [self createGif];
    
    if (_timeZonePopup && _timeZonePopup.displaying) {
        [_timeZonePopup close];
    }
    
    NSString *timezoneName = [PlaceCapability getTzNameFromModel:_currentPlace];
    
    if (_timeZones.count == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [AccountController getPlaceTimezones].then(^(NSArray *timezones) {
                _timeZones = [[OrderedDictionary alloc] initWithCapacity:timezones.count];
                
                for (NSDictionary *timezone in timezones) {
                    [_timeZones setObject:timezone forKey:timezone[@"name"]];
                }
                [_timeZones sortArray];
                PopupSelectionTextPickerView *pickerView = [PopupSelectionTextPickerView create:NSLocalizedString(@"Select a time zone", nil) list:_timeZones];
                [self hideGif];
                _timeZonePopup = [PopupSelectionWindow popup:self.view subview:pickerView owner:self closeSelector:@selector(choseTimezone:)];
                [pickerView setCurrentKeyFuzzily:timezoneName];
            });
        });
    }
    else {
        [_timeZones sortArray];
        PopupSelectionTextPickerView *pickerView = [PopupSelectionTextPickerView create:NSLocalizedString(@"Select a time zone", nil) list:_timeZones];
        [self hideGif];
        _timeZonePopup = [PopupSelectionWindow popup:self.view subview:pickerView owner:self closeSelector:@selector(choseTimezone:)];
        [pickerView setCurrentKeyFuzzily:timezoneName];
    }
}

- (void)choseTimezone:(NSDictionary *)timezone {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        double lat = [PlaceCapability getAddrLatitudeFromModel:self.currentPlace];
        double longtitude  = [PlaceCapability getAddrLongitudeFromModel:self.currentPlace];
        [AccountController setTzCoordinates:self.currentPlace
                                       latitude:lat
                                      longitude:longtitude
                                         tzName:timezone[@"id"]
                                       tzOffset:timezone[@"offset"]
                                          tzDST:((NSNumber *)timezone[@"usesDST"]).boolValue];
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlaceCell";
    
    PlaceSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        cell = [[PlaceSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[self.settingsTitles[indexPath.row] uppercaseString] attributes:[FontData getFont:FontDataTypeSettingsText]];
    
    [cell.mainLabel setAttributedText:titleString];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *segueName = nil;
    
    // TEMP Commented out code to remove functionality not include in Beta release.
    /* switch (indexPath.row) {
     case 0:
     segueName = @"editAddressSegue";
     break;
     case 1:
     [self selectTimeZone];
     return;
     case 2:
     segueName = @"";
     break;
     case 3:
     segueName = @"thirdPartySegue";
     break;
     default:
     break;
     } */
    
    switch (indexPath.row) {
        case 0:
            segueName = @"editAddressSegue";
            break;
        case 1:
            [self selectTimeZone];
            break;
        case 2:
            segueName = @"thirdPartySegue";
            break;
        default:
            break;
    }
    
    if (segueName && segueName.length > 0) {
        [self performSegueWithIdentifier:segueName sender:self];
    }
}
#pragma mark: - PlaceModel update notification

- (void)placeUpdated:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshPlaceInfo];
    });
}

- (void)refreshPlaceInfo {
    [self configurePlaceLabels];
    [self.placeAddressLabel setNeedsDisplay];
    [self.placeNameLabel setNeedsDisplay];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
