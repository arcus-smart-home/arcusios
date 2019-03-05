//
//  PairedHubAlreadyForActionViewController.m
//  i2app
//
//  Created by Arcus Team on 7/21/15.
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
#import "PairedHubAlreadyForActionViewController.h"
#import "HubSuccessViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "PlaceCapability.h"

#import "DevicePairingWizard.h"
#import "DeviceCapability.h"
#import "FoundDevicesViewController.h"

@interface PairedHubAlreadyForActionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PairedHubAlreadyForActionViewController

+ (instancetype)create {
    PairedHubAlreadyForActionViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToParentColor];
    
    [self navBarWithCloseButtonAndTitle:[NSLocalizedString(@"success", nil) uppercaseString]];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    self.tableView.tableHeaderView = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1 / UIScreen.mainScreen.scale)];
        line.backgroundColor = self.tableView.separatorColor;
        line;
    });
    
    //add white overlay
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    // For Pairing Single device where only one device was paired so far,
    // hide the "Next" button and turn off pairing mode and go to Dashboard
    if ([DevicePairingManager sharedInstance].pairingFlowType == PairingFlowTypeAddOneDevice &&
        [DevicePairingManager sharedInstance].justPairedDevices.count == 1) {
        self.nextButton.hidden = YES;
        [[DevicePairingManager sharedInstance] stopHubPairing];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int height = IS_IPHONE_5 ? 65 : 80;
    return height;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PairedHubAlreadyForActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    

    NSString *titleString = @"";
    NSString *contextString = @"";
    
    switch (indexPath.row) {
        case 0:
            titleString = NSLocalizedString(@"SOMEONE WALKED IN THE DOOR", @"");
            contextString = NSLocalizedString(@"Notify me when a door opens.", @"");
            break;
        case 1:
            titleString = NSLocalizedString(@"WHAT'S TRIGGERING THE ALARM?", @"");
            contextString = NSLocalizedString(@"Set camera to record when alarm is triggered.", @"");
            break;
        case 2:
            titleString = NSLocalizedString(@"FORGET THE FLASHLIGHT", @"");
            contextString = NSLocalizedString(@"Turn on a light when something moves.", @"");
            break;
        default:
            break;
    }
    
    [cell setTitle:titleString context:contextString];
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)close:(id)sender {
    [self nextButtonPressed:sender];
}

- (void)nextButtonPressed:(id)sender {
    if (![[DevicePairingManager sharedInstance] areAllDevicesUpdated]) {
        // Check if FoundDevicesViewController is already in the stack
        FoundDevicesViewController *foundVC = (FoundDevicesViewController *)[self findLastViewController:[FoundDevicesViewController class]];
        if (foundVC) {
            [self.navigationController popToViewController:foundVC animated:YES];
        }
        else {
            foundVC = [FoundDevicesViewController create];
            [self.navigationController pushViewController:foundVC animated:YES];
        }
    }
    else {
        [DevicePairingWizard runPostPostPairingWizard:self];
    }
}

@end


#pragma mark - PairedHubAlreadyForActionCell
@implementation PairedHubAlreadyForActionCell {
    
    __weak IBOutlet NSLayoutConstraint *labelToTopOfCellConstraint;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    
    if (IS_IPHONE_5) {
        labelToTopOfCellConstraint.constant = 5;
    }
}

- (void)setTitle:(NSString *)title context:(NSString *)context {
    if (IS_IPHONE_5) {
        [self.mainTextLabel styleSet:title andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    }
    else {
        [self.mainTextLabel styleSet:title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    }
    [self.secondaryTextLabel setText:context];
}

@end
