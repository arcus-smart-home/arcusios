//
//  Model+Extension.swift
//  i2app
//
//  Created by Aron Crittendon on 10/13/17.
//  Copyright © 2017 Lowes Corporation. All rights reserved.
//

import Foundation

extension Model {
  var name: String {
    return getName()
  }

  var tags: [AnyObject]? {
    return getTags()
  }

  var caps: [String]? {
    return getCapabilities()
  }

  var instances: [String: AnyObject]? {
    return getInstances()
  }

  var type: String? {
    return getType()
  }
}
