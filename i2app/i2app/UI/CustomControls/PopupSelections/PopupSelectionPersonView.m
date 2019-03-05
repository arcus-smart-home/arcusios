//
//  PopupSelectionPersonView.m
//  i2app
//
//  Created by Arcus Team on 11/18/15.
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
#import "PopupSelectionPersonView.h"

#import "PeopleModelManager.h"

#import "UIImage+ScaleSize.h"
#import "UIImage+ImageEffects.h"
#import "ImageDownloader.h"
#import "DeviceController.h"
#import "DeviceCapability.h"

#pragma mark - PopupSelectionPersonViewCell
@interface PopupSelectionPersonViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UIImageView *checkIcon;

- (void) setPerson:(PersonModel *)device checked:(BOOL)check owner:(PopupSelectionPersonView *)owner;
- (void) setDevice:(DeviceModel *)device checked:(BOOL)check owner:(PopupSelectionPersonView *)owner;

@end


#pragma mark - PopupSelectionPersonView
@interface PopupSelectionPersonView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSArray<PersonModel *> *persons;

@end

@implementation PopupSelectionPersonView {
    NSString    *_selectedPersonID;
    
    DeviceModel *_deviceModel;
    id          _unassignedOwner;
    SEL         _unassignedSelector;
}

- (CGFloat)getHeight {
    UIView *container = self.window.container;
    if (container) {
        return container.frame.size.height - 120;
    }
    return [super getHeight];
}

+ (PopupSelectionPersonView *)create:(NSString *)title {
    PopupSelectionPersonView *selection = [[PopupSelectionPersonView alloc] initWithNibName:@"PopupSelectionPersonView" bundle:nil];
    selection.titleString = title;
    
    return selection;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
    [_tableView setTableFooterView:[[UIView alloc] init]];
    
    if (_persons == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSArray *persons) {
                
                _persons = persons;
                
                [self.tableView reloadData];
            });
        });
    }
}

#pragma mark - PickerDelegate
- (void)initializePicker {
}

- (PersonModel *)getSelectedValue {
    if (_selectedPersonID) {
        if (!_selectedPersonID) {
            if (_unassignedOwner && _unassignedSelector && [_unassignedOwner respondsToSelector:_unassignedSelector]) {
                [_unassignedOwner performSelector:_unassignedSelector withObject:nil afterDelay:0];
            }
        }
        else {
          for (PersonModel *person in _persons) {
            if ([person.modelId isEqualToString:_selectedPersonID])
              return person;
          }
        }
    }
    
    return nil;
}

- (void)setAssignedOption:(DeviceModel*)model owner:(id)owner selector:(SEL)selector assignedPerson:(PersonModel *)person {
    _deviceModel = model;
    _unassignedOwner = owner;
    if (person) {
        _selectedPersonID = person.modelId;
    }
    else {
        _selectedPersonID = nil;
    }
    _unassignedSelector = selector;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _persons.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PopupSelectionCells" owner:self options:nil];
    PopupSelectionPersonViewCell *cell = (PopupSelectionPersonViewCell *)[nib objectAtIndex:2];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row == 0) {
        [cell setDevice:_deviceModel checked:!_selectedPersonID owner:self];
    }
    else if (indexPath.row <= _persons.count) {
        PersonModel *person = [_persons objectAtIndex:indexPath.row - 1];
        [cell setPerson:person checked:(_selectedPersonID && [person.modelId isEqualToString:_selectedPersonID]) owner:self];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        _selectedPersonID = nil;
    }
    else if (indexPath.row <= _persons.count) {
        PersonModel *person = [_persons objectAtIndex:indexPath.row - 1];
        _selectedPersonID = person.modelId;
    }

    [self.tableView reloadData];
}

@end



#pragma mark - PopupSelectionPersonView
@implementation PopupSelectionPersonViewCell {
    __weak PopupSelectionPersonView *_controller;
    PersonModel *_person;
    DeviceModel *_device;
}

- (void) setPerson:(PersonModel *)person checked:(BOOL)check owner:(PopupSelectionPersonView *)owner {
    _controller = owner;
    _person = person;
    
    [self.personNameLabel styleSet:_person.fullName andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];

    UIImage *cellImage = [_person image];
    if (!cellImage) {
        cellImage = [[UIImage imageNamed:@"userIcon"] invertColor];
    }
    else {
        cellImage = [cellImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
        cellImage = [cellImage roundCornerImageWithsize:CGSizeMake(45, 45)];
    }
    
    [self.deviceImage setImage:cellImage];
    [self.checkIcon setImage:check?[UIImage imageNamed:@"CheckMark"]:[UIImage imageNamed:@"CheckmarkEmptyIcon"]];
}
- (void) setDevice:(DeviceModel *)device checked:(BOOL)check owner:(PopupSelectionPersonView *)owner {
    _controller = owner;
    _device = device;
    
    [self.personNameLabel styleSet:_device.name andButtonType:FontDataType_DemiBold_14_Black upperCase:YES];
    
    [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device] withDevTypeId:[device devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
        [self.deviceImage setImage:[image invertColor]];
    });
    [self.checkIcon setImage:check?[UIImage imageNamed:@"CheckMark"]:[UIImage imageNamed:@"CheckmarkEmptyIcon"]];
}

@end
