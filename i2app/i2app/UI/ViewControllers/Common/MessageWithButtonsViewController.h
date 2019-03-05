//
//  MessageWithButtonsViewController.h
//  i2app
//
//  Created by Arcus Team on 9/30/15.
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

@class MessageWithButtonsViewController;

@interface MessageWithButtonsControllerModel: NSObject

@property (strong, nonatomic) NSString *controllerTitle;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage *iconImage;

@property (nonatomic) BOOL hasCloseButton;

@property (assign, nonatomic) SEL openSelector;
@property (assign, nonatomic) SEL closeSelector;

@property (strong, nonatomic) NSString *clickableButtonName;
@property (assign, nonatomic) SEL clickableButtonSelector;

@property (strong, nonatomic) NSString *topButtonName;
@property (assign, nonatomic) SEL topButtonSelector;

@property (strong, nonatomic) NSString *secondButtonName;
@property (assign, nonatomic) SEL secondButtonSelector;

@property (assign, nonatomic) BOOL goToDeviceList;

@property (assign, nonatomic) MessageWithButtonsViewController *viewController;

- (void)beginRuning;

@end

@protocol MessageWithButtonsControllerCallback

- (void)refresh;

@end

@interface MessageWithButtonsViewController : UIViewController <MessageWithButtonsControllerCallback>

+ (MessageWithButtonsViewController *)create:(MessageWithButtonsControllerModel *)controlModel;

@end


