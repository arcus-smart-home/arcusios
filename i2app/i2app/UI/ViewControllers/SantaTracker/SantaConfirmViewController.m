//
//  SantaConfirmViewController.m
//  i2app
//
//  Created by Arcus Team on 11/5/15.
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
#import "SantaConfirmViewController.h"
#import "SantaConfirmViewControllerCell.h"
#import "SantaTracker.h"
#import "NSDate+Convert.h"
#import "NSDate+TimeAgo.h"
#import "UIImage+ImageEffects.h"
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionWindow.h"
#import "FullScreenImageView.h"

#import <QuartzCore/QuartzCore.h>

@interface SantaConfirmViewController ()

@property (nonatomic, strong) IBOutlet UIView *imageViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *imagesLabel;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *photoImageHeightConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *snataWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *santaVisitTime;

@property (nonatomic, strong) NSArray *participatingDevices;

@end

@implementation SantaConfirmViewController {
    PopupSelectionWindow *_popup;
}

#pragma mark - View LifeCycle

+ (SantaConfirmViewController *)create {
    SantaConfirmViewController *vc = [[UIStoryboard storyboardWithName:@"SantaTracker" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithCloseButtonAndTitle:@"Santa Tracker™"];
    
    [self.tableView setBackgroundView:[UIView new]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];

    NSDate *openingDate = [SantaTracker dynamicVisitTime];

    [self.santaVisitTime setText:[openingDate formatBasedOnDayOfWeekAndHoursIncludingToday]];
  
    UIImage *santaImage = [[SantaTracker shareInstance] getSantaImage];
    if (santaImage) {
        [self.imageView setImage:santaImage];
        
        if (IS_IPAD) {
            self.photoImageHeightConstraint.constant *= 2;
            self.snataWidthConstraint.constant *= 2;
        }
    }
    else {
        for (UIView *item in _imagesLabel) {
            [item setHidden:YES];
        }
        [_saveButton setHidden:YES];
    }
}

#pragma mark - Getters & Setters

- (NSArray *)participatingDevices {
    if (!_participatingDevices) {
        _participatingDevices = [[SantaTracker shareInstance] participatingDevices];
    }
    return _participatingDevices;
}

- (IBAction)onClickSantaImage:(id)sender {    
    [self presentViewController:[FullScreenImageView createWithImage:[self imageWithView:self.imageViewContainer]] animated:YES completion:nil];
}
- (IBAction)onClickSaveSantaImage:(id)sender {
    if ([[SantaTracker shareInstance] getSantaImage]) {
        UIImage *photo = [UIImage imageFromLayer:self.imageViewContainer.layer];
        UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
        
        PopupSelectionButtonsView *message = [PopupSelectionButtonsView createWithTitle:@"Saved Photo" subtitle:@"Santa photo saved. Open the Photos app to view the picture." button:nil];
        _popup = [PopupSelectionWindow popup:self.view subview:message];
    }
}

- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.participatingDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIndentifier = @"cell";
    
    SantaConfirmViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if (!cell) {
        cell = [[SantaConfirmViewControllerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
        
    SantaHistoryItemModel *itemModel = [self.participatingDevices objectAtIndex:indexPath.row];
    NSString *title = itemModel.title;
    NSString *subtitle = @"Santa Detected";
    
    switch (itemModel.type) {
        case SantaReindeerSensor:
            subtitle = @"Reindeer hooves detected";
            break;
        case SantaChimneySensor:
            subtitle = @"Motion detected near base";
            break;
        case SantaMilkCookiesSensor:
            subtitle = @"Depletion of milk & cookies";
            break;
        case SantaChristmasStockingSensor:
            subtitle = @"Movement detected";
            break;
        case SantaChristmasTreeSensor:
            subtitle = @"Movement detected";
            break;
        case SantaContactSensor:
            subtitle = @"Opened";
            break;
        case SantaMotionSensor:
            subtitle = @"Movement detected";
            break;
    }
        
    title = [title uppercaseString];

    NSDate *openingDate = [SantaTracker dynamicVisitTime];
    
    [cell.timeLabel styleSet:[openingDate formatDateTimeStamp] andFontData:[FontData createFontData:FontTypeMedium size:12 blackColor:NO alpha:YES]];
    [cell.titleLabel styleSet:title andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES]];
    [cell.subtitleLabel styleSet:subtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO alpha:YES]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
