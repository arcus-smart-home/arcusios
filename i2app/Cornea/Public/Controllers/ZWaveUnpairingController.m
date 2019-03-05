//
//  ZWaveUnpairingController.m
//  Pods
//
//  Created by Arcus Team on 12/16/15.
//
//

#import <i2app-Swift.h>
#import "ZWaveUnpairingController.h"
#import "HubZwaveCapability.h"
#import "HubCapability.h"


#import <PromiseKit/PromiseKit.h>

NSString *const kHubStopUnpairing = @"STOP_UNPAIRING";
NSString *const kHubStartUnpairing = @"START_UNPAIRING";

NSString *const kUnpairedDeviceRemovedNotifcation = @"hubadv:UnpairedDeviceRemoved";

int const kTimeoutInMilliseconds =  60 * 1000 * 2;

@implementation ZWaveUnpairingController {
    HubModel *_hub;
    BOOL _isUnpairing;
}

- (instancetype)initWithHub:(HubModel *)hub {
    if (self = [super init]) {
        _hub = hub;
        _isUnpairing = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRemoved:) name:Constants.kModelRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hubStateChanged:) name:[Model attributeChangedNotification:kAttrHubState] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unpairedDeviceRemoved:) name:kUnpairedDeviceRemovedNotifcation object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)isUnPairing {
    return _isUnpairing;
}

- (void)startUnParing {
    _isUnpairing = YES;
    
    if (!_hub) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [HubCapability unpairingRequestWithActionType:kHubStartUnpairing withTimeout:kTimeoutInMilliseconds withProtocol:@"" withProtocolId:@"" withForce:NO onModel:_hub].thenInBackground(^(HubUnpairingRequestResponse *response) {
            if ([self.delegate respondsToSelector:@selector(successStartUnpairWithResponse:)]) {
                [self.delegate successStartUnpairWithResponse:response];
            }
        }).
        
        catch(^(NSError *error) {
            _isUnpairing = NO;
            if ([self.delegate respondsToSelector:@selector(failToStartUnpairWithError:)]) {
                [self.delegate failToStartUnpairWithError:error];
            }
        });
    });
}

- (void)stopUnParing {
    if (!_hub) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [HubCapability unpairingRequestWithActionType:kHubStopUnpairing withTimeout:0 withProtocol:@"" withProtocolId:@"" withForce:NO onModel:_hub].thenInBackground(^(HubUnpairingRequestResponse *response) {
            _isUnpairing = NO;
            if ([self.delegate respondsToSelector:@selector(successStartUnpairWithResponse:)]) {
                [self.delegate successStopUnpairWithResponse:response];
            }
        }).
        
        catch(^(NSError *error){
            if ([self.delegate respondsToSelector:@selector(failToStopUnpairWithError:)]) {
                [self.delegate failToStopUnpairWithError:error];
            }
        });
    });
    
}

#pragma mark - Notifcations

-(void)deviceRemoved:(NSNotification *)notification {
    if (_isUnpairing == NO) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceRemovedName:)]) {
        [self.delegate deviceRemovedName:((DeviceModel *)notification.object).name];
    }
    
}

#pragma mark - Hub Notifcations

-(void)hubStateChanged:(NSNotification *)notification {
    
    NSString *state = [notification.object objectForKey:kAttrHubState];
    DDLogWarn(@"stateChanged: %@", state);
    
    if ([state isEqualToString:kEnumHubStateNORMAL]) {
        
        if (_isUnpairing == NO) {
            return;
        }
        
        _isUnpairing = NO;
        if( [self.delegate respondsToSelector:@selector(timeOut)]) {
            [self.delegate timeOut];
        }
        
    }
    
    else if ([state isEqualToString:kEnumHubStateUNPAIRING]) {
        _isUnpairing = YES;
    }
}

#pragma mark - UnpairedDeviceRemoved Notifcations
-(void)unpairedDeviceRemoved:(NSNotification *)notification {
    if (_isUnpairing == NO) {
        return;
    }
    
    NSDictionary *attributes = [notification.object objectForKey:@"attributes"];
    NSString *deviceName = [attributes objectForKey:@"devTypeGuess"];
    
    if ([self.delegate respondsToSelector:@selector(deviceRemovedName:)]) {
        [self.delegate deviceRemovedName:deviceName];
    }
}
@end
