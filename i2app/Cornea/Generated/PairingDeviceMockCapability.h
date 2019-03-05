

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class PairingDeviceMockModel;



/** The eventual product address that will be displayed when / if a driver is created for this mock. */
extern NSString *const kAttrPairingDeviceMockTargetProductAddress;


extern NSString *const kCmdPairingDeviceMockUpdatePairingPhase;




@interface PairingDeviceMockCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getTargetProductAddressFromModel:(PairingDeviceMockModel *)modelObj;





/** Updates the pairing phase, does not allow the mock to &#x27;go backwards&#x27; */
+ (PMKPromise *) updatePairingPhaseWithPhase:(NSString *)phase onModel:(Model *)modelObj;



@end
