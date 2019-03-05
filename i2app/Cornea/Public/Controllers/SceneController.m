//
//  SceneController.m
//  Pods
//
//  Created by Arcus Team on 11/4/15.
//
//

#import <i2app-Swift.h>
#import "SceneController.h"
#import "SceneCapability.h"
#import "SceneTemplateCapability.h"
#import "SceneService.h"
#import "SubsystemCapability.h"
#import <PromiseKit/PromiseKit.h>



#import "FavoriteController.h"

NSString *const kSceneAttributeTitle = @"Title";
NSString *const kSceneAttributeValue = @"Value";

@implementation SceneController

+ (PMKPromise *)getAllScenes:(NSString *)placeId {
    return [SceneService listScenesWithPlaceId:placeId].then(^(SceneServiceListScenesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            for (NSDictionary *sceneDict in [response getScenes]) {
                SceneModel *scene = [[SceneModel alloc] initWithAttributes:sceneDict];
                [[[CorneaHolder shared] modelCache] updateModel:[scene address] changes:[scene get]];
            }
            
            [FavoriteController getAllFavoriteModels];
            
            fulfill([[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]]);
        }];
    });
}

+ (PMKPromise *)getAllSceneTemplates:(NSString *)placeId {
    return [SceneService listSceneTemplatesWithPlaceId:placeId].then(^(SceneServiceListSceneTemplatesResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSMutableArray *sceneTemplates = [[NSMutableArray alloc] initWithCapacity:[response getSceneTemplates].count];
            for (NSDictionary *templateAttribs in [response getSceneTemplates]) {
                SceneTemplateModel *templateModel = [[SceneTemplateModel alloc] initWithAttributes:templateAttribs];
                [sceneTemplates addObject:templateModel];
            }
            fulfill(sceneTemplates.copy);
        }];
    });
}

+ (PMKPromise *)createWithPlaceId:(NSString *)placeId withName:(NSString *)name onModel:(SceneTemplateModel *)model {
    return [SceneTemplateCapability createWithPlaceId:placeId withName:name withActions:[NSArray new] onModel:model].then(^(SceneTemplateCreateResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(response);
        }];
    });
}

+ (PMKPromise *)getTemplateActionsWithPlaceId:(NSString *)placeId onModel:(SceneTemplateModel *)model {
    return [SceneTemplateCapability resolveActionsWithPlaceId:placeId onModel:model].then(^(SceneTemplateResolveActionsResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            NSArray *actionsArray = [response getActions];
            NSMutableArray *actions = [[NSMutableArray alloc] initWithCapacity:actionsArray.count];
            for (NSDictionary *dict in actionsArray) {
                SceneAction *action = [[SceneAction alloc] initWithDictionary:dict];
                [actions addObject:action];
            }
            fulfill(actions);
        }];
    });
}

+ (PMKPromise *)fireOnModel:(SceneModel* )model {
    return [SceneCapability fireOnModel:model];
}

@end

#pragma mark - SceneActionSelectorAttributeValue
@implementation SceneActionSelectorAttributeValue : NSObject

@dynamic firstTitle;
@dynamic secondTitle;

@dynamic firstConfigurableValue;
@dynamic secondConfigurableValue;

- (instancetype)initWithObject:(NSObject *)valueObj {
    if (self = [super init]) {
        DDLogInfo(@"SceneActionSelectorAttributeValue initializer - %@", valueObj);
        
        if ([valueObj isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)valueObj;
            NSMutableArray<NSDictionary *> *allValues = [[NSMutableArray alloc] initWithCapacity:values.count];
            if (values.count > 0) {
                for (NSObject *value in values) {
                    NSMutableDictionary *valuesDict = [[NSMutableDictionary alloc] initWithCapacity:2];
                    if ([value isKindOfClass:[NSArray class]]) {
                        if (((NSArray *)value).count > 0) {
                            if ([((NSArray *)value)[0] isKindOfClass:[NSString class]]) {
                                NSString *title = (NSString *)((NSArray *)value)[0];
                                [valuesDict setObject:title forKey:kSceneAttributeTitle];
                            }
                            else {
                                NSAssert([((NSArray *)value)[0] isKindOfClass:[NSString class]], @"Value of type different from NSString is not being handled");
                            }
                            
                            NSObject *secondValue = ((NSArray *)value)[1];
                            if ([secondValue isKindOfClass:[NSArray class]]) {
                                if (((NSArray *)secondValue).count > 0) {
                                    if ([((NSArray *)secondValue)[0] isKindOfClass:[NSDictionary class]]) {
                                        SceneActionSelectorAttributeValue *valuesAttrib = [[SceneActionSelectorAttributeValue alloc] initWithObject:secondValue];
                                        [valuesDict setObject:valuesAttrib forKey:kSceneAttributeValue];
                                    }
                                    else {
                                        NSAssert([((NSArray *)secondValue)[0] isKindOfClass:[NSDictionary class]], @"Value of type different from NSDictionary is not being handled");
                                    }
                                }
                            }
                            else if ([secondValue isKindOfClass:[NSString class]]) {
                                NSString *title = (NSString *)((NSArray *)value)[0];
                                [valuesDict setObject:title forKey:kSceneAttributeValue];
                            }
                            else {
                                NSAssert(YES, @"ONLY NSARRAY AND NSSTRING VALUES are being handled");
                            }
                        }
                    }
                    else {
                        _nestedAttribute = [[SceneActionSelectorAttribute alloc] initWithAttributes:(NSDictionary *)value];
                    }
                    [allValues addObject:valuesDict];
                }
                _allAttributeValues = allValues.copy;
            }
        }
        else {
            NSString *message = [NSString stringWithFormat:@"SceneActionSelectorAttributeValue value property is not an NSArray and this is not being handled\n%@", valueObj];
            NSAssert([valueObj isKindOfClass:[NSArray class]], message);
        }
    }
    return self;
}

- (NSString *)description {
    return self.allAttributeValues.description;
}

#pragma mark - Dynamic Properties
- (NSString *)firstTitle {
    return _allAttributeValues[0][kSceneAttributeTitle];
}

- (SceneActionSelectorAttribute *)firstConfigurableValue {
    return _allAttributeValues[0][kSceneAttributeValue];
}

- (NSString *)secondTitle {
    return _allAttributeValues[1][kSceneAttributeTitle];
}

- (SceneActionSelectorAttribute *)secondConfigurableValue {
    return _allAttributeValues[1][kSceneAttributeValue];
}

- (NSString *)getTitleForIndex:(int)index {
    return _allAttributeValues[index][kSceneAttributeTitle];
}

- (SceneActionSelectorAttribute *)getConfigurableValueForIndex:(int)index {
    return _allAttributeValues[index][kSceneAttributeValue];
}

@end


#pragma mark - SceneActionSelectorAttribute
@implementation SceneActionSelectorAttribute

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
      _attributesDictionary = attributes.copy;

        if (![attributes[@"name"] isKindOfClass:[NSNull class]]) {
            _name = (NSString *)attributes[@"name"];
        }
        DDLogInfo(@"SceneActionSelectorAttribute initializer - %@", _name);
        
        if (![attributes[@"min"] isKindOfClass:[NSNull class]]) {
            _min = (NSNumber *)attributes[@"min"];
        }
        if (![attributes[@"max"] isKindOfClass:[NSNull class]]) {
            _max = (NSNumber *)attributes[@"max"];
        }
        if (![attributes[@"step"] isKindOfClass:[NSNull class]]) {
            _step = (NSNumber *)attributes[@"step"];
        }
        if (![attributes[@"unit"] isKindOfClass:[NSNull class]]) {
            _unit = (NSString *)attributes[@"unit"];
        }
        NSObject *value = attributes[@"value"];
        if (![value isKindOfClass:[NSNull class]]) {
            if ([value isKindOfClass:[NSArray class]] && ((NSArray *)value).count > 0) {
                _value = [[SceneActionSelectorAttributeValue alloc] initWithObject:attributes[@"value"]];
                _attributeValues = attributes[@"value"];
            }
            else {
                NSAssert([value isKindOfClass:[NSNull class]], @"SceneActionSelectorAttribute:initWithAttributes value is not an array. WHAT TO DO?????");
            }
        }
        _type = [self getSceneActionSelectorType:attributes[@"type"]];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ \n type = %d", _name, _min, _max, _step, _unit, _value, _type];
}

- (SceneActionSelectorType)getSceneActionSelectorType:(NSString *)type {
    if ([type caseInsensitiveCompare:@"GROUP"] == NSOrderedSame) {
        return SceneActionSelectorTypeGroup;
    }
    else if ([type caseInsensitiveCompare:@"BOOLEAN"] == NSOrderedSame) {
        return SceneActionSelectorTypeBoolean;
    }
    else if ([type caseInsensitiveCompare:@"LIST"] == NSOrderedSame) {
        return SceneActionSelectorTypeList;
    }
    else if ([type caseInsensitiveCompare:@"DURATION"] == NSOrderedSame) {
        return SceneActionSelectorTypeDuration;
    }
    else if ([type caseInsensitiveCompare:@"RANGE"] == NSOrderedSame) {
        return SceneActionSelectorTypeRange;
    }
    else if ([type caseInsensitiveCompare:@"PERCENT"] == NSOrderedSame) {
        return SceneActionSelectorTypePercent;
    }
    else if ([type caseInsensitiveCompare:@"THERMOSTAT"] == NSOrderedSame) {
        return SceneActionSelectorTypeThermostat;
    }
    else if ([type caseInsensitiveCompare:@"TEMPERATURE"] == NSOrderedSame) {
        return SceneActionSelectorTypeTemperature;
    }
    return SceneActionSelectorTypeNone;
}

@end

#pragma mark - SceneActionSelector
@implementation SceneActionSelector

@dynamic deviceName;

- (instancetype)initWithId:(NSString *)selectorId WithAttributes:(NSArray *)attributes {
    if (self = [super init]) {
        _selectorId = selectorId;
        DDLogInfo(@"SceneActionSelector initializer - %@", _selectorId);
        // Attributes  is an array of dictionaries
        NSMutableArray<SceneActionSelectorAttribute *> *attributesArray = [[NSMutableArray alloc] initWithCapacity:attributes.count];
        for (NSDictionary *dict in attributes) {
            SceneActionSelectorAttribute *attribGroup = [[SceneActionSelectorAttribute alloc] initWithAttributes:dict];
            [attributesArray addObject:attribGroup];
        }
        _attributes = attributesArray.copy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ ", self.selectorId, /*self.name,*/ _attributes.description];
}

#pragma mark - Dynamic Properties
- (NSString *)deviceName {
    if ([_selectorId containsString:DeviceCapability.namespace]) {
        return [[[CorneaHolder shared] modelCache] fetchModel:_selectorId].name;
    }
    return @"";
}

// TODO: the assumption here is that there is only one attribute in the attributes list
- (BOOL)isConfigurable:(int)groupIndex {
    if (_attributes.count == 1) {
        if (_attributes[0].type == SceneActionSelectorTypeThermostat) {
            return YES;
        }
        
        if ([_attributes[0].value isKindOfClass:[SceneActionSelectorAttributeValue class]]) {
            SceneActionSelectorAttributeValue *attribValue = _attributes[0].value;
            if ([attribValue isKindOfClass:[SceneActionSelectorAttributeValue class]]) {
                return (attribValue.allAttributeValues[groupIndex].count > 1);
            }
        }
        else {
            SceneActionSelectorAttribute *attribValue = _attributes[0];
            if (attribValue.min && attribValue.max && attribValue.step) {
                return YES;
            }
            else {
                if (attribValue.type != SceneActionSelectorTypeThermostat) {
                    // So far only Thermostat doesn't need to have parameters
                    NSAssert(NO, @"SceneActionSelector:isConfigurable NEED TO HANDLE THIS");
                }
            }
        }
    }
    else {
        NSAssert(_attributes.count == 1, @"SceneActionSelector:isConfigurable has more than 1 attributes");
    }
    return NO;
}

@end

#pragma mark - SceneAction
@implementation SceneAction {
    NSDictionary    *_actionDictionary;
}

@dynamic actionId;
@dynamic name;
@dynamic isSatisfiable;
@dynamic hintString;
@dynamic devicesFromSelectors;

- (instancetype)initWithDictionary:(NSDictionary *)action {
    if (self = [super init]) {
        _actionDictionary = action;
        NSDictionary *selectorsDict = action[@"selectors"];
        NSMutableArray *selectors = [[NSMutableArray alloc] initWithCapacity:selectorsDict.count];
        
        for (int i = 0; i < selectorsDict.count; i++) {
            SceneActionSelector *selector = [[SceneActionSelector alloc] initWithId:selectorsDict.allKeys[i] WithAttributes:selectorsDict.allValues[i]];
            [selectors addObject:selector];
        }
        _selectors = selectors.copy;
        _type = [self getSceneActionType];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@ %d \n%@", self.name, self.actionId, self.isSatisfiable, self.selectors.description];
}


#pragma mark - Dynamic Properties
- (NSString *)actionId {
    return _actionDictionary[@"id"];
}

- (NSString *)name {
    return _actionDictionary[@"name"];
}

- (BOOL)isSatisfiable {
    NSNumber *obj = _actionDictionary[@"satisfiable"];
    return obj.boolValue;
}

- (NSString *)hintString {
    return _actionDictionary[@"typehint"];
}

- (NSArray *)devicesFromSelectors {
    NSMutableArray *devices = [[NSMutableArray alloc] initWithCapacity:_selectors.count];
    
    for (SceneActionSelector *selector in _selectors) {
        [devices addObject:[[[CorneaHolder shared] modelCache] fetchModel:selector.selectorId]];
    }
    return devices.copy;
}

// Since each selector has its own attributes, and each selector's attributes can
// have group names (for example: "ON", "OFF", for simplicity now we are assuming
// that all selectors have the same groups.
// _firstSelectors - all selectors that can appear in groupOne
// _secondSelectors - all selectors that can appear in groupTwo
- (NSArray *)buildGroupLabelsAndSelectors:(SceneModel *)currentScene firstGroup:(NSArray **)firstGroup secondGroup:(NSArray **)secondGroup {
    
    // Get the selectors from the SceneModel
    NSArray *sceneActions = [SceneCapability getActionsFromModel:currentScene];
    SceneActionSelectorAttribute *attribute = self.selectors[0].attributes[0];
    NSMutableArray *firstGroupArray = [NSMutableArray new];
    NSMutableArray *secondGroupArray = [NSMutableArray new];
    for (NSDictionary *action in sceneActions) {
        if ([action[@"template"] isEqualToString:self.actionId]) {
            NSDictionary *context = (NSDictionary *)action[@"context"];
            for (NSString *key in context.allKeys) {
                NSDictionary *contextDict = (NSDictionary *)context[key];
                if (contextDict.count > 0) {
                    // Some selectors may not have values (thermostat)
                    if (attribute.value) {
                        // These are actions that have multiple states ("On"/"Off" or "Lock"/"Unlock", etc.)
                        SceneActionSelectorAttributeValue *attrValue = (SceneActionSelectorAttributeValue *)attribute.value;
                        
                        NSString *groupAttrib = contextDict[attribute.name];
                        if (groupAttrib.length > 0) {
                            SceneActionSelector *selector = [self getSelectorForDeviceAddress:key];
                            if (selector) {
                                if ([groupAttrib isEqualToString:attrValue.firstTitle]) {
                                    [firstGroupArray addObject:selector];
                                }
                                else if ([groupAttrib isEqualToString:attrValue.secondTitle]) {
                                    if (selector) {
                                        [secondGroupArray addObject:selector];
                                    }
                                }
                            }
                        }
                    }
                    else {
                        // These are actions that have a single state (Thermostat, camera, etc)
                        SceneActionSelector *selector = [self getSelectorForDeviceAddress:key];
                        if (selector) {
                            [firstGroupArray addObject:selector];
                        }
                    }
                }
                else {
                    SceneActionSelector *selector = [self getSelectorForDeviceAddress:key];
                    if (selector) {
                        [firstGroupArray addObject:selector];
                    }
                }
            }
        }
    }
    *firstGroup = firstGroupArray;
    *secondGroup = secondGroupArray;
    
    NSMutableArray *labels = [[NSMutableArray alloc] initWithCapacity:2];
    if (attribute && [attribute.value isKindOfClass:[SceneActionSelectorAttributeValue class]]) {
        SceneActionSelectorAttributeValue *attrValue = (SceneActionSelectorAttributeValue *)attribute.value;
        
        for (int i = 0; i < attrValue.allAttributeValues.count; i++) {
            NSString *title = [attrValue getTitleForIndex:i];
            [labels addObject:title];
        }
    }
    return labels.copy;
}

- (SceneActionType)getSceneActionType {
    NSString *hintString = self.hintString;
    
    if ([hintString isEqualToString:@"security"]) {
        return SceneActionTypeSecurity;
    }
    else if ([hintString isEqualToString:@"thermostat"]) {
        return SceneActionTypeThermostat;
    }
    else if ([hintString isEqualToString:@"light"]) {
        return SceneActionTypeLight;
    }
    else if ([hintString isEqualToString:@"lock"]) {
        return SceneActionTypeLock;
    }
    else if ([hintString isEqualToString:@"garage"]) {
        return SceneActionTypeGarage;
    }
    else if ([hintString isEqualToString:@"camera"]) {
        return SceneActionTypeCamera;
    }
    else if ([hintString isEqualToString:@"vent"]) {
        return SceneActionTypeVent;
    }
    else if ([hintString isEqualToString:@"fan"]) {
        return SceneActionTypeFan;
    }
    else if ([hintString isEqualToString:@"waterheater"]) {
        return SceneActionTypeWaterheater;
    }
    else if ([hintString isEqualToString:@"valve"]) {
        return SceneActionTypeValve;
    }
    else if ([hintString isEqualToString:@"blind"]) {
        return SceneActionTypeBlinds;
    }
    else if ([hintString isEqualToString:@"spaceheater"]) {
        return SceneActionTypeSpaceHeater;
    }
    return SceneActionTypeNone;
}

- (SceneActionSelector *)getSelectorForDeviceAddress:(NSString *)deviceAddress {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"selectorId", deviceAddress];
    NSArray *filteredArray = [_selectors filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        return filteredArray[0];
    }
    return nil;
}

@end
