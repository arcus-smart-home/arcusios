//
//  BLEPairingAvailableNetworksViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/17/18.
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
import RxSwift
import RxSwiftExt
import RxCocoa
import RxDataSources
import CoreBluetooth

struct BLEWiFiSearchingStrings {
  static let searchingTitle: String = "Searching"
  static let searchingDescription: String = "The device is looking for available Wi-Fi Networks."
}

class BLEPairingAvailableNetworksViewController: UIViewController, ArcusBLEAvailableNetworksPresenter,
  HubBLEInstructionable,
  StoryboardCreatable {

  static var storyboardName: String = DeviceBLEPairingStoryboardName
  static var storyboardIdentifier: String = "BLEPairingAvailableNetworksViewController"

  @IBOutlet weak var whichNetworkLabel: UILabel!
  @IBOutlet weak var searchingForNetworks: UIView!
  @IBOutlet weak var dontSeeYourNetwork: UIView!
  @IBOutlet weak var tableView: UITableView!

  // MARK: - PairingStepsPresenter
  var step: ArcusPairingStepViewModel?
  fileprivate var presenter: BLEPairingPresenterProtocol?

  weak var customStepDelegate: PairingStepsCustomStepDelegate?

  // MARK: - ArcusBLEPairingClient
  var bleClient: (ArcusBLEAvailability & ArcusBLEConnectable & ArcusBLEConfigurable & ArcusBLEWiFiConfigurable & ArcusBLEPairable)!
  var disposeBag: DisposeBag = DisposeBag()

  var backSubjectDisposeBag: DisposeBag = DisposeBag()

  // MARK: - ArcusBLEAvailableNetworksPresenter
  var currentDeviceNetwork: Variable<WiFiScanItem?> = Variable(nil)
  var otherWifiNetworks: Variable<[WiFiScanItem]> = Variable([])
  var manualConfigSelected: Variable<Bool> = Variable(false)

  // MARK - Constructor

  static func fromPairingStep(step: ArcusPairingStepViewModel,
                              presenter: BLEPairingPresenterProtocol) -> BLEPairingAvailableNetworksViewController? {
    let storyboard = UIStoryboard(name: "BLEDevicePairing", bundle: nil)
    if let vc = storyboard.instantiateViewController(withIdentifier: "BLEPairingAvailableNetworksViewController")
      as? BLEPairingAvailableNetworksViewController {
      vc.step = step
      vc.presenter = presenter

      if let step = step as? CustomPairingStepViewModel,
        let client = step.config
          as? (ArcusBLEAvailability & ArcusBLEConnectable & ArcusBLEConfigurable & ArcusBLEWiFiConfigurable & ArcusBLEPairable) {
        vc.bleClient = client
      }

      return vc
    }
    return nil
  }

  // MARK - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    if let presenterDelegate = presenter?.customStepDelegate {
      customStepDelegate = presenterDelegate
    }

    if let deviceShortName = customStepDelegate?.deviceShortName {
      whichNetworkLabel.text =
        whichNetworkLabel.text?.replacingOccurrences(of: "<ShortName>",
                                                     with: deviceShortName)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    bleClient.availableNetworks.value = []
    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    disposeBag = DisposeBag()
  }

  // MARK - Prepare For Segue

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let deviceShortName = customStepDelegate?.deviceShortName,
      let navigationController = segue.destination as? UINavigationController,
      let dontSeeNetworkViewController = navigationController
        .viewControllers.first as? BLEPairingDontSeeNetworkViewController else {
        return
    }
    dontSeeNetworkViewController.shortName = deviceShortName
    dontSeeNetworkViewController.ipcdDeviceType = bleClient.ipcdDeviceType
  }

  // MARK: UI Configuration

  func configureBindings() {
    disposeBag = DisposeBag()

    bindDontSeeYourWifiNetwork()

    bindTableView()

    bindConnectedDevice()

    bindPagingDelegate()
  }

  func bindConnectedDevice() {
    guard bleClient.connectedDevice.value != nil else { return }

    bleClient.connectedDevice
      .asObservable()
      .delay(1.0, scheduler: MainScheduler.asyncInstance)
      .filter { bleDevice in
        return bleDevice == nil
      }
      .take(1)
      .subscribe(onNext: { [weak customStepDelegate] _ in
        let segue = PairingStepSegues.segueToBLEConnectionLostErrorPopOver.rawValue
        customStepDelegate?.showPopupWithSegue(segue)
      })
      .disposed(by: disposeBag)
  }

  private func bindDontSeeYourWifiNetwork() {
    dontSeeYourNetwork.isHidden = true

    Observable<Int>
      .timer(30, scheduler: MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] _ in
        self?.dontSeeYourNetwork.isHidden = false
      })
      .disposed(by: disposeBag)
  }

  private func bindPagingDelegate() {
    guard let delegate = customStepDelegate else { return }

    bleClient.isSearching
      .asObservable()
      .inverse()
      .bind(to: searchingForNetworks.rx.isHidden)
      .disposed(by: disposeBag)

    manualConfigSelected
      .asObservable()
      .bind(to: delegate.pagingEnabled)
      .disposed(by: disposeBag)

    bleClient.selectedNetwork
      .asObservable()
      .map { [unowned self] wifiNetwork in
        return wifiNetwork != nil && !self.bleClient.isSearching.value
      }
      .bind(to: delegate.pagingEnabled)
      .disposed(by: disposeBag)

    bleClient.isSearching
      .asObservable()
      .map { [unowned self] isSearching in
        return self.bleClient.selectedNetwork.value != nil && !isSearching
      }
      .bind(to: delegate.pagingEnabled)
      .disposed(by: disposeBag)

    delegate.stepsMovedBackSubject
      .asObservable()
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [unowned self, weak delegate] index in
        guard let step = self.step as? CustomPairingStepViewModel,
          step.order == index || step.order == index - 1 else {
            return
        }

        // Reset current state.
        if step.order == index {
          self.disposeBag = DisposeBag()
          self.bleClient.availableNetworks.value = []

          // If moving backwards as a result of a disconnected device, then re-enable paging.
          if self.bleClient.connectedDevice.value == nil {
            delegate?.pagingEnabled.value = true
          }
        }
        self.bleClient.selectedNetwork.value = nil
      })
      .disposed(by: backSubjectDisposeBag)

    bleClient.isBLEAvailable()
      .shareReplay(1)
      .filter { available in
        return available == false
      }
      .subscribe(onNext: { [weak delegate] _ in
        let segueIdentifier = PairingStepSegues.segueToBLENotEnabledErrorPopOver.rawValue
        delegate?.showPopupWithSegue(segueIdentifier)
      })
      .disposed(by: disposeBag)
  }

  private func bindTableView() {
    let dataSource = RxTableViewSectionedReloadDataSource<BLESectionType>()

    dataSource.configureCell = {(dataSource, tableView, indexPath, row) -> UITableViewCell in
      let sectionSource = dataSource[indexPath]

      if let model = sectionSource.viewModel as? WiFiScanItem,
        let cell = tableView.dequeueReusableCell(withIdentifier: "wifiCell") as? BLEWifiScanTableViewCell {
        cell.nameLabel.text = model.ssid
        cell.wifiSignalIcon.image = WiFiScanItem.imageForSignalStrength(model.signal,
                                                                        security: model.security)

        return cell
      } else if let manualString = sectionSource.viewModel as? String,
        let cell = tableView.dequeueReusableCell(withIdentifier: "manualCell") as? BLEManualConfigTableViewCell {
        cell.configLabel.text = manualString

        return cell
      }
      return UITableViewCell()
    }

    wifiNetworksDataSource(bleClient)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
      self.manualConfigSelected.value = false
      self.bleClient.selectedNetwork.value = nil

      switch indexPath.section {
      case 0:
        if let currentNetwork = self.currentDeviceNetwork.value {
          self.bleClient.selectedNetwork.value = currentNetwork
        }
      case 1:
        self.bleClient.selectedNetwork.value = self.otherWifiNetworks.value[indexPath.row]
      case 2:
        self.manualConfigSelected.value = true
      default:
        break
      }
    }).disposed(by: disposeBag)

    bleClient.availableNetworks
      .asObservable()
      .filter { [unowned self] networks in
        guard let name = self.getCurrentNetworkName(), name.count > 0 else {
          return false
        }
        return true
      }.subscribe(onNext: { [unowned self] _ in
        if self.tableView.numberOfRows(inSection: 0) > 0 {
          let index = IndexPath(row: 0, section: 0)
          self.tableView.selectRow(at: index, animated: true, scrollPosition: .none)
          self.networkCellSelected(index)
        }
      })
      .disposed(by: disposeBag)
  }

  // MARK - ArcusBLEAvailableNetworksPresenter

  func networkCellSelected(_ indexPath: IndexPath) {
    manualConfigSelected.value = false
    bleClient.selectedNetwork.value = nil

    switch indexPath.section {
    case 0:
      if let currentNetwork = currentDeviceNetwork.value {
        bleClient.selectedNetwork.value = currentNetwork
      }
    case 1:
      bleClient.selectedNetwork.value = otherWifiNetworks.value[indexPath.row]
    case 2:
      manualConfigSelected.value = true
    default:
      break
    }
  }
}

protocol GenericRow {
  var viewModel: AnyObject { get }
}

struct Row: GenericRow {
  var viewModel: AnyObject

  init(viewModel: AnyObject) {
    self.viewModel = viewModel
  }
}

struct BLESectionType: SectionModelType {
  typealias Item = Row

  var header: String
  var items: [Item]

  init(header: String = "", items: [Item]) {
    self.header = header
    self.items = items
  }

  init(original: BLESectionType, items: [Item]) {
    self = original
    self.items = items
  }
}
