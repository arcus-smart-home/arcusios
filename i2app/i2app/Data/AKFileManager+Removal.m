// 
// AKFileManager+Removal.m
//
// Created by Arcus Team on 3/31/16.
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
#import "AKFileManager+Removal.h"


@interface AKFileManager (Removal_Private)

// Implemented in AKFileManager.m
- (NSFileManager *)fileManager;
- (NSOperationQueue *)imageIOQueue;

@end

@implementation AKFileManager (Removal)

#pragma mark - Remove Cached Files

- (void)removeCachedImageForHash:(NSString *)descriptionHash {
    // Get Path To Images
    NSString *cachePath = [[self class] amazeKitCachePath];
    NSString *baseHashPath = [cachePath stringByAppendingPathComponent:@"ModelImages"];
    NSString *imagePath = [[baseHashPath stringByAppendingPathComponent:descriptionHash]
            stringByAppendingPathExtension:@"png"];

    __block BOOL isDirectory;
    __block BOOL directoryExists = NO;

    NSBlockOperation *directoryExistsOperation = [NSBlockOperation blockOperationWithBlock:^{
        directoryExists = [[self fileManager] fileExistsAtPath:imagePath
                                                   isDirectory:&isDirectory];
    }];

    [[self imageIOQueue] addOperation:directoryExistsOperation];
    [directoryExistsOperation waitUntilFinished];

    if (directoryExists == YES && isDirectory == NO) {

        NSError *error;

        // Remove File at imagePath
        NSURL *fileURL = [NSURL fileURLWithPath:imagePath];

        [[self fileManager] removeItemAtURL:fileURL error:&error];

        if (error != NULL) {
            DDLogError(@"AKFileManager: File Removal Error: %@", error);
        }

    }
}

- (void)removeAllCachedImagesForHeight:(int)height width:(int)width {
    // Get Path To Images
    NSString *cachePath = [[self class] amazeKitCachePath];
    NSString *baseHashPath = [cachePath stringByAppendingPathComponent:@"ModelImages"];

    __block BOOL isDirectory;
    __block BOOL directoryExists = NO;

    NSBlockOperation *directoryExistsOperation = [NSBlockOperation blockOperationWithBlock:^{
        directoryExists = [[self fileManager] fileExistsAtPath:baseHashPath
                                                   isDirectory:&isDirectory];
    }];

    [[self imageIOQueue] addOperation:directoryExistsOperation];
    [directoryExistsOperation waitUntilFinished];

    if (directoryExists == YES && isDirectory == YES) {

        // Iterate through all Images in Dir
        NSURL *directoryURL = [NSURL fileURLWithPath:baseHashPath];
        NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];

        NSDirectoryEnumerator *enumerator = [[self fileManager]
                enumeratorAtURL:directoryURL
     includingPropertiesForKeys:keys
                        options:0
                   errorHandler:^(NSURL *url, NSError *error) {
                       if (error != nil) {
                           DDLogError(@"AKFileManager: File Enumeration Error: %@", error);
                       }
                       // Return YES if the enumeration should continue after the error.
                       return YES;
                   }];

        for (NSURL *url in enumerator) {
            NSError *error;
            NSNumber *isDirectory = nil;
            if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
                if (error != nil) {
                    DDLogError(@"AKFileManager: File Error: %@", error);
                }
            }
            else if (! [isDirectory boolValue]) {
                // If Image is 90x90
                NSData *data = [NSData dataWithContentsOfURL:url];

                if (data != nil) {
                    UIImage *image = [UIImage imageWithData:data];

                    if (image.size.height == 90 && image.size.width == 90) {
                        // Remove Image
                        [[self fileManager] removeItemAtURL:url error:&error];

                        if (error != nil) {
                            DDLogError(@"AKFileManager: File Removal Error: %@", error);
                        }
                    }
                }
            }
        }
    }
}

@end
