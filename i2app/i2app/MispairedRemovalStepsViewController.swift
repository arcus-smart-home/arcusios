//
//  MispairedRemovalStepsViewController.swift
//  i2app
//
//  Arcus Team on 4/20/18.
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

public class MispairedRemovalStepsViewController: MispairedBaseViewController {

  var steps: [FactoryResetStepModel] = []
  let presenter = MispairedPresenter()
  
  @IBOutlet weak var stepsTable: UITableView!
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    stepsTable.dataSource = self
    presenter.delegate = self
    
    presenter.remove(mispairedDev, force: false)
  }
  
  @IBAction func onCancel(_ sender: Any?) {
  }
  
  @IBAction func unwindToRemove(segue: UIStoryboardSegue) {
    self.navigationItem.title = "Remove Device"
    presenter.remove(mispairedDev, force: false)
  }

  @IBAction func unwindToForceRemove(segue: UIStoryboardSegue) {
    self.navigationItem.title = "Force Remove"
    presenter.remove(mispairedDev, force: true)
  }

}

extension MispairedRemovalStepsViewController: UITableViewDataSource {

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return steps.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "FactoryResetStepCell") as? FactoryResetStepCell {
      cell.stepNumber.image = steps[indexPath.row].numberImage()
      cell.stepText.text = steps[indexPath.row].stepText
      return cell
    }
    return UITableViewCell()
  }

}

extension MispairedRemovalStepsViewController: MispairedDelegate {

  func onShowRemovalSteps(_ steps: [FactoryResetStepModel]) {
    self.steps = steps
    self.stepsTable.reloadData()
  }
  
  func onRemoved() {
    ArcusAnalytics.tag(named: AnalyticsTags.DevicePairingRemove)
    presenter.stopPresenting()
    performSegue(withIdentifier: MispairedSegues.segueToSuccess.rawValue, sender: nil)
  }
  
  func onRemoveFailed(forced: Bool) {
    presenter.stopPresenting()
    performSegue(withIdentifier : MispairedSegues.segueToFailure.rawValue, sender: nil)
  }
  
  func onError(_ message: String) {
    DDLogError(message)
    displayGenericErrorMessage()
  }
}
