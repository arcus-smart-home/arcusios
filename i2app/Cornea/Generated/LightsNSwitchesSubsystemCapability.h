

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class SubsystemModel;



/** The set of switch devices in the place */
extern NSString *const kAttrLightsNSwitchesSubsystemSwitchDevices;

/** The addresses of LIGHTS device groups defined at this place */
extern NSString *const kAttrLightsNSwitchesSubsystemDeviceGroups;

/** A map of deviceTypeHint to count of devices that are currently on. */
extern NSString *const kAttrLightsNSwitchesSubsystemOnDeviceCounts;





@interface LightsNSwitchesSubsystemCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSArray *)getSwitchDevicesFromModel:(SubsystemModel *)modelObj;


+ (NSArray *)getDeviceGroupsFromModel:(SubsystemModel *)modelObj;


+ (NSDictionary *)getOnDeviceCountsFromModel:(SubsystemModel *)modelObj;





@end
