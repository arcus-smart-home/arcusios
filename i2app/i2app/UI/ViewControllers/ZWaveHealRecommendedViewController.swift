//
//  ZWaveHealRecommendedViewController.swift
//  i2app
//
//  Arcus Team on 9/20/16.
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

open class ZWaveHealRecommendedViewController: UIViewController {

  @IBOutlet weak var rebuildNow: UIButton!
  @IBOutlet weak var rebuildLater: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  var popupWindow: PopupSelectionWindow?

  open static func create () -> UIViewController {
    let zWaveToolsStoryboard = UIStoryboard(name: "ZWaveTools", bundle: nil)
    return zWaveToolsStoryboard
      .instantiateViewController(withIdentifier: "ZWaveHealRecommendedViewController")
  }

  override open func viewDidLoad() {

    configureLabels()
    configureButtons()
    configureBackground()
    configureNavBar()
  }

  @IBAction func onRebuildLater(_ sender: AnyObject) {
    let title = "ARE YOU SURE?"
    let subtitle = "Your Z-Wave devices may not work optimally until "
      + "the Z-Wave network rebuild process is completed."

    var buttons: [PopupSelectionButtonModel] = [PopupSelectionButtonModel]()
    buttons.append(PopupSelectionButtonModel.create("YES",
                                                    event: #selector(onUserCancelled(_:)), obj: nil))
    buttons.append(PopupSelectionButtonModel.create("NO",
                                                    event: #selector(onUserDidNotCancel(_:)), obj: nil))

    if let buttonView = PopupSelectionButtonsView.create(withTitle: title,
                                                         subtitle: subtitle,
                                                         buttons: buttons) {
      buttonView.owner = self
      popupWindow = PopupSelectionWindow.popup(self.view,
                                               subview: buttonView,
                                               owner: self,
                                               close: nil,
                                               style: PopupWindowStyleCautionWindow)
    }
  }

  @IBAction func onRebuildNow(_ sender: AnyObject) {
    let nextViewController = ZWaveHealProgressViewController.createAndStartRebuild()
    self.navigationController?.pushViewController(nextViewController, animated: true)
  }

  fileprivate func configureLabels () {
    let title = "Z-Wave Network \n Rebuild Recommended"
    let description = "One or more Z-Wave devices were paired. "
      + "\n Z-Wave devices in your home link together to \n form a network. If devices are added, "
      + "\n relocated or removed, the network will need \n to be rebuilt. \n\n Ensure your devices "
      + "are placed in their final \n installation location. \n\n Choose Rebuild Now when you have "
      + "finished \n pairing all of your devices."

    titleLabel
      .attributedText = NSAttributedString(string: title,
                                           attributes:[NSFontAttributeName: UIFont(name: "AvenirNext-Medium",
                                                                                   size: 18.0)!,
                                                       NSKernAttributeName: 0.0,
                                                       NSForegroundColorAttributeName: UIColor.white])

    descriptionLabel
      .attributedText = NSAttributedString(string:  description,
                                           attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium",
                                                                                    size: 14.0)!,
                                                        NSKernAttributeName: 0.0])

  }

  fileprivate func configureButtons () {
    rebuildNow.styleSet("REBUILD NOW", andButtonType: FontDataTypeButtonLight, upperCase: true)
    rebuildLater.styleSet("REBUILD LATER", andButtonType: FontDataTypeButtonLight, upperCase: true)
  }

  fileprivate func configureNavBar() {
    self.navBar(withTitle: "Z-WAVE NETWORK REBUILD")
  }

  fileprivate func configureBackground () {
    self.setBackgroundColorToDashboardColor()
    self.addDarkOverlay(BackgroupOverlayLightLevel)
  }

  func onUserCancelled (_ sender: AnyObject!) {

    // Stooopid: Have to pop back to the dashboard before showing modal VC, otherwise, 
    // we can't dismiss ZWaveRebuildLaterViewController due to issue 
    // with makeDashboardViewControllerRootViewController
    let navigationController = self.navigationController!
    _ = navigationController.popToRootViewController(animated: true)

    let zWaveToolsStoryboard = UIStoryboard(name: "ZWaveTools", bundle: nil)
    let nextViewController = zWaveToolsStoryboard
      .instantiateViewController(withIdentifier: "ZWaveRebuildLaterViewController")
    navigationController.present(nextViewController, animated: true, completion: nil)
  }

  func onUserDidNotCancel (_ sender: AnyObject!) {
    // Nothing to do
  }

}
