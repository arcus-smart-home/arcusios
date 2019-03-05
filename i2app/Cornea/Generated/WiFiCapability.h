

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;











/** When true, wireless interface is enabled. */
extern NSString *const kAttrWiFiEnabled;

/** Indicates whether or not this device has a WiFi connection to an access point. */
extern NSString *const kAttrWiFiState;

/** SSID of base station connected to. */
extern NSString *const kAttrWiFiSsid;

/** BSSID of base station connected to. */
extern NSString *const kAttrWiFiBssid;

/** Security of connection. */
extern NSString *const kAttrWiFiSecurity;

/** Channel in use. */
extern NSString *const kAttrWiFiChannel;

/** Noise level in dBm */
extern NSString *const kAttrWiFiNoise;

/** Received signal stength indicator in dB. */
extern NSString *const kAttrWiFiRssi;


extern NSString *const kCmdWiFiConnect;

extern NSString *const kCmdWiFiDisconnect;


extern NSString *const kEnumWiFiStateCONNECTED;
extern NSString *const kEnumWiFiStateDISCONNECTED;
extern NSString *const kEnumWiFiSecurityNONE;
extern NSString *const kEnumWiFiSecurityWEP;
extern NSString *const kEnumWiFiSecurityWPA_PSK;
extern NSString *const kEnumWiFiSecurityWPA2_PSK;
extern NSString *const kEnumWiFiSecurityWPA_ENTERPRISE;
extern NSString *const kEnumWiFiSecurityWPA2_ENTERPRISE;


@interface WiFiCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (BOOL)getEnabledFromModel:(DeviceModel *)modelObj;

+ (BOOL)setEnabled:(BOOL)enabled onModel:(DeviceModel *)modelObj;


+ (NSString *)getStateFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSsidFromModel:(DeviceModel *)modelObj;


+ (NSString *)getBssidFromModel:(DeviceModel *)modelObj;


+ (NSString *)getSecurityFromModel:(DeviceModel *)modelObj;


+ (int)getChannelFromModel:(DeviceModel *)modelObj;


+ (int)getNoiseFromModel:(DeviceModel *)modelObj;


+ (int)getRssiFromModel:(DeviceModel *)modelObj;





/** Attempts to connect to the access point with the given properties. */
+ (PMKPromise *) connectWithSsid:(NSString *)ssid withBssid:(NSString *)bssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(Model *)modelObj;



/** Disconnects from current access point. USE WITH CAUTION. */
+ (PMKPromise *) disconnectOnModel:(Model *)modelObj;



@end
