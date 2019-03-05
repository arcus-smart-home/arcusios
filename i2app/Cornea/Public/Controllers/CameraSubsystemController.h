//
//  CameraSubsystemController.h
//  Pods
//
//  Created by Arcus Team on 10/5/15.
//
//

#import <Foundation/Foundation.h>
#import "SubsystemsController.h"

@interface CameraSubsystemController : NSObject<SubsystemProtocol>

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (PMKPromise *)getCameraPreviewWithCameraId:(NSString *)cameraId
                                     placeId:(NSString *)placeId;

- (PMKPromise *)listRecordingsWithWithCameraId:(NSString *)cameraId
                                       placeId:(NSString *)placeId;

- (PMKPromise *)lastRecordForPlaceId:(NSString *)placeId;

- (PMKPromise *)lastRecordForCameraId:(NSString *)cameraId
                              placeId:(NSString *)placeId;

@end
