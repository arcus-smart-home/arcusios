//
//  SmartStreetChooseViewController
//  i2app
//
//  Created by Arcus Team on 7/7/15.
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
#import "SmartStreetChooseViewController.h"
#import "SmartStreetTextField.h"
#import "SmartyStreets.h"

@interface SmartStreetChooseViewController () <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SmartStreetTextField *textField;
@property (strong, nonatomic) NSArray *data;

@end

@implementation SmartStreetChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (SmartStreetChooseViewController *)create:(SmartStreetTextField *)textField {
    SmartStreetChooseViewController *controller = [[SmartStreetChooseViewController alloc] initWithNibName:@"SmartStreetChooseViewController" bundle:nil];
    controller.textField = textField;
    return controller;
}

- (void)displayLoading {
    [self.tableView setHidden:YES];
}

- (void)loadData:(NSArray *)data {
    self.data = data;
    [self.tableView reloadData];
}

- (void)choseAddress:(SmartyStreetsAddress *)address {
    [self.textField choseAddress:address];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.data) {
        [self.tableView setHidden:YES];
        return 0;
    }
    else {
        [self.tableView setHidden:NO];
        return [self.data count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SmartStreetChooseCell" owner:self options:nil];
    SmartStreetChooseViewCell *cell = (SmartStreetChooseViewCell *)[nib objectAtIndex:0];
    
    //Setting cell background color to clear to override controller settings for cell making white background on iPad:
    [cell setBackgroundColor:[UIColor clearColor]];
    
    SmartyStreetsAddress *address = [self.data objectAtIndex:indexPath.row];
    [cell loadData:self address:address];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

@interface SmartStreetChooseViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *streetButton;
- (IBAction)onClickStreetButton:(id)sender;

@end

@implementation SmartStreetChooseViewCell {
    SmartStreetChooseViewController *_controller;
    SmartyStreetsAddress *_address;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.streetButton.layer.cornerRadius = 4.0f;
}

- (void)loadData:(SmartStreetChooseViewController *)controll address:(SmartyStreetsAddress *)address {
    _controller = controll;
    _address = address;
    [self.streetButton setTitle:[NSString stringWithFormat:@"  %@",address.text] forState:UIControlStateNormal];
}

- (IBAction)onClickStreetButton:(id)sender {
    [_controller choseAddress:_address];
}

@end
