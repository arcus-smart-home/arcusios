//
//  AccountCreationCompleteAccountPresenter.swift
//  i2app
//
//  Created by Arcus Team on 10/12/17.
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

import Cornea
/**
 Data object used to represent complete account view.
 */
struct AccountCreationCompleteAccountViewModel {
  /**
   A string containing the email of the logged in user
   */
  var userEmail: String?

  /**
   A string containing the name of the logged in user.
   */
  var userName: String?

  /**
   The URL to use for redirecting to complete account in the web.
   */
  var completeAccountURL: URL?
}

/**
 Callback protocol for the Complete Account Presenter updates.
 */
protocol AccountCreationCompleteAccountPresenterDelegate: class {

  /**
   Function called when an update to the delegate's views is needed.
   */
  func shouldUpdateViews()

}

/**
 Definition of the Complete Account Presenter API.
 */
protocol AccountCreationCompleteAccountPresenterProtocol {
  /**
   The object used for update callbacks.
   */
  var delegate: AccountCreationCompleteAccountPresenterDelegate? { get }

  /**
   The data object to be used to populate views.
   */
  var viewModel: AccountCreationCompleteAccountViewModel { get }

  /**
   Starts the retrival of data.
   */
  func fetchData()

  /**
   Logs out from the current account and redirects to the login view controller.
   */
  func logout()
}

/**
 Object used to retrieve and manage the data needed cor the Complete Account View. This class must subclass 
 NSObject in order to implement a URLSessionTaskDelegate conformance.
 */
class AccountCreationCompleteAccountPresenter: NSObject {
  /**
   Required by AccountCreationCompleteAccountPresenterProtocol
   */
  private(set) weak var delegate: AccountCreationCompleteAccountPresenterDelegate?

  /**
   Required by AccountCreationCompleteAccountPresenterProtocol
   */
  fileprivate(set) var viewModel = AccountCreationCompleteAccountViewModel()

  /**
   Initializes the presenter with the given delegate.
   - parameter delegate: The object to be used for update callbacks.
   */
  init(delegate: AccountCreationCompleteAccountPresenterDelegate) {
    self.delegate = delegate
  }

  fileprivate func fetchAccountCompletionURL() {
    // TODO: FIX ME!  REFACTOR TO USE `HttpRequest` AND  `RxCornea`
//    guard let webLaunchURL = RxCornea.shared.session?.sessionInfo?.webLaunchURL else { return }
//    let urlString = webLaunchURL + "/create-account/ios"
//
//    guard let token = ArcusClient.sharedInstance().sessionToken().value,
//      let url = URL(string: urlString) else {
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.addValue("arcusAuthToken=\(token)", forHTTPHeaderField: "Cookie")
//    let configuration = URLSessionConfiguration.default
//    let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//    let task = session.dataTask(with: request)
//    task.resume()
  }
}

// MARK: AccountCreationCompleteAccountPresenterProtocol

extension AccountCreationCompleteAccountPresenter: AccountCreationCompleteAccountPresenterProtocol,
UserAuthenticationController {
  func fetchData() {
    if let currentPerson = RxCornea.shared.settings?.currentPerson {
      viewModel.userName = currentPerson.firstName
      viewModel.userEmail = currentPerson.emailAddress
    }

    fetchAccountCompletionURL()

    delegate?.shouldUpdateViews()
  }

  func logout() {
    RxCornea.shared.session?.logout()
  }
}

// MARK: URLSessionTaskDelegate

extension AccountCreationCompleteAccountPresenter: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession,
                  task: URLSessionTask,
                  willPerformHTTPRedirection response: HTTPURLResponse,
                  newRequest request: URLRequest,
                  completionHandler: @escaping (URLRequest?) -> Void) {
    if response.statusCode >= 300 && response.statusCode < 400 {
      if let completeAccountURL = request.url {
        viewModel.completeAccountURL = completeAccountURL
      }
      return
    }
  }
}
