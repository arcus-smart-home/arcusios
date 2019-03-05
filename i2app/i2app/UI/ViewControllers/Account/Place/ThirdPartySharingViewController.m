//
//  Place3rdPartySharingViewController.m
//  i2app
//
//  Created by Arcus Team on 8/20/15.
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
#import "ThirdPartySharingViewController.h"
#import "AccountTextField.h"
#import "PlaceSettingsTableViewCell.h"
#import "SettingsTextFieldTableViewCell.h"
#import "PlaceChangingProviderViewController.h"

#define THIRD_PARTY_ROWS 2

@interface ThirdPartySharingViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *thirdPartyTableView;
@property (nonatomic, strong) IBOutlet UIButton *operationButton;
@property (nonatomic, strong) IBOutlet UILabel *mainTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *subTextLabel;

@property (nonatomic, strong) NSString *selectedProvider;

@end

@implementation ThirdPartySharingViewController

#pragma mark - View LifeCycle

+ (ThirdPartySharingViewController *)create {
    ThirdPartySharingViewController *viewController = [[UIStoryboard storyboardWithName:@"PlaceSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ThirdPartySharingViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thirdPartyTableView.backgroundColor = [UIColor clearColor];
    self.thirdPartyTableView.backgroundView = nil;
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    
    [self setBackgroundColorToParentColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self configureHeaderLabels];
    
    [self.operationButton styleSet:@"Accept Terms" andButtonType:FontDataTypeButtonLight upperCase:YES];
    
    self.thirdPartyTableView.scrollEnabled = NO;
    
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gestureRecognizer];
    }
}

#pragma mark - UI Configuration

- (void)configureHeaderLabels {
    self.mainTextLabel.attributedText = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"Renters and homeowners may be\neligible to receive discounts from\ntheir insurance provider by sharing\nlimited information and data.", nil) attributes:[FontData getWhiteFontWithSize:18.0 bold:NO]];
    self.subTextLabel.attributedText = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"By opting in, I agree to share Arcus information\n with the insurance provider selected below.\nExamples of such information may include\nsystem events such as: Device on/off status,\nalerts & notifications, temperature readings\n and open/close statuses of door & window\n sensors. Arcus will never share live camera\n feeds, recordings or snapshots.", nil) attributes:[FontData getFontWithSize:14.0 bold:NO kerning:0.0 color:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]]];
    self.mainTextLabel.numberOfLines = 4;
    self.subTextLabel.numberOfLines = 8;
}

#pragma mark - Setters & Getters

#pragma mark - IBActions

- (IBAction)pressedProvider:(id)sender {
    [self performSegueWithIdentifier:@"changeProviderSegue" sender:self];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    if (indexPath.row == 1) {
        height = 75.0f;
    }
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return THIRD_PARTY_ROWS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cellIdentifier = @"SelectProviderCell";
        
        PlaceSettingsTableViewCell *providerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                   forIndexPath:indexPath];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [providerCell setBackgroundColor:[UIColor clearColor]];
        
        if (!providerCell) {
            providerCell = [[PlaceSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:cellIdentifier];
            
            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [providerCell setBackgroundColor:[UIColor clearColor]];
            
        }
        
        NSAttributedString *policyString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Policy", @"").uppercaseString
                                                                             attributes:[FontData getFont:FontDataTypeSettingsTextFieldPlaceholder]];
        [providerCell.mainLabel setAttributedText:policyString];
        
        if (self.selectedProvider) {
            NSAttributedString *providerString = [[NSAttributedString alloc] initWithString:self.selectedProvider
                                                                                 attributes:[FontData getFont:FontDataTypeSettingsSubTextTranslucent]];
            [providerCell.valueLabel setAttributedText:providerString];
        }
        
        cell = providerCell;
    }
    else {
        cellIdentifier = @"EnterPolicyCell";
        
        SettingsTextFieldTableViewCell *policyCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                     forIndexPath:indexPath];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [policyCell setBackgroundColor:[UIColor clearColor]];
        
        if (!policyCell) {
            policyCell = [[SettingsTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                               reuseIdentifier:cellIdentifier];
            
            //Setting cell background color to clear to override controller settings for cell making white background on iPad:
            [policyCell setBackgroundColor:[UIColor clearColor]];
            
        }
        
        policyCell.textField.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        policyCell.textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        policyCell.textField.floatingLabelActiveTextColor = [UIColor whiteColor];
        policyCell.textField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        policyCell.textField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        
        [policyCell.textField setupType:AccountTextFieldTypeGeneral
                               fontType:FontDataTypeSettingsTextField
                    placeholderFontType:FontDataTypeSettingsTextFieldPlaceholder];
        
        policyCell.textField.delegate = self;
        
        policyCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell = policyCell;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"SelectProviderSegue" sender:self];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.thirdPartyTableView.scrollEnabled = YES;

    [super textFieldDidBeginEditing:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.thirdPartyTableView.scrollEnabled = NO;

    [super textFieldDidEndEditing:textField];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y + 64,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SelectProviderSegue"]) {
        PlaceChangingProviderViewController *viewController = (PlaceChangingProviderViewController *)segue.destinationViewController;
    
        ProviderUpdatedCompletion completion = ^(NSString *selectedProviderName) {
            self.selectedProvider = selectedProviderName;
            [self.thirdPartyTableView reloadData];
        };

        viewController.completion = completion;
    }
}



@end
