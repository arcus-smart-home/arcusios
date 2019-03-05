//
//  UIViewController+AlertBar.h
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

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AlertBarType) {
    AlertBarTypeLowBattery          = 0,
    AlertBarTypePoorConnection,
    AlertBarTypeNoConnection,
    AlertBarTypeWarning,
    AlertBarTypeOrangeWarning,
    AlertBarTypeClickableWarning,
    AlertBarUpdateFirmware,
    AlertBarTypeCamera,
    AlertBarTypeWaiting,
    AlertBarTypeAlertNoImage,
    AlertBarTypeLockWhite,
    AlertBarTypeYellowWarning,
};

typedef NS_ENUM(NSInteger, AlertBarSceneType) {
    AlertBarSceneInNavigation       = 0,
    AlertBarSceneInDevice,
    AlertBarSceneInDashboard,
    AlertBarSceneUndefined
};

#define alertBarCloseNotificationKey @"alertBarClosedNotification"
//const NSString *alertBarCloseNotificationKey = @"alertBarClosedNotification";

@interface UIViewController(AlertBar)

- (void)setDisableAlert:(BOOL)enable;
- (BOOL)getIsDisabled;

- (BOOL)isDisplayingAlert;

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable under:(CGFloat)top;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable under:(CGFloat)top bottomButton:(NSString *)buttomButton selector:(SEL)selector;

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable sceneType:(AlertBarSceneType)scene;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable grayScale:(BOOL)grayScale sceneType:(AlertBarSceneType)scene;


- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable under:(CGFloat)top bottomButton:(NSString *)bottomButton grayScale:(BOOL)grayScale selector:(SEL)selector;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable sceneType:(AlertBarSceneType)scene bottomButton:(NSString *)bottomButton selector:(SEL)selector priority:(NSInteger)priority;

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable sceneType:(AlertBarSceneType)scene bottomButton:(NSString *)bottomButton selector:(SEL)selector;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene withDuration:(int)time;

- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene bottomButton:(NSString *)bottomButton grayScale:(BOOL)grayScale selector:(SEL)selector;
- (NSInteger)popupAlert:(NSString *)message type:(AlertBarType)type canClose:(BOOL)closeable sceneType:(AlertBarSceneType)scene bottomButton:(NSString *)bottomButton grayScale:(BOOL)grayScale selector:(SEL)selector;

- (NSInteger)popupLinkAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene linkText:(NSString *)link selector:(SEL)selector;
- (NSInteger)popupLinkAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene linkText:(NSString *)link priority:(NSInteger)priority selector:(SEL)selector;
- (NSInteger)popupLinkAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene grayScale:(BOOL)grayScale linkText:(NSString *)link selector:(SEL)selector displayArrow:(BOOL)displayArrow;
- (NSInteger)popupLinkAlert:(NSString *)message type:(AlertBarType)type sceneType:(AlertBarSceneType)scene grayScale:(BOOL)grayScale linkText:(NSString *)link selector:(SEL)selector displayArrow:(BOOL)displayArrow priority:(NSInteger)priority;

- (void)closePopupAlert;
- (void)closePopupAlert:(BOOL)animate;
- (void)closePopupAlertWithTag:(NSInteger)tag;
- (void)closePopupAlertWithTimer:(NSTimer *)timer;
- (UIView *)getPopupAlertWithTag:(NSInteger)tag;


@end
