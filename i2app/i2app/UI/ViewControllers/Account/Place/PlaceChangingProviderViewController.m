//
//  PlaceChangingProviderViewController.m
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
#import "PlaceChangingProviderViewController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "AccountTextField.h"
#import "UIImage+ImageEffects.h"

#pragma mark - PlaceChangingProviderViewController

@interface PlaceChangingProviderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet AccountTextField *enterName;

@property (nonatomic, strong) NSArray *providersArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation PlaceChangingProviderViewController

#pragma mark - View LifeCycle

+ (PlaceChangingProviderViewController *)create {
    PlaceChangingProviderViewController *viewController = [[UIStoryboard storyboardWithName:@"PlaceSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([PlaceChangingProviderViewController class])];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
    [self setBackgroundColorToParentColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self setupView];
    
    self.selectedIndex = -1;
}

#pragma mark - UI Configuration

- (void)setupView {
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gestureRecognizer];
    }

    [_tableView setBackgroundColor:[UIColor clearColor]];

    _enterName.placeholder = [NSLocalizedString(@"Enter Name", nil) uppercaseString];
    _enterName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [_enterName setAccountFieldStyle:AccountTextFieldStyleWhite];
    [_enterName setupType:AccountTextFieldTypeGeneral];
    _enterName.delegate = self;
    
    [_saveButton styleSet:@"Save" andButtonType:FontDataTypeButtonLight upperCase:YES];
}

#pragma mark - Getters & Setters

- (NSArray *)providersArray {
    if (!_providersArray) {
        _providersArray = @[@"Liberty Mutual", @"State Farm Insurance"];
    }
    return _providersArray;
}

#pragma mark - IBActions

- (IBAction)saveButtonPressed:(id)sender {
    if (self.completion != nil) {
        NSString *providerName;
        if (self.selectedIndex != -1 && self.selectedIndex < self.providersArray.count) {
            providerName = self.providersArray[self.selectedIndex];
        }
        else {
            providerName = self.enterName.text;
        }
        self.completion(providerName);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.providersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ProviderOptionsCell";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
    }
    
    cell.managesSelectionState = NO;

    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    NSString *titleString = self.providersArray[indexPath.row];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:titleString.uppercaseString
                                                                    attributes:[FontData getFont:FontDataTypeSettingsText]];
    [cell.titleLabel setAttributedText:titleText];

    cell.selectionImage.image = [UIImage imageNamed:@"CheckmarkEmptyIcon"].invertColor;
    cell.selectionImage.highlightedImage = [UIImage imageNamed:@"CheckMark"].invertColor;
    
    if (indexPath.row == self.selectedIndex) {
        [cell.selectionImage setHighlighted:YES];
    }
    else {
        [cell.selectionImage setHighlighted:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    self.enterName.text = @"";

    [tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    
    if (textField.text.length > 0) {
        self.selectedIndex = -1;
        [self.tableView reloadData];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.y + 64,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height);
    
    [UIView commitAnimations];
}

@end




