//
//  ClientMessage.m
//  Pods
//
//  Created by Arcus Team on 4/22/15.
//
//

#import <i2app-Swift.h>
#import "ClientMessage.h"

// Matches any message type.
static NSString *const kMSG_ANY_MESSAGE_TYPE = @"*";

static NSString *const kHeaders = @"headers";
static NSString *const kDestination = @"destination";
static NSString *const kCorelationId = @"correlationId";
static NSString *const kIsRequest = @"isRequest";
static NSString *const kSource = @"source";
static NSString *const kType = @"type";
static NSString *const kMessageType = @"messageType";
static NSString *const kPayload = @"payload";
static NSString *const kAttributes = @"attributes";

@interface ClientMessage ()


@end;


@implementation ClientMessage

+ (ClientMessage *)clientMessageWithJsonData:(NSDictionary *)jsonDict {
    // Create ClientMessage
    return [[ClientMessage alloc] initWithJson:jsonDict];
}

+ (ClientMessage *)getClientMessage:(NSString *)message {
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create ClientMessage
    return [[ClientMessage alloc] initWithJson:jsonObject];
}

#pragma mark - Life Cycle
- (instancetype)initRequest:(NSString *)destination
                       type:(NSString *)type
                 attributes:(NSDictionary *)attributes
              correlationId:(NSString *)correlationId {
    if (self = [super init]) {
        _source = nil;
        _destination = destination;
        _isRequest = YES;
        _type = type;
        _correlationId = correlationId;
        _attributes = attributes;
    }
    return self;
}

- (instancetype)initWithDestination:(NSString *)destination
                          isRequest:(BOOL)isRequest
                               type:(NSString *)type
                         attributes:(NSDictionary *)attributes
                      correlationId:(NSString *)correlationId {
    if (self = [super init]) {
        _source = nil;
        _destination = destination;
        _isRequest = isRequest;
        _type = type;
        _correlationId = correlationId;
        _attributes = attributes;
    }
    return self;
}


- (instancetype)initWithJson:(NSDictionary *)jsonDict {
    if (self = [super init]) {
        _type = jsonDict[kType];
        _attributes = jsonDict[kPayload][kAttributes];
        jsonDict = jsonDict[kHeaders];
        
        _destination = jsonDict[kDestination];
        _source = jsonDict[kSource];
        _correlationId = jsonDict[kCorelationId];
        _isRequest = ((NSString *)jsonDict[kIsRequest]).boolValue;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%@ destination:%@ source:%@ correlationId:%@ isRequest:%d attributes:%@", self.type, self.destination, self.source, self.correlationId, self.isRequest, self.attributes];
}

- (NSDictionary *)buildJsonObject {
    if (!self.destination || !self.correlationId) {
        return nil;
    }
    NSDictionary *headers = @{kDestination:self.destination,
                              kCorelationId:self.correlationId,
                              kIsRequest:[[NSNumber alloc] initWithBool:self.isRequest]};
    NSDictionary *payloadDict;
    if (self.attributes.count > 0) {
        payloadDict = @{kMessageType:self.type, kAttributes:self.attributes};
    }
    else {
        payloadDict = @{kMessageType:self.type};
    }
    NSDictionary *jsonDict = @{kType:self.type,
                               kHeaders:headers,
                               kPayload:payloadDict};
    return jsonDict;
}


- (NSString *)toString {
    NSDictionary *jsonDict = [self buildJsonObject];
    if (!jsonDict) {
        return @"";
    }
    // DDLogWarn(@"jsonObject=%@", jsonDict);
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DDLogWarn(@"json string: %@", jsonString);
    
    return jsonString;
}

- (BOOL)isError {
    return ([self.type caseInsensitiveCompare:@"Error"] == NSOrderedSame);
}

@end

