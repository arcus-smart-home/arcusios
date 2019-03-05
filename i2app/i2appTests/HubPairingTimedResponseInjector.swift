//
//  HubPairingTimedResponseInjector.swift
//  i2app
//
//  Created by Paul Wood on 6/20/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import Foundation
@testable import i2app

///prepare a list of responses to inject into hub pairing
class HubPairingTimedResponseInjector {

  /// a list of responses to inject, or NSNull to use the last response
  var responses: [Any] = []

  var lastResponseSent: Any? = nil

  var currentIndex: Int = 0

  /// the next response to inject
  func next () {}
}
