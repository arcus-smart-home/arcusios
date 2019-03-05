//
//  DeviceBLEPairingDeviceDiscoveryViewController.swift
//  i2app
//
//  Created by Paul Wood on 8/3/18.
//  Copyright © 2018 Lowes Corporation. All rights reserved.
//

import Foundation

class DeviceBLEPairingDeviceDiscoveryViewController: BLEPairingDeviceDiscoveryViewController {

  // MARK - Constructor

  static func fromPairingStep(step: IrisPairingStepViewModel,
                              presenter: BLEPairingPresenterProtocol) -> BLEPairingDeviceDiscoveryViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingDeviceDiscoveryViewController")
      as? BLEPairingDeviceDiscoveryViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let client = step.config as? (IrisBLEAvailability & IrisBLEScannable & IrisBLEConnectable) {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }
  
}
