//
//  TroubleshootingTipCell.swift
//  i2app
//
//  Arcus Team on 3/12/18.
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

protocol TroubleshootingTipActionDelegate: class {
  func onTroubleshootingActionTaken(_ model: TroubleshootingTipSectionModel?)
}

class TroubleshootingTipCell: UITableViewCell {
  weak var delegate: TroubleshootingTipActionDelegate?
  var model: TroubleshootingTipSectionModel?

  @IBOutlet weak var tipNumber: UIImageView!
  @IBOutlet weak var actionLink: ScleraButton!
  @IBOutlet weak var tipText: UILabel!
  
  func bindToModel(_ model: TroubleshootingTipSectionModel, delegate: TroubleshootingTipActionDelegate) {
    self.delegate = delegate
    self.model = model
    
    tipNumber.image = self.numberImage(model.tipNumber)

    tipText.isHidden = !model.tip.isInfoAction()
    actionLink.isHidden = model.tip.isInfoAction()

    tipText.text = model.tip.message
    actionLink.setTitle(model.tip.message, for: .normal)
  }
  
  private func numberImage(_ forNumber: Int) -> UIImage? {
    return UIImage(named: "step\(forNumber)_teal_30x30")
  }
  
  @IBAction func onActionLinkTapped(_ sender: Any?) {
    delegate?.onTroubleshootingActionTaken(self.model)
  }
}
