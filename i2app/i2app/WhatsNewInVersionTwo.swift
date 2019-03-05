//
//  WhatsNewInVersionTwo.swift
//  i2app
//
//  Created by Arcus Team on 3/2/17.
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
import CocoaLumberjack

protocol WhatsNewViewControllerContainer: class {
  func didFinishDisplayOfWhatsNew()
}

class WhatsNewInVersionTwo: UIViewController {

  @IBOutlet weak var webView: UIWebView!

  /// Injected Presenter, must be set before viewDidLoad
  var presenter: WhatsNewPresenterViewProtocol!

  /// whats new container
  weak var container: WhatsNewViewControllerContainer!

  override func viewDidLoad() {
    super.viewDidLoad()
    if let urlToLoad = presenter.urlToLoad {
      let urlRequest = URLRequest(url: urlToLoad)
      self.webView.loadRequest(urlRequest)
    } else {
      DDLogWarn("Unexpected bahavior, Presenter misconfigured closing to dashboard")
      closePressed()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    presenter.presentedSaveAppVersion()
  }

  class func create(withPresenter: WhatsNewPresenterViewProtocol,
                    container: WhatsNewViewControllerContainer) -> WhatsNewInVersionTwo? {
    let storyboard: UIStoryboard = UIStoryboard(name: "WhatsNewInVersionTwo", bundle:nil)
    let viewController = storyboard.instantiateInitialViewController() as? WhatsNewInVersionTwo
    viewController?.presenter = withPresenter
    viewController?.container = container
    return viewController
  }

  @IBAction func closePressed() {
    if let parent = self.presentingViewController {
      parent.dismiss(animated: true, completion: { [weak self] _ in
        guard let strongSelf = self else {
          return
        }
        strongSelf.container.didFinishDisplayOfWhatsNew()
      })
    }
  }
}

extension WhatsNewInVersionTwo: UIWebViewDelegate {
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    guard let url = request.url else {
      // Don't know what is happening, loading without a URL? But this does the default behavior
      return true
    }
    DDLogInfo("Will open url: \(url.absoluteString)")
    if url == presenter.urlToLoad {
      return true
    } else {
      UIApplication.shared.openURL(url)
      return false
    }
  }
}
