

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WiFiCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrWiFiEnabled=@"wifi:enabled";

NSString *const kAttrWiFiState=@"wifi:state";

NSString *const kAttrWiFiSsid=@"wifi:ssid";

NSString *const kAttrWiFiBssid=@"wifi:bssid";

NSString *const kAttrWiFiSecurity=@"wifi:security";

NSString *const kAttrWiFiChannel=@"wifi:channel";

NSString *const kAttrWiFiNoise=@"wifi:noise";

NSString *const kAttrWiFiRssi=@"wifi:rssi";


NSString *const kCmdWiFiConnect=@"wifi:Connect";

NSString *const kCmdWiFiDisconnect=@"wifi:Disconnect";


NSString *const kEnumWiFiStateCONNECTED = @"CONNECTED";
NSString *const kEnumWiFiStateDISCONNECTED = @"DISCONNECTED";
NSString *const kEnumWiFiSecurityNONE = @"NONE";
NSString *const kEnumWiFiSecurityWEP = @"WEP";
NSString *const kEnumWiFiSecurityWPA_PSK = @"WPA_PSK";
NSString *const kEnumWiFiSecurityWPA2_PSK = @"WPA2_PSK";
NSString *const kEnumWiFiSecurityWPA_ENTERPRISE = @"WPA_ENTERPRISE";
NSString *const kEnumWiFiSecurityWPA2_ENTERPRISE = @"WPA2_ENTERPRISE";


@implementation WiFiCapability
+ (NSString *)namespace { return @"wifi"; }
+ (NSString *)name { return @"WiFi"; }

+ (BOOL)getEnabledFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WiFiCapabilityLegacy getEnabled:modelObj] boolValue];
  
}

+ (BOOL)setEnabled:(BOOL)enabled onModel:(DeviceModel *)modelObj {
  [WiFiCapabilityLegacy setEnabled:enabled model:modelObj];
  
  return [[WiFiCapabilityLegacy getEnabled:modelObj] boolValue];
  
}


+ (NSString *)getStateFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WiFiCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getSsidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WiFiCapabilityLegacy getSsid:modelObj];
  
}


+ (NSString *)getBssidFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WiFiCapabilityLegacy getBssid:modelObj];
  
}


+ (NSString *)getSecurityFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [WiFiCapabilityLegacy getSecurity:modelObj];
  
}


+ (int)getChannelFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WiFiCapabilityLegacy getChannel:modelObj] intValue];
  
}


+ (int)getNoiseFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WiFiCapabilityLegacy getNoise:modelObj] intValue];
  
}


+ (int)getRssiFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[WiFiCapabilityLegacy getRssi:modelObj] intValue];
  
}




+ (PMKPromise *) connectWithSsid:(NSString *)ssid withBssid:(NSString *)bssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(DeviceModel *)modelObj {
  return [WiFiCapabilityLegacy connect:modelObj ssid:ssid bssid:bssid security:security key:key];

}


+ (PMKPromise *) disconnectOnModel:(DeviceModel *)modelObj {
  return [WiFiCapabilityLegacy disconnect:modelObj ];
}

@end
