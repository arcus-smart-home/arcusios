//
//  DeviceTextfieldViewController.m
//  i2app
//
//  Created by Arcus Team on 5/5/15.
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
#import "DeviceTextfieldViewController.h"
#import "ImagePicker.h"
#import "ProductCapability.h"
#import "DeviceCapability.h"
#import "HubCapability.h"
#import "DeviceController.h"
#import "ProductCatalogController.h"
#import "AccountTextField.h"
#import "DevicePairingWizard.h"
#import "NSString+Validate.h"
#import "DevicePairingManager.h"
#import "DeviceCapability.h"
#import "PairedHubAlreadyForActionViewController.h"

#import "DeviceDetailsTabBarController.h"
#import "AKFileManager.h"
#import "SDWebImageManager.h"
#import "DeviceManager.h"
#import "ImageDownloader.h"
#import "UIImage+ImageEffects.h"
#import "PairingStep.h"

@interface DeviceTextfieldViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *tutorialView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (nonatomic) UIWebView *videoView;
@property (atomic) DeviceTextFieldType deviceTextFieldType;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *stepNumberImage;
@property (weak, nonatomic)  NSLayoutConstraint *bottomToButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageToNumberConstraint;
@property (nonatomic, assign) BOOL isFirstEntryAttempt;
@property (strong, nonatomic) UIImage *deviceImage;
@property (strong, nonatomic) NSString *deviceImageKey;
@property (strong, nonatomic) UIImage *selectedImage;
@property (assign, nonatomic) BOOL isDefaultImage;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImageView;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)photoButtonPressed:(id)sender;

- (void)saveHubPhotoAndName:(HubModel *)hubModel ;

@end

@implementation DeviceTextfieldViewController

#pragma mark - Life Cycle
+ (instancetype)createWithDeviceModel:deviceModel {
    __block DeviceTextfieldViewController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return [self createWithDeviceModel:deviceModel withViewController:vc];
}

+ (instancetype)createWithDeviceModelFromDeviceDetail:(DeviceModel *)deviceModel {
    DeviceTextfieldViewController *vc = [self createWithDeviceModel:deviceModel];
    vc.inDeviceDetails = YES;
    return vc;
}

+ (instancetype)createWithDeviceModel:deviceModel withViewController:(DeviceTextfieldViewController *)vc {
    PairingStep *step = [[PairingStep alloc] init];
    step.stepType = PairingStepNameAndPhoto;
    
    if ([deviceModel isKindOfClass:DeviceModel.class]) {
        step.title = [DeviceCapability getProductIdFromModel:deviceModel];
    }
    else  {
        step.title = [HubCapability getNameFromModel:deviceModel];
    }
    
    step.mainStep = NSLocalizedString(@"Name your device\nand add a photo if you like.", nil);
    step.secondStep = NSLocalizedString(@"Device Name", nil);
    step.success = YES;
    
    [vc setDeviceStep:step];
    
    if (deviceModel) {
        vc.deviceModel = deviceModel;
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            if ([deviceModel isKindOfClass:[HubModel class]]) {
                // HubModel is not available: try to retrieve it again
                [DeviceController getHubsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSDictionary *dict) {
                    vc.deviceModel = (DeviceModel *)[[CorneaHolder shared] settings].currentHub;
                });
            }
        });
    }
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstEntryAttempt = YES;

    _selectedImage = nil;

    if (self.inDeviceDetails) {
        // This View Controller is used in Device More, not in Pairing
        [self setBackgroundColorToLastNavigateColor];
        [self addDarkOverlay:BackgroupOverlayLightLevel];

        [self.cameraButton setImage:[self.cameraButton.imageView.image invertColor] forState:UIControlStateNormal];
        self.mainStepLabel.textColor = [UIColor whiteColor];

        self.deviceTextField.textColor = [UIColor whiteColor];
        self.deviceTextField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        self.deviceTextField.floatingLabelActiveTextColor = [UIColor whiteColor];
        self.deviceTextField.activeSeparatorColor =  [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        self.deviceTextField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    }

    self.deviceTextField.delegate = self;
    self.deviceTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.deviceTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (self.deviceTextField) {
        if (self.deviceTextField.text.length > 0) {
            self.deviceTextField.attributedText = [[FontData createFontData:FontTypeMedium size:14 blackColor:YES space:YES] getFontAttributed:self.deviceTextField.text];
        }
        if (self.deviceModel.name.length > 0) {
            if ([self.deviceModel isKindOfClass:[HubModel class]] &&
                self.deviceModel.name.length == 0) {
                self.deviceTextField.text = @"Smart Hub".uppercaseString;
            }
            else {
                self.deviceTextField.attributedText = [[FontData createFontData:FontTypeMedium size:14 blackColor:self.inDeviceDetails ? NO : YES space:YES] getFontAttributed:self.deviceModel.name];
                self.deviceTextField.floatingLabel.attributedText = [FontData getString:[NSLocalizedString(@"Device Name", nil) uppercaseString] withFont:FontDataTypeAccountTextFieldPlaceholder];
            }
        }
    }
    
    if (self.step.stepType == PairingStepEnterHubId) {
        [_photoButton setImage:[UIImage imageNamed:self.step.imageUrl] forState:UIControlStateNormal];
        self.deviceTextField.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16];
        self.stepNumberImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Step%d", (int)self.step.stepIndex + 1]];
    }
    else if (self.step.stepType == PairingStepNameAndPhoto && self.step.imageUrl) {
        [_photoButton setImage:[UIImage imageNamed:self.step.imageUrl] forState:UIControlStateNormal];
    }
    else if (self.deviceModel) {
        [self setupViewForDeviceWithModel:self.deviceModel];
    }
    
    // Adding the cloud for c2c
    if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
        self.cloudImageView.hidden = ![self.deviceModel isC2CDevice];
    }
    else {
        self.cloudImageView.hidden = YES;
    }
  
    if (self.inDeviceDetails) {
        [_nextButton styleSet:NSLocalizedString(@"SAVE", nil) andButtonType:FontDataTypeButtonLight upperCase:YES];
    } else {
        [_nextButton styleSet:NSLocalizedString(@"NEXT", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
    }
  
    if (IS_IPHONE_5) {
        _topToImageConstraint.constant = 14;
        _imageToNumberConstraint.constant = 14;
    }
    
    [[DevicePairingManager sharedInstance] stopHubPairing];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setupViewForDeviceWithModel:(DeviceModel *)deviceModel {
  if (self.deviceModel.deviceType == DeviceTypeThermostatNest && !self.inDeviceDetails) {
    [self navBarWithTitle:self.deviceModel.name];

    // If in pairing and only one device paired then remove the back button
    if ([[DevicePairingManager sharedInstance].justPairedDevices count] == 1) {
      self.navigationItem.leftBarButtonItem = nil;
    }
  } else {
    [self navBarWithBackButtonAndTitle:self.deviceModel.name];
  }

    if (self.deviceImage) {
        [_photoButton setImage:self.deviceImage forState:UIControlStateNormal];
        if (self.isDefaultImage) {
            [_photoButton setImage:self.deviceImage forState:UIControlStateNormal];
        }
        else {
            _selectedImage = self.deviceImage;
            [self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.photoButton];
        }
        return;
    }
    
    NSString *name;
    NSString *productId = nil;
    if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
      name = self.deviceModel.modelId;
      productId = [DeviceCapability getProductIdFromModel:self.deviceModel];
    }
    else if ([self.deviceModel isKindOfClass:[HubModel class]]) {
      name = [HubCapability namespace];
      HubModel *hub = (HubModel *)self.deviceModel;
      NSString *hubModel = [HubCapability getModelFromModel:hub];
      if ([hubModel isEqualToString:@"IH300"]){
        productId = @"dee001";
      }
    }
    
    if (name.length > 0) {
      UIImage *image = [[AKFileManager defaultManager]
                        cachedImageForHash:self.deviceModel.modelId
                        atSize:[UIScreen mainScreen].bounds.size
                        withScale:[UIScreen mainScreen].scale];
        if (image) {
            _selectedImage = image;
            [self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.photoButton];
        }
        else {
            [self setBackgroundColorToDashboardColor];
            
            [ImageDownloader downloadDeviceImage:productId withDevTypeId:[self.deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:YES isBlackStyle:NO].then(^(UIImage *image) {
                if (image) {
                    if (!self.inDeviceDetails && self.deviceModel.deviceType != DeviceTypeThermostatNest) {
                        image = [image invertColor];
                    }

                    [_photoButton setImage:image forState:UIControlStateNormal];
                }
            });
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(continuePairingAfterRenamingTheDevice:)
                                               name:[Model attributeChangedNotification:kAttrDeviceName]
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardFrameWillChange:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
  _nextButton.userInteractionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewTapped {
    [self.view endEditing:YES];
}

/*
 * Used to initialize all control IBOutlets and IBActions
 */
- (void)initializeTemplateViewController {

  if (self.deviceModel.deviceType == DeviceTypeThermostatNest && !self.inDeviceDetails) {
    [self navBarWithTitle:self.step.title];

    // If in pairing and only one device paired then remove the back button
    if ([[DevicePairingManager sharedInstance].justPairedDevices count] == 1) {
      self.navigationItem.leftBarButtonItem = nil;
    }
  } else {
    [self navBarWithBackButtonAndTitle:self.step.title];
  }

    
    self.tutorialView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    
    if ([self.step isKindOfClass:[PairingStep class]]) {
        self.mainStepLabel.text = self.step.mainStep;
        self.deviceTextField.placeholder = [self.step.secondStepPlaceholder uppercaseString];
        
        if (self.step.stepType == PairingStepEnterHubId) {
            [self.photoButton setImage:[UIImage imageNamed:@"ImagePlaceholder"] forState:UIControlStateNormal];
            self.photoButton.userInteractionEnabled = NO;
            self.deviceTextFieldType = DeviceTextFieldTypeHubID;
            self.cameraButton.hidden = YES;
        }
        else if (self.step.stepType == PairingStepNameAndPhoto) {
            self.deviceTextFieldType = DeviceTextFieldTypeDeviceName;
            self.photoButton.userInteractionEnabled = YES;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitedFullScreen:)  name:UIWindowDidBecomeHiddenNotification object:nil];
    }
    
    [self refreshVideo];
    
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
}

- (void)refreshVideo {
    BOOL displayVideo = ([DevicePairingManager sharedInstance].pairingWizard.videoURL && [DevicePairingManager sharedInstance].pairingWizard.videoURL.length > 0);
    [self.tutorialView setHidden:!displayVideo];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.deviceTextFieldType == DeviceTextFieldTypeHubID) {
        //calculate new length
        NSInteger moddedLength = textField.text.length - (range.length - string.length);
        // max size.
        if (moddedLength >= 9) {
            return NO;
        }
        // Auto-add hyphen before appending 4rd character if hyphen is not enetered by user
        if ([self range:range ContainsLocation:3]) {
            textField.text = [self formatHubString:[textField.text stringByReplacingCharactersInRange:range withString:string] withStringCheck:string];
            return NO;
        }
    }
    return YES;
}

- (NSString *)formatHubString:(NSString *)originalHubString withStringCheck:(NSString *)check {
    NSString * newHubString = originalHubString;
    if (newHubString.length > 3 && ![check isEqual:@"-"]) {
        newHubString = [newHubString stringByReplacingCharactersInRange:NSMakeRange(3, 0) withString:@"-"];
    }
    return newHubString;
}

- (bool)range:(NSRange)range ContainsLocation:(NSInteger)location {
    if (range.location <= location && range.location+range.length >= location) {
        return YES;
    }
    return NO;
}

#pragma mark - Actions
- (void)exitedFullScreen:(id)sender {
    [self.videoView removeFromSuperview];
}

- (IBAction)nextButtonPressed:(id)sender {
    [self resignFirstResponder];

    if ([[DevicePairingManager sharedInstance] ignoreDeviceAdded] == YES) {
        [[DevicePairingManager sharedInstance] setIgnoreDeviceAdded:NO];
    }
    
    if ([self validateTextFields] == NO) {
        return;
    }
    
    if ([self.deviceModel isKindOfClass:[DeviceModel class]]) {
        [self deviceClickSave:sender];
    }
    else {
        [self hubClickSave:sender];
    }
}

- (void)back:(NSObject *)sender {
    if (self.inDeviceDetails) {
        if (![self.deviceModel.name isEqualToString:self.deviceTextField.text]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                if (self.deviceModel.deviceType != DeviceTypeHub) {
                    [DeviceCapability setName:self.deviceTextField.text onModel:self.deviceModel];

                    [self.deviceModel commit].thenInBackground(^ {
                        [self.deviceModel refresh].then(^ {
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }).catch(^(NSError *error) {
                        DDLogWarn(@"renameDevice error: %@", error.localizedDescription);
                    });
                }
                else {
                    [HubCapability setName:self.deviceTextField.text onModel:(HubModel *)self.deviceModel];

                    [self.deviceModel commit].thenInBackground(^ {
                        [self.deviceModel refresh].then(^ {
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    }).catch(^(NSError *error) {
                        DDLogWarn(@"renameDevice error: %@", error.localizedDescription);
                    });
                }
            });
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [super back:sender];
    }
}

- (void)hubClickSave:(id)sender {
    if (self.step.stepType == PairingStepEnterHubId) {
        [[DevicePairingManager sharedInstance].pairingWizard.parameters setObject:self.deviceTextField.text forKey:@"HubID"];
        [super nextButtonPressed:sender];
    }
    else if (self.step.stepType == PairingStepNameAndPhoto) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            // Rename the hub
            HubModel *hubModel = [[CorneaHolder shared] settings].currentHub;
            if (hubModel) {
                [self saveHubPhotoAndName:hubModel];
            }
            else {
                // HubModel is not available: try to retrieve it again
                [DeviceController getHubsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSDictionary *dict) {
                    [self saveHubPhotoAndName:[[CorneaHolder shared] settings].currentHub];
                }).catch(^(NSError *error) {
                    [self displayErrorMessage:NSLocalizedString(@"To continue, please restart the app", nil)];
                });
            }
        });
    }
}

- (void)deviceClickSave:(id)sender {
    // Rename the device
    BOOL attributesChanged = NO;
    if (![self.deviceTextField.text isEqualToString:self.deviceModel.name]) {
        [self createGif];
        
        [[DevicePairingManager sharedInstance] renameDevice:self.deviceTextField.text forDeviceModel:self.deviceModel];
        attributesChanged = YES;
    }
    if (_selectedImage) {
        [[AKFileManager defaultManager] cacheImage:_selectedImage forHash: self.deviceImageKey ? self.deviceImageKey: self.deviceModel.modelId];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:self.deviceModel];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                                  [DeviceDetailsTabBarController class]];
        
        if ([self.navigationController.viewControllers filteredArrayUsingPredicate:predicate].count > 0) {
            // Super should only handle this action during the pairing usecase. ITWO-11945
            if (!self.inDeviceDetails) {
                [super nextButtonPressed:sender];
            }
        }
    }
    if (!attributesChanged) {
        if (![[DevicePairingManager sharedInstance].updatedPairedDevices containsObject:self.deviceModel.modelId]) {
            [[DevicePairingManager sharedInstance].updatedPairedDevices addObject:self.deviceModel.modelId];
        }
        [self continuePairingAfterRenamingTheDevice:nil];
    }
}

- (void)saveHubPhotoAndName:(HubModel *)hubModel {
    if (!hubModel) {
        return;
    }

    [HubCapability setName:self.deviceTextField.text onModel:hubModel];
    
    if (_selectedImage) {
        [[AKFileManager defaultManager] cacheImage:_selectedImage forHash:hubModel.modelId];
        
        [self.view renderLogoAndBackgroundWithImageNamed:hubModel.modelId forLogoControl:self.photoButton];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:hubModel];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [hubModel commit].then(^(NSObject *obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [super nextButtonPressed:self];
            });
        }).catch(^(NSError *error) {
            [self displayErrorMessage:NSLocalizedStringFromTable(@"Error renaming the hub", @"ErrorMessages", nil)];
        });
    });
}

- (IBAction)photoButtonPressed:(id)sender {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:@"ID" withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            _selectedImage = image;
            
            if (_selectedImage) {
                [[AKFileManager defaultManager] cacheImage:_selectedImage forHash:self.deviceModel.modelId];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:self.deviceModel];
                [self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.photoButton];
            }            
        }
    }];
}

#pragma mark - UIKeyboardFrame Notifications

- (UIView *)findFirstResponder: (UIView *) container {
  for (UIView *subView in container.subviews) {
    if ( [subView isFirstResponder] ) {
      return subView;
    }
    UIView *recursiveSubview = [self findFirstResponder:subView];
    if (recursiveSubview != nil) {
      return recursiveSubview;
    }
  }
  return nil;
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardFrameWillChange:(NSNotification*)notification
{

  UIView *firstResponder = [self findFirstResponder:self.view];
  if (firstResponder == nil) {
    return;
  }

  //this animation will move the entire view up by the height of the keyboard
  CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
  NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];

  if ( keyboardEndFrame.size.height > 0 ) { // Animating in or around
    CGRect textFieldRect = [self.view.window convertRect:firstResponder.bounds fromView:firstResponder];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    if ((textFieldRect.origin.y + textFieldRect.size.height + 10.0f) < (viewRect.origin.y + viewRect.size.height - keyboardEndFrame.size.height)) {
      return;
    }
  }

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:animationCurve];

  CGRect newFrame = self.view.frame;
  CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
  CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];

  newFrame.origin.y -= (keyboardFrameBegin.origin.y - keyboardFrameEnd.origin.y);
  self.view.frame = newFrame;

  [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (self.isFirstEntryAttempt) {
        self.isFirstEntryAttempt = NO;
        
        [textField resignFirstResponder];
        [textField becomeFirstResponder];
        
        return;
    }
    _nextButton.userInteractionEnabled = NO;
    return;
}

- (void)textFieldDidEndEditing:(UITextField *)textfield {
    _nextButton.userInteractionEnabled = YES;
}

- (BOOL)validateTextFields {
    // We need to validate the entered data here
    [self viewTapped];
    
    NSString *errorMessageKey;
    if (![self isDataValid:&errorMessageKey]) {
        return NO;
    }
    return YES;
}

- (BOOL)isDataValid:(NSString **)errorMessageKey {
    if (self.deviceTextFieldType == DeviceTextFieldTypeHubID) {
        
        if (![self.deviceTextField.text isValidHubID]) {
            [self displayErrorMessage:*errorMessageKey withTitle:@"Invalid Hub ID"];
            self.deviceTextField.textColor = pinkAlertColor;
            return NO;
        }
    }
    else {
        if (![self.deviceTextField.text isValidDeviceName]) {
            
            [self displayErrorMessage:*errorMessageKey withTitle:@"Cannot be empty"];
            self.deviceTextField.textColor = pinkAlertColor;
            return NO;
        }
    }
    return YES;
}

#pragma mark - Device Renamed Observer
/*
 * Display "Device Paired Success" page if:
 *      1. Only if only one device was paired
 *      2. Multiple devices were paired: the after the first device gets paired
 */
- (void)continuePairingAfterRenamingTheDevice:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{

        if ([DevicePairingManager sharedInstance].justPairedDevices.count == 1) {
            [self processJustPairedOneDevice];
        }
        else if ([DevicePairingManager sharedInstance].justPairedDevices.count > 1) {
            if (self.deviceModel.deviceType != DeviceTypeThermostatHoneywellC2C) {
                [self processJustPairedMoreThanOneDevice];
            }
            else {
                [self processJustPairedOneDevice];
            }
        }
        else {
            // This is not during pairing
            UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
            if ([vc isKindOfClass:[DeviceDetailsTabBarController class]]) {
                
                [vc setNavBarTitle:self.deviceModel.name];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    });
}

- (void)processJustPairedOneDevice {
    PairingStep *step = [[PairingStep alloc] init];
    step.stepType = PairingStepPromo;
    step.stepIndex = 0;
    step.title = self.deviceModel.name;
    
    [[DevicePairingManager sharedInstance].pairingWizard addPairingStep:step];
    [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
}

- (void)processJustPairedMoreThanOneDevice {
    
    DeviceType deviceType = [DevicePairingManager sharedInstance].pairingWizard.deviceType;
    BOOL isFave = YES;
    NSArray *extraSteps = [DevicePairingWizard getDevTypeForExtraSteps];
    BOOL isExtra = NO;
    for (int i = 0; i < [extraSteps count]; i++) {
        if ([@(deviceType) isEqual:[extraSteps objectAtIndex:i]]) {
            isExtra = YES;
            break;
        }
    }
    
    if ([DevicePairingManager sharedInstance].updatedPairedDevices.count == 1) {
        PairingStep *step = [[PairingStep alloc] init];
        step.stepType = PairingStepPromo;
        step.stepIndex = isExtra ? 1 : 0;
        step.title = self.deviceModel.name;
        
        [[DevicePairingManager sharedInstance].pairingWizard addPairingStep:step];
        [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
        
    }
    else if ([DevicePairingManager sharedInstance].justPairedDevices.count > [DevicePairingManager sharedInstance].updatedPairedDevices.count) {
        if (isExtra || isFave) {
            [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        // Done pairing
        if (isExtra || isFave) {
            [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
            
        }
        else {
            [[DevicePairingManager sharedInstance] resetAllPairingStates];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
