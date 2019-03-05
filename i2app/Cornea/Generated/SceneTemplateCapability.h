

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SceneTemplateModel;







/** Timestamp that the scene template was added to the catalog */
extern NSString *const kAttrSceneTemplateAdded;

/** Timestamp that the scene template was last modified */
extern NSString *const kAttrSceneTemplateModified;

/** The name of the rule template */
extern NSString *const kAttrSceneTemplateName;

/** A description of the rule template */
extern NSString *const kAttrSceneTemplateDescription;

/** True if this is a custom template that may be re-used. */
extern NSString *const kAttrSceneTemplateCustom;

/** Indicates if the scene template is in use or not. */
extern NSString *const kAttrSceneTemplateAvailable;


extern NSString *const kCmdSceneTemplateCreate;

extern NSString *const kCmdSceneTemplateResolveActions;




@interface SceneTemplateCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getAddedFromModel:(SceneTemplateModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(SceneTemplateModel *)modelObj;


+ (NSString *)getNameFromModel:(SceneTemplateModel *)modelObj;


+ (NSString *)getDescriptionFromModel:(SceneTemplateModel *)modelObj;


+ (BOOL)getCustomFromModel:(SceneTemplateModel *)modelObj;


+ (BOOL)getAvailableFromModel:(SceneTemplateModel *)modelObj;





/** Creates a scene instance from a given scene template */
+ (PMKPromise *) createWithPlaceId:(NSString *)placeId withName:(NSString *)name withActions:(NSArray *)actions onModel:(Model *)modelObj;



/** Resolves the actions that are applicable to a scene template. */
+ (PMKPromise *) resolveActionsWithPlaceId:(NSString *)placeId onModel:(Model *)modelObj;



@end
