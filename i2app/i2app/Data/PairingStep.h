//
//  PairingStep.h
//  i2app
//
//  Created by Arcus Team on 11/2/15.
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
#import "DeviceProductCatalog+Extension.h"
#import "DevicePairingManager.h"

@interface PairingStep : NSObject

@property (nonatomic, assign) NSInteger stepIndex;
@property (nonatomic, strong) NSString *mainStep;
@property (nonatomic, strong) NSString *secondStep;
@property (nonatomic, strong) NSString *secondStepPlaceholder;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, assign) PairingStepType stepType;
@property (nonatomic, strong) NSArray *inputsArray;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) DeviceProductCatalog *productCatalog;
@property (nonatomic, assign) BOOL success;
/* InstructionTitle and InstructionText are only used for 
   stepType == PairingStepPostPairInstructions */
@property (nonatomic, strong) NSString *instructionTitle;
@property (nonatomic, strong) NSString *instructionText;

// Currently used only for Water heater, but it should be specified
// for all IPCD devices
@property (nonatomic, strong) NSString *errorMessage;

@end
