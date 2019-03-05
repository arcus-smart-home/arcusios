//
//  ClientRequest.m
//  Pods
//
//  Created by Arcus Team on 4/20/15.
//
//

#import <i2app-Swift.h>
#import "ClientRequest.h"

#import <PromiseKit/PromiseKit.h>

@implementation ClientRequest

NSMutableDictionary     *_attributes;

#pragma mark - Life Cycle
- (NSString *)description {
    return [NSString stringWithFormat:@"ClientRequest [address=%@, command=%@, attributes=%@, restfulRequest=%d, connectionURL=%@]", self.address, self.command, _attributes, self.restfulRequest, self.connectionURL];
}

- (void)setAttributeValue:(id)value forKey:(NSString *)key {
    if (!_attributes) {
        _attributes = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    [_attributes setValue:value forKey:key];
}


- (NSString *)buildRequestBody {
    NSError *error = nil;
    NSDictionary *jsonDict;
    if (_attributes) {
        jsonDict = @{@"headers": @{@"destination": self.address },@"type": self.command, @"payload": @{@"attributes": _attributes,@"messageType": self.command}};
    }
    else {
        jsonDict = @{@"headers": @{@"destination": self.address },@"type": self.command, @"payload": @{@"messageType": self.command}};
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
