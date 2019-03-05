//
//  LoggingConfig.m
//  Pods
//
//  Created by Arcus Team on 10/21/15.
//
//

#import <i2app-Swift.h>
#import "LoggingConfig.h"

#ifdef DEBUG
#define APP_LOG_LEVEL DDLogLevelAll
#define CORNEA_LOG_LEVEL DDLogLevelAll
#else
#define APP_LOG_LEVEL DDLogLevelError
#define CORNEA_LOG_LEVEL DDLogLevelOff
#endif

//DDLogLevel ddLogLevel = DDLogLevelOff;

@implementation LoggingConfig

+ (void)setLogLevel:(DDLogLevel)logLevel {
    ddLogLevel = logLevel;
}

@end
