//
//  PairingCartViewModel.swift
//  i2app
//
//  Arcus Team on 3/12/18.
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

/// A view model encapsulating the data rendered on a portion of the pairing cart view.
protocol PairingCartCellViewModel {

  /// The name of the UITableViewCell represented by this model
  var reuseIdentifier: String { get }
  
  /// Determines whether the cell is clickable (should be highlighted when clicked)
  var isActionable: Bool { get }
}

/// A veiw model representing the data rendered on the pairing cart view.
struct PairingCartSectionViewModel {

  var isBackButtonHidden = false              // Hide back chevron in nav bar
  var sections: [PairingCartCellViewModel]    // Each section visible on the screen
  var topButton: String?                      // Top button title (nil to hide button)
  var bottomButton: String?                   // Bottom button title
  
  init (_ sections: [PairingCartCellViewModel],
        topButton: String?,
        bottomButton: String?,
        isBackButtonHidden: Bool) {
    
    self.isBackButtonHidden = isBackButtonHidden
    self.sections = sections
    self.topButton = topButton
    self.bottomButton = bottomButton
  }

  init (_ sections: [PairingCartCellViewModel], topButton: String?) {
    self.init(sections, topButton: topButton, bottomButton: "GO TO DASHBOARD", isBackButtonHidden: true)
  }

  init (_ sections: [PairingCartCellViewModel]) {
    self.init(sections, topButton: nil, bottomButton: "GO TO DASHBOARD", isBackButtonHidden: false)
  }

  func getSection<T: PairingCartCellViewModel>(of type: T.Type) -> T? {
    for thisSection in sections {
      if let foundSection = thisSection as? T {
        return foundSection
      }
    }
    
    return nil
  }
  
  func isStillSearching() -> Bool {
    return topButton == nil
  }
}

/// View model associated with the animated home section
struct HomeAnimationSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "HomeAnimationCell"
  let isActionable: Bool = false
  
  var image: UIImage?
  
  init (_ image: UIImage? = UIImage(named: "home_animation_placeholder")) {
    self.image = image
  }
}

/// View model associated with the title/subtitle section
struct TitleSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "TitleCell"
  let isActionable: Bool = false

  var title: String?
  var subtitle: String?
  
  init (title: String?, subtitle: String?) {
    self.title = title
    self.subtitle = subtitle
  }
}

/// View model associated with the "Troubleshooting Title" section
struct TroubleshootingTitleSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "TroubleshootingTitleCell"
  let isActionable: Bool = false

  let title = "Troubleshooting Tips"
}

/// View model associated with the "Troubleshooting Tips" section
struct TroubleshootingTipSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "TroubleshootingTipCell"
  let isActionable: Bool = false

  let tip: HelpStepViewModel
  let tipNumber: Int
  
  init(_ tip: HelpStepViewModel, tipNumber: Int) {
    self.tip = tip
    self.tipNumber = tipNumber
  }
}

/// View model associated with a pair-dev cell that is neither in an error state or
/// fully connected state. (That is, a cell with a progress spinner in it)
struct PendingDeviceSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "PendingDeviceCell"
  let isActionable: Bool = false
  let deviceName: String
  let disposition: String
  
  init(deviceName: String, disposition: String) {
    self.deviceName = deviceName
    self.disposition = disposition
  }
}

/// View model associated with a mispaired/misconfired pair-dev, offering the user
/// an action to resolve the issue.
struct RemoveDeviceSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "RemoveDeviceCell"
  let isActionable: Bool = true
  
  let pairDev: PairingDeviceModel
  let deviceName: String
  let disposition: String
  let callToAction: String
  
  /// Instantiates a model for a mispaired Philips Hue device
  init(hue pairDev: PairingDeviceModel) {
    self.pairDev = pairDev
    self.callToAction = "Remove"
    self.deviceName = "Improperly Paired Hue"
    self.disposition = "Philips Hue"
  }

  /// Instantiates a model for a mispaired device (other than a Philips Hue)
  init(pairDev: PairingDeviceModel, deviceName: String, disposition: String) {
    self.pairDev = pairDev
    self.callToAction = "Remove"
    self.deviceName = pairDev.isPhilipsHue() ? "Improperly Paired Hue" : deviceName
    self.disposition = pairDev.isPhilipsHue() ? "Philips Hue" : disposition
  }
}

/// View model associated with a completely paired and configured device. (Represents
/// a device cell with a green checkmark.)
struct CompletedDeviceSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "CompletedDeviceCell"
  let isActionable: Bool = false
  let deviceName: String
  let vendorName: String
  let productId: String
  let devTypeHint: String
  
  init(deviceName: String, vendorName: String, productId: String, devTypeHint: String) {
    self.deviceName = deviceName
    self.vendorName = vendorName
    self.productId = productId
    self.devTypeHint = devTypeHint
  }
}

/// View model associated with a paired, but unconfigured device. Offers the user
/// the action to configure the device.
struct CustomizeDeviceSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "CustomizeDeviceCell"
  let isActionable: Bool = true
  
  let address: String
  let deviceName: String
  let vendorName: String
  let productId: String
  let devTypeHint: String
  
  init(address: String, deviceName: String, vendorName: String, productId: String, devTypeHint: String) {
    self.address = address
    self.deviceName = deviceName
    self.vendorName = vendorName
    self.productId = productId
    self.devTypeHint = devTypeHint
  }
}

/// No-op view model representing a horizontal rule cell.
struct HorizontalRuleSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "HorizontalRuleCell"
  let isActionable: Bool = false
}

/// No-op view model representing a 42px space/margin between cells/sections.
struct SpacerSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "SpacerSectionCell"
  let isActionable: Bool = false
}

/// No-op view model representing the "No Devices" icon appearing under special cases in
/// the pairing cart. 
struct NoDevicesSectionModel: PairingCartCellViewModel {
  let reuseIdentifier: String = "NoDevicesCell"
  let isActionable: Bool = false
}
