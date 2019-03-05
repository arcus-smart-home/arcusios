//
//  BLEListViewController.swift
//  i2app
//
//  Created by Arcus Team on 6/25/18.
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

import UIKit
import Cornea
import CoreBluetooth
import CocoaLumberjack
import RxSwift
import RxCocoa
import RxSwiftExt
import RxDataSources

class BLEListViewController: UIViewController, BLEListPresenter {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bluetoothStatusView: UIView!
  @IBOutlet weak var bluetoothLabel: UILabel!

  @IBOutlet weak var connectedStatusView: UIView!
  @IBOutlet weak var connectedLabel: UILabel!

  @IBOutlet weak var wifiScanView: UIView!
  @IBOutlet weak var wifiScanButton: ScleraButton!

  @IBOutlet weak var networkConfigView: UIView!
  @IBOutlet weak var networkKeyTextField: ScleraTextField!
  @IBOutlet weak var configureNetworkButton: ScleraButton!

  @IBOutlet weak var statusLabel: UILabel!

  var client: BLEClient = BLEPairingClient(CBCentralManager())

  var viewModels: Variable<[ArcusBLEViewModel]> = Variable<[ArcusBLEViewModel]>([])
  var disposeBag: DisposeBag = DisposeBag()

  var selectedNetwork: Variable<WiFiScanItem?> = Variable(nil)
  var networkKey: Variable<String> = Variable("")

  override func viewDidLoad() {
    super.viewDidLoad()
    client = BLEPairingClient(CBCentralManager())

    client.isBLEAvailable()
      .map { available in
        return available ? "Available" : "Unavailable"
      }
      .bind(to: bluetoothLabel.rx.text)
      .disposed(by: disposeBag)

    _ = client.scanForBLEDevices()

    bindTableView()

//    client.connectedDevice
//      .asObservable()
//      .map {
//        $0 == nil ? true : false
//      }
//      .bind(to: connectedStatusView.rx.isHidden)
//      .disposed(by: disposeBag)

    client.connectedDevice
      .asObservable()
      .map { bleModel in
        guard let peripheral = bleModel?.peripheral, let name = peripheral.name else {
          return "N/A"
        }
        return name
      }
      .bind(to: connectedLabel.rx.text)
      .disposed(by: disposeBag)

//    client.connectedDevice
//      .asObservable()
//      .map {
//        $0 == nil ? true : false
//      }
//      .bind(to: wifiScanView.rx.isHidden)
//      .disposed(by: disposeBag)

//    selectedNetwork
//      .asObservable()
//      .map {
//        $0 == nil ? true : false
//      }
//      .bind(to: networkConfigView.rx.isHidden)
//      .disposed(by: disposeBag)

    networkKey
      .asObservable()
      .map { key in
        return key.count > 0
      }
      .bind(to: configureNetworkButton.rx.isEnabled)
      .disposed(by: disposeBag)

    networkKeyTextField.rx.controlEvent(.editingChanged)
      .map { [unowned self] _ in
        return self.networkKeyTextField.text ?? ""
      }
      .bind(to: networkKey)
      .disposed(by: disposeBag)
  }

  private func bindTableView() {
    let dataSource = RxTableViewSectionedReloadDataSource<BLESectionType>()

    dataSource.configureCell = {(dataSource, tableView, indexPath, row) -> UITableViewCell in
      let sectionSource = dataSource[indexPath]
      if let viewModel = sectionSource.viewModel as? ArcusBLEViewModel,
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BLETableViewCell {
        cell.titleLabel.text = viewModel.name

        return cell
      } else if let viewModel = sectionSource.viewModel as? WiFiScanItem,
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell") as? BLEWifiNetworkTableViewCell {
        cell.ssidLabel.text = viewModel.ssid
        cell.securityLabel.text = viewModel.security
        cell.channelLabel.text = String(describing: viewModel.channel)
        cell.strengthImageView.image = WiFiScanItem.imageForSignalStrength(viewModel.signal,
                                                                           security: viewModel.security)

        return cell
      }
      return UITableViewCell()
    }

    tableDataSource()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
      switch indexPath.section {
      case 0:
        let bleModel = self.client.discoveredDevices.value[indexPath.row]
        _ = self.client.connect(bleModel)
//        self.client.stopScan()
      case 1:
        self.selectedNetwork.value = self.client.availableNetworks.value[indexPath.row]
        break
      default:
        break
      }
    }).disposed(by: disposeBag)
  }

  // MARK: - IBActions

  @IBAction func doneButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func scanButtonPressed(_ sender: AnyObject) {
    _ = client.discoverAvailableNetworks()
  }

  @IBAction func configureNetworkPressed(_ sender: AnyObject) {
    guard let network = selectedNetwork.value, let key = networkKeyTextField.text else { return }
    client.configureWifiNetwork(network, networkKey: key)
      .do(onNext: { _ in
        DDLogInfo("Configuration Successful")
      }, onError: { _ in
        DDLogInfo("Configuration Failed")
      })
      .flatMap { _ in
        return self.client.getDeviceSerial()
      }
      .do(onNext: { serial in
        DDLogInfo("Camera Serial: \(serial)")
      })
      .asObservable()
      .flatMap { _ in
        return Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
      }
      .flatMap { _ in
        return self.client.getDeviceConfigStatus()
      }
      .map { status in
        return status.description()
      }
      .do(onNext: { status in
        DDLogInfo("Camera Config Status: \(status)")
      })
      .catchErrorJustReturn(nil)
      .bind(to: statusLabel.rx.text)
      .disposed(by: disposeBag)
  }
}

class BLETableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
}

class BLEWifiNetworkTableViewCell: UITableViewCell {
  @IBOutlet weak var ssidLabel: UILabel!
  @IBOutlet weak var securityLabel: UILabel!
  @IBOutlet weak var channelLabel: UILabel!
  @IBOutlet weak var strengthImageView: UIImageView!
}

typealias BLEClient = ArcusBLEAvailability & ArcusBLEScannable & ArcusBLEConnectable
  & ArcusBLEConfigurable & ArcusBLEWiFiConfigurable

protocol BLEListPresenter {
  var client: BLEClient { get set }
  var disposeBag: DisposeBag { get set }

  func tableDataSource() -> Observable<[BLESectionType]>
}

extension BLEListPresenter {
  func tableDataSource() -> Observable<[BLESectionType]> {
    let deviceObservable: Observable<[Row]> = client.discoveredDevices
      .asObservable()
      .map { devices in
        return devices.map {
          return Row(viewModel: $0 as AnyObject)
        }
      }

    let networkObservable: Observable<[Row]> = client.availableNetworks
      .asObservable()
      .map { networks in
        return networks.map {
          return Row(viewModel: $0 as AnyObject)
        }
    }

   return Observable<[BLESectionType]>
    .combineLatest(deviceObservable, networkObservable) { devices, networks in
      let sections: [BLESectionType] = [
        BLESectionType(header: "Discovered Devices", items: devices),
        BLESectionType(header: "Available Networks", items: networks)
      ]
      return sections
    }
    .shareReplay(1)
  }
}
