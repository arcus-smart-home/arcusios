//
//  PersonCallTreeViewController.m
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

#import <i2app-Swift.h>
#import "PersonCallTreeViewController.h"
#import "SDWebImageManager.h"
#import <PureLayout/PureLayout.h>
#import "PopupSelectionButtonsView.h"
#import "PopupSelectionWindow.h"

#pragma mark - Person call tree model
@implementation PersonCallTreeModel

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked {
    PersonCallTreeModel *model = [[PersonCallTreeModel alloc] init];
    [model setPersonName:name];
    [model setChecked:checked];
    return model;
}

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked attachedObj:(id)obj {
    PersonCallTreeModel *model = [[PersonCallTreeModel alloc] init];
    [model setPersonName:name];
    [model setChecked:checked];
    [model setAttachedObj:obj];
    return model;
}

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImage:(UIImage *)image {
    PersonCallTreeModel *model = [[PersonCallTreeModel alloc] init];
    [model setPersonName:name];
    [model setChecked:checked];
    [model setPortraitImage:image];
    return model;
}

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImage:(UIImage *)image andAttachedObj:(id)obj {
    PersonCallTreeModel *model = [[PersonCallTreeModel alloc] init];
    [model setPersonName:name];
    [model setChecked:checked];
    [model setPortraitImage:image];
    [model setAttachedObj:obj];
    return model;
}

+ (PersonCallTreeModel *)createWith:(NSString *)name checked:(BOOL)checked withImageUrl:(NSString *)imageUrl {
    PersonCallTreeModel *model = [[PersonCallTreeModel alloc] init];
    [model setPersonName:name];
    [model setChecked:checked];
    [model setPortraitURLPath:imageUrl];
    return model;
}

@end

#pragma mark - Person call tree cell
@interface PersonCallTreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;

- (void)setPersonModel:(PersonCallTreeModel *)model;

@end


@implementation PersonCallTreeCell {
    PersonCallTreeModel *_personModel;
}

- (void)setPersonModel:(PersonCallTreeModel *)model {
    _personModel = model;
    
    [self.titleLabel styleSet:model.personName andButtonType:FontDataType_DemiBold_14_White upperCase:YES];
    
    if (model.portraitImage) {
        [self.deviceImage setImage:model.portraitImage];
    }
    else if (model.portraitURLPath && model.portraitURLPath.length > 0) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.portraitURLPath] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [self.deviceImage setImage:model.portraitImage];
        }];
    }
    else {
        [self.deviceImage setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
    }
    
    self.deviceImage.layer.cornerRadius = self.deviceImage.bounds.size.width / 2.0f;
    [self.deviceImage autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [self.checkbox setSelected: model.checked];
}

- (void)switchChecked {
    _personModel.checked = !_personModel.checked;
    [self.checkbox setSelected: _personModel.checked];
}

- (void)layoutSubviews {
    if (self.editing) {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = 0;
        cellFrame.size.width = self.superview.frame.size.width;
        [self setFrame:cellFrame];
    }
    else {
        CGRect cellFrame = self.frame;
        cellFrame.origin.x = -30;
        cellFrame.size.width = self.superview.frame.size.width + 30;
        [self setFrame:cellFrame];
    }
    [super layoutSubviews];
}

@end

#pragma mark - Person call tree view controller
@interface PersonCallTreeViewController () <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic, assign) int maxNumberOfEnabledPeople;

@property (strong, nonatomic) NSMutableArray *callTree;
@property (strong, nonatomic) NSArray *callTreeDisplay;

@end

@implementation PersonCallTreeViewController {
    PopupSelectionWindow *_popupWindow;
}

+ (PersonCallTreeViewController *)createWithTitle:(NSString *)title toOwner:(UIViewController<PersonCallTreeDataDelegate> *)owner maxNumberOfEnabledPeople:(int)maxNumberOfEnabledPeople {
    PersonCallTreeViewController *controller = [[UIStoryboard storyboardWithName:@"Common" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    controller.title = title;
    controller.owner = owner;
    controller.maxNumberOfEnabledPeople = maxNumberOfEnabledPeople;
    
    [owner.view addSubview:controller.view];
    [controller.view autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [controller.view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [controller.view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [controller.view autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.owner setBackgroundColorToLastNavigateColor];
    [self.owner addDarkOverlay:BackgroupOverlayLightLevel];
    [self.owner addBackButtonItemAsLeftButtonItem];
    
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self loadNav];
    [self reloadData:NO];
}

- (void)loadNav {
    if ([self.owner getEnableCallTree]) {
        [self.owner navBarWithTitle:self.title andRightButtonText:@"Edit" withSelector:@selector(onClickEdit:) selectorTarget:self];
        [self.titleLabel setText:[self.owner getEnabledTitleText]];
        [self.subtitleLabel setText:[self.owner getEnabledSubtitleText]];
        
        NSString *footText = [self.owner getFootText];
        if (footText && footText.length) {
            [self.bottomLabel setText:[self.owner getFootText]];
        }
        else {
            [self.bottomLabel setText:@""];
        }
    }
    else {
        [self.owner setNavBarTitle:self.title];
        [self.titleLabel setText:[self.owner getDisabledTitleText]];
        [self.subtitleLabel setText:[self.owner getDisabledSubtitleText]];
        [self.bottomLabel setText:@""];
    }
}
- (BOOL)isValidCallTree {
    int numberOfEnabled = 0;
    for (PersonCallTreeModel *model in _callTree) {
        if (model.checked) {
            numberOfEnabled += 1;
        }
        if (numberOfEnabled > self.maxNumberOfEnabledPeople) {
            return NO;
        }
    }
    
    return YES;
}
- (void)onClickEdit:(id)sender {
    if (_tableView.editing) {
        if ([self.owner respondsToSelector:@selector(verifyEditAvaliable)]) {
            BOOL enable = [self.owner performSelector:@selector(verifyEditAvaliable)];
            if (!enable) {
                return;
            }
        }
        
        if (([self isValidCallTree]) == NO) {
            PopupSelectionButtonsView *buttonView = [PopupSelectionButtonsView createWithTitle:NSLocalizedString(@"Over limit number of enabled people", nil) subtitle:[NSString stringWithFormat:@"You just can enable up to %d people", self.maxNumberOfEnabledPeople] button:nil];
            buttonView.owner = self;
            
            _popupWindow = [PopupSelectionWindow popup:self.view subview:buttonView owner:self closeSelector:nil style:PopupWindowStyleCautionWindow];
            return;
        }
        
        [_tableView setEditing:NO animated:YES];
        
        [self.owner saveCallTree:_callTree];
        
        [self.owner navBarWithTitle:self.title andRightButtonText:@"Edit" withSelector:@selector(onClickEdit:) selectorTarget:self];
        _callTreeDisplay = [_callTree filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(PersonCallTreeModel *evaluatedObject, NSDictionary *bindings) {
            return evaluatedObject.checked;
        }]];
    }
    else {
        if ([self.owner respondsToSelector:@selector(verifyDoneAvaliable)]) {
            BOOL enable = [self.owner performSelector:@selector(verifyDoneAvaliable)];
            if (!enable) {
                return;
            }
        }
        
        [_tableView setEditing:YES animated:YES];
        [self.owner navBarWithTitle:self.title andRightButtonText:@"Done" withSelector:@selector(onClickEdit:) selectorTarget:self];
        [_tableView reloadData];
    }
    
    [_tableView reloadData];
}

- (void)reloadData:(bool)orderChanged {
    _callTree = [[NSMutableArray alloc] initWithArray:[self.owner callTreeData]];

    // Order has probably changed so save the new calltree order
    if (orderChanged) {
        [self.owner saveOrder:_callTree];
    }
    
    // This is crashing the app
    //_callTree = [self.owner sortCallTreeData:_callTree];

    _callTreeDisplay = [_callTree filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((PersonCallTreeModel *)evaluatedObject).checked;
    }]];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.isEditing) {
        return _callTree.count;
    }
    
    return _callTreeDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonCallTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    PersonCallTreeModel *model = nil;
    if (tableView.isEditing) {
        model = [_callTree objectAtIndex:indexPath.row];
    }
    else {
        model = [_callTreeDisplay objectAtIndex:indexPath.row];
    }
    
    [cell setPersonModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView.isEditing) {
        PersonCallTreeCell *cell = (PersonCallTreeCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell switchChecked];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSDictionary *fromPerson = [_callTree objectAtIndex:sourceIndexPath.row];
    
    [_callTree removeObjectAtIndex:sourceIndexPath.row];
    [_callTree insertObject:fromPerson atIndex:destinationIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}



@end
