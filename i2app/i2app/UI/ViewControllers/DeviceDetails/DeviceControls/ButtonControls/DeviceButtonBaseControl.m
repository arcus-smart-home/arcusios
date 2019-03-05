//
//  DeviceButtonBaseControl.m
//  i2app
//
//  Created by Arcus Team on 7/20/15.
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
#import "DeviceButtonBaseControl.h"
#import <PureLayout/PureLayout.h>

@interface DeviceButtonBaseControl()

@property (assign, nonatomic) SEL buttonSelector;
@property (weak, nonatomic) NSObject *owner;
@property (nonatomic, assign) BOOL shiftButton;

@end

@implementation DeviceButtonBaseControl {
    BOOL _isDisabled;
}

@dynamic disable;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.button = [[TransparentTextButton alloc] initForAutoLayout];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.button = [[TransparentTextButton alloc] initForAutoLayout];
    }
    return self;
}

- (void)initializeDisplay {
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.button];

    if (self.shiftButton) {
        [self autoSetDimensionsToSize:CGSizeMake(64, 35)];

        [self.button autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    } else {
        [self autoSetDimensionsToSize:CGSizeMake(64, 64)];

        [self.button autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }

    _isDisabled = NO;
    
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPressed:(id)sender {
    if (_isDisabled) {
        return;
    }
    
    if (self.buttonSelector && self.owner && [self.owner respondsToSelector:self.buttonSelector]) {
        [_owner performSelector:self.buttonSelector withObject:sender afterDelay:0];
    }
    else {
        DDLogWarn(@" ##### ERROR: Button's event is undefine. #####");
    }
}

- (void)setButtonImage:(UIImage *)image {
    [self.button setImage:image forState:UIControlStateNormal];
}

- (void)setLabel:(NSAttributedString *)string {
    [self.button setAttributedTitle:string forState:UIControlStateNormal];
}

- (void)setLabelText:(NSString *)string {
    [self.button setTitleLabelText:string withFontSize:10.f];
}

- (void)setDisable: (BOOL)disable {
    _isDisabled = disable;
    if (disable) {
        [self.button setAlpha:0.4f];
        self.button.userInteractionEnabled = NO;
    }
    else {
        [self.button setAlpha:1.0f];
        self.button.userInteractionEnabled = YES;
    }
}

- (BOOL)getDisable {
    return _isDisabled;
}

#pragma mark - create button
+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name owner:(NSObject *)controller {
    
    DeviceButtonBaseControl *control = [[DeviceButtonBaseControl alloc] initForAutoLayout];
    [control setButtonImage:buttonImage];
    [control setLabelText:name];
    [control setOwner:controller];
    
    return control;
}

+ (DeviceButtonBaseControl *)createDefaultButton:(NSString *)name withSelector:(SEL)selector owner:(NSObject *)controller {
    
    DeviceButtonBaseControl *control = [[DeviceButtonBaseControl alloc] initForAutoLayout];
    [control setButtonImage:[UIImage imageNamed:@"white_button_no_text_large"]];
    [control setLabelText:name];
    [control setButtonSelector:selector];
    [control setOwner:controller];
    
    return control;
}

+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject *)controller {
    
    DeviceButtonBaseControl *control = [[DeviceButtonBaseControl alloc] initForAutoLayout];
    [control setButtonImage:buttonImage];
    [control setLabelText:name];
    [control setButtonSelector:selector];
    [control setOwner:controller];
    
    return control;
}

+ (DeviceButtonBaseControl *)create:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject *)controller shiftButton:(BOOL)shiftButton {

    DeviceButtonBaseControl *control = [[DeviceButtonBaseControl alloc] initForAutoLayout];
    [control setButtonImage:buttonImage];
    [control setLabelText:name];
    [control setButtonSelector:selector];
    [control setOwner:controller];
    [control setShiftButton:shiftButton];

    return control;
}

- (void)setDefaultStyle:(NSString *)name withSelector:(SEL)selector owner:(NSObject *)controller {
    [self initializeDisplay];
    [self setButtonImage:[UIImage imageNamed:@"white_button_no_text_large"]];
    [self setLabelText:name];
    [self setButtonSelector:selector];
    [self setOwner:controller];
}

- (void)setDefaultTransparenceStyle:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller {
    [self initializeDisplay];
    [self setButtonImage:[UIImage imageNamed:@"white_button_no_text_large"]];
    [self setLabelText:name];
    [self setButtonSelector:selector];
    [self setOwner:controller];
}

- (void)setImageStyle:(UIImage *)buttonImage withSelector:(SEL)selector owner:(NSObject*)controller {
    [self initializeDisplay];
    [self setButtonImage:buttonImage];
    [self setLabelText:@""];
    [self setButtonSelector:selector];
    [self setOwner:controller];
}

- (void)setImageStyle:(UIImage *)buttonImage name:(NSString *)name withSelector:(SEL)selector owner:(NSObject*)controller {
    [self initializeDisplay];
    [self setButtonImage:buttonImage];
    [self setLabelText:name];
    [self setButtonSelector:selector];
    [self setOwner:controller];
}



@end
