//
//  File.swift
//  i2app
//
//  Created by Arcus Team on 5/16/17.
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

import UserNotifications
import Cornea

extension Notification.Name {
  static let pushWillChangePlace = Notification.Name("PlaceWillChangeFromPush")
  static let pushDidChangePlace = Notification.Name("PlaceDidChangeFromPush")
}

enum RemoteNotificationType {
  case device
  case person
  case scene
  case subsystem
  case unknown
}

struct RemoteNotification {
  var title: String = ""
  var body: String = ""
  var isContentAvailable: Bool = false
  var address: String = ""
  var placeId: String = ""
  var placeName: String = ""
  var type: RemoteNotificationType {
    if address.hasPrefix("DRIV:dev:") {
      return .device
    } else if address.hasPrefix("SERV:person:") {
      return .person
    } else if address.hasPrefix("SERV:scene:") {
      return .scene
    } else if address.hasPrefix("SERV:sub") {
      return .subsystem
    }
    return .unknown
  }

  init(_ userInfo: [AnyHashable: Any]) {
    if let aps = userInfo["aps"] as? [String: AnyObject] {
      if let alert = aps["alert"] as? [String: AnyObject] {
        if let title = alert["title"] as? String {
          self.title = title
        }

        if let body = alert["body"] as? String {
          self.body = body
        }
      }

      if let isContentAvailable = aps["content-available"] as? Bool {
        self.isContentAvailable = isContentAvailable
      }
    }

    if let address = userInfo["address"] as? String {
      self.address = address
    }

    if let placeId = userInfo["place_id"] as? String {
      self.placeId = placeId
    }

    if let placeName = userInfo["place_name"] as? String {
      self.placeName = placeName
    }
  }
}

protocol RootViewControllerRouter {
  var rootViewController: UIViewController { get set }

  func load(_ viewController: UIViewController)
  func load(_ viewControllerStack: [UIViewController])
}

extension RootViewControllerRouter {
  func load(_ viewController: UIViewController) {
    self.rootViewController.navigationController?.present(viewController,
                                                          animated: true,
                                                          completion: {})
  }

  func load(_ viewControllerStack: [UIViewController]) {
    self.rootViewController.navigationController?.viewControllers = viewControllerStack
  }
}

class RemoteNotificationRouter: RootViewControllerRouter {
  var rootViewController: UIViewController

  required init(_ rootViewController: UIViewController) {
    self.rootViewController = rootViewController
  }

  func load(_ remoteNotification: RemoteNotification) -> Bool {
    switch remoteNotification.type {
    case .device:
      return loadDeviceOperation(remoteNotification.address)
    case .subsystem:
      return loadSubsystem(remoteNotification.address)
    default:
      break
    }
    return false
  }

  private func loadDeviceOperation(_ address: String) -> Bool {
    // Device control screen for the referenced device (sidemenu → devices → device)
    var viewControllers = rootViewController.navigationController?.viewControllers
    if viewControllers != nil {
      viewControllers!.append(DeviceListViewController.create())

      if let device = RxCornea.shared.modelCache?.fetchModel(address) as? DeviceModel {
        if let vc = DeviceDetailsTabBarController.create(with: device) {
          viewControllers!.append(vc)
        }
      }
      load(viewControllers!)
      return true
    }
    return false
  }

  private func loadSubsystem(_ address: String) -> Bool {
    let components = address.components(separatedBy: ":")
    guard components.count > 2 else {
      return false
    }

    if let viewController = viewControllerForSubsystem(components[1]) {
      load(viewController)
      return true
    }
    return false
  }

  private func viewControllerForSubsystem(_ subsystem: String) -> UIViewController? {
    var viewController: UIViewController? = nil

    switch subsystem {
    case PersonCapability.namespace():
      // Person account settings screen for the referenced person (sidemenu → settings → people → person)
      if var viewControllers = viewControllers() {
        viewControllers.append(SettingsViewController.create())

        if let peopleListVC = PeopleListViewController.create() {
          viewControllers.append(peopleListVC)
          viewControllers.append(PeopleContactInformationViewController.create(peopleListVC.peopleManager))
        }
        load(viewControllers)
      }
    case SecuritySubsystemCapability.namespace():
      // Ignore.  ViewRouter will handle.
      break
    case DoorsNLocksSubsystemCapability.namespace():
      // Doors & Locks subsystem card (dashboard → Doors & Locks card)
      viewController = ServiceTabbarViewController.create(DashboardCardTypeDoorsLocks)
    case ClimateSubsystemCapability.namespace():
      // Climate subsystem card (dashboard → Climate card)
      viewController = ServiceTabbarViewController.create(DashboardCardTypeClimate)
    case LightsNSwitchesSubsystemCapability.namespace():
      // Lights & Switches subsystem card (dashboard → Lights & Switches card)
      viewController = LightsSwitchesTabbarController.create()
    case SafetySubsystemCapability.namespace():
      // Ignore.  ViewRouter will handle.
      break
    case PresenceCapability.namespace():
      // Home & Family subsystem card (dashboard → Home & Family card)
      viewController = HomeFamilyTabBarViewController.create()
    case CareSubsystemCapability.namespace():
      // Care subsystem card (dashboard → Care card)
      viewController = CareTabBarController.init(title: "CARE")
    case WaterSubsystemCapability.namespace():
      // Water subsystem card (dashboard → Water card)
      viewController = WaterTabbarController.create()
    case CamerasSubsystemCapability.namespace():
      // Camera subsystem card (dashboard → Cameras)
      viewController = CameraTabBarViewController.create()
    case LawnNGardenSubsystemCapability.namespace():
      // Lawn & Garden subsystem card (dashboard → Lawn & Garden)
      viewController = LawnNGardenTabBarViewController.create()
    default:
      break
    }

    return viewController
  }

  private func viewControllers() -> [UIViewController]? {
    return rootViewController.navigationController?.viewControllers
  }
}

protocol RemoteNotificationHandlerProtocol {
  var pendingNotificationClosure: (() -> Void)? { get set }

  // EXTENDED

  func registerRemoteNotifications(_ application: UIApplication)
  func remoteNotification(_  userInfo: [AnyHashable: Any]) -> RemoteNotification
  func processRemoteNotification(_ notification: RemoteNotification,
                                 router: RemoteNotificationRouter) -> (success: Bool, retry: Bool)
}

extension RemoteNotificationHandlerProtocol {
  func registerRemoteNotifications(_ application: UIApplication) {
    if #available(iOS 10, *) {
      let options: UNAuthorizationOptions = [.badge, .alert, .sound]

      UNUserNotificationCenter.current().requestAuthorization(options: options) { _ in }
      application.registerForRemoteNotifications()
    } else {
      let types: UIUserNotificationType = [.badge, .alert, .sound]
      let notificationSettings = UIUserNotificationSettings(types: types, categories: nil)

      UIApplication.shared.registerUserNotificationSettings(notificationSettings)
      UIApplication.shared.registerForRemoteNotifications()
    }
  }

  func remoteNotification(_  userInfo: [AnyHashable: Any]) -> RemoteNotification {
    return RemoteNotification(userInfo)
  }

  func processRemoteNotification(_ notification: RemoteNotification,
                                 router: RemoteNotificationRouter) -> (success: Bool, retry: Bool) {
    // Do not process notification if cache has not been set.
    guard let placeId = RxCornea.shared.settings?.currentPlace?.modelId,
      let currentPerson = RxCornea.shared.settings?.currentPerson,
      placeId.count > 0 else {
        return (false, true)
    }

    // Do not process notiication if an alarm is active.
    guard NavigationBarAppearanceManager.sharedInstance.currentIncidentState != .alert &&
      NavigationBarAppearanceManager.sharedInstance.currentIncidentState != .prealert else {
        return (false, false)
    }

    if placeId == notification.placeId {
      let success = router.load(notification)
      return (success, false)
    } else {
      RxCornea.shared.session?.setActivePlace(notification.placeId)
    }
    return (false, true)
  }
}

class RemoteNotificationHandler: NSObject, RemoteNotificationHandlerProtocol, BatchNotificationObserver {
  static let shared: RemoteNotificationHandler = RemoteNotificationHandler()

  var pendingNotificationClosure: (() -> Void)?

  override private init() {
    super.init()
    setUp()
  }

  deinit {
    tearDown()
  }

  func setUp() {
    observeBatchNotifications([Notification.Name.subsystemCacheInitialized],
                              selector: #selector(processPendingRemoteNotification(_:)))
  }

  func tearDown() {
    removeAllBatchNotificationObservers()
  }

  @objc func processPendingRemoteNotification(_ notification: Notification) {
    guard pendingNotificationClosure != nil else {
      return
    }

    pendingNotificationClosure!()
    pendingNotificationClosure = nil
  }

  func registerForRemoteNotifications(_ application: UIApplication) {
    registerRemoteNotifications(application)
  }

  // https://eyeris.atlassian.net/wiki/display/I2D/Push+Notification+Message+Format
  func processRemoteNotification(_ application: UIApplication,
                                 userInfo: [AnyHashable: Any],
                                 rootViewController: UIViewController) {
    // Do not process notification if user did not tap it.
    guard application.applicationState == .inactive else { return }

    let notification = RemoteNotification(userInfo)
    let router = RemoteNotificationRouter(rootViewController)
    let response = processRemoteNotification(notification,
                                             router: router)

    if response.retry == true {
      pendingNotificationClosure = {
        _ = self.processRemoteNotification(notification,
                                           router: router)
      }
    }
  }
}
