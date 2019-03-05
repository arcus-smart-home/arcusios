

#import <Foundation/Foundation.h>

@class PMKPromise;
@class Model;
@class HubModel;













































































































/** Number of cameras available for pairing */
extern NSString *const kAttrHubSercommNumAvailable;

/** Number of cameras paired to the hub */
extern NSString *const kAttrHubSercommNumPaired;

/** Number of cameras paired to other hubs */
extern NSString *const kAttrHubSercommNumNotOwned;

/** Number of cameras that are no longer connected */
extern NSString *const kAttrHubSercommNumDisconnected;

/** List of cameras (by MAC address) with current mode */
extern NSString *const kAttrHubSercommCameras;

/** Per-hub camera username */
extern NSString *const kAttrHubSercommUsername;

/** Per-hub camera certificate hash value */
extern NSString *const kAttrHubSercommCertHash;


extern NSString *const kCmdHubSercommGetCameraPassword;

extern NSString *const kCmdHubSercommPair;

extern NSString *const kCmdHubSercommReset;

extern NSString *const kCmdHubSercommReboot;

extern NSString *const kCmdHubSercommConfig;

extern NSString *const kCmdHubSercommUpgrade;

extern NSString *const kCmdHubSercommGetState;

extern NSString *const kCmdHubSercommGetVersion;

extern NSString *const kCmdHubSercommGetDayNight;

extern NSString *const kCmdHubSercommGetIPAddress;

extern NSString *const kCmdHubSercommGetModel;

extern NSString *const kCmdHubSercommGetInfo;

extern NSString *const kCmdHubSercommGetAttrs;

extern NSString *const kCmdHubSercommMotionDetectStart;

extern NSString *const kCmdHubSercommMotionDetectStop;

extern NSString *const kCmdHubSercommVideoStreamStart;

extern NSString *const kCmdHubSercommVideoStreamStop;

extern NSString *const kCmdHubSercommWifiScanStart;

extern NSString *const kCmdHubSercommWifiScanEnd;

extern NSString *const kCmdHubSercommWifiConnect;

extern NSString *const kCmdHubSercommWifiDisconnect;

extern NSString *const kCmdHubSercommWifiGetAttrs;

extern NSString *const kCmdHubSercommGetCustomAttrs;

extern NSString *const kCmdHubSercommSetCustomAttrs;

extern NSString *const kCmdHubSercommPurgeCamera;

extern NSString *const kCmdHubSercommPtzGetAttrs;

extern NSString *const kCmdHubSercommPtzGotoHome;

extern NSString *const kCmdHubSercommPtzGotoAbsolute;

extern NSString *const kCmdHubSercommPtzGotoRelative;


extern NSString *const kEvtHubSercommCameraUpgradeStatus;

extern NSString *const kEvtHubSercommCameraPairingStatus;

extern NSString *const kEvtHubSercommWifiScanResults;



@interface HubSercommCapability : NSObject
+ (NSString *)namespace;
+ (NSString *)name;

+ (int)getNumAvailableFromModel:(HubModel *)modelObj;


+ (int)getNumPairedFromModel:(HubModel *)modelObj;


+ (int)getNumNotOwnedFromModel:(HubModel *)modelObj;


+ (int)getNumDisconnectedFromModel:(HubModel *)modelObj;


+ (NSDictionary *)getCamerasFromModel:(HubModel *)modelObj;


+ (NSString *)getUsernameFromModel:(HubModel *)modelObj;


+ (NSString *)getCertHashFromModel:(HubModel *)modelObj;





/** Get camera password for hub */
+ (PMKPromise *) getCameraPasswordOnModel:(Model *)modelObj;



/** Pair a camera to the hub */
+ (PMKPromise *) pairWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Reset a camera back to factory defaults */
+ (PMKPromise *) resetWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Reboot a camera */
+ (PMKPromise *) rebootWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Configure a camera */
+ (PMKPromise *) configWithMac:(NSString *)mac withParams:(NSString *)params onModel:(Model *)modelObj;



/** Upgrade firmware on camera */
+ (PMKPromise *) upgradeWithMac:(NSString *)mac withUrl:(NSString *)url onModel:(Model *)modelObj;



/** Get current state of camera */
+ (PMKPromise *) getStateWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get current firmware version on camera */
+ (PMKPromise *) getVersionWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get current day/night setting of camera */
+ (PMKPromise *) getDayNightWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get IPv4 address of camera */
+ (PMKPromise *) getIPAddressWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get model of camera */
+ (PMKPromise *) getModelWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get camera information and configuration */
+ (PMKPromise *) getInfoWithMac:(NSString *)mac withGroup:(NSString *)group onModel:(Model *)modelObj;



/** Get camera attributes */
+ (PMKPromise *) getAttrsWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Start motion detection on camera. */
+ (PMKPromise *) motionDetectStartWithMac:(NSString *)mac withUrl:(NSString *)url withUsername:(NSString *)username withPassword:(NSString *)password onModel:(Model *)modelObj;



/** Stop motion detection on a camera. */
+ (PMKPromise *) motionDetectStopWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Start video streaming on camera. */
+ (PMKPromise *) videoStreamStartWithMac:(NSString *)mac withAddress:(NSString *)address withUsername:(NSString *)username withPassword:(NSString *)password withDuration:(int)duration withPrecapture:(int)precapture withFormat:(int)format withResolution:(int)resolution withQuality_type:(int)quality_type withBitrate:(int)bitrate withQuality:(int)quality withFramerate:(int)framerate onModel:(Model *)modelObj;



/** Stop video streaming on a camera. */
+ (PMKPromise *) videoStreamStopWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Start scan for wireless access points */
+ (PMKPromise *) wifiScanStartWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** End scan for wireless access points */
+ (PMKPromise *) wifiScanEndWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Connect to a wireless network */
+ (PMKPromise *) wifiConnectWithMac:(NSString *)mac withSsid:(NSString *)ssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(Model *)modelObj;



/** Disconnect from a wireless network. */
+ (PMKPromise *) wifiDisconnectWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get current wireless attributes */
+ (PMKPromise *) wifiGetAttrsWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get camera custom attributes */
+ (PMKPromise *) getCustomAttrsWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Set camera custom attributes */
+ (PMKPromise *) setCustomAttrsWithMac:(NSString *)mac withIrLedMode:(NSString *)irLedMode withIrLedLuminance:(int)irLedLuminance withMdMode:(NSString *)mdMode withMdThreshold:(int)mdThreshold withMdSensitivity:(int)mdSensitivity withMdWindowCoordinates:(NSString *)mdWindowCoordinates onModel:(Model *)modelObj;



/** Remove camera from database, remove if necessary */
+ (PMKPromise *) purgeCameraWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Get camera Pan/Tilt/Zoom attributes */
+ (PMKPromise *) ptzGetAttrsWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Move camera to home position */
+ (PMKPromise *) ptzGotoHomeWithMac:(NSString *)mac onModel:(Model *)modelObj;



/** Move camera to absolute position */
+ (PMKPromise *) ptzGotoAbsoluteWithMac:(NSString *)mac withPan:(int)pan withTilt:(int)tilt withZoom:(int)zoom onModel:(Model *)modelObj;



/** Move camera to relative position */
+ (PMKPromise *) ptzGotoRelativeWithMac:(NSString *)mac withDeltaPan:(int)deltaPan withDeltaTilt:(int)deltaTilt withDeltaZoom:(int)deltaZoom onModel:(Model *)modelObj;



@end
