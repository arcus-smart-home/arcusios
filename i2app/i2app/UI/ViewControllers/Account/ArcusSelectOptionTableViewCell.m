//
//  ArcusSelectOptionTableViewCell.m
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

#import <i2app-Swift.h>
#import "ArcusSelectOptionTableViewCell.h"

@implementation ArcusSelectOptionTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Set to YES by default.  Set to NO in UITableViewDataSource.
        self.managesSelectionState = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (self.managesSelectionState) {
        [self.selectionImage setHighlighted:selected];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:YES];
    
    if (editing) {
        self.selectionImageWidthConstraint.constant = self.selectionImageEditWidth;
        self.selectedImageLeadingSpaceConstraint.constant = self.selectionImageEditLeadingSpace;
        self.selectedImageTrailingSpaceConstraint.constant = self.selectionImageEditTrailingSpace;
    } else {
        self.selectionImageWidthConstraint.constant = self.selectionImageWidth;
        self.selectedImageLeadingSpaceConstraint.constant = self.selectionImageLeadingSpace;
        self.selectedImageTrailingSpaceConstraint.constant = self.selectionImageTrailingSpace;
    }
}

#pragma mark - UI Configuration

- (void)configureSelectionOverlay {
    if (self.selectionImageTapOverlay) {
        if (!self.selectOverlayTapRecognizer) {
            self.selectOverlayTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(selectionImageTapped:)];
            [self.selectionImageTapOverlay addGestureRecognizer:self.selectOverlayTapRecognizer];
        } else {
            [self.selectOverlayTapRecognizer addTarget:self
                                                action:@selector(selectionImageTapped:)];
        }
        
        if (![self.selectionImageTapOverlay.gestureRecognizers containsObject:self.selectOverlayTapRecognizer]) {
            [self.selectionImageTapOverlay addGestureRecognizer:self.selectOverlayTapRecognizer];
        }
    }
}

#pragma mark - IBActions

- (IBAction)selectionImageTapped:(id)sender {
    if (self.selectImageTappedCompletion) {
        self.selectImageTappedCompletion();
    }
}

- (IBAction)accessoryImageTapped:(id)sender {
    if (self.accessoryImageTappedCompletion) {
        self.accessoryImageTappedCompletion();
    }
}

@end
