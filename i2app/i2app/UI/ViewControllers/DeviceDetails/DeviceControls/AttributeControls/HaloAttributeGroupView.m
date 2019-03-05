//
//  HaloAttributeGroupView.m
//  i2app
//
//  Created by Arcus Team on 8/26/16.
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
#import "HaloAttributeGroupView.h"
#import "DeviceAttributeItemBaseControl.h"
#import <PureLayout/PureLayout.h>

@implementation HaloAttributeGroupView

- (void) awakeFromNib {
    [super awakeFromNib];

    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            [label setText:@""];
        }
    }

    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setHumidityLevel:(double)humidity {
    [self.humidityLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)roundf(humidity)] andString2:@" %" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
}

- (void)setTemperatureLevel:(double)temperature {
    [self.temperatureLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%d", (int)roundf(temperature)] andString2:@" \u00B0" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
}

- (void)setPressureLevel:(double)pressure {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    if (pressure != 0) {
        [fmt setPositiveFormat:@"0.#"];

        [self.pressureLabel setAttributedText:[FontData getString:[NSString stringWithFormat:@"%@", [fmt stringFromNumber:[NSNumber numberWithDouble:pressure]]] andString2:@" IN" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
    else {
        [self.pressureLabel setAttributedText:[FontData getString:@"0.0" andString2:@" IN" withCombineFont:FontDataCombineTypeDeviceStatusSymbolCombine]];
    }
}

@end
