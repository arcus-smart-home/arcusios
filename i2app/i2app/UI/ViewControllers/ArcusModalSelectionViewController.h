//
//  ArcusModalSelectionViewController.h
//  i2app
//
//  Created by Arcus Team on 1/26/16.
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

@class ArcusModalSelectionModel;

/**
 * ArcusModalSeletionDelegate is intended to be implemented by ViewController's acting
 * as the parent of an instance of ArcusModalSelectionViewController.  The delgate provides
 * method definitions for methods that can be used to communicate the selected indexes
 * of the menu back to the parent.
 **/
@protocol ArcusModalSelectionDelegate <NSObject>
@optional

/**
 * Used to communicate that a single selection has been made by the ModalSelectionViewController.
 *  
 * @params - When implemented by class adopting the protocol, the ModalSelectionViewController 
 * will pass a reference of itself, and an ArcusModalSelectionModel for the selected index.
 **/
- (void)modalSelectionController:(UIViewController *)selectionController
    didSelectModalSelectionModel:(ArcusModalSelectionModel *)selectedModel;

/**
 * Used to communicate that a single deselection has been made by the ModalSelectionViewController.
 *
 * @params - When implemented by class adopting the protocol, the ModalSelectionViewController
 * will pass a reference of itself, and an ArcusModalSelectionModel for the deselected index.
 **/
- (void)modalSelectionController:(UIViewController *)selectionController
  didDeselectModalSelectionModel:(ArcusModalSelectionModel *)selectedModel;

/**
 * Used to communicate that the ModalSelectionViewController has been dismissed via the X button.
 *
 * @params - When implemented by class adopting the protocol, the ModalSelectionViewController
 * will pass a reference of itself, and a NSArray of ArcusModalSelectionModels for the selected indexes.
 * (NOTE: Only will return multiple indexes if allowsMultipleSelection = YES)
 **/
- (void)modalSelectionController:(UIViewController *)selectionController
   didDismissWithSelectedModels:(NSArray <ArcusModalSelectionModel *> *)selectedIndexes;

@end

/**
 * ArcusModalSeletionDelegate is intended to be implemented by ViewController's acting
 * as the parent of an instance of ArcusModalSelectionViewController.  The delgate provides
 * method definitions for methods that can be used to configure settings on the ModalSelectionViewController.
 **/
@protocol ArcusModalSelectionConfigurationDelegate <NSObject>
@optional
/**
 * Used to determine if the ModalSelectionViewController should allow no option to be selected.
 * Returning true will mean the user can not deselect an option if it is the last selected option
 * If this is unimplemented the ModalSelectionViewController will assume that having no selection is allowed.
 *
 * @params - When implemented by class adopting the protocol, the ModalSelectionViewController
 * will pass a reference of itself.
 **/
- (BOOL)shouldAllowNoSelectionOnModalSelectionController:(UIViewController *)selectionController;

/**
 * Used to determine if the ModalSelectionViewController should round images in every cell.
 * If this is unimplemented the ModalSelectionViewController will assume that it does not need to round every image.
 *
 * @params - When implemented by class adopting the protocol, the ModalSelectionViewController
 * will pass a reference of itself.
 **/
- (BOOL)shouldRoundAllImagesOnModalSelectionController:(UIViewController *)selectionController;

@end

/**
 * Class is intended to provide a modally presented ViewController that will present 
 * a full screen list of options to select from, and if the delegate is implemented 
 * properly it will report the selected indexs back to the parent viewController.
 *
 * Proper implementation requires the following:
 *  - ArcusModalSelectionViewController instance configured via UIStoryboard.  
 *  - ArcusModalSelectionViewController instance must use the ArcusSelectOptionTableViewCell
 *    as the TableViewCell prototype.
 *  - Parent/Calling class must conform to ArcusModalSelectionDelegate
 **/
@interface ArcusModalSelectionViewController : UIViewController

/**
 * selectionArray is used inthe ArcusModalSelectionViewController.selectionTable's dataSource.
 * In order to use this class, the selectionArray must be set with an Array of ArcusModalSelectionModels.
 **/
@property (nonatomic, strong) NSArray <ArcusModalSelectionModel *> *selectionArray;

/**
 * Enable to allow for multiple rows to be selected.
 **/
@property (nonatomic, assign) BOOL allowMultipleSelection;

/**
 * Delegate used to communicate selection.
 **/
@property (nonatomic, assign) id <ArcusModalSelectionDelegate> delegate;

/**
 * Delegate used to communicate configuration of the ArcusModalSelectionViewControllers.
 **/
@property (nonatomic, weak) id <ArcusModalSelectionConfigurationDelegate> configurationDelegate;

- (void)configurePreselectedRows;

@end
