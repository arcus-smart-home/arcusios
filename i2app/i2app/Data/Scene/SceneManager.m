//
//  SceneManager.m
//  i2app
//
//  Created by Arcus Team on 11/4/15.
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
#import "SceneManager.h"

#import "ScheduledEventModel.h"
#import "NSDate+Convert.h"

#import "SceneTemplateCapability.h"
#import "SceneCapability.h"
#import "SceneController.h"


#import "Capability.h"

#import "SchedulerCapability.h"

@interface SceneActionSelectorDefault ()

@end

@implementation SceneActionSelectorDefault

@end

@interface SceneManager ()

@end;

@implementation SceneManager {
    NSString            *_currentSceneModelId;
    SceneTemplateModel  *_currentSceneTemplate;
    SceneAction         *_currentAction;
}

@dynamic currentSceneTemplate;
@dynamic currentScene;
@dynamic currentSceneTitle;
@dynamic currentAction;

+ (SceneManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static SceneManager *manager = nil;
    dispatch_once(&pred, ^{
        manager = [[SceneManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _sceneActions = [NSMutableArray new];
    }
    return self;
}

#pragma mark - Dynamic Properties
- (SceneTemplateModel *)currentSceneTemplate {
    return _currentSceneTemplate;
}

- (void)setCurrentSceneTemplate:(SceneTemplateModel *)currentSceneTemplate {
    _currentSceneTemplate = currentSceneTemplate;

    // Get the actions associated with this template
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        [SceneController getTemplateActionsWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId onModel:_currentSceneTemplate].then(^(NSArray *actions) {
            _actions = actions;
            
            // Split between Satisfiable and Nonsatisfiable
            _satisfiableActions = [_actions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SceneAction *action, NSDictionary *bindings) {
                return action.isSatisfiable;
            }]];
            _unsatisfiableActions = [_actions filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SceneAction *action, NSDictionary *bindings) {
                return !action.isSatisfiable;
            }]];
            
            // Order them alphabetically based on the action name
            _satisfiableActions = [_satisfiableActions sortedArrayUsingComparator:^NSComparisonResult(SceneAction *a,  SceneAction *b) {
                return [a.name caseInsensitiveCompare:b.name];
            }];
            _unsatisfiableActions = [_unsatisfiableActions sortedArrayUsingComparator:^NSComparisonResult(SceneAction *a,  SceneAction *b) {
                return [a.name caseInsensitiveCompare:b.name];
            }];
        });
    });
}

- (SceneModel *)currentScene {
    if (_currentSceneModelId.length > 0) {
      NSString *address = [SceneModel addressForId:_currentSceneModelId];
      return (SceneModel *)[[[CorneaHolder shared] modelCache] fetchModel:address];
    }
    return [SceneModel new];
}

- (void)setCurrentScene:(SceneModel *)currentScene {
    _currentSceneModelId = currentScene.modelId;
    
    // set the current scene template too
    NSString *templateId = [SceneCapability getTemplateFromModel:currentScene];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"modelId", templateId];
    NSArray *filteredArray = [_allSceneTemplates filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        self.currentSceneTemplate = filteredArray[0];
    }
}

- (NSString *)currentSceneTitle {
    SceneModel *currentScene = self.currentScene;
    if (currentScene && currentScene.name.length > 0) {
        return currentScene.name;
    }
    return [SceneTemplateCapability getNameFromModel:_currentSceneTemplate];
}

- (SceneAction *)currentAction {
    return _currentAction;
}

- (void)setCurrentAction:(SceneAction *)currentAction {
    _currentAction = currentAction;
    
    if (![_sceneActions containsObject:currentAction]) {
        [_sceneActions addObject:currentAction];
    }
}

#pragma mark - Get All Scenes
- (PMKPromise *)getAllSceneTemplatesAndScenes {
    return [SceneController getAllSceneTemplates:[[CorneaHolder shared] settings].currentPlace.modelId].thenInBackground(^(NSMutableArray<SceneTemplateModel *> *sceneTemplates) {
        _allSceneTemplates = sceneTemplates;
        
        return [SceneController getAllScenes:[[CorneaHolder shared] settings].currentPlace.modelId].thenInBackground(^(NSArray *scenes) {
            return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
                fulfill(sceneTemplates);
            }];
        });
    });
}

#pragma mark - Reset Current Scene
- (void)resetCurrentScene {
    _currentSceneModelId = nil;
    _currentSceneTemplate = nil;
    _currentAction = nil;
    [_sceneActions removeAllObjects];
    [_scheduledEvents removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Constants.kModelAddedNotification object:nil];
}

- (PMKPromise *)createScene {
    // We are going to wait for the "base:Added" event to get the newly created scene model
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sceneAdded:) name:Constants.kModelAddedNotification object:nil];
    return [SceneController createWithPlaceId:[[CorneaHolder shared] settings].currentPlace.modelId withName:[SceneTemplateCapability getNameFromModel:_currentSceneTemplate] onModel:_currentSceneTemplate];
}

- (PMKPromise *)deleteCurrentScene {
    if (!self.currentScene) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) { reject([NSError errorWithDomain:@"Arcus" code:401 userInfo:@{NSLocalizedDescriptionKey : @"Current scene is nil"}]); }];
    }

    return [SceneCapability deleteOnModel:self.currentScene].then(^{
        [self resetCurrentScene];
    });
}

- (PMKPromise *)deleteSceneAtIndex:(int)index {
    if (index >= [[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]].count) {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) { }];
    }
    
    SceneModel *sceneModel = [[[[CorneaHolder shared] modelCache] fetchModels:[SceneCapability namespace]] objectAtIndex:index];
    if (sceneModel) {
        return [SceneCapability deleteOnModel:sceneModel];
    }
    else {
        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) { }];
    }
}

#pragma mark - Notifications
- (void)sceneAdded:(NSNotification *)note {
    if ([note.object isKindOfClass:[SceneModel class]]) {
        _currentSceneModelId = ((SceneModel *)note.object).modelId;
        [self.currentScene setSceneIsEmpty:YES];
    }
}

@end
