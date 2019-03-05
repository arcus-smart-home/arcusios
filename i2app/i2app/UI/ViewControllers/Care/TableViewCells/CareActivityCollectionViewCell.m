//
//  CareActivityCollectionViewCell.m
//  i2app
//
//  Created by Arcus Team on 1/22/16.
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
#import "CareActivityCollectionViewCell.h"

@implementation CareActivityCollectionViewCell

- (void)configureActivityGraphView:(NSArray <ActivityGraphViewUnitProtocol> *)activityUnits {    
    self.graphView.activityUnits = activityUnits;
    
    [self.graphView setNeedsDisplay];
    [self setNeedsDisplay];
}

- (NSAttributedString *)attributeTimeString:(NSString *)timeString {
    NSMutableAttributedString *mutableResult = nil;
    NSAttributedString *result = nil;

    if (timeString) {
        NSString *mainText = nil;
        NSString *superScriptText = nil;
        
        NSArray *timeArray = [timeString componentsSeparatedByString:@" "];
        
        if ([timeArray count] >= 2) {
            NSArray *hourMinArray = [timeArray[0] componentsSeparatedByString:@":"];
            mainText = [timeString componentsSeparatedByString:@":"][0];
            superScriptText = timeArray[1];
            
            if ([hourMinArray count] >= 2) {
                if (![hourMinArray[1] isEqualToString:@"00"]) {
                    superScriptText = hourMinArray[1];
                }
            }
            
            NSString *fullText = [NSString stringWithFormat:@"%@%@", mainText, superScriptText];
            
            NSDictionary *timeFontDictionary = [FontData getFontWithSize:14.0f
                                                                    bold:YES
                                                                 kerning:0.0f
                                                                   color:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]];
            NSRange superScriptRange = [fullText rangeOfString:superScriptText];
            
            NSMutableDictionary *mutableFontDictionary = [NSMutableDictionary dictionaryWithDictionary:[FontData getFontWithSize:8.0f
                                                                                                                            bold:NO
                                                                                                                         kerning:0.0f
                                                                                                                           color:[[UIColor whiteColor] colorWithAlphaComponent:0.8f]]];
            [mutableFontDictionary setObject:@(3) forKey:NSBaselineOffsetAttributeName];
            
            mutableResult = [[NSMutableAttributedString alloc] initWithString:fullText
                                                                   attributes:timeFontDictionary];
            [mutableResult setAttributes:mutableFontDictionary range:superScriptRange];
        }

    }
    
    if (mutableResult) {
        result = [[NSAttributedString alloc] initWithAttributedString:mutableResult];
    }
    
    return result;
}

@end
