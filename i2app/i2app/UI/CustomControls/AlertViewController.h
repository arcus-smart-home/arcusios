//
//  AlertViewController.h
//  i2app
//
//  Created by Arcus Team on 4/23/15.
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

@interface AlertViewController : UIViewController

@property(nonatomic, strong) NSString *titleString;
@property(nonatomic, strong) NSString *messageString;
@property (strong, nonatomic) AlertViewController *alertViewController;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property(nonatomic) BOOL isUsing;

- (void)slideIn;
- (void)slideInWhite;
- (IBAction) slideOut;

@end

@interface TwoButtonAlertViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIView *hubActionSheetView;

@property (strong, nonatomic) NSString *yesButtonTitle;
@property (strong, nonatomic) NSString *noButtonTitle;
@property (assign, nonatomic) FontDataType yesButtonStyle;
@property (assign, nonatomic) FontDataType noButtonStyle;

@property (strong, nonatomic) TwoButtonAlertViewController *alertViewController;
@property(nonatomic) BOOL isUsing;
@property (weak, nonatomic) IBOutlet UILabel *mainText;
@property (weak, nonatomic) IBOutlet UILabel *subText;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;


- (void)slideIn;
- (void)slideInWhite;
- (void)slideOut;
@end
