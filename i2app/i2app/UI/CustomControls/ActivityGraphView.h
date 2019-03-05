//
//  CareActivityGraphView.h
//  i2app
//
//  Created by Arcus Team on 1/22/16.
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

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ActivityGraphUnitType) {
    ActivityGraphUnitTypeNone            = 0,
    ActivityGraphUnitTypeSolid           = 1 << 0,
    ActivityGraphUnitTypeContinuousStart = 1 << 1,
    ActivityGraphUnitTypeContinuousStop  = 1 << 2,
    ActivityGraphUnitTypeContinuousMid   = 1 << 3,
};

typedef NS_ENUM(NSInteger, ActivityGraphStyleType) {
    ActivityGraphStyleTypeNone,
    ActivityGraphStyleTypeSolid,
    ActivityGraphStyleTypeSolidNoContinuous,
    ActivityGraphStyleTypeEdgeTransparent
};

@protocol ActivityGraphViewUnitProtocol <NSObject>
@required

- (ActivityGraphUnitType)activityGraphUnitTypeWithGraphStyle:(ActivityGraphStyleType)styleType;
- (UIColor *)lineColor;

@end

@interface ActivityGraphView : UIView

/**
 * Array of units to paint in the graph.  Objects in the graph must conform to
 * ActivityGraphViewUnitProtocol.
 **/
@property (nonatomic, strong) NSArray<ActivityGraphViewUnitProtocol> *activityUnits;

/**
 * ActivityGraphViewUnitProtocol conforming objects typically define the type of line that will be
 * displayed for that object.  However, this property specifies the general theme of the graph being 
 * displayed, and can be passed to ActivityGraphViewUnitProtocol conforming objects to allow 
 * customization based on graphStyle.
 **/
@property (nonatomic, assign) ActivityGraphStyleType graphStyle;

@end
