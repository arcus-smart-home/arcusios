//
//  ArcusHyperLabel.h
//  i2app
//
//  Created by Arcus Team on 01/19/17.
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

#import <UIKit/UIKit.h>

@interface ArcusHyperLabel : UILabel

@property (nonatomic, strong) UIColor *hyperLabelLinkColorDefault;
@property (nonatomic, strong) UIColor *hyperLabelLinkColorHighlighted;

- (void)setLinkForRange:(NSRange)range withAttributes:(NSDictionary *)attributes andLinkHandler:(void (^)(ArcusHyperLabel *label, NSRange selectedRange))handler;
- (void)setLinkForRange:(NSRange)range withLinkHandler:(void(^)(ArcusHyperLabel *label, NSRange selectedRange))handler;

- (void)setLinkForSubstring:(NSString *)substring withAttribute:(NSDictionary *)attribute andLinkHandler:(void(^)(ArcusHyperLabel *label, NSString *substring))handler;
- (void)setLinkForSubstring:(NSString *)substring withLinkHandler:(void(^)(ArcusHyperLabel *label, NSString *substring))handler;

- (void)setLinksForSubstrings:(NSArray *)substrings withLinkHandler:(void(^)(ArcusHyperLabel *label, NSString *substring))handler;

- (void)clearActionDictionary;

@end
