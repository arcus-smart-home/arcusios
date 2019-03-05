 //
//  SegmentModelsBuilder.m
//  i2app
//
//  Created by Arcus Team on 8/24/15.
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
#import "SegmentModelsBuilder.h"
#import "SecuritySubsystemAlertController.h"
#import "SafetySubsystemAlertController.h"
#import "CareSubsystemController.h"

#define kEmptySegmentPerCentage 1.0/100.0

@implementation SegmentModelsBuilder

+ (NSArray *)ringSegmentsDisArmMode {
    return @[@[@1,[[UIColor whiteColor] colorWithAlphaComponent:0.4f]]];
}

+ (NSArray *)ringSegmentsArmingMode {
    int numberOfSecurityDevices = [[SubsystemsController sharedInstance].securityController numberOfDevicesForMode];
    
    if (numberOfSecurityDevices == 0 || numberOfSecurityDevices == 1) {
        return [SegmentModelsBuilder ringSegmentsDisArmMode];
    }
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    for (int index = 0; index < numberOfSecurityDevices ; index++) {
        float segMentPercentage = (1.0/numberOfSecurityDevices) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage],
                                   [[UIColor whiteColor] colorWithAlphaComponent:0.2f]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage],
                                   [UIColor clearColor]]];
    }
    
    return segmentModels;
}


+ (NSArray *)ringSegMentsArmedMode {
    int numberOfSecurityDevices = [[SubsystemsController sharedInstance].securityController numberOfDevicesForMode];
    
    if (numberOfSecurityDevices == 0) {
        return @[@[@1,[UIColor whiteColor]]];
    }
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    NSArray *red = [SegmentModelsBuilder redSegments];
    NSArray *grey = [SegmentModelsBuilder greySegments];
    NSArray *white = [SegmentModelsBuilder whiteSegments];
    
    [segmentModels addObjectsFromArray:red];
    [segmentModels addObjectsFromArray:grey];
    [segmentModels addObjectsFromArray:white];
    
    return segmentModels;
}

+ (NSArray *)redSegments {
    int totalSegments = [[SubsystemsController sharedInstance].securityController totalNumberOfSegments];
    int numberOfRedSegment = [[SubsystemsController sharedInstance].securityController numberOfRedSegments];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    UIColor *pinkColor = pinkAlertColor;

    if (numberOfRedSegment == 1 && totalSegments ==1) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0], pinkColor]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfRedSegment ; index++) {
        float segMentPercentage = (1.0/totalSegments) - kEmptySegmentPerCentage;
       
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage],pinkColor]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage],
                                   [UIColor clearColor]]];
    }
    
    return segmentModels;
}

+ (NSArray *)greySegments {
    int totalSegments = [[SubsystemsController sharedInstance].securityController totalNumberOfSegments];
    int numberOfGreySegments = [[SubsystemsController sharedInstance].securityController numberOfGreySegments];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    if (numberOfGreySegments == 1 && totalSegments == 1) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0],
                                   [[UIColor whiteColor] colorWithAlphaComponent:0.2f]]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfGreySegments ; index++) {
        float segMentPercentage = (1.0/totalSegments) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage],
                                   [[UIColor whiteColor] colorWithAlphaComponent:0.2f]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage],
                                   [UIColor clearColor]]];
    }
    return segmentModels;
}

+ (NSArray *)whiteSegments {
    int totalSegments = [[SubsystemsController sharedInstance].securityController totalNumberOfSegments];
    int numberOfWhiteSegments = [[SubsystemsController sharedInstance].securityController numberOfWhiteSegments];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    if (numberOfWhiteSegments == 1 && totalSegments == 1) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0],
                                   [UIColor whiteColor],
                                   [NSNumber numberWithBool:YES]]];
        return segmentModels;
    }
                                    
    for (int index = 0; index < numberOfWhiteSegments ; index++) {
        float segMentPercentage = (1.0/totalSegments) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage],
                                   [UIColor whiteColor],
                                   [NSNumber numberWithBool:YES]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage],
                                   [UIColor clearColor]]];
    }
    return segmentModels;
}

+ (NSArray *)ringSegMentsSafetyDevices {
    
    int numberOfSecurityDevices = [(id<AlarmSubsystemProtocol>)[SubsystemsController sharedInstance].safetyController numberOfDevices];
    
    if (numberOfSecurityDevices == 0) {
        return @[@[@1,[UIColor whiteColor]]];
    }
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    [segmentModels addObjectsFromArray:[SegmentModelsBuilder segmentsForOfflineSafetyDevices]];
    [segmentModels addObjectsFromArray:[SegmentModelsBuilder segmentsForOnlineSafetyDevices]];
    
    return segmentModels;
}

+ (NSArray *)segmentsForOfflineSafetyDevices {
    int numberOfSafetyDevices = [(id<AlarmSubsystemProtocol>)[SubsystemsController sharedInstance].safetyController numberOfDevices];
    int numberOfflineDevices = [[SubsystemsController sharedInstance].safetyController numberOfOfflineDevices];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    UIColor *pinkColor = pinkAlertColor;

    if (numberOfSafetyDevices == 1 && numberOfflineDevices == 1 ) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0], pinkColor]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfflineDevices ; index++) {
        float segMentPercentage = (1.0/numberOfSafetyDevices) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage],pinkColor]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage], [UIColor clearColor]]];
    }
    
    return segmentModels;
}

+ (NSArray *)segmentsForOnlineSafetyDevices {
    int numberOfSafetyDevices = [(id<AlarmSubsystemProtocol>)[SubsystemsController sharedInstance].safetyController numberOfDevices];
    int numberOfOnlineDevices = [(id<AlarmSubsystemProtocol>)[SubsystemsController sharedInstance].safetyController numberOfOnlineDevices];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    if (numberOfSafetyDevices == 1 && numberOfOnlineDevices == 1 ) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0], [UIColor whiteColor], [NSNumber numberWithBool:YES]]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfOnlineDevices ; index++) {
        float segMentPercentage = (1.0/numberOfSafetyDevices) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage], [UIColor whiteColor], [NSNumber numberWithBool:YES]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage], [UIColor clearColor]]];
    }
    return segmentModels;
}


+ (NSArray *)ringSegmentsCareDevices {
    NSInteger numberOfCareBehaviors = [[SubsystemsController sharedInstance].careController numberOfBehaviors];
    
    if (numberOfCareBehaviors == 0) {
        return @[@[@1,[[UIColor whiteColor] colorWithAlphaComponent:0.2f]]];
    }
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    [segmentModels addObjectsFromArray:[SegmentModelsBuilder segmentsForActiveCareBehaviors]];
    [segmentModels addObjectsFromArray:[SegmentModelsBuilder segmentsForDisabledCareBehaviors]];
    
    return segmentModels;
}

+ (NSArray *)segmentsForActiveCareBehaviors {
    NSInteger numberOfCareBehaviors = [[SubsystemsController sharedInstance].careController numberOfBehaviors];
    NSInteger numberOfActiveBehaviors = [[SubsystemsController sharedInstance].careController numberOfActiveBehaviors];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    if (numberOfCareBehaviors == 1 && numberOfActiveBehaviors == 1 ) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0], [UIColor whiteColor], [NSNumber numberWithBool:YES]]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfActiveBehaviors ; index++) {
        float segMentPercentage = (1.0/numberOfCareBehaviors) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage], [UIColor whiteColor], [NSNumber numberWithBool:NO]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage], [UIColor clearColor]]];
    }
    return segmentModels;
}

+ (NSArray *)segmentsForDisabledCareBehaviors {
    NSInteger numberOfCareBehaviors = [[SubsystemsController sharedInstance].careController numberOfBehaviors];
    NSInteger numberOfDisabledBehaviors = numberOfCareBehaviors - [[SubsystemsController sharedInstance].careController numberOfActiveBehaviors];
    
    NSMutableArray *segmentModels = [NSMutableArray array];
    
    if (numberOfCareBehaviors == 1 && numberOfDisabledBehaviors == 1 ) {
        [segmentModels addObject:@[[NSNumber numberWithFloat:1.0], [[UIColor whiteColor] colorWithAlphaComponent:0.4f], [NSNumber numberWithBool:YES]]];
        return segmentModels;
    }
    
    for (int index = 0; index < numberOfDisabledBehaviors ; index++) {
        float segMentPercentage = (1.0/numberOfCareBehaviors) - kEmptySegmentPerCentage;
        [segmentModels addObject:@[[NSNumber numberWithFloat:segMentPercentage], [[UIColor whiteColor] colorWithAlphaComponent:0.4f], [NSNumber numberWithBool:NO]]];
        [segmentModels addObject:@[[NSNumber numberWithFloat:kEmptySegmentPerCentage], [UIColor clearColor]]];
    }
    return segmentModels;
}

@end
