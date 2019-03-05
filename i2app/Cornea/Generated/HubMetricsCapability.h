

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;











/** List of the active metrics reporting jobs. */
extern NSString *const kAttrHubMetricsMetricsjobs;


extern NSString *const kCmdHubMetricsStartMetricsJob;

extern NSString *const kCmdHubMetricsEndMetricsJobs;

extern NSString *const kCmdHubMetricsGetMetricsJobInfo;

extern NSString *const kCmdHubMetricsListMetrics;

extern NSString *const kCmdHubMetricsGetStoredMetrics;




@interface HubMetricsCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getMetricsjobsFromModel:(HubModel *)modelObj;





/** Start a job of the given name with the given parameters. */
+ (PMKPromise *) startMetricsJobWithJobname:(NSString *)jobname withPeriodMs:(long)periodMs withDurationMs:(long)durationMs withMetrics:(NSArray *)metrics onModel:(Model *)modelObj;



/** Instructs the hub to cancel the name metrics reporting job. */
+ (PMKPromise *) endMetricsJobsWithJobname:(NSString *)jobname onModel:(Model *)modelObj;



/** Get information about a running job. */
+ (PMKPromise *) getMetricsJobInfoWithJobname:(NSString *)jobname onModel:(Model *)modelObj;



/** List all of the current metrics.. */
+ (PMKPromise *) listMetricsWithRegex:(NSString *)regex onModel:(Model *)modelObj;



/** Retrieves the metrics stored in the long term metrics store. */
+ (PMKPromise *) getStoredMetricsOnModel:(Model *)modelObj;



@end
