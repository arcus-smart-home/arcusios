//
//  SmartStreetValidationViewControllerViewController.h
//  i2app
//
//  Created by Arcus Team on 7/7/15.
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

typedef enum {
    SmartstreetValidOperationUseThis = 1,
    SmartstreetValidOperationUseUserTyped,
    SmartstreetValidOperationEditUserTyped,
} SmartstreetValidOperation;

typedef void(^vaildCompletedBlock)(BOOL isValid);
typedef void(^smartyStreetsCompletedBlock)(SmartstreetValidOperation operation, NSDictionary *data);

@interface SmartStreetValidationViewController : UIViewController

// New method that delegates to PlaceService for address verification
+ (void)validateStreet:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(NSString*)zip addressToDisplayOnError:(NSString *)addressToDisplay owner:(UIViewController *)owner completeHandle:(vaildCompletedBlock)completeBlock;

// Legacy implementation that delegates to SmartyStreets service for address verification
+ (void)smartyStreetsValidateStreet:(NSString *)street city:(NSString *)city state:(NSString *)state addressToDisplayOnError:(NSString *)addressToDisplay owner:(UIViewController *)owner completeHandle:(smartyStreetsCompletedBlock)completeBlock;

@end
