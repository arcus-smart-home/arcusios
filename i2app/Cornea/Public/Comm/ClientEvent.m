//
//  ClientEvent.m
//  Pods
//
//  Created by Arcus Team on 4/20/15.
//
//

#import <i2app-Swift.h>
#import "ClientEvent.h"

@interface ClientEvent ()

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *sourceAddress;
@property (strong, nonatomic) NSDictionary *attributes;

@end


@implementation ClientEvent

- (instancetype) init {
    if (self = [super init]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Always use the initializer initWithType:withSourceAddress:withAttributes:"];
    }
    return self;
}

- (instancetype) initWithType:(NSString *)type
            withSourceAddress:(NSString *)sourceAddress
               withAttributes:(NSDictionary *)attributes {
    if (self = [super init]) {
        _type =  type;
        _sourceAddress = sourceAddress;
        _attributes = attributes ? attributes : [[NSDictionary alloc] init];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ClientEvent [type=%@, source=%@, attributes=%@]", self.type, self.sourceAddress, self.attributes];
}

#pragma mark - Accessors
- (NSString *)getType {
    return self.type;
}

- (NSString *)getSourceAddress {
    return self.sourceAddress;
}

- (NSDictionary *)getAttributes {
    return self.attributes;
}

- (id)getAttribute:(NSString *)key {
    return self.attributes[key];
}

@end
