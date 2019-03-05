//
//  NSURLSession+PromiseKit.m
//  Pods
//
//  Created by Arcus Team on 4/29/15.
//
//

#import <i2app-Swift.h>
#import "NSURLSession+PromiseKit.h"
#import <PromiseKit/PromiseKit.h>
#import "NSURLResponse+Process.h"

@implementation NSURLSession (PromiseKit)

- (PMKPromise *)promiseDataTaskWithURL:(NSURL *)url {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self dataTaskWithURL:url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
	        if (error) {
	            reject(error);
			}
	        else {
                error = [response getHttpResponseError];
                if (!error) {
                    fulfill(PMKManifold(data, response));
                }
                else {
                    reject(error);
                }
			}
		}];
	    [task resume];
	}];
}

- (PMKPromise *)promiseDataTaskWithRequest:(NSURLRequest *)request {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
	        if (!error) {
                error = [response getHttpResponseError];
                if (!error) {
                    fulfill(PMKManifold(data, response));
                }
                else {
                    reject(error);
                }
			}
            else {
                reject(error);
            }
		}];
	    [task resume];
	}];
}

- (PMKPromise *)promiseDownloadTaskWithURL:(NSURL *)URL toURL:(NSURL *)toURL {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self downloadTaskWithURL:URL completionHandler: ^(NSURL *location, NSURLResponse *response, NSError *error) {
	        if (error) {
	            reject(error);
			}
	        else {
                error = [response getHttpResponseError];
                if (!error) {
                    NSError *e = nil;
                    [[NSFileManager defaultManager] moveItemAtURL:location toURL:toURL error:&e];
                    fulfill(e);
                }
                else {
                    reject(error);
                }
			}
		}];
	    [task resume];
	}];
}

- (PMKPromise *)promiseDownloadTaskWithRequest:(NSURLRequest *)request toURL:(NSURL *)toURL {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self downloadTaskWithRequest:request completionHandler: ^(NSURL *location, NSURLResponse *response, NSError *error) {
	        if (error) {
	            reject(error);
			}
	        else {
                if (!error) {
                    NSError *e = nil;
                    [[NSFileManager defaultManager] moveItemAtURL:location toURL:toURL error:&e];
                    fulfill(e);
                }
                else {
                    reject(error);
                }
			}
		}];
	    [task resume];
	}];
}

- (PMKPromise *)promiseUploadTaskWithRequest:(NSURLRequest *)request fromData:(NSData *)bodyData {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self uploadTaskWithRequest:request fromData:bodyData completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
	        if (error) {
	            reject(error);
			}
	        else {
                error = [response getHttpResponseError];
                if (!error) {
                    fulfill(PMKManifold(data, response));
                }
                else {
                    reject(error);
                }
			}
		}];
	    [task resume];
	}];
}

- (PMKPromise *)promiseUploadTaskWithRequest:(NSURLRequest *)request fromFile:(NSURL *)fileURL {
	return [PMKPromise new: ^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
	    NSURLSessionTask *task = [self uploadTaskWithRequest:request fromFile:fileURL completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
	        if (error) {
	            reject(error);
			}
	        else {
                error = [response getHttpResponseError];
                if (!error) {
                    fulfill(PMKManifold(data, response));
                }
                else {
                    reject(error);
                }
			}
		}];
	    [task resume];
	}];
}

@end
