//
//  C2CPairingResponder.swift
//  i2app
//
//  Arcus Team on 3/5/18.
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

import Foundation
import Cornea

/// A presenter of a modal cloud-to-cloud view controller containing a web view and button bar
/// containing a cancel button.
protocol C2CPresenterProtocol {

  /// The (child) view controller responsibile for hiding/showing the cancel button and dismissing the
  /// modal view controller.
  var cancelDelegate: C2CCancelableDelegate? { get set }
  
  /// The (parent) view controller responsible for handling success/fail terminal states when the
  /// cloud-to-cloud connection process completes.
  var navigationDelegate: C2CNavigationDelegate? { get set }
  
  /// Delegate used to convey the loading status of the web view.
  var webLoadingDelegate: C2CWebLoadingDelegate? { get set }

  /// Sets whether the cancel button should be visible in the button bar.
  /// - Parameter cancelable: True to show the cancel button, false to hide it.
  func setIsCancelable(_ cancelable: Bool)
  
  /// Call to indicate the cloud-to-cloud connection process is complete but failed to create a
  /// connection to the Arcus cloud.
  func cloudConnectionFailed()
  
  /// Call to indicate the cloud-to-cloud connection process successfully completed.
  func cloudConnectionSucceeded()
  
  /// Should be called when the web view has finished loading.
  func webViewFinishedLoading()
}

/// A delegate responsible for mangaging the visibility of the cancel button and the display of
/// the modal cloud-to-cloud view controller.
protocol C2CCancelableDelegate: class {

  /// Called to indicate the cancelable state of the connection process has changed and the delegated
  /// view controller should hide or show its cancel button accordingly.
  ///
  /// - Parameter cancelable: True to indicate connection is in a cancelable state; show cancel button.
  func onCancelableStateChanged(_ cancelable: Bool)
  
  /// Called to indicate the modal view controller should be dismissed.
  ///
  /// - Parameter animated: Indication of whether dismiss action should be animated.
  func onDismissed(animated: Bool)
}

/// A delgate responsible for managing terminal state behavior of the cloud-to-cloud connection
/// process.
protocol C2CNavigationDelegate: class {

  /// Called to indicate the connection process completed sucesfully (typically indicating that user
  /// user should transition to pairing cart screen).
  func onCloudToCloudConnectionSucceeded()
  
  /// Called to indicate the connection process failed.
  func onCloudToCloudConnectionFailed()
  
  // Indicates the the oath flow has been canceled.
  func onCloudToCloundCanceled()
}

protocol C2CWebViewDelegate: class {
  /// Our Web View Delegates are a strategy to handle the business logic of a webview's actions,
  /// but also in a few places it makes sense for them to act as presenters to understand the business
  /// logic of URL creation. An example is Lutron needs a cookie set to the URLRequest
  func createURLRequest() -> URLRequest

  /// The base URL to be used to generate the URLRequest
  var baseUrl: URL { get }

  /// Required Initalizer
  init(_ presenter: C2CPresenter, baseUrl: URL, style: CloudToCloudStyle)
}

protocol C2CWebLoadingDelegate: class {
  
  /// Called when the web view has finsished loading.
  func webViewFinishLoading()
  
}

/// Helper method of string to check if any objects in a list are contained within it
public extension String {
  func containsFromList(_ list: [String]) -> Bool {
    var wasFound = false
    for searchString in list {
      wasFound = self.contains(searchString)
      if wasFound { // exit early if found
        break
      }
    }
    return wasFound
  }
}

public struct C2CWebViewDelegateConstants {

  var sessionInfo: ArcusSessionInfo? {
    return RxCornea.shared.session?.sessionInfo
  }

  var redirectFlags: [String] {
    var flags = [
      "state=success", // Nest
      "pair/success"  // Lutron
    ]
    if let honeywell = self.sessionInfo?.honeywellRedirectUri {
      flags.append(honeywell)
    }
    return flags
  }

  var abortFlags: [String] = [
    "state=error", // Nest
    "/pair/cancel" // Lutron
  ]
  
  var deniedFlags: [String] = [
    "error=access_denied"
  ]

  var startLoadingUrlShowCancel: String = ""

  var showCancelUrls: [String] = [
  ]
  
  var honeywellRedirectURL: String? {
    return sessionInfo?.honeywellRedirectUri
  }
}

class C2CPresenter: C2CPresenterProtocol {

  weak var cancelDelegate: C2CCancelableDelegate?
  weak var navigationDelegate: C2CNavigationDelegate?
  weak var webLoadingDelegate: C2CWebLoadingDelegate?
  
  func webViewFinishedLoading() {
    DispatchQueue.main.async {
      self.webLoadingDelegate?.webViewFinishLoading()
    }
  }
  
  func setIsCancelable(_ cancelable: Bool) {
    DispatchQueue.main.async {
      self.cancelDelegate?.onCancelableStateChanged(cancelable)
    }
  }
  
  func cloudConnectionFailed() {
    DDLogWarn("cloudConnectionFailed")
    DispatchQueue.main.async {
      self.cancelDelegate?.onDismissed(animated: true)
      self.navigationDelegate?.onCloudToCloudConnectionFailed()
    }
  }
  
  func cloudConnectionSucceeded() {
    DDLogInfo("cloudConnectionSucceeded")
    DispatchQueue.main.async {
      self.cancelDelegate?.onDismissed(animated: true)
      self.navigationDelegate?.onCloudToCloudConnectionSucceeded()
    }
  }
}
