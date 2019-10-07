//
//  DashboardCardFactory.swift
//  i2app
//
//  Created by Arcus Team on 2/11/17.
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

import Cornea

class DashboardCardFactory {

  // MARK: Cell Creation

  static func createCell(tableView: UITableView, viewModel: DashboardCardViewModel) -> UITableViewCell {
    var cell = UITableViewCell()

    if viewModel.isEnabled {
      switch viewModel.type {
      case .Favorites:
        var isPremium = false
        if let premium = RxCornea.shared.settings?.isPremiumAccount() {
          isPremium = premium
        }

        if let viewModel = viewModel as? DashboardFavoriteViewModel {
          cell = DashboardCardFactory
            .createDashboardFavoritesCell(tableView,
                                          premiumIndicator: isPremium,
                                          favoritesCount: viewModel.currentFavorites.count)
        }
      case .History:
        if let viewModel = viewModel as? DashboardHistoryViewModel {
          cell = DashboardCardFactory.createDashboardHistoryCell(tableView,
                                                                 viewModel: viewModel)
        }
      case .LightsSwitches:
        if let viewModel = viewModel as? DashboardLightsSwitchesViewModel {
          cell = DashboardCardFactory.createLightsSwitchesCell(tableView,
                                                               viewModel: viewModel)
        }
      case .Climate:
        if let viewModel = viewModel as? DashboardClimateViewModel {
          cell = DashboardCardFactory.createClimateCell(tableView,
                                                        viewModel: viewModel)
        }
      case .DoorsLocks:
        if let viewModel = viewModel as? DashboardDoorsLocksViewModel {
          cell = DashboardCardFactory.createDoorsLocksCell(tableView,
                                                           viewModel: viewModel)
        }
      case .Cameras:
        if let viewModel = viewModel as? DashboardCamerasViewModel {
          cell = DashboardCardFactory.createCamerasCell(tableView,
                                                        viewModel: viewModel)
        }
      case .Water:
        if let viewModel = viewModel as? DashboardWaterViewModel {
          cell = DashboardCardFactory.createWaterCell(tableView,
                                                      viewModel: viewModel)
        }
      case .Care:
        if let viewModel = viewModel as? DashboardCareViewModel {
          cell = DashboardCardFactory.createCareCell(tableView,
                                                     viewModel: viewModel)
        }
      case .LawnGarden:
        if let viewModel = viewModel as? DashboardLawnGardenViewModel {
          cell = DashboardCardFactory.createLawnGardenCell(tableView,
                                                           viewModel: viewModel)
        }
      case .Alarms:
        if let viewModel = viewModel as? DashboardAlarmsViewModel {
          cell = DashboardCardFactory.createAlarmsCell(tableView,
                                                       viewModel: viewModel)
        }
      case .HomeFamily:
        if let viewModel = viewModel as? DashboardHomeFamilyViewModel {
          cell = DashboardCardFactory.createHomeFamilyCell(tableView,
                                                           viewModel: viewModel)
        }
      }
    } else {
      cell = DashboardCardFactory.createLearnMoreCell(tableView,
                                                      title: viewModel.title, imageName: viewModel.imageName)
    }

    // Extend the cell separators to take the whole width.
    cell.preservesSuperviewLayoutMargins = false
    cell.separatorInset = UIEdgeInsets.zero
    cell.layoutMargins = UIEdgeInsets.zero

    return cell
  }

  static func createDashboardFavoritesCell(_ tableView: UITableView,
                                           premiumIndicator: Bool, favoritesCount: Int) -> UITableViewCell {
    if favoritesCount == 0 {
      if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.historyEmpty)
        as? DashboardServiceCard {
        cell.cardTitle.text = NSLocalizedString("Choose your favorite devices and scenes under "
          + "\"Device Details\" and \"Scenes\" in the left hand navigation.", comment: "")
        cell.backgroundColor = UIColor.clear

        return cell
      }
    } else {
      if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.favorite)
        as? DashboardFavoriteCard {
        cell.collectionView.reloadData()
        cell.backgroundColor = UIColor.clear

        return cell
      }
    }

    return UITableViewCell()
  }

  static func createDashboardHistoryCell(_ tableView: UITableView,
                                         viewModel: DashboardHistoryViewModel) -> UITableViewCell {

    let entryCount = viewModel.historyEntries.count

    if let cell = tableView
      .dequeueReusableCell(withIdentifier: DashboardCardIdentifier.history) as? DashboardHistoryCard,
      entryCount > 0 {

      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      if entryCount > 0 {
        cell.timeOne.text = viewModel.historyEntries[0].time
        cell.entryOne.text = viewModel.historyEntries[0].entry
        cell.deviceOne.text = viewModel.historyEntries[0].name
        cell.heightCollapseTwo.priority = DashboardConstants.constraintPriorityHigh
        cell.heightCollapseThree.priority = DashboardConstants.constraintPriorityHigh
      }

      if entryCount > 1 {
        cell.timeTwo.text = viewModel.historyEntries[1].time
        cell.entryTwo.text = viewModel.historyEntries[1].entry
        cell.deviceTwo.text = viewModel.historyEntries[1].name
        cell.heightCollapseTwo.priority = DashboardConstants.constraintPriorityLow
        cell.heightCollapseThree.priority = DashboardConstants.constraintPriorityHigh
      }

      if entryCount > 2 {
        cell.timeThree.text = viewModel.historyEntries[2].time
        cell.entryThree.text = viewModel.historyEntries[2].entry
        cell.deviceThree.text = viewModel.historyEntries[2].name
        cell.heightCollapseTwo.priority = DashboardConstants.constraintPriorityLow
        cell.heightCollapseThree.priority = DashboardConstants.constraintPriorityLow
      }
      cell.backgroundColor = UIColor.clear
      return cell
    }

    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.historyEmpty)
      as? DashboardHistoryCard {
      cell.cardTitle.text = NSLocalizedString(
        "You have no items in your history.",
        comment: "")
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createLightsSwitchesCell(_ tableView: UITableView,
                                       viewModel: DashboardLightsSwitchesViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.lightsSwitches)
      as? DashboardLightsSwitchesCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      cell.lightCount.text = String(viewModel.lightsOnCount)
      cell.switchCount.text = String(viewModel.switchesOnCount)
      cell.dimmerCount.text = String(viewModel.dimmersOnCount)

      if viewModel.lightsOnCount > 0 {
        cell.lightsContainerWidth.priority = DashboardConstants.constraintPriorityLow
      } else {
        cell.lightsContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      }

      if viewModel.switchesOnCount > 0 {
        cell.switchesContainerWidth.priority = DashboardConstants.constraintPriorityLow
      } else {
        cell.switchesContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      }

      if viewModel.dimmersOnCount > 0 {
        cell.dimmersContainerWidth.priority = DashboardConstants.constraintPriorityLow
      } else {
        cell.dimmersContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      }

      cell.backgroundColor = UIColor.clear

      return cell
    }

    return UITableViewCell()
  }

  static func createClimateCell(_ tableView: UITableView,
                                viewModel: DashboardClimateViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.climate)
      as? DashboardClimateCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      // Add a space to the range string
      var range = ""
      if !viewModel.temperatureRange.isEmpty {
        range = " " + viewModel.temperatureRange
      }

      cell.temperature.attributedText = stringWithUpperText(viewModel.temperature,
                                                            upperText: range,
                                                            extraSmall: false,
                                                            invert: false,
                                                            grayedOut: true)
      cell.humidity.attributedText = stringWithUpperText(viewModel.humidity, upperText: "%", extraSmall: true)

      // Shrink the containers with empty data
      cell.humidityContainerWidth.priority = viewModel.humidity.isEmpty
        ? DashboardConstants.constraintPriorityHigh : DashboardConstants.constraintPriorityLow
      cell.temperatureContainerWidth.priority = viewModel.temperature.isEmpty
        ? DashboardConstants.constraintPriorityHigh : DashboardConstants.constraintPriorityLow
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createDoorsLocksCell(_ tableView: UITableView,
                                   viewModel: DashboardDoorsLocksViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.doorsLocks)
      as? DashboardDoorsLocksCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      cell.lockLabel.text = "\(viewModel.openedLockCount)"
      cell.doorLabel.text = "\(viewModel.openedDoorCount)"
      cell.garageLabel.text = "\(viewModel.openedGarageCount)"

      cell.garageContainerWidth.priority = viewModel.openedGarageCount > 0
        ? DashboardConstants.constraintPriorityLow : DashboardConstants.constraintPriorityHigh
      cell.locksContainerWidth.priority = viewModel.openedLockCount > 0
        ? DashboardConstants.constraintPriorityLow : DashboardConstants.constraintPriorityHigh
      cell.doorsContainerWidth.priority = viewModel.openedDoorCount > 0
        ? DashboardConstants.constraintPriorityLow : DashboardConstants.constraintPriorityHigh
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createLawnGardenCell(_ tableView: UITableView,
                                   viewModel: DashboardLawnGardenViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.lawnGarden)
      as? DashboardLawnGardenCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      if viewModel.onIndicator {
        cell.onContainerWidth.priority = DashboardConstants.constraintPriorityLow
        cell.infoText.text = ""
        if viewModel.activeCount > 1 {
          cell.infoText.text = "\(viewModel.activeCount)"
        }
      } else {
        cell.onContainerWidth.priority = DashboardConstants.constraintPriorityHigh
        let time = " " + viewModel.scheduleTime
        cell.infoText.attributedText = stringWithUpperText(viewModel.scheduleDay, upperText: time)
      }
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createCareCell(_ tableView: UITableView,
                             viewModel: DashboardCareViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.care)
      as? DashboardCareCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {

        cell.cardImage.image = cardImage
      }

      cell.backgroundColor = viewModel.backgroundColor

      // Add space before AM/PM
      var amPM = ""
      if !viewModel.timePeriod.isEmpty {
        amPM = " " + viewModel.timePeriod
      }

      cell.dateTime.attributedText = stringWithUpperText(viewModel.relativeTime, upperText: amPM)

      if viewModel.status.isEmpty {
        cell.onContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      } else {
        cell.onLabel.text = viewModel.status
        cell.onContainerWidth.priority = DashboardConstants.constraintPriorityLow
      }

      return cell
    }

    return UITableViewCell()
  }

  static func createHomeFamilyCell(_ tableView: UITableView,
                                   viewModel: DashboardHomeFamilyViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
      withIdentifier: DashboardCardIdentifier.homeFamily) as? DashboardHomeFamilyCard {

      cell.cardTitle.text = viewModel.title

      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      if viewModel.firstImage != nil {
        cell.firstPerson.isHidden = false
        cell.firstPerson.setImage(viewModel.firstImage, for: UIControlState())
        cell.firstImageContainerWidth.priority = DashboardConstants.constraintPriorityLow
      } else {
        cell.firstPerson.isHidden = true
        cell.firstImageContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      }

      if viewModel.secondImage != nil {
        cell.secondPerson.isHidden = false
        cell.secondPerson.setImage(viewModel.secondImage, for: UIControlState())
        cell.secondImageContainerWidth.priority = DashboardConstants.constraintPriorityLow
      } else {
        cell.secondPerson.isHidden = true
        cell.secondImageContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      }

      if viewModel.additionalCount.isEmpty {
        cell.countContainerWidth.priority = DashboardConstants.constraintPriorityHigh
      } else {
        cell.countContainerWidth.priority = DashboardConstants.constraintPriorityLow

        // Only show the plus before the count when there people at home
        if viewModel.firstImage == nil && viewModel.secondImage == nil {
          cell.additionalCount.text =  viewModel.additionalCount
        } else {
          cell.additionalCount.attributedText =
            stringWithUpperText(viewModel.additionalCount, upperText: "+ ", extraSmall: false, invert: true)
        }
      }
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createCamerasCell(_ tableView: UITableView,
                                viewModel: DashboardCamerasViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.cameras)
      as? DashboardCamerasCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      var amPM = ""
      if !viewModel.timePeriod.isEmpty {
        amPM = " " + viewModel.timePeriod
      }

      cell.camerasLabel.attributedText = stringWithUpperText(viewModel.relativeTime, upperText: amPM)
      if viewModel.relativeTime == "" {
        cell.camerasIcon.isHidden = true
      } else {
        cell.camerasIcon.isHidden = false
      }
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  static func createAlarmsCell(_ tableView: UITableView,
                               viewModel: DashboardAlarmsViewModel) -> UITableViewCell {
    if let cell =
      tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.alarms) as? DashboardAlarmsCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      cell.backgroundColor = viewModel.backgroundColor
      cell.infoText.text = viewModel.status

      if viewModel.hasSmallText {
        cell.infoText.font = UIFont(name: "AvenirNext-Medium", size: 12)
      } else {
        cell.infoText.font = UIFont(name: "AvenirNext-Regular", size: 18)
      }

      if viewModel.proIndicator {
        cell.proIndicator.isHidden = false
      } else {
        cell.proIndicator.isHidden = true
      }

      return cell
    }

    return UITableViewCell()
  }

  static func createWaterCell(_ tableView: UITableView,
                              viewModel: DashboardWaterViewModel) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.water)
      as? DashboardWaterCard {
      cell.cardTitle.text = viewModel.title
      if let cardImage = UIImage(named: viewModel.imageName) {
        cell.cardImage.image = cardImage
      }

      var target = ""
      if !viewModel.target.isEmpty {
        target = " " + viewModel.target
      }

      if viewModel.waterInfo.isEmpty && !viewModel.saltPercentage.isEmpty {
        cell.waterInfo.attributedText = stringWithUpperText(viewModel.saltPercentage,
                                                            upperText: "%",
                                                            extraSmall: true)
      } else if !viewModel.waterInfo.isEmpty {
        cell.waterInfo.attributedText = stringWithUpperText(viewModel.waterInfo, upperText: target)
      } else {
        cell.waterInfo.text = ""
      }

      cell.activeImage.isHidden = !viewModel.onIndicator
      cell.backgroundColor = UIColor.clear

      return cell
    }

    return UITableViewCell()
  }

  static func createLearnMoreCell(_ tableView: UITableView,
                                  title: String, imageName: String) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: DashboardCardIdentifier.learnMore)
      as? DashboardLearnMoreCard {

      cell.cardTitle.text = title

      if let image = UIImage(named:imageName) {
        cell.cardImage.image = image
      }
      cell.backgroundColor = UIColor.clear
      return cell
    }

    return UITableViewCell()
  }

  private static func stringWithUpperText(_ mainText: String,
                                          upperText: String,
                                          extraSmall: Bool = false,
                                          invert: Bool = false,
                                          grayedOut: Bool = false) -> NSAttributedString {
    var upperTextSize: CGFloat = 12.0
    var upperTextOffset: CGFloat = 4.0
    if extraSmall {
      upperTextSize = 10.0
      upperTextOffset = 5.0
    }

    var alpha: CGFloat = 1.0
    if grayedOut {
      alpha = 0.80
    }

    let upperTextAttributes: [String: AnyObject] = [
      NSFontAttributeName: UIFont(name: "Avenir Next", size: upperTextSize)!,
      NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: alpha),
      NSBaselineOffsetAttributeName: upperTextOffset as AnyObject
    ]

    let mainText = NSMutableAttributedString(string: mainText)
    let upperText = NSMutableAttributedString(string: upperText, attributes: upperTextAttributes)

    if invert {
      upperText.append(mainText)
      return upperText
    } else {
      mainText.append(upperText)
      return mainText
    }
  }

}
