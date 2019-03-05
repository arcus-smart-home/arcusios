//
//  DeviceSettingModels.m
//  i2app
//
//  Created by Arcus Team on 8/6/15.
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
#import "DeviceSettingModels.h"

@implementation DeviceSettingUnitBase {
    NSMutableDictionary *_store;
    UITableViewCell     *_cell;
    NSMutableArray      *_insideArray;
}

- (instancetype)init {
    if (self = [super init]) {
        _insideArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"title: %@ deviceId: %@", self.title, self.deviceModel.address];
}

#pragma mark - inherit NSMutableArray
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    [_insideArray insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_insideArray removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    [_insideArray addObject:anObject];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    [_insideArray addObjectsFromArray:otherArray];
}

- (void)removeLastObject {
    [_insideArray removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    [_insideArray replaceObjectAtIndex:index withObject:anObject];
}

- (NSUInteger)count {
    return _insideArray.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    return [_insideArray objectAtIndex:index];
}
#pragma mark -


- (void)loadData {
    
}

- (UITableViewCell *)getCell {
    if (!_cell) {
        _cell = [self generateCell];
    }
    return _cell;
}

- (UITableViewCell *)generateCell {
    return [[UITableViewCell alloc] init];
}

- (void)setValue:(id)value to:(NSString *)key {
    if (!_store) {
        _store = [[NSMutableDictionary alloc] init];
    }
    
    [_store setObject:value forKey:key];
}

- (id)getValueFrom:(NSString *)key {
    if (!_store) {
        return [[NSObject alloc] init];
    }
    
    return [_store objectForKey:key];
}

- (void)setBoolean:(BOOL)value to:(NSString *)key {
    if (!_store) {
        _store = [[NSMutableDictionary alloc] init];
    }
    
    [_store setObject:@(value) forKey:key];
}

- (BOOL)getBooleanFrom:(NSString *)key {
    if (!_store) {
        return NO;
    }
    
    id value = [_store objectForKey:key];
    return [value boolValue];
}

- (void)setInt:(NSInteger)value to:(NSString *)key {
    if (!_store) {
        _store = [[NSMutableDictionary alloc] init];
    }
    
    [_store setObject:@(value) forKey:key];
}

- (NSInteger)getIntFrom:(NSString *)key {
    if (!_store) {
        return NO;
    }
    
    id value = [_store objectForKey:key];
    return [value integerValue];
}

- (void)setString:(NSString *)text to:(NSString *)key {
    if (!_store) {
        _store = [[NSMutableDictionary alloc] init];
    }
    
    [_store setObject:text forKey:key];
}

- (NSString *)getStringFrom:(NSString *)key {
    if (!_store) {
        return @"";
    }
    
    NSString *value = [_store objectForKey:key];
    return value;
}

@end


@implementation DeviceSettingUnitCollection {
    NSMutableArray *_units;
    UIViewController *_owner;
    DeviceModel *_model;
}

- (instancetype)initWithOwner: (UIViewController *)owner deviceModel:(DeviceModel *)model {
    self = [super init];
    if (self) {
        _owner = owner;
        _model = model;
        _units = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%@ must user initWithOwner", NSStringFromSelector(_cmd)];
    }
    return self;
}

// has second level means that is group table
- (BOOL)hasSecondLevelUnits {
    for (DeviceSettingUnitBase *unit in _units) {
        if (unit.count > 0) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)getHeightOfCell:(NSIndexPath *)indexPath {
    return [self getCell:indexPath].frame.size.height;
}

- (NSInteger)getNumberOfSection {
    if ([self hasSecondLevelUnits]) {
        return _units.count;
    }
    else {
        return 1;
    }
}

- (NSInteger)getNumberOfRows:(NSInteger)section {
    if ([self hasSecondLevelUnits]) {
        if (_units.count > section) {
            DeviceSettingUnitBase *unit = [_units objectAtIndex:section];
            return unit.count;
        }
        else {
            return 0;
        }
    }
    else {
        return _units.count;
    }
}

- (NSString *)getSectionTitle:(NSInteger)section {
    if (_units.count < section) {
        return @"";
    }
    DeviceSettingUnitBase *unit = [_units objectAtIndex:section];
    return unit.title;
}

- (DeviceSettingUnitBase *)getUnit:(NSIndexPath *)indexPath {
    if ([self hasSecondLevelUnits]) {
        if (_units.count < indexPath.section) {
            return [[DeviceSettingUnitBase alloc] init];
        }
        
        DeviceSettingUnitBase *unit = [_units objectAtIndex:indexPath.section];
        if (unit.count < indexPath.row) {
            return [[DeviceSettingUnitBase alloc] init];
        }
        return [unit objectAtIndex:indexPath.row];
    }
    else {
        if (_units.count < indexPath.row) {
            return [[DeviceSettingUnitBase alloc] init];
        }
        
        return [_units objectAtIndex:indexPath.row];
    }
}

- (UITableViewCell *)getCell:(NSIndexPath *)indexPath {
    DeviceSettingUnitBase *unit = [self getUnit:indexPath];
    return [unit getCell];
}

- (void)addUnit:(DeviceSettingUnitBase *)unit {
    [unit setControlOwner:_owner];
    if (unit.count > 0) {
        [self assignOwner:unit];
    }
    [_units addObject:unit];
}

- (void)assignOwner: (NSArray *)array {
    for (DeviceSettingUnitBase *item in array) {
        if ([item isKindOfClass:[DeviceSettingUnitBase class]]) {
            [item setDeviceModel:_model];
            [item setControlOwner:_owner];
            if (item.count > 0) {
                [self assignOwner:item];
            }
        }
    }
}

- (void)removeAllUnit {
    [_units removeAllObjects];
}

- (void)removeUnit:(DeviceSettingUnitBase *)unit {
    for (DeviceSettingUnitBase *item in _units) {
        if ([item isEqual:unit]) {
            [_units removeObject:item];
            return;
        }
        else if (item.count > 0) {
            for (DeviceSettingUnitBase *subitem in item) {
                if ([subitem isEqual:unit]) {
                    [_units removeObject:subitem];
                    return;
                }
            }
        }
    }
}

- (NSArray *)getAllUnits {
    return _units;
}

@end

@implementation DeviceSettingPackage {
    UIViewController *_owner;
    DeviceModel *_currentDeviceModel;
}

+ (BOOL)hasSetting:(DeviceModel *)model {
    NSString *typeStr = DeviceTypeToString(model.deviceType);
    Class providerClass = NSClassFromString([NSString stringWithFormat:@"DeviceSetting%@Package",typeStr]);
    return providerClass != nil;
}

+ (DeviceSettingPackage *)generateDeviceSetting:(DeviceModel *)model controlOwner:(UIViewController *)owner {
    NSString *typeStr = DeviceTypeToString(model.deviceType);
    Class providerClass = NSClassFromString([NSString stringWithFormat:@"DeviceSetting%@Package", typeStr]);
    if (providerClass) {
        DeviceSettingPackage *package = [[providerClass alloc] initWithOwner:owner deviceModel:model];;
        return package;
    }
    else {
        return nil;
    }
}

+ (DeviceSettingPackage *)generateDeviceSettingFromDevice:(UIViewController *)owner device:(DeviceModel*)deviceModel {
    return [self generateDeviceSetting:deviceModel controlOwner:owner];
}

- (instancetype)initWithOwner: (UIViewController *)owner deviceModel:(DeviceModel *)model {
    self = [super init];
    if (self) {
        _owner = owner;
        _currentDeviceModel = model;
        _unitCollection = [[DeviceSettingUnitCollection alloc] initWithOwner:owner deviceModel:model];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [NSException raise:NSInternalInconsistencyException format:@"%@ must user initWithOwner", NSStringFromSelector(_cmd)];
    }
    return self;
}

- (void)loadData {
    [self loadUnitData:[_unitCollection getAllUnits]];
}

- (void)loadUnitData: (NSArray *)array {
    for (DeviceSettingUnitBase *item in array) {
        if ([item isKindOfClass:[DeviceSettingUnitBase class]]) {
            [item setDeviceModel:_currentDeviceModel];
            [item loadData];
            if (item.count > 0) {
                [self loadUnitData:item];
            }
        }
    }
}

- (BOOL)shouldDisplay {
    return YES;
}

@end


