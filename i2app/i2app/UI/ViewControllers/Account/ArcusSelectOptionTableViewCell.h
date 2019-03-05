//
//  ArcusSelectOptionTableViewCell.h
//  i2app
//
//  Created by Arcus Team on 8/21/15.
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
#import "ArcusLabel.h"

typedef void(^SelectOptionCellImageTappedCompletion)(void);

@interface ArcusSelectOptionTableViewCell : UITableViewCell

/**
 *  UIImageView used to display cell selection icon.
 **/
@property (nonatomic, weak) IBOutlet UIImageView *selectionImage;

/**
 *  UIImageView used to display detail image of the data being show. 
 *  i.e. a Person/Device Image
 **/
@property (nonatomic, weak) IBOutlet UIImageView *detailImage;

/**
 *  UIImageView used to display a custom cell accessory image.
 **/
@property (nonatomic, weak) IBOutlet UIImageView *accessoryImage;

/**
 *  Main UILabel of the cell.  Used to display cell title.
 **/
@property (nonatomic, weak) IBOutlet ArcusLabel *titleLabel;

/**
 *  Sub UILabel of the cell; used to display descriptive text.
 **/
@property (nonatomic, weak) IBOutlet ArcusLabel *descriptionLabel;

/**
 *  The selectionImage is not a button, and has no action assigned on tap.
 *  If the cell needs to have a specific action for when the selection image is tapped
 *  vs. when the entire cell is tapped, then an empty and transparent overlay should
 *  be placed over the selectionImage to allow for an assignable area of the view to 
 *  have it's own action carried out by UITapGestureRecognizer.
 **/
@property (nonatomic, weak) IBOutlet UIView *selectionImageTapOverlay;

/**
 *  UITapGestureRecognizer used in conjunction with the selectionImageTapOverlay to
 *  allow for a separate action to be triggered when the selectionImageTapOverlay is 
 *  tapped.
 **/
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *selectOverlayTapRecognizer;

/**
 *  NSLayoutConstraint used to determine the width of the selectionImage.  
 *  This outlet is ONLY necessary when supporting an 'Edit' mode for the cell, and 
 *  is used to help show/hide or reposition the image as necessary.
 **/
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectionImageWidthConstraint;

/**
 *  NSLayoutConstraint used to determine the leading space of the selectionImage.
 *  This outlet is ONLY necessary when supporting an 'Edit' mode for the cell, and
 *  is used to help show/hide or reposition the image as necessary.
 **/
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectedImageLeadingSpaceConstraint;

/**
 *  NSLayoutConstraint used to determine the trailing space of the selectionImage.
 *  This outlet is ONLY necessary when supporting an 'Edit' mode for the cell, and
 *  is used to help show/hide or reposition the image as necessary.
 **/
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *selectedImageTrailingSpaceConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLeftConstraint;

/**
 *  Instead of implementing a delegate protocol, the cell uses SelectOptionCellImageTappedCompletion
 *  blocks to initiate callbacks to the owning UITableViewDataSource/Delegate
 *
 *  The selectImageTappedCompletion is used to communicate that the selectionImage has been tapped.
 **/
@property (nonatomic, copy) SelectOptionCellImageTappedCompletion selectImageTappedCompletion;

/**
 *  Instead of implementing a delegate protocol, the cell uses SelectOptionCellImageTappedCompletion
 *  blocks to initiate callbacks to the owning UITableViewDataSource/Delegate
 *
 *  The accessoryImageTappedCompletion is used to communicate that the accessoryImage has been tapped.
 **/
@property (nonatomic, copy) SelectOptionCellImageTappedCompletion accessoryImageTappedCompletion;

/**
 *  Property used to specify the selectionImage's width when not being editted.
 *  This property must be implemented in order to properly support changes in 
 *  the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageWidth;

/**
 *  Property used to specify the selectionImage's leadingSpaceConstraint's constant
 *  when not being editted. This property must be implemented in order to properly 
 *  support changes in the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageLeadingSpace;

/**
 *  Property used to specify the selectionImage's trailingSpaceConstraint's constant
 *  when not being editted. This property must be implemented in order to properly
 *  support changes in the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageTrailingSpace;

/**
 *  Property used to specify the selectionImage's width whle being editted.
 *  This property must be implemented in order to properly support changes in
 *  the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageEditWidth;

/**
 *  Property used to specify the selectionImage's editLeadingSpaceConstraint's constant
 *  while being editted. This property must be implemented in order to properly
 *  support changes in the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageEditLeadingSpace;

/**
 *  Property used to specify the selectionImage's editTrailingSpaceConstraint's constant
 *  while being editted. This property must be implemented in order to properly
 *  support changes in the selectionImage during editing.
 **/
@property (nonatomic, assign) NSInteger selectionImageEditTrailingSpace;

@property (nonatomic, assign) BOOL managesSelectionState;

- (IBAction)selectionImageTapped:(id)sender;
- (IBAction)accessoryImageTapped:(id)sender;

- (void)configureSelectionOverlay;

@end
