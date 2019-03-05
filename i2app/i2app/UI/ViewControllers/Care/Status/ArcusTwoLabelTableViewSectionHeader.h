//
//  ArcusTwoLabelTableViewSectionHeader.h
//  i2app
//
//  Created by Arcus Team on 2/4/16.
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

extern NSString *const kArcusTwoLabelTableSectionHeader;

@interface ArcusTwoLabelTableViewSectionHeader : UITableViewHeaderFooterView

//The text label on the left side of the view
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainTextLabelLeadingConstraint;

//The text label on the right side of the view
@property (weak, nonatomic) IBOutlet UILabel *accessoryTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessoryTextLabelTrailingConstraint;

@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurVisualEffectView;
//Setting this property will set the hidden property of the visual effect view to the appropriate value
@property (nonatomic) BOOL hasBlurEffect;

@property (weak, nonatomic) IBOutlet UIView *backingView;

@end
