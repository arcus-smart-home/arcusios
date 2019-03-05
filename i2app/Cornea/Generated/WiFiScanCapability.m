

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "WiFiScanCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdWiFiScanStartWifiScan=@"wifiscan:StartWifiScan";

NSString *const kCmdWiFiScanEndWifiScan=@"wifiscan:EndWifiScan";


NSString *const kEvtWiFiScanWiFiScanResults=@"wifiscan:WiFiScanResults";



@implementation WiFiScanCapability
+ (NSString *)namespace { return @"wifiscan"; }
+ (NSString *)name { return @"WiFiScan"; }



+ (PMKPromise *) startWifiScanWithTimeout:(int)timeout onModel:(DeviceModel *)modelObj {
  return [WiFiScanCapabilityLegacy startWifiScan:modelObj timeout:timeout];

}


+ (PMKPromise *) endWifiScanOnModel:(DeviceModel *)modelObj {
  return [WiFiScanCapabilityLegacy endWifiScan:modelObj ];
}

@end
