//
//  SecurityTableViewController.m
//  i2app
//
//  Created by Arcus Team on 4/29/15.
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
#import "SecurityTableViewController.h"
#import "UIViewController+BackgroundColor.h"

@interface SecurityTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SecurityTableViewController

#pragma mark - Life Cycle
+ (SecurityTableViewController *)create {
    return [[UIStoryboard storyboardWithName:@"CreateAccount" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([SecurityTableViewController class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Security Questions", nil) uppercaseString]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setBackgroundColorToParentColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    UIColor *separatorColor = self.viewMode == ViewModeSettingsChange ? [[UIColor whiteColor] colorWithAlphaComponent:0.4f] : [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    self.tableView.separatorColor = separatorColor;
    [self.tableView setTableFooterView:[UIView new]];
}

#pragma mark - Defaults

- (SecurityQuestionsViewMode)viewMode {
    if (!_viewMode) {
        _viewMode = ViewModeAccountCreation;
    }
    return _viewMode;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL allowSelection = YES;
    
    NSString *selectedQuestion = _dataSource[indexPath.row];
    
    if ([self.currentSelections containsObject:selectedQuestion]) {
        if (![selectedQuestion isEqualToString:self.selectedButton.titleLabel.text]) {
            allowSelection = NO;
        }
    }
    
    if (allowSelection) {
        FontDataType fontType = (self.viewMode == ViewModeSettingsChange) ? FontDataTypeSettingsSubTextTranslucent : FontDataTypeAccountSubText;
        
        [self.selectedButton setAttributedTitle:[FontData getString:selectedQuestion withFont:fontType] forState:UIControlStateNormal];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private Methods

- (BOOL)isSelectedQuestion:(NSString *)theQuestion {
    for (NSString *question in _currentSelections) {
        if ([question isEqualToString:theQuestion]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *question = _dataSource[indexPath.row];
    
    if ([self isSelectedQuestion:question]) {
        [self configureViewSelectedCell:cell withQuestion:question];
    }
    else {
        [self configureViewNormalCell:cell withQuestion:question];
    }
}

- (void)configureViewSelectedCell:(UITableViewCell *)cell withQuestion:(NSString *)question {
    cell.textLabel.attributedText = [FontData getString:question withFont:FontDataTypeAccountSubTextWithOpacity];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.viewMode == ViewModeSettingsChange) {
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell setTintColor:[[UIColor whiteColor] colorWithAlphaComponent: 0.6]];
    }
    else {
        [cell setTintColor:[[UIColor blackColor] colorWithAlphaComponent: 0.3]];
    }
}

- (void)configureViewNormalCell:(UITableViewCell *)cell withQuestion:(NSString *)question {
    cell.textLabel.attributedText = [FontData getString:question withFont:FontDataTypeAccountSubText];
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (self.viewMode == ViewModeSettingsChange) {
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell setTintColor:[UIColor whiteColor]];
    }
    else {
        [cell setTintColor:[UIColor blackColor]];
    }
}

@end


