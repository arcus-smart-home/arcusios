

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubWiFiCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubWiFiWifiEnabled=@"hubwifi:wifiEnabled";

NSString *const kAttrHubWiFiWifiState=@"hubwifi:wifiState";

NSString *const kAttrHubWiFiWifiSsid=@"hubwifi:wifiSsid";

NSString *const kAttrHubWiFiWifiBssid=@"hubwifi:wifiBssid";

NSString *const kAttrHubWiFiWifiSecurity=@"hubwifi:wifiSecurity";

NSString *const kAttrHubWiFiWifiChannel=@"hubwifi:wifiChannel";

NSString *const kAttrHubWiFiWifiNoise=@"hubwifi:wifiNoise";

NSString *const kAttrHubWiFiWifiRssi=@"hubwifi:wifiRssi";


NSString *const kCmdHubWiFiWiFiConnect=@"hubwifi:WiFiConnect";

NSString *const kCmdHubWiFiWiFiDisconnect=@"hubwifi:WiFiDisconnect";

NSString *const kCmdHubWiFiWiFiStartScan=@"hubwifi:WiFiStartScan";

NSString *const kCmdHubWiFiWiFiEndScan=@"hubwifi:WiFiEndScan";


NSString *const kEvtHubWiFiWiFiScanResults=@"hubwifi:WiFiScanResults";

NSString *const kEnumHubWiFiWifiStateCONNECTED = @"CONNECTED";
NSString *const kEnumHubWiFiWifiStateDISCONNECTED = @"DISCONNECTED";
NSString *const kEnumHubWiFiWifiSecurityNONE = @"NONE";
NSString *const kEnumHubWiFiWifiSecurityWEP = @"WEP";
NSString *const kEnumHubWiFiWifiSecurityWPA_PSK = @"WPA_PSK";
NSString *const kEnumHubWiFiWifiSecurityWPA2_PSK = @"WPA2_PSK";
NSString *const kEnumHubWiFiWifiSecurityWPA_ENTERPRISE = @"WPA_ENTERPRISE";
NSString *const kEnumHubWiFiWifiSecurityWPA2_ENTERPRISE = @"WPA2_ENTERPRISE";


@implementation HubWiFiCapability
+ (NSString *)namespace { return @"hubwifi"; }
+ (NSString *)name { return @"HubWiFi"; }

+ (BOOL)getWifiEnabledFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubWiFiCapabilityLegacy getWifiEnabled:modelObj] boolValue];
  
}

+ (BOOL)setWifiEnabled:(BOOL)wifiEnabled onModel:(HubModel *)modelObj {
  [HubWiFiCapabilityLegacy setWifiEnabled:wifiEnabled model:modelObj];
  
  return [[HubWiFiCapabilityLegacy getWifiEnabled:modelObj] boolValue];
  
}


+ (NSString *)getWifiStateFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubWiFiCapabilityLegacy getWifiState:modelObj];
  
}


+ (NSString *)getWifiSsidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubWiFiCapabilityLegacy getWifiSsid:modelObj];
  
}


+ (NSString *)getWifiBssidFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubWiFiCapabilityLegacy getWifiBssid:modelObj];
  
}


+ (NSString *)getWifiSecurityFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubWiFiCapabilityLegacy getWifiSecurity:modelObj];
  
}


+ (int)getWifiChannelFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubWiFiCapabilityLegacy getWifiChannel:modelObj] intValue];
  
}


+ (int)getWifiNoiseFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubWiFiCapabilityLegacy getWifiNoise:modelObj] intValue];
  
}


+ (int)getWifiRssiFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubWiFiCapabilityLegacy getWifiRssi:modelObj] intValue];
  
}




+ (PMKPromise *) wiFiConnectWithSsid:(NSString *)ssid withBssid:(NSString *)bssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(HubModel *)modelObj {
  return [HubWiFiCapabilityLegacy wiFiConnect:modelObj ssid:ssid bssid:bssid security:security key:key];

}


+ (PMKPromise *) wiFiDisconnectOnModel:(HubModel *)modelObj {
  return [HubWiFiCapabilityLegacy wiFiDisconnect:modelObj ];
}


+ (PMKPromise *) wiFiStartScanWithTimeout:(int)timeout onModel:(HubModel *)modelObj {
  return [HubWiFiCapabilityLegacy wiFiStartScan:modelObj timeout:timeout];

}


+ (PMKPromise *) wiFiEndScanOnModel:(HubModel *)modelObj {
  return [HubWiFiCapabilityLegacy wiFiEndScan:modelObj ];
}

@end
