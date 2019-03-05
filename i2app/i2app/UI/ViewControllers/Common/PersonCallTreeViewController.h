//
//  PersonCallTreeViewController.h
//  i2app
//
//  Created by Arcus Team on 9/14/15.
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
#import <UIKit/UIKit.h>

#pragma mark - person call tree model
@interface PersonCallTreeModel : NSObject

@property (strong, nonatomic) NSString *personName;
@property (nonatomic) BOOL checked;
@property (strong, nonatomic) id attachedObj;

@property (strong, nonatomic) UIImage *portraitImage;
// Works when doesn't have person face image
@property (strong, nonatomic) NSString *portraitURLPath;

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked;
+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked attachedObj:(id)obj;

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImage:(UIImage *)image;
+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImage:(UIImage *)image andAttachedObj:(id)obj;
+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImageUrl:(NSString *)imageUrl;

@end

#pragma mark - person call tree delegate
@protocol PersonCallTreeDataDelegate<NSObject>

@required

- (BOOL)getEnableCallTree;

- (NSString *)getEnabledTitleText;
- (NSString *)getEnabledSubtitleText;

- (NSString *)getDisabledTitleText;
- (NSString *)getDisabledSubtitleText;

- (NSString *)getFootText;

- (void) saveCallTree:(NSArray *)callTree;

// the typr of callTreeData should be @[PersonCallTreeModel]
- (NSArray *)callTreeData;
- (void)saveOrder:(NSArray *)orderedCallTreeData;

@optional
// @return if able to edit mode
- (BOOL)verifyEditAvaliable;
// @return if able to be done
- (BOOL)verifyDoneAvaliable;

- (NSArray *)sortCallTreeData:(NSArray *)callTreeData;
@end

#pragma mark - person call tree controller

__attribute__((deprecated(("Use PesonCallTreeListViewController instead."))))
@interface PersonCallTreeViewController : UIViewController

@property (strong, nonatomic) UIViewController<PersonCallTreeDataDelegate> *owner;

+ (PersonCallTreeViewController *)createWithTitle:(NSString *)title toOwner:(UIViewController<PersonCallTreeDataDelegate> *)owner maxNumberOfEnabledPeople:(int)maxNumberOfEnabledPeople;

- (void)loadNav;
- (void)reloadData:(bool)orderChanged;

@end
