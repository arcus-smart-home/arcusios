//
//  HomeFamilyViewController.m
//  i2app
//
//  Created by Arcus Team on 11/16/15.
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
#import "HomeFamilyViewController.h"
#import <PureLayout/PureLayout.h>


#import "PersonService.h"
#import "PersonCapability.h"
#import "PersonController.h"
#import "PresenceSubsystemController.h"
#import "DeviceCapability.h"



#import "UIImage+ScaleSize.h"
#import "AKFileManager.h"
#import "ImageDownloader.h"
#import "DeviceRenameAssignmentController.h"

@interface HomeFamilyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *peopleDevicesListHome;
@property (nonatomic, strong) NSMutableArray *peopleDevicesListAway;




@end

@implementation HomeFamilyViewController {
    BOOL _isEmptyHome;
    BOOL _isAllTogater;
}

+ (HomeFamilyViewController *)create {
    HomeFamilyViewController *controller = [[UIStoryboard storyboardWithName:@"ServicesDetail" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    return controller;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setTitle:NSLocalizedString(@"Status", nil)];
    _isEmptyHome = NO;
    _isAllTogater = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self observeNotifications];

    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:[UIView new]];
}

- (void)dealloc {
  [self removeNotificationObservers];
}

- (void)observeNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(subsystemUpdated:)
                                               name:kSubsystemInitializedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(subsystemUpdated:)
                                               name:kSubsystemUpdatedNotification
                                             object:nil];
}

- (void)removeNotificationObservers {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)subsystemUpdated:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self loadData];
    });
}

/**
  * Fetch Data from the platform and reloadData on the tableView
  * @warning this is not a threadsafe function, it must be called on the main thread
  */
- (void)loadData {
    
    //Count the number of people at home:
    NSArray *peopleAtHome = [[SubsystemsController sharedInstance].presenceController allPeopleAtHomeAddresses];
    
    //Count the total number of devices at home:
    NSArray *devicesAtHome = [[SubsystemsController sharedInstance].presenceController allDevicesAtHomeAddresses];
    
    NSArray *peopleAway = [[SubsystemsController sharedInstance].presenceController allPeopleAwayAddresses];
    
    NSArray *devicesAway = [[SubsystemsController sharedInstance].presenceController allDevicesAwayAddresses];
    
    // int homeCount = peopleAtHome.count + devicesAtHome.count;
    // int awayCount = peopleAway.count + devicesAway.count;
    
    _peopleDevicesListHome = [[NSMutableArray alloc] init];
    _peopleDevicesListAway = [[NSMutableArray alloc] init];
    
    
    //Load people and devices at home:
    for (NSString *personString in peopleAtHome) {
        
        [_peopleDevicesListHome addObject: personString];
        
    }
    
    for (NSString *deviceString in devicesAtHome) {
        
        [_peopleDevicesListHome addObject: deviceString];
    }
    
    //Load people and devices away:
    for (NSString *personString in peopleAway) {
        
        [_peopleDevicesListAway addObject: personString];
        
    }
    
    for (NSString *deviceString in devicesAway) {
        
        [_peopleDevicesListAway addObject: deviceString];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace]
        .then(^(NSArray *personList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    });
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Pull in the count of Home and Away for each section for rows:
    
    //Count the number of people at home:
    NSArray *peopleAtHome = [[SubsystemsController sharedInstance].presenceController allPeopleAtHomeAddresses];
    
    //Count the total number of devices at home:
    NSArray *devicesAtHome = [[SubsystemsController sharedInstance].presenceController allDevicesAtHomeAddresses];
    
    NSArray *peopleAway = [[SubsystemsController sharedInstance].presenceController allPeopleAwayAddresses];
    
    NSArray *devicesAway = [[SubsystemsController sharedInstance].presenceController allDevicesAwayAddresses];
    
    int homeCount = (int)(peopleAtHome.count + devicesAtHome.count);
    
    int awayCount = (int)(peopleAway.count + devicesAway.count);
    
    _isEmptyHome = homeCount==0;
    _isAllTogater = awayCount==0;
    
    if (section == 0) {
        if (_isEmptyHome) {
            return 1;
        }
        else {
            return homeCount;
        }
    }
    else {
        if (_isAllTogater) {
            return 1;
        }
        else {
            return awayCount;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && _isEmptyHome) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyHomeCell"];
        return cell;
    }
    else if (indexPath.section == 1 && _isAllTogater) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"togetherCell"];
        return cell;
    }
    
    HomeFamilyStatusCell *statusCell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
    
    [statusCell setBackgroundColor:[UIColor clearColor]];
    
    NSString *modelAddress = @"";
    
    if (indexPath.section == 0) {
        // people and device at home
        modelAddress = [_peopleDevicesListHome objectAtIndex:indexPath.row];
    }
    else {
        // people and device away
        modelAddress = [_peopleDevicesListAway objectAtIndex:indexPath.row];
    }
    NSString *presenceType = [modelAddress substringToIndex:4];
    
    if ([presenceType isEqualToString:Constants.kService]) {
        //Get the person object:
        PersonModel *personModel = (PersonModel *)[[[CorneaHolder shared] modelCache] fetchModel:modelAddress];
        [statusCell setPersonDeviceAttribute: personModel.fullName];
        
        UIImage *personIcon = [personModel image];
        if (personIcon) {
            personIcon = [personIcon exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
            personIcon = [personIcon roundCornerImageWithsize:CGSizeMake(45, 45)];
            
            statusCell.imageView.layer.cornerRadius = statusCell.imageView.bounds.size.width / 2.0f;
            [statusCell.imageView setImage:personIcon];
        }
        else {
            // [statusCell.imageView setImage:[UIImage imageNamed:@"userIcon"]];
            [statusCell.imageView setImage:[[UIImage imageNamed:@"userIcon"] exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)]];
        }
        [statusCell setPersonDeviceSubtitle: [personModel getSubtitle]];
    }
    else {
        //Get the device object:
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:modelAddress];
        
        NSString *deviceName = [DeviceCapability getNameFromModel:deviceModel];
        [statusCell setPersonDeviceAttribute: deviceName];
        
        UIImage *image = [[AKFileManager defaultManager] cachedImageForHash:deviceModel.modelId
                                                                     atSize:[UIScreen mainScreen].bounds.size
                                                                  withScale:[UIScreen mainScreen].scale];
        
        if (image) {
            image = [image exactZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)];
            image = [image roundCornerImageWithsize:CGSizeMake(45, 45)];
            
            statusCell.imageView.layer.cornerRadius = statusCell.imageView.bounds.size.width / 2.0f;
            [statusCell.imageView setImage:image];
        }
        else {
            [statusCell.imageView setImage:[UIImage imageNamed:@"PlaceholderWhite"]];
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:deviceModel] withDevTypeId:[deviceModel devTypeHintToImageName] withPlaceHolder:nil isLarge:NO isBlackStyle:NO].then(^(UIImage *image) {
                if (image) {
                    [statusCell.imageView setImage:[image backgroundZoomScaleAndCutSizeInCenter:CGSizeMake(45, 45)]];
                }
            });
        }
        [statusCell setPersonDeviceSubtitle: @"Unassigned"];
    }

    statusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return statusCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2f]];
    
    
    UILabel *label = [[UILabel alloc] initForAutoLayout];
    [label styleSet:((section == 0)?@"Home":@"Away") andButtonType:FontDataType_DemiBold_14_White_NoSpace];
    
    [view addSubview:label];
    [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:15.0f];
    
    
    UILabel *label1 = [[UILabel alloc] initForAutoLayout];
    NSString *strFromInt = [NSString stringWithFormat:@"%d", (int)(section == 0 ?_peopleDevicesListHome.count: _peopleDevicesListAway.count)];
    [label1 styleSet:strFromInt andFontData:[FontData createFontData:FontTypeMedium size:14 blackColor:NO alpha:YES]];
    
    [view addSubview:label1];
    [label1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [label1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:view withOffset:350.0f];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && _isEmptyHome) || (indexPath.section == 1 && _isAllTogater)) {
        return 90;
    }
    else {
        return 70;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *modelAddress = @"";

    if (indexPath.section == 0 && !_isEmptyHome) {
        // people and device at home
        modelAddress = [_peopleDevicesListHome objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 1 && !_isAllTogater) {
        // people and device away
        modelAddress = [_peopleDevicesListAway objectAtIndex:indexPath.row];
    }

    if (modelAddress.length > 0) {
        NSString *presenceType = [modelAddress substringToIndex:4];

        if ([presenceType isEqualToString:Constants.kService]) {
            //Get the person object:
            PersonModel *personModel = (PersonModel *) [[[CorneaHolder shared] modelCache] fetchModel:modelAddress];

            //Convert to DeviceModel
            modelAddress = [[SubsystemsController sharedInstance].presenceController findDeviceAssignedToPerson:personModel];
        }

        //Get the device object:
        DeviceModel *deviceModel = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:modelAddress];

        DeviceRenameAssignmentController *vc = [DeviceRenameAssignmentController createWithDeviceModel:deviceModel];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell layoutIfNeeded];
}

@end


@implementation HomeFamilyStatusCell

- (void)setPersonDeviceAttribute:(NSString *)fname {
    [self.personDeviceName styleSet:fname andFontData:[FontData createFontData:FontTypeDemiBold size:14 blackColor:NO space:YES] upperCase:YES];
    
}

- (void)setPersonDeviceSubtitle:(NSString *)personTitle {
    [self.personDeviceOther styleSet:personTitle andFontData:[FontData createFontData:FontTypeMediumItalic size:13 blackColor:NO space:NO alpha:YES]];
}


@end

@interface HomeFamilyMessageStatusCell: UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation HomeFamilyMessageStatusCell



@end





