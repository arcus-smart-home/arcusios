//
//  PersonCallTreeListViewController.h
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

#import <UIKit/UIKit.h>

@class PopupSelectionWindow;

/**
 *  In order to use the PersonCallTreeListViewController, the SubsystemController
 *  responsible for providing data for the call tree MUST implement the PersonCallTreeDataProtocol.
 *  Protocol will allow for getting/setting the callTree as well as will enable monitoring of 
 *  eventChange Notifications
 **/
@protocol PersonCallTreeDataProtocol <NSObject>
@required

- (void)addChangeEventNotifiationObserver:(id)observer
                                 selector:(SEL)aSelector;
- (void)removeChangeEventNotifiationObserver:(id)observer
                                    selector:(SEL)aSelector;

- (NSArray *)fetchPersonCallTree;
- (void)saveUpdatedPersonCallTree:(NSArray *)callTree;

@end

@interface PersonCallTreeListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *callTreeTableView;
@property (nonatomic, strong) PopupSelectionWindow *popupWindow;
@property (nonatomic, strong) NSArray *callTreeList;  // Array of all people allowed in callTree
@property (nonatomic, strong) NSArray *activeCallTreeList; // Array of all active people allowed in callTree

@property (nonatomic, assign) id <PersonCallTreeDataProtocol> delegate;

/**
 *  Enabled by default to support editing.  Set to NO to disable.
 **/
@property (nonatomic, assign) BOOL allowEditing;

/**
 *  String property used to set the edit title for the editDoneButton
 **/
@property (nonatomic, strong) NSString *editButtonTitle;

/**
 *  String property used to set the done title for the editDoneButton
 **/
@property (nonatomic, strong) NSString *doneButtonTitle;

/**
 *  Used to limit the number of people that can be enabled in a particular callTree
 **/
@property (nonatomic, assign) NSInteger enabledMaximumCount;

@end
