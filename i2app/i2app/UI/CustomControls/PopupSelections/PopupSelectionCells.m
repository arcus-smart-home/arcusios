//
//  PopupSelectionCells.m
//  i2app
//
//  Created by Arcus Team on 7/23/15.
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
#import "PopupSelectionCells.h"

#pragma mark - PopupSelectionTableCell
@implementation PopupSelectionTableCell

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    if (checked) {
        [_checkIcon setImage:[UIImage imageNamed:@"CheckMark"]];
    }
    else {
        [_checkIcon setImage:[UIImage imageNamed:@"CheckmarkEmptyIcon"]];
    }
}

- (void)setTitle:(NSString *)title withValue:(NSString *)value {
    [_titleLabel styleSet:title andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] upperCase:YES];
    [_valueLabel styleSet:value andButtonType:FontDataType_MediumMedium_12_BlackAlpha_NoSpace];
}

+ (PopupSelectionTableCell *)createCell:(NSString *)title withValue:(NSString *)value {
    NSArray *xibViews = [[NSBundle mainBundle] loadNibNamed:@"PopupSelectionCells" owner:self options:nil];
    PopupSelectionTableCell *cell = [xibViews objectAtIndex:0];
    [cell setTitle:title withValue:value];
    return cell;
}

@end
#pragma mark -


