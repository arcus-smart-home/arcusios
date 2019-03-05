//
//  SimpleTitleHeader.m
//  i2app
//
//  Created by Arcus Team on 1/27/16.
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
#import "SimpleTitleHeader.h"
#import "UILabel+Extension.h"
#import <PureLayout/PureLayout.h>

@interface SimpleTitleHeader ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheaderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerLabelTopConstraint;

@property (nonatomic) BOOL newStyle;

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *subtitleStr;
@property (weak, nonatomic) UIView *superView;

@end

@implementation SimpleTitleHeader

+ (SimpleTitleHeader *)create:(UIView *)superView {
    SimpleTitleHeader *vc = [[UIStoryboard storyboardWithName:@"SimpleTableHeader" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.superView = superView;
    
    [superView addSubview:vc.view];
    [vc.view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:superView];
    [vc.view autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:superView];
    [vc.view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:superView];
    [vc.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:superView];
    
    return vc;
}
+ (SimpleTitleHeader *)createWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle newStyle:(BOOL)isNewStyle {
    SimpleTitleHeader *vc = [[UIStoryboard storyboardWithName:@"SimpleTableHeader" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.titleStr = title;
    vc.subtitleStr = subtitle;
    vc.newStyle = isNewStyle;
    return vc;
}

- (SimpleTitleHeader *)setTitle:(NSString *)title andSubtitle:(NSString *)subtitle newStyle:(BOOL)isNewStyle {
    self.titleStr = title;
    self.subtitleStr = subtitle;
    self.newStyle = isNewStyle;
    
    [self refresh];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self refresh];
}

- (void)refresh {
    [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    [self.view layoutIfNeeded];
    
    if (self.titleStr && self.titleStr.length > 0) {
        [_headerLabel styleSet:self.titleStr andFontData:[FontData createFontData:FontTypeDemiBold size:18 blackColor:self.newStyle]];
        
        if (_subtitleStr && _subtitleStr.length > 0) {
            if (self.newStyle) {
                if (self.italicSubtitle) {
                    [_subheaderLabel styleSet:_subtitleStr andFontData:[FontData createFontData:FontTypeMediumItalic size:12 blackColor:YES alpha:YES]];
                }
                else {
                    [_subheaderLabel styleSet:_subtitleStr andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:YES alpha:YES]];
                }
            }
            else {
                [_subheaderLabel styleSet:_subtitleStr andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
            }
            
            self.headerLabelTopConstraint.constant = 20;
            
            CGFloat viewHeight = (_subheaderLabel.getNumberOfLines * 15 + _headerLabel.getNumberOfLinesForDoubleSpace * 25) + 50;
            [self.view setFrame:CGRectMake(0, 0, self.superView.frame.size.width, viewHeight)];
            
        } else {
            self.headerLabelTopConstraint.constant = 50 - ((_headerLabel.getNumberOfLinesForDoubleSpace - 1) * 10);
            [_subheaderLabel setText:@""];
        }
    }
}

@end
