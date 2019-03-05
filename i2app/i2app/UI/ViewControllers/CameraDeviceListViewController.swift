//
//  CameraDeviceListViewController.swift
//  i2app
//
//  Created by Arcus Team on 8/3/17.
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
import AVKit
import CocoaLumberjack

enum CameraCardConstants: CGFloat {
  case active = 316.0
  case recording = 320.0
  case other = 290.0
}

class CameraDeviceListViewController: UIViewController, CameraPlaybackViewController {

  @IBOutlet weak var segmentedControl: ArcusSegmentedControl!
  @IBOutlet weak var tableView: UITableView!

  var presenter: CameraDeviceListPresenterProtocol?
  var popupWindow: PopupSelectionWindow?
  var avPlayerViewController: AVPlayerViewController?
  var avPlayer: AVQueuePlayer?
  var loadingIndicatorTag: Int = NSNotFound
  var playerItemContext: Int = 0

  class func create() -> CameraDeviceListViewController {
    let sb: UIStoryboard = UIStoryboard(name: "CameraCard", bundle:nil)
    let vc = sb.instantiateViewController(withIdentifier: "CameraDeviceListViewController")
      as? CameraDeviceListViewController
    return vc!
  }
  
  deinit {
    removePlayerObservers()
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navBar(withTitle: navigationItem.title, enableBackButton: true)
    tableView.tableFooterView = UIView()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 210.0
    presenter = CameraDeviceListPresenter(delegate: self)
    NotificationCenter.default
      .addObserver(self,
                   selector:#selector(CameraDeviceListViewController.playerDidFinishPlaying(_:)),
                   name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                   object: nil)
  }
  
  @objc fileprivate func playerDidFinishPlaying(_ note: Notification) {
    safelyDismissAVPlayerViewController()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureSegmentedControl(self.tabBarController)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if presenter?.hasSetup == false {
      presenter?.addObservers()
      presenter?.fetchData()
    }
    handleAVPlayersDidClose(withLogging: true)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    presenter?.removeObservers()
    hideLoadingIndicator()
  }
}

// MARK: ArcusTabBarComponent
extension CameraDeviceListViewController: ArcusTabBarComponent {
  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }
}

extension CameraDeviceListViewController: SimpleTableViewGenericPresenterDelegate { }

// MARK: CameraDeviceListPresenterDelegate
extension CameraDeviceListViewController: CameraDeviceListPresenterDelegate {

  func shouldDisplayVideoError(err: Error) {
    hideLoadingIndicator()
    displayGenericErrorMessageWithError(err)
  }

  func updateLayout() {
    DispatchQueue.main.async {
      guard let tableView = self.tableView else {
        return
      }
      tableView.reloadData()
    }
  }

  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    handleNotification(forKeyPath: keyPath, of: object, change: change, context: context)
  }
}

// MARK: UITableViewDataSource
extension CameraDeviceListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let presenter = presenter else {
      DDLogError("major startup error, no presenter")
      return 0
    }
    return presenter.devices.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let presenter = presenter else {
      DDLogError("Fatal Error, no presenter")
      return UITableViewCell()
    }
    guard let camera = presenter.devices[indexPath.row].card else {
      DDLogError("Fatal Error, no view model")
      return UITableViewCell()
    }
    
    switch camera.status {
    case .recording:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as RecordingCameraTableViewCell
      cell.deviceNameLabel.text = camera.title
      cell.eventValueLabel.text = camera.subtitle
      cell.delegate = self
      if let imageData = camera.cameraPreview,
        !imageData.isEmpty,
        let image = UIImage(data: imageData) {
        cell.videoImage.image = image
        cell.cameraIcon.isHidden = true
        cell.previewUnavailableLabel.isHidden = true
      } else {
        cell.videoImage.image = nil
        cell.cameraIcon.isHidden = false
        cell.previewUnavailableLabel.isHidden = false
      }

      return cell
      
    case .active:
      let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as LiveCameraTableViewCell
      cell.deviceNameLabel.text = camera.title
      cell.eventValueLabel.text = camera.subtitle
      cell.recordButtonContainer?.isHidden = !camera.isRecordEnabled
      cell.delegate = self
      if let imageData = camera.cameraPreview,
        !imageData.isEmpty,
        let image = UIImage(data: imageData) {
        cell.videoImage.image = image
        cell.cameraIcon.isHidden = true
        cell.previewUnavailableLabel.isHidden = true
      } else {
        cell.videoImage.image = nil
        cell.cameraIcon.isHidden = false
        cell.previewUnavailableLabel.isHidden = false
      }
      
      return cell

    case .offline:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DisabledCameraCell", for: indexPath) as! AlertCameraTableViewCell
      cell.deviceNameLabel.text = camera.title
      cell.reasonLabel.text = "No Connection"
      return cell
    
    case .hub4g:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DisabledCameraCell", for: indexPath) as! AlertCameraTableViewCell
      cell.deviceNameLabel.text = camera.title
      cell.reasonLabel.text = "Streaming & Recording is disabled on Backup Cellular"
      return cell

    case .firmware:
      let cell = tableView.dequeueReusableCell(withIdentifier: "FirmwareCameraCell", for: indexPath) as! AlertCameraTableViewCell
      cell.deviceNameLabel.text = camera.title
      return cell
    }

  }
}

// MARK: UITableViewDelegate
extension CameraDeviceListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // stream the camera here
    presenter?.playButtonPressed(onRow: indexPath.row)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    var height: CGFloat = 0.0
    
    guard let presenter = presenter,
      let cameraCard = presenter.devices[indexPath.row].card else { return height }
    
    switch cameraCard.status {
    case .offline, .hub4g, .firmware:
      height = CameraCardConstants.other.rawValue
    case .active:
      height = CameraCardConstants.active.rawValue
    case .recording:
      height = CameraCardConstants.recording.rawValue
    }
    return height
  }
}

// MARK: RecordingCameraDeviceCellDelegate

extension CameraDeviceListViewController: RecordingCameraDeviceCellDelegate {

  func recordingButtonPressed(onCell: UITableViewCell) {
    if let index = tableView.indexPath(for: onCell) {
      presenter?.playButtonPressed(onRow: index.row)
    }
  }
}

// MARK: LiveCameraDeviceCellDelegate
extension CameraDeviceListViewController: LiveCameraDeviceCellDelegate {

  func playButtonPressed(onCell: UITableViewCell) {
    if let index = tableView.indexPath(for: onCell) {
      presenter?.playButtonPressed(onRow: index.row)
    }
  }

  func recordButtonPressed(onCell: UITableViewCell) {
    if let index = tableView.indexPath(for: onCell) {
      presenter?.recordButtonPressed(onRow: index.row)
    }
  }
}
