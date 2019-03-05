//
//  ClientRequest.h
//  Pods
//
//  Created by Arcus Team on 4/20/15.
//
//

#import <Foundation/Foundation.h>

@class PMKPromise;

@interface ClientRequest : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *command;
@property (strong, nonatomic) NSDictionary *attributes;
@property (assign, atomic) BOOL restfulRequest;
@property (strong, nonatomic) NSString *connectionURL;

- (PMKPromise *)sendRequest;

- (void) setAttributeValue:(id)value forKey:(NSString *)key;

- (NSString *)buildRequestBody;

@end
