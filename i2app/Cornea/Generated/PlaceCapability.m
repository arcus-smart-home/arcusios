

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "PlaceCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrPlaceAccount=@"place:account";

NSString *const kAttrPlacePopulation=@"place:population";

NSString *const kAttrPlaceName=@"place:name";

NSString *const kAttrPlaceState=@"place:state";

NSString *const kAttrPlaceStreetAddress1=@"place:streetAddress1";

NSString *const kAttrPlaceStreetAddress2=@"place:streetAddress2";

NSString *const kAttrPlaceCity=@"place:city";

NSString *const kAttrPlaceStateProv=@"place:stateProv";

NSString *const kAttrPlaceZipCode=@"place:zipCode";

NSString *const kAttrPlaceZipPlus4=@"place:zipPlus4";

NSString *const kAttrPlaceTzId=@"place:tzId";

NSString *const kAttrPlaceTzName=@"place:tzName";

NSString *const kAttrPlaceTzOffset=@"place:tzOffset";

NSString *const kAttrPlaceTzUsesDST=@"place:tzUsesDST";

NSString *const kAttrPlaceCountry=@"place:country";

NSString *const kAttrPlaceAddrValidated=@"place:addrValidated";

NSString *const kAttrPlaceAddrType=@"place:addrType";

NSString *const kAttrPlaceAddrZipType=@"place:addrZipType";

NSString *const kAttrPlaceAddrLatitude=@"place:addrLatitude";

NSString *const kAttrPlaceAddrLongitude=@"place:addrLongitude";

NSString *const kAttrPlaceAddrGeoPrecision=@"place:addrGeoPrecision";

NSString *const kAttrPlaceAddrRDI=@"place:addrRDI";

NSString *const kAttrPlaceAddrCounty=@"place:addrCounty";

NSString *const kAttrPlaceAddrCountyFIPS=@"place:addrCountyFIPS";

NSString *const kAttrPlaceLastServiceLevelChange=@"place:lastServiceLevelChange";

NSString *const kAttrPlaceServiceLevel=@"place:serviceLevel";

NSString *const kAttrPlaceServiceAddons=@"place:serviceAddons";

NSString *const kAttrPlaceCreated=@"place:created";

NSString *const kAttrPlaceModified=@"place:modified";


NSString *const kCmdPlaceListDevices=@"place:ListDevices";

NSString *const kCmdPlaceGetHub=@"place:GetHub";

NSString *const kCmdPlaceStartAddingDevices=@"place:StartAddingDevices";

NSString *const kCmdPlaceStopAddingDevices=@"place:StopAddingDevices";

NSString *const kCmdPlaceRegisterHub=@"place:RegisterHub";

NSString *const kCmdPlaceAddPerson=@"place:AddPerson";

NSString *const kCmdPlaceListPersons=@"place:ListPersons";

NSString *const kCmdPlaceListPersonsWithAccess=@"place:ListPersonsWithAccess";

NSString *const kCmdPlaceListDashboardEntries=@"place:ListDashboardEntries";

NSString *const kCmdPlaceListHistoryEntries=@"place:ListHistoryEntries";

NSString *const kCmdPlaceDelete=@"place:Delete";

NSString *const kCmdPlaceCreateInvitation=@"place:CreateInvitation";

NSString *const kCmdPlaceSendInvitation=@"place:SendInvitation";

NSString *const kCmdPlacePendingInvitations=@"place:PendingInvitations";

NSString *const kCmdPlaceCancelInvitation=@"place:CancelInvitation";

NSString *const kCmdPlaceUpdateAddress=@"place:UpdateAddress";

NSString *const kCmdPlaceRegisterHubV2=@"place:RegisterHubV2";


NSString *const kEnumPlaceServiceLevelBASIC = @"BASIC";
NSString *const kEnumPlaceServiceLevelPREMIUM = @"PREMIUM";
NSString *const kEnumPlaceServiceLevelPREMIUM_FREE = @"PREMIUM_FREE";
NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON = @"PREMIUM_PROMON";
NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON_FREE = @"PREMIUM_PROMON_FREE";
NSString *const kEnumPlaceServiceLevelPREMIUM_PROMON_MYARCUS_DISCOUNT = @"PREMIUM_PROMON_MYARCUS_DISCOUNT";


@implementation PlaceCapability
+ (NSString *)namespace { return @"place"; }
+ (NSString *)name { return @"Place"; }

+ (NSString *)getAccountFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAccount:modelObj];
  
}


+ (NSString *)getPopulationFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getPopulation:modelObj];
  
}


+ (NSString *)getNameFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setName:name model:modelObj];
  
  return [PlaceCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getStateFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getState:modelObj];
  
}

+ (NSString *)setState:(NSString *)state onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setState:state model:modelObj];
  
  return [PlaceCapabilityLegacy getState:modelObj];
  
}


+ (NSString *)getStreetAddress1FromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getStreetAddress1:modelObj];
  
}

+ (NSString *)setStreetAddress1:(NSString *)streetAddress1 onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setStreetAddress1:streetAddress1 model:modelObj];
  
  return [PlaceCapabilityLegacy getStreetAddress1:modelObj];
  
}


+ (NSString *)getStreetAddress2FromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getStreetAddress2:modelObj];
  
}

+ (NSString *)setStreetAddress2:(NSString *)streetAddress2 onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setStreetAddress2:streetAddress2 model:modelObj];
  
  return [PlaceCapabilityLegacy getStreetAddress2:modelObj];
  
}


+ (NSString *)getCityFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getCity:modelObj];
  
}

+ (NSString *)setCity:(NSString *)city onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setCity:city model:modelObj];
  
  return [PlaceCapabilityLegacy getCity:modelObj];
  
}


+ (NSString *)getStateProvFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getStateProv:modelObj];
  
}

+ (NSString *)setStateProv:(NSString *)stateProv onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setStateProv:stateProv model:modelObj];
  
  return [PlaceCapabilityLegacy getStateProv:modelObj];
  
}


+ (NSString *)getZipCodeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getZipCode:modelObj];
  
}

+ (NSString *)setZipCode:(NSString *)zipCode onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setZipCode:zipCode model:modelObj];
  
  return [PlaceCapabilityLegacy getZipCode:modelObj];
  
}


+ (NSString *)getZipPlus4FromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getZipPlus4:modelObj];
  
}

+ (NSString *)setZipPlus4:(NSString *)zipPlus4 onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setZipPlus4:zipPlus4 model:modelObj];
  
  return [PlaceCapabilityLegacy getZipPlus4:modelObj];
  
}


+ (NSString *)getTzIdFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getTzId:modelObj];
  
}

+ (NSString *)setTzId:(NSString *)tzId onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setTzId:tzId model:modelObj];
  
  return [PlaceCapabilityLegacy getTzId:modelObj];
  
}


+ (NSString *)getTzNameFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getTzName:modelObj];
  
}

+ (NSString *)setTzName:(NSString *)tzName onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setTzName:tzName model:modelObj];
  
  return [PlaceCapabilityLegacy getTzName:modelObj];
  
}


+ (double)getTzOffsetFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PlaceCapabilityLegacy getTzOffset:modelObj] doubleValue];
  
}

+ (double)setTzOffset:(double)tzOffset onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setTzOffset:tzOffset model:modelObj];
  
  return [[PlaceCapabilityLegacy getTzOffset:modelObj] doubleValue];
  
}


+ (BOOL)getTzUsesDSTFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PlaceCapabilityLegacy getTzUsesDST:modelObj] boolValue];
  
}

+ (BOOL)setTzUsesDST:(BOOL)tzUsesDST onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setTzUsesDST:tzUsesDST model:modelObj];
  
  return [[PlaceCapabilityLegacy getTzUsesDST:modelObj] boolValue];
  
}


+ (NSString *)getCountryFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getCountry:modelObj];
  
}

+ (NSString *)setCountry:(NSString *)country onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setCountry:country model:modelObj];
  
  return [PlaceCapabilityLegacy getCountry:modelObj];
  
}


+ (BOOL)getAddrValidatedFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PlaceCapabilityLegacy getAddrValidated:modelObj] boolValue];
  
}

+ (BOOL)setAddrValidated:(BOOL)addrValidated onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrValidated:addrValidated model:modelObj];
  
  return [[PlaceCapabilityLegacy getAddrValidated:modelObj] boolValue];
  
}


+ (NSString *)getAddrTypeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrType:modelObj];
  
}

+ (NSString *)setAddrType:(NSString *)addrType onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrType:addrType model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrType:modelObj];
  
}


+ (NSString *)getAddrZipTypeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrZipType:modelObj];
  
}

+ (NSString *)setAddrZipType:(NSString *)addrZipType onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrZipType:addrZipType model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrZipType:modelObj];
  
}


+ (double)getAddrLatitudeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PlaceCapabilityLegacy getAddrLatitude:modelObj] doubleValue];
  
}

+ (double)setAddrLatitude:(double)addrLatitude onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrLatitude:addrLatitude model:modelObj];
  
  return [[PlaceCapabilityLegacy getAddrLatitude:modelObj] doubleValue];
  
}


+ (double)getAddrLongitudeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[PlaceCapabilityLegacy getAddrLongitude:modelObj] doubleValue];
  
}

+ (double)setAddrLongitude:(double)addrLongitude onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrLongitude:addrLongitude model:modelObj];
  
  return [[PlaceCapabilityLegacy getAddrLongitude:modelObj] doubleValue];
  
}


+ (NSString *)getAddrGeoPrecisionFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrGeoPrecision:modelObj];
  
}

+ (NSString *)setAddrGeoPrecision:(NSString *)addrGeoPrecision onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrGeoPrecision:addrGeoPrecision model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrGeoPrecision:modelObj];
  
}


+ (NSString *)getAddrRDIFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrRDI:modelObj];
  
}

+ (NSString *)setAddrRDI:(NSString *)addrRDI onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrRDI:addrRDI model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrRDI:modelObj];
  
}


+ (NSString *)getAddrCountyFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrCounty:modelObj];
  
}

+ (NSString *)setAddrCounty:(NSString *)addrCounty onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrCounty:addrCounty model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrCounty:modelObj];
  
}


+ (NSString *)getAddrCountyFIPSFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getAddrCountyFIPS:modelObj];
  
}

+ (NSString *)setAddrCountyFIPS:(NSString *)addrCountyFIPS onModel:(PlaceModel *)modelObj {
  [PlaceCapabilityLegacy setAddrCountyFIPS:addrCountyFIPS model:modelObj];
  
  return [PlaceCapabilityLegacy getAddrCountyFIPS:modelObj];
  
}


+ (NSDate *)getLastServiceLevelChangeFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getLastServiceLevelChange:modelObj];
  
}


+ (NSString *)getServiceLevelFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getServiceLevel:modelObj];
  
}


+ (NSArray *)getServiceAddonsFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getServiceAddons:modelObj];
  
}


+ (NSDate *)getCreatedFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getCreated:modelObj];
  
}


+ (NSDate *)getModifiedFromModel:(PlaceModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [PlaceCapabilityLegacy getModified:modelObj];
  
}




+ (PMKPromise *) listDevicesOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy listDevices:modelObj ];
}


+ (PMKPromise *) getHubOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy getHub:modelObj ];
}


+ (PMKPromise *) startAddingDevicesWithTime:(long)time onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy startAddingDevices:modelObj time:time];

}


+ (PMKPromise *) stopAddingDevicesOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy stopAddingDevices:modelObj ];
}


+ (PMKPromise *) registerHubWithHubId:(NSString *)hubId onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy registerHub:modelObj hubId:hubId];

}


+ (PMKPromise *) addPersonWithPerson:(id)person withPassword:(NSString *)password onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy addPerson:modelObj person:person password:password];

}


+ (PMKPromise *) listPersonsOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy listPersons:modelObj ];
}


+ (PMKPromise *) listPersonsWithAccessOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy listPersonsWithAccess:modelObj ];
}


+ (PMKPromise *) listDashboardEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy listDashboardEntries:modelObj limit:limit token:token];

}


+ (PMKPromise *) listHistoryEntriesWithLimit:(int)limit withToken:(NSString *)token onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy listHistoryEntries:modelObj limit:limit token:token];

}


+ (PMKPromise *) deleteOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) createInvitationWithFirstName:(NSString *)firstName withLastName:(NSString *)lastName withEmail:(NSString *)email withRelationship:(NSString *)relationship onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy createInvitation:modelObj firstName:firstName lastName:lastName email:email relationship:relationship];

}


+ (PMKPromise *) sendInvitationWithInvitation:(id)invitation onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy sendInvitation:modelObj invitation:invitation];

}


+ (PMKPromise *) pendingInvitationsOnModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy pendingInvitations:modelObj ];
}


+ (PMKPromise *) cancelInvitationWithCode:(NSString *)code onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy cancelInvitation:modelObj code:code];

}


+ (PMKPromise *) updateAddressWithStreetAddress:(id)streetAddress onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy updateAddress:modelObj streetAddress:streetAddress];

}


+ (PMKPromise *) registerHubV2WithHubId:(NSString *)hubId onModel:(PlaceModel *)modelObj {
  return [PlaceCapabilityLegacy registerHubV2:modelObj hubId:hubId];

}

@end
