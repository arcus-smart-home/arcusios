//
//  PeopleRemoveViewController.m
//  i2app
//
//  Created by Arcus Team on 9/28/15.
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
#import "PeopleRemoveViewController.h"



#import "PersonCapability.h"
#import "PlaceCapability.h"
#import "PeopleModelManager.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+ScaleSize.h"

#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"

@interface PeopleRemoveViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *personIcon;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *removingIntroductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

@property (strong, nonatomic) PeopleModelManager *manager;

@end

@implementation PeopleRemoveViewController {
    PopupSelectionWindow *_popupWindow;
}

+ (PeopleRemoveViewController *)create:(PeopleModelManager *)manager {
    PeopleRemoveViewController *vc = [[UIStoryboard storyboardWithName:@"PeopleSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.manager = manager;
    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.title = @"Remove person";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setNavBarTitle:self.title];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self addBackButtonItemAsLeftButtonItem];
    
    UIImage *cachedImage = [[_manager getCurrent] image];
    if (cachedImage) {
        cachedImage = [cachedImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(190, 190)];
        cachedImage = [cachedImage roundCornerImageWithsize:CGSizeMake(190, 190)];
    }
    UIImage *image = cachedImage != nil? cachedImage : [UIImage imageNamed:@"userIcon"];
    [_personIcon setImage:image];
    [_personIcon setClipsToBounds:NO];
    _personIcon.layer.cornerRadius = _personIcon.bounds.size.width / 2.0f;
    _personIcon.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
    _personIcon.layer.borderWidth = 2.0f;
    
    [self.personNameLabel styleSet:[_manager getCurrent].fullName andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] upperCase:YES];
    [self.personTitleLabel styleSet:NSLocalizedString(@"Friend", nil) andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO alpha:YES]];
    
    NSString *introduction = NSLocalizedString(@"Removing this account means this person will no longer have access to '%@'", nil);
    introduction = [NSString stringWithFormat:introduction,[PlaceCapability getNameFromModel:[[CorneaHolder shared] settings].currentPlace]];
    
    [self.removingIntroductionLabel styleSet:introduction andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:NO]];
    
    [self.removeButton styleSet:@"Remove Person" andButtonType:FontDataTypeButtonLight upperCase:YES];
}

- (IBAction)onClickRemove:(id)sender {
    PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"ARE YOU SURE", nil) subtitle:NSLocalizedString(@"This cannot be undone", nil) button:[PopupSelectionButtonModel create:NSLocalizedString(@"YES", nil) event:@selector(doRemovePerson)], [PopupSelectionButtonModel create:NSLocalizedString(@"NO", nil) event:nil], nil];
    buttonView.owner = self;
    
    _popupWindow = [PopupSelectionWindow popup:self.view
                                       subview:buttonView
                                         owner:self
                                 closeSelector:nil
                                         style:PopupWindowStyleCautionWindow];
}

- (void)doRemovePerson {
    [self createGif];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [PersonController deletePerson:[_manager getCurrent]].thenInBackground(^(NSObject *persons) {
            [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSArray *personList) {
                _manager.people = [PersonModel filterOwner:personList];;
                [self hideGif];
                if (_manager.people.count == 0) {
//                    for (UIViewController *controller in self.navigationController.viewControllers) {
//                        if ([controller isKindOfClass:[SettingsMainViewController class]]) {
//                            [self.navigationController popToViewController:controller
//                                                                  animated:YES];
//                            break;
//                        }
//                    }
                }
                else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }).catch(^(NSObject *error) {
            
        });
    });
}

@end
