//
//  FontData.m
//  i2app
//
//  Created by Arcus Team on 6/8/15.
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
#import "FontData.h"
#import "SubsystemsController.h"
#import <i2app-Swift.h>

NSString *const kAvenirNextDemiBold = @"AvenirNext-DemiBold";

@interface FontData()

@property (nonatomic) FontType fontType;
@property (nonatomic) float size;
@property (nonatomic) BOOL blackColor;
@property (nonatomic) BOOL space;
@property (nonatomic) BOOL alpha;
@property (nonatomic) BOOL underline;


@end


@implementation FontData

+ (FontData *)createFontData:(FontType)fontType size:(float)size {
    return [self createFontData:fontType size:size blackColor:YES space:NO alpha:NO underline:NO];
}
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor {
    return [self createFontData:fontType size:size blackColor:blackColor space:NO alpha:NO underline:NO];
}
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor alpha:(BOOL)alpha {
    return [self createFontData:fontType size:size blackColor:blackColor space:NO alpha:alpha underline:NO];
}
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space {
    return [self createFontData:fontType size:size blackColor:blackColor space:space alpha:NO underline:NO];
}
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space alpha:(BOOL)alpha {
    return [self createFontData:fontType size:size blackColor:blackColor space:space alpha:alpha underline:NO];
}
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space alpha:(BOOL)alpha underline:(BOOL)underline {
    FontData *font = [[FontData alloc] init];
    font.fontType = fontType;
    font.size = size;
    font.blackColor = blackColor;
    font.space = space;
    font.alpha = alpha;
    font.underline = underline;
    return font;
}


- (NSDictionary *)getFontDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *fontName = FontTypeToFontString(_fontType);
    [dic setObject:[UIFont fontWithName:fontName size:_size] forKey:NSFontAttributeName];
    if (_blackColor) {
        if (_alpha) {
            [dic setObject:[[UIColor blackColor] colorWithAlphaComponent:0.6] forKey:NSForegroundColorAttributeName];
        }
        else {
            [dic setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        }
    }
    else {
        if (_alpha) {
            [dic setObject:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forKey:NSForegroundColorAttributeName];
        }
        else {
            [dic setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        }
    }
    
    if (_space) {
        [dic setObject:@(2.0f) forKey:NSKernAttributeName];
    }
    if (_underline) {
        [dic setObject:@(NSUnderlineStyleSingle) forKey:NSUnderlineStyleAttributeName];
    }
    
    return dic;
}

- (NSAttributedString *)getFontAttributed:(NSString *)text {
    if (!text || [text isEqual:[NSNull null]]) {
        text = @"";
    }
    text = NSLocalizedString(text, nil);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:[self getFontDictionary]];
    return attributedString;
}

+ (NSDictionary *)getItalicFontWithColor:(UIColor *)fontColor size:(float)size kerning:(float)kerning {
    return @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-MediumItalic" size:size],
             NSKernAttributeName : @(kerning),
             NSForegroundColorAttributeName : fontColor};
}

+ (NSDictionary *)getWhiteFontWithSize:(float)size bold:(BOOL)bold {
    return [self getWhiteFontWithSize:size bold:bold kerning:0.0f];
}

+ (NSDictionary *)getWhiteFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning {
    return [self getFontWithSize:size bold:bold kerning:kerning color:[UIColor whiteColor]];
}

+ (NSDictionary *)getBlackFontWithSize:(float)size bold:(BOOL)bold {
    return [self getBlackFontWithSize:size bold:bold kerning:0.0f];
}

+ (NSDictionary *)getBlackFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning {
    return [self getFontWithSize:size bold:bold kerning:kerning color:[UIColor blackColor]];
}

+ (NSDictionary *)getFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning color:(UIColor *)color {
    return @{NSForegroundColorAttributeName:color,
             NSFontAttributeName: [UIFont fontWithName:bold ? @"AvenirNext-DemiBold" : @"AvenirNext-Medium" size:size],
             NSKernAttributeName: @(kerning)};
}

+ (NSDictionary *)getFontWithSize:(float)size
                             bold:(BOOL)bold
                          kerning:(float)kerning
                            color:(UIColor *)color
                        alignment:(NSTextAlignment)textAlignment {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAlignment;
    
    return @{NSForegroundColorAttributeName:color,
             NSFontAttributeName : [UIFont fontWithName:bold ? @"AvenirNext-DemiBold" : @"AvenirNext-Medium" size:size],
             NSKernAttributeName : @(kerning),
             NSParagraphStyleAttributeName : paragraphStyle};
}

+ (NSDictionary *)getFont:(FontDataType) type {
    switch (type) {
        case FontDataTypeDeviceEventTitle:
          return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
            NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
            NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceEventTime:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};

        case FontDataTypeDeviceBigNumber:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceNumberSign:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceStatus:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0f]};
        case FontDataTypeDeviceTabUnselected:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.4f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceTabSelected:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                      NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0],
                      NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceLabels:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:9.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceSymbol:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0f]};
        case FontDataTypeDeviceHubStatus:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeTableViewLabel:
            return @{NSForegroundColorAttributeName:[[UIColor blackColor] colorWithAlphaComponent:0.35f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataTypeDeviceFooter:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceChooseBoxTitle:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceChooseBoxButton:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceCenterTemperatureNumber:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:80.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceDimmerOn:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeFloatingLabelFont:
            return @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0f],
                     NSKernAttributeName: @(2.0f)};
            
        case FontDataTypeAccountTextField:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0]};
        case FontDataTypeAccountTextFieldPlaceholder:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeAccountTextFieldFloatingLabelAlert:
            return @{NSForegroundColorAttributeName: pinkAlertColor,
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:11.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeAccountTextFieldPlaceholderSub:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:12.0]};
            
        case FontDataTypeAccountTextFieldWhite:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0]};
        case FontDataTypeAccountTextFieldPlaceholderWhite:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeAccountTextFieldPlaceholderSubWhite:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:12.0]};
            
        case FontDataTypeAccountMainText:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16.0]};
        case FontDataTypeAccountSubText:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataTypeAccountSubTextWithOpacity:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataTypeAccountTitle:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0]};
        case FontDataTypeDeviceKeyfobSettingSheetTitle:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeDeviceKeyfobSettingSchedueTitle:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeButtonDark:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeButtonLight:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeButtonPink:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeSlidingMenuHome:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0f]};
        case FontDataTypeSlidingMenuSubtitle:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0f]};
            
            //TODO: Going to change all the name of fonts
        case FontDataType_DemiBold_12_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_12_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0]};
        case FontDataType_DemiBold_12_WhiteAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_12_BlackAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_12_BlackUltraAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.2f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
            
        case FontDataType_DemiBold_14_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_14_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]};
        case FontDataType_DemiBold_14_White_Italic_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:14.0]};
        case FontDataType_DemiBold_14_WhiteAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_14_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_14_Black_Underline:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                     NSKernAttributeName: @(2.0f)};
            
        case FontDataType_DemiBold_18_White_Underline_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0],
                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        case FontDataType_DemiBold_18_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0]};
        case FontDataType_DemiBold_18_Black_Underline_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0],
                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        case FontDataType_DemiBold_18_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0]};
            
        case FontDataType_Medium_18_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0]};
        case FontDataType_Medium_18_Black_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:18.0]};
            
        case FontDataType_Medium_14_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_14_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_14_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataType_Medium_14_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataType_Medium_14_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
        case FontDataType_DemiBold_14_BlackAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_MediumItalic_14_BlackAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_MediumItalic_14_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0]};
        case FontDataType_MediumItalic_14_WhiteAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_MediumItalic_14_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:14.0]};
        
        case FontDataType_DemiBold_15_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_15_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0]};
            
        case FontDataType_Medium_16_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16.0]};
        case FontDataType_Medium_16_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_16_Black_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16.0]};
        case FontDataType_Medium_16_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_16_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_16_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0]};
            
        case FontDataType_DemiBold_18_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0]};

        case FontDataType_Medium_12_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_12_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_12_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0]};
        case FontDataType_MediumMedium_12_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0]};
        case FontDataType_MediumItalic_12_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:12.0]};
        case FontDataType_MediumItalic_12_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:12.0]};
        case FontDataType_Medium_12_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:12.0]};
        case FontDataTypeNavBar:
            return @{NSForegroundColorAttributeName: [SubsystemsController sharedInstance].isAlarmTriggered ? [UIColor whiteColor] : [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeChooseUnselected:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor]colorWithAlphaComponent:0.35],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_13_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_13_White_NoSpace:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                            NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0]};
        case FontDataType_DemiBold_13_WhiteAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_13_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_13_BlackAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_DemiBold_13_BlackUltraAlpha:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.2f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0],
                     NSKernAttributeName: @(2.0f)};
            
        case FontDataType_Medium_13_Black:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_13_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:13.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataType_Medium_13_BalckAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:13.0]};
        case FontDataType_Medium_13_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:13.0]};
        case FontDataType_MediumItalic_13_WhiteAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:13.0]};
        case FontDataType_MediumItalic_13_BlackAlpha_NoSpace:
            return @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.6],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-MediumItalic" size:13.0]};
        case FontDataType_UltraLight_60_White:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:60.0f],
                     NSKernAttributeName: @(2.0f)};
            
        case FontDataTypeLock:
            return @{NSForegroundColorAttributeName: [UIColor blackColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:8.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeSettingsText:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0f],
                     NSKernAttributeName: @(2.0f)};
            break;
        case FontDataTypeSettingsSubText:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
            break;
        case FontDataTypeSettingsSubTextTranslucent:
            return @{NSForegroundColorAttributeName: [[UIColor whiteColor] colorWithAlphaComponent:0.8f],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:14.0]};
            break;
        case FontDataTypeSettingsTextField:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0],
                     NSKernAttributeName: @(2.0f)};
        case FontDataTypeSettingsTextFieldPlaceholder:
            return @{NSForegroundColorAttributeName: [UIColor whiteColor],
                     NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:12.0],
                     NSKernAttributeName: @(2.0f)};
            
        default:
            break;
    }
    
    return [[NSDictionary alloc] init];
}

+ (NSDictionary *)getCombineFont:(FontDataCombineType) type {
    switch (type) {
        case FontDataCombineTypeDeviceNumberSignCombine:
            return @{@"font1": [self getFont:FontDataTypeDeviceBigNumber], @"font2": [self getFont:FontDataTypeDeviceNumberSign], @"offset": @(6.0f)};
        case FontDataCombineTypeDashboardNumberSignCombine:
            return @{@"font1": [self getFont:FontDataType_Medium_14_White], @"font2": [[FontData createFontData:FontTypeMedium size:10 blackColor:NO] getFontDictionary], @"offset": @(4.0f)};
        case FontDataCombineTypeDeviceStatusSymbolCombine:
            return @{@"font1": [self getFont:FontDataTypeDeviceStatus], @"font2": [self getFont:FontDataTypeDeviceSymbol], @"offset": @(6.0f)};
        case FontDataCombineTypeAccountTextFieldPlaceholder:
            return @{@"font1": [self getFont:FontDataTypeAccountTextFieldPlaceholder], @"font2": [self getFont:FontDataTypeAccountTextFieldPlaceholderSub], @"offset":@(1.0f)};
        case FontDataCombineTypeDeviceScheduleEventOffCircle:
            return @{@"font1": @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]},
                    @"font2": @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                   NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:8.0f]},
                    @"offset": @(10.0f)};
        case FontDataCombineTypeDeviceScheduleEventOnCircle:
            return @{@"font1": @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.4f],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]},
                     @"font2": @{NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.4f],
                                   NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-DemiBold" size:8.0f]},
                     @"offset": @(10.0f)};
        case FontDataCombineTypeAlarmText:
            return @{@"font1": [FontData getFont:FontDataType_UltraLight_60_White],
                     @"font2": @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:23.0f]},
                     @"offset": @(25.0f)};
            
        default:
            break;
    }
    
    return [[NSDictionary alloc] init];
}

+ (NSAttributedString *)getString:(NSString *)str withFont:(FontDataType) type {
    str = NSLocalizedString(str, nil);
    
    if (!str || [str isEqual:[NSNull null]]) {
        str = @"";
    }
    else {
        str = str.length > 0 ? str : @"";
    }
    return [[NSAttributedString alloc] initWithString:str attributes:[FontData getFont:type]];
}

+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 withCombineFont:(FontDataCombineType) type {
    if (!str || [str isEqual:[NSNull null]]) {
        str = @"";
    }
    if (!str2 || [str2 isEqual:[NSNull null]]) {
        str2 = @"";
    }

    str = NSLocalizedString(str, nil);
    str2 = NSLocalizedString(str2, nil);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", str, str2]];
    
    NSDictionary *combineFonts = [FontData getCombineFont: type];
    [string addAttributes:[combineFonts objectForKey:@"font1"] range:NSMakeRange(0,str.length)];
    [string addAttributes:[combineFonts objectForKey:@"font2"] range:NSMakeRange(str.length,str2.length)];
    [string addAttribute:NSBaselineOffsetAttributeName value:[combineFonts objectForKey:@"offset"] range:NSMakeRange(str.length,str2.length)];
    
    return string;
}

+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 withFont:(FontDataType) type andFont2:(FontDataType) type2 {
    if (!str || [str isEqual:[NSNull null]]) {
        str = @"";
    }
    if (!str2 || [str2 isEqual:[NSNull null]]) {
        str2 = @"";
    }
    
    str = NSLocalizedString(str, nil);
    str2 = NSLocalizedString(str2, nil);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", str, str2]];
    
    [string addAttributes:[FontData getFont:type] range:NSMakeRange(0,str.length)];
    [string addAttributes:[FontData getFont:type2] range:NSMakeRange(str.length,str2.length)];
    
    return string;
}

+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 andString3:(NSString *)str3 withFont:(FontDataType) type andFont2:(FontDataType) type2 andFont3:(FontDataType) type3 {
    if (!str || [str isEqual:[NSNull null]]) {
        str = @"";
    }
    if (!str2 || [str2 isEqual:[NSNull null]]) {
        str2 = @"";
    }
    if (!str3 || [str3 isEqual:[NSNull null]]) {
        str3 = @"";
    }
    
    str = NSLocalizedString(str, nil);
    str2 = NSLocalizedString(str2, nil);
    str3 = NSLocalizedString(str3, nil);
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", str, str2, str3]];
    
    [string addAttributes:[FontData getFont:type] range:NSMakeRange(0,str.length)];
    [string addAttributes:[FontData getFont:type2] range:NSMakeRange(str.length,str2.length)];
    [string addAttributes:[FontData getFont:type3] range:NSMakeRange((str.length + str2.length),str3.length)];
    
    return string;
}



@end
