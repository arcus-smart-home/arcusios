//
//  PlatformSwitchingController.swift
//  i2app
//
//  Created by Aron Crittendon on 11/16/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import Foundation

enum PlatformType: String {
  case dev = "DEV"
  case prod = "PROD"
}

protocol PlatformSwitchingController {
  static func setPlatformType(_ platform: PlatformType)
  static func getPlatformType() -> PlatformType
  static func isUsingDev() -> Bool
}

// TODO: FINISH IMPLEMENTATION
extension PlatformSwitchingController {
  static func setPlatformType(_ platform: PlatformType) {

  }

  static func getPlatformType() -> PlatformType {
    return .dev
  }

  static func isUsingDev() -> Bool {
    return true
  }
}
