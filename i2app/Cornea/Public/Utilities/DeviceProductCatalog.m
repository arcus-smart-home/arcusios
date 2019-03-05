//
//  DeviceProductCatalog.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "DeviceProductCatalog.h"
#import "ProductCapability.h"
#import "Capability.h"

@interface DeviceProductCatalog ()

@property (nonatomic, strong, readonly) NSDictionary *json;

@end

@implementation DeviceProductCatalog

@dynamic categories;
@dynamic brand;
@dynamic productName;
@dynamic productScreen;
@dynamic image;
@dynamic protoFamily;
@dynamic productId;
@dynamic arcusProductId;
@dynamic pairingSteps;
@dynamic keywords;
@dynamic videoURL;
@dynamic vendorId;

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Always use initWithJson: to initialize this class"];
    }
    return self;
}

- (instancetype)initWithJson:(NSDictionary *)json {
    if (self = [super init]) {
        _json = json;
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.json.description];
}

#pragma mark - Dynamic properties

- (NSString *)productId {
    return self.json[kAttrId];
}

- (NSString *)devRequired {
  return self.json[kAttrProductDevRequired];
}

- (NSString *)arcusProductId {
    return self.json[kAttrProductArcusProductId];
}

- (NSString *)productName {
    return self.json[kAttrProductName];
}

- (NSString *)protoFamily {
    return self.json[kAttrProductProtoFamily];
}

- (NSString *)productScreen {
    return self.json[kAttrProductScreen];
}

- (NSArray *)categories {
    return self.json[kAttrProductCategories];
}

- (NSString *)brand {
    return self.json[kAttrProductVendor];
}

- (NSArray *)image {
    return self.json[kAttrProductAddDevImg];
}

- (NSString *)keywords {
    return self.json[kAttrProductKeywords];
}

- (NSArray *)videoURL {
    return self.json[kAttrProductPairVideoUrl];
}

- (NSString *)vendorId {
    return self.json[kAttrProductArcusVendorId];
}

- (NSArray *)pairingSteps {
    NSArray *steps = self.json[kAttrProductPair];
    return steps.copy;
}

#pragma mark - Getting steps properies methods
- (NSString *)getTextFromPairingSteps:(NSInteger)stepNumber {
    NSArray *steps = self.json[kAttrProductPair];
    if (!steps || [steps count] == 0 || stepNumber >= [steps count]) return @"";
    
    NSString *text = [steps[stepNumber] objectForKey:@"text"];
    if (text) {
        return text;
    }
    else {
        return @"";
    }
}

- (NSString *)getSecondaryTextFromPairingSteps:(NSInteger)stepNumber {
    NSArray *steps = self.json[kAttrProductPair];
    if (!steps || [steps count] == 0 || stepNumber >= [steps count]) return @"";
    
    NSString *text = [steps[stepNumber] objectForKey:@"secondaryText"];
    if (text) {
        return text;
    }
    else {
        return @"";
    }
}

- (NSString *)targetForDevicePairingStep:(NSInteger)stepIndex {
    NSString *stepTarget = nil;
    
    NSArray *steps = self.json[kAttrProductPair];
    
    if (steps.count > 0 && stepIndex < steps.count) {
        stepTarget = [steps[stepIndex] objectForKey:@"target"];
    }
    
    return stepTarget;
}

- (NSArray *)devicePairingStepInputs:(NSInteger)stepIndex {
    NSArray *stepInputs = nil;
    
    NSArray *steps = self.json[kAttrProductPair];
    
    if (steps.count > 0 && stepIndex < steps.count) {
        stepInputs = [steps[stepIndex] objectForKey:@"inputs"];
    }
    
    return stepInputs;
}

- (PairingStepType)getPairingTypeFromPairingSteps:(NSInteger)stepNumber {
    PairingStepType stepType = PairingStepBase;
    
    NSArray *steps = self.json[kAttrProductPair];
    if (steps.count > 0 && stepNumber < steps.count) {
        NSString *typeString = [steps[stepNumber] objectForKey:@"type"];
        if ([typeString isEqualToString:@"TEXT"]) {
            stepType = PairingStepBase;
        } else if ([typeString isEqualToString:@"INPUT"]) {
            stepType = PairingStepInput;
        }
    }
    return stepType;
}

@end
