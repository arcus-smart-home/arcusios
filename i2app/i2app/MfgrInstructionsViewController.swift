//
//  MfgrInstructionsViewController.swift
//  i2app
//
//  Arcus Team on 2/23/18.
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

public class MfgrInstructionsViewController: UIViewController {
  
  @IBOutlet weak var webview: UIWebView!
  var instructionsUrl: URL?

  override public func viewDidAppear(_ animated: Bool) {
    if let url = instructionsUrl {
      webview.loadRequest(URLRequest(url: url))
    }
  }

  @IBAction func onShareTapped(sender: Any) {
    if let url = instructionsUrl {
      self.present(UIActivityViewController(activityItems: [url], applicationActivities: nil),
                   animated: true,
                   completion: nil)
    }
  }
  
  @IBAction func onCloseTapped(sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
