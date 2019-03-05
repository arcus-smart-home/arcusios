//
//  ArcusLabel.m
//  i2app
//
//  Created by Arcus Team on 2/1/16.
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
#import "ArcusLabel.h"

@implementation ArcusLabel {

    NSString    *_originalText;
}

#pragma mark - Initializers
//We have to call setText during initWithCoder to ensure that our update label is called when created from the storyboard
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setText:self.text];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setText:self.text];
    }
    return self;
}

#pragma mark - Setters
- (void)setText:(NSString *)text {
    _originalText = text;
    [self updateLabel];
}

- (void)setWideSpacing:(BOOL)wideSpacing {
    _wideSpacing = wideSpacing;
    [self updateLabel];
}

- (void)setAllCaps:(BOOL)allCaps {
    _allCaps = allCaps;
    [self updateLabel];
}

#pragma mark - Helper
- (void)updateLabel {
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.textColor,
                                 NSFontAttributeName: self.font,
                                 NSKernAttributeName: @(self.wideSpacing ? ARCUS_WIDE_KERNING : 0.0f)};
    NSString *stringToAttribute;
    if (_originalText) {
       stringToAttribute = self.allCaps ? _originalText.uppercaseString : _originalText;
    } else {
        stringToAttribute = @"";
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:stringToAttribute attributes:attributes];
    
    [self setAttributedText:attributedString];
}

@end
