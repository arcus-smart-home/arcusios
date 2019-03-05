//
//  DeviceRenameAssignmentController.m
//  i2app
//
//  Created by Arcus Team on 10/2/15.
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
#import "DeviceRenameAssignmentController.h"
#import "CommonCheckableImageCell.h"
#import "AKFileManager.h"
#import "SDWebImageManager.h"
#import "DeviceManager.h"
#import "ImagePaths.h"
#import "UIImage+ScaleSize.h"
#import "AccountTextField.h"
#import "AKFileManager.h"
#import "ImagePicker.h"
#import "DevicePairingManager.h"
#import "AlarmBaseViewController.h"
#import "PopupSelectionPersonView.h"
#import "DeviceCapability.h"
#import "PairingStep.h"
#import "UIImage+ImageEffects.h"
#import <i2app-Swift.h>

@interface DeviceRenameAssignmentController () <UITextFieldDelegate, PopupSelectionPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *logoButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanNameButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet AccountTextField *editNameField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) PairingStep *pairingStep;

@end

@implementation DeviceRenameAssignmentController {
    UIImage *_selectedImage;
    PopupSelectionWindow *_popupWindow;
    PersonModel *_assignedPerson;
}

+ (DeviceRenameAssignmentController *)createWithDeviceModel:deviceModel {
    DeviceRenameAssignmentController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceDetailsRenameAssignmentController"];
    vc.deviceModel = deviceModel;
    return vc;
}

// Can be created from both Device More page and Pairing Steps
// If called from Pairing - self.pairingStep is not nil
+ (DeviceRenameAssignmentController *)createWithDeviceStep:(PairingStep *)pairingStep device:(DeviceModel *)deviceModel {
    DeviceRenameAssignmentController *vc = [[UIStoryboard storyboardWithName:@"PairDevice" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;
    vc.title = ((DeviceModel *)deviceModel).name;
    vc.pairingStep = pairingStep;

    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self navBarWithBackButtonAndTitle:self.title];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    if (self.deviceModel && !self.pairingStep) {
        [self navBarWithBackButtonAndTitle:self.deviceModel.name];
        
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:self.deviceModel.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            _selectedImage = image;
            if (![self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.logoButton]) {
                image = nil;
            }
        }
        if (!image) {
            [self setBackgroundColorToLastNavigateColor];
            [self addDarkOverlay:BackgroupOverlayLightLevel];
            
            NSString *urlString = [ImagePaths getLargeProductImageFromProductId:[DeviceCapability getProductIdFromModel:self.deviceModel]];
            if (urlString) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        _selectedImage = image;
                        [_logoButton setImage:image forState:UIControlStateNormal];
                    }
                }];
            }
        }
    }
    else if (self.pairingStep) {
        [self setBackgroundColorToLastNavigateColor];
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];

        NSString *urlString = [ImagePaths getLargeProductImageFromProductId:[DeviceCapability getProductIdFromModel:self.deviceModel]];
        if (urlString) {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    _selectedImage = [image invertColor];
                    [_logoButton setImage:_selectedImage forState:UIControlStateNormal];
                }
            }];
        }
    }

    _editNameField.accountFieldType = AccountTextFieldTypeGeneral;
    _editNameField.text = self.deviceModel.name;

    [_editNameField setupType:_editNameField.accountFieldType fontType:FontDataTypeSettingsTextField placeholderFontType:FontDataTypeSettingsTextFieldPlaceholder];
    if (!self.pairingStep) {
        _editNameField.textColor = [UIColor whiteColor];
        _editNameField.floatingLabelTextColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f];
        _editNameField.floatingLabelActiveTextColor = [UIColor whiteColor];
        _editNameField.activeSeparatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
        _editNameField.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    }
    else {
        _editNameField.textColor = [UIColor blackColor];
        _editNameField.floatingLabelTextColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        _editNameField.floatingLabelActiveTextColor = [UIColor blackColor];
        _editNameField.activeSeparatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
        _editNameField.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];

        [_nextButton styleSet:NSLocalizedString(@"NEXT", nil) andButtonType:FontDataTypeButtonDark];
    }

    _editNameField.userInteractionEnabled = YES;
    
    _assignedPerson = [self.deviceModel getAssignedPerson];
}

- (void)onClickSave:(id)sender {
    if (![self.editNameField.text isEqualToString:self.deviceModel.name]) {
        [[DevicePairingManager sharedInstance] renameDevice:self.editNameField.text forDeviceModel:self.deviceModel];
    }
    if (_selectedImage) {
        [[AKFileManager defaultManager] cacheImage:_selectedImage forHash:self.deviceModel.modelId];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:self.deviceModel];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(id)sender {
    if (!self.pairingStep) {
        if (![self.editNameField.text isEqualToString:self.deviceModel.name]) {
            [self createGif];
            [[DevicePairingManager sharedInstance] renameDevice:self.editNameField.text forDeviceModel:self.deviceModel completeBlock:^{
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)clickCleanButton:(id)sender {
    [_editNameField setText:@""];
}
- (IBAction)onClickImageButton:(id)sender {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:@"ID" withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            _selectedImage = image;

            if (_selectedImage) {
                [[AKFileManager defaultManager] cacheImage:_selectedImage forHash:self.deviceModel.modelId];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceBackgroupUpdateNotification object:self.deviceModel];
                [self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.logoButton];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (IBAction)onClickBackground:(id)sender {
    [self.editNameField resignFirstResponder];
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIImage *cellImage = [_assignedPerson image];
    if (!cellImage) {
        cellImage = [UIImage imageNamed:@"userIcon"];
        if (self.pairingStep) {
            cellImage = [cellImage invertColor];
        }
    }
    else {
        cellImage = [cellImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
        cellImage = [cellImage roundCornerImageWithsize:CGSizeMake(45, 45)];
    }
    
    if (!self.pairingStep) {
        [cell setIcon:cellImage withWhiteTitle:_assignedPerson ? @"ASSIGNED" : @"UNASSIGNED" subtitle:nil andSide:_assignedPerson.fullName];
    }
    else {
        [cell setIcon:cellImage withBlackTitle:_assignedPerson ? @"ASSIGNED" : @"UNASSIGNED" subtitle:nil andSide:_assignedPerson.fullName];
    }

    [cell hideCheckbox];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *personViewSelection =
        [PopupSelectionPersonViewController createWithDelegate:self
                                                   deviceModel:self.deviceModel
                                           selectedPersonModel:_assignedPerson];
    [self presentViewController:personViewSelection animated:true completion:nil];
}

#pragma mark - PopupSelectionPersonViewControllerDelegate

- (void)unassigned {
    [self createGif];
    [self.deviceModel unassignPerson:^{
        _assignedPerson = nil;
        [self.tableView reloadData];
        [self hideGif];
    } failedBlock:^{
        [self hideGif];
        [self displayGenericErrorMessage];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)completeSelection:(PersonModel *)value {
    if (value) {
        [self createGif];
        [self.deviceModel assignPerson:value completeBlock:^{
            _assignedPerson = value;
            [self.tableView reloadData];
            [self hideGif];
        } failedBlock:^{
            [self hideGif];
            [self displayGenericErrorMessage];
        }];
    }
    else {
        [self unassigned];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - override
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= 100;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textfield {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view subview:container owner:self closeSelector:selector];
}
- (void)popupError:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    _popupWindow = [PopupSelectionWindow popup:self.view subview:container owner:self closeSelector:selector];
}

- (IBAction)nextButtonPressed:(id)sender {
    if (![self.editNameField.text isEqualToString:self.deviceModel.name]) {
        [self createGif];
        [[DevicePairingManager sharedInstance] renameDevice:self.editNameField.text forDeviceModel:self.deviceModel completeBlock:^{
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [super nextButtonPressed:sender];
            });
        }];
    }
    else {
        [super nextButtonPressed:sender];
    }
}

@end
