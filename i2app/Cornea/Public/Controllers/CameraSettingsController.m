//
//  CameraSettingsController.m
//  Pods
//
//  Created by Arcus Team on 10/6/15.
//
//

#import <i2app-Swift.h>
#import "CameraSettingsController.h"
#import "WiFiCapability.h"
#import "WiFiScanCapability.h"
#import "PromiseKit.h"

@implementation CameraSettingsController

+ (PMKPromise *)updateNetworkSettingsWithWifiSSID:(NSString *)name
                                      securityKey:(NSString *)key
                                     securityType:(NSString *)type
                                    onDeviceModel:(DeviceModel *)deviceModel {
    
    // Password is not required if no security is set on WiFi.
    // Setting key to an empty string will prevent the app from crashing.
    if (!key) {
        key = @"";
    }

    return  [WiFiCapability connectWithSsid:name
                                  withBssid:@""
                               withSecurity:type
                                    withKey:key
                                    onModel:deviceModel].thenInBackground(^(WiFiConnectResponse *event) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([event attributes]);
        }];
    });
}

+ (PMKPromise *)getWifiNetworksForDevice:(DeviceModel *)deviceModel
                             withTimeout:(NSNumber *)timeout {
    return [WiFiScanCapability startWifiScanWithTimeout:[timeout intValue]
                                                onModel:deviceModel].then(^(WiFiScanStartWifiScanResponse *event) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill([event attributes]);            
        }];
    });
}

@end
