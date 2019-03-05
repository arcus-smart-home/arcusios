//
//  ImagePicker.h
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

#import <Foundation/Foundation.h>

@interface ImagePicker : NSObject

typedef void(^ImagePickerCompletionBlock)(UIImage *image);

+ (instancetype)sharedInstance;

- (void)presentImagePickerInViewController:(UIViewController *)viewController
                               withImageId:(NSString *)imageName
                       withCompletionBlock:(ImagePickerCompletionBlock) completionBlock;

- (void)presentImagePicker:(UIViewController *)viewController
               withImageId:(NSString *)imageName
       withCompletionBlock:(void (^)(UIImage *image))completionBlock;

+ (void)saveImage:(UIImage *)image imageName:(NSString *)imageName;
+ (UIImage *)loadImage:(NSString *)imageName forImageView:(UIImageView *)imageView;

- (UIImage *)scaleAndRotateImage:(UIImage *)image;

@end
