//
//  CameraSettingsController.h
//  Pods
//
//  Created by Arcus Team on 10/6/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;


@interface CameraSettingsController : NSObject

+ (PMKPromise *)updateNetworkSettingsWithWifiSSID:(NSString *)name
                                      securityKey:(NSString *)key
                                     securityType:(NSString *)type
                                    onDeviceModel:(DeviceModel *)deviceModel;
+ (PMKPromise *)getWifiNetworksForDevice:(DeviceModel *)deviceModel
                             withTimeout:(NSNumber *)timeout;

@end
