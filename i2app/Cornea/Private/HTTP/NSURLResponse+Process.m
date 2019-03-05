//
//  NSURLResponse+Process.m
//  Pods
//
//  Created by Arcus Team on 4/29/15.
//
//

#import <i2app-Swift.h>
#import "NSURLResponse+Process.h"
#import <PromiseKit/PromiseKit.h>



@implementation NSURLResponse (Process)

const int kHttpCodeOk = 200;
const int kHttpCodeUnautorized = 401;
const int kHttpCodeNotFound = 404;
const int kHttpCodeNotAcceptable = 406;
const int kHttpCodeConflict = 409;
const int kHttpCodeInternalServerError = 500;

- (NSError *)getHttpResponseError {
    
    if (((NSHTTPURLResponse *)self).statusCode < 300) {
        return nil;
    }
    NSString *errorMessage;
    switch (((NSHTTPURLResponse *)self).statusCode) {
        case kHttpCodeUnautorized:
            errorMessage = @"Authentication Failure";
            break;
            
        case kHttpCodeInternalServerError:
            errorMessage = @"Most Probably the request format is not correct";
            break;
            
        default:
            errorMessage = @"Unknown error: please investigate";
            break;
    }
    NSError *error = [NSError errorWithDomain:@"Arcus" code:((NSHTTPURLResponse *)self).statusCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
    
    return error;
}

- (NSString *)getToken:(NSData *)data {
    NSString *token = nil;
//    @try {
//        NSError *error;
//        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
//                                                                     options:kNilOptions
//                                                                       error:&error];
//
//        NSString *status = jsonResponse[@"status"];
//
//        if ([status localizedCaseInsensitiveCompare:@"success"] == NSOrderedSame) {
//            NSURL *url = [NSURL URLWithString:[[[CorneaHolder shared] session] getPlatformUrl]];
//            NSHTTPCookie *cookie = [[NSHTTPCookie cookiesWithResponseHeaderFields:((NSHTTPURLResponse *)self).allHeaderFields forURL:url] firstObject];
//
//            token = cookie.value;
//            DDLogWarn(@"Authorization token: %@", token);
//        }
//        else {
//            NSString *errorMessage = [NSString stringWithFormat:@"NSURLResponse:getToken returns response status different from \"success\""];
//            DDLogWarn(@"%@", errorMessage);
//            errorMessage = [NSString stringWithFormat:@"receivedErrorMessage:%@ \n additionalInfo:%@", error.localizedDescription, errorMessage];
//            // TODO: create a global pending response handler
//            [NSException raise:NSInternalInconsistencyException
//                        format:@"%@", errorMessage];
//        }
//    }
//    @catch (NSException *exception) {
//        DDLogWarn(@"Exception: %@", exception);
//    }
    return token;
}

@end
