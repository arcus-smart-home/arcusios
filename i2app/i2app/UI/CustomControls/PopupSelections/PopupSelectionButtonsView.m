//
//  PopupSelectionButtonsView.m
//  i2app
//
//  Created by Arcus Team on 7/24/15.
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
#import "PopupSelectionButtonsView.h"
#import <PureLayout/PureLayout.h>

@interface PopupSelectionButtonsView ()

@property (strong, nonatomic) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainer;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonAreaConstraint;

@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSString *subtitleString;

@property (nonatomic) PopupWindowStyle style;

@end

@implementation PopupSelectionButtonsView

- (CGFloat)getHeight {
    if (_subtitleString && _subtitleString.length > 0) {
        
        NSString *realText = NSLocalizedString(_subtitleString, nil);
        
        CGRect possibleSize =[realText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 150,9999)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Medium" size:14]}
                                                    context:nil];
        CGSize size = possibleSize.size;

        return size.height + (_buttons.count * 65) + 50;
    }
    else {
        return (_buttons.count * 55) + 90;
    }
}

- (void)setStyle:(PopupWindowStyle)style {
    _style = style;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_buttons || [_buttons count] > 0) {
        UIButton *_lastBtn = nil;
        NSInteger index = 0;
        for (PopupSelectionButtonModel *btnModel in _buttons) {
            UIButton *btn = [[UIButton alloc] initForAutoLayout];
            [_buttonsContainer addSubview:btn];

            if (btnModel.backgroundColor != nil) {
                btn.backgroundColor = btnModel.backgroundColor;
            }
            
            if (btnModel.unfilledStyle) {
                [btn styleSet:[NSString stringWithFormat:@" %@ ", btnModel.title] andFontData:[FontData createFontData:FontTypeDemiBold size:12 blackColor:(_style != PopupWindowStyleCautionWindow) space:YES]];
                btn.layer.cornerRadius = 4.0f;
                btn.layer.borderColor = [UIColor blackColor].CGColor;
                btn.layer.borderWidth = 1.0f;
                [btn autoSetDimension:ALDimensionHeight toSize:21];
                [btn autoAlignAxisToSuperviewAxis:ALAxisVertical];
                if (_style == PopupWindowStyleCautionWindow) {
                    btn.layer.borderColor = [UIColor whiteColor].CGColor;
                }
            }
            else {
                if (_style == PopupWindowStyleCautionWindow) {
                    btn.layer.borderColor = [UIColor whiteColor].CGColor;
                    [btn styleSet:btnModel.title andButtonType:FontDataTypeButtonLight upperCase:YES];
                }
                else {
                    [btn styleSet:btnModel.title andButtonType:FontDataTypeButtonDark upperCase:YES];
                }
                [btn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_buttonsContainer withOffset:14];
                [btn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_buttonsContainer withOffset:-14];
                [btn autoSetDimension:ALDimensionHeight toSize:44];
            }

            // Note: This was hastily put in and overrides the above button colors based on a model set color.
            if (btnModel.backgroundColor != nil) {
                btn.backgroundColor = btnModel.backgroundColor;
            }

            if (_lastBtn) {
                [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lastBtn withOffset:14];
            }
            else {
                [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_buttonsContainer];
            }
            
            btn.tag = index;
            index++;
            
            [btn addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
            
            _lastBtn = btn;
        }
    }
    
    if (_titleString && _titleString.length > 0) {
        [_titleLabel styleSetWithSpace:_titleString andFontSize:14 bold:YES upperCase:YES];
        [_titleLabel sizeToFit];
    }
    else {
        [_titleLabel setText:@""];
    }
    
    if (_subtitleString && _subtitleString.length > 0) {
        [_secondLabel styleSet:_subtitleString andFontSize:13 bold:NO alpha:YES upperCase:NO];
    }
    else {
        [_secondLabel setText:@""];
        _buttonAreaConstraint.constant = 10.0f;
    }
    
    if (_style == PopupWindowStyleCautionWindow) {
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_secondLabel setTextColor:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
    }
    [_secondLabel sizeToFit];

    [self.view layoutIfNeeded];
    [self.view.superview layoutIfNeeded];
}

- (void)pressedButton:(UIButton *)button {
    if ([_buttons count] > button.tag) {
        PopupSelectionButtonModel *btnModel = _buttons[button.tag];
        
        if (btnModel != nil) {
            NSString *obj = ((NSString *) btnModel.obj).copy;
            
            if (_owner && btnModel.pressedSelector && [_owner respondsToSelector:btnModel.pressedSelector]) {
                [_owner performSelector:btnModel.pressedSelector withObject:obj afterDelay:0];
            }
        }
        [self.window close];

    }
}

- (void)networkTypeSelected:(id)sender {
    if (sender) {
        
    }
}

+ (PopupSelectionButtonsView *)createWithTitle:(NSString *)title subtitle:(NSString *)subtitle buttons:(NSArray<PopupSelectionButtonModel *>*)buttons {
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    buttonsView.titleString = title;
    buttonsView.subtitleString = subtitle;
    buttonsView.buttons = buttons;
    
    return buttonsView;
}

+ (PopupSelectionButtonsView *)createWithTitle:(NSString *)title buttons:(NSArray<PopupSelectionButtonModel *>*)buttons {
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    buttonsView.titleString = title;
    buttonsView.buttons = buttons;
    
    return buttonsView;
}

+ (PopupSelectionButtonsView *)create:(NSArray<PopupSelectionButtonModel *>*)buttons {
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    buttonsView.buttons = buttons;
    
    return buttonsView;
}

+ (PopupSelectionButtonsView *)createWithTitle:(NSString *)title subtitle:(NSString *)subtitle button:(PopupSelectionButtonModel *)button, ... {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    va_list args;
    va_start(args, button);
    for (PopupSelectionButtonModel *arg = button; arg != nil; arg = va_arg(args, PopupSelectionButtonModel *)) {
        if (arg && [arg isKindOfClass:[PopupSelectionButtonModel class]]) {
            [array addObject:arg];
        }
    }
    va_end(args);
    
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    buttonsView.titleString = title;
    buttonsView.subtitleString = subtitle;
    buttonsView.buttons = array;
    
    return buttonsView;
}

+ (PopupSelectionButtonsView *)createWithTitle:(NSString *)title button:(PopupSelectionButtonModel *)button, ... {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    va_list args;
    va_start(args, button);
    for (PopupSelectionButtonModel *arg = button; arg != nil; arg = va_arg(args, PopupSelectionButtonModel *)) {
        [array addObject:arg];
    }
    va_end(args);
    
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    buttonsView.titleString = title;
    buttonsView.buttons = array;
    
    return buttonsView;
}

+ (PopupSelectionButtonsView *)createWithButton:(PopupSelectionButtonModel *)button, ... {
    PopupSelectionButtonsView *buttonsView = [[PopupSelectionButtonsView alloc] initWithNibName:@"PopupSelectionButtonsView" bundle:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    va_list args;
    va_start(args, button);
    for (PopupSelectionButtonModel *arg = button; arg != nil; arg = va_arg(args, PopupSelectionButtonModel *)) {
        [array addObject:arg];
    }
    va_end(args);
    
    buttonsView.buttons = array;
    return buttonsView;
}

- (id)getSelectedValue {
    return nil;
}

@end
