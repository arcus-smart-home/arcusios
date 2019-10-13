//
//  AlarmsLearnMoreViewController.swift
//  i2app
//
//  Created by Arcus Team on 3/8/17.
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

class AlarmsLearnMoreViewController: UIViewController, AlarmsLearnMorePresenterDelegate {
  var alarmType = AlarmType.Smoke
  var presenter: AlarmsLearnMorePresenterProtocol!

  // MARK: Outlets
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var viewTitle: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var deviceList: UILabel!
  @IBOutlet weak var deviceInfo: UILabel!
  @IBOutlet weak var shopButton: UIButton!
  @IBOutlet weak var deviceListCollapse: NSLayoutConstraint!

  @IBAction func shopButtonPressed(_ sender: AnyObject) {
    UIApplication.shared.open(URL(string: presenter.viewModel.buttonURL)!)
  }

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    presenter = AlarmsLearnMorePresenter(delegate: self)

    navBar(withTitle: presenter.navigationTitle(), enableBackButton: true)

    // Set the background of the view
    setBackgroundColorToDashboardColor()
    addDarkOverlay(BackgroupOverlayLightLevel)

    shouldUpdateViews()
  }

  func shouldUpdateViews() {
    let viewModel = presenter.viewModel

    image.image = UIImage(named: viewModel.imageName)
    viewTitle.text = viewModel.title
    subtitle.text = viewModel.subtitle
    deviceInfo.text = viewModel.deviceInfo
    shopButton.setTitle(viewModel.buttonTitle, for: UIControlState())
    deviceList.text = viewModel.deviceList

    if  viewModel.deviceList.isEmpty {
      deviceListCollapse.priority = 999
    } else {
      deviceListCollapse.priority = 200
    }
  }
}
