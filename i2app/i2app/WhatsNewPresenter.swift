//
//  WhatsNewPresenter.swift
//  i2app
//
//  Created by Arcus Team on 9/26/17.
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

protocol WhatsNewPresenterConnectivityDelegate: class {
  func whatsNewIsPrepared(_ presenter: WhatsNewPresenter)
  func whatsNewIsNotNeeded(_ presenter: WhatsNewPresenter)
}

protocol WhatsNewPresenterFetchProtocol: class {
  func checkShouldDisplayWhatsNewScreen()
}

protocol WhatsNewPresenterViewProtocol: class {
  var urlToLoad: URL? { get }
  func presentedSaveAppVersion()
}

let kLastVersionLaunchedKey = "LastVersionLaunched"

fileprivate struct StaticResource {
  static var baseURLString: String {
    if let ssr = RxCornea.shared.session?.sessionInfo?.staticResourceBaseUrl {
      return ssr
    }
    return ""
  }
}

class WhatsNewPresenter: WhatsNewPresenterFetchProtocol, WhatsNewPresenterViewProtocol {

  weak var connectivityDelegate: WhatsNewPresenterConnectivityDelegate!

  var urlToLoad: URL?

  init(connectivityDelegate: WhatsNewPresenterConnectivityDelegate) {
    self.connectivityDelegate = connectivityDelegate
  }

  func checkShouldDisplayWhatsNewScreen() {
    guard let currentAppVersion = currentAppVersion else {
      DDLogWarn("Unexpected Bahavior CFBundleShortVersionString not available")
      // exit gracefully
      self.connectivityDelegate.whatsNewIsNotNeeded(self)
      return
    }
    if savedVersion == nil || savedVersion != currentAppVersion {
      recursivelyCheckVersionURL(with: currentAppVersion)
    } else {
      self.connectivityDelegate.whatsNewIsNotNeeded(self)
    }
  }

  func presentedSaveAppVersion() {
    if let currentAppVersion = currentAppVersion {
      UserDefaults.standard.set(currentAppVersion, forKey: kLastVersionLaunchedKey)
    }
  }

  fileprivate func recursivelyCheckVersionURL(with versionString: String) {
    guard let urlForVersion = buildURL(with: versionString) else {
      // No longer a valid URL
      self.connectivityDelegate.whatsNewIsNotNeeded(self)
      return
    }
    let configuration = URLSessionConfiguration.ephemeral
    let session =  URLSession(configuration: configuration, delegate:nil, delegateQueue: OperationQueue.main)
    var mutableRequest = URLRequest(url: urlForVersion)
    mutableRequest.httpMethod = "HEAD"
    let task = session.dataTask(with: mutableRequest) {
      _, response, error in
      if error != nil {
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
          self.urlToLoad = urlForVersion
          self.connectivityDelegate.whatsNewIsPrepared(self)
          break
        case 404:
          let nextVersionUp = versionString.removePointFromVersionString()
          self.recursivelyCheckVersionURL(with: nextVersionUp)
          break
        default:
          break
        }
      }
    }
    task.resume()
  }

  func buildURL(with versionString: String) -> URL? {
    if versionString == "" {
      return nil
    }
    let toSlashes = versionString.replacingOccurrences(of: ".", with: "/")
    let builtString = "\(StaticResource.baseURLString)/o/release/ios/\(toSlashes)/notes.html"
    return URL(string: builtString)
  }

  var savedVersion: String? {
    return UserDefaults.standard.string(forKey: kLastVersionLaunchedKey)
  }

  var currentAppVersion: String? {
    if let infoDictionary = Bundle.main.infoDictionary,
      let bundleShortVersionString = infoDictionary["CFBundleShortVersionString"] as? String {
      return bundleShortVersionString
    }
    return nil
  }
}

fileprivate extension String {
  func removePointFromVersionString() -> String {
    var numberList = self.components(separatedBy: ".")
    if numberList.count > 2 {
      numberList.removeLast()
      return numberList.joined(separator: ".")
    } else {
      return ""
    }
  }
}

// Past Keys saved here so we know the previous values to prevent conflicts
let kVersion2_1Launched: String = "kVersionTwoLaunched"
let kVersion2_2Launched: String = "kVersionTwoDotTwoLaunched"
let kVersion2_3Launched: String = "kVersionTwoDotThreeLaunched"
let kVersion2_4Launched: String = "kVersionTwoDotFourLaunched"
let kVersion2_4_1Launched: String = "kVersionTwoDotFourDotOneLaunched"
let kVersion2_5Launched: String = "kVersionTwoDotFiveLaunched"
