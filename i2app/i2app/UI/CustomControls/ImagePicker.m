//
//  ImagePicker.m
//  i2app
//
//  Created by Arcus Team on 4/25/15.
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
#import "ImagePicker.h"
#import "AKFileManager.h"
#import <i2app-Swift.h>

@interface ImagePicker () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
    
    UIImagePickerController *_imagePickerController;
    UIPopoverController *_popoverCameraController;
    UIPopoverController *_popoverPhotoAlbumController;
    
    
}

@property(nonatomic, weak) UIViewController *containerViewController;
@property(nonatomic, copy) ImagePickerCompletionBlock completionBlock;
@property(nonatomic, strong) NSString *imageName;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;

@end

@implementation ImagePicker

+ (instancetype)sharedInstance {
    static ImagePicker *sharedInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInst == nil) {
            sharedInst = [[ImagePicker alloc] init];
        }
    });
    return sharedInst;
}

- (void)presentImagePickerInViewController:(UIViewController *)viewController
                               withImageId:(NSString *)imageName
                       withCompletionBlock:(ImagePickerCompletionBlock) completionBlock {
    self.completionBlock = completionBlock;
    self.containerViewController = viewController;
    self.imageName = imageName;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the Image Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photos", @"Camera", nil];
    [actionSheet showInView:viewController.view];
}

- (void)presentImagePicker:(UIViewController *)viewController
               withImageId:(NSString *)imageName
       withCompletionBlock:(void (^)(UIImage *image))completionBlock {
    self.completionBlock = completionBlock;
    self.containerViewController = viewController;
    self.imageName = imageName;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select the Image Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photos", @"Camera", nil];
    [actionSheet showInView:viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch ((int)buttonIndex) {
        case 0:
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary withViewController: self.containerViewController];
            break;
            
        case 1:
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera withViewController: self.containerViewController];
            break;
            
        default:
            break;
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
                  withViewController: (UIViewController*) vc {
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            //Make a choice on whether to use Camera or Photo Library:
            
            //Do this for Camera access:
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.showsCameraControls = YES;
            
            _popoverCameraController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            
            _popoverCameraController.delegate = self;
            _popoverCameraController.popoverContentSize = CGSizeMake(500, 400);
            
            //Set the size of the pop over frame:
            CGRect popoverStartFrameCamera = {0, 0, 500, 400};
            
            //Waits one cycle so that we can present in the current presenting view controller:
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [_popoverCameraController presentPopoverFromRect:popoverStartFrameCamera inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];}];
            
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.sourceType = sourceType;
            _imagePickerController.delegate = self;
            _imagePickerController.showsCameraControls = YES;
            
            [self.containerViewController presentViewController:_imagePickerController animated:YES completion:nil];
        }
        [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsBackgroundCamera attributes:@{}];
    }
    else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            _popoverPhotoAlbumController = [[UIPopoverController alloc]
                                            initWithContentViewController:imagePicker];
            
            _popoverPhotoAlbumController.delegate = self;
            _popoverPhotoAlbumController.popoverContentSize = CGSizeMake(500, 400);
            
            //Set the size of the pop over frame:
            CGRect popoverStartFrame = {0, 0, 500, 400};
            
            //Waits one cycle so that we can present in the current presenting view controller:
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [_popoverPhotoAlbumController presentPopoverFromRect:popoverStartFrame inView:vc.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];}];
        }
        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.sourceType = sourceType;
            _imagePickerController.delegate = self;
            
            [self.containerViewController presentViewController:_imagePickerController animated:YES completion:nil];
        }
        [ArcusAnalytics tag:AnalyticsTags.DashboardSettingsBackgroundGallery attributes:@{}];
    }
}

#pragma mark - UIImagePickerControllerDelegate
// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    // Make sure the image is rotated correctly before saving it into PNG
    image = [self scaleAndRotateImage:image];
    
    if (self.completionBlock) {
        self.completionBlock(image);
    }
    [_imagePickerController dismissViewControllerAnimated:YES completion:^{
        _imagePickerController = nil;
    }];
    
    if (_popoverCameraController != nil) {
        [_popoverCameraController dismissPopoverAnimated:YES];
    }
    
    if (_popoverPhotoAlbumController != nil) {
        [_popoverPhotoAlbumController dismissPopoverAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        _imagePickerController = nil;
    }];
}

#pragma mark - Load/Save Image to Documents
+ (void)saveImage:(UIImage *)image imageName:(NSString *)imageName {
    if (image) {
        [[AKFileManager defaultManager] cacheImage:image
                                           forHash:imageName];
    }
}

+ (UIImage *)loadImage:(NSString *)imageName forImageView:(UIImageView *)imageView {
    return [[AKFileManager defaultManager] cachedImageForHash:imageName
                                                       atSize:imageView.image.size
                                                    withScale:imageView.image.scale];
}

#pragma mark - Rotate PNG image
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = [UIScreen mainScreen].bounds.size.height;
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width / height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    // account for the retina display
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat scaleRatio = bounds.size.width * scale / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    
    switch (orient) {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    bounds = CGRectMake(0, 0, bounds.size.width * scale, bounds.size.height * scale);
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@end
