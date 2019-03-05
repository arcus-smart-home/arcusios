//
//  TiltSensorPairingStepViewController.m
//  i2app
//
//  Created by Arcus Team on 10/6/15.
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
#import "TiltSensorPairingStepViewController.h"
#import "DeviceController.h"
#import "DevicePairingManager.h"
#import "ImagePaths.h"
#import "UIImage+ImageEffects.h"
#import "AKFileManager.h"
#import "SDWebImageManager.h"

@interface TiltSensorPairingStepViewController()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * settingArray;
@property (strong, nonatomic) DeviceModel *model;


- (IBAction)nextButtonPressed:(id)sender;

@end

@implementation TiltSensorPairingStepViewController {
    UIImage *_selectedImage;
    __weak IBOutlet NSLayoutConstraint *tableToImageConstraint;

}

+ (instancetype)createWithDeviceStep:(PairingStep *)step device:(DeviceModel*)deviceModel {
    TiltSensorPairingStepViewController *vc = [self createWithDeviceStep:step];
    vc.model = deviceModel;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackgroundColorToParentColor];
    
    if (self.model) {
        [self navBarWithBackButtonAndTitle:self.model.name];
        
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:self.model.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            _selectedImage = image;
            if (![self.view renderLogoAndBackgroundWithImage:_selectedImage forLogoControl:self.mainPhoto]) {
                image = nil;
            }
        }
        if (!image) {
            [self setBackgroundColorToDashboardColor];
            
            NSString *urlString = [ImagePaths getLargeProductImageFromDevTypeHint:[self.model devTypeHintToImageName]];
            if (urlString) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        image = [image invertColor];
                        _selectedImage = image;
                        [_mainPhoto setImage:image];
                    }
                }];
            }
        }
    }
    
    _selectedImage = nil;

    if (IS_IPHONE_5) {
        tableToImageConstraint.constant = 10;
    }
    
    [self navBarWithBackButtonAndTitle:self.model.name];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.separatorColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.tableView.scrollEnabled = NO;

     [_nextButton styleSet:NSLocalizedString(@"next", nil)
             andButtonType:FontDataTypeButtonDark
                 upperCase:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];

    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                               inSection:0]];
}

- (void)loadData {
    self.settingArray = [[NSMutableArray alloc] initWithArray:@[
                                                                [[NSMutableDictionary alloc] initWithDictionary: @{@"title": NSLocalizedString(@"Horizontal (EX:Garage Door)", nil), @"check": @(YES)}],
                                                                [[NSMutableDictionary alloc] initWithDictionary: @{@"title": NSLocalizedString(@"Vertical (EX:Jewelry box)", nil), @"check": @(NO)}]]];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TiltSelectionViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSMutableDictionary *item = [self.settingArray objectAtIndex:indexPath.item];
    [cell setTitle:[item objectForKey:@"title"] checked:[[item objectForKey:@"check"] boolValue]];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        for (NSMutableDictionary *item in self.settingArray) {
            [item setObject:@(NO) forKey:@"check"];
        }
        
        NSDictionary *item = [self.settingArray objectAtIndex:indexPath.item];
        
        if ([[item objectForKey:@"title"] containsString:@"Horizontal"]) {
            [DeviceController setTiltClosedPosition:YES onModel:self.model].then(^(NSObject *obj) {
                [[self.settingArray objectAtIndex:indexPath.row] setObject:@(YES) forKey:@"check"];
                [self.tableView reloadData];
            });
            }
        else {
            [DeviceController setTiltClosedPosition:NO onModel:self.model].then(^(NSObject *obj) {
                [[self.settingArray objectAtIndex:indexPath.row] setObject:@(YES) forKey:@"check"];
                [self.tableView reloadData];
            });
        }
    });

}



- (IBAction)nextButtonPressed:(id)sender {
    [super nextButtonPressed:sender];
}
@end


@implementation TiltSelectionViewControllerCell

- (void)setTitle:(NSString *)title checked:(BOOL)checked {
    [self.titleLabel styleSet:title andButtonType:FontDataTypeDeviceKeyfobSettingSheetTitle];
    [self.checkButton setSelected:checked];
}

@end
