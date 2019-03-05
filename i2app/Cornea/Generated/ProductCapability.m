

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "ProductCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrProductId=@"product:id";

NSString *const kAttrProductName=@"product:name";

NSString *const kAttrProductShortName=@"product:shortName";

NSString *const kAttrProductDescription=@"product:description";

NSString *const kAttrProductManufacturer=@"product:manufacturer";

NSString *const kAttrProductVendor=@"product:vendor";

NSString *const kAttrProductAddDevImg=@"product:addDevImg";

NSString *const kAttrProductCert=@"product:cert";

NSString *const kAttrProductCanBrowse=@"product:canBrowse";

NSString *const kAttrProductCanSearch=@"product:canSearch";

NSString *const kAttrProductArcusProductId=@"product:arcusProductId";

NSString *const kAttrProductArcusVendorId=@"product:arcusVendorId";

NSString *const kAttrProductArcusModelId=@"product:arcusModelId";

NSString *const kAttrProductArcusComUrl=@"product:arcusComUrl";

NSString *const kAttrProductHelpUrl=@"product:helpUrl";

NSString *const kAttrProductPairVideoUrl=@"product:pairVideoUrl";

NSString *const kAttrProductBatteryPrimSize=@"product:batteryPrimSize";

NSString *const kAttrProductBatteryPrimNum=@"product:batteryPrimNum";

NSString *const kAttrProductBatteryBackSize=@"product:batteryBackSize";

NSString *const kAttrProductBatteryBackNum=@"product:batteryBackNum";

NSString *const kAttrProductKeywords=@"product:keywords";

NSString *const kAttrProductOTA=@"product:OTA";

NSString *const kAttrProductProtoFamily=@"product:protoFamily";

NSString *const kAttrProductProtoSpec=@"product:protoSpec";

NSString *const kAttrProductDriver=@"product:driver";

NSString *const kAttrProductAdded=@"product:added";

NSString *const kAttrProductLastChanged=@"product:lastChanged";

NSString *const kAttrProductCategories=@"product:categories";

NSString *const kAttrProductPair=@"product:pair";

NSString *const kAttrProductRemoval=@"product:removal";

NSString *const kAttrProductReset=@"product:reset";

NSString *const kAttrProductPopulations=@"product:populations";

NSString *const kAttrProductScreen=@"product:screen";

NSString *const kAttrProductBlacklisted=@"product:blacklisted";

NSString *const kAttrProductHubRequired=@"product:hubRequired";

NSString *const kAttrProductMinAppVersion=@"product:minAppVersion";

NSString *const kAttrProductMinHubFirmware=@"product:minHubFirmware";

NSString *const kAttrProductDevRequired=@"product:devRequired";

NSString *const kAttrProductCanDiscover=@"product:canDiscover";

NSString *const kAttrProductAppRequired=@"product:appRequired";

NSString *const kAttrProductInstallManualUrl=@"product:installManualUrl";

NSString *const kAttrProductPairingMode=@"product:pairingMode";

NSString *const kAttrProductPairingIdleTimeoutMs=@"product:pairingIdleTimeoutMs";



NSString *const kEnumProductCertCOMPATIBLE = @"COMPATIBLE";
NSString *const kEnumProductCertNONE = @"NONE";
NSString *const kEnumProductCertWORKS = @"WORKS";
NSString *const kEnumProductBatteryPrimSize_9V = @"_9V";
NSString *const kEnumProductBatteryPrimSizeAAAA = @"AAAA";
NSString *const kEnumProductBatteryPrimSizeAAA = @"AAA";
NSString *const kEnumProductBatteryPrimSizeAA = @"AA";
NSString *const kEnumProductBatteryPrimSizeC = @"C";
NSString *const kEnumProductBatteryPrimSizeD = @"D";
NSString *const kEnumProductBatteryPrimSizeCR123 = @"CR123";
NSString *const kEnumProductBatteryPrimSizeCR2 = @"CR2";
NSString *const kEnumProductBatteryPrimSizeCR2032 = @"CR2032";
NSString *const kEnumProductBatteryPrimSizeCR2430 = @"CR2430";
NSString *const kEnumProductBatteryPrimSizeCR2450 = @"CR2450";
NSString *const kEnumProductBatteryPrimSizeCR14250 = @"CR14250";
NSString *const kEnumProductBatteryBackSize_9V = @"_9V";
NSString *const kEnumProductBatteryBackSizeAAAA = @"AAAA";
NSString *const kEnumProductBatteryBackSizeAAA = @"AAA";
NSString *const kEnumProductBatteryBackSizeAA = @"AA";
NSString *const kEnumProductBatteryBackSizeC = @"C";
NSString *const kEnumProductBatteryBackSizeD = @"D";
NSString *const kEnumProductBatteryBackSizeCR123 = @"CR123";
NSString *const kEnumProductBatteryBackSizeCR2 = @"CR2";
NSString *const kEnumProductBatteryBackSizeCR2032 = @"CR2032";
NSString *const kEnumProductBatteryBackSizeCR2430 = @"CR2430";
NSString *const kEnumProductBatteryBackSizeCR2450 = @"CR2450";
NSString *const kEnumProductBatteryBackSizeCR14250 = @"CR14250";
NSString *const kEnumProductPairingModeEXTERNAL_APP = @"EXTERNAL_APP";
NSString *const kEnumProductPairingModeWIFI = @"WIFI";
NSString *const kEnumProductPairingModeHUB = @"HUB";
NSString *const kEnumProductPairingModeIPCD = @"IPCD";
NSString *const kEnumProductPairingModeOAUTH = @"OAUTH";
NSString *const kEnumProductPairingModeBRIDGED_DEVICE = @"BRIDGED_DEVICE";


@implementation ProductCapability
+ (NSString *)namespace { return @"product"; }
+ (NSString *)name { return @"Product"; }

+ (NSString *)getIdFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getId:modelObj];
  
}


+ (NSString *)getNameFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getShortNameFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getShortName:modelObj];
  
}


+ (NSString *)getDescriptionFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getDescription:modelObj];
  
}


+ (NSString *)getManufacturerFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getManufacturer:modelObj];
  
}


+ (NSString *)getVendorFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getVendor:modelObj];
  
}


+ (NSString *)getAddDevImgFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getAddDevImg:modelObj];
  
}


+ (NSString *)getCertFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getCert:modelObj];
  
}


+ (BOOL)getCanBrowseFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getCanBrowse:modelObj] boolValue];
  
}


+ (BOOL)getCanSearchFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getCanSearch:modelObj] boolValue];
  
}


+ (NSString *)getArcusProductIdFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getArcusProductId:modelObj];
  
}


+ (NSString *)getArcusVendorIdFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getArcusVendorId:modelObj];
  
}


+ (NSString *)getArcusModelIdFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getArcusModelId:modelObj];
  
}


+ (NSString *)getArcusComUrlFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getArcusComUrl:modelObj];
  
}


+ (NSString *)getHelpUrlFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getHelpUrl:modelObj];
  
}


+ (NSString *)getPairVideoUrlFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getPairVideoUrl:modelObj];
  
}


+ (NSString *)getBatteryPrimSizeFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getBatteryPrimSize:modelObj];
  
}


+ (int)getBatteryPrimNumFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getBatteryPrimNum:modelObj] intValue];
  
}


+ (NSString *)getBatteryBackSizeFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getBatteryBackSize:modelObj];
  
}


+ (int)getBatteryBackNumFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getBatteryBackNum:modelObj] intValue];
  
}


+ (NSString *)getKeywordsFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getKeywords:modelObj];
  
}


+ (BOOL)getOTAFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getOTA:modelObj] boolValue];
  
}


+ (NSString *)getProtoFamilyFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getProtoFamily:modelObj];
  
}


+ (NSString *)getProtoSpecFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getProtoSpec:modelObj];
  
}


+ (NSString *)getDriverFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getDriver:modelObj];
  
}


+ (NSDate *)getAddedFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getAdded:modelObj];
  
}


+ (NSDate *)getLastChangedFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getLastChanged:modelObj];
  
}


+ (NSArray *)getCategoriesFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getCategories:modelObj];
  
}


+ (NSArray *)getPairFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getPair:modelObj];
  
}


+ (NSArray *)getRemovalFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getRemoval:modelObj];
  
}


+ (NSArray *)getResetFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getReset:modelObj];
  
}


+ (NSArray *)getPopulationsFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getPopulations:modelObj];
  
}


+ (NSString *)getScreenFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getScreen:modelObj];
  
}


+ (BOOL)getBlacklistedFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getBlacklisted:modelObj] boolValue];
  
}


+ (BOOL)getHubRequiredFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getHubRequired:modelObj] boolValue];
  
}


+ (NSString *)getMinAppVersionFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getMinAppVersion:modelObj];
  
}


+ (NSString *)getMinHubFirmwareFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getMinHubFirmware:modelObj];
  
}


+ (NSString *)getDevRequiredFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getDevRequired:modelObj];
  
}


+ (BOOL)getCanDiscoverFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getCanDiscover:modelObj] boolValue];
  
}


+ (BOOL)getAppRequiredFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getAppRequired:modelObj] boolValue];
  
}


+ (NSString *)getInstallManualUrlFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getInstallManualUrl:modelObj];
  
}


+ (NSString *)getPairingModeFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [ProductCapabilityLegacy getPairingMode:modelObj];
  
}


+ (int)getPairingIdleTimeoutMsFromModel:(ProductModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[ProductCapabilityLegacy getPairingIdleTimeoutMs:modelObj] intValue];
  
}



@end
