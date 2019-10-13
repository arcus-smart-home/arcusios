//
//  SlideMenuViewController.swift
//  i2app
//
//  Created by Arcus Team on 5/27/18.
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
import RxSwift
import RxCocoa
import Cornea

class SlideMenuViewController: UIViewController, SlideMenuPresenterProtocol {
  @IBOutlet weak var slideTableView: UITableView!

  var viewModel: SlideMenuViewModel = SlideMenuViewModel()
  var disposeBag: DisposeBag = DisposeBag()

  override var prefersStatusBarHidden: Bool {
    return true
  }

  // MARK: - Constructor

  class func create() -> SlideMenuViewController? {
    let sb: UIStoryboard = UIStoryboard(name: "SlideMenu", bundle: nil)
    guard let vc = sb.instantiateInitialViewController() as? SlideMenuViewController else {
      DDLogError("SlideMenu unavailable")
      return nil
    }
    return vc
  }

  // MARK: - View LifeCycle/UIViewController Overrides

  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindTableView()
    bindTableViewItemSelection()
    setupTableView()
    // Retrieve the user on the initial load
    retrieveTableHeaderPerson()
    observeCurrentPersonChanges()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.refresh()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    view.frame.size.width = revealViewController().rearViewRevealWidth
  }

  override func prefersHomeIndicatorAutoHidden() -> Bool {
    return true
  }

  // MARK: - UI Configuration

  private func setupTableView() {
    slideTableView.register(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: SlideMenuTableViewCell.cellIdentifier)
    setupTableViewFooter()
  }

  private func provideTableHeader() -> SlideMenuTableViewHeaderView? {
    guard let tableHeader = slideTableView.tableHeaderView as? SlideMenuTableViewHeaderView else {
      return nil
    }

    return tableHeader
  }

  private func setupTableViewFooter() {
    guard let tableFooter = slideTableView.tableFooterView as? SlideMenuTableViewFooterView else {
      return
    }

    tableFooter.setVersionInfo(versionString: BuildConfigure.clientVersion())
    tableFooter.setupLogoutButton()
    tableFooter.logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
  }

  private func bindTableView() {
    viewModel.menuModels.asObservable()
      .bind(to: slideTableView.rx
        .items(cellIdentifier: SlideMenuTableViewCell.cellIdentifier,
               cellType: SlideMenuTableViewCell.self)) {
                (_, model: SlideMenuModel, cell: SlideMenuTableViewCell) in

                cell.initializeCell(withModel: model)

      }.disposed(by: disposeBag)
  }

  private func bindTableViewItemSelection() {
    slideTableView.rx.itemSelected.map { index in
      return (index, self.viewModel.menuModels.value[index.row])
      }.subscribe({ [weak self] value in
        switch value {
        case .next(let indexPath, let slideMenuModel):
          self?.slideTableView.deselectRow(at: indexPath, animated: true)
          self?.performAction(slideMenuModel)
        default:
          break
        }
      }).disposed(by: disposeBag)
  }

  // MARK: - CurrentPerson Observation

  private func observeCurrentPersonChanges() {
    guard let settings = RxCornea.shared.settings as? RxArcusSettings else { return }
    
    settings.eventObservable.asObservable().filter {
      return $0 is CurrentPersonChangeEvent
      }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe { [weak self] _ in
        self?.retrieveTableHeaderPerson()
    }.disposed(by: disposeBag)
  }

  // MARK: -

  internal func performAction(_ model: SlideMenuModel) {
    guard let actionType = model.actionType else { return }
    
    guard let navController = self.revealViewController().frontViewController as? UINavigationController else {
      return
    }
    
    self.revealViewController().setFrontViewPosition(.left, animated: true)

    switch actionType {
    case .dashboard:
      ApplicationRoutingService.defaultService.showDashboard()
    case .present:
      guard let controller = model.actionObject as? UIViewController else { return }
      navController.present(controller, animated: true, completion: nil)
    case .evaluate:
      guard let value = model.actionObject as? SlideMenuEvaluation else { return }
      guard let vc = value.1 else { return }
      // we should only support push or present for now
      if value.0 == .push {
        navController.pushViewController(vc, animated: true)
      } else if value.0 == .present {
        navController.present(vc, animated: true, completion: nil)
      }
    case .push:
      guard let controller = model.actionObject as? UIViewController else { return }
      navController.pushViewController(controller, animated: true)
    case .url:
      guard let url = model.actionObject as? URL else { return }
      UIApplication.shared.open(url)
    default:
      break
    }
  }
  
  private func retrieveTableHeaderPerson() {
    guard let RxPersonLabel = provideTableHeader()?.personNameLabel.rx.text else { return }
    
    fetchPersonInfo().asObservable().filter {
      return $0 != nil
      }.map {
        if let firstName = $0?.firstName, !firstName.isEmpty {
        return "Hello, \(firstName)"
      } else {
        return ""
      }
    }.bind(to: RxPersonLabel).disposed(by: disposeBag)
  }
  
  @objc private func logout() {
    ArcusAnalytics.tag(AnalyticsTags.LeftSlidingMenuLogout, attributes: [:])
    
    revealViewController().revealToggle(self)
    
    CorneaHolder.shared.session?.logout()
  }
}
