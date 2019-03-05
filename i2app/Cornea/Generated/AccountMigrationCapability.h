

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class AccountModel;




extern NSString *const kCmdAccountMigrationMigrateBillingAccount;




@interface AccountMigrationCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Creates a new V2 billing account for the user based on their V1 service level */
+ (PMKPromise *) migrateBillingAccountWithBillingToken:(NSString *)billingToken withPlaceID:(NSString *)placeID withServiceLevel:(NSString *)serviceLevel onModel:(Model *)modelObj;



@end
