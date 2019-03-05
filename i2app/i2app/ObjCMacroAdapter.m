//
//  ObjCMacroAdapter.m
//  i2app
//
//  Created by Arcus Team on 5/27/16.
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
#import "ObjCMacroAdapter.h"

@implementation ObjCMacroAdapter

+ (BOOL)isPhone5 {
    return IS_IPHONE_5;
}

#pragma mark - Colors

+ (UIColor *)arcusPinkAlertColor {
    return pinkAlertColor;
}

+ (UIColor *)arcusPurpleAlertColor {
    return purpleAlertColor;
}

+ (UIColor *)arcusGrayAlertColor {
    return grayAlertColor;
}

#pragma mark - Arcus URLs
+ (NSString *)arcusPrivacyStatementUrl {
    return privacyStatementUrl;
}

+ (NSString *)arcusTermsOfServiceUrl {
    return termsOfServiceUrl;
}

@end
