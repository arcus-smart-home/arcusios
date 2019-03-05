//
//  ArcusBaseTimeZoneViewController.m
//  i2app
//
//  Created by Arcus Team on 5/10/16.
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
#import "ArcusBaseTimeZoneViewController.h"
#import "ArcusBaseTimeZoneViewController+Private.h"
#import "PopupSelectionTextPickerView.h"
#import "PlaceCapability.h"


@implementation ArcusBaseTimeZoneViewController {
    PopupSelectionWindow    *_popupWindow;
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navBarWithBackButtonAndTitle:[NSLocalizedString(@"Time Zone", nil) uppercaseString]];
    
    self.titleLabel.text = NSLocalizedString(self.titleLabel.text, nil);
    self.subtitleLabel.text = NSLocalizedString(self.subtitleLabel.text, nil);
    self.timeZoneLabel.text = NSLocalizedString(self.timeZoneLabel.text, nil);
    
    NSString *timeZone = [self defaultTimeZoneValue];
    self.timeZoneValueLabel.text = timeZone;
    if (timeZone.length == 0) {
        self.nextButton.enabled = NO;
    }
}

#pragma mark - IBActions
- (IBAction)onClickTimeZone:(id)sender {
    [self createGif];
    
    if (_popupWindow && _popupWindow.displaying) {
        [_popupWindow close];
    }
    
    if (self.timeZones.count == 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            [AccountController getPlaceTimezones].then(^(NSArray *timezones) {
                self.timeZones = [[OrderedDictionary alloc] initWithCapacity:timezones.count];
                
                for (NSDictionary *timezone in timezones) {
                    [self.timeZones setObject:timezone forKey:timezone[@"name"]];
                }
                [self.timeZones sortArray];
                PopupSelectionTextPickerView *pickerView = [PopupSelectionTextPickerView create:NSLocalizedString(@"Select a time zone", nil) list:self.timeZones];
                [self hideGif];
                _popupWindow = [PopupSelectionWindow popup:self.view subview:pickerView owner:self closeSelector:@selector(choseTimezone:)];
                [pickerView setCurrentKeyFuzzily:self.timeZoneValueLabel.text];
            });
        });
    }
    else {
        [self.timeZones sortArray];
        PopupSelectionTextPickerView *pickerView = [PopupSelectionTextPickerView create:NSLocalizedString(@"Select a time zone", nil) list:self.timeZones];
        [self hideGif];
        _popupWindow = [PopupSelectionWindow popup:self.view subview:pickerView owner:self closeSelector:@selector(choseTimezone:)];
        [pickerView setCurrentKeyFuzzily:self.timeZoneValueLabel.text];
    }
}

#pragma mark - ArcusBaseTimeZoneViewController methods to be overriden in subclasses
- (NSString *)defaultTimeZoneValue {
    DDLogError(@"Implement defaultTimeZoneValue in subclass of ArcusBaseTimeZoneViewController");
    return nil;
}

- (IBAction)nextButtonPressed:(id)sender {
    DDLogError(@"Implement nextButtonPressed: in the subclass of ArcusBaseTimeZoneViewController.h");
}

- (void)userChoseTimezoneWithName:(NSString *)timeZone timeZoneID:(NSString *)tzID offset:(NSNumber *)offset usesDST:(BOOL)usesDST {
    DDLogError(@"Implement userChoseTimezoneWithName:timeZoneID:offset:usesDST: in subclass");
}

#pragma mark - Picker dismissed selector
- (void)choseTimezone:(NSDictionary *)timezone {
    self.timeZoneValueLabel.text = timezone[@"name"];
    self.nextButton.enabled = YES;
    [self userChoseTimezoneWithName:timezone[@"name"] timeZoneID:timezone[@"id"] offset:timezone[@"offset"] usesDST:[timezone[@"usesDST"] boolValue]];
}

@end
