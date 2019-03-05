//
//  ArcusModalSelectionViewController.m
//  i2app
//
//  Created by Arcus Team on 1/26/16.
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
#import "ArcusModalSelectionViewController.h"
#import "ArcusSelectOptionTableViewCell.h"
#import "ArcusModalSelectionModel.h"
#import "DeviceCapability.h"


#import "AKFileManager.h"
#import "ImageDownloader.h"

@interface ArcusModalSelectionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UITableView *selectionTable;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, assign) NSInteger selectAllIndex;

@end

@implementation ArcusModalSelectionViewController

#pragma mark - View LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedItems = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureHeaderLabels];
    [self configureSelectAll];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configurePreselectedRows];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UI Configuration

- (void)configureHeaderLabels {
    NSString *title = self.titleLabel.text;
    if (title) {
        NSDictionary *titleAttributes = [FontData getFontWithSize:12.0f
                                                             bold:NO
                                                          kerning:2.0f
                                                            color:self.titleLabel.textColor];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                                              attributes:titleAttributes];
        [self.titleLabel setAttributedText:attributedTitle];
    }
    
    NSString *description = self.descriptionLabel.text;
    if (description) {
        NSDictionary *descriptionAttributes = [FontData getFontWithSize:13.0f
                                                                   bold:NO
                                                                kerning:0.0f
                                                                  color:self.descriptionLabel.textColor];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:description
                                                                              attributes:descriptionAttributes];
        [self.descriptionLabel setAttributedText:attributedTitle];
    }
    
}

- (void)configurePreselectedRows {
    for (NSInteger row = 0; row < [_selectionArray count]; row++) {
        ArcusModalSelectionModel *selectionModel = _selectionArray[row];
        if (selectionModel.isSelected) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:0];
            
            [self.selectionTable selectRowAtIndexPath:indexPath
                                             animated:YES
                                       scrollPosition:UITableViewScrollPositionNone];
            [self.selectedItems addObject:selectionModel];
        }
    }
}

- (void)configureSelectAll {
    self.selectAllIndex = -1;
    for (ArcusModalSelectionModel *selectionModel in self.selectionArray) {
        if (selectionModel.isSelectAll) {
            self.selectAllIndex = [self.selectionArray indexOfObject:selectionModel];
            break;
        }
    }
}

#pragma mark - Getters & Setters

- (void)setAllowMultipleSelection:(BOOL)allowMultipleSelection {
    _allowMultipleSelection = allowMultipleSelection;
    self.selectionTable.allowsMultipleSelection = _allowMultipleSelection;
}

- (void)allIndexesSelectedFromIndex:(NSIndexPath *)indexPath {
    for (NSInteger row = 0; row < [self.selectionTable numberOfRowsInSection:0]; row++) {
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:0];
        
        if (currentIndexPath != indexPath) {
            [self.selectionTable selectRowAtIndexPath:currentIndexPath
                                             animated:YES
                                       scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)allIndexesDeselectedFromIndex:(NSIndexPath *)indexPath {
    for (NSInteger row = 0; row < [self.selectionTable numberOfRowsInSection:0]; row++) {
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row
                                                           inSection:0];
        
        if (![currentIndexPath isEqual:indexPath]) {
            [self.selectionTable deselectRowAtIndexPath:currentIndexPath
                                               animated:YES];
        }
    }
}

- (void)setAllIndexesSelected {
    [self.selectedItems removeAllObjects];
    for (ArcusModalSelectionModel *selectionModel in self.selectionArray) {
        selectionModel.isSelected = YES;
    }
    self.selectedItems = [NSMutableArray arrayWithArray:self.selectionArray];
}

- (void)setAllIndexesDeselected {
    [self.selectedItems removeAllObjects];
    for (ArcusModalSelectionModel *selectionModel in self.selectionArray) {
        selectionModel.isSelected = NO;
    }
}

#pragma mark - IBActions

- (IBAction)closeButtonPressed:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(modalSelectionController:
                                                        didDismissWithSelectedModels:)]) {
            [self.delegate modalSelectionController:self
                       didDismissWithSelectedModels:self.selectedItems];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.selectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ArcusSelectionCell";
    
    ArcusSelectOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ArcusSelectOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ArcusModalSelectionModel *selectionModel = self.selectionArray[indexPath.row];
    NSDictionary *titleFontDictionary = [FontData getFontWithSize:14.0f
                                                             bold:YES
                                                          kerning:2.0f
                                                            color:[UIColor blackColor]];
    if (selectionModel.title) {
        NSAttributedString *titleAttributedString = nil;

        if([selectionModel.title isKindOfClass:[NSString class]]) {
            titleAttributedString = [[NSAttributedString alloc] initWithString:[selectionModel.title
                                                                                uppercaseString]
                                                                    attributes:titleFontDictionary];
        } else {
            titleAttributedString = [[NSAttributedString alloc] initWithString:[selectionModel.title.description
                                                                                uppercaseString]
                                                                    attributes:titleFontDictionary];
        }
        
        cell.titleLabel.attributedText = titleAttributedString;
    }
    
    if (selectionModel.itemDescription) {
        NSDictionary *descFontDictionary = [FontData getItalicFontWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.6f]
                                                                       size:14.0f
                                                                    kerning:0.0f];
        NSAttributedString *descAttributedString = [[NSAttributedString alloc] initWithString:selectionModel.itemDescription
                                                                                   attributes:descFontDictionary];
        
        cell.descriptionLabel.attributedText = descAttributedString;
    }
    
    if (selectionModel.image) {
        cell.detailImage.image = selectionModel.image;
    }
    
    if (selectionModel.deviceAddress) {
        DeviceModel *device = (DeviceModel *)[[[CorneaHolder shared] modelCache] fetchModel:selectionModel.deviceAddress];
        UIImage *deviceImage = [[AKFileManager defaultManager] cachedImageForHash:device.modelId
                                                                           atSize:[UIScreen mainScreen].bounds.size
                                                                        withScale:[UIScreen mainScreen].scale];
        if (!deviceImage) {
            [ImageDownloader downloadDeviceImage:[DeviceCapability getProductIdFromModel:device]
                                   withDevTypeId:[device devTypeHintToImageName]
                                 withPlaceHolder:nil
                                         isLarge:NO
                                    isBlackStyle:YES].then(^(UIImage *image) {
                cell.detailImage.image = image;
            });
        } else {
            cell.detailImage.image = deviceImage;
            cell.detailImage.layer.cornerRadius = cell.detailImage.bounds.size.width/2;
            cell.detailImage.clipsToBounds = YES;
        }
    }
    
    BOOL shouldRoundAllImages;
    if (self.configurationDelegate && [self.configurationDelegate respondsToSelector:@selector(shouldRoundAllImagesOnModalSelectionController:)]) {
        shouldRoundAllImages = [self.configurationDelegate shouldRoundAllImagesOnModalSelectionController:self];
    } else {
        shouldRoundAllImages = NO;
    }
    
    if (shouldRoundAllImages) {
        cell.detailImage.layer.cornerRadius = cell.detailImage.bounds.size.width/2;
        cell.detailImage.clipsToBounds = YES;
    }
        
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusModalSelectionModel *selectionModel = self.selectionArray[indexPath.row];
    if (selectionModel.isSelectAll && self.allowMultipleSelection) {
        [self setAllIndexesSelected];
        [self allIndexesSelectedFromIndex:indexPath];
    } else {
        selectionModel.isSelected = YES;
        if (self.allowMultipleSelection) {
            if (![self.selectedItems containsObject:selectionModel]) {
                [self.selectedItems addObject:selectionModel];
            }
            
            // If selectAll is enabled and user has manually selected all values mark selectAll selected.
            if (self.selectAllIndex >= 0 &&
                [self.selectedItems count] == [self.selectionArray count]) {
                [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectAllIndex
                                                                   inSection:0]
                                       animated:YES
                                 scrollPosition:UITableViewScrollPositionNone];

            }
        } else {
            self.selectedItems = [NSMutableArray arrayWithArray:@[selectionModel]];
            [self allIndexesDeselectedFromIndex:indexPath];
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(modalSelectionController:
                                                                didSelectModalSelectionModel:)]) {
                    [self.delegate modalSelectionController:self
                               didSelectModalSelectionModel:selectionModel];
                }
            }
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL shouldAllowNoSelection;
    if (self.configurationDelegate && [self.configurationDelegate respondsToSelector:@selector(shouldAllowNoSelectionOnModalSelectionController:)]) {
        shouldAllowNoSelection = [self.configurationDelegate shouldAllowNoSelectionOnModalSelectionController:self];
    } else {
        shouldAllowNoSelection = YES;
    }
    
    if ((shouldAllowNoSelection)
        || (self.selectAllIndex >= 0 && !shouldAllowNoSelection && self.selectedItems.count >= 3)
        || (self.selectAllIndex < 0 && !shouldAllowNoSelection && self.selectedItems.count >= 2)) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ArcusModalSelectionModel *selectionModel = self.selectionArray[indexPath.row];
    if (selectionModel.isSelectAll && self.allowMultipleSelection) {
        [self setAllIndexesDeselected];
        [self allIndexesDeselectedFromIndex:indexPath];
    } else {
        selectionModel.isSelected = NO;
        if (self.allowMultipleSelection) {
            if ([self.selectedItems containsObject:selectionModel]) {
                [self.selectedItems removeObject:selectionModel];
            }
        } else {
            self.selectedItems = nil;
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(modalSelectionController:
                                                                didDeselectModalSelectionModel:)]) {
                    [self.delegate modalSelectionController:self
                             didDeselectModalSelectionModel:selectionModel];
                }
            }
        }
        
        if (self.selectAllIndex >= 0) {
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectAllIndex
                                                                 inSection:0]
                                     animated:YES];
        }
    }
}

@end
