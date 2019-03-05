

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "TestCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrTestLastTestTime=@"test:lastTestTime";



NSString *const kEvtTestTest=@"test:Test";



@implementation TestCapability
+ (NSString *)namespace { return @"test"; }
+ (NSString *)name { return @"Test"; }

+ (NSDate *)getLastTestTimeFromModel:(DeviceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [TestCapabilityLegacy getLastTestTime:modelObj];
  
}



@end
