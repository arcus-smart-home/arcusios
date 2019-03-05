//
//  CameraClipsViewController.swift
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
import SDWebImage
import AVKit
import Reachability
import CocoaLumberjack
import RxSwift
import RxCocoa

class CameraClipsViewController: UIViewController {
  @IBOutlet weak var segmentedControl: ArcusSegmentedControl!
  var presenter: CameraClipsPresenterProtocol?
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var filterBar: UIView!
  @IBOutlet weak var filterLabel: UILabel!
  @IBOutlet weak var filterTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
  var maxHeaderHeight: CGFloat = 0
  var minHeaderHeight: CGFloat = -64
  var previousScrollOffset: CGFloat = 0
  @IBOutlet weak var errorBanner: ScleraBannerView!
  @IBOutlet weak var errorBannerHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var showPinnedClipsOnlyLabel: UILabel!
  @IBOutlet weak var pinnedOnlySwitch: UISwitch!
  @IBOutlet weak var downloadBar: UIView!
  var downloadBarHeightDefault: CGFloat = 0.0
  var errorBannerHeightDefault: CGFloat = 0.0
  @IBOutlet weak var downloadBarHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var downloadProgressView: UIProgressView!
  @IBOutlet weak var downloadCancelButton: UIButton!
  var avPlayerViewController: AVPlayerViewController?
  var avPlayer: AVQueuePlayer?
  var refreshControl: UIRefreshControl!
  var loadingIndicatorTag: Int =  NSNotFound
  var playerItemContext: Int = 0
  fileprivate var reach: Reachability!
  fileprivate var isOnWifi: Bool = false
  fileprivate var downloadCellIndexPath: IndexPath?
  fileprivate var popupWindow: PopupSelectionWindow?

  fileprivate let headerIdentifier = "sectionHeader"
  fileprivate var disposeBag: DisposeBag = DisposeBag()
  var activeIndexPath: IndexPath?
  
  class func create() -> CameraClipsViewController {
    let sb: UIStoryboard = UIStoryboard(name: "CameraCard", bundle:nil)
    let vc = sb.instantiateViewController(withIdentifier: "CameraClipsViewController")
      as? CameraClipsViewController
    return vc!
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
    removePlayerObservers()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navBar(withTitle: navigationItem.title, enableBackButton: true)
    configureTableView()
    configureDownloadBar()
    configureHeader()
    configureReachability()
    configureErrorBanner()
    
    let playerDidFinishPlaying = #selector(CameraClipsViewController.playerDidFinishPlaying(_:))
    NotificationCenter.default.addObserver(self,
                                           selector:playerDidFinishPlaying,
                                           name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                           object: nil)
    guard let placeId = RxCornea.shared.settings?.currentPlace?.modelId else {
      return
    }
    presenter = CameraClipsPresenter(delegate: self, placeId: placeId)
    
    bindPinnedSwitchToPremiumStatus()
    bindPinnedSwitchLabelToPremiumStatus()
    // Call to update the quota limit/used
    presenter?.fetchQuota() { }
  }

  @objc fileprivate func playerDidFinishPlaying(_ note: Notification) {
    safelyDismissAVPlayerViewController()
  }
  
  func configureTableView() {
    tableView.estimatedRowHeight = 268.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.register(UINib.init(nibName: "ArcusTwoLabelTableViewSectionHeader", bundle: nil),
                       forHeaderFooterViewReuseIdentifier: headerIdentifier)
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.white
    refreshControl.backgroundColor = UIColor.clear
    refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    refreshControl.beginRefreshing()
    if #available(iOS 10.0, *) {
      tableView.refreshControl = refreshControl
    } else {
      tableView.backgroundView = refreshControl
    }
  }

  func configureDownloadBar() {
    downloadBarHeightDefault = downloadBarHeightConstraint.constant
    // hide download bar on startup
    self.downloadBar.isHidden = true
    self.downloadBarHeightConstraint.constant = 0
    self.downloadBar.layoutIfNeeded()
    DispatchQueue.main.async {
      self.presenter?.fetchDownloadData()
    }
  }
  
  func configureErrorBanner() {
    errorBannerHeightDefault = errorBannerHeightConstraint.constant
    hideErrorBanner()
  }

  func configureHeader() {
    minHeaderHeight = headerHeightConstraint.constant * -1
  }

  func configureReachability() {
    reach = Reachability.forInternetConnection()
    // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
    reach.reachableOnWWAN = false
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(reachabilityChanged(_:)),
      name: NSNotification.Name.reachabilityChanged,
      object: nil
    )
    reach.startNotifier()
    if reach.isReachableViaWiFi() {
      isOnWifi = true
    }
  }

  @objc fileprivate func reachabilityChanged(_ note: Notification) {
    if reach.isReachableViaWiFi() {
      isOnWifi = true
    } else {
      isOnWifi = false
    }
  }

  func updateHeader() {
    //TODO: polish can be added to the header here
    let range = self.maxHeaderHeight - self.minHeaderHeight
    let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
    _ = openAmount / range
  }
  
  // Bind pinned switch to premium status obserable
  private func bindPinnedSwitchToPremiumStatus() {
    presenter?.fetchPremiumStatus()
      .map { status in
        return !status
      }
      .bind(to: pinnedOnlySwitch.rx.isHidden)
    .disposed(by: disposeBag)
  }
  
  private func bindPinnedSwitchLabelToPremiumStatus() {
    presenter?.fetchPremiumStatus()
      .map { status in
        return status ? "Show Pinned Clips Only" : "View Clips Below"
    }
    .bind(to: showPinnedClipsOnlyLabel.rx.text)
    .disposed(by: disposeBag)
  }
  
  fileprivate func bindCellPinButtonToPremiumStatus(cell: CameraClipTableViewCell, rowData: ClipItem) {
    presenter?.fetchPremiumStatus()
      .subscribe(onNext: { status in
        if status {
          cell.pinButton.addSpringAnimation()
          if rowData.isPinned {
            cell.pinButton.setImage(#imageLiteral(resourceName: "PinFilled"), for: .normal)
            cell.pinButton.setImage(#imageLiteral(resourceName: "PinLined"), for: .highlighted)
          } else {
            cell.pinButton.setImage(#imageLiteral(resourceName: "PinFilled"), for: .highlighted)
            cell.pinButton.setImage(#imageLiteral(resourceName: "PinLined"), for: .normal)
          }
        } else {
          cell.pinButton.isHidden = true
        }
      })
    .disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configureSegmentedControl(self.tabBarController)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.hideLoadingIndicator()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateHeader()
    if presenter?.hasSetup == false {
      presenter?.fetchNextData()
    }
    handleAVPlayersDidClose(withLogging: true)
  }

  func refresh(_ sender: Any?) {
    self.presenter?.fetchTopData()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
      self.refreshControl.endRefreshing()
    })
  }
  
  @IBAction func isPinnedToggled(_ sender: UISwitch) {
    if let presenter = presenter {
      let newFilter = ClipFilter(cameraFilter: presenter.filter.cameraFilter,
                                 timeFilter: presenter.filter.timeFilter,
                                 pinnedOnly: sender.isOn)
      presenter.filter = newFilter
    }
  }

  @IBAction func cancelDownloadPressed(_ sender: UIButton) {
    presenter?.cancelDownloadPressed()
  }
}

extension CameraClipsViewController {
  static let segueToShowFilters = "ShowFilters"
  static let segueToClipExpiredPopup = "ClipExpiredPopupSegue"
  static let allSeguesIdentifiers = [segueToShowFilters]

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let presenter = self.presenter,
      let settings = RxCornea.shared.settings else {
        DDLogError("Fatal programming error")
        return
    }
    
    if let identifier = segue.identifier,
    identifier == CameraClipsViewController.segueToShowFilters,
      let vc: CameraClipsFilterViewController = segue.destination as? CameraClipsFilterViewController {
      vc.selectedTimeFilter = presenter.filter.timeFilter
      vc.selectedCameraFilter = presenter.filter.cameraFilter
      vc.premiumStatusBool = settings.isPremiumAccount()
      vc.delegate = self
    } else if let identifier = segue.identifier,
      identifier == CameraClipsViewController.segueToClipExpiredPopup,
      let vc: ClipExpiredPopup = segue.destination as? ClipExpiredPopup {
      vc.delegate = self
      vc.activePath = activeIndexPath
    }
  }
  
  func showErrorBanner() {
    self.errorBannerHeightConstraint.constant = self.errorBannerHeightDefault
    self.errorBanner.show()
    self.errorBanner.layoutIfNeeded()
  }
  
  func hideErrorBanner() {
    self.errorBannerHeightConstraint.constant = 0
    self.errorBanner.hide()
    self.errorBanner.layoutIfNeeded()
  }
}

extension CameraClipsViewController: ArcusTabBarComponent {
  @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
    tabSegmentedControlValueChanged(sender)
  }
}

extension CameraClipsViewController: CameraPlaybackViewController {
  override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                             change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    handleNotification(forKeyPath: keyPath, of: object, change: change, context: context)
  }
}

extension CameraClipsViewController: SimpleTableViewGenericPresenterDelegate {

  func updateLayout() {
    DispatchQueue.main.async {
      self.handleRefreshControl()
      guard let tableView = self.tableView,
        let presenter = self.presenter,
      let settings = RxCornea.shared.settings else {
        return
      }
      tableView.reloadData()
      var title = "Filter"
      if presenter.filter.selectedFacetCount > 0 && settings.isPremiumAccount() == true {
        title += " (\(presenter.filter.selectedFacetCount))"
      }
      self.filterLabel.text = title
      self.scrollViewDidScroll(self.tableView)
    }
  }

  func updateAtIndexPath(_ indexPath: IndexPath) {
    DispatchQueue.main.async {
      self.handleRefreshControl()
      guard let tableView = self.tableView else {
        return
      }
      //only reload Rows if the row is visible
      if let found = tableView.indexPathsForVisibleRows?.filter({$0 == indexPath}).count,
        found > 0,
        let clip = self.presenter?.sections[safe: indexPath.section]?.items[safe: indexPath.row],
        let cell = self.tableView.cellForRow(at: indexPath) as? CameraClipTableViewCell {
        _ = self.bind(cell, toClipItem: clip)
      }
    }
  }

  private func handleRefreshControl() {

    func addRefreshControl() {
      if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
      } else {
        tableView.backgroundView = refreshControl
      }
    }

    func removeRefreshControl() {
      if #available(iOS 10.0, *) {
        tableView.refreshControl = nil
      } else {
        tableView.backgroundView = nil
      }
    }

    if let presenter = presenter,
      presenter.hasSetup {
      addRefreshControl()
      self.refreshControl.endRefreshing()
    } else {
      removeRefreshControl()
    }
  }

  func handleFilterControl() {

  }
}

extension CameraClipsViewController: UITableViewDelegate {

  public func tableView(_ tableView: UITableView,
                        willDisplay cell: UITableViewCell,
                        forRowAt indexPath: IndexPath) {
    guard let sections = presenter?.sections,
        sections.count != 0 else {
      // display the no clips cell
      return
    }
    if tableView.isLast(index: indexPath, offset: 5) {
      presenter?.fetchNextData()
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let sections = presenter?.sections else {
      DDLogError("Fatal Error in presenter")
      return 0
    }
    if sections.count == 0 {
      // display the no clips cell
      return 0
    }
    return 32
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let presenter = presenter else {
      DDLogError("Fatal Error in presenter")
      return nil
    }
    if !presenter.hasSetup || presenter.sections.count == 0 {
      return nil
    }
    if let tableHeader =
      tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
        as? ArcusTwoLabelTableViewSectionHeader,
      let title = presenter.sections[safe: section]?.title {
      tableHeader.mainTextLabel.text = title
      tableHeader.accessoryTextLabel.text = nil
      tableHeader.hasBlurEffect = true
      return tableHeader
    }
    return nil
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset

    let absoluteTop: CGFloat = 0
    let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height

    let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
    let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

    if canAnimateHeader(scrollView) {

      // Calculate new header height
      var newHeight = self.filterTopConstraint.constant
      if isScrollingDown {
        newHeight = max(self.minHeaderHeight, self.filterTopConstraint.constant - abs(scrollDiff))
      } else if isScrollingUp {
        newHeight = min(self.maxHeaderHeight, self.filterTopConstraint.constant + abs(scrollDiff))
      }

      // Header needs to animate
      if newHeight != self.filterTopConstraint.constant {
        self.filterTopConstraint.constant = newHeight
        self.updateHeader()
        self.setScrollPosition(self.previousScrollOffset)
      }

      self.previousScrollOffset = scrollView.contentOffset.y
    } else {
      self.filterTopConstraint.constant = self.maxHeaderHeight
    }
  }

  fileprivate func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
    // Calculate the size of the scrollView when header is collapsed
    let scrollViewMaxHeight = scrollView.frame.height + self.filterTopConstraint.constant - minHeaderHeight

    // Make sure that when header is collapsed, there is still room to scroll
    return scrollView.contentSize.height > scrollViewMaxHeight
  }
  
  func setScrollPosition(_ position: CGFloat) {
    self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
  }
}

extension CameraClipsViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let presenter = presenter else {
      DDLogError("Fatal Error in presenter")
      return 0
    }
    if !presenter.hasSetup {
      return 0
    } else if presenter.sections.count == 0 {
      // display the no clips cell
      return 1
    } else {
      return presenter.sections.count
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let presenter = presenter else {
      DDLogError("Fatal Error in presenter")
      return 0
    }
    if !presenter.hasSetup {
      return 0
    } else if presenter.sections.count == 0 {
      // display the no clips cell
      return 1
    }
    guard let items = presenter.sections[safe: section]?.items else {
      DDLogError("Fatal Error in view controller logic")
      return 0
    }
    return items.count
  }

  fileprivate func bind(_ cell: CameraClipTableViewCell, toClipItem rowData: ClipItem) -> UITableViewCell {
    cell.delegate = self
    cell.videoMetaDataLabel.text = rowData.recordingModel.recordDateAndDuration()
    if let presenter = presenter,
      let cameraID = rowData.recordingModel.cameraID(),
      let cameraName = presenter.getDeviceName(for: cameraID)
    {
      cell.videoCameraName.text = cameraName
      cell.videoCameraName.isHidden = false
      cell.videoCameraNameLabelTopConstraint.constant = 8
    } else {
      cell.videoCameraName.isHidden = true
      cell.videoCameraName.text = nil
      cell.videoCameraNameLabelTopConstraint.constant = 0
    }
    cell.videoImage.sd_cancelCurrentImageLoad()
    cell.videoImage.image = nil
    if !rowData.isPinned {
        if let expirationTime = cell.getVideoExpirationTimeString(withEndDate: rowData.recordingModel.deleteTime()) {
          cell.videoExpirationLabel.text = expirationTime
          cell.videoExpirationLabel.isHidden = false
      }
    } else {
      cell.videoExpirationLabel.isHidden = true
      cell.videoExpirationLabel.text = nil
    }
    self.bindCellPinButtonToPremiumStatus(cell: cell, rowData: rowData)
    if let url = rowData.previewURL {
      cell.videoImage.sd_setImage(with: url)
      cell.previewUnavailableLabel.isHidden = true
    } else {
      cell.previewUnavailableLabel.isHidden = false
    }
    return cell
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let presenter = presenter else {
      DDLogError("Fatal Error in presenter")
      return UITableViewCell()
    }
    if !presenter.hasSetup {
      DDLogError("Fatal Error, no cells should display before setup")
      return UITableViewCell()
    }
    if presenter.sections.count == 0 {
      // display the no clips cell
      let noclipsCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CameraClipsNoClipsCell
      if presenter.filter.selectedFacetCount == 0 {
        noclipsCell.warningLabel.text = NSLocalizedString("You have no video clips", comment: "")
      } else {
        noclipsCell.warningLabel.text = NSLocalizedString("You have no video clips for the selected filter. "
          + "Check filter above for more options.", comment: "")
      }
      return noclipsCell
    }
    
    guard let clip = presenter.sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
      DDLogError("Fatal Error in presenter")
      return UITableViewCell()
    }
    
    let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CameraClipTableViewCell
    return bind(cell, toClipItem:clip)
  }
}

extension CameraClipsViewController: CameraClipTableViewCellDelegate {
  func playButtonPressed(onCell: CameraClipTableViewCell) {
    if let idx = tableView.indexPath(for: onCell) {
      presenter?.playPressed(atIndexpath: idx)
    }
  }
  func deleteButtonPressed(onCell: CameraClipTableViewCell) {
    if let idx = tableView.indexPath(for: onCell) {
      presenter?.deletePressed(atIndexpath: idx)
    }
  }

  func completeDownload() {
    if let idx = downloadCellIndexPath {
      presenter?.downloadPressed(atIndexpath: idx)
      downloadCellIndexPath = nil
    }
  }

  func displayConfirmDownloadPopup() {
    if popupWindow?.displaying == true {
      popupWindow?.close()
    }
    let popupStyle = PopupWindowStyleMessageWindow

    let yesButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("Yes", comment: ""),
                                       event: #selector(performDownload(_:)))
    let noButton: PopupSelectionButtonModel =
      PopupSelectionButtonModel.create(NSLocalizedString("Cancel", comment: ""),
                                       event: #selector(closePopup(_:)))

    let buttonView: PopupSelectionButtonsView =
      PopupSelectionButtonsView.create(withTitle: "Cellular Connection",
                                       subtitle: "You are on a cellular connection. Data charges may apply. Do you wish to continue?",
                                       buttons: [noButton, yesButton])
    buttonView.owner = self

    popupWindow = PopupSelectionWindow.popup(view,
                                             subview: buttonView,
                                             owner: self,
                                             displyCloseButton: false,
                                             close: #selector(closePopup(_:)),
                                             style: popupStyle)

  }

  func closePopup(_ sender: AnyObject!) {}

  func performDownload(_ sender: AnyObject!) {
    completeDownload()
  }

  func downloadButtonPressed(onCell: CameraClipTableViewCell) {
    downloadCellIndexPath = tableView.indexPath(for: onCell)
    if isOnWifi {
      completeDownload()
    } else {
      displayConfirmDownloadPopup()
    }
  }

  func pinButtonPressed(onCell: CameraClipTableViewCell) {
    guard let idx = self.tableView.indexPath(for: onCell),
      let presenter = self.presenter,
      let section = presenter.sections[safe: idx.section],
      let clip = section.items[safe: idx.row] else {
        return
    }
    
    // Check if the clip is pinned..
    if clip.isPinned {
      // If the clip has expired, show our popup
      self.showAlertIfExpired(indexPath: idx) { status in
        if !status {
          // If our status is false, unpin the clip and show the video expiration label
          presenter.pinPressed(atIndexpath: idx)
          onCell.videoExpirationLabel.isHidden = !onCell.videoExpirationLabel.isHidden
        }
      }
      return
    }
    
    // Create a dispatch group to wait for the quota report to update
    // then execute the logic once finished
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    presenter.fetchQuota() {
      dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) {
      if presenter.favoriteQuotaUsed < presenter.favoriteQuotaLimit {
        // Check for unpinning an expired clip
        presenter.pinPressed(atIndexpath: idx)
        onCell.videoExpirationLabel.isHidden = !onCell.videoExpirationLabel.isHidden
      } else {
        // Hide the animation via timer after 3 seconds
        self.showErrorBanner()
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
          self?.hideErrorBanner()
        })
      }
    }
  }
  
  func showAlertIfExpired(indexPath: IndexPath, completion: (Bool) -> Void) {
    guard let section = presenter?.sections[safe: indexPath.section],
      let clip = section.items[safe: indexPath.row] else {
        completion(true)
        return
    }
    
    self.activeIndexPath = indexPath
    
    if clip.isPinned && clip.recordingModel.isVideoExpired() {
      // The user is unpinning a clip that has expired.. display the popup
      self.performSegue(withIdentifier: CameraClipsViewController.segueToClipExpiredPopup, sender: self)
      completion(true)
      return
    } else {
      completion(false)
    }
  }
}

extension CameraClipsViewController: CameraClipsPresenterDelegate {

  func shouldPopupMessage(_ title: String, subtitle: String) {
    self.popupMessageWindow(title, subtitle: subtitle)
  }

  func shouldPopupErrorWindow(_ title: String, subtitle: String) {
    self.popupErrorWindow(title, subtitle: subtitle)
  }

  func shouldDisplayGenericErrorMessage() {
    self.displayGenericErrorMessage()
  }

  func hideProgressBanner() {
    UIView.animate(withDuration: 0.2, animations: {
      self.downloadBar.isHidden = true
      self.downloadBarHeightConstraint.constant = 0
    })
  }

  func showProgressBanner() {
    self.downloadProgressView.progress = 0.0
    UIView.animate(withDuration: 0.2, animations: {
      self.downloadBar.isHidden = false
      self.downloadBarHeightConstraint.constant = self.downloadBarHeightDefault
    })
  }

  func updateProgressBanner(_ value: Float) {
    var updatedValue = value
    if value < 0.01 {
      updatedValue = 0.01
    }
    self.downloadProgressView.progress = updatedValue
  }

  func showProgress(_ progress: Float) {
    guard viewIfLoaded != nil else {
      return
    }
    if progress < 0.0 {
      hideProgressBanner()
    } else if progress == 0.0 {
      showProgressBanner()
    } else {
      updateProgressBanner(progress)
    }
  }
}

extension CameraClipsViewController: CameraClipsFilterViewControllerDelegate {
  
  func didApplyFilters(withViewController filterVC: CameraClipsFilterViewController) {
    guard let presenter = presenter else {
      DDLogError("Fatal Error in presenter")
      return
    }
    let clipFilter = ClipFilter(cameraFilter: filterVC.selectedCameraFilter,
                                timeFilter: filterVC.selectedTimeFilter,
                                pinnedOnly: pinnedOnlySwitch.isOn)
    presenter.filter = clipFilter
    self.dismiss(animated: true, completion: nil)
  }
  
  func didCancelFilters(withViewController  filterVC: CameraClipsFilterViewController) {
    self.dismiss(animated: true, completion: nil)
  }
}

extension CameraClipsViewController: ClipExpiredPopupDelegate {
  func handleClipExpiredResponseYes(path: IndexPath?) {
    if let path = path {
      presenter?.deletePressed(atIndexpath: path)
    }
  }
}
