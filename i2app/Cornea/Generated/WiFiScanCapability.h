

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;




extern NSString *const kCmdWiFiScanStartWifiScan;

extern NSString *const kCmdWiFiScanEndWifiScan;


extern NSString *const kEvtWiFiScanWiFiScanResults;



@interface WiFiScanCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;




/** Starts a wifi scan that will end after timeout seconds unless endWifiScan() is called. Periodically, while WiFi scan is active, WiFiScanResults events will be generated. */
+ (PMKPromise *) startWifiScanWithTimeout:(int)timeout onModel:(Model *)modelObj;



/** Ends any active WiFiScan. If no scan is active, this is a no-op. */
+ (PMKPromise *) endWifiScanOnModel:(Model *)modelObj;



@end
