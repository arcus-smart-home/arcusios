//
//  DebugInfoViewController.m
//  i2app
//
//  Created by Arcus Team on 8/31/15.
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
#import "DebugInfoViewController.h"
#import "PersonCapability.h"

#import "DeviceManager.h"
#import "UIView+Subviews.h"

typedef enum {
    DebugInfoTypeDevVsTest   = 0,
    DebugInfoTypeAppVersion,
    DebugInfoTypeBuildVersion,
    DebugInfoTypeHubId,
    DebugInfoTypeEmail,
    DebugInfoTypeSessionLenght,
    DebugInfoTypeNumberOfDevices
} DebugInfoType;

//#define SHOW_BEFENDER

@interface DebugInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@interface DebugInfoCell: UITableViewCell

- (void)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle;

@end

@interface DebugInfoOnOffCell: UITableViewCell

- (void)setTitle:(NSString *)title withState:(BOOL)isOn;

@end

@interface BugfendrerOnOffCell: UITableViewCell

- (void)setTitle:(NSString *)title withState:(BOOL)isOn;

@end

@implementation DebugInfoViewController

+ (DebugInfoViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DebugInfoViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToParentColor];
    [self navBarWithCloseButtonAndTitle:[NSLocalizedString(@"Debug Info", nil) uppercaseString]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)close:(NSObject *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
#ifdef SHOW_BEFENDER
    return 7;
#else
    return 6;
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    const NSArray *cellTitles = @[ @"Dev Platform URL:", @"Bugfendrer", @"App Version:", @"Build Version:", @"Hub Id:", @"Email:", @"Session began:", @"Number of Devices:" ];
    
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"platformUrlCell";
        cell = (DebugInfoOnOffCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        if (!cell) {
            cell = [DebugInfoOnOffCell new];
        }
//        [((DebugInfoOnOffCell *)cell) setTitle:@"Dev-Test Platform" withState:[AccountController isPlatformUrlDev]];

        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
#ifdef SHOW_BEFENDER
    else if (indexPath.row == 6) {
        // Turn on/off Bugfendrer
        static NSString *CellIdentifier = @"bugfendrerCell";
        cell = (BugfendrerOnOffCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        if (!cell) {
            cell = [BugfendrerOnOffCell new];
        }
        [((BugfendrerOnOffCell *)cell) setTitle:@"Bugfender" withState:[DDBugfenderLogger retrieveBugfenderOnState]];

        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
    }
#endif
    
    else {
        static NSString *CellIdentifier = @"cell";
        cell = (DebugInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if (!cell) {
            cell = [DebugInfoCell new];
            
            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [cell setBackgroundColor:[UIColor clearColor]];
            
        }
        
        NSString *subtitle;
        NSString *title;
        
        switch (indexPath.row) {
            case 1:
                title = @"Version";
                subtitle = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
                break;
                
            case 2:
                title = @"Build";
                subtitle = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
                break;
                
            case 3:
                title = @"Hub ID";
                subtitle = [[CorneaHolder shared] settings].currentHub.modelId;
                break;
                
            case 4:
                title = @"User ID";
                subtitle = [PersonCapability getEmailFromModel:[[CorneaHolder shared] settings].currentPerson];
                break;
                
            case 5:
            {
                title = @"Session Start";
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                [dateFormatter setAMSymbol:@"am"];
                [dateFormatter setPMSymbol:@"pm"];
//                subtitle = [dateFormatter stringFromDate:[AccountController getSessionStartTime]];
            }
                break;
                
            case 6:
                title = @"Device Count";
                subtitle = [NSString stringWithFormat:@"%ld", (unsigned long)[DeviceManager instance].devices.count];
                break;
                
            default:
                subtitle = @"";
                break;
        }
        
        [((DebugInfoCell *)cell) setTitle:title withSubtitle:subtitle];

        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end


#pragma mark - DebugInfoOnOffCell
@interface DebugInfoOnOffCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onOffSwitch;

- (IBAction)switchStateChanged:(id)sender;

@end

@implementation DebugInfoOnOffCell

- (void)setTitle:(NSString *)title withState:(BOOL)isOn {
    self.titleLabel.text = title;
    self.onOffSwitch.on = isOn;
    
    self.onOffSwitch.onTintColor = [UIColor grayColor];
}

- (IBAction)switchStateChanged:(UISwitch *)sender {
//    [AccountController setPlatformUrlToType:sender.on];
//    [AccountController set]
    [[self viewController] displayErrorMessage:@"You need to restart the app to change the platform URL"];
}

@end

#pragma mark - DebugInfoCell
@interface DebugInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end

@implementation DebugInfoCell

- (void)setTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}


@end
