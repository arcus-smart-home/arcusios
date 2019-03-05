//
//  ZWaveUnpairingController.h
//  Pods
//
//  Created by Arcus Team on 12/16/15.
//
//

#import <Foundation/Foundation.h>
#import "HubCapability.h"

@protocol ZWaveUnpairingControllerDelegate <NSObject>

- (void)successStartUnpairWithResponse:(HubUnpairingRequestResponse *)response;

- (void)failToStartUnpairWithError:(NSError*)error;

@optional
- (void)deviceRemovedName:(NSString *)deviceRemovedName;

- (void)failToStopUnpairWithError:(NSError*)error;
- (void)successStopUnpairWithResponse:(HubUnpairingRequestResponse *)response;
- (void)timeOut;

@end

@interface ZWaveUnpairingController : NSObject

@property (nonatomic, weak)id <ZWaveUnpairingControllerDelegate>delegate;
- (instancetype)initWithHub:(HubModel*)hub;
- (BOOL)isUnPairing;
- (void)startUnParing;
- (void)stopUnParing;

@end
