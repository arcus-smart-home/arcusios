//
//  DevicePairingFormEntryViewController.m
//  i2app
//
//  Created by Arcus Team on 11/2/15.
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
#import "DevicePairingFormEntryViewController.h"
#import "SettingsTextFieldTableViewCell.h"
#import "PairingStep.h"
#import "IPCDInputModel.h"
#import "UIImageView+WebCache.h"
#import "PopupSelectionButtonsView.h"
#import "DevicePairingWizard.h"

#import "IPCDServiceController.h"
#import "DeviceCapability.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface DevicePairingFormEntryViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IPCDServiceDelegate>

@property (nonatomic, strong) IBOutlet UIView *tutorialVideoBanner;
@property (nonatomic, strong) IBOutlet UIImageView *pairingStepImage;
@property (nonatomic, strong) IBOutlet UIImageView *currentStepIndicator;
@property (nonatomic, strong) IBOutlet UILabel *instructionLabel;
@property (nonatomic, strong) IBOutlet UILabel *instructionDetailLabel;
@property (nonatomic, strong) IBOutlet UITableView *formTableView;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *tutorialVideoBannerHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *pairingStepTopSpacing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *pairingStepHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *currentStepTopSpacing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *currentStepHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *instructionTopSpacing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *instructionHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *instructionDetailTopSpacing;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *instructionDetailHeight;
@property (nonatomic, strong) PopupSelectionWindow *popupWindow;

@property (nonatomic, strong) NSArray *formFieldsArray;
@property (nonatomic, strong) NSArray *ipcdInputModels;
@property (nonatomic, strong) NSDictionary *userEnteredValues;
@property (nonatomic, assign) BOOL pairingStepImageIsLoading;
@property (nonatomic, assign) BOOL nextButtonEnabled;
@property (nonatomic, strong) IPCDServiceController *ipcdServicerController;

@property (nonatomic, strong) NSTimer *waitTimer;

@end

@implementation DevicePairingFormEntryViewController

+ (instancetype)create {
    DevicePairingFormEntryViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

+ (instancetype)createWithDeviceStep:(PairingStep *)step {
    DevicePairingFormEntryViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    [vc setDeviceStep:step];
    return vc;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pairingStepImageIsLoading = NO;
    self.nextButtonEnabled = NO;
    self.tutorialVideoBanner.hidden = YES;
    self.tutorialVideoBannerHeight.constant = 0.0f;
    
    [self configureNavBar];
    [self configureBackground];
    [self configureHeaderView];
    [self configureNextButton];
    [self configureGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceAddEventReceived:) name:kUpdateUIDeviceAddedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        if (self.ipcdServicerController) {
            [self.ipcdServicerController stopPairing];
        }
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI Configuration

- (void)configureNavBar {
    self.navigationItem.title = self.step.title;
    [self navBarWithBackButtonAndTitle:self.navigationItem.title];
}

- (void)configureBackground {
    self.formTableView.backgroundColor = [UIColor clearColor];
    self.formTableView.backgroundView = nil;
    
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
}

- (void)configureHeaderView {
    // Set Image
    if (self.step.imageUrl) {
        if ([self.step.imageUrl containsString:@"http"]) {
            self.pairingStepImageIsLoading = YES;
            [self.pairingStepImage sd_setImageWithURL:[NSURL URLWithString:self.step.imageUrl] completed:^ (UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!image) {
                    self.pairingStepTopSpacing.constant = 0.0f;
                    self.pairingStepHeight.constant = 0.0f;
                }
            }];
        }
        else {
            self.pairingStepImage.image = [UIImage imageNamed:self.step.imageUrl];
        }
    }
    
    // Set Step Number Image
    if (self.step.stepIndex) {
        self.currentStepIndicator.image = [UIImage imageNamed:[NSString stringWithFormat:@"Step%ld", (long)self.step.stepIndex + 1]];
    }
    
    // Set Instruction
    self.instructionLabel.text = self.step.mainStep;
    
    // Set Detail
    self.instructionDetailLabel.text = self.step.secondStep;
    
    [self collapseUnusedHeaderFields];
}

- (void)collapseUnusedHeaderFields {
    if (!self.pairingStepImage.image && !self.pairingStepImageIsLoading) {
        self.pairingStepTopSpacing.constant = 0.0f;
        self.pairingStepHeight.constant = 0.0f;
    }
    
    if (!self.currentStepIndicator.image) {
        self.currentStepTopSpacing.constant = 0.0f;
        self.currentStepHeight.constant = 0.0f;
    }
    
    if (!self.instructionLabel.text) {
        self.instructionTopSpacing.constant = 0.0f;
        self.instructionHeight.constant = 0.0f;
    }
    
    if (!self.instructionDetailLabel.text) {
        self.instructionDetailTopSpacing.constant = 0.0f;
        self.instructionDetailHeight.constant = 0.0f;
    }
}

- (void)configureNextButton {
    [self.nextButton styleSet:@"Next"
                andButtonType:FontDataTypeButtonDark
                    upperCase:YES];
    
}

- (void)configureGesture {
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Setters & Getters

- (NSArray *)ipcdInputModels {
    if (!_ipcdInputModels) {
        NSMutableArray *mutableInputModels = [[NSMutableArray alloc] init];
        for (NSDictionary *inputInfo in self.step.inputsArray) {
            [mutableInputModels addObject:[IPCDInputModel ipcdInputModelForInputInfo:inputInfo]];
        }
        
        _ipcdInputModels = mutableInputModels;
    }
    
    return _ipcdInputModels;
}

- (NSArray *)formFieldsArray {
    if (!_formFieldsArray) {
        NSMutableArray *mutableInputs = [[NSMutableArray alloc] init];
        for (IPCDInputModel *inputModel in self.ipcdInputModels) {
            if (![inputModel.inputType isEqualToString:@"HIDDEN"]) {
                [mutableInputs addObject:inputModel];
                
            }
        }
        _formFieldsArray = [NSArray arrayWithArray:mutableInputs];
    }
    return _formFieldsArray;
}

- (void)setNextButtonEnabled:(BOOL)nextButtonEnabled {
    _nextButtonEnabled = nextButtonEnabled;
    
    self.nextButton.enabled = _nextButtonEnabled;
    if (_nextButtonEnabled) {
        self.nextButton.titleLabel.alpha = 1.0f;
    }
    else {
        self.nextButton.titleLabel.alpha = 0.5f;
    }
}

#pragma mark - IBActions

- (IBAction)textFieldTextDidChange:(id)sender {
    UITextField *textField = (UITextField *)sender;
    if (textField.tag < [self.formFieldsArray count]) {
        IPCDInputModel *inputModel = self.formFieldsArray[textField.tag];
        inputModel.inputValue = textField.text;
    }
    [self setNextButtonEnabled:[self validateInputModels]];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if ([self validateInputModels]) { // Validation here should be unnecessary.
        NSDictionary *attributes = [self attributesForPairingStep];
        if (attributes) {
            self.ipcdServicerController = [[IPCDServiceController alloc] initWithTarget:self.step.target attributes:attributes];
            self.ipcdServicerController.delegate = self;
            [self.ipcdServicerController startPairing];
            
            [self displayPopUpWithTitle:NSLocalizedString(@"Verifying code", nil)
                               subtitle:NSLocalizedString(@"Please be patient while we verify the information above.", nil)
                                isError:NO];
        }
    }
}

- (IBAction)contactSupport:(id)sender {
    // This will need to be addressed if support is added.
//
//    NSString *phNo = @"+18554694747";
//    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
//    
//    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
//        [[UIApplication sharedApplication] openURL:phoneUrl];
//    }
}

#pragma mark - InputModel Validation

- (BOOL)validateInputModels {
    BOOL isValid = YES;
    
    for (IPCDInputModel *inputModel in self.ipcdInputModels) {
        if (inputModel.isRequired) {
            if (inputModel.inputValue.length != inputModel.requiredLength) {
                isValid = NO;
                break;
            }
        }
    }
    
    return isValid;
}

#pragma mark - Attributes Generation

- (NSDictionary *)attributesForPairingStep {
    NSMutableDictionary *mutablePairingSteps = [[NSMutableDictionary alloc] init];
    
    BOOL isGenie = NO;
    
    for (IPCDInputModel *inputModel in self.ipcdInputModels) {
        if (!isGenie) {
            isGenie = [inputModel.inputValue isEqualToString:@"GenieGDOController"];
        }
        
        if (inputModel.inputName && inputModel.inputValue) {
            [mutablePairingSteps setObject:inputModel.inputValue
                                    forKey:inputModel.inputName];
        }
    }
    
    if (isGenie) {
        mutablePairingSteps = [self updateAttributesForGenieGarageDoorController:mutablePairingSteps];
    }
    
    return [NSDictionary dictionaryWithDictionary:mutablePairingSteps];
}

#pragma mark - Genie GarageDoorController Attribute Customization

- (NSMutableDictionary *)updateAttributesForGenieGarageDoorController:(NSDictionary *)attributes {
    NSMutableDictionary *updatedAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    
    for (NSString *key in attributes.allKeys) {
        if ([key isEqualToString:@"IPCD:sn"]) {
            NSString *snValue = attributes[key];
            snValue = [snValue substringToIndex:(snValue.length - 1)];
            
            [updatedAttributes setObject:snValue forKey:key];
        }
    }
    
    return updatedAttributes;
}

#pragma mark - Notification Handling

- (void)deviceAddEventReceived:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(),^{
        // Dismiss Popups
        DeviceModel *addedDevice = (DeviceModel*)notification.object;
        if ([self.step.productCatalog.productId isEqualToString:[DeviceCapability getProductIdFromModel:addedDevice]]) {
            [DevicePairingManager sharedInstance].currentDevice = addedDevice;
            
            if (addedDevice.deviceType == DeviceTypeGarageDoorController) {
                self.waitTimer = [NSTimer scheduledTimerWithTimeInterval:15.0
                                                                  target:self
                                                                selector:@selector(advanceToNextStep)
                                                                userInfo:nil
                                                                 repeats:NO];
            }
            else {
                [self advanceToNextStep];
            }
        }
        else if ([self.waitTimer isValid]) {
            [self advanceToNextStep];
        }
    });
}

- (void)advanceToNextStep {
    if ([self.waitTimer isValid]) {
        [self.waitTimer invalidate];
    }
    
    if ([self.popupWindow displaying]) {
        [self.popupWindow close];
    }
    
    // Move to next step
    [super nextButtonPressed:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.formFieldsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifer = @"InputTextFieldCell";
    
    SettingsTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (!cell) {
        cell = [[SettingsTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:cellIdentifer];
    }
    
    IPCDInputModel *inputModel = self.formFieldsArray[indexPath.row];
    if (inputModel) {
        cell.textField.tag = indexPath.row;
        cell.textField.textColor = [UIColor blackColor];
        cell.textField.floatingLabelTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        cell.textField.floatingLabelActiveTextColor = [UIColor blackColor];
        cell.textField.activeSeparatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        cell.textField.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        
        [cell.textField setupType:AccountTextFieldTypeGeneral
                         fontType:FontDataType_Medium_18_Black_NoSpace
              placeholderFontType:FontDataTypeAccountTextFieldPlaceholder];
        
        cell.textField.placeholder = (inputModel.placeholderText) ? inputModel.placeholderText : @"";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITextFieldDelegate

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
    
    CGFloat animatedDistance;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance - 30;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    self.nextButton.userInteractionEnabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textfield {
    
    CGRect viewFrame = CGRectMake(0.0f,
                                  65.0f,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    self.nextButton.userInteractionEnabled = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL shouldChange = YES;
    
    if (range.length + range.location > textField.text.length) {
        shouldChange = NO;
    }
    
    if (shouldChange) {
        NSInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (textField.tag < [self.formFieldsArray count]) {
            IPCDInputModel *inputModel = self.formFieldsArray[textField.tag];
            if (inputModel.isRequired) {
                if (inputModel.requiredLength > 0) {
                    shouldChange = newLength <= inputModel.requiredLength;
                }
            }
        }
    }
    
    return shouldChange;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard];
    
    return YES;
}

#pragma mark - IPCDServiceDelegate

- (void)successfulParing {
    
}

- (void)paringHasTimeOut {
    // Show Device Not Found Error Pop Up
    dispatch_async(dispatch_get_main_queue(),^{
        NSString *codeString = nil;
        for (IPCDInputModel *inputModel in self.formFieldsArray) {
            if (inputModel.isRequired) {
                codeString = inputModel.placeholderText;
                break;
            }
        }
        
        NSString *errorMessage = [NSString stringWithFormat:@"Check your %@ and try again. \nIf the issue persists, contact the \nArcus Support Team", codeString];
        
        [self displayPopUpWithTitle:NSLocalizedString(@"Device not found", nil)
                           subtitle:errorMessage
                            isError:YES];
    });
}

- (void)failedParingDeviceHasOwner {
    // Show Error Pop Up
    dispatch_async(dispatch_get_main_queue(),^{
        NSString *codeString = nil;
        for (IPCDInputModel *inputModel in self.formFieldsArray) {
            if (inputModel.isRequired) {
                codeString = inputModel.placeholderText;
                break;
            }
        }
        
        NSString *errorMessage = [NSString stringWithFormat:@"Check your %@ and try again. \nIf the issue persists, contact the \nArcus Support Team", codeString];
        
        [self displayPopUpWithTitle:NSLocalizedString(@"Device has already been claimed \nby another system.", nil)
                           subtitle:errorMessage
                            isError:YES];
    });
}

- (void)failedParingDeviceNotFound {
    // Show Error Pop Up
    dispatch_async(dispatch_get_main_queue(),^{
        [self displayPopUpWithTitle:NSLocalizedString(@"DEVICE NOT FOUND", nil)
                           subtitle:self.step.errorMessage.length > 0 ? self.step.errorMessage : self.genericErrorMessage
                            isError:YES];
    });
}

#pragma mark - PopUp Handling

- (void)displayPopUpWithTitle:(NSString *)title subtitle:(NSString *)subtitle isError:(BOOL)isError {
    if ([self.popupWindow displaying]) {
        [self.popupWindow close];
    }
    
    PopupSelectionButtonModel *contactSupportSelectionModel = nil;
    if (isError) {
        contactSupportSelectionModel = [PopupSelectionButtonModel create:NSLocalizedString(@"1-0", nil) event:@selector(contactSupport:)];
    }
    
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:[title uppercaseString]
                                                                              subtitle:subtitle
                                                                                button:contactSupportSelectionModel, nil];
    buttonView.owner = self;
    
    self.popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:buttonView
                                             owner:self
                                     closeSelector:nil
                                             style:isError ? PopupWindowStyleCautionWindow : PopupWindowStyleMessageWindow];
}

#pragma mark - Hide Keyboard

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

@end
