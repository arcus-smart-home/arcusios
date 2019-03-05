

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "AccountMigrationCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdAccountMigrationMigrateBillingAccount=@"accountmig:MigrateBillingAccount";




@implementation AccountMigrationCapability
+ (NSString *)namespace { return @"accountmig"; }
+ (NSString *)name { return @"AccountMigration"; }



+ (PMKPromise *) migrateBillingAccountWithBillingToken:(NSString *)billingToken withPlaceID:(NSString *)placeID withServiceLevel:(NSString *)serviceLevel onModel:(AccountModel *)modelObj {
  return [AccountMigrationCapabilityLegacy migrateBillingAccount:modelObj billingToken:billingToken placeID:placeID serviceLevel:serviceLevel];

}

@end
