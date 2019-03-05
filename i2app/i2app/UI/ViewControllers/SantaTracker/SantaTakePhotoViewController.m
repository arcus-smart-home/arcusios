//
//  SantaTakePhotoViewController.m
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
#import "SantaTakePhotoViewController.h"
#import "ImagePicker.h"
#import "AKFileManager.h"
#import "SantaTracker.h"
#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "SantaDoneConfigViewController.h"

@interface SantaTakePhotoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cameraTreeIcon;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) BOOL createModel;

@end

@implementation SantaTakePhotoViewController {
    UIImage *_newImage;
    __weak IBOutlet UIImageView *cameraIcon;
}

+ (SantaTakePhotoViewController *)create:(BOOL)createModel {
    SantaTakePhotoViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.createModel = createModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Santa Tracker™"];
    
    if (self.createModel) {
        [self.saveButton styleSet:@"Next" andButtonType:FontDataTypeButtonLight upperCase:YES];
    }
    else {
        [self.saveButton setHidden:YES];
    }
    
    [self.titleLabel styleSet:@"Take a photo where you think Santa will appear and Arcus will capture a photo of him." andFontData:[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO]];
    [self.subtitleLabel styleSet:@"It's best to take the photo where you think Santa will arrive. One landscape photo only." andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO alpha:YES]];
    
    [cameraIcon setImage:[cameraIcon.image invertColor]];
    
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:kSantaTrackerImageId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    if (image) {
        _newImage = [image copy];
        image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
        image = [image roundCornerImageWithsize:CGSizeMake(190, 190)];
        
        [_cameraTreeIcon setImage:image];
    }
}
- (IBAction)onClickTakePic:(id)sender {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:kSantaTrackerImageId withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            
            _newImage = image;
            
            UIImage *logoImage = image.copy;
            logoImage = [logoImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
            logoImage = [logoImage roundCornerImageWithsize:CGSizeMake(190, 190)];
            
            [_cameraTreeIcon setImage:logoImage];
            
            if (!self.createModel) {
                [[SantaTracker shareInstance] setUpdatedSantaPhoto:_newImage];
            }
        }
    }];
}
- (IBAction)onClickSave:(id)sender {
    if (_newImage) {
        [[AKFileManager defaultManager] cacheImage:_newImage forHash:kSantaTrackerImageId];
    }

    [self.navigationController pushViewController:[SantaDoneConfigViewController create] animated:YES];
}


@end
