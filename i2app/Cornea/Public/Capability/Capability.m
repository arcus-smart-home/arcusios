//
//  Capability.m
//  Pods
//
//  Created by Arcus Team on 4/17/15.
//
//

#import <i2app-Swift.h>
#import "Capability.h"


static NSString *const kNamespace   = @"base";

NSString *const kAttrId             = @"base:id";
NSString *const kAttrType           = @"base:type";
NSString *const kAttrAddress        = @"base:address";
NSString *const kAttrTags           = @"base:tags";
NSString *const kAttrImages         = @"base:images";
NSString *const kAttrCaps           = @"base:caps";
NSString *const kAttrInstances      = @"base:instances";

NSString *const kCmdGetAttributes   = @"base:GetAttributes";
NSString *const kCmdSetAttributes   = @"base:SetAttributes";

NSString *const kCmdRemoveTags = @"base:RemoveTags";
NSString *const kCmdAddTags = @"base:AddTags";

NSString *const kEventAdded   = @"base:Added";
NSString *const kEventValueChanged = @"base:ValueChange";
NSString *const kEventDeleted = @"base:Deleted";


static NSString *const kEventGetAttributesResponse = @"base:GetAttributesResponse";
static NSString *const kEventSetAttributesError    = @"base:SetAttributesError";


@interface Capability ()

@end


@implementation Capability


+ (NSString *)namespace {
    [NSException raise:NSInternalInconsistencyException
                format:@"Must be overriden %@ in derived class", NSStringFromSelector(_cmd)];
    
    return @"";
}

+ (NSString *)name {
    [NSException raise:NSInternalInconsistencyException
                format:@"Must be overriden %@ in derived class", NSStringFromSelector(_cmd)];
    
    return @"";
}


#pragma mark - Dynamic Properties
+ (NSString *)typeForModel:(Model *)model {
    return [model get][kAttrType];
}

+ (NSString *)capabilityIdForModel:(Model *)model {
    return [model get][kAttrId];
}

+ (NSString *)addressForModel:(Model *)model {
    return [model get][kAttrAddress];
}

+ (NSArray *)tagsForModel:(Model *)model {
    return [model get][kAttrTags];
}

+ (NSDictionary *)imagesForModel:(Model *)model {
    return [model get][kAttrImages];
}

+ (NSArray *)capabilitiesForModel:(Model *)model {
    return [model get][kAttrCaps];
}

+ (NSArray *)instancesForModel:(Model *)model {
    return [model get][kAttrInstances];
}

@end
