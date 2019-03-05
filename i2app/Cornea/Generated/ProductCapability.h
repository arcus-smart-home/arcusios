

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class ProductModel;



/** Product Id */
extern NSString *const kAttrProductId;

/** Product Name */
extern NSString *const kAttrProductName;

/** Product short name */
extern NSString *const kAttrProductShortName;

/** Product Description */
extern NSString *const kAttrProductDescription;

/** Product Manufacturer */
extern NSString *const kAttrProductManufacturer;

/** Product Vendor */
extern NSString *const kAttrProductVendor;

/** Product Device Image */
extern NSString *const kAttrProductAddDevImg;

/** Product Arcus Certification */
extern NSString *const kAttrProductCert;

/** Product appears in browse */
extern NSString *const kAttrProductCanBrowse;

/** Product appears in search */
extern NSString *const kAttrProductCanSearch;

/** Lowe&#x27;s Product Id */
extern NSString *const kAttrProductArcusProductId;

/**  */
extern NSString *const kAttrProductArcusVendorId;

/** Lowe&#x27;s Model Id */
extern NSString *const kAttrProductArcusModelId;

/** Arcus.com url */
extern NSString *const kAttrProductArcusComUrl;

/** Help url */
extern NSString *const kAttrProductHelpUrl;

/** Video url */
extern NSString *const kAttrProductPairVideoUrl;

/** Primary battery size */
extern NSString *const kAttrProductBatteryPrimSize;

/** Primary battery number */
extern NSString *const kAttrProductBatteryPrimNum;

/** Backup battery size */
extern NSString *const kAttrProductBatteryBackSize;

/** Backup battery number */
extern NSString *const kAttrProductBatteryBackNum;

/** Product Keywords */
extern NSString *const kAttrProductKeywords;

/**  */
extern NSString *const kAttrProductOTA;

/** Protocol Family */
extern NSString *const kAttrProductProtoFamily;

/** Protocol Specification */
extern NSString *const kAttrProductProtoSpec;

/** Driver Name */
extern NSString *const kAttrProductDriver;

/** Product added timestamp */
extern NSString *const kAttrProductAdded;

/** Product last changed timestamp */
extern NSString *const kAttrProductLastChanged;

/** Product categories */
extern NSString *const kAttrProductCategories;

/** Pairing Steps */
extern NSString *const kAttrProductPair;

/** Remove Steps */
extern NSString *const kAttrProductRemoval;

/** Reset Steps */
extern NSString *const kAttrProductReset;

/** Populations specified for this product */
extern NSString *const kAttrProductPopulations;

/** Detailed screen name for this product */
extern NSString *const kAttrProductScreen;

/** Product is blacklisted */
extern NSString *const kAttrProductBlacklisted;

/** Product requires a hub.  If not specified, defaults to true */
extern NSString *const kAttrProductHubRequired;

/** Tag to indicate minimum app version supported by a given product */
extern NSString *const kAttrProductMinAppVersion;

/** The minimum hub firmware version required to use this product */
extern NSString *const kAttrProductMinHubFirmware;

/** Product catalog id of a parent device that must be paired before this can be paired */
extern NSString *const kAttrProductDevRequired;

/** If product can be discovered in non-Arcus user experiences that are fed by the Arcus API, such as Alexa or Google Home.  Default is true. */
extern NSString *const kAttrProductCanDiscover;

/** If product can only be pairable via the mobile application.  Default is false. */
extern NSString *const kAttrProductAppRequired;

/** URL to manufacturer installation instructions. */
extern NSString *const kAttrProductInstallManualUrl;

/** The pairing mode for the device.  If not specified it will be defaulted to HUB. EXTERNAL_APP:  Requires a different mobile application, for example for voice assistants. WIFI:  Requires the mobile app and typically custom soft AP pairing logic. HUB:  Requires the hub to be present for pairing. IPCD:  Requires manual entry of information to align an IP connected device with a place, typically the serial number. OAUTH:  Requires interaction with a third-party for cloud to cloud integration. BRIDGED_DEVICE:  Requires some bridge device to be paired first where the bridge device is specified in the devRequired attribute.  */
extern NSString *const kAttrProductPairingMode;

/** The custom value of pairing idle timeout in milliseconds. */
extern NSString *const kAttrProductPairingIdleTimeoutMs;



extern NSString *const kEnumProductCertCOMPATIBLE;
extern NSString *const kEnumProductCertNONE;
extern NSString *const kEnumProductCertWORKS;
extern NSString *const kEnumProductBatteryPrimSize_9V;
extern NSString *const kEnumProductBatteryPrimSizeAAAA;
extern NSString *const kEnumProductBatteryPrimSizeAAA;
extern NSString *const kEnumProductBatteryPrimSizeAA;
extern NSString *const kEnumProductBatteryPrimSizeC;
extern NSString *const kEnumProductBatteryPrimSizeD;
extern NSString *const kEnumProductBatteryPrimSizeCR123;
extern NSString *const kEnumProductBatteryPrimSizeCR2;
extern NSString *const kEnumProductBatteryPrimSizeCR2032;
extern NSString *const kEnumProductBatteryPrimSizeCR2430;
extern NSString *const kEnumProductBatteryPrimSizeCR2450;
extern NSString *const kEnumProductBatteryPrimSizeCR14250;
extern NSString *const kEnumProductBatteryBackSize_9V;
extern NSString *const kEnumProductBatteryBackSizeAAAA;
extern NSString *const kEnumProductBatteryBackSizeAAA;
extern NSString *const kEnumProductBatteryBackSizeAA;
extern NSString *const kEnumProductBatteryBackSizeC;
extern NSString *const kEnumProductBatteryBackSizeD;
extern NSString *const kEnumProductBatteryBackSizeCR123;
extern NSString *const kEnumProductBatteryBackSizeCR2;
extern NSString *const kEnumProductBatteryBackSizeCR2032;
extern NSString *const kEnumProductBatteryBackSizeCR2430;
extern NSString *const kEnumProductBatteryBackSizeCR2450;
extern NSString *const kEnumProductBatteryBackSizeCR14250;
extern NSString *const kEnumProductPairingModeEXTERNAL_APP;
extern NSString *const kEnumProductPairingModeWIFI;
extern NSString *const kEnumProductPairingModeHUB;
extern NSString *const kEnumProductPairingModeIPCD;
extern NSString *const kEnumProductPairingModeOAUTH;
extern NSString *const kEnumProductPairingModeBRIDGED_DEVICE;


@interface ProductCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (NSString *)getIdFromModel:(ProductModel *)modelObj;


+ (NSString *)getNameFromModel:(ProductModel *)modelObj;


+ (NSString *)getShortNameFromModel:(ProductModel *)modelObj;


+ (NSString *)getDescriptionFromModel:(ProductModel *)modelObj;


+ (NSString *)getManufacturerFromModel:(ProductModel *)modelObj;


+ (NSString *)getVendorFromModel:(ProductModel *)modelObj;


+ (NSString *)getAddDevImgFromModel:(ProductModel *)modelObj;


+ (NSString *)getCertFromModel:(ProductModel *)modelObj;


+ (BOOL)getCanBrowseFromModel:(ProductModel *)modelObj;


+ (BOOL)getCanSearchFromModel:(ProductModel *)modelObj;


+ (NSString *)getArcusProductIdFromModel:(ProductModel *)modelObj;


+ (NSString *)getArcusVendorIdFromModel:(ProductModel *)modelObj;


+ (NSString *)getArcusModelIdFromModel:(ProductModel *)modelObj;


+ (NSString *)getArcusComUrlFromModel:(ProductModel *)modelObj;


+ (NSString *)getHelpUrlFromModel:(ProductModel *)modelObj;


+ (NSString *)getPairVideoUrlFromModel:(ProductModel *)modelObj;


+ (NSString *)getBatteryPrimSizeFromModel:(ProductModel *)modelObj;


+ (int)getBatteryPrimNumFromModel:(ProductModel *)modelObj;


+ (NSString *)getBatteryBackSizeFromModel:(ProductModel *)modelObj;


+ (int)getBatteryBackNumFromModel:(ProductModel *)modelObj;


+ (NSString *)getKeywordsFromModel:(ProductModel *)modelObj;


+ (BOOL)getOTAFromModel:(ProductModel *)modelObj;


+ (NSString *)getProtoFamilyFromModel:(ProductModel *)modelObj;


+ (NSString *)getProtoSpecFromModel:(ProductModel *)modelObj;


+ (NSString *)getDriverFromModel:(ProductModel *)modelObj;


+ (NSDate *)getAddedFromModel:(ProductModel *)modelObj;


+ (NSDate *)getLastChangedFromModel:(ProductModel *)modelObj;


+ (NSArray *)getCategoriesFromModel:(ProductModel *)modelObj;


+ (NSArray *)getPairFromModel:(ProductModel *)modelObj;


+ (NSArray *)getRemovalFromModel:(ProductModel *)modelObj;


+ (NSArray *)getResetFromModel:(ProductModel *)modelObj;


+ (NSArray *)getPopulationsFromModel:(ProductModel *)modelObj;


+ (NSString *)getScreenFromModel:(ProductModel *)modelObj;


+ (BOOL)getBlacklistedFromModel:(ProductModel *)modelObj;


+ (BOOL)getHubRequiredFromModel:(ProductModel *)modelObj;


+ (NSString *)getMinAppVersionFromModel:(ProductModel *)modelObj;


+ (NSString *)getMinHubFirmwareFromModel:(ProductModel *)modelObj;


+ (NSString *)getDevRequiredFromModel:(ProductModel *)modelObj;


+ (BOOL)getCanDiscoverFromModel:(ProductModel *)modelObj;


+ (BOOL)getAppRequiredFromModel:(ProductModel *)modelObj;


+ (NSString *)getInstallManualUrlFromModel:(ProductModel *)modelObj;


+ (NSString *)getPairingModeFromModel:(ProductModel *)modelObj;


+ (int)getPairingIdleTimeoutMsFromModel:(ProductModel *)modelObj;





@end
