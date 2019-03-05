//
//  WeatherRadioStationViewController.swift
//  i2app
//
//  Created by Arcus Team on 4/4/18.
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
import RxSwift

class WeatherRadioStationViewController: UIViewController {
  
  /**
   Required by PairingCustomizationStepPresenter & WeatherRadioStationPresenter
   */
  var disposeBag = DisposeBag()
  
  /**
   Required by PairingCustomizationStepPresenter & WeatherRadioStationPresenter
   */
  var deviceAddress = ""
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  @IBOutlet weak var actionButton: UIButton!
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var pairingCustomizationViewModel = PairingCustomizationViewModel()
  
  /**
   Required by PairingCustomizationStepPresenter
   */
  var stepIndex = 0
  
  /**
   Required by WeatherRadioStationPresenter
   */
  var weatherStations = [WeatherRadioStationViewModel]()
  
  fileprivate var isTableExpanded = false
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBOutlet weak var infoLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var weakRadioSignalView: UIView!
  
  @IBOutlet weak var weakRadioSignalText: UILabel!
  
  let tableViewContentSizeKey = "contentSize"
  
  static func create() -> WeatherRadioStationViewController? {
    let storyboard = UIStoryboard(name: "WeatherRadioStation", bundle: nil)
    let id = "WeatherRadioStationViewController"
    guard let viewController = storyboard.instantiateViewController(withIdentifier: id)
      as? WeatherRadioStationViewController else {
        return nil
    }
    
    return viewController
  }
  
  deinit {
    tableView.removeObserver(self, forKeyPath: tableViewContentSizeKey)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    weatherRadioStationObserveChanges()
    weatherRadioStationFetchData()
  }
  
  override func observeValue(forKeyPath keyPath: String?,
                             of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?,
                             context: UnsafeMutableRawPointer?) {
    if keyPath == tableViewContentSizeKey {
      updateTableViewHeight()
    }
  }
  
  @IBAction func actionButtonPressed(_ sender: Any) {
    weatherRadioStationSelectStation(atIndex: weatherRadioStationIndexOfSelectedStation())
    addCustomization(PairingCustomizationStepType.weatherRadioStation.rawValue)
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingCustomizeWeatherRadioStation)
    
    advanceToNextStep()
  }
  
  @IBAction func skipButtonPressed(_ sender: Any) {
    advanceToNextStep()
  }
  
  @IBAction func rescanButtonPressed(_ sender: Any) {
    UIView.animate(withDuration: 0.3, animations: {
      self.weakRadioSignalView.alpha = 0
    }) { (_) in
      self.weakRadioSignalView.isHidden = true
      self.weatherRadioStationFetchData()
    }
  }
  
  @IBAction func moreStationsButtonPressed(_ sender: Any) {
    isTableExpanded = true
    tableView.tableFooterView = UIView()
    tableView.reloadData()
  }
  
  @IBAction func playButtonPressed(_ sender: Any) {
    guard let playButton = sender as? UIButton,
    playButton.tag < weatherStations.count else {
      return
    }
    
    let station = weatherStations[playButton.tag]
    
    if station.isPlaying {
      stopPlayingStation()
    } else {
      playStation(atIndex: playButton.tag)
    }
  }
  
  private func configureViews() {
    addScleraBackButton()
    addScleraStyleToNavigationTitle()
    updateActionButtonText()
    
    tableView.addObserver(self,
                          forKeyPath: tableViewContentSizeKey,
                          options: .new,
                          context: nil)
    
    let gesture = UITapGestureRecognizer(target: self,
                                         action: #selector(openCoverateMap))
    weakRadioSignalText.addGestureRecognizer(gesture)
    
    // Set platform fields if avaiable
    if let header = currentStepViewModel()?.header {
      navigationItem.title = header
    }
    if let title = currentStepViewModel()?.title {
      titleLabel.text = title
    }
    if let info = currentStepViewModel()?.info {
      infoLabel.text = info
    }
    if let descriptionParagraphs = currentStepViewModel()?.description, descriptionParagraphs.count > 0 {
      descriptionLabel.text = descriptionParagraphs.joined(separator: "\n\n")
    }
  }
  
  @objc private func openCoverateMap() {
     UIApplication.shared.openURL(NSURL.NoaaMaps)
  }
  
  fileprivate func displayWeakRadioSignalView() {
    weakRadioSignalView.alpha = 0
    weakRadioSignalView.isHidden = false
    
    UIView.animate(withDuration: 0.3) {
      self.weakRadioSignalView.alpha = 1
    }
  }
  
  fileprivate func advanceToNextStep() {
    if isLastStep() {
      addCustomization(PairingCustomizationStepType.complete.rawValue)
      dismiss(animated: true, completion: nil)
    } else {
      if let nextStep = nextStepViewController() {
        navigationController?.pushViewController(nextStep, animated: true)
      }
    }
  }
  
  fileprivate func updateTableViewHeight() {
    guard tableViewHeight.constant != tableView.contentSize.height else {
      return
    }
    
    tableViewHeight.constant = tableView.contentSize.height
  }
  
  fileprivate func updateViews() {
    tableView.isHidden = weatherStations.count < 1
    tableView.reloadData()
    
    if isTableExpanded {
      tableView.tableFooterView = UIView()
    }
  }
  
}

extension WeatherRadioStationViewController: PairingCustomizationStepPresenter {
  
}

extension WeatherRadioStationViewController: WeatherRadioStationPresenter {
  
  func weatherRadioStationDataUpdated() {
    updateViews()
  }
  
  func weatherRadioStatonWeakSignalFound() {
    displayWeakRadioSignalView()
  }
  
}

extension WeatherRadioStationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if weatherStations.count > 3 &&
      !isTableExpanded &&
      weatherRadioStationIndexOfSelectedStation() < 3 {
      return 3
    }
    
    if weatherStations.count != 0 {
      isTableExpanded = true
    }
    
    return weatherStations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherRadioStationCell")
      as? WeatherRadioStationCell else {
      return UITableViewCell()
    }
    
    let viewModel = weatherStations[indexPath.row]
    let selectedImageName = viewModel.isSelected ? "check_teal_30x30" : "uncheck_30x30"
    let playImageName = viewModel.isPlaying ? "stop_purple_30x30" : "play_purple_30x30"
    
    cell.name.text = viewModel.name
    cell.frequency.text = viewModel.frequency
    cell.selectedImageView.image = UIImage(named: selectedImageName)
    cell.playButton.setImage(UIImage(named: playImageName), for: .normal)
    cell.playButton.tag = indexPath.row
    
    return cell
  }
  
}

extension WeatherRadioStationViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    weatherRadioStationSelectStation(atIndex: indexPath.row)
  }
  
}
