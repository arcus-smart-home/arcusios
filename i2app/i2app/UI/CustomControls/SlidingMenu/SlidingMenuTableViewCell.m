//
//  SlidingMenuTableViewCell.m
//  i2app
//
//  Created by Arcus Team on 5/19/15.
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
#import "SlidingMenuTableViewCell.h"

@interface SlidingMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation SlidingMenuTableViewCell


#pragma mark - Life Cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setAllLabelToEmpty];
    
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)initializeCellWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle withImageNamed:(NSString *)imageName {
    
    self.mainLabel.text = title;
    self.secondaryLabel.text = subtitle;
    self.image.image = [UIImage imageNamed:imageName];
    [self.image setTintColor:[UIColor blackColor]];
}

@end
