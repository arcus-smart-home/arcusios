//
//  AlertActionSheetViewController.m
//  i2app
//
//  Created by Arcus Team on 9/17/15.
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
#import "AlertActionSheetViewController.h"
#import "UIImage+ImageEffects.h"


@interface AlertActionSheetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIView *tipArea;
@property (weak, nonatomic) IBOutlet UILabel *tipTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipSubtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arcusIcon;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIView *additionalContent;
@property (weak, nonatomic) IBOutlet UIView *fullSeparator;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic) AlertActionType type;

@property (nonatomic, strong) NSTimer *dismissTimer;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipAreaHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBottomToParentConstraint;

@end

@implementation AlertActionSheetViewController

+ (AlertActionSheetViewController *)create:(AlertActionType)type {
    AlertActionSheetViewController *vc = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.type = type;
    return vc;
}

- (NSString *)description {
    return NSStringFromClass([self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == AlertActionTypeInternetERROR) {
        self.dismissTimer = [NSTimer timerWithTimeInterval:5.0f
                                                    target:self
                                                  selector:@selector(dismissTimerAction)
                                                  userInfo:nil
                                                   repeats:YES];
    }
    
    [self buildGradientView];
    [self hideBackButton];
    _tipArea.layer.shadowColor = [UIColor blackColor].CGColor;
    _tipArea.layer.shadowOffset = CGSizeMake(-5, 0);
    _tipArea.layer.shadowRadius = 20.0f;

    if (IS_IPHONE_5) {
        self.tipAreaHeightConstraint.constant = 200;
        self.iconBottomToParentConstraint.constant = 10;
    }

    [self loadData];
}

- (void)dismissTimerAction {
  // TODO:  Need to verify that this is no longer needed.
//    if ([SessionController sessionIsOpen]) {
//        [self.dismissTimer invalidate];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (void)loadData {
    switch (self.type) {
        case AlertActionTypeInternetERROR:
            [self setupViewsNoInternet];
            break;
            
        case AlertActionTypePremimumRuleTEASER:
            [self setupViewsPremiumRuleAndScene];
        
            break;
        
        case AlertActionTypePremimumFobTEASER:
            [self setupViewsPremimuFob];
            
            break;
        
        case AlertActionTypePremimumSceneTEASER:
            [self setupViewsPremiumRuleAndScene];
            
            break;
        
        case AlertActionTypePremiumCareTEASER:
            [self setupViewsPremiumCare];
            
            break;
            
        default:
            break;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma  mark - setup views
- (void)buildGradientView {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.bounds;
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    
    switch (self.type) {
        case AlertActionTypePremiumCareTEASER:
            self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:155.0/255.0 green:70.0/255.0 blue:138.0/255.0 alpha:1.0].CGColor,
                                          (__bridge id)[UIColor colorWithRed:85.0/255.0 green:116.0/255.0 blue:185.0/255.0 alpha:1.0].CGColor];
            self.gradientLayer.locations = nil;
            break;
            
        default:
            self.gradientLayer.colors = @[(__bridge id)pinkAlertColor.CGColor,
                                          (__bridge id)[UIColor whiteColor].CGColor];
            self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
            break;
    }
    
    
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}


- (void)setupViewsNoInternet {
    _closeButton.hidden = YES;
    
    [_titleLabel styleSet:NSLocalizedString(@"NO Internet connection",nil) andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    [_subtitleLabel styleSet:NSLocalizedString(@"Please check your internet connection and make sure you are not in airplane mode.",nil) andButtonType:FontDataType_DemiBold_18_White_NoSpace];
    
    [_tipTitleLabel styleSet:NSLocalizedString(@"Tip #48",nil) andButtonType:FontDataType_Medium_14_Black upperCase:YES];
    [_tipSubtitleLabel styleSet:NSLocalizedString(@"Monitor the temperature in your crawl space using a contact or motion sensor.",nil) andButtonType:FontDataType_DemiBold_18_BlackAlpha_NoSpace];
    
}

- (void)setupViewsPremiumRuleAndScene {
  
  
    [self.gradientLayer removeFromSuperlayer];
    self.view.backgroundColor = [UIColor whiteColor];
  
  
    _closeButton.hidden = NO;
    [_closeButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];

    self.iconImage.hidden = YES;
    _titleLabel.hidden = YES;
    _subtitleLabel.hidden = YES;
    self.fullSeparator.hidden = NO;
  
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"PremiumRequiredSubcontent" owner:self options:nil] objectAtIndex:0];
    [self.additionalContent addSubview:view];
  
  
    [_tipSubtitleLabel styleSet:NSLocalizedString(@"",nil) andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:YES space:NO]];
    _tipSubtitleLabel.alpha = 0.60;
}

- (void)setupViewsPremimuFob {
    [self.iconImage setImage: [[UIImage imageNamed:@"icon_rules"] invertColor]];
    _closeButton.hidden = NO;
    [_titleLabel styleSet:NSLocalizedString(@"Premium required", nil) andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    NSMutableArray<NSString *> *texts = [[NSMutableArray alloc] init];
    [texts addObject:NSLocalizedString(@"Experience one-touch automation for when arriving home, headind out, going to sleep and more. \n\n",nil)];
    [texts addObject:NSLocalizedString(@"Going to work? Adjust the thermostat, lock up close the garage door, set the alarm and turn off the lights with single tap. \n",nil)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", texts[0], texts[1]]];
    [string addAttributes:[[FontData createFontData:FontTypeDemiBold size:16 blackColor:NO space:NO alpha:NO] getFontDictionary] range:NSMakeRange(0, texts[0].length)];

    [string addAttributes:[[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO space:YES alpha:YES] getFontDictionary] range:NSMakeRange(texts[0].length, texts[1].length)];

    [_subtitleLabel setAttributedText:string];

    [_tipSubtitleLabel styleSet:NSLocalizedString(@"",nil) andFontData:[FontData createFontData:FontTypeMedium size:16 blackColor:YES space:NO]];
}

- (void)setupViewsPremiumCare {
    [_iconImage setImage:[UIImage imageNamed:@"care"]];
    [_iconImage setTintColor:[UIColor whiteColor]];
    _closeButton.hidden = NO;
    
    _separator.hidden = NO;
    
    [_titleLabel styleSet:NSLocalizedString(@"Feature Not Available on Current Plan",nil) andButtonType:FontDataType_DemiBold_12_White upperCase:YES];
    
    NSMutableArray<NSString *> *texts = [[NSMutableArray alloc] init];
    [texts addObject:NSLocalizedString(@"Care helps you monitor your loved ones' daily routines.\n\n\n",nil)];
    [texts addObject:NSLocalizedString(@"No Activity Detected\n",nil).uppercaseString];
    [texts addObject:NSLocalizedString(@"Trigger an alarm if no movement occurs at times when you normally expect movement.\n\n",nil)];
    [texts addObject:NSLocalizedString(@"Curfew\n",nil).uppercaseString];
    [texts addObject:NSLocalizedString(@"Trigger a Care Alarm when a loved one is not home by a certain time.",nil)];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@%@%@", texts[0], texts[1],texts[2],texts[3],texts[4]]];
    
    [string addAttributes:[[FontData createFontData:FontTypeMedium size:18 blackColor:NO space:NO alpha:NO] getFontDictionary] range:NSMakeRange(0,texts[0].length)];
    [string addAttributes:[[FontData createFontData:FontTypeDemiBold size:12 blackColor:NO space:YES alpha:NO] getFontDictionary] range:NSMakeRange(texts[0].length, texts[1].length)];
    [string addAttributes:[[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO space:NO alpha:YES] getFontDictionary] range:NSMakeRange(texts[0].length + texts[1].length, texts[2].length)];
    [string addAttributes:[[FontData createFontData:FontTypeDemiBold size:12 blackColor:NO space:YES alpha:NO] getFontDictionary] range:NSMakeRange(texts[0].length + texts[1].length + texts[2].length,texts[3].length)];
    [string addAttributes:[[FontData createFontData:FontTypeMediumItalic size:14 blackColor:NO space:NO alpha:YES] getFontDictionary] range:NSMakeRange(texts[0].length + texts[1].length + texts[2].length + texts[3].length, texts[4].length)];
    
    [_subtitleLabel setAttributedText:string];
    
    
    [_tipSubtitleLabel styleSet:NSLocalizedString(@"",nil) andFontData:[FontData createFontData:FontTypeMedium size:18 blackColor:NO space:NO]];
    
    _tipArea.backgroundColor = [UIColor clearColor];
}

- (IBAction)onClickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
