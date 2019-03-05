

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;











/** When true, wireless interface is enabled. */
extern NSString *const kAttrHubWiFiWifiEnabled;

/** Indicates whether or not this device has a WiFi connection to an access point. */
extern NSString *const kAttrHubWiFiWifiState;

/** SSID of base station connected to. */
extern NSString *const kAttrHubWiFiWifiSsid;

/** BSSID of base station connected to. */
extern NSString *const kAttrHubWiFiWifiBssid;

/** Security of connection. */
extern NSString *const kAttrHubWiFiWifiSecurity;

/** Channel in use. */
extern NSString *const kAttrHubWiFiWifiChannel;

/** Noise level in dBm */
extern NSString *const kAttrHubWiFiWifiNoise;

/** Received signal stength indicator in dB. */
extern NSString *const kAttrHubWiFiWifiRssi;


extern NSString *const kCmdHubWiFiWiFiConnect;

extern NSString *const kCmdHubWiFiWiFiDisconnect;

extern NSString *const kCmdHubWiFiWiFiStartScan;

extern NSString *const kCmdHubWiFiWiFiEndScan;


extern NSString *const kEvtHubWiFiWiFiScanResults;

extern NSString *const kEnumHubWiFiWifiStateCONNECTED;
extern NSString *const kEnumHubWiFiWifiStateDISCONNECTED;
extern NSString *const kEnumHubWiFiWifiSecurityNONE;
extern NSString *const kEnumHubWiFiWifiSecurityWEP;
extern NSString *const kEnumHubWiFiWifiSecurityWPA_PSK;
extern NSString *const kEnumHubWiFiWifiSecurityWPA2_PSK;
extern NSString *const kEnumHubWiFiWifiSecurityWPA_ENTERPRISE;
extern NSString *const kEnumHubWiFiWifiSecurityWPA2_ENTERPRISE;


@interface HubWiFiCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getWifiEnabledFromModel:(HubModel *)modelObj;

+ (BOOL)setWifiEnabled:(BOOL)wifiEnabled onModel:(HubModel *)modelObj;


+ (NSString *)getWifiStateFromModel:(HubModel *)modelObj;


+ (NSString *)getWifiSsidFromModel:(HubModel *)modelObj;


+ (NSString *)getWifiBssidFromModel:(HubModel *)modelObj;


+ (NSString *)getWifiSecurityFromModel:(HubModel *)modelObj;


+ (int)getWifiChannelFromModel:(HubModel *)modelObj;


+ (int)getWifiNoiseFromModel:(HubModel *)modelObj;


+ (int)getWifiRssiFromModel:(HubModel *)modelObj;





/** Attempts to connect to the access point with the given properties. */
+ (PMKPromise *) wiFiConnectWithSsid:(NSString *)ssid withBssid:(NSString *)bssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(Model *)modelObj;



/** Disconnects from current access point. USE WITH CAUTION. */
+ (PMKPromise *) wiFiDisconnectOnModel:(Model *)modelObj;



/** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
+ (PMKPromise *) wiFiStartScanWithTimeout:(int)timeout onModel:(Model *)modelObj;



/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
+ (PMKPromise *) wiFiEndScanOnModel:(Model *)modelObj;



@end
