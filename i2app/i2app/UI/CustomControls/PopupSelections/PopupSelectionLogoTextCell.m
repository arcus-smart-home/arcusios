//
//  PopupSelectionLogoTextCell.m
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

#import <i2app-Swift.h>
#import "PopupSelectionLogoTextCell.h"
#import "PopupSelectionLogoTextView.h"

#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"
#import "ImagePaths.h"

#import "PeopleModelManager.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"

#import "DeviceCapability.h"

@interface PopupSelectionLogoItemModel()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage  *logoImage;

@property (assign, nonatomic) BOOL     displayLogo;
@property (strong, nonatomic) NSObject *returningObj;
@property (strong, nonatomic) Model    *dynamicModel;

@end


@implementation PopupSelectionLogoItemModel

+ (PopupSelectionLogoItemModel*) createWithDeviceModel:(DeviceModel *)model selected:(BOOL)selected {
    PopupSelectionLogoItemModel *item = [[PopupSelectionLogoItemModel alloc] init];
    [item setTitle:model.name];
    [item setSubtitle:model.vendor];
    [item setSelected:selected];
    [item setModel:model];
    [item setDisplayLogo:YES];
    return item;
}

+ (PopupSelectionLogoItemModel*) createWithPersonModel:(PersonModel *)model selected:(BOOL)selected {
    PopupSelectionLogoItemModel *item = [[PopupSelectionLogoItemModel alloc] init];
    [item setTitle:model.fullName];
    [item setSelected:selected];
    
    UIImage *cellImage = [model image];
    if (!cellImage) {
        cellImage = [[UIImage imageNamed:@"userIcon"] invertColor];
    }
    else {
        cellImage = [cellImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
        cellImage = [cellImage roundCornerImageWithsize:CGSizeMake(45, 45)];
    }
    
    [item setLogoImage:cellImage];
    [item setDisplayLogo:YES];
    [item setModel:model];
    return item;
}
+ (PopupSelectionLogoItemModel*) createWithLogo:(UIImage *)logo title:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected {
    PopupSelectionLogoItemModel *model = [[PopupSelectionLogoItemModel alloc] init];
    [model setTitle:title];
    [model setSubtitle:subtitle];
    [model setSelected:selected];
    if (logo) {
        [model setLogoImage:logo];
    }
    else {
        [model setLogoImage:[UIImage imageNamed:@"CategoryIconPlaceholder"]];
    }
    [model setDisplayLogo:YES];
    return model;
}
+ (PopupSelectionLogoItemModel*) createWithTitle:(NSString *)title subtitle:(NSString *)subtitle selected:(BOOL)selected {
    PopupSelectionLogoItemModel *model = [[PopupSelectionLogoItemModel alloc] init];
    [model setTitle:title];
    [model setSubtitle:subtitle];
    [model setSelected:selected];
    [model setDisplayLogo:NO];
    return model;
}

- (PopupSelectionLogoItemModel*) setModel:(Model *)model {
    self.dynamicModel = model;
    self.displayLogo = YES;
    return self;
}
- (PopupSelectionLogoItemModel*) setLogo: (UIImage *)image {
    self.logoImage = image;
    return self;
}
- (PopupSelectionLogoItemModel*) setTitleText:(NSString *)title {
    self.title = title;
    return self;
}
- (PopupSelectionLogoItemModel*) setSubtitleText:(NSString *)subtitle {
    self.subtitle = subtitle;
    return self;
}
- (PopupSelectionLogoItemModel*) setReturnObj:(NSObject *)obj {
    self.returningObj = obj;
    return self;
}

- (NSObject *) getReturningObj {
    if (self.returningObj) {
        return self.returningObj;
    }
    else if (self.dynamicModel) {
        return self.dynamicModel;
    }
    return self;
}


@end


@implementation PopupSelectionLogoTextCell {
    __weak PopupSelectionLogoTextView *_controller;
    PopupSelectionLogoItemModel *_itemModel;
    __weak IBOutlet NSLayoutConstraint *titlePositionConstraint;
    __weak IBOutlet NSLayoutConstraint *titleLeftConstraint;
}

- (void) set:(PopupSelectionLogoItemModel *)itemModel owner:(PopupSelectionLogoTextView *)owner {
    _itemModel = itemModel;
    _controller = owner;
    
    [self.titleLabel styleSet:itemModel.title andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    if (itemModel.subtitle && itemModel.subtitle.length > 0) {
        titlePositionConstraint.constant = 9.0f;
        [self.subtitleLabel styleSet:itemModel.subtitle andButtonType:FontDataType_MediumItalic_14_BlackAlpha_NoSpace];
    }
    else {
        titlePositionConstraint.constant = 15.0f;
        self.subtitleLabel.text = @"";
    }
    
    [self.checkIcon setImage:itemModel.selected ? [UIImage imageNamed:@"CheckMark"] : [UIImage imageNamed : @"CheckmarkEmptyIcon"]];
    
    if (itemModel.displayLogo) {
        [self.logoImage setImage:itemModel.logoImage];
        titleLeftConstraint.constant = 75;
    }
    else {
        [self.logoImage setHidden:YES];
        titleLeftConstraint.constant = 15;
    }
    
    if ([itemModel.dynamicModel isKindOfClass:[DeviceModel class]]) {
        [self configureImageIconWithDeviceModel:(DeviceModel*)itemModel.dynamicModel];
    }
}

- (void)configureImageIconWithDeviceModel:(DeviceModel *)model {
    UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:model.modelId
                                                                 atSize:[UIScreen mainScreen].bounds.size
                                                              withScale:[UIScreen mainScreen].scale];
    
    if (image) {
        image = [image exactZoomScaleAndCutSizeInCenter:self.logoImage.bounds.size];
        image = [image roundCornerImageWithsize:self.logoImage.bounds.size];
        
        self.logoImage.layer.cornerRadius = self.logoImage.bounds.size.width / 2.0f;
        self.logoImage.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f].CGColor;
        self.logoImage.layer.borderWidth = 2.0f;
        
        [self.logoImage setImage:image];
    }
    else {
        
        [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:model] withDevTypeId:[model devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
            self.logoImage.image = [image invertColor];
        });
    }
}

@end
