//
//  HaloPlusPickWeatherStationViewController.swift
//  i2app
//
//  Created by Arcus Team on 9/1/16.
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

class HaloPlusPickWeatherStationTableCell: UITableViewCell {

  @IBOutlet weak var titleLabel: ArcusLabel!
  @IBOutlet weak var subtitleLabel: ArcusLabel!
  @IBOutlet weak var selectionButton: ArcusButton!
  @IBOutlet weak var playRadioButton: UIButton!

  @IBAction func selectionButtonPressed(_ sender: UIButton) {
    let vc: HaloPlusPickWeatherStationViewController? =
      self.getParentViewController() as? HaloPlusPickWeatherStationViewController
    if vc != nil {
      vc!.tableView(vc!.tableView,
                    didSelectRowAt: IndexPath(row: sender.tag, section: 0))
    }
  }
}

// used both in Pairing and Device Details/More
class HaloPlusPickWeatherStationViewController: BasePairingViewController,
UITableViewDelegate, UITableViewDataSource {

  var isPairing: Bool = false

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: ArcusHyperLabel!

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nextButton: ArcusButton!
  @IBOutlet weak var skipRadioSetupButton: ArcusButton!
  @IBOutlet weak var rescanButton: ArcusButton!
  @IBOutlet weak var tableToBottomConstraint: NSLayoutConstraint!

  @IBOutlet weak var subtitleLabelHeightConstraint: NSLayoutConstraint!

  var presenter: HaloWeatherRadioPresenter?
  var radioStations: [WeatherRadioStation] = []

  var selectedRadioStationIndex: NSInteger = NSNotFound
  var playingRadioStationIndex: NSInteger = NSNotFound

  let noaaCoverageLinkText: String = "NOAA Weather Radio Coverage"

  @objc class func create(_ device: DeviceModel) -> HaloPlusPickWeatherStationViewController {
    let vc: HaloPlusPickWeatherStationViewController =
      (UIStoryboard(name: "DeviceDetailSettingHalo", bundle: nil)
        .instantiateViewController(withIdentifier: "HaloPlusPickWeatherStationViewController")
        as? HaloPlusPickWeatherStationViewController)!

    vc.deviceModel = device
    vc.isPairing = false
    return vc
  }

  @objc class func createWithDeviceStep(_ step: PairingStep,
                                        device: DeviceModel) -> HaloPlusPickWeatherStationViewController {
    let vc: HaloPlusPickWeatherStationViewController = (UIStoryboard(name: "PairHalo", bundle: nil)
      .instantiateViewController(withIdentifier: "HaloPlusPickWeatherStationViewController")
      as? HaloPlusPickWeatherStationViewController)!

    vc.deviceModel = device
    vc.isPairing = true
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setBackgroundColorToLastNavigateColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)

    self.navBar(withBackButtonAndTitle: "Weather Radio")

    self.presenter = HaloWeatherRadioPresenter(deviceModel: self.deviceModel)
    self.scanForRadioStations()

    self.titleLabel.isHidden = true
    self.subtitleLabel.isHidden = true
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(setPlayButtonState(_:)),
                   name: Model.attributeChangedNotificationName(kAttrWeatherRadioPlayingstate),
                   object: nil)
    NotificationCenter.default
      .addObserver(self,
                   selector: #selector(setSelectedButtonState(_:)),
                   name: Model.attributeChangedNotificationName(kAttrWeatherRadioStationselected),
                   object: nil)

    if self.isPairing == true {
      self.addWhiteOverlay(BackgroupOverlayMiddleLevel)
      self.subtitleLabel.hyperLabelLinkColorDefault = UIColor.black
      self.subtitleLabel.hyperLabelLinkColorHighlighted = UIColor.black
    } else {
      self.subtitleLabel.hyperLabelLinkColorDefault = UIColor.white
      self.subtitleLabel.hyperLabelLinkColorHighlighted = UIColor.white
      self.nextButton.isHidden = true
    }
    self.tableView.isHidden = true

    self.tableView.tableFooterView = UIView()

    if UIDevice.isIPhone5() {
      self.subtitleLabel.text = "Tap the play button to determine which radio" +
        "station is the clearest. You'll hear the radio" +
      "playing through Halo."
    } else {
      self.subtitleLabel.text = "Tap the play button to determine which radio\n" +
        "station is the clearest. You'll hear the radio\n" +
      "playing through Halo."
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    hideGif()
  }

  // MARK: - UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.radioStations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier: String = "cell"
    let cell: HaloPlusPickWeatherStationTableCell? =
      tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        as? HaloPlusPickWeatherStationTableCell

    cell?.backgroundColor = UIColor.clear
    cell?.selectionStyle = .none
    if self.selectedRadioStationIndex == indexPath.row {
      if isPairing {
        cell?.selectionButton.setImage(UIImage(named: "RoleCheckedIcon"), for: UIControlState())
      } else {
        cell?.selectionButton.setImage(UIImage(named: "RoleCheckedIconWhite"), for: UIControlState())
      }
    } else {
      if isPairing {
        cell?.selectionButton.setImage(UIImage(named: "RoleUncheckButton"), for: UIControlState())
      } else {
        cell?.selectionButton.setImage(UIImage(named: "RoleUncheckButtonWhite"), for: UIControlState())
      }
    }
    if self.playingRadioStationIndex == indexPath.row {
      if isPairing {
        cell?.playRadioButton.setImage(UIImage(named: "radioPauseBlack"), for: UIControlState())
      } else {
        cell?.playRadioButton.setImage(UIImage(named: "radioPauseWhite"), for: UIControlState())
      }
    } else {
      if isPairing {
        cell?.playRadioButton.setImage(UIImage(named: "radioPlayBlack"), for: UIControlState())
      } else {
        cell?.playRadioButton.setImage(UIImage(named: "radioPlayWhite"), for: UIControlState())
      }
    }

    cell?.selectionButton.tag = indexPath.row
    let radioStation: WeatherRadioStation? = self.radioStations[indexPath.row]
    if radioStation != nil {
      cell?.titleLabel.text = "STATION " + String(radioStation!.id)
      cell?.subtitleLabel.text = radioStation!.frequency
      cell?.playRadioButton.tag = indexPath.row
    }
    self.setPlayRadioStationButtonAction(cell!)

    return cell!
  }

  // MARK: - UITableViewDelegate
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.isIPhone5() {
      return 60
    }
    return 70
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    if let cell = self.tableView.cellForRow(at: indexPath) as? HaloPlusPickWeatherStationTableCell {
      if cell.selectionButton.isSelected == false {
        let radioStation: WeatherRadioStation? = self.radioStations[indexPath.row]
        if radioStation != nil {
          self.presenter?.setDefaultRadioStation(radioStation!.id, completionBlock: { success in
            DispatchQueue.main.async {
              if success == true {
                self.selectedRadioStationIndex = indexPath.row
                self.tableView.reloadData()
              } else {
                self.displayGenericErrorMessage()
              }
            }
          })
        }
      }
    }
  }

  func setPlayRadioStationButtonAction(_ cell: HaloPlusPickWeatherStationTableCell) {
    cell.playRadioButton
      .setActionTo(UIControlEvents.touchUpInside,
                   closure: {(button: UIButton) -> Void in
                    if self.playingRadioStationIndex != NSNotFound {
                      let playingIndexPath: IndexPath =
                        IndexPath(row: self.playingRadioStationIndex,
                                  section: 0)
                      var imageName = "radioPlayWhite"
                      if self.isPairing {
                        imageName = "radioPlayBlack"
                      }
                      if let playingCell = self.tableView
                        .cellForRow(at: playingIndexPath) as?
                        HaloPlusPickWeatherStationTableCell {
                        playingCell.playRadioButton.setImage(UIImage(named: imageName),
                                                             for: UIControlState())
                      }
                    }

                    let playingIndexPath = IndexPath(row: button.tag, section: 0)
                    let playingCell = (self.tableView.cellForRow(at: playingIndexPath)
                      as? HaloPlusPickWeatherStationTableCell)!
                    if self.playingRadioStationIndex == button.tag {
                      self.presenter?.stopPlayingStation({ success in
                        DispatchQueue.main.async {
                          if success == true {
                            self.playingRadioStationIndex = NSNotFound
                            playingCell.playRadioButton.setImage(UIImage(named: self.isPairing ?
                              "radioPlayBlack" : "radioPlayWhite"), for: UIControlState())
                          } else {
                            self.displayGenericErrorMessage()
                          }
                        }
                      })
                    } else {
                      let stationId: Int? = Int(self.radioStations[button.tag].id)
                      if stationId != nil {
                        self.presenter?
                          .playStation(stationId!, duration:10,
                                       completionBlock: {
                                        success in
                                        DispatchQueue.main.async {
                                          if success == true {
                                            self.playingRadioStationIndex = button.tag
                                            playingCell.playRadioButton.setImage(
                                              UIImage(named: self.isPairing ?
                                                "radioPauseBlack" : "radioPauseWhite"),
                                              for: UIControlState())
                                          } else {
                                            self.displayGenericErrorMessage()
                                          }
                                        }
                          })
                      }
                    }
      })
  }

  func setPlayButtonState(_ notification: Notification) {
    if !Thread.isMainThread {
      DispatchQueue.main.async {
        self.setPlayButtonState(notification)
      }
      return
    }
    if let state: String = WeatherRadioCapability.getPlayingstateFrom(self.deviceModel!) {
      if state == kEnumWeatherRadioPlayingstateQUIET {
        self.playingRadioStationIndex = NSNotFound
      }
    }
    self.tableView.reloadData()
  }

  func setSelectedButtonState(_ notification: Notification) {
    if !Thread.isMainThread {
      DispatchQueue.main.async {
        self.setSelectedButtonState(notification)
      }
      return
    }
    let selectedStationId: Int32? = WeatherRadioCapability.getStationselectedFrom(self.deviceModel)
      if selectedStationId != nil {
      let selectedStationIndex =
        (self.presenter?.getIndexOfStationWithId(Int(selectedStationId!),
                                                 stations: self.radioStations))!

      if selectedStationIndex != self.selectedRadioStationIndex {
        self.selectedRadioStationIndex = selectedStationIndex
        self.tableView.reloadData()
      }
    }
  }

  @IBAction override func nextButtonPressed(_ sender: Any?) {
    if self.isPairing {
      if self.radioStations.count > 0 {
        let vc: UIViewController  = HaloPlusDisplayAlertsViewController.create()
        self.navigationController?.pushViewController(vc, animated: true)
      }
    } else {
      self.navigationController!.popViewController(animated: true)
    }
  }

  @IBAction func skipRadioSetupButtonPressed(_ sender: AnyObject) {
    DevicePairingManager.sharedInstance().pairingWizard.createNextStepObject(true)
  }

  @IBAction func rescanButtonPressed(_ sender: AnyObject) {
    scanForRadioStations()
  }

  func scanForRadioStations() {
    self.createGif()
    self.presenter!.getRadioStations(self.deviceModel, completionBlock: { radioStations in
      DispatchQueue.main.async {
        self.hideGif()
        self.radioStations = radioStations
        if self.radioStations.count > 0 {
          if let selectedStationId: Int32? = WeatherRadioCapability.getStationselectedFrom(self.deviceModel) {
            self.selectedRadioStationIndex =
              (self.presenter?.getIndexOfStationWithId(Int(selectedStationId!),
                                                       stations: self.radioStations))!
          } else {
            self.selectedRadioStationIndex = 0
            self.presenter?.setDefaultRadioStation(self.radioStations[0].id,
                                                   completionBlock: {_ in})
          }

          self.tableToBottomConstraint.constant = self.nextButton.frame.size.height + 20
          self.subtitleLabelHeightConstraint.constant = 60
          self.tableView.isHidden = false
          self.skipRadioSetupButton.isHidden = true
          self.rescanButton.isHidden = true
          self.titleLabel.text = "Select an Emergency Weather Station"
          if UIDevice.isIPhone5() {
            self.subtitleLabel.text = "Tap the play button to determine which radio" +
            "station is the clearest. You'll hear the radio playing through Halo."
          } else {
            self.subtitleLabel.text = "Tap the play button to determine which radio\n" +
            "station is the clearest. You'll hear the radio\nplaying through Halo."
          }
          if self.isPairing {
            self.nextButton.isHidden = false
          } else {
            self.nextButton.isHidden = true
          }
        } else {
          self.subtitleLabelHeightConstraint.constant = 100
          self.tableView.isHidden = true
          self.rescanButton.isHidden = false
          if self.isPairing {
            self.nextButton.isHidden = true
          }
          self.skipRadioSetupButton.isHidden = !self.isPairing
          self.titleLabel.text = "Weak Radio Signal"

          var string: String
          if UIDevice.isIPhone5() {
            string = "There are no weather radio stations within\nrange of this device. " +
              "Resolve by ensuring the\ndevice is connected to AC power and that\nyour location " +
            "is covered by\nthe NOAA Weather Radio Coverage map."
          } else {
            string = "There are no weather radio stations within range\nof this device. Resolve "
              + "by ensuring the device is\nconnected to AC power and that your location is\ncovered by "
              + "the NOAA Weather Radio Coverage map."
          }
          var color = UIColor.white
          if self.isPairing == true {
            color = UIColor.black
          }
          let attributes =
            [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 14.0)!,
             NSKernAttributeName: 0.0,
             NSForegroundColorAttributeName: color]
              as [String : Any]
          self.subtitleLabel.attributedText = NSAttributedString(string: string, attributes: attributes)
          let handler = {(hyperLabel: ArcusHyperLabel?, substring: String?) -> Void in
            DispatchQueue.main.async {
              UIApplication.shared.open(NSURL.NoaaMaps)
            }
          }
          self.subtitleLabel.setLinksForSubstrings(["NOAA Weather Radio Coverage"], withLinkHandler: handler)
        }
        self.titleLabel.isHidden = false
        self.subtitleLabel.isHidden = false
        self.tableView.reloadData()
      }
    })
  }
}
