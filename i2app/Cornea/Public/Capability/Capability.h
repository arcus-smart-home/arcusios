//
//  Capability.h
//  Pods
//
//  Created by Arcus Team on 4/17/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const kAttrId;
extern NSString *const kAttrType;
extern NSString *const kAttrAddress;
extern NSString *const kAttrTags;
extern NSString *const kAttrImages;
extern NSString *const kAttrCaps;
extern NSString *const kAttrInstances;

extern NSString *const kCmdGetAttributes;
extern NSString *const kCmdSetAttributes;
extern NSString *const kCmdRemoveTags;
extern NSString *const kCmdAddTags;

extern NSString *const kEventAdded;
extern NSString *const kEventValueChanged;
extern NSString *const kEventDeleted;

@class Model;

@interface Capability : NSObject

+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)typeForModel:(Model *)model;
+ (NSString *)capabilityIdForModel:(Model *)model;
+ (NSString *)addressForModel:(Model *)model;
+ (NSArray *)tagsForModel:(Model *)model;
+ (NSDictionary *)imagesForModel:(Model *)model;
+ (NSArray *)capabilitiesForModel:(Model *)model;
+ (NSArray *)instancesForModel:(Model *)model;
@end
