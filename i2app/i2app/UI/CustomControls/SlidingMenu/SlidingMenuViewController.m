
/*
 
 xCopyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
 */

#import "SlidingMenuViewController.h"
#import "SlidingMenuTableViewCell.h"
#import "ChooseDeviceViewController.h"

#import "DeviceListViewController.h"
#import "PlaceTableViewCell.h"
#import "PlaceCapability.h"
#import "WebViewController.h"
#import "AlertActionSheetViewController.h"
#import "SceneListViewController.h"
#import "ArcusLabel.h"



#import "TutorialListViewController.h"
#import "TutorialViewController.h"
#import <i2app-Swift.h>
#import "PlacePickerModalViewController.h"
#import "ArcusModalSelectionModel.h"

#import "AKFileManager.h"
#import "PersonCapability.h"

#import <SWRevealViewController/SWRevealViewController.h>

#import <i2app-Swift.h>

#define GRADIENT_BAR_HEIGHT 30
#define GRADIENT_BAR_X_LOCATION 0
#define GRADIENT_BAR_Y_LOCATION 88
#define PERSON_NAME_MARGIN_H 100

#import <PureLayout/PureLayout.h>

@interface SlidingMenuViewController() {
    NSInteger _presentedRow;
    BOOL isGradientAdded;
    
    
}

@property (weak, nonatomic) IBOutlet UIView *fadedView;
@property (nonatomic, assign) BOOL isPremium;
@property (nonatomic, weak) UILabel *placeNameLabel;
@property (nonatomic, weak) ArcusLabel *personNameLabel;


@end

@implementation SlidingMenuViewController
@synthesize rearTableView = _rearTableView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.rearTableView.scrollEnabled = YES;
    self.rearTableView.backgroundColor = [UIColor clearColor];
    self.rearTableView.rowHeight = 70;
    [self.rearTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.title = NSLocalizedString(@"Rear View", nil);
    self.fadedView.backgroundColor = [UIColor clearColor];
    
    [self.rearTableView registerNib:[UINib nibWithNibName:@"SlidingMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.rearTableView registerNib:[UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"placeCell"];
    [self.rearTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footerView"];
    
    NSString *placeModelUpdateNotification = [NSString stringWithFormat:@"Update%@Notification",[PlaceModel class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(placeChanged:) name:placeModelUpdateNotification object:nil];
    
    NSString *personModelUpdateNotification = [NSString stringWithFormat:@"Update%@Notification",[PersonModel class]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(personChanged:) name:personModelUpdateNotification object:nil];

}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.rearTableView reloadData];
}

#pragma mark - Getters

- (BOOL)isPremium {
    return _isPremium = [CorneaHolder.shared.settings isPremiumAccount];
}

- (void)logout {
    [self.revealViewController revealToggle:self];

    //Tag Left Rail Menu - Logout:
    [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuLogout attributes:@{}];

    [[[CorneaHolder shared] session] logout];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    int h = (int)theView.frame.size.height/3;
    CGRect gradientFrame = CGRectMake(theView.frame.origin.x, theView.frame.origin.y, theView.frame.size.width, h +10);//theView.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = h*2;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[theColor CGColor],
                       (id)[[theColor colorWithAlphaComponent:1.0f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.95f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.8f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.7f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.2f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    //reverse the color array if needed
    if (transparentToOpaque) {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [theView.layer addSublayer:gradient];
}

#pragma mark - UITableView Delegate and Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 119.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 93.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        
        //Updated to better center the image based on 2x image usage. May consider changing this logic to use deterministic function of 2x/3x
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width/2.0f-65.0f, 25.0f, 65.0f, 50.0f)];
        imageView.image = [UIImage imageNamed:@"ArcusLogoSlidingMenuNew"];
        [headerView addSubview:imageView];
        
        //Get the current person logged in
        PersonModel *personModel = [[[CorneaHolder shared] settings] currentPerson];
    
        //Build the greeting string, if first name is empty then do not print anything:
        NSString *greetingString = [[NSString alloc ] init ];
        greetingString = [self buildGreetingString: personModel];
        
        //Draw the gradient bar
        UIView *gradientBarView = [[UIView alloc] initWithFrame:CGRectMake(GRADIENT_BAR_X_LOCATION, GRADIENT_BAR_Y_LOCATION, tableView.frame.size.width, GRADIENT_BAR_HEIGHT)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        //Gradient settings
        gradient.startPoint = CGPointZero;
        gradient.endPoint = CGPointMake(1, 0);
        gradient.frame = gradientBarView.bounds;
        
        //Gradient colors #00BFB3 and #0095C8
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.0/255.0 green:191/255.0 blue:179/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:0/255.0 green:149.0/255.0 blue:200/255.0 alpha:1.0] CGColor], nil];
        
        //Add the gradient layer into the gradient bar UIView
        [[gradientBarView layer] insertSublayer:gradient atIndex:0];
        
        //Create the greeting label to place on top of the gradient bar:
        CGFloat centerX = self.revealViewController.rearViewRevealWidth/2;
        
        ArcusLabel *greetingLabel = [[ArcusLabel alloc] initWithFrame:CGRectMake(GRADIENT_BAR_X_LOCATION, GRADIENT_BAR_Y_LOCATION, tableView.frame.size.width - PERSON_NAME_MARGIN_H, GRADIENT_BAR_HEIGHT)];
      
        self.personNameLabel = greetingLabel;
        self.personNameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBoldItalic" size:16.0f];
        self.personNameLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0f];
        self.personNameLabel.text = greetingString;
        self.personNameLabel.allCaps = NO;
        self.personNameLabel.wideSpacing = YES;
        self.personNameLabel.textAlignment = NSTextAlignmentCenter;
        self.personNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.personNameLabel.center = CGPointMake(centerX, GRADIENT_BAR_HEIGHT/2);
      
        //Add the UILabel to the UIView layer
        [gradientBarView.layer insertSublayer:greetingLabel.layer atIndex:1];
        
        //Add the gradient UIView to the headerview
        [headerView addSubview: gradientBarView];
        
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    footerView.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat centerX = self.revealViewController.rearViewRevealWidth / 2;
    
    UIButton *logout = [UIButton new];
    NSAttributedString *_attribute = [[NSAttributedString alloc] initWithString:[NSLocalizedString(@"Log out", nil)uppercaseString] attributes:[FontData getFontWithSize:9.0 bold:YES kerning:2.0f color:[[UIColor blackColor] colorWithAlphaComponent:0.6f]]];
    [logout setAttributedTitle:_attribute forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [logout sizeToFit];

    logout.bounds = CGRectMake(0, 0, centerX * 2, logout.bounds.size.height);
    logout.center = CGPointMake(centerX, 30 + logout.bounds.size.height/2 - logout.titleLabel.frame.origin.y);
    [footerView addSubview:logout];
    
    UIView *line = [UIView new];
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];;
    line.bounds = CGRectMake(0, 0, 165, 1);
    line.center = CGPointMake(centerX, 47 + line.bounds.size.height/2);
    [footerView addSubview:line];

    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SlidingMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SlidingMenuTableViewCell" owner:self options:nil];
        cell = nib[0];
    }
    
    const NSArray *titleTexts = @[NSLocalizedString(@"Dashboard", nil),
                                  NSLocalizedString(@"Scenes", nil),
                                  NSLocalizedString(@"Rules", nil),
                                  NSLocalizedString(@"Devices", nil),
                                  NSLocalizedString(@"Settings", nil),
                                  NSLocalizedString(@"Support", nil),
                                  NSLocalizedString(@"Shop", nil)];
    const NSArray *subtitleTexts = @[NSLocalizedString(@"Status of Your Home", nil),
                                     NSLocalizedString(@"Control Several Devices at Once", nil),
                                     NSLocalizedString(@"Connect & Automate Devices", nil),
                                     NSLocalizedString(@"Manage & Control Devices", nil),
                                     NSLocalizedString(@"Profile, People & Places", nil),
                                     NSLocalizedString(@"FAQs & Customer Support", nil),
                                     NSLocalizedString(@"Browse Arcus-Compatible Products", nil)];
    const NSArray *imageNames = @[@"DashboardIcon",
                                  @"ScenesIconNew",
                                  @"RulesIcon",
                                  @"DevicesIconNew",
                                  @"SettingsIconNew",
                                  @"SupportIcon",
                                  @"ShoppingIcon"];
    
    NSInteger index = indexPath.row;
    [cell initializeCellWithTitle:titleTexts[index] withSubtitle:subtitleTexts[index] withImageNamed:imageNames[index]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // selecting row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    
    // otherwise we'll create a new frontViewController and push it with animation
    switch (row) {
        case 0:
            
            //Tag Left Rail Menu - Dashboard:
            [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuDashboard attributes:@{}];
            
            [((UINavigationController *)self.revealViewController.frontViewController) popToRootViewControllerAnimated:NO];
            
            break;
            
        case 1:
        {
            if ([[CorneaHolder shared] settings].displayScenesTutorial) {
                TutorialViewController *vc = [TutorialViewController createWithType:TuturialTypeScenes andCompletionBlock:^{
                    [self displayScenesListViewController];
                }];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self displayScenesListViewController];
            }
        }
            break;
            
        case 2: {
            if ([[CorneaHolder shared] settings].displayRulesTutorial) {
                TutorialViewController *vc = [TutorialViewController createWithType:TuturialTypeRules andCompletionBlock:^{
                    [self displayRulesListViewController];
                }];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self displayRulesListViewController];
            }
        }
            break;
            
        case 3: {
            //Tag Left Rail Menu - Devices
            [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuDevice attributes:@{}];
            
            DeviceListViewController *deviceListViewController = [DeviceListViewController create];
            [((UINavigationController *)self.revealViewController.frontViewController) pushViewController:deviceListViewController animated:YES];
        }
            break;
            
        case 4: {
            
            //Tag Left Rail Menu - Settings
            [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuSettings attributes:@{}];
            
            SettingsViewController *settingsViewController = [SettingsViewController create];
            [((UINavigationController *)self.revealViewController.frontViewController) pushViewController:settingsViewController animated:YES];
        }
            break;
            
        case 5:
        {
            //Tag Left Rail Menu - Support
            [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuSupport attributes:@{}];
            
            TutorialListViewController *vc = [TutorialListViewController create];
            [((UINavigationController *)self.revealViewController.frontViewController) pushViewController:vc animated:YES];
        }
            break;
            
        case 6:
        {
            //Tag Left Rail Menu - Shop:
            [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuShop attributes:@{}];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
        }
            break;
            
        default:
            break;
    }
    
    _presentedRow = row;  // <- store the presented row
}

- (void)displayRulesListViewController {
    //Tag Left Rail Menu - Rules:
    [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuRule attributes:@{}];
        
    RuleListViewController *viewController = [RuleListViewController create];
    [((UINavigationController *)self.revealViewController.frontViewController) pushViewController:viewController animated:YES];
}

- (void)displayScenesListViewController {
    //Tag Left Rail Menu - Scene
    [ArcusAnalytics tag:AnalyticsTags.LeftSlidingMenuScene attributes:@{}];
        
    SceneListViewController *vc = [SceneListViewController create];
    [((UINavigationController *)self.revealViewController.frontViewController) pushViewController:vc animated:YES];
}

- (void)buildAndShowPlacePicker {
    ArcusModalSelectionViewController *vc = [PlacePickerModalViewController create];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SessionController listAvailablePlaces].then(^(NSArray<PlaceAndRoleModel *> *models) {
            
            PlaceModel *currentPlace = [[[CorneaHolder shared] settings] currentPlace];
            NSMutableArray<ArcusModalSelectionModel *> *placeModalModels = [NSMutableArray arrayWithCapacity:models.count];
            for (PlaceAndRoleModel *prModel in models) {
                ArcusModalSelectionModel *modalModel = [ArcusModalSelectionModel new];
                modalModel.title = prModel.placeName;
                modalModel.itemDescription = prModel.placeLocation;
                modalModel.tag = prModel.placeId;
                modalModel.image = [ArcusSettingsHomeImageHelper fetchHomeImage:prModel.placeId];

                if ([currentPlace.modelId isEqualToString:prModel.placeId]) {
                    modalModel.isSelected = YES;
                }
                [placeModalModels addObject:modalModel];
            }
            
            [placeModalModels sortUsingComparator:^NSComparisonResult(ArcusModalSelectionModel *obj1, ArcusModalSelectionModel *obj2){
                return [obj1.title compare:obj2.title options:NSCaseInsensitiveSearch];
            }];
            
            vc.selectionArray = placeModalModels;
            vc.allowMultipleSelection = NO;
            vc.delegate = ((UINavigationController *)self.revealViewController.frontViewController).viewControllers[0];
            vc.configurationDelegate = ((UINavigationController *)self.revealViewController.frontViewController).viewControllers[0];
            
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
            [((UINavigationController *)self.revealViewController.frontViewController) presentViewController:vc animated:YES completion:nil];
        });
    });
}

#pragma mark: - PlaceModel update notification
- (void)placeChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshPlaceName];
    });
}

#pragma mark: - PersonModel update notification
- (void)personChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshPersonName];
    });
}


- (void)refreshPlaceName {
    PlaceModel *placeModel = [[[CorneaHolder shared] settings] currentPlace];
    NSString *placeName = [PlaceCapability getNameFromModel:placeModel];
    [self.placeNameLabel setAttributedText:[FontData getString:placeName withFont:FontDataTypeSlidingMenuHome]];
    [self.placeNameLabel setNeedsLayout];
    [self.placeNameLabel layoutIfNeeded];
    
}

- (void)refreshPersonName {
    PersonModel *personModel = [[[CorneaHolder shared] settings] currentPerson];
    
    //Build the greeting string, if first name is empty then do not print anything:
    NSString *greetingString = [[NSString alloc ] init ];
    greetingString = [self buildGreetingString: personModel];
    
    //Create the greeting label to place on top of the gradient bar:
    self.personNameLabel.text = greetingString;
}

-(NSString *)buildGreetingString: (PersonModel *) personModel {
    
    if ([PersonCapability getFirstNameFromModel: personModel].length > 0){
        NSString *personFirstName = [PersonCapability getFirstNameFromModel: personModel];
        return [NSString stringWithFormat: @"Hello, %@", personFirstName ];
    } else {
       return [NSString stringWithFormat: @""];
    }

}

@end
