//
//  PopupSelectionLogoTextCell.h
//  i2app
//
//  Created by Arcus Team on 12/18/15.
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


@class PopupSelectionLogoTextView;



@interface PopupSelectionLogoItemModel: NSObject

@property (assign, nonatomic) BOOL selected;

+ (PopupSelectionLogoItemModel*) createWithDeviceModel:(DeviceModel *)model selected:(BOOL)selected;
+ (PopupSelectionLogoItemModel*) createWithPersonModel:(PersonModel *)model selected:(BOOL)selected;
+ (PopupSelectionLogoItemModel*) createWithLogo:(UIImage *)logo title:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected;
+ (PopupSelectionLogoItemModel*) createWithTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected;

- (PopupSelectionLogoItemModel*) setModel:(Model *)model;
- (PopupSelectionLogoItemModel*) setLogo:(UIImage *)image;
- (PopupSelectionLogoItemModel*) setTitleText:(NSString *)title;
- (PopupSelectionLogoItemModel*) setSubtitleText:(NSString *)subtitle;
- (PopupSelectionLogoItemModel*) setReturnObj:(NSObject *)obj;

- (NSObject *) getReturningObj;

@end


@interface PopupSelectionLogoTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;

- (void) set:(PopupSelectionLogoItemModel *)itemModel owner:(PopupSelectionLogoTextView *)owner;

@end
