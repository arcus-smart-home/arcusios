
//
// I18NServiceEvents.swift
//
// Generated on 20/09/18
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

import Foundation
// MARK: Commands
fileprivate struct Commands {
  /** Loads localized keys from the server */
  public static let i18NServiceLoadLocalizedStrings: String = "i18n:LoadLocalizedStrings"
  
}

// MARK: Requests

/** Loads localized keys from the server */
public class I18NServiceLoadLocalizedStringsRequest: ClientMessage, ArcusClientRequest {
  
  // MARK: I18NServiceLoadLocalizedStringsRequest Enumerations
  
  override init() {
    super.init()
    self.command = Commands.i18NServiceLoadLocalizedStrings
  }

  public func responseEventForMessage(_ message: ArcusClientMessage) -> ArcusEvent {
    guard message.type != "Error" else {
      var errorCode: String = ClientError.ErrorType.unknown.rawValue
      var errorMessage: String = ""

      if let code = message.attributes["code"] as? String {
        errorCode = code
      }

      if let message = message.attributes["message"] as? String {
        errorMessage = message
      }

      let error = ClientError(code: errorCode, message: errorMessage)
      return SessionErrorEvent(message, error: error)
    }
    return I18NServiceLoadLocalizedStringsResponse(message)
  }
  // MARK: LoadLocalizedStringsRequest Attributes
  struct Attributes {
    /** The set of bundles to load, if null or empty all bundles will be loaded */
    static let bundleNames: String = "bundleNames"
/** The locale to load the localized strings, if not provided or is empty en-US will be used */
    static let locale: String = "locale"
 }
  
  /** The set of bundles to load, if null or empty all bundles will be loaded */
  public func setBundleNames(_ bundleNames: [String]) {
    attributes[Attributes.bundleNames] = bundleNames as AnyObject
  }

  
  /** The locale to load the localized strings, if not provided or is empty en-US will be used */
  public func setLocale(_ locale: String) {
    attributes[Attributes.locale] = locale as AnyObject
  }

  
}

public class I18NServiceLoadLocalizedStringsResponse: SessionEvent {
  
  
  /** A map of all the localized strings in the given locale where they key is prefixed with the &#x27;bundleName:&#x27; */
  public func getLocalizedStrings() -> [String: String]? {
    return self.attributes["localizedStrings"] as? [String: String]
  }
}

