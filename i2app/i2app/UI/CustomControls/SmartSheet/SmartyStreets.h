//
//  DataLoader.h
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

#import <Foundation/Foundation.h>

@interface SmartyStreets : NSObject

+ (void)autoCompleteAddress:(NSString *) partialAddress withCompletionHandler:(void (^)(NSArray *))completionHandler;
+ (void)verifyAddress:(NSString *) street withCity:(NSString *)city withState:(NSString *)state withCompletionHandler:(void (^)(NSDictionary *)) completionHandler;
+ (void)verifyAddress:(NSString *)street withZip:(NSString *)zip withCompletionHandler:(void (^)(NSDictionary *))completionHandler;

@end

@interface SmartyStreetsAddress: NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;

@end
