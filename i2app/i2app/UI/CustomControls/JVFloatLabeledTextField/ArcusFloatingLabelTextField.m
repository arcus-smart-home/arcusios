//
//  ArcusFloatingLabelTextField.m
//  i2app
//
//  Arcus Team on 6/1/17.
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
#import <Foundation/Foundation.h>
#import "ArcusFloatingLabelTextField.h"

@implementation ArcusFloatingLabelTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
  
    if (self) {
        [self initColorsAndBaseline];
    }
  
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
  
    if (self) {
        [self initColorsAndBaseline];
    }
  
    return self;
}

- (void)initColorsAndBaseline {

        // Set default label colors
        [super setFloatingLabelTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.3f]];
        [super setFloatingLabelActiveTextColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];

        // Add baseline under text
        self.separatorView = [[UIView alloc]init];
        self.separatorView.backgroundColor = self.separatorColor;
        [super addSubview:self.separatorView];
}

- (void)setFloatingLabelText:(NSString *)text {

    if (text != nil) {
        if (self.activatedFontAttributed && self.activatedFontAttributed.count > 0) {
            super.floatingLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:self.activatedFontAttributed];
        }
        else {
            super.floatingLabel.attributedText = [FontData getString:text withFont:FontDataTypeFloatingLabelFont];
        }
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
    _separatorView.frame = CGRectMake(super.floatingLabel.frame.origin.x + 2, self.frame.size.height - 1.0f,
                                      self.frame.size.width-super.floatingLabel.frame.origin.x * 2.0f - 1, 1.0f);

    _separatorView.backgroundColor = (super.isFirstResponder) ? self.activeSeparatorColor : self.separatorColor;

    super.floatingLabel.adjustsFontSizeToFitWidth = YES;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return _separatorColor;
}

- (UIColor *)activeSeparatorColor {
    if (!_activeSeparatorColor) {
        _activeSeparatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    }
    return _activeSeparatorColor;
}

- (void)showFloatingLabel:(BOOL)animated {
    void (^showBlock)() = ^{
        super.floatingLabel.alpha = 1.0f;
        super.floatingLabel.frame = CGRectMake(super.floatingLabel.frame.origin.x,
                                          super.floatingLabelYPadding,
                                          super.floatingLabel.frame.size.width,
                                          super.floatingLabel.frame.size.height);
    };
    
    if (animated || 0 != super.animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:super.floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

@end
