//
//  BillingTokenClient.m
//  Cornea
//
//  Created by Arcus Team on 5/4/15.
/*
 * Copyright 2019 Arcus Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
//

#import <i2app-Swift.h>
#import "BillingTokenClient.h"
#import "ApplicationSecureRequestDelegate.h"

@implementation BillingTokenClient

+ (PMKPromise *)getBillingTokenUsing:(BillingRequestBuilder *)builder {
    ApplicationSecureRequestDelegate *delegate = [ApplicationSecureRequestDelegate new];
  
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                          delegate:delegate
                                                     delegateQueue:[NSOperationQueue currentQueue]];
    return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        
        NSURLSessionTask *task = [session dataTaskWithRequest:[builder buildRequest] completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            NSError *error = e;
            NSString *token;
            if (!error) {
                if (((NSHTTPURLResponse *)r).statusCode != 200) {
                    error = [NSError errorWithDomain:@"Arcus"
                                                code:2000
                                            userInfo:@{
                                                       NSLocalizedDescriptionKey:
                                                           [NSString stringWithFormat:@"Billing system returned unexpected HTTP-code %ld!",
                                                            (long)((NSHTTPURLResponse *) r).statusCode]
                                                       }];
                }
                else {
                    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:d options:0 error:&error];
                    if (!error) {
                        NSDictionary *recurlyError = response[@"error"];
                        if (recurlyError.count > 0) {
                            error = [NSError errorWithDomain:@"Arcus"
                                                        code:2001
                                                    userInfo:recurlyError];
                        }
                        else {
                            token = [response objectForKey:@"id"];
                        }
                    }
                }
            }
            
            if (error) {
                reject(error);
            }
            else {
                fulfill(token);
            }
        }];
        [task resume];
    }];
}

@end
