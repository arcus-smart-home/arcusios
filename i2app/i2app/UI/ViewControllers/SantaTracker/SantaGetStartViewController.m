//
//  SantaGetStartViewController.m
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
#import "SantaGetStartViewController.h"
#import "SantaReindeerLandViewController.h"

@interface SantaGetStartViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *getStatedButton;

@property (nonatomic) BOOL createModel;

@end

@implementation SantaGetStartViewController

+ (SantaGetStartViewController *)create:(BOOL)createModel {
    SantaGetStartViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.createModel = createModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self navBarWithCloseButtonAndTitle:@"Santa Tracker™"];
    
    [_titleLabel styleSet:@"Get the kids and let's prove Santa will stop by on Christmas morning." andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO alpha:NO]];
    
    [_subtitleLabel styleSet:@"This will be more fun with the entire family" andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO alpha:YES]];
    
    [_introLabel styleSet:@"Santa Tracker™ uses virtual \"Santa Sensors\" to prove Santa came to your home. Santa Sensors are not sold at Lowe's. " andFontData:[FontData createFontData:FontTypeMedium size:13 blackColor:NO alpha:YES]];
    
    [_getStatedButton styleSet:@"Let's Get Started" andButtonType:FontDataTypeButtonLight upperCase:YES];
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onClickStated:(id)sender {
    [self.navigationController pushViewController:[SantaReindeerLandViewController create:self.createModel] animated:YES];
}

@end
