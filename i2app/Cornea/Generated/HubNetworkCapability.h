

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;



/** Name of the primary network interface. */
extern NSString *const kAttrHubNetworkType;

/** Elapsed second since last change of the active interface type. */
extern NSString *const kAttrHubNetworkUptime;

/** ip address of the active interface */
extern NSString *const kAttrHubNetworkIp;

/** External ip address of the active interface as detected by the hub bridge. */
extern NSString *const kAttrHubNetworkExternalip;

/** netmask of the gateway */
extern NSString *const kAttrHubNetworkNetmask;

/** IP Address gateway */
extern NSString *const kAttrHubNetworkGateway;

/** CSV of the DNS server IP Addresses. */
extern NSString *const kAttrHubNetworkDns;

/** ip address of the active interface */
extern NSString *const kAttrHubNetworkInterfaces;


extern NSString *const kCmdHubNetworkGetRoutingTable;


extern NSString *const kEnumHubNetworkTypeETH;
extern NSString *const kEnumHubNetworkType3G;
extern NSString *const kEnumHubNetworkTypeWIFI;


@interface HubNetworkCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTypeFromModel:(HubModel *)modelObj;


+ (long)getUptimeFromModel:(HubModel *)modelObj;


+ (NSString *)getIpFromModel:(HubModel *)modelObj;


+ (NSString *)getExternalipFromModel:(HubModel *)modelObj;


+ (NSString *)getNetmaskFromModel:(HubModel *)modelObj;


+ (NSString *)getGatewayFromModel:(HubModel *)modelObj;


+ (NSString *)getDnsFromModel:(HubModel *)modelObj;


+ (NSArray *)getInterfacesFromModel:(HubModel *)modelObj;





/** Gets the routing table for the active netowrk interface. */
+ (PMKPromise *) getRoutingTableOnModel:(Model *)modelObj;



@end
