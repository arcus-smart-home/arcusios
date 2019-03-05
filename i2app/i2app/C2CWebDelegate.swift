//
//  C2CWebDelegate.swift
//  i2app
//
//  Created by Arcus Team on 6/8/18.
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

import UIKit
import Cornea

/// Class to support web routing for OAuth Devices, communicates to a presenter any changes that need to occur
/// due to changes in the webview. Uses the `C2CWebViewDelegateConstants` struct to make comparisons of
/// urls to a list of strings to determin logic. Also this will set the Cookie Jar for Lutron pairing
class C2CWebDelegate: NSObject, C2CWebViewDelegate, UIWebViewDelegate {

  var presenter: C2CPresenter
  var baseUrl: URL
  var nextRequestUsesSession = false
  var style: CloudToCloudStyle
  var constants = C2CWebViewDelegateConstants()

  public required init(_ presenter: C2CPresenter, baseUrl: URL, style: CloudToCloudStyle) {
    self.baseUrl = baseUrl
    self.presenter = presenter
    self.style = style
  }

  public func createURLRequest() -> URLRequest {
    if style == .lutron {
      setCookieJar()
    }
    return URLRequest(url: baseUrl)
  }

  /// Given a placeModel and session token set the shared HTTPCookieStorage with a cookie needed to
  /// use OAuth in the Lutron pairing flow.
  ///
  /// - This is marked public for potential testing in the future
  public func setCookieJar(_ placeModelId: String? = RxCornea.shared.settings?.currentPlace?.modelId,
                           _ sessionToken: String? = RxCornea.shared.session?.token?.value) {
    guard let placeId = placeModelId,
      let sessionToken = sessionToken else {
        return
    }

    let urlString = baseUrl.absoluteString + "?place=" + placeId
    guard let url = URL(string: urlString) else {
      return
    }

    let cookieProperties: [HTTPCookiePropertyKey : Any] = [
      .name: "arcusAuthToken",
      .value: sessionToken,
      .originURL: url,
      .path: "/",
      .expires: NSDate().addingDays(1)
    ]

    if let cookie = HTTPCookie(properties: cookieProperties) {
      let cookieJar = HTTPCookieStorage.shared
      cookieJar.setCookie(cookie)
    }
  }

  // MARK: UIWebViewDelegate

  public func webView(_ webView: UIWebView,
                      shouldStartLoadWith request: URLRequest,
                      navigationType: UIWebViewNavigationType) -> Bool {
    guard let url = request.url?.absoluteString else {
      return true
    }
    
    if shouldURLSucceed(url: url) && style != .honeywell {
      // Honeywell devices should only report success on the webViewDidFinishLoad delegate call to avoid
      // redirecting the user too early.
      presenter.cloudConnectionSucceeded()
      return false
    } else if shouldURLFail(url: url) {
      presenter.cloudConnectionFailed()
      return false
    }
    
    return true
  }

  public func webViewDidFinishLoad(_ webView: UIWebView) {
    presenter.webViewFinishedLoading()
    
    guard let url = webView.request?.url?.absoluteString else {
      return
    }
    
    presenter.setIsCancelable(url.containsFromList(constants.showCancelUrls))
    
    if shouldURLSucceed(url: url) {
      presenter.cloudConnectionSucceeded()
    } else if shouldURLFail(url: url) {
      presenter.cloudConnectionFailed()
    }
  }

  public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    presenter.cloudConnectionFailed()
  }
  
  private func shouldURLSucceed(url: String) -> Bool {
    // Ensure that the honeywell flow does not succeed until the last page is reached.
    if style == .honeywell {
      if url.containsFromList(constants.redirectFlags) && !url.contains("redirect_uri") {
        return true
      } else {
        return false
      }
    }
    
    return url.containsFromList(constants.redirectFlags)
  }
  
  private func shouldURLFail(url: String) -> Bool {
    return url.containsFromList(constants.abortFlags) || url.containsFromList(constants.deniedFlags)
  }

}
