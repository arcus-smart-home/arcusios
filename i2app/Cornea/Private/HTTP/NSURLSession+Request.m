//
//  NSURLSession+Request.m
//  Pods
//
//  Created by Arcus Team on 4/29/15.
//
//

#import <i2app-Swift.h>
#import "NSURLSession+Request.h"

@implementation NSURLSession (Request)

const int kTimeoutMS = 10;

- (NSURLRequest *)createPostRequest:(NSString *)urlString withRequestBody:(NSString *)requestBody {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.timeoutInterval = kTimeoutMS;
    
    request.HTTPMethod = @"POST";
    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSData *myRequestData = [NSData dataWithBytes:[requestBody UTF8String] length: requestBody.length];
    request.HTTPBody = myRequestData;
    
    return request;
}

@end
