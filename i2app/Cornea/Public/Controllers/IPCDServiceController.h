//
//  IPCDServiceController.h
//  Pods
//
//  Created by Arcus Team on 10/30/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@protocol IPCDServiceDelegate <NSObject>

- (void)successfulParing;

- (void)paringHasTimeOut;
- (void)failedParingDeviceHasOwner;
- (void)failedParingDeviceNotFound;

@end


@interface IPCDServiceController : NSObject

//target and attributes was extracted from product catalog
// target "BRDG::IPCD"
// attributes {"IPCD:sn":"123456789002","IPCD:v1devicetype":"GenieGDOController"}

- (instancetype) initWithTarget:(NSString *)target attributes:(NSDictionary *)attrs;

@property (nonatomic, weak) id <IPCDServiceDelegate> delegate;
@property (nonatomic, assign) NSInteger timeout;

- (void)startPairing;
- (void)stopPairing;

@end
