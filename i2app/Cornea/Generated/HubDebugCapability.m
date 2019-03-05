

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubDebugCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdHubDebugGetFiles=@"hubdebug:GetFiles";

NSString *const kCmdHubDebugGetAgentDb=@"hubdebug:GetAgentDb";

NSString *const kCmdHubDebugGetSyslog=@"hubdebug:GetSyslog";

NSString *const kCmdHubDebugGetBootlog=@"hubdebug:GetBootlog";

NSString *const kCmdHubDebugGetProcesses=@"hubdebug:GetProcesses";

NSString *const kCmdHubDebugGetLoad=@"hubdebug:GetLoad";




@implementation HubDebugCapability
+ (NSString *)namespace { return @"hubdebug"; }
+ (NSString *)name { return @"HubDebug"; }



+ (PMKPromise *) getFilesWithPaths:(NSArray *)paths onModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getFiles:modelObj paths:paths];

}


+ (PMKPromise *) getAgentDbOnModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getAgentDb:modelObj ];
}


+ (PMKPromise *) getSyslogOnModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getSyslog:modelObj ];
}


+ (PMKPromise *) getBootlogOnModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getBootlog:modelObj ];
}


+ (PMKPromise *) getProcessesOnModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getProcesses:modelObj ];
}


+ (PMKPromise *) getLoadOnModel:(HubModel *)modelObj {
  return [HubDebugCapabilityLegacy getLoad:modelObj ];
}

@end
