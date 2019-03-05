

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "DeviceMockCapability.h"
#import <i2app-Swift.h>



NSString *const kCmdDeviceMockSetAttributes=@"devmock:SetAttributes";

NSString *const kCmdDeviceMockConnect=@"devmock:Connect";

NSString *const kCmdDeviceMockDisconnect=@"devmock:Disconnect";




@implementation DeviceMockCapability
+ (NSString *)namespace { return @"devmock"; }
+ (NSString *)name { return @"DeviceMock"; }



+ (PMKPromise *) setAttributesWithAttrs:(NSDictionary *)attrs onModel:(DeviceModel *)modelObj {
  return [DeviceMockCapabilityLegacy setAttributes:modelObj attrs:attrs];

}


+ (PMKPromise *) connectOnModel:(DeviceModel *)modelObj {
  return [DeviceMockCapabilityLegacy connect:modelObj ];
}


+ (PMKPromise *) disconnectOnModel:(DeviceModel *)modelObj {
  return [DeviceMockCapabilityLegacy disconnect:modelObj ];
}

@end
