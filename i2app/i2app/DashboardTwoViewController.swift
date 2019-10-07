//
//  i2app
//
//  Created by Arcus Team on 12/12/16.
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

import CocoaLumberjack
import SWRevealViewController
import Cornea
import RxSwift

extension Constants {
  static let dashboardPlaceLoadingTag: Int = 91453 // PLACE
}

// The interger raw value of this type will determine the priority of the type.
internal enum DashboardBannerType: Int {
  case hubOffline = 1
  case hasInvitation
  case lteActivateDevice
  case lteUpdatePlan
  case lteConfigureDevice
  case deviceFirmwareUpdate
  case hubisRunningOnBattery
}

internal enum DashboardConstants {
  static let constraintPriorityLow: Float = 200
  static let constraintPriorityHigh: Float = 999
  static let titleImageName = "DashLogo"
  static let titleImageWhiteName = "DashLogoWhite"
  static let careTabBarTitle = "CARE"
  static let cardSizeStandard: CGFloat = 80
  static let cardSizeFavorite: CGFloat = 120
  static let revealMenuWidth: CGFloat = 315
  static let historyFetchDuration = 15.0
  static let callSupportNumber = "+18554694747"
  static let delaySecsBeforeApptentive = 8
}

internal enum DashboardCardIdentifier {
  static let favorite = "DashboardFavoriteCard"
  static let favoriteItem = "DashboardFavoriteItemCell"
  static let history = "DashboardHistoryCard"
  static let historyEmpty = "DashboardHistoryEmptyCard"
  static let lightsSwitches = "DashboardLightsSwitchesCard"
  static let homeFamily = "DashboardHomeFamilyCard"
  static let doorsLocks = "DashboardDoorsLocksCard"
  static let lawnGarden = "DashboardLawnGardenCard"
  static let care = "DashboardCareCard"
  static let alarms = "DashboardAlarmsCard"
  static let cameras = "DashboardCamerasCard"
  static let water = "DashboardWaterCard"
  static let climate = "DashboardClimateCard"
  static let learnMore = "DashboardLearnMoreCard"
}

// MARK: DashboardTwoViewController
@objc class DashboardTwoViewController: UIViewController, DebugMenuMixin {

  // MARK: Public Properties
  var revealController: SWRevealViewController!

  var pinchCount: Int = 0
  var pinchStart: Date = Date()

  // MARK: Private Properties
  var dashboardPresenter: DashboardPresenterProtocol?
  var bannerPresenter: BannerPresenter!
  var personInvitationsController: PersonInvitationsController!
  var historyTimer: Timer?
  var heightAtIndexPath = [IndexPath: CGFloat]()
  var whatsNewPresenter: (WhatsNewPresenterViewProtocol & WhatsNewPresenterFetchProtocol)?

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var currentPlaceButton: UIButton!
  @IBOutlet weak var headerImage: UIImageView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var headerImageClippingView: UIView!
  @IBOutlet var placeSwtichingOverlay: PlaceSwitchingOverlay!

  var disposeBag: DisposeBag = DisposeBag()

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: IB Actions
  @IBAction func dashboardSettingsButtonPressed(_ sender: AnyObject) {
    navigationController?.pushViewController(DashboardSettingViewController.create(), animated: true)
  }

  @IBAction func dashboardMenuButtonPressed(_ sender: AnyObject) {
    ArcusAnalytics.tag(named: AnalyticsTags.NavigationSidebar)

    revealController.revealToggle(self)
  }

  @IBAction func dashboardAddButtonPressed(_ sender: AnyObject) {
    ArcusAnalytics.tag(AnalyticsTags.DashboardAddClick, attributes: [:])
    
    performSegue(withIdentifier: "AddMenuViewController", sender: self)
  }

  // MARK: Life Cyle Events
  override func viewDidLoad() {
    super.viewDidLoad()

    // Set up reveal controller
    if revealController == nil {
      revealController = SWRevealViewController()
    }

    revealController.delegate = self
    revealController.tapGestureRecognizer()
    revealController.rearViewRevealWidth = DashboardConstants.revealMenuWidth

    dashboardPresenter = DashboardPresenter(delegate: self)
    dashboardPresenter?.startObserving()
    dashboardPresenter?.collectData()

    addDarkOverlay(BackgroupOverlayLightLevel)

    placeSwtichingOverlay.tag = -1
    showLoadingOverlay()

    // Avoid empty cells being added to the table footer if the contect of the table is
    // smaller than the available height.
    tableView.tableFooterView = UIView()

    // Configure table so the History Card can grow dynamically
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = DashboardConstants.cardSizeStandard

    let titleChangeSelector = #selector(DashboardTwoViewController.shouldUpdateNavigationBar(_:))
    NotificationCenter.default.addObserver(self,
                                           selector: titleChangeSelector,
                                           name: Notification.Name.activeAlarmIncidentChanged,
                                           object: nil)
    updateNavigationBarWithLogoImage()

    notifyPersonEmailAvailable()

    configureDebugGestureRecognizer(#selector(pinchGestureReceived(_:)))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    DevicePairingManager.sharedInstance().stopPairingProcessAndNotifications()
    DashboardCardsManager.shareInstance().checkAdditionalCards()

    if bannerPresenter == nil {
      bannerPresenter = BannerPresenter(callback: self)
    }

    shouldPresentWhatsNewInTwoScreen()

    dashboardPresenter?.startObserving()
    dashboardPresenter?.collectData()

    // Add a timer to fetch history while on the dashboard.
    historyTimer = Timer.scheduledTimer(
      timeInterval: DashboardConstants.historyFetchDuration,
      target: self,
      selector: #selector(fetchHistory),
      userInfo: nil,
      repeats: true)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // Ensure that the device is able to use the idle timeout
    UIApplication.shared.isIdleTimerDisabled = false
    
    if self.placeSwtichingOverlay.tag == 0 {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
        self.hideLoadingOverlay()
      })
    }

    guard let presenter = dashboardPresenter else {
      return
    }

    // On First launch display the "Welcome Tutorial"
    // don't do it until after the Add device/hub pairing steps execute
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      if self.navigationController?.topViewController == self,
        presenter.isAccountJustCreated() {
        let tutorial = TutorialViewController.create(
          with: presenter.tutorialTypeNeeded(), andCompletionBlock: nil)

        presenter.saveAccountCreation()

        self.navigationController?.present(tutorial!,
                                           animated: true,
                                           completion: nil)
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      ArcusAnalytics.tag(AnalyticsTags.Dashboard, attributes: [:])
    }
  }

  /* 
   Required as a patch to make sure that ArcusClient does not store the session token incorrectly. This is a
     port from the old objective-C Dashboard and will be phased out with an ArcusClient refactor.
  */
  func notifyPersonEmailAvailable() {
    if let email = RxCornea.shared.settings?.currentPerson?.emailAddress {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentPersonEmail"),
                                      object: email)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Remove the history fetch when navigating away from the dashboard.
    historyTimer?.invalidate()
    historyTimer = nil

    if self.tableView == nil { return }
    bannerPresenter = nil
    dashboardPresenter?.stopObserving()
    removeInvitationsController()
    closePopupAlert()
    hideLoadingOverlay()
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    applyParallaxToHeaderImage(tableView.contentOffset.y)
  }

  // MARK: Public Functions
  func setDashboardBackgroundImageForPlaceID(_ placeId: NSString) {
    shouldUpdateViews()
  }

  func setDashboardBackgroundImageForCurrentPlace() {
    dashboardPresenter?.collectData()
  }

  @objc func refreshBanners() {
    DispatchQueue.main.async {
      self.checkHubState()
      self.checkForDeviceFirmwareUpdates()
      self.setupInvitationsController()
    }
  }

  func changeToPlaceWithId(_ placeId: NSString) {
    dashboardPresenter?.updatePlaceForId(placeId as String)
  }

  func fetchHistory() {
    guard let presenter = dashboardPresenter as? DashboardPresenter else { return }

    presenter.fetchDashboardHistory()
  }

  // MARK: Private Functions
  fileprivate func addDropShadowToButton(_ button: UIButton) {
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 1, height: 1)
    button.layer.shadowRadius = 1
    button.layer.shadowOpacity = 0.8
  }

  fileprivate func configurePlaceChangeButton() {
    addDropShadowToButton(currentPlaceButton)

    currentPlaceButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    currentPlaceButton.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    currentPlaceButton.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
  }

  fileprivate func applyParallaxToHeaderImage(_ yOffset: CGFloat) {
    let screenWidth = tableView.frame.width
    let headerImageHeight: CGFloat = 180
    let limitBeforeZoom: CGFloat = 15

    if yOffset >= 0 {
      let imageFrame = CGRect(x: 0, y: 0, width: screenWidth, height: headerImageHeight)

      headerImageClippingView.clipsToBounds = true
      headerImage.frame = imageFrame.offsetBy(dx: 0.0, dy: yOffset)
    } else {
      let xOffset = (yOffset < limitBeforeZoom * -1) ?
        yOffset * -1 - limitBeforeZoom : 0

      headerImageClippingView.clipsToBounds = false
      headerImage.frame = CGRect(x: 0 - xOffset,
                                 y: yOffset,
                                 width: screenWidth + (xOffset * 2),
                                 height: headerImageHeight + (yOffset * -1))
    }
  }

  func checkAcccountJustCreated() -> Bool {
    let accountCreated = UserDefaults.standard.bool(forKey: "accountJustCreated")
    let missingHub = RxCornea.shared.settings?.currentHub == nil

    return accountCreated && missingHub
  }

  func shouldUpdateNavigationBar(_ note: Notification) {
    DispatchQueue.main.async {
      self.updateNavigationBarWithLogoImage()
    }
  }

  func updateNavigationBarWithLogoImage() {
    var image: UIImage! = nil
    switch NavigationBarAppearanceManager.sharedInstance.currentColorScheme {
    case .none:
      image = UIImage(named: DashboardConstants.titleImageName)
    default:
      image = UIImage(named: DashboardConstants.titleImageWhiteName)
    }
    let imageView = UIImageView(image:image)
    navigationItem.titleView = imageView
  }

  func showLoadingOverlay(_ loadingText: String? = nil, tag: Int = 0) {
    // Do not show if Dashboard isn't visible.
    guard navigationController?.topViewController is DashboardTwoViewController else {
      return
    }

    // Do not show loading overlay if already visible.
    guard navigationController?.view.subviews.contains(placeSwtichingOverlay) == false else {
      return
    }

    // Tag the overlay to differentiate between overlay types.
    placeSwtichingOverlay.tag = tag

    // Only display place switching label is placeName is not nil.
    placeSwtichingOverlay.activityDescription.text = loadingText
    placeSwtichingOverlay.activityDescription.isHidden = loadingText == nil

    // Add the overlay to the navigationController's view.
    if let navigationController: UINavigationController = self.navigationController {
      placeSwtichingOverlay.frame = navigationController.view.frame
      placeSwtichingOverlay.setNeedsDisplay()
      navigationController.view.addSubview(self.placeSwtichingOverlay)

      // Animate the loading indicator.
      placeSwtichingOverlay.activityIndicator.startAnimating()
    }
  }

  func hideLoadingOverlay(_ tag: Int = 0) {
    // Only dismiss the overlay if the tag matches the overlay's tag.
    guard placeSwtichingOverlay.tag == tag else {
      return
    }

    // Reset the tag
    placeSwtichingOverlay.tag = -1

    // Stop animating the loading indicator.
    placeSwtichingOverlay.activityIndicator.stopAnimating()

    // Remove the overlay from the navigationController's view.
    placeSwtichingOverlay.removeFromSuperview()
  }

  fileprivate func presentHistoryController() {
    let vc = DashboardHistoryListViewController.create()
    navigationController?.pushViewController(vc!, animated: true)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == kAlarmUpgradeSegue {
      UpgradeAlarmViewController.configureWithSegue(segue)
    }
  }
}

// MARK: DashboardPresenterDelegate
extension DashboardTwoViewController: DashboardPresenterDelegate {
  func shouldPresentLoadingScreen() {
    DispatchQueue.main.async {
      self.createGif()
    }
  }

  func shouldPresentBiometricAuthPrompt() {
    let touchIDPresenter = PromptToEnableBiometricAuthenticationPresenter()
    touchIDPresenter.shouldDisplayPromptToEnableBiometricAuthentication()
      .subscribe(
        onSuccess: { [unowned self] _ in
          guard let touchIDPromptVC = PromptToEnableBiometricAuthenticationViewController
            .create(presenter: touchIDPresenter) else {
              DDLogWarn("PromptToEnableBiometricAuthenticationViewController could not be created")
              return
          }
          if self.viewIfLoaded?.window != nil {
            self.present(touchIDPromptVC, animated: true, completion: nil)
          }
      }).disposed(by: disposeBag)
  }

  func shouldPresentWhatsNewInTwoScreen() {
    if whatsNewPresenter == nil {
      whatsNewPresenter = WhatsNewPresenter(connectivityDelegate: self)
    }
    whatsNewPresenter?.checkShouldDisplayWhatsNewScreen()
  }

  func shouldPresentTNCViewController() {
    ApplicationRoutingService.defaultService.showTermsAndConditions()
  }

  func shouldHideLoadingScreen() {
    DispatchQueue.main.async {
      self.hideGif()
    }
  }

  func shouldPresentPeopleDetailViewController(_ viewController: PeopleDetailViewController) {
    DispatchQueue.main.async {
      self.navigationController?.pushViewController(viewController, animated: true)
    }
  }

  func shouldUpdateCards() {
    guard dashboardPresenter != nil else {
      return
    }

    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }

  func shouldUpdateCardAtIndex(_ index: IndexPath) {
    guard dashboardPresenter != nil else {
      return
    }

    DispatchQueue.main.async {
      self.tableView.reloadRows(at: [index], with: .none)
    }
  }

  func shouldUpdateHeaderElements() {
    guard dashboardPresenter != nil else {
      return
    }

    DispatchQueue.main.async {
      self.updateHeaderElements()
    }
  }

  func shouldUpdateViews() {
    guard dashboardPresenter != nil && bannerPresenter != nil else {
      return
    }

    DispatchQueue.main.async {
      self.updateHeaderElements()

      // Check Banners
      self.refreshBanners()
    }
  }

  func shouldDismissViewController() {
    DispatchQueue.main.async {
      self.navigationController?.dismiss(animated: true, completion: nil)
    }
  }

  func shouldShowLegacyAlarmCancel() {
    DispatchQueue.main.async {
      self.performSegue(withIdentifier: kCancelLegacySegue, sender: self)
    }
  }

  func shouldShowChangingPlaceOverlay(_ loadingText: String?) {
    DispatchQueue.main.async {
      self.showLoadingOverlay(loadingText, tag: Constants.dashboardPlaceLoadingTag)
    }
  }

  func shouldDismissChangePlaceOverlay() {
    DispatchQueue.main.async {
      self.hideLoadingOverlay(Constants.dashboardPlaceLoadingTag)
    }
  }

  private func updateHeaderElements() {
    DispatchQueue.main.async { [weak self] in
      guard let presenter = self?.dashboardPresenter as? DashboardPresenter else {
        return
      }
      
      // Update header content
      self?.headerImage.image = presenter.headerImage
      
      // Update Background Image
      self?.backgroundImage.image = presenter.headerImage
      
      // Check if the place button should be displayed
      if presenter.placeModalModels.count < 2 ||
        presenter.currentPlaceName.isEmpty {
        self?.currentPlaceButton.isHidden = true
      } else {
        self?.configurePlaceChangeButton()
        self?.currentPlaceButton.isHidden = false
        self?.currentPlaceButton.setTitle(presenter.currentPlaceName, for: UIControlState())
      }
    }
  }
}

// MARK: SWRevealViewControllerDelegate
extension DashboardTwoViewController: SWRevealViewControllerDelegate {
  func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
    setNeedsStatusBarAppearanceUpdate()
  }

  func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
    if position == FrontViewPosition.right {
      dashboardPresenter?.stopObserving()
      bannerPresenter = nil
      removeInvitationsController()
      closePopupAlert()
    } else if position == FrontViewPosition.left {
      if bannerPresenter == nil {
        bannerPresenter = BannerPresenter(callback: self)
      }

      dashboardPresenter?.startObserving()
      dashboardPresenter?.collectData()
    }
  }
}

// MARK: UITableViewDelegate
extension DashboardTwoViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presenter = dashboardPresenter as? DashboardPresenter else { return }

    let viewModel = presenter.viewModels[indexPath.row]

    if viewModel.isEnabled {
      // Handle Active Cards
      switch viewModel.type {
      case .Alarms:
        guard let alarmViewModel = viewModel as? DashboardAlarmsViewModel else {
          return
        }

        // TODO: Update?
        ArcusAnalytics.tag(AnalyticsTags.DashboardSecurityClick, attributes: [:])
        
        if alarmViewModel.isOfflineMode {
          // Check for alarm offline mode
          let storyboard = UIStoryboard(name: "AlarmOfflineWarning", bundle: nil)
          let viewController = storyboard.instantiateViewController(withIdentifier: "AlarmOfflineWarning")
          navigationController?.present(viewController, animated: true, completion: nil)
        } else if let settings = RxCornea.shared.settings,
          settings.displaySecurityTutorial() == true
            && alarmViewModel.backgroundColor == UIColor.clear {
          // Ensure that the color is clear which means that no alarm is going off.
          let tutorial = TutorialViewController.create(
            with: TuturialType.security,
            andCompletionBlock: {
              if let segueId = presenter.alarmSegueIdentifier() {
                self.performSegue(withIdentifier: segueId, sender: self)
              }
          })
          
          navigationController?.present(tutorial!,
                                        animated: true,
                                        completion: nil)
        } else {
          if let segueId = presenter.alarmSegueIdentifier() {
            performSegue(withIdentifier: segueId, sender: self)
          }
        }
      case .LightsSwitches:
        ArcusAnalytics.tag(AnalyticsTags.DashboardLightswitchesClick, attributes: [:])
        navigationController?.pushViewController(LightsSwitchesTabbarController.create(), animated: true)
      case .Climate:
        ArcusAnalytics.tag(AnalyticsTags.DashboardClimateClick, attributes: [:])
        if let settings = RxCornea.shared.settings, settings.displayClimateTutorial() == true {
          let tutorial = TutorialViewController.create(
            with: TuturialType.climate,
            andCompletionBlock: {
              self.navigationController?.pushViewController(
                ServiceTabbarViewController.create(DashboardCardTypeClimate),
                animated: true)
          })

          navigationController?.present(tutorial!,
                                        animated: true,
                                        completion: nil)
        } else {
          navigationController?.pushViewController(
            ServiceTabbarViewController.create(DashboardCardTypeClimate),
            animated: true)
        }
      case .DoorsLocks:
        ArcusAnalytics.tag(AnalyticsTags.DashboardDoorslocksClick, attributes: [:])
        navigationController?
          .pushViewController(ServiceTabbarViewController.create(DashboardCardTypeDoorsLocks),
                              animated: true)
      case .Cameras:
        ArcusAnalytics.tag(AnalyticsTags.DashboardCamerasClick, attributes: [:])
        navigationController?.pushViewController(CameraTabBarViewController.create()!, animated: true)
        //navigationController?.pushViewController(CamerasTabBarViewController.create()!, animated: true)
      case .Water:
        ArcusAnalytics.tag(AnalyticsTags.DashboardWaterClick, attributes: [:])
        navigationController?.pushViewController(WaterTabbarController.create(), animated: true)
      case .Care:
        ArcusAnalytics.tag(AnalyticsTags.DashboardCareClick, attributes: [:])
        if SubsystemsController.sharedInstance().careController.isAlarmTriggered {
          CareAlarmViewController.create(completionBlock: { vc in
            self.navigationController?.pushViewController(vc!, animated: true)
          })
        } else {
          navigationController?.pushViewController(CareTabBarController(title: "CARE"), animated: true)
        }
      case .LawnGarden:
        ArcusAnalytics.tag(AnalyticsTags.DashboardLawnGardgenClick, attributes: [:])
        navigationController?.pushViewController(LawnNGardenTabBarViewController.create(), animated: true)
      case .HomeFamily:
        ArcusAnalytics.tag(AnalyticsTags.DashboardHomeFamilyClick, attributes: [:])
        navigationController?.pushViewController(HomeFamilyTabBarViewController.create(), animated: true)
      case .History:
        if let settings = RxCornea.shared.settings,
          settings.displayHistoryTutorial() == true {
          let tutorial = TutorialViewController.create(with: TuturialType.history,
                                                       andCompletionBlock: {
                                                        self.presentHistoryController()
          })!
          navigationController?.present(tutorial,
                                        animated: true,
                                        completion: nil)
        } else {
          presentHistoryController()
        }
      default:
        return
      }
    }
    
    // Handle Learn More Cards
    else {
      switch viewModel.type {
      case .Care:
        if presenter.premiumAccountIndicator {
          navigationController?.pushViewController(CareNoDeviceViewController.create(), animated: true)
        } else {
          ArcusAnalytics.tag(named: AnalyticsTags.DashboardCareInfo)
          UIApplication.shared.openURL(NSURL.ProductsCare)
        }
        return

      case .LightsSwitches:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardLightsswitchesInfo)
        UIApplication.shared.openURL(NSURL.ProductsLights)
        break
      case .Climate:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardClimateInfo)
        UIApplication.shared.openURL(NSURL.ProductsClimate)
        break
      case .DoorsLocks:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardDoorslocksInfo)
        UIApplication.shared.openURL(NSURL.ProductsDoors)
        break
      case .Cameras:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardCamerasInfo)
        UIApplication.shared.openURL(NSURL.ProductsCameras)
        break
      case .LawnGarden:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardLawngardenInfo)
        UIApplication.shared.openURL(NSURL.ProductsLawn)
        break
      case .HomeFamily:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardHomefamilyInfo)
        UIApplication.shared.openURL(NSURL.ProductsHome)
        break
      case .Alarms:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardCamerasInfo)
        UIApplication.shared.openURL(NSURL.ProductsSecurity)
        break
      case .Water:
        ArcusAnalytics.tag(named: AnalyticsTags.DashboardWaterInfo)
        UIApplication.shared.openURL(NSURL.ProductsWater)
        break
      default:
        UIApplication.shared.openURL(NSURL.Support)
        break
      }
    }
  }
}

// MARK: UITableViewDataSource
extension DashboardTwoViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let presenter = dashboardPresenter else { return 0 }

    return presenter.viewModels.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let presenter = dashboardPresenter else {
      return DashboardConstants.cardSizeStandard
    }

    let viewModel = presenter.viewModels[indexPath.row]

    switch viewModel.type {
    case .Favorites:
      return DashboardConstants.cardSizeFavorite
    case .History where presenter.numberOfHistoryItems() > 0:
      return UITableViewAutomaticDimension
    default:
      return DashboardConstants.cardSizeStandard
    }
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let presenter = dashboardPresenter as? DashboardPresenter,
      presenter.viewModels.count > indexPath.row else {

      return UITableViewCell()
    }

    let viewModel = presenter.viewModels[indexPath.row]

    return DashboardCardFactory.createCell(tableView: tableView, viewModel: viewModel)
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    let height = heightAtIndexPath[indexPath]

    if height != nil {
      return height!
    } else {
      return UITableViewAutomaticDimension
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    heightAtIndexPath[indexPath] = cell.frame.height
  }
}

// MARK: UICollectionViewDelegate - Favorites
extension DashboardTwoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let presenter = dashboardPresenter as? DashboardPresenter else { return }

    if presenter.dashboardCurrentFavoritesCount() <= 0 {
      return
    }

    let favoritesIndex = presenter.viewModelIndexForType(.Favorites)
    if let viewModel = presenter.viewModels[favoritesIndex] as? DashboardFavoriteViewModel {
      let currentFavorite = viewModel.currentFavorites[indexPath.row]

      if let model = currentFavorite.dataModel as? DeviceModel {

        // Arcus Analytics
        ArcusAnalytics.tag(AnalyticsTags.FavoritesClick, attributes: [:])
        ArcusAnalytics.tag(AnalyticsTags.FavoritesDeviceClick,
                          attributes: [AnalyticsTags.TargetAddressKey: model.getAddress() as AnyObject])

        let vc = DeviceDetailsTabBarController.create(with: model)!
        navigationController?.pushViewController(vc, animated: true)
      } else if let model = currentFavorite.dataModel as? SceneModel {

        // Arcus Analytics
        ArcusAnalytics.tag(AnalyticsTags.FavoritesClick, attributes: [:])
        ArcusAnalytics.tag(AnalyticsTags.FavoritesSceneClick,
                          attributes: [AnalyticsTags.TargetAddressKey: model.getAddress() as AnyObject])

        // Animate the scene icon
        if let favoriteCell =
          collectionView.cellForItem(at: indexPath) as? DashboardFavoriteItemCell {
          favoriteCell.isUserInteractionEnabled = false
          favoriteCell.alpha = 0.6

          let pressAnimation = CAKeyframeAnimation(keyPath: "transform")
          pressAnimation.timingFunction = CAMediaTimingFunction(
            controlPoints: 0.5, 0.5, 1.0, 1.0)
          pressAnimation.values = [
            NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.80, 0.80, 0.80)),
            NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.05, 1.05, 1.05)),
            NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.95, 0.95, 0.95)),
            NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 1.0))
          ]

          favoriteCell.layer.add(pressAnimation, forKey: nil)

          let delayTime = DispatchTime.now() + Double(Int64(
            3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
          DispatchQueue.main.asyncAfter(deadline: delayTime) {
            favoriteCell.isUserInteractionEnabled = true
            favoriteCell.alpha = 1.0
          }
        }

        // Fire scene
        DispatchQueue.global(qos: .background).async {
          SceneController.fire(on: model)
        }
      }
    }
  }
}

// MARK: UICollectionViewDataSource - Favorites
extension DashboardTwoViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let presenter = dashboardPresenter as? DashboardPresenter else { return 0 }

    return presenter.dashboardCurrentFavoritesCount()
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let id = DashboardCardIdentifier.favoriteItem
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)

    guard let presenter = dashboardPresenter as? DashboardPresenter,
      let favoriteCell = cell as? DashboardFavoriteItemCell,
      let favoriteIndex = dashboardPresenter?.viewModelIndexForType(.Favorites),
      let viewModel = presenter.viewModels[favoriteIndex] as? DashboardFavoriteViewModel else {
        return UICollectionViewCell()
    }

      let currentFavorite = viewModel.currentFavorites[indexPath.row]
      favoriteCell.label.text = currentFavorite.name
      favoriteCell.icon.image = currentFavorite.image

      return favoriteCell
  }
}

extension DashboardTwoViewController: WhatsNewPresenterConnectivityDelegate {
  func whatsNewIsPrepared(_ presenter: WhatsNewPresenter) {
    let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      guard self.navigationController?.topViewController == self else { return } // due to alarm or other VC
      if let whatsNew = WhatsNewInVersionTwo.create(withPresenter: presenter, container: self) {
        self.present(whatsNew, animated: true, completion: nil)
      } else {
        DDLogWarn("Unexpected behavior WhatsNewInVersionTwo could not be created")
      }
    }
  }

  func whatsNewIsNotNeeded(_ presenter: WhatsNewPresenter) {
    shouldPresentBiometricAuthPrompt()
  }
}

extension DashboardTwoViewController: WhatsNewViewControllerContainer {
  func didFinishDisplayOfWhatsNew() {
    shouldPresentBiometricAuthPrompt()
  }
}
