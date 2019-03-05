//
//  PersonCallTreeListViewController.m
//  i2app
//
//  Created by Arcus Team on 2/22/16.
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
#import "PersonCallTreeListViewController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "PersonCallTreeListItem.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionWindow.h"

@interface PersonCallTreeListViewController ()

@end

@implementation PersonCallTreeListViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Call Tree Editing is Enabled by Default. Override to disable.
    self.allowEditing = YES;
    
    // Defaults to 10 active people allowed in call tree.
    self.enabledMaximumCount = 10;
    
    [self navBarWithBackButtonAndTitle:self.title];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController) {
        [self addChangeEventNotifiationObservers];

        if (self.allowEditing) {
            [self navBarWithTitle:self.title
               andRightButtonText:NSLocalizedString(@"Edit", nil)
                     withSelector:@selector(editDoneButtonPressed:)];
        }
    } else if (self.isMovingFromParentViewController) {
        [self removeChangeEventNotifiationObservers];
    }
}

#pragma mark - Notification Handling

- (void)addChangeEventNotifiationObservers {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(addChangeEventNotifiationObserver:selector:)]) {
        [self.delegate addChangeEventNotifiationObserver:self
                                                selector:@selector(callTreeChangeEventReceived:)];
    }
}

- (void)removeChangeEventNotifiationObservers {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(removeChangeEventNotifiationObserver:selector:)]) {
        [self.delegate removeChangeEventNotifiationObserver:self
                                                   selector:@selector(callTreeChangeEventReceived:)];
    }
}

- (void)callTreeChangeEventReceived:(NSNotification *)notification {
    self.activeCallTreeList = nil;
    self.callTreeList = [self fetchCallTree];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.callTreeTableView reloadData];
    });
}

#pragma mark - Getters & Setters

- (NSArray *)callTreeList {
    if (!_callTreeList) {
        _callTreeList = [self fetchCallTree];
    }
    return _callTreeList;
}

- (NSArray *)activeCallTreeList {
    if (!_activeCallTreeList) {
        NSMutableArray *mutableCallTree = [[NSMutableArray alloc] init];
        
        for (PersonCallTreeListItem *callTreeListItem in self.callTreeList) {
            if (callTreeListItem.isEnabled) {
                [mutableCallTree addObject:callTreeListItem];
            }
        }
        
        _activeCallTreeList = [NSArray arrayWithArray:mutableCallTree];
    }
    
    return _activeCallTreeList;
}

#pragma mark - UI Configuration & Manipulation

- (void)updateEditDoneButtonState:(BOOL)isEditing {
    if (isEditing) {
        [self navBarWithTitle:self.title
           andRightButtonText:self.doneButtonTitle
                 withSelector:@selector(editDoneButtonPressed:)];
    } else {
        [self navBarWithTitle:self.title
           andRightButtonText:self.editButtonTitle
                 withSelector:@selector(editDoneButtonPressed:)];
        
    }
}

- (BOOL)allowUpdateToCallTreeItem:(PersonCallTreeListItem *)callTreeItem {
    BOOL allowUpdate = YES;
    
    if (!callTreeItem.isEnabled &&
        ([self.activeCallTreeList count] >= self.enabledMaximumCount)) {
        allowUpdate = NO;
    }
    
    return allowUpdate;
}

- (void)displayMaximumAllowedErrorMessage {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Reached the limit of enabled people", nil) subtitle:[NSString stringWithFormat:@"You can only enable up to %i people", (int)self.enabledMaximumCount] button:nil];
    buttonView.owner = self;
    
    self.popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:buttonView
                                             owner:self
                                     closeSelector:nil
                                             style:PopupWindowStyleCautionWindow];
}

#pragma mark - Data I/O

- (NSArray *)fetchCallTree {
    NSMutableArray *mutableCallTree = [[NSMutableArray alloc] init];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fetchPersonCallTree)]) {
        NSArray *fetchedCallTree = [self.delegate fetchPersonCallTree];
        for (NSDictionary *callTreeInfo in fetchedCallTree) {
            PersonCallTreeListItem *listItem = [PersonCallTreeListItem callTreeItemWithInfo:callTreeInfo];
        
            if (listItem) {
                [mutableCallTree addObject:listItem];
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableCallTree];
}

- (void)saveUpdatedCallTree {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveUpdatedPersonCallTree:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.delegate saveUpdatedPersonCallTree:[self callTreeSubmissionArray]];
        });
    }
}

- (NSArray *)callTreeSubmissionArray {
    NSMutableArray *mutableCallTree = [[NSMutableArray alloc] init];
    
    for (PersonCallTreeListItem *callTreeItem in self.callTreeList) {
        [mutableCallTree addObject:[callTreeItem callTreeInfo]];
    }
    
    return [NSArray arrayWithArray:mutableCallTree];
}

#pragma mark - IBActions

- (IBAction)editDoneButtonPressed:(id)sender {
    [self.callTreeTableView setEditing:![self.callTreeTableView isEditing]];
    
    BOOL isEditing = [self.callTreeTableView isEditing];
    
    [self updateEditDoneButtonState:isEditing];

    if (!isEditing) {
        // Editing completed, update callTree is necessary
        self.activeCallTreeList = nil;
        [self saveUpdatedCallTree];
    }

    [self.callTreeTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (tableView.isEditing) {
        rows = [self.callTreeList count];
    } else {
        rows = [self.activeCallTreeList count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationListCell"];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"notificationListCell"];
    }
    
    PersonCallTreeListItem *callTreeItem = (tableView.isEditing) ? self.callTreeList[indexPath.row] : self.activeCallTreeList[indexPath.row];
    if (callTreeItem) {
        [cell.titleLabel setText:callTreeItem.name];
        
        if (callTreeItem.image) {
            [cell.detailImage setImage:callTreeItem.image];
        } else {
            [cell.detailImage setImage:[UIImage imageNamed:@"userIcon"]];
        }
    }
    
    cell.managesSelectionState = NO;
    
    [cell setEditing:tableView.isEditing animated:YES];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (tableView.isEditing) {
        [cell.selectionImage setHighlighted:callTreeItem.isEnabled];
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray *mutableCallTree = [[NSMutableArray alloc] initWithArray:self.callTreeList];
    
    PersonCallTreeListItem *callTreeListItem = mutableCallTree[sourceIndexPath.row];
    
    [mutableCallTree removeObjectAtIndex:sourceIndexPath.row];
    [mutableCallTree insertObject:callTreeListItem atIndex:destinationIndexPath.row];
    
    self.callTreeList = [NSArray arrayWithArray:mutableCallTree];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.allowEditing;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        PersonCallTreeListItem *callTreeItem = self.callTreeList[indexPath.row];
        if ([self allowUpdateToCallTreeItem:callTreeItem]) {
            callTreeItem.isEnabled = !callTreeItem.isEnabled;
            
            [tableView reloadData];
        } else {
            [self displayMaximumAllowedErrorMessage];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
