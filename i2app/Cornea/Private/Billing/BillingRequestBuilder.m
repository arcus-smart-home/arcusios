//
//  BillingRequestBuilder.m
//  Cornea
//
//  Created by Arcus Team on 5/4/15.
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
#import "NSString+URLEncoding.h"
#import "BillingRequestBuilder.h"

#import <i2app-Swift.h>

static NSString *const kCardNumber=@"number";
static NSString *const kMonth = @"month";
static NSString *const kYear = @"year";
static NSString *const kFirstName = @"first_name";
static NSString *const kLastName = @"last_name";
static NSString *const kVerificationValue = @"cvv";
static NSString *const kAddress1 = @"address1";
static NSString *const kAddress2 = @"address2";
static NSString *const kCity = @"city";
static NSString *const kState = @"state";
static NSString *const kPostalCode = @"postal_code";
static NSString *const kCountry = @"country";
static NSString *const kVatNumber = @"vat_number";

@interface BillingRequestBuilder ()

- (NSData *)buildBody;

@end


@implementation BillingRequestBuilder

- (instancetype)initWithUrl:(NSString *)tokenUrl withPublicKey:(NSString *)publicKey {
    if (self = [super init]) {
        _tokenUrl = tokenUrl;
        _publicKey = publicKey;
    }
    return self;
}

- (NSURLRequest *)buildRequest {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.tokenUrl]];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [self buildBody];
    return request;
}

- (NSData *)buildBody {
    NSMutableString *body = [NSMutableString
                             stringWithFormat:@"%@=%@", @"key", [self.publicKey stringAsUrlEncoded]];
    
    [body appendFormat:@"&%@=%@", kCardNumber, [self.cardNumber stringAsUrlEncoded]];
    [body appendFormat:@"&%@=%d", kMonth, self.month];
    [body appendFormat:@"&%@=%d", kYear, self.year];
    
    if (self.firstName) {
        [body appendFormat:@"&%@=%@", kFirstName, [self.firstName stringAsUrlEncoded]];
    }
    if (self.lastName) {
        [body appendFormat:@"&%@=%@", kLastName, [self.lastName stringAsUrlEncoded]];
    }
    if (self.verificationValue) {
        [body appendFormat:@"&%@=%@", kVerificationValue, [self.verificationValue stringAsUrlEncoded]];
    }
    if (self.address1) {
        [body appendFormat:@"&%@=%@", kAddress1, [self.address1 stringAsUrlEncoded]];
    }
    if (self.address2) {
        [body appendFormat:@"&%@=%@", kAddress2, [self.address2 stringAsUrlEncoded]];
    }
    if (self.city) {
        [body appendFormat:@"&%@=%@", kCity, [self.city stringAsUrlEncoded]];
    }
    if (self.state) {
        [body appendFormat:@"&%@=%@", kState, [self.state stringAsUrlEncoded]];
    }
    if (self.postalCode) {
        [body appendFormat:@"&%@=%@", kPostalCode, [self.postalCode stringAsUrlEncoded]];
    }
    if (self.country) {
        [body appendFormat:@"&%@=%@", kCountry, [self.country stringAsUrlEncoded]];
    }
    if (self.vatNumber) {
        [body appendFormat:@"&%@=%@", kVatNumber, [self.vatNumber stringAsUrlEncoded]];
    }
    
    return [NSData dataWithBytes:body.UTF8String length:body.length];
}

- (int)setMonthFromString:(NSString *)month {
    self.month = (int)[[Constants getMonths] indexOfObject:month] + 1;
    return self.month;
}

- (int)setYearFromString:(NSString *)year {
    self.year = (int)[year integerValue];
    return self.year;
}

@end
