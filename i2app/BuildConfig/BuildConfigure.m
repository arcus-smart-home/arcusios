//
//  BuildConfigure.m
//  i2app
//
//  Created by Arcus Team on 12/31/15.
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

#import "BuildConfigure.h"
#import <sys/sysctl.h>

@implementation BuildConfigure

+ (NSString *)clientAgentInfo {
    return [NSString stringWithFormat:@"%@/%@(%@)", [UIDevice currentDevice].model, [BuildConfigure osVersion], [BuildConfigure platformRawString]];
}

+ (NSString *)clientVersionInfo {
    return [NSString stringWithFormat:@"%@-%@", [BuildConfigure clientVersion], [BuildConfigure hashCommit]];
}

+ (NSString *)clientVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)clientBundleIdentifier {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"];
}

+ (NSString *)hashCommit {
    return [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleVersionKey];
}

+ (NSString *)osVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)platformRawString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

@end
