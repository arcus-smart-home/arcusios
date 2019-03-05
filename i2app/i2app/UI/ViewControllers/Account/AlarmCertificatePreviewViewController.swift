//
//  AlarmCertificatePreviewViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/5/17.
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

class AlarmCertificatePreviewViewController: UIViewController {
  @IBOutlet weak var webView: UIWebView!

  var pdfData = Data()
  var pdfURL = ""

  var interactionController: UIDocumentInteractionController!

  @IBAction func shareButtonPressed(_ sender: Any) {

    do {
      let fileURL = try FileManager.default.url(for: .documentDirectory,
                                                 in: .userDomainMask,
                                                 appropriateFor: nil,
                                                 create: false).appendingPathComponent("AlarmCertificate.pdf")
      try pdfData.write(to:fileURL)

      interactionController = UIDocumentInteractionController(url: fileURL)
      interactionController.presentOptionsMenu(from: self.view.frame,
                                               in: self.view,
                                               animated: true)
    } catch {
      let errorMessage = NSLocalizedString(
        "Unable to share Alarm Certificate. Please try again later.",
        comment: "")

      displayErrorMessage(errorMessage, withTitle: NSLocalizedString("UNABLE TO SHARE", comment: ""))
    }
  }

  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navBar(withTitle: self.navigationItem.title)

    if let url = URL(string: pdfURL) {
      let request = URLRequest(url: url)
      webView.loadRequest(request)
    }
  }
}

// MARK: UIWebViewDelegate

extension AlarmCertificatePreviewViewController: UIWebViewDelegate {
  func webView(_ webView: UIWebView,
               shouldStartLoadWith request: URLRequest,
               navigationType: UIWebViewNavigationType) -> Bool {
    return true
  }
}
