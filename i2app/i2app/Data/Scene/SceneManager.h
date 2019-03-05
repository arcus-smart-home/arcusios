//
//  SceneManager.h
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

#import <Foundation/Foundation.h>



@class ScheduledEventModel;
@class SceneAction;
@class Model;
@class PMKPromise;

@interface SceneActionSelectorDefault : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *initialParam;
@property (nonatomic, strong) NSObject *initialValue;
@property (nonatomic, strong) NSDictionary *attributes;

@end

@interface SceneManager : NSObject

+ (SceneManager *)sharedInstance;

@property (nonatomic, strong) NSMutableArray<SceneTemplateModel *> *allSceneTemplates;

@property (nonatomic, strong) SceneTemplateModel *currentSceneTemplate;
@property (nonatomic, strong) SceneModel *currentScene;

@property (nonatomic, strong) SceneAction *currentAction;
@property (nonatomic, strong, readonly) NSMutableArray <SceneAction *> *sceneActions;

@property (nonatomic, strong) NSArray <Model *> *selectors;
@property (nonatomic, assign, readonly) NSString *currentSceneTitle;

@property (atomic, assign) BOOL isNewScene;

@property (nonatomic, strong, readonly) NSArray *actions;
@property (nonatomic, strong, readonly) NSArray<SceneAction *> *satisfiableActions;
@property (nonatomic, strong, readonly) NSArray<SceneAction *> *unsatisfiableActions;

@property (strong, nonatomic) NSMutableArray<ScheduledEventModel *> *scheduledEvents;

- (PMKPromise *)getAllSceneTemplatesAndScenes;

- (void)resetCurrentScene;

- (PMKPromise *)createScene;
- (PMKPromise *)deleteCurrentScene;
- (PMKPromise *)deleteSceneAtIndex:(int)index;

@end
