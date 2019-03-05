//
//  PeopleDetailViewController.m
//  i2app
//
//  Created by Arcus Team on 9/24/15.
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
#import "PeopleDetailViewController.h"
#import "PersonCapability.h"

#import <PureLayout/PureLayout.h>
#import "AKFileManager.h"
#import "ImagePicker.h"
#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"

#import "UIView+Subviews.h"
#import "CommonTitleValueonRightCell.h"
#import "PeopleModelManager.h"
#import "PeopleRemoveViewController.h"
#import "PeopleContactInformationViewController.h"
#import "PinCodeEntryViewController.h"

#define centerViewSize (self.personSwitchArea.frame.size.width / 35) * 25
#define displayPercentage 0.86f
#define edgeOverViewPercentage 1.5f
#define logoViewTag 10

typedef enum {
    PersonViewPositionCenter = 0,
    PersonViewPositionLeft,
    PersonViewPositionRight,
} PersonViewPosition;

@interface PeopleDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *personSwitchArea;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PeopleDetailViewController {
    NSLayoutConstraint *_leftPosition;
    NSLayoutConstraint *_centerPosition;
    NSLayoutConstraint *_rightPosition;
    
    UIView *_leftView;
    UIView *_centerView;
    UIView *_rightView;
    
    NSMutableArray  *_personInfoList;
}

#pragma mark - View LifeCycle

+ (PeopleDetailViewController *)create:(PeopleModelManager *)manager {
    PeopleDetailViewController *vc = [[UIStoryboard storyboardWithName:@"PeopleSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.manager = manager;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setNavBarTitle:self.navigationItem.title];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self addBackButtonItemAsLeftButtonItem];
    [self.personSwitchArea setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeftRecognizer.delegate = self;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    self.tableView.scrollEnabled = NO;
    
    [self displayInformation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self displayPeople];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (UIView *subview in self.personSwitchArea.subviews) {
        [subview removeFromSuperview];
    }
    [self.view layoutIfNeeded];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (_manager.people.count == 1) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized && gestureRecognizer.view == self.view) {
        
        [UIView animateWithDuration:0.5f animations:^{
            _leftPosition.constant = 0;
            _centerPosition.constant = centerViewSize * displayPercentage;
            _rightPosition.constant = centerViewSize * edgeOverViewPercentage;
            
            [self setToEdge:_centerView];
            [self setToCenter:_leftView];
            
            [self.view setAlpha:1.0f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (_rightView) {
                [_rightView removeFromSuperview];
            }
            
            _rightPosition = _centerPosition;
            _centerPosition = _leftPosition;
            _rightView = _centerView;
            _centerView = _leftView;
            
            // Add new view on left
            [_manager setCurrentTo:[_manager getPrevious]];
            _leftView = [self generatePersonView:[_manager getPrevious] position:PersonViewPositionLeft];
            _leftPosition.constant = centerViewSize * -edgeOverViewPercentage;
            [self setToEdge:_leftView];
            [self setBackgroundImageWithCurrectPerson];
            [self.view layoutIfNeeded];
            
            [UIView animateWithDuration:0.1f animations:^{
                _leftPosition.constant = centerViewSize * -displayPercentage;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }];
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (_manager.people.count == 1) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized && gestureRecognizer.view == self.view) {

        if (!_rightPosition || !_rightView) return;
        
        [UIView animateWithDuration:0.5f animations:^{
            _rightPosition.constant = 0;
            _centerPosition.constant = centerViewSize * -displayPercentage;
            if (_leftPosition) {
                _leftPosition.constant = centerViewSize * -edgeOverViewPercentage;
            }
            
            [self setToEdge:_centerView];
            [self setToCenter:_rightView];
            
            [self.view setAlpha:1.0f];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (_leftView) {
                [_leftView removeFromSuperview];
            }
            
            _leftPosition = _centerPosition;
            _centerPosition = _rightPosition;
            _leftView = _centerView;
            _centerView = _rightView;
            
            // Add new view on right
            [_manager setCurrentTo:[_manager getNext]];
            _rightView = [self generatePersonView:[_manager getNext] position:PersonViewPositionRight];
            _rightPosition.constant = centerViewSize * edgeOverViewPercentage;
            [self setToEdge:_rightView];
            [self setBackgroundImageWithCurrectPerson];
            [self.view layoutIfNeeded];
            
            [UIView animateWithDuration:0.1f animations:^{
                _rightPosition.constant = centerViewSize * displayPercentage;
                
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark - dynamic view -assist methods

- (UIView *)generatePersonView:(PersonModel *)model position:(PersonViewPosition)position {
    if (!model) {
        return nil;
    }
    UIView *personView = [[UIView alloc] initForAutoLayout];
    UIImageView *personLogo = [[UIImageView alloc] initForAutoLayout];
    UILabel *personNameLabel = [[UILabel alloc] initForAutoLayout];
    UILabel *personTitleLabel = [[UILabel alloc] initForAutoLayout];
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:[UIImage imageNamed:@"CameraIcon"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    
    [personView addSubview:personLogo];
    [personView addSubview:personNameLabel];
    [personView addSubview:personTitleLabel];
    [personView addSubview:cameraBtn];
    
    [self.personSwitchArea addSubview:personView];
    
    // Layout
    [personLogo autoSetDimensionsToSize:CGSizeMake(200, 200)];
    [personLogo autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:personView withOffset:28];
    [personLogo autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [personLogo setTag:logoViewTag];
    
    [personNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:personLogo withOffset:28];
    [personNameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [personTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:personNameLabel withOffset:1];
    [personTitleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [cameraBtn setContentMode:UIViewContentModeCenter];
    [cameraBtn autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [cameraBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:personLogo withOffset:-40];
    [cameraBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:personLogo withOffset:10];
    
    [personView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [personView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [personView autoSetDimension:ALDimensionWidth toSize:centerViewSize];
    
    NSLayoutConstraint *tempConstaint = [personView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    switch (position) {
        case PersonViewPositionCenter:
            _centerPosition = tempConstaint;
            break;
        case PersonViewPositionLeft:
            _leftPosition = tempConstaint;
            break;
        case PersonViewPositionRight:
            _rightPosition = tempConstaint;
            break;
        default:
            break;
    }
    
    // Setting value
    UIImage *cachedImage = [model image];
    if (cachedImage) {
        cachedImage = [cachedImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
        cachedImage = [cachedImage roundCornerImageWithsize:CGSizeMake(190, 190)];
    }
    UIImage *image = cachedImage != nil? cachedImage : [[UIImage imageNamed:@"account_user"] invertColor];

    [personLogo setImage:image];
    [personNameLabel styleSet:model.fullName andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] upperCase:YES];
    [personTitleLabel styleSet:model.getSubtitle andFontData:[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO space:NO alpha:YES]];
    
    [self.personSwitchArea layoutIfNeeded];
    [self.view layoutIfNeeded];

    [personLogo setClipsToBounds:NO];
    personLogo.layer.cornerRadius = personLogo.bounds.size.width / 2.0f;
    personLogo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
    personLogo.layer.borderWidth = 3.0f;
    
    return personView;
}

- (UIView *)getCurrentLogo {
    for (UIView *item in _centerView.subviews) {
        if (item.tag == logoViewTag) {
            return item;
        }
    }
    return [UIView new];
}

- (void)setToEdge:(UIView *)personView {

    UIView *logo = [personView getSubviewByTag:logoViewTag];
    if (IS_IPHONE_5) {
        logo.layer.transform = CATransform3DMakeScale(.55, .55, 1);
    }
    else {
        logo.layer.transform = CATransform3DMakeScale(.65, .65, 1);
    }
    for (UIView *item in [personView getSubviewsExcludeTag:logoViewTag]) {
        [item setAlpha:0.0f];
    }
}

- (void)setToCenter:(UIView *)personView {
    UIView *logo = [personView getSubviewByTag:logoViewTag];
    logo.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    for (UIView *item in [personView getSubviewsExcludeTag:logoViewTag]) {
        [item setAlpha:1.0f];
    }
}

// TODO: slide swtich operation
#pragma mark - dynamic view - displaying methods

- (void)displayPeople {
    for (UIView *subview in self.personSwitchArea.subviews) {
        [subview removeFromSuperview];
    }
    [self.view layoutIfNeeded];
    [self.view setAlpha:0.0f];
    
    _centerView = [self generatePersonView:[_manager getCurrent] position:PersonViewPositionCenter];
    
    if (_manager.people.count > 0) {
        if (_manager.people.count == 1) {
            
            [UIView animateWithDuration:0.5f animations:^{
                _rightPosition.constant = centerViewSize * displayPercentage;
                
                [self.view layoutIfNeeded];
                [self.view setAlpha:1.0f];
            } completion:^(BOOL finished) {
                [self displayInformation];
            }];
        }
        else {
            _rightView = [self generatePersonView:[_manager getNext] position:PersonViewPositionRight];
            _leftView = [self generatePersonView:[_manager getPrevious] position:PersonViewPositionLeft];
            
            [self setToEdge:_rightView];
            [self setToEdge:_leftView];
            [UIView animateWithDuration:0.5f animations:^{
                _leftPosition.constant = centerViewSize * -displayPercentage;
                _rightPosition.constant = centerViewSize * displayPercentage;
                
                [self.view setAlpha:1.0f];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self displayInformation];
            }];
        }
        [self setBackgroundImageWithCurrectPerson];
    }
    else {
        [self displayInformation];
        [self setBackgroundColorToLastNavigateColor];
    }
}

- (void)displayInformation {
    _personInfoList = [[NSMutableArray alloc] init];
    [_personInfoList addObject:@{@"title":@"Contact Information", @"onClick":[NSValue valueWithPointer:@selector(contactInformation)]}];
    [_personInfoList addObject:@{@"title":@"Pin Code", @"onClick":[NSValue valueWithPointer:@selector(pinCode)]}];
    [_personInfoList addObject:@{@"title":@"Remove Person", @"onClick":[NSValue valueWithPointer:@selector(removePerson)]}];
    
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
}

- (void)setBackgroundImageWithCurrectPerson {
    UIImage *cachedImage = [[_manager getCurrent] image];
    if (cachedImage) {
        cachedImage = [cachedImage backgroundZoomScaleAndCutSizeInCenter:[UIScreen mainScreen].bounds.size];
        cachedImage = [cachedImage applyLightEffect];
        self.view.backgroundColor = [UIColor colorWithPatternImage:cachedImage];
    }
    else {
        [self setBackgroundColorToLastNavigateColor];
    }
}

#pragma mark - actions 

- (void)contactInformation {
    PeopleContactInformationViewController *information = [PeopleContactInformationViewController create:_manager];
    [self.navigationController pushViewController:information animated:YES];
}

- (void)pinCode {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    PinCodeEntryViewController *vc = [PinCodeEntryViewController create];
#pragma clang diagnostic pop
    vc.pinViewMode = EnterPinViewModePersonUpdateFirstEntry;
    vc.updatePersonModel = _manager.getCurrent;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)removePerson {
    PeopleRemoveViewController *controller = [PeopleRemoveViewController create:_manager];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)openCamera {
    [[ImagePicker sharedInstance] presentImagePickerInViewController:self withImageId:@"PersonID" withCompletionBlock:^(UIImage *image) {
        if ([image isKindOfClass:[UIImage class]]) {
            [[AKFileManager defaultManager] cacheImage:image forHash:[_manager getCurrent].modelId];
            [self.view renderLogoAndBackgroundWithImage:image forLogoControl:[self getCurrentLogo]];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _personInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTitleValueonRightCell *cell = [CommonTitleValueonRightCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    NSDictionary *cellItem = _personInfoList[indexPath.row];
    [cell setWhiteTitle:[cellItem[@"title"] uppercaseString]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cellItem = _personInfoList[indexPath.row];
    if (cellItem[@"onClick"]) {
        SEL cmd = [cellItem[@"onClick"] pointerValue];
        [self performSelector:cmd withObject:nil afterDelay:0];
    }
}



@end
