

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class PopulationModel;





/** Population Name */
extern NSString *const kAttrPopulationName;

/** Population Description */
extern NSString *const kAttrPopulationDescription;

/** Indicates that this population is the default population */
extern NSString *const kAttrPopulationIsDefault;


extern NSString *const kCmdPopulationGetPopulations;




@interface PopulationCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getNameFromModel:(PopulationModel *)modelObj;


+ (NSString *)getDescriptionFromModel:(PopulationModel *)modelObj;


+ (BOOL)getIsDefaultFromModel:(PopulationModel *)modelObj;





/** Returns information on all populations. */
+ (PMKPromise *) getPopulationsOnModel:(Model *)modelObj;



@end
