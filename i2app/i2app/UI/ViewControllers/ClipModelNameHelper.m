//
//  ClipModelNameHelper.m
//  i2app
//
//  Created by Arcus Team on 8/23/17.
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
#import "ClipModelNameHelper.h"
#import "RecordingCapability.h"

#import "RuleCapability.h"


@implementation ClipModelNameHelper

/**
  Oldie but a goodie:
  create the clip name using the RecordingCapability, Person, and Current Place and a NSScanner
  Prepend `Triggered By: ` to the rule name
 */
+ (NSString *)clipNameFromRecordingModel:(RecordingModel *)recordingModel {
  NSString *personId = [RecordingCapability getPersonidFromModel:recordingModel];
  if ([personId isEqual:[NSNull null]]) {
    // Triggered by scene
    return @"Triggered By: Manual Recording";
  }
  else if (personId.length > 0 && [personId characterAtIndex:0] == '0') {
    personId = [personId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    unsigned ruleId = 0;
    NSScanner *scanner = [NSScanner scannerWithString:personId];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&ruleId];
    if (ruleId > 0) {
      NSString *ruleAddress = [NSString stringWithFormat:@"%@:%@:%@.%d", Constants.kService, [RuleCapability namespace], [[CorneaHolder shared] settings].currentPlace.modelId, ruleId];
      if (ruleAddress.length > 0) {
        RuleModel *ruleModel = (RuleModel *)[[[CorneaHolder shared] modelCache] fetchModel:ruleAddress];
        if (ruleModel) {
          NSString *ruleName = [RuleCapability getNameFromModel:ruleModel];
          return [NSString stringWithFormat:@"Triggered By: %@", ruleName];
        }
      }
    }
  }
  return @"Triggered By: Manual Recording";
}

@end
