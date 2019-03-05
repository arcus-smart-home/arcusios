//
//  VentExtraStepViewController.m
//  i2app
//
//  Created by Arcus Team on 10/1/15.
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
#import "VentExtraStepViewController.h"

@interface VentExtraStepViewController()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation VentExtraStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackgroundColorToParentColor];
    [self navBarWithBackButtonAndTitle:NSLocalizedString(@"Attention", nil)];
    [_nextButton styleSet:NSLocalizedString(@"next", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    
    self.mainLabel.text = NSLocalizedString(@"Please consult an HVAC professional\n or the device manufacturer for\nbest practices on maintaining\nyour HVAC system.", nil);

}

- (IBAction)nextButtonPressed:(id)sender {
    [super nextButtonPressed:sender];
}
@end
