//
//  SceneController.h
//  Pods
//
//  Created by Arcus Team on 11/4/15.
//
//

#import <Foundation/Foundation.h>

@class SceneTemplateModel;
@class SceneModel;

extern NSString *const kSceneAttributeTitle;
extern NSString *const kSceneAttributeValue;

typedef enum {
    SceneActionTypeNone,
    SceneActionTypeSecurity,
    SceneActionTypeThermostat,
    SceneActionTypeLight,
    SceneActionTypeLock,
    SceneActionTypeGarage,
    SceneActionTypeCamera,
    SceneActionTypeVent,
    SceneActionTypeFan,
    SceneActionTypeWaterheater,
    SceneActionTypeValve,
    SceneActionTypeBlinds,
    SceneActionTypeSpaceHeater,
} SceneActionType;

typedef enum {
    SceneActionSelectorTypeNone,
    SceneActionSelectorTypeGroup,
    SceneActionSelectorTypeBoolean,
    SceneActionSelectorTypeList,
    SceneActionSelectorTypeDuration,
    SceneActionSelectorTypeRange,
    SceneActionSelectorTypePercent,
    SceneActionSelectorTypeThermostat,
    SceneActionSelectorTypeTemperature,
} SceneActionSelectorType;

@class PMKPromise;



@class SceneActionSelectorAttribute;
@class SceneActionSelector;

@interface SceneController : NSObject

+ (PMKPromise *)getAllScenes:(NSString *)placeId;
+ (PMKPromise *)getAllSceneTemplates:(NSString *)placeId;

+ (PMKPromise *)createWithPlaceId:(NSString *)placeId withName:(NSString *)name onModel:(SceneTemplateModel *)model;

+ (PMKPromise *)getTemplateActionsWithPlaceId:(NSString *)placeId onModel:(SceneTemplateModel *)model;

+ (PMKPromise *)fireOnModel:(SceneModel* )model;

@end

#pragma mark - SceneActionSelectorAttributeValue
@interface SceneActionSelectorAttributeValue : NSObject

- (instancetype)initWithObject:(NSObject *)valueObj;

@property (nonatomic, strong, readonly) NSArray<NSDictionary *> *allAttributeValues;

@property (nonatomic, assign, readonly) BOOL isFirstConfigurable;
@property (nonatomic, assign, readonly) BOOL isSecondConfigurable;

@property (nonatomic, assign, readonly) NSString *firstTitle;
@property (nonatomic, assign, readonly) NSString *secondTitle;

@property (nonatomic, strong, readonly) SceneActionSelectorAttribute *firstConfigurableValue;
@property (nonatomic, strong, readonly) SceneActionSelectorAttribute *secondConfigurableValue;

@property (nonatomic, strong, readonly) SceneActionSelectorAttribute *nestedAttribute;

- (NSString *)getTitleForIndex:(int)index;
- (SceneActionSelectorAttribute *)getConfigurableValueForIndex:(int)index;

@end

#pragma mark - SceneActionSelectorAttribute
@interface SceneActionSelectorAttribute : NSObject

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSNumber *min;
@property (nonatomic, strong, readonly) NSNumber *max;
@property (nonatomic, strong, readonly) NSNumber *step;
@property (nonatomic, strong, readonly) NSString *unit;
@property (nonatomic, assign, readonly) SceneActionSelectorType type;

// value will be the type that is specified by SceneActionSelectorType type
@property (nonatomic, strong, readonly) SceneActionSelectorAttributeValue *value;

@property (nonatomic, strong, readonly) NSArray *attributeValues;
@property (nonatomic, strong, readonly) NSDictionary* attributesDictionary;

@end


#pragma mark - SceneActionSelector
@interface SceneActionSelector : NSObject

- (instancetype)initWithId:(NSString *)selectorId WithAttributes:(NSArray *)attributes;

@property (nonatomic, strong, readonly) NSString *selectorId;
@property (nonatomic, assign, readonly) NSString *deviceName;
@property (nonatomic, strong, readonly) NSArray<SceneActionSelectorAttribute *> *attributes;


- (BOOL)isConfigurable:(int)groupIndex;

@end


#pragma mark - SceneAction
@interface SceneAction : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)action;

@property (nonatomic, assign, readonly) NSString *actionId;
@property (nonatomic, assign, readonly) NSString *name;
@property (atomic, assign, readonly) BOOL isSatisfiable;
@property (nonatomic, strong, readonly) NSArray<SceneActionSelector *> *selectors;
@property (nonatomic, strong, readonly) NSArray<DeviceModel *> *devicesFromSelectors;
@property (nonatomic, assign, readonly) NSString *hintString;
@property (nonatomic, assign, readonly) SceneActionType type;

- (SceneActionSelector *)getSelectorForDeviceAddress:(NSString *)deviceAddress;

- (NSArray *)buildGroupLabelsAndSelectors:(SceneModel *)currentScene firstGroup:(NSArray **)firstGroup secondGroup:(NSArray **)secondGroup;

@end
