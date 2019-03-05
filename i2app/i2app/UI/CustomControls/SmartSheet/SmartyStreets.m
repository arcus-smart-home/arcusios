//
//  DataLoader.m
//  SmartyStreets
//
//  Arcus Team on 6/3/15.
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
#import "SmartyStreets.h"
#import "ApplicationSecureRequestDelegate.h"

@implementation SmartyStreets

/**
 * Attempts to autocomplete the given address, calling the completion handler with an NSArray of Address objects when complete. Sends
 * the completion handler an empty array if no autocomplete suggestions can be made.
 */
+ (void)autoCompleteAddress:(NSString *)partialAddress withCompletionHandler:(void (^)(NSArray *))completionHandler {
    
    NSString *urlString = [@"https://autocomplete-api.smartystreets.com/suggest?auth-id=replaceme&prefix="
                           stringByAppendingString:[partialAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *requestUrl = [NSURL URLWithString: urlString];
    
    [SmartyStreets downloadDataFromURL:requestUrl withCompletionHandler:^(NSData* data) {
        completionHandler([SmartyStreets parseSuggestedAddresses:data]);
    }];
}

/**
 * Attempts to validate an address represented by a street address, city, and state, calling the completion handler with an NSDictionary
 * of validated attributes and values. Sends the completion handler nil if the given address is invalid.
 */
+ (void)verifyAddress:(NSString *)street withCity:(NSString *)city withState:(NSString *)state withCompletionHandler:(void (^)(NSDictionary *)) completionHandler {
    if ((street != nil) && (city != nil) && (state != nil)) {
        NSString *urlString = [[[[[@"https://api.smartystreets.com/street-address?auth-id=replaceme&auth-token=replaceme"
                                   stringByAppendingString:[SmartyStreets urlEncode:street]]
                                  stringByAppendingString:@"&state="]
                                 stringByAppendingString:[SmartyStreets urlEncode:state]]
                                stringByAppendingString:@"&city="]
                               stringByAppendingString:[SmartyStreets urlEncode:city]];
        
        NSURL *requestUrl = [NSURL URLWithString: urlString];
        
        [SmartyStreets downloadDataFromURL:requestUrl withCompletionHandler:^(NSData* data) {            
            completionHandler([SmartyStreets parseValidatedAddress:data]);
        }];
    }
}

+ (void)verifyAddress:(NSString *)street withZip:(NSString *)zip withCompletionHandler:(void (^)(NSDictionary *))completionHandler {
    // TODO: Not implemented.
}

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    ApplicationSecureRequestDelegate *delegate = [ApplicationSecureRequestDelegate new];
  
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:delegate delegateQueue:nil];
  
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            // If any error occurs then just display its description on the console.
            DDLogWarn(@"%@", [error localizedDescription]);
            
            // Call the completion handler with nil on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(nil);
            }];
        }
        else {
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode != 200) {
                DDLogWarn(@"HTTP status code = %d", (int)HTTPStatusCode);
            }
            
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    
    // Resume the task.
    [task resume];
}

/**
 * Flattens an NSDictionary containing scalar attributes and other NSDictionary objects into an NSDictionary containing only scalar values. As it
 * dives into the given dictionary, it prefixes the key with the given prefix string.
 */
+ (NSDictionary *)flatten:(NSDictionary *)dictionary withPrefix:(NSString *)prefix {
    
    NSMutableDictionary *flattenedDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *thisKey in [dictionary allKeys]) {
        
        NSString *keyName = (prefix == nil) ? thisKey : [[prefix stringByAppendingString:@"/"] stringByAppendingString:thisKey];
        
        if ([[dictionary valueForKey:thisKey] isKindOfClass:[NSDictionary class]]) {
            [flattenedDictionary addEntriesFromDictionary:[SmartyStreets flatten:[dictionary valueForKey:thisKey] withPrefix:keyName]];
        }
        else {
            [flattenedDictionary setObject:[dictionary valueForKey:thisKey] forKey:keyName];
        }
    }
    
    return flattenedDictionary;
}

/**
 * Parses data returned from the SmartyStreets address validation service into an NSDictionary of attribute/value pairs.
 * Returns nil if the address sent to SmartyStreets could not be validated.
 */
+ (NSDictionary *)parseValidatedAddress:(NSData*) data {
    
    if (data != nil) {
        // Convert the returned data into a dictionary.
        NSError *error;
        NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (error != nil) {
            DDLogWarn(@"%@", [error localizedDescription]);
        }
        else {
            for (NSMutableDictionary *thisElement in parsedObject) {
                return [SmartyStreets flatten:thisElement withPrefix:nil];
            }
        }
    }
    
    return nil;
}

/**
 * Parses data returned from the SmartyStreets service into an NSArray of Address objects.
 */
+ (NSArray *)parseSuggestedAddresses:(NSData*) data {
    
    NSMutableArray *addresses = [[NSMutableArray alloc] init];
    
    if (data != nil) {
        // Convert the returned data into a dictionary.
        NSError *error;
        NSMutableDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (error != nil) {
            DDLogWarn(@"%@", [error localizedDescription]);
        }
        else {
            NSArray *results = [parsedObject valueForKey:@"suggestions"];
            if (! [results isEqual:[NSNull null]]) {
                for (NSDictionary *addressDict in results) {
                    SmartyStreetsAddress* address = [[SmartyStreetsAddress alloc] init];
                    
                    [address setText:[[addressDict valueForKey:@"text"] description]];
                    [address setStreet:[[addressDict valueForKey:@"street_line"] description]];
                    [address setCity:[[addressDict valueForKey:@"city"] description]];
                    [address setState:[[addressDict valueForKey:@"state"] description]];
                    
                    [addresses addObject:address];
                }
            }
        }
    }
    
    return addresses;
}

/**
 * Convenience method to URL-encode a given string.
 */
+ (NSString *)urlEncode:(NSString *)value {
    return [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@end


@implementation SmartyStreetsAddress

@end
