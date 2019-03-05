//
//  ClientMessage.h
//  Pods
//
//  Created by Arcus Team on 4/22/15.
//
//

#import <Foundation/Foundation.h>

@interface ClientMessage : NSObject // <NSCoding>

+ (ClientMessage *)clientMessageWithJsonData:(NSDictionary *)jsonDict;
+ (ClientMessage *)getClientMessage:(NSString *)message;

- (instancetype)initWithDestination:(NSString *)destination
                          isRequest:(BOOL)isRequest
                               type:(NSString *)type
                         attributes:(NSDictionary *)attributes
                      correlationId:(NSString *)correlationId;

- (instancetype)initRequest:(NSString *)destination
                       type:(NSString *)type
                 attributes:(NSDictionary *)attributes
              correlationId:(NSString *)correlationId;

- (instancetype)initWithJson:(NSDictionary *)jsonDict;

@property (readonly, nonatomic) NSString *type;
@property (readonly, nonatomic) NSString *destination;
@property (readonly, nonatomic) NSString *source;
@property (readonly, nonatomic) NSString *correlationId;

@property (readonly, atomic) BOOL isRequest;
@property (readonly, nonatomic) NSDictionary *attributes;

- (NSDictionary *)buildJsonObject;
- (NSString *)toString;

- (BOOL)isError;

@end

