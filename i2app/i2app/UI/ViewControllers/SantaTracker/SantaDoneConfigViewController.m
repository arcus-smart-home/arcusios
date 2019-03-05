//
//  SantaDoneConfigViewController.m
//  i2app
//
//  Created by Arcus Team on 11/3/15.
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
#import "SantaDoneConfigViewController.h"
#import "SantaTracker.h"

@interface SantaDoneConfigViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation SantaDoneConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithCloseButtonAndTitle:@"Santa Tracker™"];
    
    [self.titleLabel styleSet:@"Check back on Christmas Day to see if you snapped a photo of Santa!" andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO]];
    [self.doneButton styleSet:@"Done" andButtonType:FontDataTypeButtonLight upperCase:YES];
    
    [[SantaTracker shareInstance] setStatus:SantaTrackerStatusConfigured];
    [[SantaTracker shareInstance] save];
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

+ (SantaDoneConfigViewController *)create {
    SantaDoneConfigViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (IBAction)onClickDone:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
