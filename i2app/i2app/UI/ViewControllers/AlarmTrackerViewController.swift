//
//  AlarmTrackerViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/1/16.
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
import PureLayout

class AlarmTrackerViewController: UIViewController {
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var tableView: UITableView!
  @IBOutlet var confirmButton: ArcusIconButton!
  @IBOutlet var cancelButton: ArcusIconButton!
  @IBOutlet var placeLabel: ArcusLabel!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet var buttonsEqualWidth: NSLayoutConstraint!
  @IBOutlet var confirmButtonWidth: NSLayoutConstraint!
  @IBOutlet var confirmButtonLeadingWidth: NSLayoutConstraint!
  @IBOutlet var buttonContainerHeight: NSLayoutConstraint!
  @IBOutlet var proBadgeHeightContstraint: NSLayoutConstraint!
  @IBOutlet var proBadgeBottomSpaceContstraint: NSLayoutConstraint!
  @IBOutlet weak var offlineBannerContainer: UIView!
  @IBOutlet weak var offlineBannerLabel: ArcusLabel!

  var incidentPresenter: IncidentTrackerPresenter?
  var popupWindow: PopupSelectionWindow = PopupSelectionWindow()

  private var cancelPopUpViewController: CancelTrackerPopupViewController? =
    CancelTrackerPopupViewController.create()

  @IBAction func backButtonPressed(_ sender: Any) {
    // Check ig the hub is offline, if so present the pink offline warning screen
    if let presenter = incidentPresenter, presenter.isHubDown {
      presentOfflineWarning()
    } else {
      navigationController?.popViewController(animated: true)
    }
  }

  // MARK: View LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // TEMP: Workaround for tracker layout issue.
    collectionView.autoSetDimension(.height, toSize: 150)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    configureAlarmLayout(incidentPresenter)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    ArcusAnalytics.tag(named: AnalyticsTags.AlarmsTracker)
    configureAlarmLayout(incidentPresenter)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if isMovingFromParentViewController == true {
      incidentPresenter?.tearDown()
      incidentPresenter = nil
    }
  }

  // MARK: UI Configuration

  func configureAlarmLayout(_ presenter: IncidentTrackerPresenter?) {
    guard presenter != nil else {
      return
    }

    let buttonState = presenter!.incidentButtonState()

    configureNavigationTitle(presenter!.alarmTitle)
    configureButtonVisibility(buttonState)
    configureButtonColors(presenter!.incidentColor, buttonState: buttonState)
    configureButtonEnabledState(presenter!)
    configurePlaceLabel(presenter!.placeName)
    configureBackgroundTintColor(presenter!.incidentBackgroundColor)
    configureCollectionView(presenter!.trackerScrollingEnabled())
    configureTableView()
    configureProBadge(presenter!.proBadgeVisible)
    configureTrackerIndex(presenter!)
  }

  func configureNavigationTitle(_ title: String) {
    navBar(withBackButtonAndTitle: title)
  }

  func configureButtonVisibility(_ buttonState: IncidentTrackerButtonState) {
    switch buttonState {
    case .hidden:
      buttonContainerHeight.constant = 0
    case .cancel:
      buttonContainerHeight.constant = 75
      buttonsEqualWidth.isActive = false
      confirmButtonWidth.isActive = true
      confirmButtonWidth.constant = 0
      confirmButtonLeadingWidth.constant = 0
    case .cancelConfirm:
      buttonContainerHeight.constant = 75
      buttonsEqualWidth.isActive = true
      confirmButtonWidth.isActive = false
      confirmButtonWidth.constant = 300 // constraint is '<='
      confirmButtonLeadingWidth.constant = 16
    }
  }

  func configureButtonColors(_ color: UIColor, buttonState: IncidentTrackerButtonState) {
    switch buttonState {
    case .hidden:
      return
    case .cancel:
      cancelButton.backgroundColor = color
    case .cancelConfirm:
      confirmButton.backgroundColor = kProMonConfirmColor
      cancelButton.backgroundColor = kProMonCancelColor
    }
  }

  func configureButtonEnabledState(_ presenter: IncidentTrackerPresenter) {
    cancelButton.isEnabled = presenter.cancelButtonEnabled()
    confirmButton.isEnabled = presenter.confirmButtonEnabled()
  }

  func configurePlaceLabel(_ placeName: String) {
    placeLabel.text = placeName
  }

  func configureTrackerIndex(_ presenter: IncidentTrackerPresenter) {
    view.layoutIfNeeded()

    if presenter.alarmEvents != nil {
      if presenter.alarmEvents!.count > 2 && collectionView.numberOfItems(inSection: 0) > 2 {

        let indexPath = IndexPath(row: (presenter.alarmEvents?.count)! - 2, section: 0)

        if collectionView.numberOfItems(inSection: indexPath.section) > indexPath.row {
          collectionView.scrollToItem(at: indexPath,
                                      at: .centeredHorizontally,
                                      animated: true)
        }
      }
    }

    view.layoutIfNeeded()

    if let flowLayout = collectionView.collectionViewLayout as? AlarmTrackerCollectionViewFlowLayout {
      flowLayout.invalidateLayout()
    }
  }

  func configureBackgroundTintColor(_ color: UIColor) {
    backgroundView.backgroundColor = color
  }

  func configureCollectionView(_ scrollEnabled: Bool) {
    collectionView.isScrollEnabled = scrollEnabled
  }

  func configureTableView() {
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 70
  }

  func configureProBadge(_ visible: Bool) {
    if visible == false {
      proBadgeHeightContstraint.constant = 0
      proBadgeBottomSpaceContstraint.constant = 8
    } else {
      proBadgeHeightContstraint.constant = 14
      proBadgeBottomSpaceContstraint.constant = 16
    }
  }

  // MARK: IBActions

  @IBAction func confirmPressed(_ sender: AnyObject) {
    if let alarmEvents = incidentPresenter?.alarmEvents,
      let activeIndex = incidentPresenter?.alarmEventActiveIndex,
      let currentState = alarmEvents[activeIndex].name {
      ArcusAnalytics.tag(AnalyticsTags.AlarmsTrackerConfirmed,
                        attributes: [AnalyticsTags.TrackerState: currentState as AnyObject])
    }

    incidentPresenter?.confirm()
  }

  @IBAction func cancelPressed(_ sender: AnyObject) {
    if let alarmEvents = incidentPresenter?.alarmEvents,
      let activeIndex = incidentPresenter?.alarmEventActiveIndex,
      let currentState = alarmEvents[activeIndex].name {
      ArcusAnalytics.tag(AnalyticsTags.AlarmsTrackerCancelled,
                        attributes: [AnalyticsTags.TrackerState: currentState as AnyObject])
    }

    incidentPresenter?.cancel()
  }

  // MARK: Popup Handling

  func displayPopUp(_ title: String, subtitle: String) {
    cancelPopUpViewController?.configureCancelPopup(title: title, message: subtitle, closeBlock: {
      self.dismissPopup()

      // If the hub is offline then navigate back to the dashboard when closing the alarm tracker
      if let presenter = self.incidentPresenter, presenter.isHubDown {
        self.presentOfflineWarning()
      } else {
        self.dismissTracker()
      }
    })

    dismissPopup()

    popupWindow.container = view
    popupWindow.subview = cancelPopUpViewController
    popupWindow.owner = self
    popupWindow.displayCloseButton = false

    cancelPopUpViewController?.window = popupWindow

    popupWindow.open()
  }

  func dismissPopup() {
    if popupWindow.displaying == true {
      popupWindow.close()
    }
  }

  func contactSupport(_ sender: AnyObject!) {
    let phoneNo = "telprompt:+18445716006"
    if let phoneUrl = URL(string: phoneNo),
      UIApplication.shared.canOpenURL(phoneUrl) == true {
      UIApplication.shared.open(phoneUrl)
    }
  }

  fileprivate func presentOfflineWarning() {
    let storyboard = UIStoryboard(name: "AlarmOfflineWarning", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AlarmOfflineWarning")
    navigationController?.present(viewController, animated: true, completion: nil)
  }

  fileprivate func updateCollectionView(_ updateBlock: @escaping () -> Void) {
    guard collectionView != nil
      && incidentPresenter!.alarmEventActiveIndex >= 0
      else { return }

    self.collectionView.performBatchUpdates({
      updateBlock()
    }, completion: {
      _ in
    })
  }
}

// MARK: UICollectionViewDataSource

extension AlarmTrackerViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    guard let alarmEvents = incidentPresenter?.alarmEvents else {
      return 0
    }
    return alarmEvents.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                         for: indexPath) as? AlarmTrackerCollectionViewCell else {
                                          return AlarmTrackerCollectionViewCell()
    }

    if let presenter: IncidentTrackerPresenter = incidentPresenter {
      let viewModel: AlarmTrackerStateViewModel = presenter.alarmEvents![indexPath.row]

      cell.stateLabel.text = viewModel.name
      cell.stateView.activeColor = viewModel.activeColor
      cell.stateView.inactiveColor = viewModel.inactiveColor
      cell.stateView.activeIconState = viewModel.ringStateActive
      cell.stateView.inactiveIconState = viewModel.ringStateInactive
      cell.stateView.leftSegmentActiveType = viewModel.leftSegmentActiveType
      cell.stateView.leftSegmentInactiveType = viewModel.leftSegmentInactiveType
      cell.stateView.rightSegmentActiveType = viewModel.rightSegmentActiveType
      cell.stateView.rightSegmentInactiveType = viewModel.rightSegmentActiveType
      cell.stateView.iconName = viewModel.iconName
      cell.stateView.stateIcon.attributedText = viewModel.attributedCountdownText()
      if viewModel.beginHidden {
        cell.opacity = 0.0
      } else {
        cell.opacity = 1.0
      }
    }
    return cell
  }
}

extension AlarmTrackerViewController: UICollectionViewDelegate {
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    if let fl = collectionView.collectionViewLayout as? AlarmTrackerCollectionViewFlowLayout {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
        fl.invalidateLayout()
      })
    }
  }
}

// MARK: UITableViewDataSource

extension AlarmTrackerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let rows: Int = incidentPresenter?.alarmHistory?.count else {
      return 0
    }
    return rows
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      as? ArcusTitleDetailTableViewCell else {
        let cell = ArcusTitleDetailTableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    cell.backgroundColor = UIColor.clear
    cell.selectionStyle = .none

    if let viewModel: AlarmTrackerHistoryViewModel = incidentPresenter?.alarmHistory?[indexPath.row] {
      cell.accessoryLabel.text = viewModel.timestamp
      if viewModel.iconName != "" {
        cell.accessoryImage.image = UIImage(named: viewModel.iconName)
        cell.accessoryImageWidth.constant = 16
        cell.accessoryImageTrailingSpace.constant = 35
      } else {
        cell.accessoryImageWidth.constant = 0
        cell.accessoryImageTrailingSpace.constant = 0
      }
      cell.titleLabel.text = viewModel.name
      cell.descriptionLabel.text = viewModel.description
    }

    return cell
  }
}

// MARK: AlarmTrackerDelegate

extension AlarmTrackerViewController: IncidentTrackerDelegate {
  func updateLayout() {
    guard collectionView != nil else { return }
    configureAlarmLayout(self.incidentPresenter)

    // Set up views for the offline warning
    configureOfflineBanner()
  }

  fileprivate func configureOfflineBanner() {
    if let presenter = incidentPresenter, presenter.isHubDown {
      offlineBannerContainer.isHidden = false
      offlineBannerLabel.text = presenter.offlineBannerText
    } else {
      offlineBannerContainer.isHidden = true
      offlineBannerLabel.text = ""
    }
  }

  func updateTracker() {
    updateCollectionView({
      _ in
      self.collectionView.reloadSections(IndexSet(integer: 0))
      self.configureTrackerIndex(self.incidentPresenter!)
    })
  }

  func updateHistory() {
    guard tableView != nil else { return }

    tableView.reloadData()
  }

  func updateCountdown() {
    updateCollectionView({
      _ in
      let reloadPath: IndexPath =
        IndexPath(row: self.incidentPresenter!.alarmEventActiveIndex, section: 0)
      if self.collectionView.numberOfItems(inSection: reloadPath.section) > reloadPath.row {
        self.collectionView.reloadItems(at: [reloadPath as IndexPath])
      }
    })
  }

  func fullLayoutRefresh() {
    updateTracker()
    updateHistory()
    updateCountdown()
    updateLayout()
  }

  func dismissTracker() {
    self.navigationController?.popViewController(animated: true)
  }

  func showClearingPopup(_ title: String, message: String) {
    self.displayPopUp(title, subtitle: message)
  }
}
