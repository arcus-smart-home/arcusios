//
//  TermsConditionsViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/28/16.
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

class TermsConditionsViewController: UIViewController {

  class func create() -> TermsConditionsViewController {
    let storyboard: UIStoryboard = UIStoryboard(name: "TutorialsStoryboard", bundle:nil)
    let viewController: TermsConditionsViewController? =
      storyboard.instantiateViewController(withIdentifier: "TermsConditionsViewController")
        as? TermsConditionsViewController

    return viewController!
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = ObjCMacroAdapter.arcusPurpleAlertColor()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.navigationController!.navigationBar.isHidden = true
  }

  func goToPrivacyStatement() {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusPrivacyStatementUrl()
    self.navigationController!.navigationBar.isHidden = false
    self.navigationController?.pushViewController(webView, animated: true)
  }

  func goToTermsOfService() {
    let webView: WebViewController = WebViewController()
    webView.urlString = ObjCMacroAdapter.arcusTermsOfServiceUrl()
    self.navigationController!.navigationBar.isHidden = false
    self.navigationController?.pushViewController(webView, animated: true)
  }

  @IBAction func termsOfServiceTopPressed(_ sender: AnyObject) {
    self.goToTermsOfService()
  }

  @IBAction func PrivacyStatementTop1Pressed(_ sender: AnyObject) {
    self.goToPrivacyStatement()
  }

  @IBAction func PrivacyStatementTop2Pressed(_ sender: AnyObject) {
    self.goToPrivacyStatement()
  }

  @IBAction func termsOfServiceBottomPressed(_ sender: AnyObject) {
    self.goToTermsOfService()
  }

  @IBAction func PrivacyStatementBottomPressed(_ sender: AnyObject) {
    self.goToPrivacyStatement()
  }

  @IBAction func acceptButtonPressed(_ sender: AnyObject) {
    guard let person = RxCornea.shared.settings?.currentPerson else { return }

    let completion: () -> Void = {
      DispatchQueue.main.async {
        self.dismiss(animated: true, completion: nil)
      }
    }
    SessionController.acceptNewTermsAndConditions(person, completion: completion)
  }
}
