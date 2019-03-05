//
//  BillingRequestBuilder.h
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

#import <Foundation/Foundation.h>

@interface BillingRequestBuilder : NSObject

@property (nonatomic, readonly) NSString *tokenUrl;
@property (nonatomic, readonly) NSString *publicKey;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, assign) int month;
@property (nonatomic, assign) int year;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *verificationValue;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *vatNumber;

- (instancetype)initWithUrl:(NSString *)tokenUrl withPublicKey:(NSString *)publicKey;
- (NSURLRequest *)buildRequest;

- (int)setMonthFromString:(NSString *)month;
- (int)setYearFromString:(NSString *)year;

@end
