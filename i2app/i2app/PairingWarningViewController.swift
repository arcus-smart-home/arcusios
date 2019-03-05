//
//  PairingWarningViewController.swift
//  i2app
//
//  Created by Arcus Team on 7/23/18.
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
import RxCocoa

protocol PairingWarningDelegate: class {
  func shouldTransitionToActivation()
  func shouldTransitionToImproperlyPaired()
}

class PairingWarningViewController: UIViewController, PairingWarningPresenter {
 
  // MARK: Properties
  
  var disposeBag = DisposeBag()
  var pairingWarningViewModel = PairingWarningViewModel()
  var delegate: PairingWarningDelegate?
  
  // MARK: IBOutlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  // MARK: Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViews()
    fetchPairingWarningSectionData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let pairingCart = segue.destination as? PairingCartViewController {
      pairingCart.startSearchingOnLoad = false
    }
  }

  // MARK: IBActions
  
  @IBAction func notNowButtonPressed(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: Privata Functions
  
  private func configureViews() {
    bindTableView()
    makeTableViewHeightDynamic()
    
    tableView.tableFooterView = UIView()
  }
  
  private func bindTableView() {
    pairingWarningViewModel.sections.asObservable()
      .bind(to: tableView.rx
        .items(cellIdentifier: "PairingWarningSectionCell",
               cellType: PairingWarningSectionCell.self)) { [weak self]
                (_, viewModel: PairingWarningSectionViewModel, cell: PairingWarningSectionCell) in
    
                cell.titleLabel.text = viewModel.sectionTitle
                cell.descriptionLabel.text = viewModel.sectionDescription
                cell.actionButton.setTitle(viewModel.buttonTitle, for: .normal)
                cell.buttonAction = {
                  self?.handleSectionCellButtonAction(sectionType: viewModel.sectionType)
                }
      }.disposed(by: disposeBag)
  }
  
  private func handleSectionCellButtonAction(sectionType: PairingWarningSectionType) {
    // Exit early if the user is attempting to activate devices and the hub is offline.
    if !isHubOnline() && sectionType == .activation {
      performSegue(withIdentifier: "HubOfflineSegue", sender: self)
      return
    }
    
    dismiss(animated: true) { [weak self] in
      switch sectionType {
      case .activation:
        self?.delegate?.shouldTransitionToActivation()
      case .improperlyPaired:
        self?.delegate?.shouldTransitionToImproperlyPaired()
      }
    }
  }
  
  private func makeTableViewHeightDynamic() {
    tableView.rx.observe(UICollectionView.self, "contentSize")
      .subscribeOn(MainScheduler.instance)
      .subscribe({ [weak self] _ in
        self?.tableViewHeight.constant = self?.tableView.contentSize.height ?? 0
      })
      .disposed(by: disposeBag)
  }
  
}
