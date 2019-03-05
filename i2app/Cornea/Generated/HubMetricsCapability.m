

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubMetricsCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubMetricsMetricsjobs=@"hubmetric:metricsjobs";


NSString *const kCmdHubMetricsStartMetricsJob=@"hubmetric:StartMetricsJob";

NSString *const kCmdHubMetricsEndMetricsJobs=@"hubmetric:EndMetricsJobs";

NSString *const kCmdHubMetricsGetMetricsJobInfo=@"hubmetric:GetMetricsJobInfo";

NSString *const kCmdHubMetricsListMetrics=@"hubmetric:ListMetrics";

NSString *const kCmdHubMetricsGetStoredMetrics=@"hubmetric:GetStoredMetrics";




@implementation HubMetricsCapability
+ (NSString *)namespace { return @"hubmetric"; }
+ (NSString *)name { return @"HubMetrics"; }

+ (NSArray *)getMetricsjobsFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubMetricsCapabilityLegacy getMetricsjobs:modelObj];
  
}




+ (PMKPromise *) startMetricsJobWithJobname:(NSString *)jobname withPeriodMs:(long)periodMs withDurationMs:(long)durationMs withMetrics:(NSArray *)metrics onModel:(HubModel *)modelObj {
  return [HubMetricsCapabilityLegacy startMetricsJob:modelObj jobname:jobname periodMs:periodMs durationMs:durationMs metrics:metrics];

}


+ (PMKPromise *) endMetricsJobsWithJobname:(NSString *)jobname onModel:(HubModel *)modelObj {
  return [HubMetricsCapabilityLegacy endMetricsJobs:modelObj jobname:jobname];

}


+ (PMKPromise *) getMetricsJobInfoWithJobname:(NSString *)jobname onModel:(HubModel *)modelObj {
  return [HubMetricsCapabilityLegacy getMetricsJobInfo:modelObj jobname:jobname];

}


+ (PMKPromise *) listMetricsWithRegex:(NSString *)regex onModel:(HubModel *)modelObj {
  return [HubMetricsCapabilityLegacy listMetrics:modelObj regex:regex];

}


+ (PMKPromise *) getStoredMetricsOnModel:(HubModel *)modelObj {
  return [HubMetricsCapabilityLegacy getStoredMetrics:modelObj ];
}

@end
