//
//  DashboardData.swift
//  i2app
//
//  Created by Arcus Team on 12/14/16.
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

struct DashboardCardTitle {
  static let history: String = NSLocalizedString("History", comment: "")
  static let lightsSwitches: String = NSLocalizedString("Lights & Switches", comment: "")
  static let climate: String = NSLocalizedString("Climate", comment: "")
  static let doorsLocks: String = NSLocalizedString("Doors & Locks", comment: "")
  static let cameras: String = NSLocalizedString("Cameras", comment: "")
  static let lawnGarden: String = NSLocalizedString("Lawn & Garden", comment: "")
  static let care: String = NSLocalizedString("Care", comment: "")
  static let water: String = NSLocalizedString("Water", comment: "")
  static let homeFamily: String = NSLocalizedString("Home & Family", comment: "")
  static let alarms: String = NSLocalizedString("Alarms", comment: "")
}

struct DashboardCardImageName {
  static let history: String = "history_white"
  static let lightsSwitches: String = "Dashboard_lightsswitches"
  static let climate: String = "Dashboard_climate"
  static let doorsLocks: String = "Dashboard_doorslocks"
  static let cameras: String = "Dashboard_camera"
  static let lawnGarden: String = "Dashboard_lawngarden"
  static let care: String = "Dashboard_care"
  static let water: String = "Dashboard_water"
  static let homeFamily: String = "Dashboard_homefamily"
  static let alarms: String = "Dashboard_alarm"
}

enum DashboardCardType: String {
  case Favorites
  case History
  case LightsSwitches
  case Climate
  case DoorsLocks
  case Cameras
  case LawnGarden
  case Care
  case Water
  case HomeFamily
  case Alarms
}

protocol DashboardCardViewModel {
  var title: String {get}
  var imageName: String {get}
  var type: DashboardCardType {get}
  var isEnabled: Bool {get set}

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool
}

class DashboardLightsSwitchesViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.lightsSwitches
  let imageName: String = DashboardCardImageName.lightsSwitches
  let type: DashboardCardType = DashboardCardType.LightsSwitches
  var isEnabled: Bool = false
  var lightsOnCount: Int = 0
  var switchesOnCount: Int = 0
  var dimmersOnCount: Int = 0

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardLightsSwitchesViewModel else {
      return false
    }

    return title == viewModel.title &&
      imageName == viewModel.imageName &&
      type == viewModel.type &&
      isEnabled == viewModel.isEnabled &&
    lightsOnCount == viewModel.lightsOnCount &&
    switchesOnCount == viewModel.switchesOnCount &&
    dimmersOnCount == viewModel.dimmersOnCount
  }
}

class DashboardAlarmsViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.alarms
  let imageName: String = DashboardCardImageName.alarms
  let type: DashboardCardType = DashboardCardType.Alarms
  var isEnabled: Bool = false
  var proIndicator: Bool = false
  var status: String = ""
  var backgroundColor: UIColor = UIColor.clear
  var isOfflineMode: Bool = false
  var hasSmallText: Bool = false

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardAlarmsViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    proIndicator == viewModel.proIndicator &&
    isOfflineMode == viewModel.isOfflineMode &&
    status == viewModel.status &&
    hasSmallText == viewModel.hasSmallText &&
    backgroundColor == viewModel.backgroundColor
  }
}

class DashboardHomeFamilyViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.homeFamily
  let imageName: String = DashboardCardImageName.homeFamily
  let type: DashboardCardType = DashboardCardType.HomeFamily
  var isEnabled: Bool = false
  var firstImage: UIImage?
  var secondImage: UIImage?
  var additionalCount: String = ""

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardHomeFamilyViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    firstImage == viewModel.firstImage &&
    secondImage == viewModel.secondImage &&
    additionalCount == viewModel.additionalCount
  }
}

class DashboardClimateViewModel: DashboardCardViewModel {
  let title = DashboardCardTitle.climate
  let imageName = DashboardCardImageName.climate
  let type = DashboardCardType.Climate
  var isEnabled = false
  var humidity = ""
  var temperature = ""
  var temperatureRange = ""

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardClimateViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    humidity == viewModel.humidity &&
    temperature == viewModel.temperature &&
    temperatureRange == viewModel.temperatureRange
  }
}

class DashboardDoorsLocksViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.doorsLocks
  let imageName: String = DashboardCardImageName.doorsLocks
  let type: DashboardCardType = DashboardCardType.DoorsLocks
  var isEnabled: Bool = false
  var openedDoorCount: Int = 0
  var openedLockCount: Int = 0
  var openedGarageCount: Int = 0

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardDoorsLocksViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    openedDoorCount == viewModel.openedDoorCount &&
    openedLockCount == viewModel.openedLockCount &&
    openedGarageCount == viewModel.openedGarageCount
  }
}

class DashboardCamerasViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.cameras
  let imageName: String = DashboardCardImageName.cameras
  let type: DashboardCardType = DashboardCardType.Cameras
  var isEnabled: Bool = false
  var relativeTime: String = ""
  var timePeriod: String = ""

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardCamerasViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    relativeTime == viewModel.relativeTime &&
    timePeriod == viewModel.timePeriod
  }
}

class DashboardWaterViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.water
  let imageName: String = DashboardCardImageName.water
  let type: DashboardCardType = DashboardCardType.Water
  var isEnabled: Bool = false
  var onIndicator: Bool = false
  var waterInfo: String = ""
  var saltPercentage: String = ""
  var target: String = ""

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardWaterViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    onIndicator == viewModel.onIndicator &&
    waterInfo == viewModel.waterInfo &&
    saltPercentage == viewModel.saltPercentage &&
    target == viewModel.target
  }
}

class DashboardCareViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.care
  let imageName: String = DashboardCardImageName.care
  let type: DashboardCardType = DashboardCardType.Care
  var isEnabled: Bool = false
  var status: String = ""
  var relativeTime: String = ""
  var timePeriod: String = ""
  var backgroundColor: UIColor = UIColor.clear

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardCareViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    status == viewModel.status &&
    relativeTime == viewModel.relativeTime &&
    timePeriod == viewModel.timePeriod &&
    backgroundColor == viewModel.backgroundColor
  }
}

class DashboardLawnGardenViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.lawnGarden
  let imageName: String = DashboardCardImageName.lawnGarden
  let type: DashboardCardType = DashboardCardType.LawnGarden
  var isEnabled: Bool = false
  var onIndicator: Bool = false
  var activeCount: Int = 0
  var scheduleDay: String = ""
  var scheduleTime: String = ""

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardLawnGardenViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    onIndicator == viewModel.onIndicator &&
    activeCount == viewModel.activeCount &&
    scheduleDay == viewModel.scheduleDay &&
    scheduleTime == viewModel.scheduleTime
  }
}

class DashboardFavoriteViewModel: DashboardCardViewModel {
  let title = ""
  let imageName = ""
  let type = DashboardCardType.Favorites
  var isEnabled = true
  var currentFavorites = [DashboardFavoriteItemViewModel]()

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardFavoriteViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    currentFavorites == viewModel.currentFavorites
  }
}

// TODO: FIX ME!
class DashboardFavoriteItemViewModel: Equatable {
  var name: String = ""
  // Not really opposed to UIImage in a view model, but we should prob stick with ImageName in VMs
  var image: UIImage = UIImage()
  // Why is this here?
  var cloudImageView: UIImageView = UIImageView()
  // Why is this here?
  var dataModel: Model = Model(attributes: [:])
}

func == (lhs: DashboardFavoriteItemViewModel, rhs: DashboardFavoriteItemViewModel) -> Bool {
  return lhs.name == rhs.name &&
  lhs.image == rhs.image &&
  lhs.dataModel == rhs.dataModel &&
  lhs.cloudImageView == rhs.cloudImageView
}

class DashboardHistoryViewModel: DashboardCardViewModel {
  let title: String = DashboardCardTitle.history
  let imageName: String = DashboardCardImageName.history
  let type: DashboardCardType = DashboardCardType.History
  var isEnabled: Bool = true
  var historyEntries: [DashboardHistoryItemViewModel] = []

  func isEquals(_ cardViewModel: DashboardCardViewModel) -> Bool {
    guard let viewModel = cardViewModel as? DashboardHistoryViewModel else {
      return false
    }

    return title == viewModel.title &&
    imageName == viewModel.imageName &&
    type == viewModel.type &&
    isEnabled == viewModel.isEnabled &&
    historyEntries == viewModel.historyEntries
  }
}

class DashboardHistoryItemViewModel: Equatable {
  var name: String = ""
  var entry: String = ""
  var time: String = ""
}

func == (lhs: DashboardHistoryItemViewModel, rhs: DashboardHistoryItemViewModel) -> Bool {
  return lhs.name == rhs.name &&
    lhs.entry == rhs.entry &&
    lhs.time == rhs.time
}
