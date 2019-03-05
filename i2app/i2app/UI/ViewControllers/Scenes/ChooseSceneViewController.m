//
//  ChooseSceneViewController.m
//  i2app
//
//  Created by Arcus Team on 10/22/15.
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
#import "ChooseSceneViewController.h"
#import "CommonIconTitleCellTableViewCell.h"
#import "SettingSceneViewController.h"

#import "SceneManager.h"
#import "SceneTemplateCapability.h"


#import "SceneScheduleController.h"
#import "SceneCapability.h"
#import <i2app-Swift.h>

@interface ChooseSceneViewController () <UITableViewDelegate , UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation ChooseSceneViewController {
    NSMutableArray<SceneTemplateModel *> *_sceneTemplates;
}

+ (ChooseSceneViewController *)create {
    ScheduleController.scheduleController = [SceneScheduleController new];
    ScheduleController.scheduleController.ownerController = (SimpleTableViewController *)self;
    
    ChooseSceneViewController *vc = [[UIStoryboard storyboardWithName:@"Scenes" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:@"Choose a scene"];
    [self setBackgroundColorToDashboardColor];
    [self addWhiteOverlay:BackgroupOverlayMiddleLevel];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setTableFooterView:[[UIView alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)loadData {
    [self createGif];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance] getAllSceneTemplatesAndScenes].then(^(NSArray *sceneTemplates) {
            _sceneTemplates = [[NSMutableArray alloc] initWithCapacity:sceneTemplates.count];
            for (SceneTemplateModel *sceneTemplate in sceneTemplates) {
                if ([SceneTemplateCapability getAvailableFromModel:sceneTemplate]) {
                    [_sceneTemplates addObject:sceneTemplate];
                }
            }
            [self hideGif];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - implement UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sceneTemplates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonIconTitleCellTableViewCell *cell = [CommonIconTitleCellTableViewCell create:tableView];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    SceneTemplateModel *sceneTemplate = _sceneTemplates[indexPath.row];
    
    [cell setIcon:[UIImage imageNamed:[@"scene_" stringByAppendingString:sceneTemplate.modelId]] withBlackTitle:[SceneTemplateCapability getNameFromModel:sceneTemplate] subtitle:[SceneTemplateCapability getDescriptionFromModel:sceneTemplate]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [SceneManager sharedInstance].isNewScene = YES;
    [SceneManager sharedInstance].currentSceneTemplate = _sceneTemplates[indexPath.row];
    
    [self createGif];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [[SceneManager sharedInstance] createScene]
        .then(^(SceneTemplateCreateResponse *response) {
            [SceneManager sharedInstance].currentScene = (SceneModel*)[[[CorneaHolder shared] modelCache] fetchModel:[response getAddress]];
            //Tag Add Scene
            [ArcusAnalytics tag:AnalyticsTags.SceneAdd attributes:@{}];
            [self goToSettingSceneViewController];
        })
        .catch(^(NSError *error) {
            [self displayGenericErrorMessageWithError:error];
        })
        .finally(^ {
            [self hideGif];
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)goToSettingSceneViewController {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSArray *vcs = self.navigationController.viewControllers;
    if (![vcs[vcs.count - 1] isKindOfClass:[SettingSceneViewController class]]) {
      SettingSceneViewController *vc = [SettingSceneViewController create];
      [self.navigationController pushViewController:vc animated:YES];
    }
  });
}

@end
