//
//  DevicePairingController.m
//  Pods
//
//  Created by Arcus Team on 10/1/15.
//
//

#import <i2app-Swift.h>
#import "DevicePairingController.h"
#import "DeviceController.h"


#import "HubCapability.h"
#import "PlaceCapability.h"
#import "DeviceCapability.h"
#import "HubZWaveCapability.h"
#import <PromiseKit/PromiseKit.h>

#import <i2app-Swift.h>

@implementation DevicePairingController

NSString *const kHubStateStartPairing = @"START_PAIRING";
NSString *const kHubStateStopPairing = @"STOP_PAIRING";
NSString *const kHubStateStopUnpairing = @"STOP_UNPAIRING";
NSString *const kHubStateStartUnpairing = @"START_UNPAIRING";

const int kHubPairingTimeoutMs          = 5 * 60 * 1000;
const int kHubUnpairingTimeoutMs        = 5 * 60 * 1000;       // 5 minutes
const int kHubUnpairingTimeoutTriggerS  = 4 * 60;              // Seconds that must pass before a timeout can be declared

DeviceModel         *_deviceModel;
NSDate              *_startTime;

dispatch_block_t    _successBlock;
dispatch_block_t    _failureBlock;

#pragma mark - Start / Stop Pairing
+ (PMKPromise *)startHubPairingMode:(PlaceModel *)place {
    return [PlaceCapability startAddingDevicesWithTime:kHubPairingTimeoutMs onModel:place].catch(^(NSError *error) {
        return [PlaceCapability startAddingDevicesWithTime:kHubPairingTimeoutMs onModel:place].catch(^(NSError *error) {
            return [PlaceCapability startAddingDevicesWithTime:kHubPairingTimeoutMs onModel:place];
        });
    });
}

+ (PMKPromise *)stopHubPairingMode:(PlaceModel *)place {
    return [PlaceCapability stopAddingDevicesOnModel:place].catch(^(NSError *error) {
        return [PlaceCapability stopAddingDevicesOnModel:place].catch(^(NSError *error) {
            return [PlaceCapability stopAddingDevicesOnModel:place];
        });
    });
}

#pragma mark - Remove Device
+ (void)startRemovingDevice:(DeviceModel *)device
           withSuccessBlock:(dispatch_block_t)successBlock
           withFailureBlock:(dispatch_block_t)failureBlock {
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removedDevice:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeout:) name:[Model attributeChangedNotification:kAttrHubState] object:nil];

    _deviceModel = device;
    _startTime = [NSDate date];
    
    [DeviceCapability removeWithTimeout:kHubUnpairingTimeoutMs onModel:device].then(^{
        // Don't do anything - just wait for Constants.kModelRemovedNotification
    }).catch(^(NSError *error) {
        if (_failureBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _failureBlock);
            _failureBlock = nil;
        }
    });
}

+ (PMKPromise *)forceRemoveDevice:(DeviceModel *)device {
    return [DeviceCapability forceRemoveOnModel:device];
}

#pragma mark - Notification

+ (void) timeout:(NSNotification *) notification {
    
    // We can't determine timeout merely by seeing the hub state change; when unpairing a ZB device directly, the hub will automatically
    // transition out of unpairing once a device has been removed (typically a fraction of a second before the app sees the device
    // removed message); therefore, we need to also verify a reasonable amount of time has passed before declairing a timeout error
    NSTimeInterval secondsSinceRequest = [[NSDate date] timeIntervalSinceDate:_startTime];
    
    if (secondsSinceRequest > kHubUnpairingTimeoutTriggerS && ![[notification.object allValues] containsObject:kEnumHubZwaveStateUNPAIRING]) {
        if (_failureBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _failureBlock);
            _failureBlock = nil;
        }
    }
}

+ (void)removedDevice:(NSNotification *)notification {
    if (![[[[CorneaHolder shared] modelCache] fetchModels:[DeviceCapability namespace]] containsObject:_deviceModel]) {
        // Device was removed
        if (_successBlock) {
            // Stop listening for hub state changes
            [[NSNotificationCenter defaultCenter] removeObserver:self name:[Model attributeChangedNotification:kAttrHubState] object:nil];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _successBlock);
            _successBlock = nil;
        }
    }
}

#pragma mark - Start / Stop Unparing
+ (PMKPromise *)stopHubUnpairingMode:(HubModel *)hub {
    
    if (hub) {
        return [HubCapability unpairingRequestWithActionType:kHubStateStopUnpairing withTimeout:0 withProtocol:@"" withProtocolId:@"" withForce:YES onModel:hub].thenInBackground(^(HubPairingRequestResponse *response) {
            // DDLogWarn(@"HubUnpairingRequestResponse %@", [response get].description);
        });
    }
    
    // Nothing to do if no hub exists
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(nil);
        }];
    }
}

@end
