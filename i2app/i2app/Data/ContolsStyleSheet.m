//
//  ContolsStyleSheet.m
//  i2app
//
//  Created by Arcus Team on 6/19/15.
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
#import "ContolsStyleSheet.h"

@interface FontData()

- (NSDictionary *)getFontDictionary;

@end

@implementation UIButton (StyleSheet)

- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata {
    [self styleSet:text andFontData:fontdata upperCase:NO];
}
- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[fontdata getFontDictionary]];
    [self setAttributedTitle:attribute forState:UIControlStateNormal];
}



- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type {
    [self styleSet:text andButtonType:type upperCase:NO];
}

- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    [self setAttributedTitle:[FontData getString:value withFont:type] forState:UIControlStateNormal];
    switch (type) {
        case FontDataTypeButtonDark:
            self.layer.cornerRadius = 4.0f;
            self.backgroundColor = [UIColor blackColor];
            break;
        case FontDataTypeButtonLight:
            self.layer.cornerRadius = 4.0f;
            self.backgroundColor = [UIColor whiteColor];
            break;
        case FontDataTypeButtonPink:
            self.layer.cornerRadius = 4.0f;
            self.backgroundColor = pinkAlertColor;
            break;
        default:
            break;
    }
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold {
    [self styleSetWithSpace:text andFontSize:size bold:bold upperCase:NO];
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getFontWithSize:size bold:bold kerning:2.0f color:(alpha?[[UIColor blackColor] colorWithAlphaComponent:0.6f] : [UIColor blackColor])]];
    [self setAttributedTitle:attribute forState:UIControlStateNormal];
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getWhiteFontWithSize:size bold:bold kerning:2.0f]];
    [self setAttributedTitle:attribute forState:UIControlStateNormal];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold {
    [self styleSet:text andFontSize:size bold:bold upperCase:NO];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getFontWithSize:size bold:bold kerning:1.0f color:(alpha?[[UIColor blackColor] colorWithAlphaComponent:0.6f] : [UIColor blackColor])]];
    [self setAttributedTitle:attribute forState:UIControlStateNormal];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getWhiteFontWithSize:size bold:bold]];
    [self setAttributedTitle:attribute forState:UIControlStateNormal];
}

@end


@implementation UILabel (StyleSheet)

- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata {
    [self styleSet:text andFontData:fontdata upperCase:NO];
}
- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    [self setAttributedText:[[NSAttributedString alloc] initWithString:value attributes:[fontdata getFontDictionary]]];
}

- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type {
    [self styleSet:text andButtonType:type upperCase:NO];
}

- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    [self setAttributedText:[FontData getString:value withFont:type]];
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold {
    [self styleSetWithSpace:text andFontSize:size bold:bold upperCase:NO];
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getFontWithSize:size bold:bold kerning:2.0f color:(alpha?[[UIColor blackColor] colorWithAlphaComponent:0.6f] : [UIColor blackColor])]];
    [self setAttributedText:attribute];
}

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getBlackFontWithSize:size bold:bold kerning:2.0f]];
    [self setAttributedText:attribute];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold {
    [self styleSet:text andFontSize:size bold:bold upperCase:NO];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getFontWithSize:size bold:bold kerning:1.0f color:(alpha?[[UIColor blackColor] colorWithAlphaComponent:0.6f] : [UIColor blackColor])]];
    [self setAttributedText:attribute];
}

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase {
    NSString *value = uppercase ? [NSLocalizedString(text, nil) uppercaseString] : NSLocalizedString(text, nil);
    
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:value attributes:[FontData getBlackFontWithSize:size bold:bold]];
    [self setAttributedText:attribute];
}

@end
