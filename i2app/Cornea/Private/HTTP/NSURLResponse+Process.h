//
//  NSURLResponse+Process.h
//  Pods
//
//  Created by Arcus Team on 4/29/15.
//
//

#import <Foundation/Foundation.h>

extern const int kHttpCodeUnautorized;

@interface NSURLResponse (Process)

- (NSError *)getHttpResponseError;

- (NSString *)getToken:(NSData *)data;

@end
