//
//  UIViewController+Navigation.m
//  i2app
//
//  Created by Arcus Team on 4/7/15.
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
#import "UIViewController+Navigation.h"
#import "UIImage+ImageEffects.h"
#import "SubsystemsController.h"
#import <objc/runtime.h>
#import <i2app-Swift.h>

@interface UIViewController (Navigation_Private)

- (void)addBackButtonItemAsLeftButtonItem;
- (void)addRightButtonItem:(NSString *)imageName selector:(SEL)selector;
- (void)addLeftButtonItem:(NSString *)imageName selector:(SEL)selector;

- (void)addCloseButtonItem;

+ (void)swizzleViewDidLoad;
+ (void)swizzleViewWillAppear;

@end

typedef enum {
    NavigationItemImageBack = 0,
    NavigationItemImageClose,
    NavigationItemImageAdd,
    NavigationItemImageMenu,
    NavigationItemImageSearch,
    // Dash Logo needs to stay last in the enumeration
    NavigationItemImageDashLogo
} NavigationItemImage;

@implementation UIViewController (Navigation)
    NSDictionary    *_navigationIconsWhite;
    NSDictionary    *_navigationIconsBlack;

#define navButtonImagesTypeToString(enum) [@[@"MenuIcon", @"AddIcon", @"button_close", @"button_back", @"SearchButton", @"DashLogo"] objectAtIndex:enum]

@dynamic navigationIconsWhite;
@dynamic navigationIconsBlack;

#pragma mark - Dynamic Properties
- (NSDictionary *)navigationIconsWhite {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *navigationIcons = [[NSMutableDictionary alloc] init];
    
        UIImage *barIcon;
        NSString *imageName;
        for (int i = 0; i <= NavigationItemImageDashLogo; i++) {
            imageName = navButtonImagesTypeToString(i);
            barIcon = [UIImage imageNamed:imageName];
            barIcon = [barIcon invertColor];
            [navigationIcons setObject:barIcon forKey:imageName];
        }
        
        _navigationIconsWhite = navigationIcons.copy;
    });
    
    return _navigationIconsWhite;
}

- (NSDictionary *)navigationIconsBlack {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary *navigationIcons = [[NSMutableDictionary alloc] init];

        UIImage *barIcon;
        NSString *imageName;
        for (int i = 0; i <= NavigationItemImageDashLogo; i++) {
            imageName = navButtonImagesTypeToString(i);
            barIcon = [UIImage imageNamed:imageName];
            [navigationIcons setObject:barIcon forKey:imageName];
        }
        
        _navigationIconsBlack = navigationIcons.copy;
    });
    
    return _navigationIconsBlack;
}

- (void)navBarWithTitleImage {
    // Add the main title image
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DashLogo"]];
}

- (void)addCloseButtonItem {
    [self addRightButtonItem:@"button_close" selector:@selector(close:)];
}

- (void)addBackButtonItemAsLeftButtonItem {
    [self addLeftButtonItem:@"button_back" selector:@selector(back:)];
}

- (void)addRightButtonImageItem:(UIImage *)image selector:(SEL)selector {
    [self addRightButtonImageItem:image selector:selector animation:NO];
}

- (void)addRightButtonImageItem:(UIImage *)image selector:(SEL)selector animation:(BOOL)animation {
    // Create a custom button with the image
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:image forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    // Add the target
    [rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // Add the container bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.backBarButtonItem = nil;
    
    if (animation) {
        [rightButton setAlpha:0.0f];
        [UIView animateWithDuration:0.5f animations:^{
            [rightButton setAlpha:1.0f];
        }];
    }
}

- (void)addRightButtonItem:(NSString *)imageName selector:(SEL)selector {
  UIImage *barButtonImage = nil;

  if ([[[NavigationBarAppearanceManager sharedInstance] navigationBarTintColor] isEqual:[UIColor blackColor]]) {
    barButtonImage = self.navigationIconsBlack[imageName];
  } else {
    barButtonImage = self.navigationIconsWhite[imageName];
  }

  [self addRightButtonImageItem:barButtonImage selector:selector];
}

- (void)addRightButtonTextItem:(NSString *)name selector:(SEL)selector {
    [self addRightButtonTextItem:name selector:selector animation:NO];
}

- (void)addRightButtonTextItem:(NSString *)name selector:(SEL)selector animation:(BOOL)animation {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setAttributedTitle:[FontData getString:[name uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 50, 12);
    // Add the target
    [rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    // Add the container bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

- (void)addRightButtonText:(NSString *)name selector:(SEL)selector {
    [self addRightButtonTextItem:name selector:selector];
}

- (void)addLeftButtonImageItem:(UIImage *)imageName selector:(SEL)selector {
  UIImage *barButtonImage = nil;

  if ([[[NavigationBarAppearanceManager sharedInstance] navigationBarTintColor] isEqual:[UIColor blackColor]]) {
    barButtonImage = self.navigationIconsBlack[@"button_back"];
  } else {
    barButtonImage = self.navigationIconsWhite[@"button_back"];
  }

  [self addLeftButtonImageItem:barButtonImage selector:selector animation:NO];
}

- (void)addLeftButtonImageItem:(UIImage *)imageName selector:(SEL)selector animation:(BOOL)animation {
    // Create a custom button with the image
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:imageName forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 44.0, 44.0);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -26, 0, 0)];
    // Add the target
    [leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // Add the container bar button
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    if (animation) {
        [leftButton setAlpha:0.0f];
        [UIView animateWithDuration:0.5f animations:^{
            [leftButton setAlpha:1.0f];
        }];
    }
}

- (void)addLeftButtonItem:(NSString *)imageName selector:(SEL)selector {
  UIImage *barButtonImage = nil;
  if ([[[NavigationBarAppearanceManager sharedInstance] navigationBarTintColor] isEqual:[UIColor blackColor]]) {
    barButtonImage = self.navigationIconsBlack[@"button_back"];
  } else {
    barButtonImage = self.navigationIconsWhite[@"button_back"];
  }

  [self addLeftButtonImageItem:barButtonImage selector:selector];
}

- (void)navBarWithBackButtonAndTitleImage {
    [self navBarWithTitleImage];
    [self addBackButtonItemAsLeftButtonItem];
}

- (void)navBarWithCloseButtonAndTitleImage {
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self navBarWithTitleImage];
    [self addCloseButtonItem];
}


- (void)navBarWithTitle:(NSString *) title {
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self setNavBarTitle:title];
}

- (void)navBarWithTitle:(NSString *)title textColor:(UIColor *)textColor {
  [self.navigationItem setHidesBackButton:YES animated:YES];

  if ([title isEqual:[NSNull null]] || title.length == 0) {
    title = @"";
  }
  UILabel *titleLabel = [UILabel new];
  titleLabel.attributedText = [[FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES] getFontAttributed:[title uppercaseString]];
  [titleLabel sizeToFit];
  titleLabel.textColor = textColor;
  self.navigationItem.titleView = titleLabel;
}

- (void)navBarWithCloseButtonAndTitle:(NSString *)title {
    [self.navigationItem setHidesBackButton:YES animated:YES];

    [self setNavBarTitle:title];

    // Check if the "Close" button needs to be displayed
    if (self.presentingViewController || (self.navigationController && self.navigationController.viewControllers.count > 1)) {
        [self addCloseButtonItem];
    }
}

- (void)navBarWithTitle:(NSString *)title enableBackButton:(BOOL)enabled {
    if (enabled) {
        [self addBackButtonItemAsLeftButtonItem];
    }

    self.navigationItem.rightBarButtonItem = nil;

    [self setNavBarTitle:title];
}

- (void)navBarWithBackButtonAndTitle:(NSString *)title {
    // Display the back button if necessary
    if (self.navigationController.viewControllers.count > 1 ||
        [self isKindOfClass:[UITabBarController class]]) {
        [self addBackButtonItemAsLeftButtonItem];
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self setNavBarTitle:title];
}

- (void)navBarWithBackButtonAndTitle:(NSString *)title
                rightButtonImageName:(NSString *)imageName
                 rightButtonSelector:(SEL)selector {
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setNavBarTitle:title];
    
    [self addRightButtonItem:imageName selector:selector];
}


- (void)navBarWithLeftButton:(NSString *)leftButtonImageName
          leftButtonSelector:(SEL)leftButtonSelector
              andRightButton:(NSString *)rightButtonImageName
         rightButtonSelector:(SEL)rightButtonSelector
         withTitleImageNamed:(NSString *)imageName {

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    [self addLeftButtonItem:leftButtonImageName selector:leftButtonSelector];
    [self addRightButtonItem:rightButtonImageName selector:rightButtonSelector];
}


- (void)navBarWithLeftButtonImage:(UIImage *)leftButtonImage
          leftButtonSelector:(SEL)leftButtonSelector
              andRightButtonImage:(UIImage *)rightButtonImage
         rightButtonSelector:(SEL)rightButtonSelector
         withTitleImage:(UIImage *)image {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];

    [self addLeftButtonImageItem:leftButtonImage selector:leftButtonSelector];
    [self addRightButtonImageItem:rightButtonImage selector:rightButtonSelector];
}

- (void)navBarWithLeftButtonImage:(UIImage *)leftButtonImage
               leftButtonSelector:(SEL)leftButtonSelector
              andRightButtonImage:(UIImage *)rightButtonImage
              rightButtonSelector:(SEL)rightButtonSelector
                   withTitleImage:(UIImage *)image
                        animation:(BOOL)animation {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    if (animation) {
        self.navigationItem.titleView.alpha = 0.0f;
        [UIView animateWithDuration:0.5f animations:^{
            self.navigationItem.titleView.alpha = 1.0f;
        }];
    }
    
    [self addLeftButtonImageItem:leftButtonImage selector:leftButtonSelector animation:animation];
    [self addRightButtonImageItem:rightButtonImage selector:rightButtonSelector animation:animation];
}

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
           withSelector:(SEL)selector {
    [self navBarWithTitle:title andRightButtonText:text withSelector:selector selectorTarget:self];
}

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
              textColor:(UIColor *)textColor
           withSelector:(SEL)selector
         selectorTarget:(id)target {
  [self.navigationItem setHidesBackButton:YES animated:YES];
  [self navBarWithTitle:title textColor:textColor];

  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [rightButton setAttributedTitle:[FontData getString:[text uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
  rightButton.frame = CGRectMake(0, 0, 50, 12);
  rightButton.titleLabel.textColor = textColor;
  // Add the target
  [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
  // Add the container bar button
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
  self.navigationItem.backBarButtonItem = nil;

}

- (void)navBarWithTitle:(NSString *)title
     andRightButtonText:(NSString *)text
           withSelector:(SEL)selector
         selectorTarget:(id)target {
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self setNavBarTitle:title];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setAttributedTitle:[FontData getString:[text uppercaseString] withFont:FontDataTypeNavBar] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 50, 12);
    // Add the target
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // Add the container bar button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.backBarButtonItem = nil;
}

- (void)hideBackButton {
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}
- (void)hideRightButton {
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Create Bar buttons
- (void)setNavBarTitle:(NSString *)title {
    if ([title isEqual:[NSNull null]] || title.length == 0) {
        title = @"";
    }
    UILabel *titleLabel = [UILabel new];
    NavigationBarAppearanceManager *appearanceManager = NavigationBarAppearanceManager.sharedInstance;
    UIColor *activeColor = appearanceManager.navigationBarTintColor;
    FontData *font = [FontData createFontData:FontTypeDemiBold size:12 blackColor:YES space:YES];
    NSMutableDictionary *fontAttributes = [NSMutableDictionary dictionaryWithDictionary:font.getFontDictionary];
    [fontAttributes setObject:activeColor forKey:NSForegroundColorAttributeName];
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:fontAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Bar Button Actions
- (void)close:(NSObject *)sender {
    if (!self.parentViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeToRootViewController:(NSObject *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back:(NSObject *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect) {.size = size});
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)navBarWithSearchBar {
    UISearchBar *searchBar = [[UISearchBar new] initWithFrame:self.navigationItem.titleView.frame];
    searchBar.barStyle = UIBarStyleBlack;
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.translucent = YES;
    
    [searchBar setSearchBarStyle:UISearchBarStyleMinimal];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.tintColor = [UIColor blackColor];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor redColor]];
    
    self.navigationItem.titleView = searchBar;

    for (UIView *subview in [[searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
            break;
        }
    }
    [searchBar setBackgroundColor:[UIColor clearColor]];
    UIImage *clearImg = [self imageWithColor:[UIColor clearColor] andSize:CGSizeMake(300, 30)];
    [searchBar setBackgroundImage:clearImg];
}

- (UIViewController *)findLastViewController:(Class)aClass {
    for (int index = ((int)self.navigationController.viewControllers.count - 1); index >= 0; index--) {
        UIViewController *vc = self.navigationController.viewControllers[index];
        if ([vc isKindOfClass:aClass]) {
            return vc;
        }
    }
    return nil;
}

- (UIViewController *)findViewControllerByIndex:(int)numberOfIndex {
    if (self.navigationController.viewControllers.count <= numberOfIndex) {
        return nil;
    }
    else {
        return self.navigationController.viewControllers[self.navigationController.viewControllers.count - numberOfIndex - 1];
    }
}

+ (void)load {
    [UIViewController swizzleViewDidLoad];
    [UIViewController swizzleViewWillAppear];
}

+ (void)swizzleViewDidLoad {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(viewDidLoadNavigationBarFix);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (void)swizzleViewWillAppear {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(viewWillAppearNavigationBarFix:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[NavigationBarAppearanceManager sharedInstance] statusBarBarStyle];
}

#pragma clang diagnostic pop

- (void)viewDidLoadNavigationBarFix {
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Method Swizzling

- (void)viewWillAppearNavigationBarFix:(BOOL)animated {
//  [self viewWillAppearNavigationBarFix:animated];

  [self setNeedsStatusBarAppearanceUpdate];

  if (![self isAlertModal]) {
    for (UINavigationItem *item in self.navigationController.navigationBar.subviews) {
      if ([item isKindOfClass:[UIButton class]]) {
        UIColor *tintColor = [[NavigationBarAppearanceManager sharedInstance] navigationBarTintColor];
        ((UIButton *)item).imageView.image = [((UIButton *)item).imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [((UIButton *)item).imageView setTintColor:[UIColor blackColor]];
        [((UIButton *)item) setImage:((UIButton *)item).imageView.image forState:UIControlStateNormal];
      }
    }
  }
}

- (BOOL)isAlertModal {
  BOOL result = NO;
  if ([self isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navController = (UINavigationController *)self;
    NSArray *viewControllers = [navController viewControllers];
    if ([viewControllers count] > 0) {
      if ([viewControllers[0] isKindOfClass:[ModalAlertViewController class]]) {
        result = YES;
      }
    }
  } else if ([self isKindOfClass:[ModalAlertViewController class]]) {
    result = YES;
  }
  return result;
}

@end
