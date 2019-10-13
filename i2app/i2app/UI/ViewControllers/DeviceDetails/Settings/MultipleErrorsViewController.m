//
//  MultipleErrorsViewController.m
//  i2app
//
//  Created by Arcus Team on 10/13/15.
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
#import "MultipleErrorsViewController.h"
#import "DeviceController.h"
#import "i2app-Swift.h"

@interface MultipleErrorsViewControllerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation MultipleErrorsViewControllerCell

- (void)setErrorMessage:(NSString *)errorMessage {
    [_errorLabel styleSet:errorMessage andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO]];
}

@end


@interface MultipleErrorsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *callingButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DeviceModel *deviceModel;

@property (strong, nonatomic) NSArray *errorList;
@property (nonatomic) BOOL isHeaderVisible;

@end

@implementation MultipleErrorsViewController

+ (MultipleErrorsViewController *)createWithErrorList:(NSArray*)errorList {
    MultipleErrorsViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.errorList = errorList;
    vc.isHeaderVisible = YES;
    return vc;
}

+ (MultipleErrorsViewController *)createWithErrorList:(NSArray*)errorList withHeaderVisible:(BOOL)isHeaderVisible {
    MultipleErrorsViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.errorList = errorList;
    vc.isHeaderVisible = isHeaderVisible;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"ERRORS", nil) uppercaseString]];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    
    [self.callingButton styleSet:@"1-0" andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO space:YES]];
    self.callingButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.callingButton.layer.borderWidth = 1.0f;
    self.callingButton.layer.cornerRadius = 6.0f;
    [self.callingButton addTarget:self action:@selector(onClickCall) forControlEvents:UIControlEventTouchUpInside];

    if (!self.isHeaderVisible) {
        self.tableView.tableHeaderView = nil;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];    
    self.navigationController.navigationBar.barTintColor = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.navigationController.navigationBar.barTintColor = [Appearance errorPink];
    self.navigationController.navigationBar.translucent = YES;
    
    for (UINavigationItem *item in self.navigationController.navigationBar.subviews) {
        if ([item isKindOfClass:[UILabel class]]) {
            [((UILabel *)item) setTextColor:[UIColor whiteColor]];
        }
        if ([item isKindOfClass:[UIButton class]]) {
            ((UIButton *)item).imageView.image = [((UIButton *)item).imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [((UIButton *)item).imageView setTintColor:[UIColor whiteColor]];
            [((UIButton *)item) setImage:((UIButton *)item).imageView.image forState:UIControlStateNormal];
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onClickCall {
    // This will need to be addressed if support is added.
//    NSURL *phoneUrl = [NSURL URLWithString:@"tel://+18887756937"];
//
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    }
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _errorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultipleErrorsViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell setErrorMessage:[_errorList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
