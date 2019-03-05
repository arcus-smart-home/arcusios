//
//  HoneywellC2CViewController.m
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
#import "HoneywellC2CViewController.h"
#import "HoneywellC2CStatusViewController.h"
#import "DevicePairingManager.h"

#import "DevicePairingManager.h"
#import "ThermostatOperationViewControllerOld.h"
#import "DeviceDetailsTabBarController.h"

#import <PureLayout/PureLayout.h>
#import <i2app-Swift.h>
#import "ApplicationSecureRequestDelegate.h"

@interface HoneywellC2CViewController ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSURLRequest *urlRequest;

@end

static const NSString *kAccessControlListUrl = @"AccessControlList";

@implementation HoneywellC2CViewController {
    BOOL _nextRequestShouldUseSession;
    BOOL _statusScreenIsDisplayed;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];

    // Stop the pairing mode
    [[DevicePairingManager sharedInstance] stopHubPairing];
    
    [self navBarWithBackButtonAndTitleImage];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    
    self.view.backgroundColor = [UIColor clearColor];

    [self loadUrlRequest];
    
    self.webView.scalesPageToFit = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.webView];
// FIXME:
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self createGif];

    _nextRequestShouldUseSession = NO;
    _statusScreenIsDisplayed = NO;
}

- (void)loadUrlRequest {
    NSString *urlString;
    NSString *honeywellConnectUrl = [NSString stringWithFormat:@"%@?response_type=code&client_id=%@&redirect_uri=%@&scope=Basic Power&state=", [[CorneaHolder shared] session].sessionInfo.honeywellLoginBaseUrl, [[CorneaHolder shared] session].sessionInfo.honeywellClientId, [[CorneaHolder shared] session].sessionInfo.honeywellRedirectUri];
    if (self.isPairingMode) {
        urlString = [NSString stringWithFormat:@"%@pair:%@", honeywellConnectUrl, [[CorneaHolder shared] settings].currentPlace.modelId];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@login:%@", honeywellConnectUrl, [[CorneaHolder shared] settings].currentPlace.modelId];
    }
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self loadUrlRequest];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.mainDocumentURL.absoluteString;
    
    // DDLogInfo(@"%@", url);
    if (_nextRequestShouldUseSession) {
        if ([url containsString:[[CorneaHolder shared] session].sessionInfo.honeywellLoginBaseUrl]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [self sendRequestUsingSession:url];
            });
            return NO;
        }
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DDLogInfo(@"webViewDidStartLoad: %@", webView.request.mainDocumentURL.absoluteString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideGif];
    DDLogError(@"didFailLoadWithError:%@", webView.request.description);
    DDLogError(@"%@", error.description);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideGif];
    
    NSString *innerHtml = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    if ([innerHtml containsString:@"AccessControlList"]) {
        _nextRequestShouldUseSession = YES;
    }
    // DDLogInfo(@"Current URL*******: %@", innerHtml);
}

#pragma mark - Private
- (void)sendRequestUsingSession:(NSString *)url {
    ApplicationSecureRequestDelegate *delegate = [ApplicationSecureRequestDelegate new];
  
    // Instantiate a session configuration object.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Instantiate a session object.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:delegate
                                                     delegateQueue:nil];
    
    // Create a data task object to perform the data downloading.
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            [self reportFailure];
            // If any error occurs then just display its description on the console.
            DDLogWarn(@"%@", error.localizedDescription);
        }
        else {
            // If no error occurs, check the HTTP status code.
            NSInteger HTTPStatusCode = ((NSHTTPURLResponse *)response).statusCode;
            
            // If it's other than 200, then show it on the console.
            if (HTTPStatusCode == 200 && [response.URL.absoluteString containsString:[[CorneaHolder shared] session].sessionInfo.honeywellRedirectUri]) {
                [self reportSuccess];
            }
            else {
                DDLogWarn(@"HTTP status code = %d", (int)HTTPStatusCode);
                [self reportFailure];
            }
        }
        _nextRequestShouldUseSession = NO;
    }];
    
    [task resume];
}

- (void)reportSuccess {
    if (_statusScreenIsDisplayed) {
        return;
    }
    _statusScreenIsDisplayed = YES;
    
    if (self.isPairingMode) {
        [[DevicePairingManager sharedInstance] subscribeToDeviceAddedNotification];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            HoneywellC2CStatusViewController *vc = [HoneywellC2CStatusViewController create];
            vc.isSuccessful = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
    else {
        [self goBackToDeviceDetails:YES];
    }
}

- (void)reportFailure {
    if (_statusScreenIsDisplayed) {
        return;
    }
    _statusScreenIsDisplayed = YES;
    if (self.isPairingMode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HoneywellC2CStatusViewController *vc = [HoneywellC2CStatusViewController create];
            vc.isSuccessful = NO;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
    else {
        [self goBackToDeviceDetails:NO];
    }
}

- (void)goBackToDeviceDetails:(BOOL)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        DeviceDetailsTabBarController *tabBarController = (DeviceDetailsTabBarController *)[self findLastViewController:[DeviceDetailsTabBarController class]];
        if (tabBarController) {
                [self.navigationController popToViewController:tabBarController animated:YES];

            if (self.goToViewController) {
                [((ThermostatOperationViewControllerOld *)self.goToViewController) refreshDeviceModel:success];
            }
        }
    });
}


@end
