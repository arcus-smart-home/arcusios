//
//  SmartPetTokenPairingViewController.m
//  i2app
//
//  Created by Arcus Team on 1/19/16.
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
#import "SmartPetTokenPairingViewController.h"
#import "PairingStep.h"
#import "DevicePairingManager.h"
#import "DevicePairingWizard.h"
#import "PopupSelectionWindow.h"
#import "PopupSelectionSearching.h"
#import "DoorsNLocksSubsystemController.h"
#import "PetTokenCapability.h"
#import <i2app-Swift.h>


@interface BasePairingViewController ()

- (void)setDeviceStep:(PairingStep *)step;

@end

@interface SmartPetTokenPairingViewController()

@property (nonatomic, strong) NSString *petTokenName;

@end

@implementation SmartPetTokenPairingViewController {
    PopupSelectionWindow    *_popup;
}

+ (SmartPetTokenPairingViewController *)createWithDeviceModel:(DeviceModel *)deviceModel {
    SmartPetTokenPairingViewController *vc = [[UIStoryboard storyboardWithName:@"DeviceDetails" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    vc.deviceModel = deviceModel;

    return vc;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.title = NSLocalizedString(@"Pet Door", nil);
}

- (void)viewDidLoad{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(petTokenAdded:) name:self.deviceModel.modelChangedNotification object:nil];
}

- (void)initializeTemplateViewController {
    if (!self.step) {
        [self setDeviceStep:[PairingStep new]];
        self.step.stepIndex = 1;
        self.step.imageUrl = @"petdoor_pair2";
        self.step.mainStep = NSLocalizedString(@"Pair Smart Key", nil);
        self.step.secondStep = NSLocalizedString(@"Pair Smart Key second", nil);
    }

    [super initializeTemplateViewController];

    [self waitingForPetdoor];
}

- (void)waitingForPetdoor {
    PopupSelectionSearching *searching = [PopupSelectionSearching create:@"Waiting for pet door" subtitle:@"It may take a few minutes for the pet door to find, program, and report the SmartKey back to Arcus."];
    _popup = [PopupSelectionWindow popup:self.view subview:searching];
}



- (void)petTokenAdded:(NSNotification *)note {
    if ([note.object isKindOfClass:[NSDictionary class]]) {
        NSNumber *tokenIdNumber = ((NSDictionary *)note.object)[kPetTokenId];
        if (tokenIdNumber && ![tokenIdNumber isEqual:[NSNull null]]) {
            _addedTokenId = tokenIdNumber.intValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_popup close];
                [[DevicePairingManager sharedInstance].pairingWizard createNextStepObject:YES];
            });
        }
    }
}
@end
