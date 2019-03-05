//
//  SimpleTableViewController.m
//  i2app
//
//  Created by Arcus Team on 10/7/15.
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
#import "SimpleTableViewController.h"
#import "CommonCheckableCell.h"
#import <PureLayout/PureLayout.h>
#import "UILabel+Extension.h"
#import "SimpleTitleHeader.h"
#import "DeviceController.h"

@implementation SimpleTableCell

+ (SimpleTableCell *)create:(UITableViewCell *)cell withOwner:(id)owner andPressSelector:(SEL)selector {
    SimpleTableCell *tableCell = [[SimpleTableCell alloc] init];
    [tableCell setTableCell:cell];
    [tableCell setOwner:owner];
    [tableCell setPressSelector:selector];
    
    return tableCell;
}

- (void)onPressed {
    if (self.owner && self.pressSelector) {
        [self.owner performSelector:self.pressSelector withObject:nil afterDelay:0];
    }
}

@end



@interface SimpleTableDelegateBase()

@end

@implementation SimpleTableDelegateBase {
    PopupSelectionWindow *_popupWindow;
}

- (void) initializeData {
    
}

- (BOOL)enableScrolling {
    return YES;
}

- (NSString *) getTitle {
    return @"";
}

- (NSString *) getHeaderText {
    return @"";
}

- (NSString *) getSubheaderText {
    return @"";
}

- (NSString *) getFooterText {
    return @"";
}

- (UIView *) getFooterView {
    return [UIView new];
}

- (NSString *) getBottomButtonText {
    return nil;
}

- (void) onClickBottomButton {
    
}

- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView {
    return @[];
}

- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle {
    return @[];
}

- (void)refresh {
    if (self.ownerController) {
        [self.ownerController refresh];
    }
}

- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:_ownerController.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector];
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:_ownerController.view
                                       subview:container
                                         owner:self
                                 closeSelector:selector
                                         style:PopupWindowStyleCautionWindow];
}

- (void)closePopup {
    [_popupWindow close];
    _popupWindow = nil;
}

- (void)initializeView {
    
}

- (SimpleTableViewController *)getOwner {
    return self.ownerController;
}

@end



@interface SimpleTableViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) id<SimpleTableDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL newStyle;
@property (nonatomic) BOOL popupStyle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

@property (strong, nonatomic) SimpleTitleHeader *simpleHeader;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end


@implementation SimpleTableViewController {
    NSArray<SimpleTableCell *> *_cells;
}

+ (SimpleTableViewController *)createPopupStyleWithDelegate:(id<SimpleTableDelegate>)delegate {
    SimpleTableViewController *vc = [self createWithNewStyle:YES andDelegate:delegate];
    vc.popupStyle = YES;
    return vc;
}

+ (SimpleTableViewController *)createWithNewStyle:(BOOL)newStyle andDelegate:(id<SimpleTableDelegate>)delegate {
    SimpleTableViewController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    [vc setDelegate:delegate];
    [vc setTitle:[delegate getTitle]];
    [vc setNewStyle:newStyle];
    if ([delegate isKindOfClass:[SimpleTableDelegateBase class]]) {
        [(SimpleTableDelegateBase *)delegate setOwnerController:vc];
    }
    return vc;
}

+ (SimpleTableViewController *)createWithDelegate:(id<SimpleTableDelegate>)delegate {
    return [self createWithNewStyle:NO andDelegate:delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.delegate initializeData];
    
    [self navBarWithBackButtonAndTitle:[self.delegate getTitle]];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setBackgroundColorToDashboardColor];
    
    [self.closeButton setHidden:!self.popupStyle];
    if (self.popupStyle) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    }
    else if (self.newStyle) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    }
    else {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    }
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.scrollEnabled = [self.delegate enableScrolling];
    
    UIView *footerView = [self.delegate getFooterView];
    if (!footerView) {
        footerView = [UIView new];
    }
    [self.tableView setTableFooterView:footerView];
    
    NSString *bottomButtonText = [self.delegate getBottomButtonText];
    
    if (bottomButtonText.length > 0) {
        self.bottomButton.hidden = NO;
        self.tableViewBottomConstraint.constant = 70;
        
        [self.bottomButton styleSet:bottomButtonText andButtonType: (self.newStyle ? FontDataTypeButtonDark : FontDataTypeButtonLight) upperCase:YES];
    }
    else {
        self.bottomButton.hidden = YES;
        self.tableViewBottomConstraint.constant = 0;
    }
    
    self.simpleHeader = [SimpleTitleHeader create:self.headerView];
    
    // Special case: User forgrounds the app while viewing the table; need to redraw once models are loaded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginComplete:) name:kDeviceListRefreshedNotification object:nil];
    
    [self refresh];
}

- (void)onLoginComplete:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refresh];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.delegate refresh];
}

- (IBAction)onClickBottomButton:(id)sender {
    [self.delegate onClickBottomButton];
}

- (IBAction)onClickClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {
    NSString *headerText = [self.delegate getHeaderText];
    if (headerText && headerText.length > 0) {
        if (self.simpleHeader) {
            [self.simpleHeader setTitle:headerText andSubtitle:[self.delegate getSubheaderText] newStyle:self.newStyle];;
            [self.simpleHeader refresh];
            self.headerView.frame = self.simpleHeader.view.frame;
        }
        [self.headerView sizeToFit];
        [self.tableView setTableHeaderView:self.headerView];
    }
    else {
        [self.tableView setTableHeaderView:[UITableView new]];
    }
    _cells = [self.delegate getTableCells:self.tableView withStyleNew:self.newStyle];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTableCell *cell = [_cells objectAtIndex:indexPath.row];
    return cell.tableCell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTableCell *cell = [_cells objectAtIndex:indexPath.row];
    if (cell.forceCellHeight > 0) {
        return cell.forceCellHeight;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTableCell *cell = [_cells objectAtIndex:indexPath.row];
    if (cell.forceCellHeight > 0) {
        return cell.forceCellHeight;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SimpleTableCell *cell = [_cells objectAtIndex:indexPath.row];
    if (cell.owner && cell.pressSelector) {
        if ([cell.owner respondsToSelector:cell.pressSelector]) {
            [cell.owner performSelector:cell.pressSelector withObject:cell afterDelay:0];
        }
    }
}

@end
