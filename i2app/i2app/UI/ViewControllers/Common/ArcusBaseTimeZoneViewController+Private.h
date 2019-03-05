//
//  ArcusBaseTimeZoneViewController+Private.h
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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

#import "ArcusBaseTimeZoneViewController.h"
#import "OrderedDictionary.h"

@interface ArcusBaseTimeZoneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) OrderedDictionary *timeZones;

#pragma mark - To be implemented by subclasses
- (IBAction)onClickTimeZone:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (NSString *)defaultTimeZoneValue;
- (void)userChoseTimezoneWithName:(NSString *)timeZone timeZoneID:(NSString *)tzID offset:(NSNumber *)offset usesDST:(BOOL)usesDST;

@end
