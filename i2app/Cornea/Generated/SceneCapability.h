

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SceneModel;



/** The name of the scene */
extern NSString *const kAttrSceneName;

/** Timestamp that the rule was created */
extern NSString *const kAttrSceneCreated;

/** Timestamp that the rule was last modified */
extern NSString *const kAttrSceneModified;

/** The address of the template this scene was created from. */
extern NSString *const kAttrSceneTemplate;

/** Whether or not this scene is enabled, currently this is tied directly to PREMIUM / BASIC status and may not be changed. */
extern NSString *const kAttrSceneEnabled;

/** Whether or not a notification should be fired when this scene is executed. */
extern NSString *const kAttrSceneNotification;

/** The id of the associated scheduler. */
extern NSString *const kAttrSceneScheduler;

/** True while the scene is being executed, the scene may not be ran again until executing is false, at which point all actions have succeeded or failed. */
extern NSString *const kAttrSceneFiring;

/** The actions associated with this scene. */
extern NSString *const kAttrSceneActions;

/** The last time this scene was run. */
extern NSString *const kAttrSceneLastFireTime;

/** The actions associated with this scene. */
extern NSString *const kAttrSceneLastFireStatus;


extern NSString *const kCmdSceneFire;

extern NSString *const kCmdSceneDelete;


extern NSString *const kEnumSceneLastFireStatusNOTRUN;
extern NSString *const kEnumSceneLastFireStatusSUCCESS;
extern NSString *const kEnumSceneLastFireStatusFAILURE;
extern NSString *const kEnumSceneLastFireStatusPARTIAL;


@interface SceneCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getNameFromModel:(SceneModel *)modelObj;

+ (NSString *)setName:(NSString *)name onModel:(Model *)modelObj;


+ (NSDate *)getCreatedFromModel:(SceneModel *)modelObj;


+ (NSDate *)getModifiedFromModel:(SceneModel *)modelObj;


+ (NSString *)getTemplateFromModel:(SceneModel *)modelObj;


+ (BOOL)getEnabledFromModel:(SceneModel *)modelObj;


+ (BOOL)getNotificationFromModel:(SceneModel *)modelObj;

+ (BOOL)setNotification:(BOOL)notification onModel:(Model *)modelObj;


+ (NSString *)getSchedulerFromModel:(SceneModel *)modelObj;


+ (BOOL)getFiringFromModel:(SceneModel *)modelObj;


+ (NSArray *)getActionsFromModel:(SceneModel *)modelObj;

+ (NSArray *)setActions:(NSArray *)actions onModel:(Model *)modelObj;


+ (NSDate *)getLastFireTimeFromModel:(SceneModel *)modelObj;


+ (NSString *)getLastFireStatusFromModel:(SceneModel *)modelObj;





/** Executes the scene */
+ (PMKPromise *) fireOnModel:(Model *)modelObj;



/** Deletes the scene */
+ (PMKPromise *) deleteOnModel:(Model *)modelObj;



@end
