//
//  PeopleListViewController.m
//  i2app
//
//  Created by Arcus Team on 9/24/15.
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
#import "PeopleListViewController.h"


#import "ArcusImageTitleDescriptionTableViewCell.h"
#import "PeopleDetailViewController.h"
#import "PeopleModelManager.h"
#import "UIImage+ScaleSize.h"




@interface PeopleListViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PeopleModelManager *peopleManager;

@end

@implementation PeopleListViewController

#pragma mark - View LifeCycle

+ (PeopleListViewController *)create {
    return [[UIStoryboard storyboardWithName:@"PeopleSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:self.navigationItem.title];
    [self setBackgroundColorToLastNavigateColor];
    [self addDarkOverlay:BackgroupOverlayLightLevel];
    [self addBackButtonItemAsLeftButtonItem];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Data Fetching

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [PersonController listPersonsForPlaceModel:[[CorneaHolder shared] settings].currentPlace].then(^(NSArray *personList) {
            personList = [PersonModel filterOwner:personList];
            _peopleManager = [PeopleModelManager create:personList];
            
            [self.tableView reloadData];
        });
    });
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if (_peopleManager) {
        rows = _peopleManager.people.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PersonCell";
    
    ArcusImageTitleDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (!cell) {
        cell = [[ArcusImageTitleDescriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:CellIdentifier];
        
        //Setting cell background color to clear to override controller settings for cell making white background on iPad:
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    PersonModel *person = [_peopleManager.people objectAtIndex:indexPath.row];
    
    NSString *titleString = [person.fullName uppercaseString];
    NSAttributedString *titleText = [[NSAttributedString alloc] initWithString:titleString
                                                                    attributes:[FontData getWhiteFontWithSize:12.0f
                                                                                                         bold:NO
                                                                                                      kerning:2.0f]];
    [cell.titleLabel setAttributedText:titleText];
    
    
    NSDictionary *subTitleFontData = [FontData getItalicFontWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6f]
                                                                 size:14.0
                                                              kerning:0.0];
    
    NSString *description = person.getSubtitle;
    NSAttributedString *descText = [[NSAttributedString alloc] initWithString:description
                                                                   attributes:subTitleFontData];
    [cell.descriptionLabel setAttributedText:descText];
    
    UIImage *cachedImage = [person image];
    if (cachedImage) {
        cachedImage = [cachedImage exactZoomScaleAndCutSizeInCenter:CGSizeMake(30, 30)];
        cachedImage = [cachedImage roundCornerImageWithsize:CGSizeMake(30, 30)];
    }
    UIImage *image = cachedImage != nil ? cachedImage : [UIImage imageNamed:@"userIcon"];
    
    if (image) {
        cell.detailImage.image = image;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.peopleManager setCurrentToIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowPersonDetailSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"ShowPersonDetailSegue"]) {
        PeopleDetailViewController *detailViewController = (PeopleDetailViewController *)segue.destinationViewController;
        detailViewController.manager = self.peopleManager;
    }
}

@end
