//
//  CareBehaviorModel.m
//  i2app
//
//  Created by Arcus Team on 2/4/16.
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
#import "CareBehaviorModel.h"
#import "CareBehaviorEnums.h"

@implementation CareBehaviorModel

- (instancetype)initWithTemplate:(CareBehaviorTemplateModel *)template {
    if (self = [super init]) {
        self.name = template.name;
        self.type = template.type;
        self.behaviorProperties = [NSMutableDictionary dictionary];
        self.enabled = YES;
        self.participatingDevices = [NSArray array];
        self.timeWindows = [NSArray array];
        self.lastActivated = nil;
        self.lastFired = nil;
        self.templateId = template.templateIdentifier;
        if (template.type == CareBehaviorTypeOpen) {//This is ugly, done because open behaviors require durations but our UI design has no duration input for the door opened unexpectedly duration
            self.behaviorProperties[kCareBehaviorPropertyDurationSecs] = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

- (instancetype)copy {
    CareBehaviorModel *copyModel = [[CareBehaviorModel alloc] init];
    copyModel.name = [self.name copy];
    copyModel.type = self.type;
    copyModel.behaviorProperties = [[NSMutableDictionary alloc] initWithDictionary:self.behaviorProperties copyItems:YES];
    copyModel.enabled = self.enabled;
    copyModel.participatingDevices = [[NSArray alloc] initWithArray:self.participatingDevices copyItems:YES];
    copyModel.availableDevices = [[NSArray alloc] initWithArray:self.availableDevices copyItems:YES];
    copyModel.timeWindows = [[NSArray alloc] initWithArray:self.timeWindows copyItems:YES];
    copyModel.lastActivated = [self.lastActivated copy];
    copyModel.lastFired = [self.lastFired copy];
    copyModel.templateId = [self.templateId copy];
    copyModel.identifier = [self.identifier copy];
    return copyModel;
}

@end
