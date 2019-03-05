//
//  LoggingConfig.h
//  Pods
//
//  Created by Arcus Team on 10/21/15.
//
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

//extern DDLogLevel ddLogLevel;

@interface LoggingConfig : NSObject

+ (void)setLogLevel:(DDLogLevel)logLevel;

@end
