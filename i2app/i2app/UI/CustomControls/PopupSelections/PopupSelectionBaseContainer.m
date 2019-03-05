//
//  PopupSelectionBaseContainer.m
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

#import <i2app-Swift.h>
#import "PopupSelectionBaseContainer.h"

#pragma mark - selection cell model
@implementation PopupSelectionModel


+ (PopupSelectionModel *)create:(NSString *)title {
    return [self create:title value:nil obj:nil];
}

+ (PopupSelectionModel *)create:(NSString *)title obj:(id)obj{
    return [self create:title value:nil obj:obj];
}

+ (PopupSelectionModel *)create:(NSString *)title selected:(BOOL)selected obj:(id)obj {
    return [self create:title value:nil selected:selected obj:obj];
}

+ (PopupSelectionModel *)create:(NSString *)title value:(NSString *)value {
    return [self create:title value:value obj:nil];
}

+ (PopupSelectionModel *)create:(NSString *)title value:(NSString *)value obj:(id)obj {
    return [self create:title value:value selected:NO obj:obj];
}

+ (PopupSelectionModel *)create:(NSString *)title value:(NSString *)value selected:(BOOL)selected obj:(id)obj {
    PopupSelectionModel *model = [[PopupSelectionModel alloc] init];
    [model setTitle:title];
    [model setValue:value];
    [model setParam:obj];
    [model setChecked:selected];
    return model;
}

@end
#pragma mark -


#pragma mark - selection button model
@implementation PopupSelectionButtonModel

+ (PopupSelectionButtonModel *)create:(NSString *)title {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    
    return buttonModel;
}

+ (PopupSelectionButtonModel *)create:(NSString *)title event:(SEL)event {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    [buttonModel setPressedSelector:event];
    
    return buttonModel;
}

+ (PopupSelectionButtonModel *)create:(NSString *)title event:(SEL)event obj:(id)obj {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    [buttonModel setPressedSelector:event];
    [buttonModel setObj:obj];
    
    return buttonModel;
}

+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    [buttonModel setUnfilledStyle:YES];
    
    return buttonModel;
}

+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title event:(SEL)event {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    [buttonModel setPressedSelector:event];
    [buttonModel setUnfilledStyle:YES];
    
    return buttonModel;
}

+ (PopupSelectionButtonModel *)createUnfilledStyle:(NSString *)title event:(SEL)event obj:(id)obj {
    PopupSelectionButtonModel *buttonModel = [[PopupSelectionButtonModel alloc] init];
    [buttonModel setTitle:title];
    [buttonModel setPressedSelector:event];
    [buttonModel setUnfilledStyle:YES];
    [buttonModel setObj:obj];
    
    return buttonModel;
}

@end
#pragma mark - 

#pragma mark - popup container
@interface PopupSelectionBaseContainer ()

@end

@implementation PopupSelectionBaseContainer

- (instancetype)init {
    if (self = [super init]) {
        // self.dataObject being nil sometimes causes a crash
        self.dataObject = [NSObject new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initializePicker];
}

- (void)setStyle:(PopupWindowStyle)style {
    
}

#pragma mark - PickerDelegate
- (void)initializePicker {
}

- (id)getSelectedValue {
    return [[NSException alloc] initWithName:@"OVERRIDE METHOD" reason:@"Please, override this method in the derived class: PopupSelectionBaseContainer:getSelectedValue" userInfo:nil];
}

- (CGFloat)getHeight {
    return self.view.bounds.size.height;
}

- (void)setCurrentKey:(id)currentValue {
}

- (void)setCurrentKeyFuzzily:(id)currentKey {
}

@end
