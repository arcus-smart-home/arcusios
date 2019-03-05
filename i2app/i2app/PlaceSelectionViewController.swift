//
//  PlaceSelectionViewController.swift
//  i2app
//
//  Created by Arcus Team on 12/18/17.
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

/**
 This view controller presents a list of the available places. The user is allowed to select a place,
 prompting the view to switch places and dismiss itself.
 */
class PlaceSelectionViewController: UIViewController {

  /**
   View used to show the available places for the current user.
   */
  @IBOutlet weak var tableView: UITableView!

  /**
   Loading overlay shown when switcing places.
   */
  @IBOutlet weak var loadingView: ScleraLoadingView!

  /**
   Presenter used to fetch data.
   */
  var presenter: PlaceSelectionPresenterProtocol?

  /**
   Button used to dismiss the view.
   */
  @IBAction func closeButtonPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter = PlaceSelectionPresenter(delegate: self)
    presenter?.fetchPlaces()
  }
  
}

// MARK: PlaceSelectionPresenterDelegate

extension PlaceSelectionViewController: PlaceSelectionPresenterDelegate {
  func shouldUpdatePlaces() {
    tableView.reloadData()
  }
  
  func placeChangeDidSucceed() {
    self.loadingView.hide()
    self.dismiss(animated: true, completion: nil)
  }
  
  func placeChangeDidFail() {
    dismiss(animated: true, completion: nil)
  }
}

// MARK: UITableViewDelegate

extension PlaceSelectionViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presenter = presenter,
      presenter.placesAvailable.count > indexPath.row else {
        return
    }
    
    ArcusAnalytics.tag(named: AnalyticsTags.DashboardPlaceSelect)
    
    let place = presenter.placesAvailable[indexPath.row]
    if place.isSelected {
      dismiss(animated: true, completion: nil)
    } else {
      loadingView.show()
      presenter.changePlace(withPlaceId: place.identifier)
    }
  }
}

// MARK: UITableViewDataSource

extension PlaceSelectionViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let presenter = presenter else {
      return 0
    }
    
    return presenter.placesAvailable.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "PlaceSelectionCell") as? PlaceSelectionTableViewCell,
      let presenter = presenter,
      presenter.placesAvailable.count > indexPath.row else {
      
        return UITableViewCell()
    }
    
    let viewModel = presenter.placesAvailable[indexPath.row]
    
    cell.titleLabel.text = viewModel.title
    cell.descriptionLabel.text = viewModel.description
    cell.placeImageView.image = viewModel.image
    cell.indicatorImageView.isHighlighted = viewModel.isSelected
    
    return cell
  }
}
