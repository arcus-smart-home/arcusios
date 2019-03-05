//
//  UIViewController+DisplayError.m
//  i2app
//
//  Created by Arcus Team on 4/8/15.
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
#import "UIViewController+DisplayError.h"
#import "AlertViewController.h"
#import "PopupMessageViewController.h"
#import <i2app-Swift.h>

@implementation UIViewController (DisplayError)

@dynamic genericErrorMessage;

TwoButtonAlertViewController *_twoButtonAlertViewController;
AlertViewController *_alertViewController;

- (NSString *)genericErrorMessage {
    return NSLocalizedString(@"Generic Error Message", nil);
}

- (void)displayGenericErrorMessage {
    [self displayErrorMessage:NSLocalizedStringFromTable(self.genericErrorMessage, @"ErrorMessages", nil) withTitle:NSLocalizedStringFromTable(@"Hmmm, Something’s Wrong", @"ErrorMessages", nil)];
}

- (void)displayGenericErrorMessageWithError:(NSError *)error {
#ifdef DEBUG
    if (error.localizedDescription.length > 0) {
        [self displayErrorMessage:error.localizedDescription];
    }
    else {
        [self displayGenericErrorMessage];
    }
#else
    [self displayGenericErrorMessage];
#endif
}

- (void)displayGenericErrorMessageWithMessage:(NSString *)errorMessage;
 {
#ifdef DEBUG
     if (errorMessage.length > 0) {
         [self displayErrorMessage:errorMessage];
     }
     else {
         [self displayGenericErrorMessage];
     }
#else
     [self displayGenericErrorMessage];
#endif
}

//// Both errorMessage and title here are keys, so we need to lookup in the Localizable.string
//// for the value that needs to be displayed
- (void)displayErrorMessage:(NSString *)errorMessageKey {
    [self displayErrorMessage:errorMessageKey withTitle:NSLocalizedStringFromTable(@"Oops!", @"ErrorMessages", nil)];
}

- (void)displayErrorMessage:(NSString *)errorMessageKey withTitle:(NSString *)titleKey {
    @synchronized(self) {
        NSAssert([NSThread isMainThread], @"displayErrorMessage needs to be executed on the main thread");
        if (_alertViewController) {
            if (_alertViewController.isUsing) {
                [_alertViewController.view removeFromSuperview];
            }
        }
        else {
            _alertViewController = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
        }
        _alertViewController.titleString = NSLocalizedString(titleKey, nil);
        _alertViewController.messageString = NSLocalizedString(errorMessageKey, nil);
        [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_alertViewController.view];
        [_alertViewController slideIn];
    }
}

- (void)displayErrorMessageWhite:(NSString *)errorMessageKey withTitle:(NSString *)titleKey {
  @synchronized(self) {
    NSAssert([NSThread isMainThread], @"displayErrorMessage needs to be executed on the main thread");
    if (_alertViewController) {
      if (_alertViewController.isUsing) {
        [_alertViewController.view removeFromSuperview];
      }
    }
    else {
      _alertViewController = [[AlertViewController alloc] initWithNibName:@"AlertViewController" bundle:nil];
    }
    _alertViewController.titleString = NSLocalizedString(titleKey, nil);
    _alertViewController.messageString = NSLocalizedString(errorMessageKey, nil);
    [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_alertViewController.view];
    [_alertViewController slideInWhite];
  }
}

- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2 {
    [self displayMessage:title subtitle:[subtitle uppercaseString] buttonOne:button1 buttonTwo:button2 withTarget:nil withButtonOneSelector:nil andButtonTwoSelector:nil];
}


- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2 withTarget:(id)target withButtonOneSelector:(SEL)buttonOneTapped andButtonTwoSelector:(SEL)buttonTwoTapped {
    [self displayMessage:title subtitle:[subtitle uppercaseString] backgroundColor:[UIColor whiteColor] buttonOne:button1 buttonTwo:button2 buttoneOneStyle:FontDataTypeButtonDark buttonTwoStyle:FontDataTypeButtonDark withTarget:self withButtonOneSelector:buttonOneTapped andButtonTwoSelector:buttonTwoTapped];
}

- (void)displayMessage:(NSString *)title subtitle:(NSString *)subtitle backgroundColor:(UIColor *)bgColor buttonOne:(NSString *)button1 buttonTwo:(NSString *)button2  buttoneOneStyle:(FontDataType)buttonOneStyle buttonTwoStyle:(FontDataType)buttonTwoStyle withTarget:(id)target withButtonOneSelector:(SEL)buttonOneTapped andButtonTwoSelector:(SEL)buttonTwoTapped {
    @synchronized(self) {
        NSAssert([NSThread isMainThread], @"displayMessage needs to be executed on the main thread");
        self.navigationController.view.userInteractionEnabled = NO;
        
        if (_twoButtonAlertViewController) {
            if (_twoButtonAlertViewController.isUsing) {
                [_twoButtonAlertViewController.view removeFromSuperview];
            }
            _twoButtonAlertViewController = nil;
        }
        
        _twoButtonAlertViewController = [[TwoButtonAlertViewController alloc] initWithNibName:@"TwoButtonAlertViewController" bundle:nil];
        
        _twoButtonAlertViewController.yesButtonTitle = button1;
        _twoButtonAlertViewController.yesButtonStyle = buttonOneStyle;
        _twoButtonAlertViewController.noButtonTitle = button2;
        _twoButtonAlertViewController.noButtonStyle = buttonTwoStyle;
        [_twoButtonAlertViewController.noButton styleSet:button2 andButtonType:buttonTwoStyle];
        [((AppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:_twoButtonAlertViewController.view];
        _twoButtonAlertViewController.mainText.attributedText = [FontData getString:[NSLocalizedString(title, nil) uppercaseString] withFont:FontDataTypeDeviceKeyfobSettingSheetTitle];
        _twoButtonAlertViewController.subText.attributedText = [FontData getString:NSLocalizedString(subtitle, nil) withFont:FontDataType_MediumMedium_12_BlackAlpha_NoSpace];

        [_twoButtonAlertViewController.yesButton addTarget:target action:buttonOneTapped forControlEvents:UIControlEventTouchUpInside];
        [_twoButtonAlertViewController.noButton addTarget:target action:buttonTwoTapped forControlEvents:UIControlEventTouchUpInside];
        [_twoButtonAlertViewController slideIn];
        _twoButtonAlertViewController.hubActionSheetView.backgroundColor = bgColor;
    }
}

- (void)slideOutTwoButtonAlert {
    @synchronized(self) {
        self.navigationController.view.userInteractionEnabled = YES;
        NSAssert([NSThread isMainThread], @"displayMessage needs to be executed on the main thread");
        if (_twoButtonAlertViewController) {
            if (_twoButtonAlertViewController.isUsing) {
                [_twoButtonAlertViewController slideOut];
            }
        }
    }
}

- (void)popupMessageWindow:(NSString *)title subtitle:(NSString *)subtitle {
    [PopupMessageViewController popupWindow:self title:title message:subtitle];
}
- (void)popupErrorWindow:(NSString *)title subtitle:(NSString *)subtitle {
    [PopupMessageViewController popupErrorWindow:self.view title:title message:subtitle];
}

@end
