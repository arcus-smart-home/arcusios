

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubBackupCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdHubBackupBackup=@"hubbackup:Backup";

NSString *const kCmdHubBackupRestore=@"hubbackup:Restore";


NSString *const kEvtHubBackupRestoreFinished=@"hubbackup:RestoreFinished";

NSString *const kEvtHubBackupRestoreProgress=@"hubbackup:RestoreProgress";



@implementation HubBackupCapability
+ (NSString *)namespace { return @"hubbackup"; }
+ (NSString *)name { return @"HubBackup"; }



+ (PMKPromise *) backupWithType:(NSString *)type onModel:(HubModel *)modelObj {
  return [HubBackupCapabilityLegacy backup:modelObj type:type];

}


+ (PMKPromise *) restoreWithType:(NSString *)type withData:(NSString *)data onModel:(HubModel *)modelObj {
  return [HubBackupCapabilityLegacy restore:modelObj type:type data:data];

}

@end
