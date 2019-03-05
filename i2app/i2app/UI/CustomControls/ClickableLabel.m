//
//  ClickableLabel.m
//  i2app
//
//  Created by Arcus Team on 6/25/15.
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
#import "ClickableLabel.h"
#import <CoreText/CoreText.h>

@implementation ClickableLabel {
    FontDataType _sentenceType;
    FontDataType _changableType;
    
    CTFramesetterRef _framesetter;
    
    NSString *_templateSentence;
    NSMutableArray *_changableParams;
    NSMutableArray *_changableParamsRanges;
    
    FontDataType    _footerType;
    NSString        *_footerSentence;
}

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height) / 2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width) / 2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}
static inline NSAttributedString * NSAttributedStringBySettingColorFromContext(NSAttributedString *attributedString, UIColor *color) {
    if (!color) {
        return attributedString;
    }
    
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    [mutableAttributedString enumerateAttribute:(NSString *)kCTForegroundColorFromContextAttributeName inRange:NSMakeRange(0, [mutableAttributedString length]) options:0 usingBlock:^(id value, NSRange range, __unused BOOL *stop) {
        BOOL usesColorFromContext = (BOOL)value;
        if (usesColorFromContext) {
            [mutableAttributedString setAttributes:[NSDictionary dictionaryWithObject:color forKey:(NSString *)kCTForegroundColorAttributeName] range:range];
            [mutableAttributedString removeAttribute:(NSString *)kCTForegroundColorFromContextAttributeName range:range];
        }
    }];
    
    return mutableAttributedString;
}

- (CTFramesetterRef)framesetter {
    @synchronized(self) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)NSAttributedStringBySettingColorFromContext(self.attributedText, self.textColor));
        if (framesetter) CFRetain(framesetter);
        if (_framesetter) {
            CFRelease(_framesetter);
        }
        
        _framesetter=framesetter;
    }
    
    return _framesetter;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    if (!CGRectContainsPoint(self.bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect =  [self textRect];
        //[self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame([self framesetter], CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter
        CGFloat flushFactor = 0.0f;
        if (self.textAlignment == NSTextAlignmentCenter) {
            flushFactor = 0.5f;
        }
        else if (self.textAlignment == NSTextAlignmentRight) {
            flushFactor = 1.0f;
        }
        
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}


- (NSRange)containingWordRange:(CFIndex)index {
    NSString *string = self.text;
    
    NSRange end = [string rangeOfString:@" " options:0 range:NSMakeRange(index, string.length - index)];
    NSRange front = [string rangeOfString:@" " options:NSBackwardsSearch range:NSMakeRange(0, index)];
    
    if (front.location == NSNotFound) {
        front.location = 0;
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length-1;
    }
    
    return NSMakeRange(front.location, end.location-front.location);
}

- (NSString *)containingWord:(CFIndex)index {
    NSRange rang = [self containingWordRange:index];
    return [self.text substringWithRange:rang];
}

- (void)substituteParam:(NSInteger)orderID to:(NSString *)value {
    [_changableParams replaceObjectAtIndex:orderID withObject:value];
    [self display];
}

- (void)display {
    [_changableParamsRanges removeAllObjects];
    
    NSString *content = [_templateSentence copy];
    for (int i = 0; i < _changableParams.count; i++) {
        NSRange range = [content rangeOfString:@"%@"];
        content = [content stringByReplacingCharactersInRange:range  withString:_changableParams[i]];
        
        range.length = ((NSString *)_changableParams[i]).length;
        [_changableParamsRanges addObject:[NSValue valueWithRange:range]];
    }
    
    NSRange footerRange;
    if (_footerSentence) {
        footerRange = NSMakeRange(content.length,_footerSentence.length);
        content = [content stringByAppendingString:_footerSentence];
    }
    else {
        footerRange = NSMakeRange(0, 0);
    }
    
    // Set attributed string
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
    [string addAttributes:[FontData getFont:_sentenceType] range:NSMakeRange(0, content.length)];
    for (NSValue *item in _changableParamsRanges) {
        [string addAttributes:[FontData getFont:_changableType] range:[item rangeValue]];
    }
    
    if (_footerSentence) {
        [string addAttributes:[FontData getFont:_footerType] range:footerRange];
    }
    
    [self setAttributedText:string];
}

- (void)setTemplateSentence:(NSString *)sentence changeableParams:(NSArray *)params withstype:(FontDataType)type andChangeableType:(FontDataType)changeabletype {
    
    _sentenceType = type;
    _changableType = changeabletype;
    
    _templateSentence = sentence;
    _changableParams = [[NSMutableArray alloc] initWithArray: params];
    _changableParamsRanges = [[NSMutableArray alloc] initWithCapacity:params.count];
    
    [self display];
}

- (void)setFooterSentence: (NSString *)sentence style:(FontDataType)type {
    _footerSentence = sentence;
    _footerType = type;
    
    [self display];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (index == NSNotFound) return;
    DDLogWarn(@"%@", [self containingWord:index]);
    
    if (self.touchEvent) {
        NSRange range;
        NSInteger orderID = -1;
        for (int i = 0; i < _changableParamsRanges.count; i++) {
            range = [_changableParamsRanges[i] rangeValue];
            if (range.location <= index && (range.location + range.length) >= index) {
                orderID = i;
                break;
            }
        }
        
        self.touchEvent(orderID);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    if (index == NSNotFound) return;
    DDLogWarn(@"Cancelled touch: %@", [self containingWord:index]);
}


@end
