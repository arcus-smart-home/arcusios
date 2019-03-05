//
//  DeviceRenamePetSmartKeyViewController.m
//  i2app
//
//  Created by Arcus Team on 1/18/16.
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
#import "DeviceRenamePetSmartKeyViewController.h"
#import "PetTokenCapability.h"
#import "DoorsNLocksSubsystemController.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"
#import "AKFileManager.h"
#import "PairingStep.h"
#import "SmartPetTokenPairingViewController.h"
#import "SimpleTableViewController.h"
#import <i2app-Swift.h>

@interface DeviceTextfieldViewController()

@property (strong, nonatomic) UIImage *deviceImage;
@property (strong, nonatomic) NSString *deviceImageKey;
@property (strong, nonatomic) UIImage *selectedImage;
@property (assign, nonatomic) BOOL isDefaultImage;

@end

@interface DeviceRenamePetSmartKeyViewController()

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *petSmartTopImageConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perdoorInputButtomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonBottomConstraint;

@property (atomic, assign) int smartKeyTokenId;
@property (nonatomic, strong) NSString *smartKeyTokenKey;
@property (nonatomic, strong) NSString *smartkeyTokenName;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)onClickRemove:(id)sender;

@end

@implementation DeviceRenamePetSmartKeyViewController {
    PopupSelectionWindow        *_popupWindow;
}

+ (instancetype)createWithDeviceModel:deviceModel withPetData:(NSDictionary *)petData {
    DeviceRenamePetSmartKeyViewController *vc = [self createWithDeviceModel:deviceModel withViewController:[[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])]];

    // When renaming a token we need the tokenKey ("pt1")
    vc.smartKeyTokenKey = petData[@"PetToken"];
    vc.smartkeyTokenName = petData[kAttrPetTokenPetName];
    
    return vc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    self.deviceImageKey = [NSString stringWithFormat:@"%@-%d", self.deviceModel.modelId, self.smartKeyTokenId];
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:self.deviceImageKey atSize:[UIScreen mainScreen].bounds.size withScale:[UIScreen mainScreen].scale];
    UIImage *defaultImage = [UIImage imageNamed:@"SmartKey_large"];
    if (!image) {
        image = defaultImage;
        self.isDefaultImage = YES;
    } else {
        if ([image isEqual:defaultImage]) {
            self.isDefaultImage = YES;
        } else {
            self.isDefaultImage = NO;
        }
    }
    self.deviceImage = image;
    
    [super viewDidLoad];
    self.deviceTextField.placeholder = @"";
    
    if (self.smartkeyTokenName.length > 0) {
        [self setNavBarTitle:self.smartkeyTokenName];
        self.deviceTextField.text = self.smartkeyTokenName;
    }
    else {
        [self setNavBarTitle:@"Smart Key"];
        self.deviceTextField.text = NSLocalizedString(@"SMART KEY", nil);
        self.removeButton.hidden = YES;
        self.saveButtonBottomConstraint.constant = 20;
        [self.view setNeedsLayout];
    }
    
    if (IS_IPHONE_5) {
        self.petSmartTopImageConstraint.constant = 14;
        self.perdoorInputButtomConstraint.constant = 30;
    }

    self.mainStepLabel.text = NSLocalizedString(@"Name your pet key", nil);
    
    [_removeButton styleSet:NSLocalizedString(@"remove", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.smartKeyTokenId == 0) {
        // The smart key has just paired
        SmartPetTokenPairingViewController *pairingVC = (SmartPetTokenPairingViewController *)[self findLastViewController:[SmartPetTokenPairingViewController class]];
        self.smartKeyTokenId = pairingVC.addedTokenId;
    }
}

- (void)hideSecondButton:(BOOL)hide {
    self.firstButtonBottomConstraint.constant = hide ? 20.0f : 80.0f;
    [self.removeButton setHidden:hide];
}

- (IBAction)onClickRemove:(id)sender {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"ARE YOU SURE?", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"YES", nil) event:@selector(removeTokenKey)], [PopupSelectionButtonModel create:NSLocalizedString(@"NO", nil) event:nil], nil];
    buttonView.owner = self;

    _popupWindow = [PopupSelectionWindow popup:self.view subview:buttonView owner:self closeSelector:nil style:PopupWindowStyleCautionWindow];
}

- (void)removeTokenKey {
    if (self.smartKeyTokenKey.length == 0) {
        self.smartKeyTokenKey = [DoorsNLocksSubsystemController getPetTokenForTokenId:self.smartKeyTokenId onPetModel:self.deviceModel];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petTokenRemoved:) name:self.deviceModel.modelChangedNotification object:nil];
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [DoorsNLocksSubsystemController removePetToken:self.smartKeyTokenKey onPetModel:self.deviceModel].catch(^ {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:self.deviceModel.modelChangedNotification object:nil];
            [self hideGif];
            [self displayGenericErrorMessage];
        });
    });
}

- (void)petTokenRemoved:(NSNotification *)note {
    if ([note.object isKindOfClass:[NSDictionary class]]) {
        NSNumber *tokenIdNumber = ((NSDictionary *)note.object)[kPetTokenId];
        if (tokenIdNumber && ![tokenIdNumber isEqual:[NSNull null]]) {
            if (tokenIdNumber.intValue == self.smartKeyTokenId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideGif];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Pet token has been unpaired
                [[NSNotificationCenter defaultCenter] removeObserver:self name:self.deviceModel.modelChangedNotification object:nil];
                [self hideGif];
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}

- (IBAction)nextButtonPressed:(id)sender {
    if (self.smartKeyTokenKey.length == 0) {
        self.smartKeyTokenKey = [DoorsNLocksSubsystemController getPetTokenForTokenId:self.smartKeyTokenId onPetModel:self.deviceModel];
    }

    if (self.selectedImage) {
        [[AKFileManager defaultManager] cacheImage:self.selectedImage forHash: self.deviceImageKey ? self.deviceImageKey: self.deviceModel.modelId];
    }

    if (self.smartKeyTokenKey.length > 0) {
        [self createGif];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [DoorsNLocksSubsystemController renamePetToken:self.deviceTextField.text withPetToken:self.smartKeyTokenKey onPetModel:self.deviceModel].then(^(NSObject *obj) {
                UIViewController *vc = [self findLastViewController:[SimpleTableViewController class]];
                [self.navigationController popToViewController:vc animated:YES];
            }).catch(^ {
                [self displayGenericErrorMessage];
            }).finally(^ {
                [self hideGif];
            });
        });
    }
}

@end
