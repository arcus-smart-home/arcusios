//
//  LocationHelper.h
//  Pods
//
//  Created by Arcus Team on 10/2/15.
//
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

typedef void(^LocationCompletionSuccessBlock)(double latitude, double longitude);
typedef void(^LocationCompletionFailureBlock)(NSError *err);


- (void)startLocationManagerWithBlock:(LocationCompletionSuccessBlock)successBlock
                     withFailureBlock:(LocationCompletionFailureBlock)failureBlock;

@end
