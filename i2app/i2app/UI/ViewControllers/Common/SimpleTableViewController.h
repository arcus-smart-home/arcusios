//
//  SimpleTableViewController.h
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

#import <UIKit/UIKit.h>
#import "PopupSelectionBaseContainer.h"

@interface SimpleTableCell : NSObject

@property (strong, nonatomic) UITableViewCell *tableCell;
@property (strong, nonatomic) id owner;
@property (assign) SEL pressSelector;
@property (strong, nonatomic) NSObject *dataObject;
@property (assign, nonatomic) CGFloat forceCellHeight;

+ (SimpleTableCell *)create:(UITableViewCell *)cell withOwner:(id)owner andPressSelector:(SEL)selector;

@end

@protocol SimpleTableDelegate <NSObject>

@required
- (void)initializeData;
- (BOOL)enableScrolling;
- (NSString *)getTitle;
- (NSString *)getHeaderText;
- (NSString *)getSubheaderText;
- (NSString *)getFooterText;
- (UIView *)getFooterView;
- (NSString *)getBottomButtonText;
- (void)onClickBottomButton;
- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle;

@optional
- (void)refresh;

@end

@class SimpleTableViewController;

@interface SimpleTableDelegateBase : NSObject<SimpleTableDelegate>

@property (strong, nonatomic) SimpleTableViewController *ownerController;

// Override
- (void)initializeData;
- (NSString *)getTitle;
- (NSString *)getHeaderText;
- (NSString *)getSubheaderText;
- (NSString *)getFooterText;
- (UIView *)getFooterView;
- (NSString *)getBottomButtonText;
- (void)onClickBottomButton;
- (NSArray<SimpleTableCell *> *) getTableCells:(UITableView *)tableView withStyleNew:(BOOL)newStyle;

// Assist methods
- (void)refresh;
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector;
- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector;
- (void)closePopup;
- (SimpleTableViewController *)getOwner;

- (void)initializeView;
@end

@interface SimpleTableViewController : UIViewController

+ (SimpleTableViewController *)createPopupStyleWithDelegate:(id<SimpleTableDelegate>)delegate;
+ (SimpleTableViewController *)createWithNewStyle:(BOOL)newStyle andDelegate:(id<SimpleTableDelegate>)delegate;
+ (SimpleTableViewController *)createWithDelegate:(id<SimpleTableDelegate>)delegate;

@property (strong, nonatomic) PopupSelectionWindow *popupWindow;

- (void)refresh;

@end
