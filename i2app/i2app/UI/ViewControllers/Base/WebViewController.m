//
//  WebViewController.m
//  i2app
//
//  Created by Arcus Team on 4/15/15.
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
#import "WebViewController.h"
#import "ALView+PureLayout.h"

@interface WebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;

    self.view.backgroundColor = [UIColor clearColor];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
    
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self navBarWithBackButtonAndTitleImage];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  
  NSString *baseURLAllowed = @"";
  if ([request.URL.absoluteString containsString:baseURLAllowed]) {
    return YES;
  }
  
  return NO;
}

@end
