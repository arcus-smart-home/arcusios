//
//  PopupSelectionTextPickerView.h
//  i2app
//
//  Created by Arcus Team on 10/5/15.
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

#import "PopupSelectionBaseContainer.h"
#import "OrderedDictionary.h"

@interface PopupSelectionTextPickerView : PopupSelectionBaseContainer

@property (weak, nonatomic) IBOutlet UIPickerView *textPicker;

@property (strong, nonatomic) OrderedDictionary *textPickerList;

+ (PopupSelectionTextPickerView *)create:(NSString *)title list:(OrderedDictionary *)list;

- (void)setCurrentKeyFuzzily:(NSString *)key;

- (void)setSign:(NSString *)text withFrame:(BOOL)frame;

@end
