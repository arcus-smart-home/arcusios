//
//  IPCDServiceController.m
//  Pods
//
//  Created by Arcus Team on 10/30/15.
//
//

#import <i2app-Swift.h>
#import "IPCDServiceController.h"

#import "BridgeService.h"
#import <PromiseKit/PromiseKit.h>

#define kRetryTimeInSeconds 1
#define kTimeoutInSeconds 300

NSString *const kErrorNotFound = @"request.destination.notfound";
NSString *const kErrorDevAlreadyClaimed = @"request.invalid";

@implementation IPCDServiceController{
    NSTimer *_regiterTimer;
    NSString *_target;
    NSDictionary *_attributes;
    int _timeoutCounter;
}

//target and attributes was extracted from product catalog
// target "BRDG::IPCD"
// attributes {"IPCD:sn":"123456789002","IPCD:v1devicetype":"GenieGDOController"}
- (instancetype) initWithTarget:(NSString *)target attributes:(NSDictionary *)attrs {
    if (self = [super init]) {
        _target = target;
        _attributes = attrs;
    }
    return self;
}

- (NSInteger)timeout {
    return _timeout = (_timeout == 0) ? kTimeoutInSeconds : _timeout;
}

- (PMKPromise *) registerDeviceWithTarget:(NSString *)target attributes:(NSDictionary *)attrs {
    return [BridgeService registerDeviceWithAttrs:attrs]
    .thenInBackground(^(BridgeServiceRegisterDeviceResponse *response) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(response);
        }];
    });
}

- (void)startPairing {
    [self startRegisterTimer];
}

- (void)stopPairing {
    [self stopRegisterTimer];
}

- (void)startRegisterTimer {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self registerDeviceWithTarget:_target attributes:_attributes].then(^(BridgeServiceRegisterDeviceResponse *response){
            [self stopRegisterTimer];
            if( [self.delegate respondsToSelector:@selector(successfulParing)]) {
                [self.delegate successfulParing];
            }
            
        }).catch(^(NSError *error) {
            NSString  *errorCode = [error.userInfo objectForKey:@"code"];
            
            if ([errorCode isEqualToString:kErrorDevAlreadyClaimed]) {
                [self stopRegisterTimer];
                if( [self.delegate respondsToSelector:@selector(failedParingDeviceHasOwner)]) {
                    [self.delegate failedParingDeviceHasOwner];
                }
            }
            else if ([errorCode isEqualToString:kErrorNotFound]) {
                [self stopRegisterTimer];
                if( [self.delegate respondsToSelector:@selector(failedParingDeviceNotFound)]) {
                    [self.delegate failedParingDeviceNotFound];
                }
            }
        });
    });
    
    _timeoutCounter = 0;
    _regiterTimer  = [NSTimer scheduledTimerWithTimeInterval:kRetryTimeInSeconds
                                                      target:self
                                                    selector:@selector(handleRetryTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopRegisterTimer {
    [_regiterTimer invalidate];
    _regiterTimer = nil;
}

- (void)handleRetryTimer {
    if (_timeoutCounter >= self.timeout) {
        [self stopRegisterTimer];
        if( [self.delegate respondsToSelector:@selector(paringHasTimeOut)]) {
            [self.delegate paringHasTimeOut];
            return;
        }
    }
    
    _timeoutCounter ++;
}

@end
