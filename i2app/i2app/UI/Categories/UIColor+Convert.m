//
//  UIColor+Convert.m
//  i2app
//
//  Created by Arcus Team on 6/4/15.
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
#import "UIColor+Convert.h"
#import "UIImage+ImageEffects.h"

@implementation UIColor(Convert)

+ (UIColor *)UIColorFromRGB:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b {
    return [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:1.0f];
}

+ (UIColor *) UICoLorFromHex:(NSString *)str {
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    }
    
    NSArray *colors = [self spliteColor: str];
    
    NSNumber *red = [colors objectAtIndex:0];
    NSNumber *green = [colors objectAtIndex:1];
    NSNumber *blue = [colors objectAtIndex:2];
    
    UIColor *color = [UIColor colorWithRed:[red floatValue] / 255.0
                                     green:[green floatValue] /255.0
                                      blue:[blue floatValue] /255.0
                                     alpha:1];
    
    return color;
}

+ (NSNumber *) toNumber:(NSString *)hex {
    hex = [hex uppercaseString];
    
    int val = 0;
    int res = 0;
    
    for (int i = 0; i < 2; i++) {
        char c = [hex characterAtIndex:i];
        
        switch (c) {
            case 'A':
                val = 10;
                break;
            case 'B':
                val = 11;
                break;
            case 'C':
                val = 12;
                break;
            case 'D':
                val = 13;
                break;
            case 'E':
                val = 14;
                break;
            case 'F':
                val = 15;
                break;
            default:
                val = [[NSNumber numberWithChar:c] intValue] - 48;
                if (val < 0 || val > 9) {
                    val = 0;
                }
                
                break;
        }
        
        res += val * pow(16, 1 - i);
    }
    
    return [NSNumber numberWithInt:res - 1];
}

+ (NSArray *)spliteColor:(NSString *)colorString {
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    for (int i = 0; i < 3; i++) {
        NSRange range = NSMakeRange(i * 2, 2);
        [colors addObject: [self toNumber:[colorString substringWithRange:range]]];
    }
    
    return colors;
}

+ (UIImage *)UIImageWithColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    label.backgroundColor = color;
    
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
