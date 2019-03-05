//
//  DeviceNotificationLabel.m
//  i2app
//
//  Created by Arcus Team on 7/6/15.
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
#import "DeviceNotificationLabel.h"
#import <PureLayout/PureLayout.h>

@implementation DeviceNotificationLabelModel

@end



@interface DeviceNotificationLabel()

@property (copy) deviceNotificationCloseBlock closeEvent;

@end

@implementation DeviceNotificationLabel {
    NSString *_titleString;
    NSString *_contentString;
    
    UIImageView *_leftIcon;
    UIImageView *_rightIcon;
    UIButton *_closeBtn;
}

- (DeviceNotificationLabelModel *) getLabelModel {
    DeviceNotificationLabelModel *model = [[DeviceNotificationLabelModel alloc] init];
    model.titleString = _titleString;
    model.contentString = _contentString;
    model.leftIcon = _leftIcon.image;
    model.rightIcon = _rightIcon.image;
    model.hasCloseButton = !_closeBtn.isHidden;
    if (model.hasCloseButton) {
        model.closeEvent = self.closeEvent;
    }
    return model;
}

- (void) setLabelModel: (DeviceNotificationLabelModel *)model {

    if (model.hasCloseButton) {
        if (model.titleString) {
            [self setTitle:model.titleString];
        }
        if (model.contentString) {
            [self setContent:model.contentString];
        }
        [self enableClose:model.closeEvent];
    }
    else if (model.leftIcon) {
        [self setTitle:model.titleString withLeftIcon:model.leftIcon];
    }
    else if (model.rightIcon) {
        [self setTitle:model.titleString withLeftIcon:model.rightIcon];
    }
}

- (void) setTitle:(NSString *)title andContent:(NSString *)content {
    [self setTitle:title];
    [self setContent:content];
}

- (void) setTitle:(NSString *)title {
    _titleString = [title stringByAppendingString:@" "];
    if (!_contentString) _contentString = @"";
    
    [self setAttributedText:[FontData getString:[_titleString uppercaseString] andString2:[_contentString uppercaseString] withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
    
    [self hideIcons];
}

- (void) setContent:(NSString *)content {
    _contentString = content;
    if (!_titleString) _titleString = @"";
    
    [self setAttributedText:[FontData getString:[_titleString uppercaseString] andString2:[_contentString uppercaseString] withFont:FontDataTypeDeviceEventTitle andFont2:FontDataTypeDeviceEventTime]];
    
    [self hideIcons];
}

- (void) setTitle:(NSString *)title andTime:(NSDate *)date {
    [self setTitle:title];

    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval:60 * 60 * 24 * -1];
    NSDate *dateBefore = [date dateByAddingTimeInterval:60 * 60 * 24 * -1];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY:MM:dd"];
    NSString *localDateString = [dateFormatter stringFromDate:today];
    NSString *givenDateString = [dateFormatter stringFromDate:date];
    
    NSString *yesterdayString = [dateFormatter stringFromDate:yesterday];
    NSString *datebeforeString = [dateFormatter stringFromDate:dateBefore];
    
    if ([localDateString isEqualToString:givenDateString]) {
        [dateFormatter setDateFormat:@"h:mm a"];
        [self setContent:[dateFormatter stringFromDate:date]];
    }
    else if ([yesterdayString isEqualToString:datebeforeString]) {
        [dateFormatter setDateFormat:@"h:mm a"];
        [self setContent:[NSString stringWithFormat:@"Yesterday %@", [dateFormatter stringFromDate:date]]];
    }
    else {
        [dateFormatter setDateFormat:@"MMM dd, YYYY"];
        [self setContent:[dateFormatter stringFromDate:date]];
    }
    [self hideIcons];
}

- (void) setTitle:(NSString *)title andDurationInMinute:(int)duration {
    [self setTitle:title];
    int minutes = abs(duration) % 60;
    int hours = (duration - minutes) / 60;
    [self setContent:[NSString stringWithFormat:@"%ld:%.2ldM", (long)hours, (long) minutes]];
    [self hideIcons];
}

- (void)hideIcons {
    
    if (_leftIcon) {
        [_leftIcon setHidden:YES];
    }
    if (_rightIcon) {
        [_rightIcon setHidden:YES];
    }

}

- (void) setTitle:(NSString *)title withLeftIcon:(UIImage *)icon {
    _titleString = title;
    [self setAttributedText:[FontData getString:[NSString stringWithFormat:@"    %@",title] withFont:FontDataTypeDeviceEventTime]];
    
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        [self.superview addSubview:_leftIcon];
        [_leftIcon autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self withOffset:12];
        [_leftIcon autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self];
    }
    [_leftIcon setImage:icon];
}

- (void) setTitle:(NSString *)title withRightIcon:(UIImage *)icon {
    _titleString = title;
    [self setAttributedText:[FontData getString:[NSString stringWithFormat:@"%@    ",title] withFont:FontDataTypeDeviceEventTime]];
    
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        [self.superview addSubview:_rightIcon];
        [_rightIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self withOffset:12];
        [_rightIcon autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self];
    }
    //TODO: Hidden the event bar for this sprint
    [_rightIcon setHidden:YES];
    [_rightIcon setImage:icon];
}

- (void) enableClose:(deviceNotificationCloseBlock)block {
    if (_leftIcon) [_leftIcon setHidden:YES];
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    self.closeEvent = block;
    [_closeBtn setHidden:NO];
    
    [_closeBtn setImage:[UIImage imageNamed:@"alertClose"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(onClickClose) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:_closeBtn];
    [_closeBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self withOffset:-10];
    [_closeBtn autoConstrainAttribute:ALAttributeHorizontal toAttribute:ALAttributeHorizontal ofView:self];
}

- (void) hideClose {
    if (_rightIcon && !_rightIcon.hidden) {
        [self setAttributedText:[FontData getString:[NSString stringWithFormat:@"%@    ",_titleString] withFont:FontDataTypeDeviceEventTime]];
    }
    [_closeBtn setHidden:YES];
}

- (void) onClickClose {
    [self hideClose];
    
    if (self.closeEvent)
        self.closeEvent(self);
}


@end
