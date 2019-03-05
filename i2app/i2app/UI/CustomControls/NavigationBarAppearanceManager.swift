//
//  NavigationBarAppearanceManager.swift
//  i2app
//
//  Created by Arcus Team on 2/16/17.
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

public let kActiveAlarmIncidentChanged = "kActiveAlarmIncidentChanged"

extension Notification.Name {
  static let activeAlarmIncidentChanged = Notification.Name("kActiveAlarmIncidentChanged")
}

extension ActiveAlarmIncidentType {
  ///The Color for the background of a cell following the active incident
  var cellTintColor: UIColor {
    switch self {
    case .none:
      return UIColor.clear
    case .security:
      return Appearance.securityBlue
    case .panic:
      return Appearance.panicGrey
    case .smokeAndCO:
      return Appearance.smokeAndCORed
    case .water:
      return Appearance.waterLeakTeal
    case .care:
      return Appearance.carePurple
    }

  }

  var navigationBarBarStyle: UIBarStyle {
    switch self {
    case .none:
      return .default
    default:
      return .default
    }

  }

  var navigationBarTranslucent: Bool {
    return false
  }

  ///The Color for the background of a navigation bar following the active incident
  func barTintColor(_ state: IncidentAlertState) -> UIColor {
    if state == .prealert {
      return UIColor.white
    } else {
      switch self {
      case .none:
        return UIColor.white
      case .security:
        return Appearance.securityBlue
      case .panic:
        return Appearance.panicGrey
      case .smokeAndCO:
        return Appearance.smokeAndCORed
      case .water:
        return Appearance.waterLeakTeal
      case .care:
        return Appearance.carePurple
      }
    }
  }

  ///Color of text of Buttons in the bar or cell
  func navigationBarTintColor(_ state: IncidentAlertState) -> UIColor {
    if state == .prealert {
      return UIColor.black
    } else {
      switch self {
      case .none:
        return UIColor.black
      case .security, .panic, .smokeAndCO, .care, .water:
        return UIColor.white
      }
    }
  }

  func statusBarBarStyle(_ state: IncidentAlertState) -> UIStatusBarStyle {
    if state == .prealert {
      return .default
    } else {
      switch self {
      case .none:
        return .default
      case .security, .panic, .smokeAndCO, .care, .water:
        return .lightContent
      }
    }

  }

  func navigationBarTextAttributes(_ state: IncidentAlertState) -> [String:AnyObject]? {
    if state == .prealert {
      return [NSForegroundColorAttributeName: UIColor.black]
    } else {
      switch self {
      case .none:
        return [NSForegroundColorAttributeName: UIColor.black]
      case .security, .panic, .smokeAndCO, .care, .water:
        return [NSForegroundColorAttributeName: UIColor.white]
      }
    }
  }
}

class NavigationBarAppearanceManager: NSObject {

  static let sharedInstance = NavigationBarAppearanceManager()

  var presenter: ActiveIncidentAlarmPresenterProtocol!

  override init () {
    super.init()
    self.presenter = ActiveIncidentAlarmPresenter(delegate: self)
  }

  func setup() {
    UINavigationBar.appearance().isTranslucent = false
    setColorScheme(ActiveAlarmIncidentType.none, state: currentIncidentState)
  }

  /// Function will set the NavigationControllerColorable to the desired color
  fileprivate func setColorScheme(_ type: ActiveAlarmIncidentType, state: IncidentAlertState) {

    UIApplication.shared.setStatusBarStyle(type.statusBarBarStyle(state), animated: false)

    UINavigationBar.appearance().barTintColor = type.barTintColor(state)
    UINavigationBar.appearance().barStyle = type.navigationBarBarStyle
    UINavigationBar.appearance().tintColor = type.navigationBarTintColor(state)
    UINavigationBar.appearance().titleTextAttributes = type.navigationBarTextAttributes(state)

    UIBarButtonItem
      .appearance(whenContainedInInstancesOf: [UINavigationBar.self])
      .tintColor = type.navigationBarTintColor(state)

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
      self.reloadViews()
    }
  }

  var incidentTypes: [ActiveAlarmIncidentType] {
    return presenter.data
  }

  var currentColorScheme: ActiveAlarmIncidentType {
    if let first = presenter.data.first {
      return first
    } else {
      return .none
    }

  }

  var currentIncidentState: IncidentAlertState {
    if presenter != nil {
      return presenter.activeIncidentState
    }
    // Fallback
    return .complete

  }
  
  func isInAlarmState() -> Bool {
    return currentIncidentState != .complete || currentColorScheme != .none
  }

  func reloadViews() {
    guard let delegate = UIApplication.shared.delegate,
      let window = delegate.window as? UIWindow else { return }
    let allSubviews = window.allSubviews() as! [UIView]
    let navBars: [UIView] = allSubviews
      .filter { v in return v is UINavigationBar }

    navBars.forEach { navBar in
      if let superView = navBar.superview {
        navBar.removeFromSuperview()
        superView.addSubview(navBar)

        navBar.subviews.forEach({ v in
          let view = v //is a strong reference needed?
          if let superview = view.superview {
            view.removeFromSuperview()
            superview.addSubview(view)
          }
        })
      }
    }
  }
}

extension NavigationBarAppearanceManager: ActiveIncidentAlarmPresenterDelegateProtocol {
  func updateLayout() {
    DispatchQueue.main.async {
      let center = NotificationCenter.default
      center.post(name: Notification.Name.activeAlarmIncidentChanged, object: self)
      self.setColorScheme(self.currentColorScheme, state: self.currentIncidentState)
    }
  }
}

extension NavigationBarAppearanceManager {
  override var debugDescription: String {
    return "\(super.debugDescription) \(currentColorScheme)"
  }
}

extension NavigationBarAppearanceManager {

  @objc var barTintColor: UIColor {
    return self.currentColorScheme.barTintColor(currentIncidentState)
  }

  var statusBarBarStyle: UIStatusBarStyle {
    return self.currentColorScheme.statusBarBarStyle(currentIncidentState)
  }

  @objc var cellTintColor: UIColor {
    return self.currentColorScheme.cellTintColor
  }

  @objc var navigationBarTintColor: UIColor {
    return self.currentColorScheme.navigationBarTintColor(currentIncidentState)
  }

  @objc var navigationBarBarStyle: UIBarStyle {
    return  self.currentColorScheme.navigationBarBarStyle
  }

  @objc var navigationBarTranslucent: Bool {
    return self.currentColorScheme.navigationBarTranslucent
  }

  @objc var navigationBarTextAttributes: [String:AnyObject]? {
    return self.currentColorScheme.navigationBarTextAttributes(currentIncidentState)
  }
}
