//
//  LightsNSwitchesSubsystemController.m
//  Pods
//
//  Created by Arcus Team on 12/2/15.
//
//

#import <i2app-Swift.h>
#import "LightsNSwitchesSubsystemController.h"
#import "LightsNSwitchesSubsystemCapability.h"



#define aSavedDevicesKey @"savedLightsNSwitchsDeviceIDs"

@implementation LightsNSwitchesSubsystemController

@synthesize subsystemModel;
@synthesize numberOfDevices;

@dynamic allDeviceIds;

@dynamic numberOfOnDevices;
@dynamic numberOfOnDimmers;
@dynamic numberOfOnLights;
@dynamic numberOfOnSwitches;

@dynamic allDimmersAddresses;
@dynamic allLightsAddresses;
@dynamic allSwitchesAddresses;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self  = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}

#pragma mark - SubsystemProtocol
- (int)numberOfDevices {
    return (int)[LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel].count;
}

- (void)saveOrderedDeviceIDs:(NSArray *)ids {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:ids];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedObject forKey:aSavedDevicesKey];
    [userDefaults synchronize];
}

- (NSMutableArray *)getOrderedDeviceIDs {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [userDefaults objectForKey:aSavedDevicesKey];
    NSMutableArray *savedDeviceIDs = [[NSMutableArray alloc] init];
    if (encodedObject) {
        savedDeviceIDs = [[NSMutableArray alloc] initWithArray: [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject]];
    }
    return savedDeviceIDs;
}

- (NSArray *)removedDeviceIds {
    NSMutableSet *oldSet = [NSMutableSet setWithArray:[self getOrderedDeviceIDs]];
    NSMutableSet *newSet = [NSMutableSet setWithArray:[LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel]];
    [newSet intersectSet:oldSet];
    [oldSet minusSet:newSet];
    
    return [oldSet allObjects];
}

- (NSArray *)addedDeviceIds {
    NSMutableSet *oldSet = [NSMutableSet setWithArray:[self getOrderedDeviceIDs]];
    NSMutableSet *newSet = [NSMutableSet setWithArray:[LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel]];
    [oldSet intersectSet:newSet];
    [newSet minusSet:oldSet];
    
    return [newSet allObjects];
}

- (NSArray *)sortedAlphbeticalIds:(NSArray *)deviceIds {
    NSMutableArray *sortDeviceIds = [self getModelSourcesFromSourcesSortedAlphabetically:deviceIds].mutableCopy;
    
    for (int i=0; i<sortDeviceIds.count; i++) {
        if (![sortDeviceIds[i] hasPrefix:@"DRIV:dev:"]) {
            [sortDeviceIds replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"DRIV:dev:%@", sortDeviceIds[i]]];
        }
    }
    
    return sortDeviceIds;
}

// Get an array of model Ids sorted alphabetically based on the Model Name
- (NSArray *)getModelSourcesFromSourcesSortedAlphabetically:(NSArray *)sources {

  NSMutableArray *models = [[NSMutableArray alloc] initWithCapacity:sources.count];
  for (NSString *source in sources) {
      Model *model = [[[CorneaHolder shared] modelCache] fetchModel:source];
      if (model) {
          [models addObject:model];
      }
  }

  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  [models sortUsingDescriptors:@[sort]];

  NSMutableArray *sortedModelIds = [[NSMutableArray alloc] initWithCapacity:models.count];

  for (Model *model in models) {
    [sortedModelIds addObject:model.modelId];
  }
  return sortedModelIds.copy;
}

- (NSArray *)allDeviceIds {
    
    NSMutableArray *savedDeviceIDs = [self getOrderedDeviceIDs];
    
    //remove device no longer exit
    for (NSString *deviceId in [self removedDeviceIds]) {
        for(NSString *removedId in savedDeviceIDs) {
            if ([removedId isEqualToString:deviceId]) {
                [savedDeviceIDs removeObject:deviceId];
                break;
            }
        }
    }
    
    NSArray *sortedNewDeviceIds = [self sortedAlphbeticalIds:[self addedDeviceIds]];
    [savedDeviceIDs addObjectsFromArray:sortedNewDeviceIds];
    [self saveOrderedDeviceIDs:savedDeviceIDs];
    
    return savedDeviceIDs;
}

- (void)switchOrderFrom:(NSInteger)oldPosition to:(NSInteger)newPosition {
    NSMutableArray *savedDeviceIDs = [self getOrderedDeviceIDs];
    if (savedDeviceIDs.count > oldPosition && savedDeviceIDs.count > newPosition) {
        id item = savedDeviceIDs[oldPosition];
        [savedDeviceIDs removeObjectAtIndex:oldPosition];
        [savedDeviceIDs insertObject:item atIndex:newPosition];
        
        [self saveOrderedDeviceIDs:savedDeviceIDs];
    }
}


- (int)numberOfOnDevices {
    return ([self numberOfOnDimmers] + [self numberOfOnLights] + [self numberOfOnSwitches]);
}

- (int)numberOfOnDimmers {
    return ((NSNumber *)[LightsNSwitchesSubsystemCapability getOnDeviceCountsFromModel:self.subsystemModel][@"dimmer"]).intValue;
}

#pragma mark - Dynamic Properties
- (int)numberOfOnLights {
    return ((NSNumber *)[LightsNSwitchesSubsystemCapability getOnDeviceCountsFromModel:self.subsystemModel][@"light"]).intValue;
}

- (int)numberOfOnSwitches {
    return ((NSNumber *)[LightsNSwitchesSubsystemCapability getOnDeviceCountsFromModel:self.subsystemModel][@"switch"]).intValue;
}

- (NSArray *)allDimmersAddresses {
    return [LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel];
}

- (NSArray *)allLightsAddresses {
    return [LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel];
}

- (NSArray *)allSwitchesAddresses {
    return [LightsNSwitchesSubsystemCapability getSwitchDevicesFromModel:self.subsystemModel];
}
@end
