//
//  PopupSelectionSearching.m
//  i2app
//
//  Created by Arcus Team on 1/19/16.
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
#import "PopupSelectionSearching.h"

@interface PopupSelectionSearching ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImage;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *subtitleStr;

@end

@implementation PopupSelectionSearching

+ (PopupSelectionSearching *)create:(NSString *)title subtitle:(NSString *)subtitle {
    PopupSelectionSearching *selection = [[PopupSelectionSearching alloc] initWithNibName:@"PopupSelectionSearching" bundle:nil];
    selection.titleStr = title;
    selection.subtitleStr = subtitle;
    
    return selection;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleLabel styleSet:self.titleStr andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:YES space:YES] upperCase:YES];
    [self.subtitleLabel styleSet:self.subtitleStr andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:YES alpha:YES]];
}


@end
