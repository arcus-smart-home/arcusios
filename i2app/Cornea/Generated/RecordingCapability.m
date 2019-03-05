

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>
#import "RecordingCapability.h"
#import <i2app-Swift.h>


NSString *const kAttrRecordingName=@"video:name";

NSString *const kAttrRecordingAccountid=@"video:accountid";

NSString *const kAttrRecordingPlaceid=@"video:placeid";

NSString *const kAttrRecordingCameraid=@"video:cameraid";

NSString *const kAttrRecordingPersonid=@"video:personid";

NSString *const kAttrRecordingTimestamp=@"video:timestamp";

NSString *const kAttrRecordingWidth=@"video:width";

NSString *const kAttrRecordingHeight=@"video:height";

NSString *const kAttrRecordingBandwidth=@"video:bandwidth";

NSString *const kAttrRecordingFramerate=@"video:framerate";

NSString *const kAttrRecordingPrecapture=@"video:precapture";

NSString *const kAttrRecordingType=@"video:type";

NSString *const kAttrRecordingDuration=@"video:duration";

NSString *const kAttrRecordingSize=@"video:size";

NSString *const kAttrRecordingDeleted=@"video:deleted";

NSString *const kAttrRecordingDeleteTime=@"video:deleteTime";

NSString *const kAttrRecordingCompleted=@"video:completed";

NSString *const kAttrRecordingVideoCodec=@"video:videoCodec";

NSString *const kAttrRecordingAudioCodec=@"video:audioCodec";


NSString *const kCmdRecordingView=@"video:View";

NSString *const kCmdRecordingDownload=@"video:Download";

NSString *const kCmdRecordingDelete=@"video:Delete";

NSString *const kCmdRecordingResurrect=@"video:Resurrect";


NSString *const kEnumRecordingTypeSTREAM = @"STREAM";
NSString *const kEnumRecordingTypeRECORDING = @"RECORDING";


@implementation RecordingCapability
+ (NSString *)namespace { return @"video"; }
+ (NSString *)name { return @"Recording"; }

+ (NSString *)getNameFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getName:modelObj];
  
}

+ (NSString *)setName:(NSString *)name onModel:(RecordingModel *)modelObj {
  [RecordingCapabilityLegacy setName:name model:modelObj];
  
  return [RecordingCapabilityLegacy getName:modelObj];
  
}


+ (NSString *)getAccountidFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getAccountid:modelObj];
  
}


+ (NSString *)getPlaceidFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getPlaceid:modelObj];
  
}


+ (NSString *)getCameraidFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getCameraid:modelObj];
  
}


+ (NSString *)getPersonidFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getPersonid:modelObj];
  
}


+ (NSDate *)getTimestampFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getTimestamp:modelObj];
  
}


+ (int)getWidthFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getWidth:modelObj] intValue];
  
}


+ (int)getHeightFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getHeight:modelObj] intValue];
  
}


+ (int)getBandwidthFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getBandwidth:modelObj] intValue];
  
}


+ (double)getFramerateFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getFramerate:modelObj] doubleValue];
  
}


+ (double)getPrecaptureFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getPrecapture:modelObj] doubleValue];
  
}


+ (NSString *)getTypeFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getType:modelObj];
  
}


+ (double)getDurationFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getDuration:modelObj] doubleValue];
  
}


+ (long)getSizeFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getSize:modelObj] longValue];
  
}


+ (BOOL)getDeletedFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getDeleted:modelObj] boolValue];
  
}


+ (NSDate *)getDeleteTimeFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getDeleteTime:modelObj];
  
}


+ (BOOL)getCompletedFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return 0; }
  
  return [[RecordingCapabilityLegacy getCompleted:modelObj] boolValue];
  
}


+ (NSString *)getVideoCodecFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getVideoCodec:modelObj];
  
}


+ (NSString *)getAudioCodecFromModel:(RecordingModel *)modelObj {
  if (modelObj == nil) { return nil; }
  
  return [RecordingCapabilityLegacy getAudioCodec:modelObj];
  
}




+ (PMKPromise *) viewOnModel:(RecordingModel *)modelObj {
  return [RecordingCapabilityLegacy view:modelObj ];
}


+ (PMKPromise *) downloadOnModel:(RecordingModel *)modelObj {
  return [RecordingCapabilityLegacy download:modelObj ];
}


+ (PMKPromise *) deleteOnModel:(RecordingModel *)modelObj {
  return [RecordingCapabilityLegacy delete:modelObj ];
}


+ (PMKPromise *) resurrectOnModel:(RecordingModel *)modelObj {
  return [RecordingCapabilityLegacy resurrect:modelObj ];
}

@end
