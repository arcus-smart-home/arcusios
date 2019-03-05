

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;






extern NSString *const kCmdHubBackupBackup;

extern NSString *const kCmdHubBackupRestore;


extern NSString *const kEvtHubBackupRestoreFinished;

extern NSString *const kEvtHubBackupRestoreProgress;



@interface HubBackupCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Performs a backup in the hub, returning a binary blob in response. */
+ (PMKPromise *) backupWithType:(NSString *)type onModel:(Model *)modelObj;



/** Performs a restore on the hub. */
+ (PMKPromise *) restoreWithType:(NSString *)type withData:(NSString *)data onModel:(Model *)modelObj;



@end
