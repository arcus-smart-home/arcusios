//
//  FontData.h
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

#import <Foundation/Foundation.h>

extern NSString *const kAvenirNextDemiBold;

typedef enum {
    FontDataTypeDeviceEventTitle = 0,
    FontDataTypeDeviceEventTime,
    FontDataTypeDeviceDescription,
    FontDataTypeDeviceBigNumber,
    FontDataTypeDeviceNumberSign,
    FontDataTypeDeviceLabels,
    FontDataTypeDeviceStatus,
   	FontDataTypeDeviceTabUnselected,
    FontDataTypeDeviceTabSelected,
    FontDataTypeDeviceSymbol,
    FontDataTypeDeviceHubStatus,
    FontDataTypeTableViewLabel,
    FontDataTypeDeviceFooter,
    FontDataTypeDeviceChooseBoxTitle,
    FontDataTypeDeviceChooseBoxButton,
    FontDataTypeDeviceCenterTemperatureNumber,
    FontDataTypeDeviceDimmerOn,
    FontDataTypeFloatingLabelFont,
    
    FontDataTypeAccountTextField,
    FontDataTypeAccountTextFieldPlaceholder,
    FontDataTypeAccountTextFieldPlaceholderSub,
    FontDataTypeAccountTextFieldFloatingLabelAlert,
    
    FontDataTypeAccountTextFieldWhite,
    FontDataTypeAccountTextFieldPlaceholderWhite,
    FontDataTypeAccountTextFieldPlaceholderSubWhite,
    
    FontDataTypeAccountMainText,
    FontDataTypeAccountSubText,
    FontDataTypeAccountSubTextWithOpacity,
    FontDataTypeAccountTitle,
    FontDataTypeDeviceKeyfobSettingSheetTitle,
    FontDataTypeDeviceKeyfobSettingSchedueTitle,
    FontDataTypeSlidingMenuHome,
    FontDataTypeSlidingMenuSubtitle,
    FontDataTypeButtonDark,
    FontDataTypeButtonLight,
    FontDataTypeButtonPink,
    FontDataTypeSettingsText,
    FontDataTypeSettingsSubText,
    FontDataTypeSettingsSubTextTranslucent,
    FontDataTypeSettingsTextField,
    FontDataTypeSettingsTextFieldPlaceholder,
    
    FontDataType_DemiBold_12_White,
    FontDataType_DemiBold_12_White_NoSpace,
    FontDataType_DemiBold_12_WhiteAlpha,
    FontDataType_DemiBold_12_BlackUltraAlpha,
    FontDataType_DemiBold_12_BlackAlpha,
    
    FontDataType_Medium_12_Black,
    FontDataType_Medium_12_White,
    FontDataType_Medium_12_White_NoSpace,
    FontDataType_Medium_12_WhiteAlpha_NoSpace,
    FontDataType_MediumMedium_12_BlackAlpha_NoSpace,
    FontDataType_MediumItalic_12_WhiteAlpha_NoSpace,
    FontDataType_MediumItalic_12_BlackAlpha_NoSpace,
    
    FontDataType_DemiBold_13_White,
    FontDataType_DemiBold_13_White_NoSpace,
    FontDataType_DemiBold_13_WhiteAlpha,
    FontDataType_DemiBold_13_Black,
    FontDataType_DemiBold_13_BlackAlpha,
    FontDataType_DemiBold_13_BlackUltraAlpha,
    
    FontDataType_Medium_13_Black,
    FontDataType_Medium_13_White,
    FontDataType_Medium_13_BalckAlpha_NoSpace,
    FontDataType_Medium_13_WhiteAlpha_NoSpace,
    FontDataType_MediumItalic_13_WhiteAlpha_NoSpace,
    FontDataType_MediumItalic_13_BlackAlpha_NoSpace,
    
    FontDataType_DemiBold_14_White,
    FontDataType_DemiBold_14_White_NoSpace,
    FontDataType_DemiBold_14_White_Italic_NoSpace,
    FontDataType_DemiBold_14_WhiteAlpha,
    FontDataType_DemiBold_14_Black,
    FontDataType_DemiBold_14_Black_Underline,
    FontDataType_DemiBold_14_BlackAlpha,
    FontDataType_Medium_14_White,
    FontDataType_Medium_14_Black,
    FontDataType_Medium_14_White_NoSpace,
    FontDataType_Medium_14_BlackAlpha_NoSpace,
    FontDataType_Medium_14_WhiteAlpha_NoSpace,
    
    FontDataType_MediumItalic_14_BlackAlpha,
    FontDataType_MediumItalic_14_BlackAlpha_NoSpace,
    FontDataType_MediumItalic_14_WhiteAlpha,
    FontDataType_MediumItalic_14_WhiteAlpha_NoSpace,
    
    FontDataType_DemiBold_15_White,
    FontDataType_DemiBold_15_White_NoSpace,

    FontDataType_DemiBold_16_White,
    FontDataType_DemiBold_16_White_NoSpace,
    
    FontDataType_DemiBold_18_White_NoSpace,
    
    FontDataType_Medium_16_White_NoSpace,
    FontDataType_Medium_16_White,
    FontDataType_Medium_16_Black_NoSpace,
    FontDataType_Medium_16_Black,
    
    FontDataType_Medium_18_White_NoSpace,
    FontDataType_Medium_18_Black_NoSpace,

    FontDataType_DemiBold_18_White_Underline_NoSpace,
    FontDataType_DemiBold_18_WhiteAlpha_NoSpace,
    FontDataType_DemiBold_18_Black_Underline_NoSpace,
    FontDataType_DemiBold_18_BlackAlpha_NoSpace,

    FontDataType_UltraLight_60_White,
    
    
    FontDataTypeNavBar,
    FontDataTypeChooseUnselected,
    FontDataTypeLock,
} FontDataType;

typedef enum {
    FontDataCombineTypeDeviceNumberSignCombine = 0,
    FontDataCombineTypeDashboardNumberSignCombine,
    FontDataCombineTypeDeviceStatusSymbolCombine,
    FontDataCombineTypeAccountTextFieldPlaceholder,
    FontDataCombineTypeDeviceScheduleEventOnCircle,
    FontDataCombineTypeDeviceScheduleEventOffCircle,
    FontDataCombineTypeAlarmText,
} FontDataCombineType;

typedef enum {
    FontTypeRegular = 0,
    FontTypeItalic,
    FontTypeBold,
    FontTypeBoldItalic,
    FontTypeDemiBold,
    FontTypeDemiBoldItalic,
    FontTypeMedium,
    FontTypeMediumItalic,
    FontTypeUltraLight,
    FontTypeUltraLightItalic,
} FontType;
#define FontTypeToFontString(enum) [@[@"AvenirNext-Regular", @"AvenirNext-Italic", @"AvenirNext-Bold", @"AvenirNext-BoldItalic", @"AvenirNext-DemiBold", @"AvenirNext-DemiBoldItalic", @"AvenirNext-Medium", @"AvenirNext-MediumItalic", @"AvenirNext-UltraLight", @"AvenirNext-UltraLightItalic"] objectAtIndex:enum]



@interface FontData : NSObject

+ (FontData *)createFontData:(FontType)fontType size:(float)size;
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor;
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor alpha:(BOOL)alpha;
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space;
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space alpha:(BOOL)alpha;
+ (FontData *)createFontData:(FontType)fontType size:(float)size blackColor:(BOOL)blackColor space:(BOOL)space alpha:(BOOL)alpha underline:(BOOL)underline;

- (NSDictionary *)getFontDictionary;
- (NSAttributedString *)getFontAttributed:(NSString *)text;

+ (NSDictionary *)getItalicFontWithColor:(UIColor *)fontColor size:(float)size kerning:(float)kerning;
+ (NSDictionary *)getWhiteFontWithSize:(float)size bold:(BOOL)bold;
+ (NSDictionary *)getWhiteFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning;
+ (NSDictionary *)getBlackFontWithSize:(float)size bold:(BOOL)bold;
+ (NSDictionary *)getBlackFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning;
+ (NSDictionary *)getFontWithSize:(float)size bold:(BOOL)bold kerning:(float)kerning color:(UIColor *)color;
+ (NSDictionary *)getFontWithSize:(float)size
                             bold:(BOOL)bold
                          kerning:(float)kerning
                            color:(UIColor *)color
                        alignment:(NSTextAlignment)textAlignment;

+ (NSDictionary *)getFont:(FontDataType) type;
+ (NSAttributedString *)getString:(NSString *)str withFont:(FontDataType) type;
+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 withCombineFont:(FontDataCombineType)type;
+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 withFont:(FontDataType)type andFont2:(FontDataType) type2;
+ (NSAttributedString *)getString:(NSString *)str andString2:(NSString *)str2 andString3:(NSString *)str3 withFont:(FontDataType) type andFont2:(FontDataType) type2 andFont3:(FontDataType) type3;

@end
