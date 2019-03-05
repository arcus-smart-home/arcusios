//
//  BaseTextViewController.m
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

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216+44;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162+44;

#import "BaseTextViewController.h"
#import "AccountTextField.h"
#import "UIView+Blur.h"
#import "UIView+Subviews.h"
#import "SmartStreetTextField.h"
#import <i2app-Swift.h>

@interface BaseTextViewController ()

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) UIToolbar *toolbar;


- (void)initializeTextFields;

@end


@implementation BaseTextViewController
CGFloat animatedDistance;

- (NSArray *)getAllSubviews:(UIView *)view {
    NSMutableArray *_allSubviews = [[NSMutableArray alloc] init];
    for (UIView *item in view.subviews) {
        [_allSubviews addObject:item];
        if ([item isMemberOfClass:[UIView class]] || [item isMemberOfClass:[UIScrollView class]]) {
            [_allSubviews addObjectsFromArray:[self getAllSubviews:item]];
        }
    }
    return _allSubviews;
}

- (void)configureTextFieldStyle:(TextFieldStyleType)style {
    
    NSArray *views = [self getAllSubviews:self.view];
    
    switch (style) {
        case TextFieldStyleTypeWhite: {
            for (AccountTextField *textField in views) {
                if (![textField isKindOfClass:[AccountTextField class]]) {
                    continue;
                }
                textField.textColor = [UIColor whiteColor];
                textField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
                textField.floatingLabelActiveTextColor = [UIColor whiteColor];
                textField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
                textField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
                textField.userInteractionEnabled = NO;
                
                FontDataType fontType = FontDataTypeSettingsTextField;
                FontDataType placeholderType = FontDataTypeSettingsTextFieldPlaceholder;
                
                [textField setupType:textField.accountFieldType
                            fontType:fontType
                 placeholderFontType:placeholderType];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setBackgroundColorToParentColor];
    
    [self initializeTextFields];
    [self initializeTabBar];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //add white overlay
    [self addWhiteOverlay:BackgroupOverlayLightLevel];
}

- (void)viewTapped {
    [self.view endEditing:YES];
}

#pragma mark - UITextField Initialization
- (void)initializeTextFields {
    // Extract the UITextFields only
    NSMutableArray *textFields = [[NSMutableArray alloc] initWithCapacity:self.view.subviews.count];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:self.view.subviews.count];
    
    UIViewTreeBlock block = ^void (UIView *view) {
        if ([view isKindOfClass:[AccountTextField class]]) {
            [textFields addObject:view];
        } else if ([view isKindOfClass:[UIButton class]]) {
            [buttons addObject:view];
        }
    };
    [UIView executeBlock:block forViewAndSubviewTree:self.view];
    
    _textFields = textFields.copy;
    _buttons = buttons.copy;
    
    for (AccountTextField *textField in _textFields) {
        textField.delegate = self;
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (AccountTextField *textField in _textFields) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField resignFirstResponder];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.inputAccessoryView = self.toolbar;

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    int tag = ((int)textField.tag) + 1;
    NSArray *allSubviews = [self.view allSubviews];
    for (UIView *view in allSubviews) {
        if (((UITextField *)view).tag == tag) {
            if ([view isKindOfClass:[UITextField class]]) {
                [((UITextField *)view) becomeFirstResponder];
                return NO;
            }
            else if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        if ((textFieldRect.origin.y + textFieldRect.size.height + 10.0f) < (viewRect.origin.y + viewRect.size.height - PORTRAIT_KEYBOARD_HEIGHT)) {
            return;
        }
    }
    else {
        if ((textFieldRect.origin.y+textFieldRect.size.height+10.0f)<(viewRect.origin.y+viewRect.size.height-LANDSCAPE_KEYBOARD_HEIGHT)) {
            return;
        }
    }
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    if ([textField isKindOfClass:[SmartStreetTextField class]]) {
        animatedDistance += 110;
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance - 30;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield {
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 64;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - Moving to next View Controller
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier caseInsensitiveCompare:@"GoToNextScreenSegue"] == NSOrderedSame) {
        return [self validateTextFields];
    }
    return YES;
}

#pragma mark - Data Validation
- (BOOL)validateTextFields {
    // We need to validate the entered data here
    [self viewTapped];
    
    NSString *errorMessageKey;
    if (![self isDataValid:&errorMessageKey]) {
        DDLogWarn(@"Account creation: invalid data: %@", errorMessageKey);
        return NO;
    }
    else {
        [self saveRegistrationContext];
    }
    return YES;
}

- (BOOL)isDataValid:(NSString **)errorMessageKey {
  [self checkIsDataValid:errorMessageKey];
  return [self checkIsDataValid:errorMessageKey];
}

- (BOOL)checkIsDataValid:(NSString **)errorMessageKey {
  BOOL isValid = YES;
  for (AccountTextField *textField in self.textFields) {
    NSString *textFieldErrorMessage = nil;
    if (![textField isValidEntry:&textFieldErrorMessage]) {
      [self shakeAnimation:textField];
      textField.animateEvenIfNotFirstResponder = YES;
      [textField showFloatingLabel:YES];
      textField.floatingLabel.attributedText = [FontData getString:[textFieldErrorMessage uppercaseString] withFont:FontDataTypeAccountTextFieldFloatingLabelAlert];
      [textField.floatingLabel sizeToFit];
      textField.separatorView.backgroundColor = pinkAlertColor;
      if (textFieldErrorMessage != nil ) {
        *errorMessageKey = textFieldErrorMessage;
      }
      isValid = NO;
    }
  }

  for (UIButton *button in self.buttons) {
    if ([button.titleLabel.text isEqualToString:[NSLocalizedString(@"State", nil) uppercaseString]] || [button.titleLabel.text isEqualToString:[@"MM"uppercaseString]] || [button.titleLabel.text isEqualToString:[@"YY" uppercaseString]]) {
      [self shakeAnimation:button];
      if ([button.titleLabel.text isEqualToString:[NSLocalizedString(@"State", nil) uppercaseString]]) {
        button.titleLabel.textColor = pinkAlertColor;
        button.imageView.image = [button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button.imageView setTintColor:pinkAlertColor];
      }
      else {
        [button setTitleColor:pinkAlertColor forState:UIControlStateNormal];
      }
    }
  }
  [self.view layoutIfNeeded];
  [self.view setNeedsDisplay];

  return isValid;
}

- (void)shakeAnimation:(UIView *)view {
    const int reset = 5;
    const int maxShakes = 4;

    //pass these as variables instead of statics or class variables if shaking two controls simultaneously
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09 - (shakes * .01) // reduce duration every shake from .09 to .04
                          delay:0.01f//edge wait delay
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseOut
                     animations:^{view.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion:^(BOOL finished) {
                         if (shakes < maxShakes) {
                             shakes++;
                             
                             //throttle down movement
                             if (translate > 0)
                                 translate--;
                             
                             //change direction
                             translate *= -1;
                             [self shakeAnimation:view];
                         }
                         else {
                             view.transform = CGAffineTransformIdentity;
                             shakes = 0;//ready for next time
                             translate = reset;//ready for next time
                             return;
                         }
                     }];
}

#pragma mark - Phone Number Masking

- (BOOL)textField:(AccountTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.accountFieldType == AccountTextFieldTypePhone) {
        if ([textField.text rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]].location == NSNotFound) {
            // Format is xxx-xxx-xxxx
            if (range.location == 12) {
                return NO;
            }
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            if (range.length == 0 &&
                (range.location == 3 || range.location == 7)) {
                textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
                return NO;
            }
            if (range.length == 1 &&
                (range.location == 4 || range.location == 8))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        else {
            // Format is (xxx) xxx-xxxx
            if (range.location == 14) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - Save Registration Context
- (void)saveRegistrationContext {
    [NSException raise:NSInternalInconsistencyException
                format:@"%@ must be overriden in derived class", NSStringFromSelector(_cmd)];
}


#pragma mark - Keyboard TabBar
- (void)initializeTabBar {
    self.toolbar = [self keyboardToolbar:@selector(previousButtonTapped) nextSelector:@selector(nextButtonTapped) doneSelector:@selector(viewTapped)];
}

- (void)previousButtonTapped {
    UITextField *currentTextField = nil;
    BOOL previousTextFieldFound = NO;
    for (UITextField *textField in _textFields) {
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            currentTextField = textField;
            break;
        }
    }
    
    if (currentTextField.tag-1 <= 0) {
        [currentTextField resignFirstResponder];
    }
    else {
        for (UITextField *textField in _textFields) {
            if ([textField isKindOfClass:[UITextField class]]) {
                if (textField.tag == currentTextField.tag-1) {
                    previousTextFieldFound = YES;
                    [textField becomeFirstResponder];
                    break;
                }
            }
        }
        if (!previousTextFieldFound) {
            [currentTextField resignFirstResponder];
        }
    }
}

- (void)nextButtonTapped {
    UITextField *currentTextField = nil;
    BOOL nextTextFieldFound = NO;
    for (UITextField *textField in _textFields) {
        if ([textField isKindOfClass:[UITextField class]] && [textField isFirstResponder]) {
            currentTextField = textField;
            break;
        }
    }
    
    for (UITextField *textField in _textFields) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if (textField.tag == currentTextField.tag+1) {
                nextTextFieldFound = YES;
                [textField becomeFirstResponder];
                break;
            }
        }
    }
    if (!nextTextFieldFound) {
        [currentTextField resignFirstResponder];
    }
}


- (UIButton *)getNextButton {
    NSArray *subviews = self.view.subviews;
    UIButton *nextButton;
    for (UIView *view in subviews) {
        nextButton = [self getNextButtonFromSubviews:view.subviews];
        if (nextButton) {
            return nextButton;
        }
    }
    return nil;
}

- (UIButton *)getNextButtonFromSubviews:(NSArray *)subviews {
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if ([[((UIButton *)view) titleForState:UIControlStateNormal] caseInsensitiveCompare:NSLocalizedString(@"next", nil)] == NSOrderedSame) {
                return (UIButton *)view;
            }
        }
    }
    return nil;
}

- (void)goToNextControl:(NSInteger)tagOfCurrentControl {
    NSInteger tag = ++tagOfCurrentControl;
    NSArray *allSubviews = [self.view allSubviews];
    for (UIView *view in allSubviews) {
        if (((UITextField *)view).tag == tag) {
            if ([view isKindOfClass:[UITextField class]]) {
                [((UITextField *)view) becomeFirstResponder];
                return;
            }
            else if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}
@end
