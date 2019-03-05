//
//  NSURLSession+Request.h
//  Pods
//
//  Created by Arcus Team on 4/29/15.
//
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Request)

- (NSURLRequest *)createPostRequest:(NSString *)urlString withRequestBody:(NSString *)requestBody;

@end
