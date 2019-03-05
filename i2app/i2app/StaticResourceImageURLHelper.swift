//
//  StaticResourceImageURLHelper.swift
//  i2app
//
//  Created by Arcus Team on 3/21/18.
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
// swiftlint:disable line_length

import Foundation
import Cornea

protocol StaticResourceImageURLHelper {
  /**
   Gets the image url for a customization step given the appropiate data.
   - parameter productId: The product ID of the product the step belongs to.
   - returns: A URL containing the path to the image for the step. Or an empty fallback URL
              if arguments are invalid
   */
  func getCustomizationStepImageUrl(stepId: String) -> URL

  /**
   returns a wellformated URL of the small color brand image
   - parameter brandName: the brand name, which will be properly formated
   - returns: A URL containing the path to the image for the step. Or an empty fallback URL
              if arguments are invalid
   */
  func getSmallBrandImage(_ brandName: String) -> URL

  /// Handles Product images small or large
  /// - parameter productId: no formatting needed
  /// - parameter isLarge: if is isLarge you get the "large" image else the "small" image
  /// - returns: A URL containing the path to the image for the step. Or an empty fallback URL
  ///            if arguments are invalid
  func getProductImage(productId: String, isLarge: Bool) -> URL

  /// Handles Product images small or large
  /// - parameter fromDevTypeHint: no formatting needed
  /// - parameter isLarge: if is isLarge you get the "large" image else the "small" image
  /// - returns: A URL containing the path to the image for the step. Or an empty fallback URL
  ///            if arguments are invalid
  func getProductImage(fromDevTypeHint hint: String, isLarge: Bool) -> URL 
}

extension StaticResourceImageURLHelper {

  var staticResourceBaseUrl: String {
    return RxCornea.shared.session?.sessionInfo?.staticResourceBaseUrl ?? ""
  }

  var scale: String {
    switch UIScreen.main.scale {
    case 1.0:
      return "1x"
    case 2.0:
      return "2x"
    case 3.0:
      return "3x"
    default:
      // Default to 2x for new and unexpected scale types
      return "2x"
    }
  }

  func getCustomizationStepImageUrl(stepId: String) -> URL {
    return URL(string: "\(staticResourceBaseUrl)/o/\(stepId)-ios-\(scale).png")!
  }

  fileprivate func safelyCreatedUrl(_ formatted: String) -> URL {
    if let url = URL(string: formatted) {
      return url
    } else {
      DDLogError("FATAL ERROR Cannot create a URL with this brand!")
      ArcusAnalytics.tag(AnalyticsTags.ImageURLCreationFatalError, attributes: [:])
      // Sweep it under the rug kinda because thats how we roll
      return URL(string: "")!
    }
  }

  func getSmallBrandImage(_ brandName: String) -> URL {
    let adjustedBrandName =
      brandName
        .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        .components(separatedBy: .whitespaces)
        .joined()
        .lowercased()

    // Example Format, search Confluence for `Dynamic Mobile and Web Asset Filename Convention`
    // to see the specification
    let formatted = "\(staticResourceBaseUrl)/o/brands/\(adjustedBrandName)/brand_small_color-ios-\(scale).png"
    return safelyCreatedUrl(formatted)
  }

  func getProductImage(productId: String, isLarge: Bool) -> URL {
    let formatted = "\(staticResourceBaseUrl)/o/products/\(productId)/product_\(isLarge ? "large":"small")-ios-\(scale).png"
    return safelyCreatedUrl(formatted)
  }

  func getProductImage(fromDevTypeHint devHint: String, isLarge: Bool) -> URL {
    let hint =
      devHint
        .replacingOccurrences(of: "/", with: "")
        .components(separatedBy: .whitespaces)
        .joined()
        .lowercased()
    let formatted = "\(staticResourceBaseUrl)/o/dtypes/\(hint)/type_\(isLarge ? "large":"small")-ios-\(scale).png"
    return safelyCreatedUrl(formatted)
  }

}
