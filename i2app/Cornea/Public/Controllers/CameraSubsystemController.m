//
//  CameraSubsystemController.m
//  Pods
//
//  Created by Arcus Team on 10/5/15.
//
//

#import <i2app-Swift.h>
#import "CameraSubsystemController.h"
#import "CamerasSubsystemCapability.h"

#import "VideoService.h"
#import "RecordingCapability.h"

#import <PromiseKit/PromiseKit.h>

@implementation CameraSubsystemController

@synthesize subsystemModel;
@dynamic allDeviceIds;
@dynamic numberOfDevices;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        subsystemModel = [[SubsystemModel alloc] initWithAttributes:attributes];
    }
    
    return self;
}

- (NSString *)description {
    return self.subsystemModel.description;
}


- (NSArray *)allDeviceIds {
    return [CamerasSubsystemCapability getCamerasFromModel:self.subsystemModel];
}

- (int)numberOfDevices {
    return (int)[self allDeviceIds].count;
}

- (PMKPromise *)getCameraPreviewWithCameraId:(NSString *)cameraId placeId:(NSString *)placeId {
  return [[[CorneaHolder shared] session] fetchCameraPreview:cameraId placeId:placeId];
}

- (PMKPromise *)listRecordingsWithWithCameraId:(NSString *)cameraId
                                       placeId:(NSString *)placeId {
    
    return [VideoService listRecordingsWithPlaceId:placeId withAll:NO withType:kEnumRecordingTypeRECORDING].then(^(VideoServiceListRecordingsResponse *response ){
        NSArray *records = response.getRecordings;
        NSMutableArray *results = [NSMutableArray array];
        for(NSDictionary *dict in records) {
            RecordingModel *model = [[RecordingModel alloc] initWithAttributes:dict];
            
            if ([[RecordingCapability getCameraidFromModel:model] isEqualToString:cameraId]) {
                [results addObject:model];
            }
        }
        NSArray *sortedArray;
        sortedArray = [results sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [RecordingCapability  getTimestampFromModel:a];
            NSDate *second = [RecordingCapability getTimestampFromModel:b];
            return [first compare:second];
        }];
        
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(sortedArray);
        }];
    });
}

- (PMKPromise *)lastRecordForPlaceId:(NSString *)placeId {
    return [VideoService listRecordingsWithPlaceId:placeId withAll:NO withType:kEnumRecordingTypeRECORDING].thenInBackground(^(VideoServiceListRecordingsResponse *response ){
        NSArray *records = response.getRecordings;
        NSMutableArray *results = [NSMutableArray array];
        
        for(NSDictionary *dict in records) {
            RecordingModel *model = [[RecordingModel alloc] initWithAttributes:dict];
            if ([[RecordingCapability getTypeFromModel:model] isEqualToString:kEnumRecordingTypeRECORDING]) {
                [results addObject:model];
            }
        }
        
        NSArray *sortedArray;
        sortedArray = [results sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSDate *first = [RecordingCapability  getTimestampFromModel:a];
            NSDate *second = [RecordingCapability getTimestampFromModel:b];
            return [second compare:first];
        }];
        
        RecordingModel *lastRecording = sortedArray.count == 0?  nil: sortedArray.firstObject;
        
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            fulfill(lastRecording);
        }];
    });
}

- (PMKPromise *)lastRecordForCameraId:(NSString *)cameraId
                              placeId:(NSString *)placeId {
    
    return [self listRecordingsWithWithCameraId:cameraId
                                        placeId:placeId].then(^(NSArray *records ) {
        
        RecordingModel *lastRecording = records.count == 0?  nil: records.lastObject;
        
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
            if (lastRecording) {
                fulfill(lastRecording);
            }
            else {
                reject(nil);
            }
        }];
    });
}

@end
