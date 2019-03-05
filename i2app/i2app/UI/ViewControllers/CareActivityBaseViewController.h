//
//  CareActivityBaseViewController.h
//  i2app
//
//  Created by Arcus Team on 2/8/16.
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
#import "CareTabRootViewController.h"
#import "CareActivityManager.h"

@class CareActivitySection;
@class PopupSelectionDayView;
@class PopupSelectionWindow;

@interface CareActivityBaseViewController : CareTabRootViewController <CareActivityManagerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *dateButton;
@property (nonatomic, weak) IBOutlet UIButton *fullScreenButton;
@property (nonatomic, strong) PopupSelectionDayView *daySelectionView;
@property (nonatomic, strong) PopupSelectionWindow *daySelectionWindow;

@property (nonatomic, strong) CareActivityManager *activityManager;
@property (nonatomic, strong) CareActivitySection *careActivitySection;
@property (nonatomic, strong) NSArray <CareActivityUnit *> *careActivityUnits;
@property (nonatomic, strong) NSArray *careDevicesArray;
@property (nonatomic, strong) NSArray *filteredDevices;
@property (nonatomic, strong) NSDate *dateFilter;

- (void)configureDateButton;
- (void)setDateButtonText:(NSString *)string;
- (void)fetchActivityListData:(void (^)(BOOL reload))completion;
- (void)updateCareDevices:(NSArray *)careDevices;
- (void)reloadData;
- (void)reloadUserInterface;
- (void)showDateSelectionPopUp;
- (void)moveCollectionViewToEndPosition:(UICollectionView *)collectionView
                               endIndex:(NSInteger)index;
- (NSInteger)indexOfUnitForCurrentTime;

- (IBAction)dateButtonPressed:(id)sender;

@end
