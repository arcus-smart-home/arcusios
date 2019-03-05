//
//  DeviceTestViewController.m
//  i2app
//
//  Created by Arcus Team on 6/2/15.
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
#import "DeviceTestViewController.h"
#import "UIViewController+AlertBar.h"

@interface DeviceTestViewController ()

@property (weak, nonatomic) IBOutlet UILabel *firstParagraph;
@property (weak, nonatomic) IBOutlet UILabel *secondParagraph;
@property (weak, nonatomic) IBOutlet UIButton *textButton;



@end

@implementation DeviceTestViewController

#pragma mark - Life Cycle
+ (DeviceTestViewController *)create {
    return [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([DeviceTestViewController class])];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = NSLocalizedString(@"TEST", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [self navBarWithBackButtonAndTitle:self.title];
    
    [self.firstParagraph setTextColor:[UIColor whiteColor]];
    [self.firstParagraph setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
    [self.secondParagraph setTextColor:[UIColor whiteColor]];
    [self.secondParagraph setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self popupAlert:@"Message" type:AlertBarTypeLowBattery canClose:YES];
}

#pragma mark - Methods
- (IBAction)onClickTest:(id)sender {
    
}



@end
