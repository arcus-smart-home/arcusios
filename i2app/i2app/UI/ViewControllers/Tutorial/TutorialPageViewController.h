//
//  TutorialPageViewController.h
//  i2app
//
//  Created by Arcus Team on 4/25/16.
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

/// Note that the order of this enum must match the indexes of the TutorialListViewController
typedef NS_ENUM(unsigned int, TuturialType) {
    TuturialTypeSecurity = 0,
    TuturialTypeIntro,
    TuturialTypeClimate,
    TuturialTypeRules,
    TuturialTypeScenes,
    TuturialTypeChoosePlaces,
    TuturialTypeHistory
};

@interface TutorialPageViewController : UIViewController

@property (assign, atomic) NSInteger pageIndex;

@property (atomic, assign) TuturialType tutorialType;

@property (weak, nonatomic) NSString *instructionsText;
@property (weak, nonatomic) NSString *titleText;
@property (weak, nonatomic) NSString *imageName;
@property (atomic, assign) BOOL lastPageViewController;
@property (atomic, assign) BOOL shouldHideShowAgain;

+ (TutorialPageViewController *)create;

@end
