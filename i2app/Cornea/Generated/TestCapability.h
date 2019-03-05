

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class DeviceModel;



/** The last time the device was tested (a test:Test event was emitted). */
extern NSString *const kAttrTestLastTestTime;



extern NSString *const kEvtTestTest;



@interface TestCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSDate *)getLastTestTimeFromModel:(DeviceModel *)modelObj;





@end
