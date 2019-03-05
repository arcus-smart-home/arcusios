//
//  ArcusBLEAvailableNetworksPresenter.swift
//  i2app
//
//  Created by Arcus Team on 8/24/18.
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

import RxSwift

protocol ArcusBLEAvailableNetworksPresenter: ArcusCurrentNetworkReadable {
  var currentDeviceNetwork: Variable<WiFiScanItem?> { get set }
  var otherWifiNetworks: Variable<[WiFiScanItem]> { get set }
  var manualConfigSelected: Variable<Bool> { get set }
  var disposeBag: DisposeBag { get set }

  /**
   Method used to create datasource for BLE Pairing Available Network's tableView.

   - Parameters:
   - client: The `ArcusBLEWiFiConfigurable` used to configure search for WiFi networks on the BLE device.

   - Returns: `Observable` of `[BLESectionType]` that can be bound to a UITableView.
   */
  func wifiNetworksDataSource(_ client: ArcusBLEWiFiConfigurable) -> Observable<[BLESectionType]>

  /**
   Method used to handle the selection of a WiFi Network's UITableViewCell.

   - Parameters:
   - indexPath: `IndexPath` of the cell selected.
   */
  func networkCellSelected(_ indexPath: IndexPath)
}

extension ArcusBLEAvailableNetworksPresenter {
  func wifiNetworksDataSource(_ client: ArcusBLEWiFiConfigurable) -> Observable<[BLESectionType]> {
    let discoveryObservable = client.discoverAvailableNetworks()

    let currentNetworkObservable: Observable<[Row]> = bindCurrentDeviceNetwork(discoveryObservable)
      .map { network in
        guard let network = network else {
          return []
        }
        return [Row(viewModel: network as AnyObject)]
    }

    let networkObservable: Observable<[Row]> = bindOtherDeviceNetwork(discoveryObservable)
      .map { networks in
        return networks.map { network in
          return Row(viewModel: network as AnyObject)
        }
    }

    let manualNetworkObservable: Observable<[Row]> =
      Observable<[Row]>.just([Row(viewModel: "Other Wi-Fi Network..." as AnyObject)])

    let observable: Observable<[BLESectionType]> = Observable<[BLESectionType]>
      .combineLatest(currentNetworkObservable, networkObservable, manualNetworkObservable) { current, networks, manual in
        return [BLESectionType(items: current),
                BLESectionType(items: networks),
                BLESectionType(items: manual)]
      }
      .filter{ [unowned client] (sections) -> Bool in
        return !client.isSearching.value
      }

    return observable
  }

  /**
   Private method used to get/bind the iOS Device's current network from the list of `availableNetworks`.

   - Parameters:
   - discoveryObservable: `Observable<[WiFiScanItem]>` representing the list of `availableNetworks`.

   - Returns: `Observable<WiFiScanItem?>` of the iOS Device's currently connected network.
   */
  private func bindCurrentDeviceNetwork(_ discoveryObservable: Observable<[WiFiScanItem]>) -> Observable<WiFiScanItem?> {
    discoveryObservable
      .asObservable()
      .map { [unowned self] (networks) -> WiFiScanItem? in
        guard let currentSSID = self.getCurrentNetworkName() else {
          return nil
        }

        guard let index = networks.index(where: { item in
          return item.ssid == currentSSID
        }) else {
          return nil
        }

        let network = networks[index]

        return network
      }
      .bind(to: currentDeviceNetwork)
      .disposed(by: disposeBag)

    return currentDeviceNetwork.asObservable()
  }

  /**
   Private method used to get/bind the the list of `availableNetworks` to `otherWifiNetworks` excluding
   the iOS Device's currently connected network.

   - Parameters:
   - discoveryObservable: `Observable<[WiFiScanItem]>` representing the list of `availableNetworks`.

   - Returns: `Observable<[WiFiScanItem]>` of the available networks excluding iOS Device's currently
   connected network.
   */
  private func bindOtherDeviceNetwork(_ discoveryObservable: Observable<[WiFiScanItem]>) -> Observable<[WiFiScanItem]> {
    discoveryObservable
      .asObservable()
      .map { networks in
        let currentSSID = self.getCurrentNetworkName()
        let filtered = networks.filter({ (item) -> Bool in
          return item.ssid.count > 0 && item.ssid != currentSSID
        })
        return filtered
      }
      .bind(to: otherWifiNetworks)
      .disposed(by: disposeBag)

    return otherWifiNetworks.asObservable()
  }
}
