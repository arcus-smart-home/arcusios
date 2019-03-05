//
//  C2CPairingViewController.swift
//  i2app
//
//  Arcus Team on 2/27/18.
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

enum CloudToCloudSegues: String {
  case segueToPairingCart = "PairingCartSegue"
  case unwindToBrandList = "UnwindToBrandList"
}

class C2CPairingViewController: UIViewController, C2CCancelableDelegate {

  @IBOutlet weak var webview: UIWebView!
  @IBOutlet weak var loadingOverlay: UIView!

  var c2cUrl: URL?
  var c2cStyle: CloudToCloudStyle?
  let presenter = C2CPresenter()

  // This delegate does not hold a view controller and therefore needs to be a strong ref
  private var webDelegate: C2CWebViewDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    addScleraStyleToNavigationTitle()
    createNavigationCancelButton()
    
    presenter.webLoadingDelegate = self
    
    if let url = self.c2cUrl, let style = self.c2cStyle {
      
      // Create a strong ref to the web delegate and pass to webview
      let aWebDelegate = C2CWebDelegate(presenter, baseUrl: url, style: style)
      webview.delegate = aWebDelegate
      webview.loadRequest(aWebDelegate.createURLRequest())
      self.webDelegate = aWebDelegate
    }
  }
  
  // MARK: Cloud to Cloud Delegate
  
  func onCancelableStateChanged(_ cancelable: Bool) {
    if cancelable {
      createNavigationCancelButton()
    } else {
      navigationItem.setLeftBarButton(nil, animated: true)
    }
  }
  
  func onDismissed(animated: Bool) {
    dismiss(animated: animated, completion: nil)
  }
  
  func cancelButtonTapped(_ sender: Any) {
    dismiss(animated: true, completion: { [weak self] in
      self?.presenter.navigationDelegate?.onCloudToCloundCanceled()
    })
  }
  
  private func createNavigationCancelButton() {
    let cancelButton = UIButton(type: .custom)
    cancelButton.setTitle("Cancel", for: .normal)
    cancelButton.setTitleColor(ScleraColor.text, for: .normal)
    cancelButton.titleLabel?.font = UIFont(name: ScleraFontFamily.regular, size: 18)
    cancelButton.frame = CGRect(x: 0, y: 0, width: 60, height: 18)
    cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
  }
}

extension C2CPairingViewController: C2CWebLoadingDelegate {
  
  func webViewFinishLoading() {
    guard !loadingOverlay.isHidden else {
      return
    }
    
    UIView.animate(withDuration: 0.25, animations: { [weak self] in
      self?.loadingOverlay.alpha = 0
    }) { [weak self] _ in
      self?.loadingOverlay.isHidden = true
    }
  }
  
}
