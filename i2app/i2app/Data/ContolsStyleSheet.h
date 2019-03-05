//
//  ContolsStyleSheet.h
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

#import <UIKit/UIKit.h>


@interface UIButton (StyleSheet)

- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata;
- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata upperCase:(BOOL)uppercase;

- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type;
- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type upperCase:(BOOL)uppercase;

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold;
- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase;
- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase;

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold;
- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase;
- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase;

@end


@interface UILabel (StyleSheet)

- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata;
- (void)styleSet:(NSString *)text andFontData:(FontData *)fontdata upperCase:(BOOL)uppercase;

- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type;
- (void)styleSet:(NSString *)text andButtonType:(FontDataType)type upperCase:(BOOL)uppercase;

- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold;
- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase;
- (void)styleSetWithSpace:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase;

- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold;
- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold upperCase:(BOOL)uppercase;
- (void)styleSet:(NSString *)text andFontSize:(float)size bold:(BOOL)bold alpha:(BOOL)alpha upperCase:(BOOL)uppercase;

@end
