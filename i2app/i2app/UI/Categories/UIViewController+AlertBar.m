//
//  UIViewController+AlertBar.m
//  i2app
//
//  Created by Arcus Team on 6/3/15.
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
#import "UIViewController+AlertBar.h"

#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "UIViewController+AlertBar.h"
#import "UIColor+Convert.h"
#import <PureLayout/PureLayout.h>
#import "UIControl+Event.h"
#import <objc/runtime.h>
#import <i2app-Swift.h>

@implementation UIViewController(AlertBar)

NSInteger           _tagIndex;
NSMutableArray<UIView *>      *_subViews;

static char _aDisableAlert;

- (void)setDisableAlert:(BOOL)enable {
    objc_setAssociatedObject(self, &_aDisableAlert, @(enable), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)getIsDisabled {
    NSNumber *disable = objc_getAssociatedObject(self, &_aDisableAlert);
    if (!disable) {
        return NO;
    } else {
        return [disable boolValue];
    }
}

- (BOOL)isDisplayingAlert {
    return (_subViews && [_subViews count] > 0);
}

- (NSInteger) getNextTag {
    if (_tagIndex + 1 == NSIntegerMax) {
        _tagIndex = 0;
    }
    return ++_tagIndex;
}

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene withDuration:(int)time {
    NSInteger tag = [self popupAlert:message
                                type:type
                            canClose:NO
                           sceneType:scene];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(closePopupAlertWithTimer:)
                                   userInfo:@(tag)
                                    repeats:NO];
    
    return -1;
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable {
    return [self popupAlert:message
                       type:type
                   canClose:closeable
                      under:20];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
                  under:(CGFloat)top {
    return [self popupAlert:message
                       type:type
                   canClose:closeable
                      under:top
               bottomButton:nil
                   selector:nil];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
              sceneType:(AlertBarSceneType)scene {
    if (scene != AlertBarSceneUndefined) {
        BOOL displayGrayScaleCover = (AlertBarTypeNoConnection == type);
        return [self popupAlert:message
                           type:type
                       canClose:closeable
                          under:[self distanceToTopForSceneType:scene]
                   bottomButton:nil grayScale:displayGrayScaleCover
                       selector:nil];
    }
    
    return -1;
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
              grayScale:(BOOL)grayScale
              sceneType:(AlertBarSceneType)scene {
    if (scene != AlertBarSceneUndefined) {
        return [self popupAlert:message
                           type:type
                      sceneType:scene
                       canClose:closeable
                          under:[self distanceToTopForSceneType:scene]
                   bottomButton:nil
                      grayScale:grayScale
                       selector:nil
                       priority:1];
    }
    
    return -1;
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
              sceneType:(AlertBarSceneType)scene
           bottomButton:(NSString *)bottomButton
               selector:(SEL)selector {
    if (scene != AlertBarSceneUndefined) {
        return [self popupAlert:message
                           type:type
                       canClose:closeable
                          under:[self distanceToTopForSceneType:scene]
                   bottomButton:bottomButton
                       selector:selector];
    }
    
    return -1;
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
              sceneType:(AlertBarSceneType)scene
           bottomButton:(NSString *)bottomButton
               selector:(SEL)selector
               priority:(NSInteger)priority {
    if (scene != AlertBarSceneUndefined) {
        return [self popupAlert:message
                           type:type
                       canClose:closeable
                          under:[self distanceToTopForSceneType:scene]
                   bottomButton:bottomButton
                       selector:selector
                       priority:priority];
    }

    return -1;
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
              sceneType:(AlertBarSceneType)scene
           bottomButton:(NSString *)bottomButton
              grayScale:(BOOL)grayScale
               selector:(SEL)selector {
    
    return [self popupAlert:message
                       type:type
                   canClose:NO
                  sceneType:scene
               bottomButton:bottomButton
                  grayScale:grayScale
                   selector:selector];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
              sceneType:(AlertBarSceneType)scene
           bottomButton:(NSString *)bottomButton
              grayScale:(BOOL)grayScale selector:(SEL)selector {
    CGFloat alertBarPosition = [self distanceToTopForSceneType:scene];
    
    return [self popupAlert:message
                       type:type
                  sceneType:scene
                   canClose:closeable
                      under:alertBarPosition
               bottomButton:bottomButton
                  grayScale:grayScale
                   selector:selector
                   priority:1];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
                  under:(CGFloat)top
           bottomButton:(NSString *)bottomButton
              grayScale:(BOOL)grayScale
               selector:(SEL)selector {

    return [self popupAlert:message
                       type:type
                  sceneType:AlertBarSceneUndefined
                   canClose:closeable
                      under:top
               bottomButton:bottomButton
                  grayScale:grayScale
                   selector:selector
                   priority:1];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
               canClose:(BOOL)closeable
                  under:(CGFloat)top
           bottomButton:(NSString *)bottomButton
              grayScale:(BOOL)grayScale
               selector:(SEL)selector
               priority:(NSInteger)priority {

    return [self popupAlert:message
                       type:type
                  sceneType:AlertBarSceneUndefined
                   canClose:closeable
                      under:top
               bottomButton:bottomButton
                  grayScale:grayScale
                   selector:selector
                   priority:priority];
}

- (NSInteger)popupAlert:(NSString *)message
                   type:(AlertBarType)type
              sceneType:(AlertBarSceneType)scene
               canClose:(BOOL)closeable
                  under:(CGFloat)top
           bottomButton:(NSString *)bottomButton
              grayScale:(BOOL)grayScale
               selector:(SEL)selector
               priority:(NSInteger)priority {
    
    if ([self getIsDisabled]) {
        return -1;
    }
    
    NSMutableArray *bufferViews = [[NSMutableArray alloc] init];
    
    if (!_subViews) {
        _subViews = [[NSMutableArray alloc] init];
    }
    
    NSInteger currentTag = [self getNextTag];
    UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    if (grayScale) {
        CGFloat bottomInset = 0.0f;
        if (scene == AlertBarSceneInDevice) {
            bottomInset = 44.0f;
        }

        UIView *grayCover = [self makeGrayViewWithTopInset:root.view topInset:top rightInset:0 bottomInset:bottomInset leftInset:0];
        [grayCover setTag:currentTag];
        [bufferViews addObject:grayCover];
    }
    
    UIView *alertBar =  [UIView newAutoLayoutView];
    [alertBar setTag:currentTag];
    [alertBar setBackgroundColor:[self bannerColorForType:type]];
    [alertBar setAlpha:0.0f];
    [root.view addSubview:alertBar];
    
    // set alert bar position
    [alertBar autoPinToTopLayoutGuideOfViewController:root withInset:top];
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
    UIImageView *icon = [self iconImageViewForType:type];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [alertBar addSubview:icon];
    
    [icon autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:alertBar withOffset:12.0f];
    [icon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:alertBar withOffset:15.0f];
    [icon autoSetDimensionsToSize:CGSizeMake(20, 20)];
    
    UILabel *messagelabel =  [[UILabel alloc] initForAutoLayout];
    [messagelabel setNumberOfLines:0];
    [messagelabel setText:message];

    if (type == AlertBarTypeLockWhite) {
      [messagelabel setFont:[UIFont fontWithName:@"AvenirNext-medium" size:14.0]];
    } else {
      [messagelabel setFont:[UIFont fontWithName:@"AvenirNext-bold" size:12.0]];
    }

    [messagelabel setTextColor:[self textColorForType:type]];
    [messagelabel setTextAlignment:[self textAlignmentForType:type]];
    [alertBar addSubview:messagelabel];
    
    [messagelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:alertBar withOffset:45.0f];
    [messagelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:alertBar withOffset:12.0f];
    [messagelabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar withOffset:-40.0f];
    [messagelabel sizeToFit];
    
    if (bottomButton && selector) {
        UIButton *messageButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        
        [messageButton styleSet:[NSString stringWithFormat:@" %@ ",bottomButton] andButtonType:FontDataType_DemiBold_14_White];
        
        [messageButton setBackgroundColor:[UIColor clearColor]];
        messageButton.layer.borderWidth = 1.0f;
        messageButton.layer.cornerRadius = 4.0f;
        messageButton.layer.borderColor = [self textColorForType:type].CGColor;
        [alertBar addSubview:messageButton];
        
        [messageButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:messagelabel withOffset:20.0f];
        [messageButton autoSetDimension:ALDimensionHeight toSize:20];
        [messageButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [alertBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:messageButton withOffset:20.0f];
        [messageButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [alertBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:messagelabel withOffset:10.0f];
    }
    
    [self.view layoutIfNeeded];
    
    [_subViews addObject:alertBar];
    [bufferViews addObject:alertBar];
    
    if (closeable) {
        UIButton *_closeButton = [[UIButton alloc] initForAutoLayout];
        [_closeButton setImage:[self closeButtonImage:type] forState:UIControlStateNormal];

        [_closeButton eventOnClick:^(id sender, NSArray *param) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *view in param) {
                    [view setAlpha:0.0f];
                }
            } completion:^(BOOL finished) {
                for (UIView *view in param) {
                    [view removeFromSuperview];
                }
            }];

            [[NSNotificationCenter defaultCenter] postNotificationName:alertBarCloseNotificationKey object:nil];
        } withObj:bufferViews];


        [alertBar addSubview:_closeButton];
        [_closeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar withOffset:-15.0f];
        [_closeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:alertBar withOffset:10.0f];
        [_closeButton autoSetDimensionsToSize:CGSizeMake(20, 20)];
    }
  
    //alertHeight
    [alertBar updateConstraintsIfNeeded];

    [UIView animateWithDuration:0.25 animations:^{
        [alertBar setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [messagelabel sizeToFit];
        [alertBar updateConstraintsIfNeeded];
    }];

    __weak __typeof(self)weakSelf = self;
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"close" object:self queue:DISPATCH_QUEUE_PRIORITY_DEFAULT usingBlock:^(NSNotification *note) {
        [weakSelf closePopupAlert];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];

    [messagelabel sizeToFit];
    [alertBar updateConstraintsIfNeeded];
    return currentTag;
}

#pragma mark = pop up link alert
- (NSInteger)popupLinkAlert:(NSString *)message
                       type:(AlertBarType)type
                  sceneType:(AlertBarSceneType)scene
                   linkText:(NSString *)link
                   selector:(SEL)selector {
    return [self popupLinkAlert:message type:type sceneType:scene grayScale:NO linkText:link selector:selector displayArrow:NO priority:1];
}

- (NSInteger)popupLinkAlert:(NSString *)message
                       type:(AlertBarType)type
                  sceneType:(AlertBarSceneType)scene
                   linkText:(NSString *)link
                   priority:(NSInteger)priority
                   selector:(SEL)selector {
    return [self popupLinkAlert:message type:type sceneType:scene grayScale:NO linkText:link selector:selector displayArrow:NO priority:priority];
}

- (NSInteger)popupLinkAlert:(NSString *)message
                       type:(AlertBarType)type
                  sceneType:(AlertBarSceneType)scene
                  grayScale:(BOOL)grayScale
                   linkText:(NSString *)link
                   selector:(SEL)selector
               displayArrow:(BOOL)displayArrow {
    return [self popupLinkAlert:message type:type sceneType:scene grayScale:grayScale linkText:link selector:selector displayArrow:displayArrow priority:1];
}

- (NSInteger)popupLinkAlert:(NSString *)message
                       type:(AlertBarType)type
                  sceneType:(AlertBarSceneType)scene
                  grayScale:(BOOL)grayScale
                   linkText:(NSString *)linkText
                   selector:(SEL)selector
               displayArrow:(BOOL)displayArrow
                   priority:(NSInteger)priority {

    if ([self getIsDisabled]) {
        return -1;
    }
    
    CGFloat top = [self distanceToTopForSceneType:scene];
    
    if (!_subViews) {
        _subViews = [[NSMutableArray alloc] init];
    }
    
    NSInteger currentTag = [self getNextTag];
    UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    if (grayScale) {
        CGFloat bottomInset;
        if (scene == AlertBarSceneInDevice) {
            bottomInset = 44.0f;
        }
        else {
            bottomInset = 0.0f;
        }
        
        UIView *grayCover = [self makeGrayViewWithTopInset:root.view topInset:top rightInset:0 bottomInset:bottomInset leftInset:0];
        [grayCover setTag:currentTag];
    }
    
    UIView *alertBar = [UIView newAutoLayoutView];
    [alertBar setTag:currentTag];
    [alertBar setBackgroundColor:[self bannerColorForType:type]];
    [alertBar setAlpha:0.0f];
    [root.view insertSubview:alertBar atIndex:priority];

    // set alert bar position
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:top];
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [alertBar autoPinEdgeToSuperviewEdge:ALEdgeRight];

    float textMessageX;
    if (type != AlertBarTypeAlertNoImage) {
        UIImageView *icon = [self iconImageViewForType:type];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [alertBar addSubview:icon];
    
        [icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [icon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:alertBar withOffset:15.0f];
        [icon autoSetDimensionsToSize:CGSizeMake(20, 20)];
        textMessageX = 45.f;
    }
    else {
        textMessageX = 10.f;
    }
    
    UILabel *messagelabel =  [[UILabel alloc] initForAutoLayout];
    messagelabel.numberOfLines = 0;
    messagelabel.lineBreakMode = NSLineBreakByWordWrapping;
    messagelabel.preferredMaxLayoutWidth = 200;
    messagelabel.backgroundColor = [UIColor clearColor];
    [messagelabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [messagelabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

    [messagelabel setText:message];
    [messagelabel setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0]];
    [messagelabel setTextColor:[self textColorForType:type]];
    [messagelabel setTextAlignment:[self textAlignmentForType:type]];
    [alertBar addSubview:messagelabel];
    
    [messagelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:alertBar withOffset:45.0f];
    [messagelabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [messagelabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar withOffset:displayArrow ? -40.0f : -20.f];

    [alertBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:messagelabel withOffset:10.0f];
    [self.view layoutIfNeeded];

    alertBar.layer.zPosition = priority;

    // Just changing the zPosition is not enough to
    // disable the click events of each alert bar
    for (UIView *view in _subViews) {
        if (view.layer.zPosition < priority) {
            view.userInteractionEnabled = NO;
        }
        else if (view.layer.zPosition > priority) {
            alertBar.userInteractionEnabled = NO;
        }
        else {
            view.userInteractionEnabled = YES;
        }
    }

    [_subViews addObject:alertBar];

    float clickableButtonWidth = 0;
    if (displayArrow) {
        UIImageView *chevronIcon = [[UIImageView alloc] initForAutoLayout];
        [alertBar addSubview:chevronIcon];
        chevronIcon.image = [self cheveronImageForType:type];
        [chevronIcon autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar withOffset:-15.0f];
        [chevronIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:messagelabel];
        [chevronIcon autoSetDimension:ALDimensionWidth toSize:chevronIcon.image.size.width];
        [chevronIcon autoSetDimension:ALDimensionHeight toSize:chevronIcon.image.size.height];
        clickableButtonWidth += chevronIcon.image.size.width + 25.0f;
    }
    if (linkText.length > 0 || type == AlertBarTypeClickableWarning) {
        UILabel *linkLabel = [[UILabel alloc] initForAutoLayout];
        linkLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0];
        linkLabel.textColor = [self linkLabelColorForType:type];

        if (![linkText isEqualToString:@"hidden_text"]) {
          linkLabel.text = linkText;
        }

        [alertBar addSubview:linkLabel];

        [linkLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar withOffset:-clickableButtonWidth];
        [linkLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:alertBar withOffset:0.0f];
        [linkLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:alertBar withOffset:0.0f];

        if (linkText.length > 0) {
             CGSize textSize = [linkLabel.text sizeWithAttributes:@{ NSFontAttributeName : linkLabel.font }];
            [linkLabel autoSetDimension:ALDimensionWidth toSize:textSize.width];
            clickableButtonWidth += textSize.width;
            messagelabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - clickableButtonWidth - textMessageX;
        }
        else {
            [linkLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:alertBar withOffset:-100.0];
            clickableButtonWidth += 60;
        }
    }
    if (clickableButtonWidth < 60) {
        clickableButtonWidth = 60;
    }
    UIButton *clickableButton = [[UIButton alloc] initForAutoLayout];
    clickableButton.backgroundColor = [UIColor clearColor];
    [alertBar addSubview:clickableButton];
    [clickableButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:alertBar];
    [clickableButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:alertBar];
    [clickableButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:alertBar];
    [clickableButton autoSetDimension:ALDimensionWidth toSize:clickableButtonWidth];
    [alertBar bringSubviewToFront:clickableButton];
    clickableButton.userInteractionEnabled = YES;
    if (selector) {
        [clickableButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    [root.view bringSubviewToFront:alertBar];

    //alertHeight
    [alertBar updateConstraintsIfNeeded];
    alertBar.alpha = 1.0f;

    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"close" object:self queue:DISPATCH_QUEUE_PRIORITY_DEFAULT usingBlock:^(NSNotification *note) {
        [self closePopupAlertWithTag:currentTag];

        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    
    return currentTag;
}

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable under:(CGFloat)top bottomButton:(NSString *)bottomButton selector:(SEL)selector {
    // Only no connection display the gray scale cover.
    BOOL displayGrayScaleCover = (AlertBarTypeNoConnection == type);
    return [self popupAlert:message type:type canClose:closeable under:top bottomButton:bottomButton grayScale:displayGrayScaleCover selector:selector];
}

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable under:(CGFloat)top bottomButton:(NSString *)bottomButton selector:(SEL)selector priority:(NSInteger)priority {
    // Only no connection display the gray scale cover.
    BOOL displayGrayScaleCover = (AlertBarTypeNoConnection == type);
    return [self popupAlert:message type:type canClose:closeable under:top bottomButton:bottomButton grayScale:displayGrayScaleCover selector:selector priority:priority];
}

#pragma mark - pop up decorate
- (UIView *)makeGrayViewWithTopInset:(UIView *)view topInset:(CGFloat)topInset rightInset:(CGFloat)rightInset bottomInset:(CGFloat)bottomInset leftInset:(CGFloat)leftInset {
    
    UIImage *image = [[UIImage imageFromLayer:view.layer] convertImageToGrayScale];
    CGRect rect = CGRectMake(leftInset, topInset, view.bounds.size.width - leftInset - rightInset, view.bounds.size.height - topInset - bottomInset);
    UIImageView *grayView = [UIImageView newAutoLayoutView];
    grayView.image = [image cutImage:rect];
    [_subViews addObject:grayView];

    [view addSubview:grayView];

    [grayView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:topInset];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:bottomInset];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:rightInset];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:leftInset];

    self.view.userInteractionEnabled = NO;

    return grayView;
}

- (UIColor *)bannerColorForType:(AlertBarType)type {
    
    if (type == AlertBarUpdateFirmware || type == AlertBarTypeCamera || type == AlertBarTypeLockWhite) {
        return [UIColor whiteColor];
    } else if (type == AlertBarTypeWaiting) {
        return [[UIColor whiteColor] colorWithAlphaComponent:.1f];
    } else if (type == AlertBarTypeOrangeWarning || type == AlertBarTypeYellowWarning) {
      return [Appearance warningYellow];
    }
    
    return pinkAlertColor;
}

- (UIColor *)textColorForType:(AlertBarType)type {

    if (type == AlertBarUpdateFirmware || type == AlertBarTypeCamera ||
        type == AlertBarTypeLockWhite || type == AlertBarTypeYellowWarning) {
        return [UIColor blackColor];
    }
    
    return [UIColor whiteColor];
}

- (NSTextAlignment)textAlignmentForType:(AlertBarType)type {
    if (type == AlertBarTypeWaiting) {
        return NSTextAlignmentCenter;
    }

    return NSTextAlignmentLeft;
}

- (UIImage *)closeButtonImage:(AlertBarType)type {
    if (type == AlertBarUpdateFirmware || type == AlertBarTypeCamera) {
        return [UIImage imageNamed:@"DeviceThermostatClose"].invertColor;
    }
    
    return [UIImage imageNamed:@"alertClose"];
}
- (UIImage *)cheveronImageForType:(AlertBarType)type {
    if (type == AlertBarUpdateFirmware || type == AlertBarTypeCamera || type == AlertBarTypeYellowWarning) {
        return [UIImage imageNamed:@"Chevron"];
    }
    
    return [UIImage imageNamed:@"ChevronWhite"];
}

- (UIImageView *)iconImageViewForType:(AlertBarType)type {
  switch (type) {
    case AlertBarTypeLowBattery:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertRunningOnBattery"]];
      break;
    case AlertBarTypePoorConnection:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertPoorConnection"]];
      break;
    case AlertBarUpdateFirmware:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertNoConnection"].invertColor];
      break;
    case AlertBarTypeCamera:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VideoCamera"]];
      break;
    case AlertBarTypeLockWhite:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_locks"].invertColor];
    case AlertBarTypeWaiting:
      return nil;
      break;
    case AlertBarTypeYellowWarning:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"warning_icon_lined_black"]];
      break;
    default:
      return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertNoConnection"]];
      break;
  }
}

- (UIColor *)linkLabelColorForType: (AlertBarType)type {
  switch (type) {
    case AlertBarTypeYellowWarning:
       return [FontColors getCreationSubheaderTextColor];
      break;
    default:
      return [FontColors getStandardSubheaderTextColor];
      break;
  }
}


#pragma mark - close pop up
- (void)closePopupAlert {
    [self closePopupAlert:NO];
}

- (void)closePopupAlert:(BOOL)animate {
    self.view.userInteractionEnabled = YES;
    if (animate) {
        if (_subViews && [_subViews count] > 0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *view in _subViews) {
                    [view setAlpha:0.0f];
                }
            } completion:^(BOOL finished) {
                for (UIView *view in _subViews) {
                    [view removeFromSuperview];
                }
                _subViews = nil;
            }];
        }
    } else {
        if (_subViews && [_subViews count] > 0) {
            for (UIView *view in _subViews) {
                [view removeFromSuperview];
            }
            _subViews = nil;
        }
    }
}

- (void)closePopupAlertWithTag:(NSInteger)tag {
    for (UIView *view in _subViews) {
        if (view.tag == tag) {
            //viewToRemove = view;
            view.alpha = 0.0f;
            return;
        }
    }
    return;

    __block UIView *viewToRemove;
    if (_subViews && [_subViews count] > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in _subViews) {
                if (view.tag == tag) {
                    viewToRemove = view;
                    view.alpha = 0.0f;
                    return;
                }
            }
        } completion:^(BOOL finished) {
            [viewToRemove removeFromSuperview];
        }];
    }
}

- (void)closePopupAlertWithTimer:(NSTimer *)timer {
    NSNumber *tag = timer.userInfo;
    
    if (_subViews && [_subViews count] > 0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in _subViews) {
                if (view.tag == [tag integerValue]) {
                    [view setAlpha:0.0f];
                }
            }
        } completion:^(BOOL finished) {
            for (UIView *view in _subViews) {
                if (view.tag == [tag integerValue]) {
                    [view removeFromSuperview];
                }
            }
        }];
    }
}

- (UIView *)getPopupAlertWithTag:(NSInteger)tag {
    for (UIView *view in _subViews) {
        if (view.tag == tag) {
            return view;
        }
    }
    return nil;
}

#pragma mark - Helpers
- (CGFloat)distanceToTopForSceneType:(AlertBarSceneType)sceneType {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone &&
      UIScreen.mainScreen.nativeBounds.size.height == 2436)  {
      //iPhone X
    if (@available(iOS 11.0, *)) {
      CGFloat distanceToTop = UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
      switch (sceneType) {
        case AlertBarSceneInDevice:
          distanceToTop += 88.0f;
          break;
        case AlertBarSceneInDashboard:
          distanceToTop += 44.0f;
          break;
        case AlertBarSceneInNavigation:
          break;
        default:
          break;
      }
      return distanceToTop;
    } else {
      // Fallback on earlier versions
      // just continue
    }
  }
  CGFloat distanceToTop = 0;
  switch (sceneType) {
    case AlertBarSceneInDevice:
      distanceToTop = 108.0f;
      break;
    case AlertBarSceneInDashboard:
      distanceToTop = 64.0f;
      break;
    case AlertBarSceneInNavigation:
      distanceToTop = 20.0f;
      break;
    default:
      break;
  }
  return distanceToTop;
}
@end
