//
//  WifiScanResultModel.m
//  i2app
//
//  Created by Arcus Team on 12/13/15.
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
#import "WifiScanResultModel.h"

@implementation WifiScanResultModel

+ (WifiScanResultModel *)wifiScanResultModelFromAttributes:(NSDictionary *)attributes {
    WifiScanResultModel *wifiScanResultModel = [[WifiScanResultModel alloc] init];
    if (attributes[@"channel"] != [NSNull null]) {
        wifiScanResultModel.channel = @([attributes[@"channel"] integerValue]);
    }
    if (attributes[@"encryption"] != [NSNull null]) {
        wifiScanResultModel.encryption = attributes[@"encryption"];
    }
    if (attributes[@"mode"] != [NSNull null]) {
        wifiScanResultModel.mode = attributes[@"mode"];
    }
    if (attributes[@"security"] != [NSNull null]) {
        wifiScanResultModel.security = [WifiScanResultModel convertedSecurityTypes:attributes[@"security"]];
    }
    if (attributes[@"signal"] != [NSNull null]) {
        wifiScanResultModel.signal = @([attributes[@"signal"] integerValue]);
    }
    if (attributes[@"ssid"] != [NSNull null]) {
        wifiScanResultModel.ssid = attributes[@"ssid"];
    }
    if (attributes[@"wepauth"] != [NSNull null]) {
        wifiScanResultModel.wepauth = attributes[@"wepauth"];
    }
    if (attributes[@"wps"] != [NSNull null]) {
        wifiScanResultModel.wps = attributes[@"wps"];
    }
    
    return wifiScanResultModel;
}

+ (NSArray *)convertedSecurityTypes:(NSArray *)types {
    NSMutableArray *mutableConvertedTypes = [[NSMutableArray alloc] init];
    for (NSString *type in types) {
        [mutableConvertedTypes addObject:[[type stringByReplacingOccurrencesOfString:@"-" withString:@"_"] uppercaseString]];
    }
    
    return [NSArray arrayWithArray:mutableConvertedTypes];
}

@end
