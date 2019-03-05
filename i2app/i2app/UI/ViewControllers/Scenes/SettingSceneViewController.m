//
//  SettingSceneViewController.m
//  i2app
//
//  Created by Arcus Team on 10/23/15.
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
#import "SettingSceneViewController.h"
#import "CommonTitleValueonRightCell.h"
#import "CommonTitleWithSwitchCell.h"
#import "CommonTitleWithSubtitleCell.h"
#import "CommonCheckableImageCell.h"
#import "SceneManager.h"
#import "SceneNameEditingViewController.h"
#import "SceneDeviceListViewController.h"
#import "SceneActionsViewController.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionButtonsView.h"
#import "ScheduleController.h"

#import "SceneCapability.h"
#import "SceneController.h"
#import "FavoriteController.h"
#import "WeeklyScheduleViewController.h"
#import "SceneScheduleController.h"
#import <i2app-Swift.h>

#define kScheduleFireEnabled  @"sched:enabled:FIRE"

@interface SettingSceneViewController () <CommonTitleWithSwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreButton;

@property (nonatomic, strong) NSString *sceneName;
@property (nonatomic, assign) BOOL notificationEnabled;
@property (nonatomic, assign) BOOL isFavorite;

@end

@implementation SettingSceneViewController {
    PopupSelectionWindow *_popupWindow;
    NSMutableArray<UITableViewCell *> *_optionCells;
    __weak IBOutlet NSLayoutConstraint *tableviewBottomConstraint;
    BOOL _isSaved;
}

#pragma mark - View LifeCycle

+ (SettingSceneViewController *)create {
    SettingSceneViewController *controller = [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isSaved = NO;
    
    [self navBarWithBackButtonAndTitle:self.sceneName];
    [self setBackgroundColorToDashboardColor];
    
    if ([SceneManager sharedInstance].isNewScene) {
        [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
        [_tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    }
    else {
        [self addDarkOverlay:BackgroupOverlayLightLevel];
        [_tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    }
    
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[UIView new]];
    
    [self loadData];

    [self registerNotifications];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model attributeChangedNotification:kScheduleFireEnabled] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model attributeChangedNotification:kAttrSceneNotification] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model tagChangedNotification:@"FAVORITE"] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model tagChangedNotification:kAttrSceneActions] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model tagChangedNotification:kAttrSceneName] object:nil];
}

- (void)back:(NSObject *)sender {
    if ([SceneManager sharedInstance].isNewScene && !_isSaved) {
        
        PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:@"Are you sure?" subtitle:@"Are you sure you wish to discard the scene?" button:[PopupSelectionButtonModel create:NSLocalizedString(@"YES, Discard this scene", nil) event:@selector(discardThis:)], [PopupSelectionButtonModel create:NSLocalizedString(@"Cancel", nil) event:nil], nil];
        buttonView.owner = self;
        [self popupWarning:buttonView complete:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)discardThis:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance] deleteCurrentScene].then(^ {
            [[SceneManager sharedInstance] resetCurrentScene];
            
            //Tag Delete Scene
            [ArcusAnalytics tag:AnalyticsTags.SceneDelete attributes:@{}];
        }).finally(^ {
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

#pragma mark - Data Loading

- (void)loadData {
    self.learnMoreButton.layer.borderWidth = 1;
    self.learnMoreButton.layer.cornerRadius = 6.0f;    
    
    _optionCells = [[NSMutableArray alloc] init];
    [_saveButton addTarget:self action:@selector(onClickSave:) forControlEvents:UIControlEventTouchUpInside];

    CommonCheckableImageCell *cell2 = [CommonCheckableImageCell create:self.tableView];
    [cell2 setIcon:nil withTitle:NSLocalizedString(@"SCHEDULE", nil) subtitle:NSLocalizedString(@"Set this Scene on a specific day or time", nil) andSide:nil withBlackFont:([SceneManager sharedInstance].isNewScene && _optionCells.count <= 0)];
    [cell2 hideCheckbox];
    [cell2 hideIconImage];
    if ([ScheduleController.scheduleController hasScheduledEventsForModelWithAddress:[SceneManager sharedInstance].currentScene.address]) {
        [cell2 attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
    }
    else {
        [cell2 removeSideIcon];
    }

    if ([SceneManager sharedInstance].isNewScene && _optionCells.count <= 0) {
        tableviewBottomConstraint.constant = 60;
        _saveButton.hidden = NO;
        
        [_saveButton styleSet:NSLocalizedString(@"SAVE", nil) andButtonType:FontDataTypeButtonDark upperCase:YES];
        self.learnMoreButton.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.learnMoreButton styleSet:@"  Learn More  " andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:YES space:YES] upperCase:YES];
        
        CommonTitleWithSubtitleCell *cell1 = [CommonTitleWithSubtitleCell create:self.tableView];
        [cell1 setBlackTitle:NSLocalizedString(@"Action", nil) subtitle:NSLocalizedString(@"Choose what this Scene does", nil) side:nil];
        [_optionCells addObject:cell1];
        
        [_optionCells addObject:cell2];
        
        CommonTitleWithSwitchCell *cell3 = [CommonTitleWithSwitchCell create:self.tableView];
        [cell3 setBlackTitle:NSLocalizedString(@"FAVORITES", nil) subtitle:NSLocalizedString(@"Add to Favorites", nil) selected:[FavoriteController modelIsFavorite:[SceneManager sharedInstance].currentScene]];
        [_optionCells addObject:cell3];
        
        CommonTitleWithSwitchCell *cell4 = [CommonTitleWithSwitchCell create:self.tableView];
        [cell4 setBlackTitle:NSLocalizedString(@"Notification", nil) subtitle:NSLocalizedString(@"Notify me when this Scene is activated", nil) selected:[SceneCapability getNotificationFromModel:[SceneManager sharedInstance].currentScene]];
        [_optionCells addObject:cell4];
        
        CommonTitleWithSubtitleCell *cell5 = [CommonTitleWithSubtitleCell create:self.tableView];
        [cell5 setBlackTitle:NSLocalizedString(@"EDIT NAME", nil) subtitle:@"" side:self.sceneName];
        [_optionCells addObject:cell5];
    }
    else if (![SceneManager sharedInstance].isNewScene) {
        tableviewBottomConstraint.constant = 0;
        [_saveButton setHidden:YES];
        
        [_saveButton styleSet:NSLocalizedString(@"SAVE",nil) andButtonType:FontDataTypeButtonLight upperCase:YES];
        self.learnMoreButton.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self.learnMoreButton styleSet:NSLocalizedString(@"  Learn More  ",nil) andFontData:[FontData createFontData:FontTypeDemiBold size:13 blackColor:NO space:YES] upperCase:YES];
        
        CommonTitleWithSubtitleCell *cell1 = _optionCells.count > 0 ? (CommonTitleWithSubtitleCell *)[_optionCells objectAtIndex:0] : nil;
        if (!cell1) {
            cell1 = [CommonTitleWithSubtitleCell create:self.tableView];
            [_optionCells addObject:cell1];
        }
        [cell1 setWhiteTitle:NSLocalizedString(@"Action", nil) subtitle:NSLocalizedString(@"Choose what this Scene does",nil) side:[self numberOfActionsString]];
        
        [_optionCells addObject:cell2];
        
        CommonTitleWithSwitchCell *cell3 = _optionCells.count > 2 ? (CommonTitleWithSwitchCell *)[_optionCells objectAtIndex:2] : nil;
        if (!cell3) {
            cell3 = [CommonTitleWithSwitchCell create:self.tableView];
            [_optionCells addObject:cell3];
        }
        [cell3 setWhiteTitle:NSLocalizedString(@"FAVORITES", nil) subtitle:NSLocalizedString(@"Add to Favorites", nil) selected:[FavoriteController modelIsFavorite:[SceneManager sharedInstance].currentScene]];

        CommonTitleWithSwitchCell *cell4 = _optionCells.count > 3 ? (CommonTitleWithSwitchCell *)[_optionCells objectAtIndex:3] : nil;
        if (!cell4) {
            cell4 = [CommonTitleWithSwitchCell create:self.tableView];
            [_optionCells addObject:cell4];
        }
        [cell4 setWhiteTitle:NSLocalizedString(@"Notification",nil) subtitle:NSLocalizedString(@"Notify me when this Scene is activated", nil) selected:[SceneCapability getNotificationFromModel:[SceneManager sharedInstance].currentScene]];

        CommonTitleWithSubtitleCell *cell5 = _optionCells.count > 4 ? (CommonTitleWithSubtitleCell *)[_optionCells objectAtIndex:4] : nil;
        if (!cell5) {
            cell5 = [CommonTitleWithSubtitleCell create:self.tableView];
            [_optionCells addObject:cell5];
        }
        [cell5 setWhiteTitle:NSLocalizedString(@"EDIT NAME", nil) subtitle:@"" side:self.sceneName];
    }
    
    [self.tableView reloadData];
}

- (void)onClickSave:(id)sender {
    _isSaved = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters & Setters

- (NSString *)sceneName {
    if (!_sceneName) {
        _sceneName = [SceneManager sharedInstance].currentSceneTitle;
    }
    return _sceneName;
}

- (NSString *)numberOfActionsString {
    SceneModel *sceneModel =  [SceneManager sharedInstance].currentScene;
    if ( [SceneCapability getActionsFromModel:sceneModel].count == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%d", (int)[SceneCapability getActionsFromModel:sceneModel].count];
}

#pragma mark - IBActions

- (IBAction)onClickSaveButton:(id)sender {
    if ([SceneManager sharedInstance].sceneActions.count == 0) {
        PopupSelectionButtonsView *container = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"No Actions selected", nil) subtitle:NSLocalizedString(@"No Actions selected in SettingSceneViewController", nil) button: nil];
        container.owner = self;
        
        [self popupWarning:container complete:nil];
    }
    else {
        [[SceneManager sharedInstance] createScene];
    }
}

- (IBAction)onClickLearnMoreButton:(id)sender {
    
    NSString *textKey = @"-";
    switch ([[SceneManager sharedInstance].currentScene getTemplateType]) {
        case SceneModelTemplateTypeNight:
            textKey = NSLocalizedString(@"learn more night in SettingSceneViewController",nil);
            break;
        case SceneModelTemplateTypeAway:
            textKey = NSLocalizedString(@"learn more away in SettingSceneViewController",nil);
            break;
        case SceneModelTemplateTypeVacation:
            textKey = NSLocalizedString(@"learn more vacation in SettingSceneViewController",nil);
            break;
        case SceneModelTemplateTypeHome:
            textKey = NSLocalizedString(@"learn more home in SettingSceneViewController",nil);
            break;
        case SceneModelTemplateTypeMorning:
            textKey = NSLocalizedString(@"learn more morning in SettingSceneViewController",nil);
            break;
        case SceneModelTemplateTypeCustom:
            textKey = NSLocalizedString(@"learn more custom in SettingSceneViewController",nil);
            break;
        default:
            break;
    }
    
    PopupSelectionButtonsView *container = [PopupSelectionButtonsView createWithTitle:@"Learn More" subtitle:textKey button: nil];
    container.owner = self;
    
    [self popup:container complete:nil];
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _optionCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_optionCells objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            SceneActionsViewController *vc = [SceneActionsViewController create];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            [ArcusAnalytics tag:AnalyticsTags.SceneScheduleEdit attributes:@{}];
            ScheduleController.scheduleController.schedulingModelAddress = [SceneManager sharedInstance].currentScene.address;
            
            WeeklyScheduleViewController *vc = [WeeklyScheduleViewController create];
            vc.hasLightBackground = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            [ArcusAnalytics tag:AnalyticsTags.SceneFav attributes:@{}];
            CommonTitleWithSwitchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setSwitchSelected:!cell.switchSelected];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [FavoriteController model:[SceneManager sharedInstance].currentScene isFavorite:cell.switchSelected];
                [[SceneManager sharedInstance].currentScene commit];
            });
        }
            break;
        case 3:{
            CommonTitleWithSwitchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setSwitchSelected:!cell.switchSelected];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [SceneCapability setNotification:cell.switchSelected onModel:[SceneManager sharedInstance].currentScene];
                [[SceneManager sharedInstance].currentScene commit];
            });
        }
            break;
        case 4: {
            SceneEditNameCompletion completion = ^ (NSString *sceneName) {
                if (sceneName) {
                    [self updateSceneName:sceneName
                            sceneNameCell:[tableView cellForRowAtIndexPath:indexPath]];
                }
            };
            
            SceneNameEditingViewController *vc = [SceneNameEditingViewController create];
            vc.sceneName = self.sceneName;
            vc.completion = completion;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)updateSceneName:(NSString *)sceneName sceneNameCell:(CommonTitleWithSubtitleCell *)cell {
    self.sceneName = sceneName;
    
    [self navBarWithBackButtonAndTitle:self.sceneName];
    
    if (cell) {
        if ([SceneManager sharedInstance].isNewScene) {
            [cell setBlackTitle:NSLocalizedString(@"EDIT NAME",nil)
                       subtitle:self.sceneName
                           side:@""];
        }
        else {
            [cell setWhiteTitle:NSLocalizedString(@"EDIT NAME",nil)
                       subtitle:self.sceneName
                           side:@""];
        }
    }
    
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [SceneCapability setName:self.sceneName
                         onModel:[SceneManager sharedInstance].currentScene];
        [[SceneManager sharedInstance].currentScene commit];
    });

}

#pragma mark - helpers 
- (void)popup:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    if (!_popupWindow || !_popupWindow.displaying) {
        _popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:container
                                             owner:self
                                     closeSelector:selector];
    }
}

- (void)popupWarning:(PopupSelectionBaseContainer *)container complete:(SEL)selector {
    if (!_popupWindow || !_popupWindow.displaying) {
        _popupWindow = [PopupSelectionWindow popup:self.view
                                           subview:container
                                             owner:self
                                     closeSelector:selector
                                             style:PopupWindowStyleCautionWindow];
    }
}

#pragma mark - notification
- (void)reloadData:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(),^{
        [self loadData];
    });
}

@end
