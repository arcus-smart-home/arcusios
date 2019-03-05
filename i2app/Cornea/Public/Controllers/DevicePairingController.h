//
//  DevicePairingController.h
//  Pods
//
//  Created by Arcus Team on 10/1/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;




@interface DevicePairingController : NSObject

+ (PMKPromise *)startHubPairingMode:(PlaceModel *)place;
+ (PMKPromise *)stopHubPairingMode:(PlaceModel *)place;

#pragma mark - Start / Stop Unparing
+ (void)startRemovingDevice:(DeviceModel *)device
           withSuccessBlock:(dispatch_block_t)successBlock
           withFailureBlock:(dispatch_block_t)failureBlock;

+ (PMKPromise *)stopHubUnpairingMode:(HubModel *)hub;

+ (PMKPromise *)forceRemoveDevice:(DeviceModel *)device;

@end
