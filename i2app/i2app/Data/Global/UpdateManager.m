//
// UpdateManager.m
//
// Created by Arcus Team on 4/1/16.
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
#import "UpdateManager.h"
#import "UpdateOperation.h"

@interface UpdateManager()

@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

static NSString *kAppVersionKey = @"APP_VERSION_KEY";
static void *operationQueueContext = &operationQueueContext;

@implementation NSString (VersionNumbers)
- (NSString *)shortenedVersionNumberString {
    static NSString *const unnecessaryVersionSuffix = @".0";
    NSString *shortenedVersionNumber = self;
    
    while ([shortenedVersionNumber hasSuffix:unnecessaryVersionSuffix]) {
        shortenedVersionNumber = [shortenedVersionNumber substringToIndex:shortenedVersionNumber.length - unnecessaryVersionSuffix.length];
    }
    
    return shortenedVersionNumber;
}
@end

@implementation UpdateManager

- (instancetype)initialUpgradeWithAction:(void (^)(void))action {
    // TODO: Should not add more blocks once update has started
    // assert(self.progress == nil);

    NSString *savedVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:kAppVersionKey] shortenedVersionNumberString];

    __block UpdateManager *weakSelf = self;
    if (!savedVersion || [savedVersion isEqualToString:@""]) {
        // savedVersion doesn't exist to run this as the initial action to make
        // This will end up getting called on new installs as well as an update
        // from 1.8.0 to 1.8.1 so pay attention to what you put in the block
        [self.operationQueue addUpdateOperationWithAction:^(dispatch_block_t completionHandler) {
            [weakSelf performAction:action withCompletion:^(NSError *error) {
                // call completionHandler when the operation is done
                completionHandler();
            }];
        }];

        // Since we haven't stored a version yet
        // let us just use this to save the current version
        [self savedVersion];
    }

    // For chaining
    return self;
}


/**

 Chainable function to perform an update from a version to the current version of the app

 @param version string version number
 @param action block to be used to perform the update
 @return self for chaining
 @warning Should not add more blocks once update has started
 */
- (instancetype)upgradeFromVersion:(NSString *)version action:(void (^)(void))action {
    // warning, assert(self.progress == nil);
    [self hasUpdateOccuredFrom:version action:action];
    // For chaining
    return self;
}

- (instancetype)finalizeUpdate {
    // Perform Finalizing Action
    __block UpdateManager *weakSelf = self;
    [self.operationQueue addUpdateOperationWithAction:^(dispatch_block_t completionHandler) {
        [weakSelf upgradeWithCompletion:^(NSError *error) {
            // call completionHandler when the operation is done
            completionHandler();
        }];
    }];

    // For chaining
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == operationQueueContext && [@"operationCount" isEqualToString:keyPath]) {
        NSNumber *operationCount = change[@"operationCount"];
        self.progress.completedUnitCount = self.progress.totalUnitCount - operationCount.unsignedIntegerValue;
    }
}

- (NSOperationQueue *)operationQueue {
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
        
        [_operationQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:operationQueueContext];
    }
    
    return _operationQueue;
}

- (void)dealloc {
    if (_operationQueue) {
        [_operationQueue removeObserver:self forKeyPath:@"operationCount"];
    }
}

- (NSProgress *)update {
    self.progress = [NSProgress progressWithTotalUnitCount:_operationQueue.operationCount];
    return self.progress;
}

// Check if an update has occurred from passed version
// Returns NO if new install or no update has occured
// Performs Action if Provided and Update Occured
// Returns YES if update occurs
- (BOOL)hasUpdateOccuredFrom:(NSString*)version action:(void (^)(void))action {
    NSString *savedVersion = [self savedVersion];
    NSString *currentVersion = [self currentAppVersion];

    if ([version compare:[savedVersion shortenedVersionNumberString] options:NSNumericSearch] == NSOrderedSame
            && (![currentVersion compare:[savedVersion shortenedVersionNumberString] options:NSNumericSearch]) == NSOrderedSame) {
        // savedVersion is equal to the currentVersion so perform action
        __block UpdateManager *weakSelf = self;
        [self.operationQueue addUpdateOperationWithAction:^(dispatch_block_t completionHandler) {
            [weakSelf performAction:action withCompletion:^(NSError *error) {
                // call completionHandler when the operation is done
                completionHandler();
            }];
        }];

        return YES;
    }

    return NO;
}

- (NSString*)upgradeWithCompletion:(void (^)(NSError* error))completion {
    NSString *savedVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:kAppVersionKey] shortenedVersionNumberString];
    NSString *currentVersion = [self currentAppVersion];

    NSError *error;

    if ([currentVersion compare:[savedVersion shortenedVersionNumberString] options:NSNumericSearch] == NSOrderedDescending) {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:kAppVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        error = [[NSError alloc] initWithDomain:UpgradeErrorDomain code:-1 userInfo:nil];
    }

    if (completion) {
        completion(error);
    }

    return currentVersion;
}

- (void)performAction:(void (^)(void))action withCompletion:(void (^)(NSError* error))completion {
    if (action) {
        action();

        if (completion) {
            completion(nil);
        }
    }
}

// New Install Initialization
- (NSString *)savedVersion {
    NSString *savedVersion = [[[NSUserDefaults standardUserDefaults] stringForKey:kAppVersionKey] shortenedVersionNumberString];

    if (!savedVersion || [savedVersion isEqualToString:@""]) {
        savedVersion = [self upgradeWithCompletion:nil];
    }

    return savedVersion;
}

-    (NSString*)currentAppVersion {
    return [(NSString*) [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] shortenedVersionNumberString];
}


@end
