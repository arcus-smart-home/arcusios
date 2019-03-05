//
//  SceneListViewController.m
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
#import "SceneListViewController.h"
#import "CommonCheckableImageCell.h"
#import "SettingSceneViewController.h"
#import "UIImage+ImageEffects.h"

#import "SceneManager.h"



#import "SceneCapability.h"
#import "SchedulerCapability.h"
#import "ScheduleController.h"
#import "SceneScheduleController.h"
#import <i2app-Swift.h>

@interface SceneListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UILabel *numberOfScenes;
@property (nonatomic, assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet UIView *EmptyMessageView;
@property (weak, nonatomic) IBOutlet UIView *numberOfScenesView;
@property (weak, nonatomic) IBOutlet UIView *numberOfScenesViewDivider;

@end

@implementation SceneListViewController

+ (SceneListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"scene", nil) uppercaseString]];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self setBackgroundColorToDashboardColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    
    [self registerNotifications];
    [self updateUI];
    
    ScheduleController.scheduleController = [SceneScheduleController new];
    ScheduleController.scheduleController.ownerController = (SimpleTableViewController *)self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:[Model attributeChangedNotification:kAttrSceneActions] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChanged:) name:Constants.kModelAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChanged:) name:Constants.kModelRemovedNotification object:nil];
}

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance] getAllSceneTemplatesAndScenes].then(^(NSArray *sceneTemplates) {
            [self updateUI];
        }).catch (^(void) {
            [self displayGenericErrorMessage];
        }).finally(^ {
            [self.tableView reloadData];
        });
    });
}

- (void)updateUI {
    _numberOfScenes.text = [NSString stringWithFormat:@"%d", (int)[[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count];
    
    if ([[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count > 0) {
        [self navBarWithTitle:[NSLocalizedString(@"scene", nil) uppercaseString] andRightButtonText:@"Edit" withSelector:@selector(toggleEditState:)];
        self.EmptyMessageView.hidden = YES;
        self.numberOfScenesView.hidden = NO;
        self.numberOfScenesViewDivider.hidden = NO;
    }
    else {
        [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"scene", nil) uppercaseString]];
        self.EmptyMessageView.hidden = NO;
        self.numberOfScenesView.hidden = YES;
        self.numberOfScenesViewDivider.hidden = YES;
    }
}

- (void)toggleEditState:(id)sender {
    if (self.isEditing ||
        (!self.isEditing && [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count > 0)) {
        self.isEditing = !self.isEditing;
        [self navBarWithTitle:[NSLocalizedString(@"scene", nil) uppercaseString] andRightButtonText:(self.isEditing ? NSLocalizedString(@"DONE", @"") : NSLocalizedString(@"EDIT", @"")) withSelector:@selector(toggleEditState:)];
        
        [self.tableView setEditing:self.isEditing animated:YES];
    }
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfScenes = [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count;
    self.EmptyMessageView.hidden = (numberOfScenes > 0);
    return numberOfScenes;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonCheckableImageCell *cell = [CommonCheckableImageCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SceneModel *scene = [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]][indexPath.row];
    UIImage *icon = nil;
    switch ([scene getTemplateType]) {
        case SceneModelTemplateTypeCustom:
            icon = [UIImage imageNamed:@"scene_custom_white"];
            break;
        case SceneModelTemplateTypeAway:
            icon = [UIImage imageNamed:@"scene_away_white"];
            break;
        case SceneModelTemplateTypeHome:
            icon = [UIImage imageNamed:@"scene_home_white"];
            break;
        case SceneModelTemplateTypeMorning:
            icon = [UIImage imageNamed:@"scene_morning_white"];
            break;
        case SceneModelTemplateTypeNight:
            icon = [UIImage imageNamed:@"scene_night_white"];
            break;
        case SceneModelTemplateTypeVacation:
            icon = [UIImage imageNamed:@"scene_vacation_white"];
            break;
        default:
            break;
    }
    
    [cell setIcon:icon withWhiteTitle:scene.name subtitle:[self numberOfActionsString:scene]];
    [cell displayArrow:YES];
    
    [cell setCheck:[ScheduleController.scheduleController isScheduleEnabledForModel:scene] styleBlack:NO];
    [cell setOnClickEvent:@selector(onClickCheckbox:scene:) owner:self withObj:scene];
    
    if ([ScheduleController.scheduleController hasScheduledEventsForModelWithAddress:scene.address]) {
        [cell attachSideIcon:[UIImage imageNamed:@"schedule_icon"] inverseColor:NO];
    }
    else {
        [cell removeSideIcon];
    }
    
    return cell;
}

- (void)onClickCheckbox:(CommonCheckableImageCell *)cell scene:(SceneModel *)scene {
    [ScheduleController.scheduleController onCheckEnable:cell withModel:scene];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [SceneManager sharedInstance].currentScene = [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]][indexPath.row];
    [SceneManager sharedInstance].isNewScene = NO;
    
    if (self.isEditing) {
        CommonCheckableImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setCheck:![cell getChecked] styleBlack:NO];
    }
    else {
        SettingSceneViewController *vc = [SettingSceneViewController create];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [[SceneManager sharedInstance] deleteSceneAtIndex:(int)indexPath.row].then(^{
                //Tag Delete Scene
                [ArcusAnalytics tag:AnalyticsTags.SceneDelete attributes:@{}];

                _numberOfScenes.text = [NSString stringWithFormat:@"%d", (int)[[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count];
                
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
                [tableView endUpdates];
                
                if ([[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count == 0) {
                    [self toggleEditState:self];
                }
            });
        });
    }
}

#pragma mark - helpers

- (NSString *)numberOfActionsString:(SceneModel *)sceneModel {
    if ( [SceneCapability getActionsFromModel:sceneModel].count == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%d %@", (int)[SceneCapability getActionsFromModel:sceneModel].count, NSLocalizedString(@"Actions", nil)];
}

#pragma mark - Notifications
- (void)reloadData:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)modelChanged:(NSNotification *)notification {
    Model *model = notification.object;
    if (![model isKindOfClass:SceneModel.class]) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

@end
