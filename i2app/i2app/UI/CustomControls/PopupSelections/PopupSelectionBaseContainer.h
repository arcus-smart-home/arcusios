//
//  PopupSelectionBaseContainer.h
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

#import <UIKit/UIKit.h>
#import "PopupSelectionWindow.h"
#import "PickerDelegate.h"

#pragma mark - selection cell model
@interface PopupSelectionModel: NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *value;
@property (nonatomic) BOOL checked;
@property (strong, nonatomic) id param;

+ (PopupSelectionModel *)create:(NSString *)title;
+ (PopupSelectionModel *)create:(NSString *)title obj:(id)obj;
+ (PopupSelectionModel *)create:(NSString *)title selected:(BOOL)selected obj:(id)obj;

+ (PopupSelectionModel *)create:(NSString *)title value:(NSString *)value;
+ (PopupSelectionModel *)create:(NSString *)title value:(NSString *)value selected:(BOOL)selected obj:(id)obj;

@end
#pragma mark -

#pragma mark - selection button model
@interface PopupSelectionButtonModel: NSObject

@property (strong, nonatomic) id obj;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) SEL pressedSelector;
@property (assign, nonatomic) BOOL unfilledStyle;
@property (strong, nonatomic) UIColor *backgroundColor;


+ (PopupSelectionButtonModel *)create:(NSString *)title;
+ (PopupSelectionButtonModel *)create:(NSString *)title event:(SEL)event;
+ (PopupSelectionButtonModel *)create:(NSString *)title event:(SEL)event obj:(id)obj;

+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title;
+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title event:(SEL)event;
+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title event:(SEL)event obj:(id)obj;

@end
#pragma mark -


#pragma mark - popup container
@interface PopupSelectionBaseContainer : UIViewController <PickerDelegate>

@property (weak, nonatomic) PopupSelectionWindow *window;
@property (strong, nonatomic) NSObject *dataObject;

- (void)setStyle:(PopupWindowStyle)style;
- (CGFloat)getHeight;
- (void)setCurrentKey:(id)currentValue;

- (void)setCurrentKeyFuzzily:(id)currentKey;

@end
