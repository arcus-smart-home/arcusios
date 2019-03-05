//
//  ClientEvent.h
//  Pods
//
//  Created by Arcus Team on 4/20/15.
//
//

#import <Foundation/Foundation.h>

@interface ClientEvent : NSObject

- (instancetype) initWithType:(NSString *)type
            withSourceAddress:(NSString *)sourceAddress
               withAttributes:(NSDictionary *)attributes;

- (NSString *)getType;
- (NSString *)getSourceAddress;
- (NSDictionary *)getAttributes;
- (id)getAttribute:(NSString *)key;

@end
