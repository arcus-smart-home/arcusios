

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;
















extern NSString *const kCmdHubDebugGetFiles;

extern NSString *const kCmdHubDebugGetAgentDb;

extern NSString *const kCmdHubDebugGetSyslog;

extern NSString *const kCmdHubDebugGetBootlog;

extern NSString *const kCmdHubDebugGetProcesses;

extern NSString *const kCmdHubDebugGetLoad;




@interface HubDebugCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Gets the current contents of the HubOS syslog file. */
+ (PMKPromise *) getFilesWithPaths:(NSArray *)paths onModel:(Model *)modelObj;



/** Gets the current contents of the agent database. */
+ (PMKPromise *) getAgentDbOnModel:(Model *)modelObj;



/** Gets the current contents of the HubOS syslog file. */
+ (PMKPromise *) getSyslogOnModel:(Model *)modelObj;



/** Gets the current contents of the HubOS bootlog file. */
+ (PMKPromise *) getBootlogOnModel:(Model *)modelObj;



/** Gets the current list of processes from the HubOS. */
+ (PMKPromise *) getProcessesOnModel:(Model *)modelObj;



/** Gets the current process load information from the HubOS. */
+ (PMKPromise *) getLoadOnModel:(Model *)modelObj;



@end
