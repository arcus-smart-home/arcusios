

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "HubSercommCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrHubSercommNumAvailable=@"hubsercomm:numAvailable";

NSString *const kAttrHubSercommNumPaired=@"hubsercomm:numPaired";

NSString *const kAttrHubSercommNumNotOwned=@"hubsercomm:numNotOwned";

NSString *const kAttrHubSercommNumDisconnected=@"hubsercomm:numDisconnected";

NSString *const kAttrHubSercommCameras=@"hubsercomm:cameras";

NSString *const kAttrHubSercommUsername=@"hubsercomm:username";

NSString *const kAttrHubSercommCertHash=@"hubsercomm:certHash";


NSString *const kCmdHubSercommGetCameraPassword=@"hubsercomm:getCameraPassword";

NSString *const kCmdHubSercommPair=@"hubsercomm:pair";

NSString *const kCmdHubSercommReset=@"hubsercomm:reset";

NSString *const kCmdHubSercommReboot=@"hubsercomm:reboot";

NSString *const kCmdHubSercommConfig=@"hubsercomm:config";

NSString *const kCmdHubSercommUpgrade=@"hubsercomm:upgrade";

NSString *const kCmdHubSercommGetState=@"hubsercomm:getState";

NSString *const kCmdHubSercommGetVersion=@"hubsercomm:getVersion";

NSString *const kCmdHubSercommGetDayNight=@"hubsercomm:getDayNight";

NSString *const kCmdHubSercommGetIPAddress=@"hubsercomm:getIPAddress";

NSString *const kCmdHubSercommGetModel=@"hubsercomm:getModel";

NSString *const kCmdHubSercommGetInfo=@"hubsercomm:getInfo";

NSString *const kCmdHubSercommGetAttrs=@"hubsercomm:getAttrs";

NSString *const kCmdHubSercommMotionDetectStart=@"hubsercomm:motionDetectStart";

NSString *const kCmdHubSercommMotionDetectStop=@"hubsercomm:motionDetectStop";

NSString *const kCmdHubSercommVideoStreamStart=@"hubsercomm:videoStreamStart";

NSString *const kCmdHubSercommVideoStreamStop=@"hubsercomm:videoStreamStop";

NSString *const kCmdHubSercommWifiScanStart=@"hubsercomm:wifiScanStart";

NSString *const kCmdHubSercommWifiScanEnd=@"hubsercomm:wifiScanEnd";

NSString *const kCmdHubSercommWifiConnect=@"hubsercomm:wifiConnect";

NSString *const kCmdHubSercommWifiDisconnect=@"hubsercomm:wifiDisconnect";

NSString *const kCmdHubSercommWifiGetAttrs=@"hubsercomm:wifiGetAttrs";

NSString *const kCmdHubSercommGetCustomAttrs=@"hubsercomm:getCustomAttrs";

NSString *const kCmdHubSercommSetCustomAttrs=@"hubsercomm:setCustomAttrs";

NSString *const kCmdHubSercommPurgeCamera=@"hubsercomm:purgeCamera";

NSString *const kCmdHubSercommPtzGetAttrs=@"hubsercomm:ptzGetAttrs";

NSString *const kCmdHubSercommPtzGotoHome=@"hubsercomm:ptzGotoHome";

NSString *const kCmdHubSercommPtzGotoAbsolute=@"hubsercomm:ptzGotoAbsolute";

NSString *const kCmdHubSercommPtzGotoRelative=@"hubsercomm:ptzGotoRelative";


NSString *const kEvtHubSercommCameraUpgradeStatus=@"hubsercomm:CameraUpgradeStatus";

NSString *const kEvtHubSercommCameraPairingStatus=@"hubsercomm:CameraPairingStatus";

NSString *const kEvtHubSercommWifiScanResults=@"hubsercomm:WifiScanResults";



@implementation HubSercommCapability
+ (NSString *)namespace { return @"hubsercomm"; }
+ (NSString *)name { return @"HubSercomm"; }

+ (int)getNumAvailableFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubSercommCapabilityLegacy getNumAvailable:modelObj] intValue];
  
}


+ (int)getNumPairedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubSercommCapabilityLegacy getNumPaired:modelObj] intValue];
  
}


+ (int)getNumNotOwnedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubSercommCapabilityLegacy getNumNotOwned:modelObj] intValue];
  
}


+ (int)getNumDisconnectedFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[HubSercommCapabilityLegacy getNumDisconnected:modelObj] intValue];
  
}


+ (NSDictionary *)getCamerasFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubSercommCapabilityLegacy getCameras:modelObj];
  
}


+ (NSString *)getUsernameFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubSercommCapabilityLegacy getUsername:modelObj];
  
}


+ (NSString *)getCertHashFromModel:(HubModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [HubSercommCapabilityLegacy getCertHash:modelObj];
  
}




+ (PMKPromise *) getCameraPasswordOnModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getCameraPassword:modelObj ];
}


+ (PMKPromise *) pairWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy pair:modelObj mac:mac];

}


+ (PMKPromise *) resetWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy reset:modelObj mac:mac];

}


+ (PMKPromise *) rebootWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy reboot:modelObj mac:mac];

}


+ (PMKPromise *) configWithMac:(NSString *)mac withParams:(NSString *)params onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy config:modelObj mac:mac params:params];

}


+ (PMKPromise *) upgradeWithMac:(NSString *)mac withUrl:(NSString *)url onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy upgrade:modelObj mac:mac url:url];

}


+ (PMKPromise *) getStateWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getState:modelObj mac:mac];

}


+ (PMKPromise *) getVersionWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getVersion:modelObj mac:mac];

}


+ (PMKPromise *) getDayNightWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getDayNight:modelObj mac:mac];

}


+ (PMKPromise *) getIPAddressWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getIPAddress:modelObj mac:mac];

}


+ (PMKPromise *) getModelWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getModel:modelObj mac:mac];

}


+ (PMKPromise *) getInfoWithMac:(NSString *)mac withGroup:(NSString *)group onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getInfo:modelObj mac:mac group:group];

}


+ (PMKPromise *) getAttrsWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getAttrs:modelObj mac:mac];

}


+ (PMKPromise *) motionDetectStartWithMac:(NSString *)mac withUrl:(NSString *)url withUsername:(NSString *)username withPassword:(NSString *)password onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy motionDetectStart:modelObj mac:mac url:url username:username password:password];

}


+ (PMKPromise *) motionDetectStopWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy motionDetectStop:modelObj mac:mac];

}


+ (PMKPromise *) videoStreamStartWithMac:(NSString *)mac withAddress:(NSString *)address withUsername:(NSString *)username withPassword:(NSString *)password withDuration:(int)duration withPrecapture:(int)precapture withFormat:(int)format withResolution:(int)resolution withQuality_type:(int)quality_type withBitrate:(int)bitrate withQuality:(int)quality withFramerate:(int)framerate onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy videoStreamStart:modelObj mac:mac hubSercommAddress:address username:username password:password duration:duration precapture:precapture format:format resolution:resolution quality_type:quality_type bitrate:bitrate quality:quality framerate:framerate];

}


+ (PMKPromise *) videoStreamStopWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy videoStreamStop:modelObj mac:mac];

}


+ (PMKPromise *) wifiScanStartWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy wifiScanStart:modelObj mac:mac];

}


+ (PMKPromise *) wifiScanEndWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy wifiScanEnd:modelObj mac:mac];

}


+ (PMKPromise *) wifiConnectWithMac:(NSString *)mac withSsid:(NSString *)ssid withSecurity:(NSString *)security withKey:(NSString *)key onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy wifiConnect:modelObj mac:mac ssid:ssid security:security key:key];

}


+ (PMKPromise *) wifiDisconnectWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy wifiDisconnect:modelObj mac:mac];

}


+ (PMKPromise *) wifiGetAttrsWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy wifiGetAttrs:modelObj mac:mac];

}


+ (PMKPromise *) getCustomAttrsWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy getCustomAttrs:modelObj mac:mac];

}


+ (PMKPromise *) setCustomAttrsWithMac:(NSString *)mac withIrLedMode:(NSString *)irLedMode withIrLedLuminance:(int)irLedLuminance withMdMode:(NSString *)mdMode withMdThreshold:(int)mdThreshold withMdSensitivity:(int)mdSensitivity withMdWindowCoordinates:(NSString *)mdWindowCoordinates onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy setCustomAttrs:modelObj mac:mac irLedMode:irLedMode irLedLuminance:irLedLuminance mdMode:mdMode mdThreshold:mdThreshold mdSensitivity:mdSensitivity mdWindowCoordinates:mdWindowCoordinates];

}


+ (PMKPromise *) purgeCameraWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy purgeCamera:modelObj mac:mac];

}


+ (PMKPromise *) ptzGetAttrsWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy ptzGetAttrs:modelObj mac:mac];

}


+ (PMKPromise *) ptzGotoHomeWithMac:(NSString *)mac onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy ptzGotoHome:modelObj mac:mac];

}


+ (PMKPromise *) ptzGotoAbsoluteWithMac:(NSString *)mac withPan:(int)pan withTilt:(int)tilt withZoom:(int)zoom onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy ptzGotoAbsolute:modelObj mac:mac pan:pan tilt:tilt zoom:zoom];

}


+ (PMKPromise *) ptzGotoRelativeWithMac:(NSString *)mac withDeltaPan:(int)deltaPan withDeltaTilt:(int)deltaTilt withDeltaZoom:(int)deltaZoom onModel:(HubModel *)modelObj {
  return [HubSercommCapabilityLegacy ptzGotoRelative:modelObj mac:mac deltaPan:deltaPan deltaTilt:deltaTilt deltaZoom:deltaZoom];

}

@end
